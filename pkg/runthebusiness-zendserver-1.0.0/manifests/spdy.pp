# Class: zendserver::spdy
#
# This class installs the google's mod_spdy for Apache HTTPD.
# Adapted from 5UbZ3r0/httpd module
# 
# Parameters:
#   - enabled = switch that activates/deactivates mod_spdy
#
# Actions:
#   - Install Google's mod_spdy for Apache httpd
#
# Requires:
#   - a valid ssl module configuration
#   - an internet connection (spdy beta auto updates itself)
#
# Sample Usage:
#   zendserver::spdy {
#     enabled => true
#   }
#
# TODO: make php and spdy work together
# TODO: don't install SPDY on RHEL 5.x!
# TODO: modify and test this for zendserver module -- currently this code is just a hold over from 5UbZ3r0/httpd
class zendserver::spdy(
  $enabled = false
) {

  include zendserver::params

  case $::operatingsystem {
    'centos', 'fedora', 'redhat': {
      file { '/usr/src/mod_spdy':
        ensure => directory,
        owner  => root,
        group  => root,
        mode   => '0755',
      }
      file { "/usr/src/mod_spdy/mod-spdy_beta_current_${::architecture}.rpm":
        ensure  => file,
        source  => "puppet:///modules/${httpd::module_name}/spdy/mod-spdy-beta_current_${::architecture}.rpm"
      }
      package { 'mod-spdy-beta':
        ensure   => present,
        provider => rpm,
        source   => "/usr/src/mod_spdy/mod-spdy-beta_current_${::architecture}.rpm"
      }
    }
    'ubuntu', 'debian': {
      file { '/usr/src/mod_spdy':
        ensure => directory,
        owner  => root,
        group  => root,
        mode   => '0755'
      }
      file { "/usr/src/mod_spdy/mod-spdy_beta_current_${::architecture}.deb":
        ensure  => file,
        source  => "puppet:///modules/${httpd::module_name}/spdy/mod-spdy-beta_current_${::architecture}.deb"
      }
      package { 'mod-spdy-beta':
        ensure   => present,
        provider => deb,
        source   => "/usr/src/mod_spdy/mod-spdy-beta_current_${::architecture}.deb"
      }
    }
    default: {
      notify { "${module_name} unsupported":
        message => "The ${module_name} module is not supported on this OS."
      }
    }
  }
}
