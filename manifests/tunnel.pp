class ffrl::tunnel inherits ffrl {

  require '::network'

  network::inet::loopback::post_up { 'ffrl NAT-IP':
    cmd => "/bin/ip addr add ${nat_ip} dev \$IFACE",
  }

  ffrl::tunnel::do('dus-a':
    remote_public_ip => '185.66.193.0',
    transfer_net => $bba_dus,
    transfer_net6 => $bba_dus6,
    nat_ip => $nat_ip,
  )

  ffrl::tunnel::do('dus-b':
    remote_public_ip => '185.66.193.1',
    transfer_net => $bbb_dus,
    transfer_net6 => $bbb_dus6,
    nat_ip => $nat_ip,
  )

  ffrl::tunnel::do('fra-a':
    remote_public_ip => '185.66.194.0',
    transfer_net => $bba_fra,
    transfer_net6 => $bba_fra6,
    nat_ip => $nat_ip,
  )

  ffrl::tunnel::do('fra-b':
    remote_public_ip => '185.66.194.1',
    transfer_net => $bbb_fra,
    transfer_net6 => $bbb_fra6,
    nat_ip => $nat_ip,
  )

  ffrl::tunnel::do('ber-a':
    remote_public_ip => '185.66.195.0',
    transfer_net => $bba_ber,
    transfer_net6 => $bba_ber6,
    nat_ip => $nat_ip,
  )

  ffrl::tunnel::do('ber-b':
    remote_public_ip => '185.66.195.1',
    transfer_net => $bbb_ber,
    transfer_net6 => $bbb_ber6,
    nat_ip => $nat_ip,
  )

  create_resources('ffrl::tunnel::do', hiera('ffrl::tunnel::do', {}))

}

