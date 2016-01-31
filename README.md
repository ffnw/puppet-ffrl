# puppet-ffrl

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with ffrl](#setup)
    * [What uplink affects](#what-uplink-affects)
    * [Beginning with ffrl](#beginning-with-uplink)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module connects to the Backbone of Freifunk Rheinland e. V.

In detail it opens GRE-tunnels to every FFRL-Router which is configured and creates BIRD-config files to open BGP-sessions.

## Setup

### What ffrl affects

This module uses ffnw-gre to create tunnel-connections to FFRL-Backbone and applies configuration files to bird and bird6 using the ffnw-bird module.

### Beginning with ffrl

```puppet
class {'::ffrl':
  local_as          => YOUR_AS_NUMBER,
  public_nets       => [ 'YOUR PUBLIC IPv4-NETWORKS ROUTEABLE IN YOUR AS' ],
  public_nets_self  => [ 'YOUR PUBLIC IPv4-NETWORKS ROUTED TO THIS DEVICE' ],
  bba_dus           => 'YOUR IPv4 TRANSFER NETWORK TO ROUTER-A IN DUS',
  bbb_dus           => 'YOUR IPv4 TRANSFER NETWORK TO ROUTER-B IN DUS',
  bba_fra           => 'YOUR IPv4 TRANSFER NETWORK TO ROUTER-A IN FRA',
  bbb_fra           => 'YOUR IPv4 TRANSFER NETWORK TO ROUTER-B IN FRA',
  bba_ber           => 'YOUR IPv4 TRANSFER NETWORK TO ROUTER-A IN BER',
  bbb_ber           => 'YOUR IPv4 TRANSFER NETWORK TO ROUTER-B IN BER',
  public_nets6      => [ 'YOUR PUBLIC IPv6-NETWORKS ROUTEABLE IN YOUR AS' ],
  public_nets_self6 => [ 'YOUR PUBLIC IPv6-NETWORKS ROUTED TO THIS DEVICE' ],
  bba_dus6          => 'YOUR IPv6 TRANSFER NETWORK TO ROUTER-A IN DUS',
  bbb_dus6          => 'YOUR IPv6 TRANSFER NETWORK TO ROUTER-B IN DUS',
  bba_fra6          => 'YOUR IPv6 TRANSFER NETWORK TO ROUTER-A IN FRA',
  bbb_fra6          => 'YOUR IPv6 TRANSFER NETWORK TO ROUTER-B IN FRA',
  bba_ber6          => 'YOUR IPv6 TRANSFER NETWORK TO ROUTER-A IN BER',
  bbb_ber6          => 'YOUR IPv6 TRANSFER NETWORK TO ROUTER-B IN BER',
  preferred         => 'YOUR PREFERRED ROUTER LOCATION',
}
```

## Usage

Please have a look at [Beginning with ffrl](#beginning-with-uplink). Every parameter except for „local\_as“ is optional. You should really apply your public networks. If there is no transfer network to a router, there will be no peering.

## Reference

* class ffrl
  * local\_as
  * public\_nets (optional, default [])
  * public\_nets\_self (optional, default [])
  * bba\_dus (optional, default undef)
  * bbb\_dus (optional, default undef)
  * bba\_fra (optional, default undef)
  * bbb\_fra (optional, default undef)
  * bba\_ber (optional, default undef)
  * bbb\_ber (optional, default undef)
  * public\_nets6 (optional, default [])
  * public\_nets\_self6 (optional, default [])
  * bba\_dus6 (optional, default undef)
  * bbb\_dus6 (optional, default undef)
  * bba\_fra6 (optional, default undef)
  * bbb\_fra6 (optional, default undef)
  * bba\_ber6 (optional, default undef)
  * bbb\_ber6 (optional, default undef)
  * preferred (optional, default undef, possible values: dus, fra, ber)

## Limitations

### OS compatibility
* Debian 8

### Dependencies
* ffnw-network
* ffnw-bird

## Development

### How to contribute
Fork the project, work on it and submit pull requests, please.

