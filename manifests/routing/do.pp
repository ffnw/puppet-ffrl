define ffrl::routing::do (
  Optional[String] $transfer_net  = undef,
  Optional[String] $transfer_net6 = undef,
  Boolean          $preferred     = false,
) {

  if( is_ip_address($transfer_net) ) {

    $source   = ip_address(ip_network($transfer_net, 1))
    $neighbor = ip_address(ip_network($transfer_net, 0))

    file {
      "/etc/bird/bird.conf.d/ffrl/${title}.conf":
        ensure  => file,
        mode    => "0644",
        content => epp("ffrl/peer.epp"),
        notify  => File['/etc/bird/bird.conf.d/ffrl.conf'];
    }

  }

  if( is_ip_address($transfer_net6) ) {

    $source   = ip_address(ip_network($transfer_net6, 2))
    $neighbor = ip_address(ip_network($transfer_net6, 1))

    file {
      "/etc/bird/bird.conf.d/ffrl/${title}.conf":
        ensure  => file,
        mode    => "0644",
        content => epp("ffrl/peer.epp"),
        notify  => File['/etc/bird/bird6.conf.d/ffrl.conf'];
    }

  }

}
