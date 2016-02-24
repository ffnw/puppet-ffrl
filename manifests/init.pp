class ffrl (
  Integer       $local_as,
  String        $nat_ip,
  Array[String] $public_nets       = $ffrl::params::public_nets,
  Array[String] $public_nets_self  = $ffrl::params::public_nets_self,
  String        $bba_dus           = $ffrl::params::bba_dus,
  String        $bbb_dus           = $ffrl::params::bbb_dus,
  String        $bba_fra           = $ffrl::params::bba_fra,
  String        $bbb_fra           = $ffrl::params::bbb_fra,
  String        $bba_ber           = $ffrl::params::bba_ber,
  String        $bbb_ber           = $ffrl::params::bbb_ber,
  Array[String] $public_nets6      = $ffrl::params::public_nets6,
  Array[String] $public_nets_self6 = $ffrl::params::public_nets_self6,
  String        $bba_dus6          = $ffrl::params::bba_dus6,
  String        $bbb_dus6          = $ffrl::params::bbb_dus6,
  String        $bba_fra6          = $ffrl::params::bba_fra6,
  String        $bbb_fra6          = $ffrl::params::bbb_fra6,
  String        $bba_ber6          = $ffrl::params::bba_ber6,
  String        $bbb_ber6          = $ffrl::params::bbb_ber6,
  String        $preferred         = $ffrl::params::preferred,
) inherits ffrl::params {
  ($nat_ip
   + $public_nets
   + $public_nets_self
   + $public_nets6
   + $public_nets_self6).each | $value | {
    validate_ip_address($value)
  }

  require router

  contain ffrl::tunnel
  contain ffrl::routing

  class { '::bird::tunnel': }
  class { '::bird::routing': }

}

