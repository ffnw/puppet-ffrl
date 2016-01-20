class ffrl::routing inherits ffrl {

  require '::bird'

  file {
    '/etc/bird/bird.conf.d/ffrl/':
      ensure => directory,
      mode   => "0755",
      owner  => root,
      group  => root;
    '/etc/bird/bird.conf.d/ffrl.conf':
      ensure  => file,
      mode    => "0644",
      content => epp("ffrl/bird.epp"),
      notify  => File['/etc/bird/bird.conf'];
  }

  file {
    '/etc/bird/bird6.conf.d/ffrl/':
      ensure => directory,
      mode   => "0755",
      owner  => root,
      group  => root;
    '/etc/bird/bird6.conf.d/ffrl.conf':
      ensure  => file,
      mode    => "0644",
      content => epp("ffrl/bird6.epp"),
      notify  => File['/etc/bird/bird6.conf'];
  }

  ffrl::routing::do('dus-a':
    transfer_net  => $bba_dus,
    transfer_net6 => $bba_dus6,
    preferred     => ($preferred == 'dus'),
  )

  ffrl::routing::do('dus-b':
    transfer_net  => $bbb_dus,
    transfer_net6 => $bbb_dus6,
    preferred     => ($preferred == 'dus'),
  )

  ffrl::routing::do('fra-a':
    transfer_net  => $bba_fra,
    transfer_net6 => $bba_fra6,
    preferred     => ($preferred == 'fra'),
  )

  ffrl::routing::do('fra-b':
    transfer_net  => $bbb_fra,
    transfer_net6 => $bbb_fra6,
    preferred     => ($preferred == 'fra'),
  )

  ffrl::routing::do('ber-a':
    transfer_net  => $bba_ber,
    transfer_net6 => $bba_ber6,
    preferred     => ($preferred == 'ber'),
  )

  ffrl::routing::do('ber-b':
    transfer_net  => $bbb_ber,
    transfer_net6 => $bbb_ber6,
    preferred     => ($preferred == 'ber'),
  )

}
