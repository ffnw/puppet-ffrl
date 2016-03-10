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

    $pre_up    = [ "/sbin/iptables -t nat -A POSTROUTING ! -s ${_transfer_net} -o \$IFACE -j SNAT --to-source ${_nat_ip}",
                   "/sbin/iptables -A FORWARD -o \$IFACE -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu", ]
    $post_up   = [ "/sbin/sysctl -w net.ipv4.conf.\$IFACE.rp_filter=0" ]
    $post_down = [ "/sbin/iptables -t nat -D POSTROUTING ! -s ${_transfer_net} -o \$IFACE -j SNAT --to-source ${_nat_ip}",
                   "/sbin/iptables -D FORWARD -o \$IFACE -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu", ]

    network::inet::tunnel { "gre-ffrl-${title}":
      address   => ip_address(ip_network($transfer_net, 1)),
      netmask   => "${ip_prefixlength($transfer_net)}",
      mode      => 'gre',
      endpoint  => ip_address($remote_public_ip),
      dstaddr   => ip_address(ip_network($transfer_net, 0)),
      ttl       => 64,
      mtu       => 1400,
      pre_up    => $pre_up,
      post_up   => $post_up,
      post_down => $post_down,
    }

    if is_ip_address($transfer_net6) {
      network::inet6::static { "gre-ffrl-${title}":
        address   => ip_network($transfer_net6, 2),
      }
    }

  }

}

