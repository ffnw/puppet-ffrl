define ffrl::tunnel::do (
  String           $remote_public_ip,
  Optional[String] $transfer_net,
  Optional[String] $transfer_net6,
  String           $nat_ip,
) {

  if is_ip_address($transfer_net) {

    validate_ip_address($remote_public_ip)
    validate_ip_address($nat_ip)

    $_transfer_net = ip_network($transfer_net)
    $_nat_ip = ip_address($nat_ip)

    $pre_up    = [ '/sbin/ip rule add pref 31000 iif $IFACE table 42',
                   '/sbin/ip rule add pref 31001 iif $IFACE unreachable',
                   '/sbin/iptables -t nat -A POSTROUTING ! -s ${_transfer_net} -o $IFACE -j SNAT --to-source ${_nat_ip}' ]
    $post_up   = [ '/sbin/sysctl -w net.ipv4.conf.$IFACE.rp_filter=0' ]
    $post_down = [ '/sbin/ip rule del pref 31000 iif $IFACE table 42',
                   '/sbin/ip rule del pref 31001 iif $IFACE unreachable',
                   '/sbin/iptables -t nat -D POSTROUTING ! -s ${_transfer_net} -o $IFACE -j SNAT --to-source ${_nat_ip}' ]

    network::inet::tunnel { "gre-ffrl-${title}":
      address   => ip_network($transfer_net, 1),
      mode      => 'gre',
      endpoint  => ip_address($remote_public_ip),
      dstaddr   => ip_network($transfer_net, 0),
      ttl       => 255,
      mtu       => 1476,
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

