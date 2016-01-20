define ffrl::tunnel::do (
  String $remote_public_ip,
  String $transfer_net,
  String $transfer_net6,
  String $nat_ip,
) {

  validate_ip_address($remote_public_ip)
  validate_ip_address($transfer_net)
  validate_ip_address($transfer_net6)
  validate_ip_address($nat_ip)

  $pre_up    = [ '/sbin/ip rule add pref 31000 iif $IFACE table 42',
                 '/sbin/ip rule add pref 31001 iif $IFACE unreachable',
                 '/sbin/iptables -t nat -A POSTROUTING'
                 + ' ! -s ' + ip_network($transfer_net) + ' -o $IFACE'
                 + ' -j SNAT --to-source ' + ip_address($nat_ip) ]
  $post_up   = [ '/sbin/sysctl -w net.ipv4.conf.$IFACE.rp_filter=0' ]
  $pre_down  = [  ]
  $post_down = [ '/sbin/ip rule del pref 31000 iif $IFACE table 42',
                 '/sbin/ip rule del pref 31001 iif $IFACE unreachable',
                 '/sbin/iptables -t nat -D POSTROUTING'
                 + ' ! -s ' + ip_network($transfer_net) + ' -o $IFACE'
                 + ' -j SNAT --to-source ' + ip_address($nat_ip) ]

  if( is_ip_address($transfer_net) ) {
    gre::tunnel ( 'ffrl-' + $title:
      remote_public_ip => ip_address($remote_public_ip),
      local_ip         => ip_network($transfer_net, 1),
      remote_ip        => ip_network($transfer_net, 0),
      local_ip6        => ip_network($transfer_net6, 2),
    )
  }

}
