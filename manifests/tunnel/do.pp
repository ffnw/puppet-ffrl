define ffrl::tunnel::do (
  String           $remote_public_ip,
  Optional[String] $transfer_net,
  Optional[String] $transfer_net6,
  String           $nat_ip,
) {

  include ffrl::tunnel

  if is_ip_address($transfer_net) {

    validate_ip_address($remote_public_ip)
    validate_ip_address($nat_ip)

    $_transfer_net = ip_network($transfer_net)
    $_nat_ip = ip_address($nat_ip)

    $kernel_table = $ffrl::kernel_table
    if ($kernel_table) {
      $ip4_rule_up   = [ "/bin/ip -4 rule add pref 31000 iif \$IFACE table ${kernel_table}",
                         "/bin/ip -4 rule add pref 31001 iif \$IFACE unreachable", ]
      $ip6_rule_up   = [ "/bin/ip -6 rule add pref 31000 iif \$IFACE table ${kernel_table}",
                         "/bin/ip -6 rule add pref 31001 iif \$IFACE unreachable", ]
      $ip4_rule_down = [ "/bin/ip -4 rule del pref 31000 iif \$IFACE table ${kernel_table}",
                         "/bin/ip -4 rule del pref 31001 iif \$IFACE unreachable", ]
      $ip6_rule_down = [ "/bin/ip -6 rule del pref 31000 iif \$IFACE table ${kernel_table}",
                         "/bin/ip -6 rule del pref 31001 iif \$IFACE unreachable", ]
    } else {
      $ip4_rule_up   = []
      $ip6_rule_up   = []
      $ip4_rule_down = []
      $ip6_rule_down = []
    }

    $pre_up    = [ "/sbin/iptables -t nat -A POSTROUTING ! -s ${_transfer_net} -o \$IFACE -j SNAT --to-source ${_nat_ip}",
                   "/sbin/iptables -A FORWARD -o \$IFACE -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu", ] + $ip4_rule_up
    $post_up   = [ "/sbin/sysctl -w net.ipv4.conf.\$IFACE.rp_filter=0" ]
    $post_down = [ "/sbin/iptables -t nat -D POSTROUTING ! -s ${_transfer_net} -o \$IFACE -j SNAT --to-source ${_nat_ip}",
                   "/sbin/iptables -D FORWARD -o \$IFACE -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu", ] + $ip4_rule_down

    network::inet::tunnel { "gre-ffrl-${title}":
      address   => ip_address(ip_network($transfer_net, 1)),
      mode      => 'gre',
      endpoint  => ip_address($remote_public_ip),
      dstaddr   => ip_address(ip_network($transfer_net, 0)),
      ttl       => 255,
      mtu       => 1476,
      pre_up    => $pre_up,
      post_up   => $post_up,
      post_down => $post_down,
    }

    if is_ip_address($transfer_net6) {
      network::inet6::static { "gre-ffrl-${title}":
        address   => ip_network($transfer_net6, 2),
        pre_up    => $ip6_rule_up,
        post_down => $ip6_rule_down,  
      }
    }

  }

}

