class ffrl (
  Integer          $local_as,
  String           $nat_ip,
  Array[String]    $public_nets       = $ffrl::params::public_nets,
  Array[String]    $public_nets_self  = $ffrl::params::public_nets_self,
  Optional[String] $bba_dus           = $ffrl::params::bba_dus,
  Optional[String] $bbb_dus           = $ffrl::params::bbb_dus,
  Optional[String] $bba_fra           = $ffrl::params::bba_fra,
  Optional[String] $bbb_fra           = $ffrl::params::bbb_fra,
  Optional[String] $bba_ber           = $ffrl::params::bba_ber,
  Optional[String] $bbb_ber           = $ffrl::params::bbb_ber,
  Array[String]    $public_nets6      = $ffrl::params::public_nets6,
  Array[String]    $public_nets_self6 = $ffrl::params::public_nets_self6,
  Optional[String] $bba_dus6          = $ffrl::params::bba_dus6,
  Optional[String] $bbb_dus6          = $ffrl::params::bbb_dus6,
  Optional[String] $bba_fra6          = $ffrl::params::bba_fra6,
  Optional[String] $bbb_fra6          = $ffrl::params::bbb_fra6,
  Optional[String] $bba_ber6          = $ffrl::params::bba_ber6,
  Optional[String] $bbb_ber6          = $ffrl::params::bbb_ber6,
  String           $preferred         = $ffrl::params::preferred,
) inherits ffrl::params {
  ([ $nat_ip ]
   + $public_nets
   + $public_nets_self
   + $public_nets6
   + $public_nets_self6).each | $value | {
    validate_ip_address($value)
  }

  require router

  class { 'ffrl::tunnel': }
  class { 'ffrl::routing': }

  contain ffrl::tunnel
  contain ffrl::routing

}

