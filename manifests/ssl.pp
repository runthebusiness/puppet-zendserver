# Class: zendserver::ssl
#
# This class installs Apache HTTPD SSL capabilities. Adapted from httpd
# Adapted from 5UbZ3r0/httpd module
#
# Parameters:
# - The $ssl_package name from the httpd::params class
#
# Actions:
#   - Install Apache HTTPD SSL capabilities
#
# Requires:
#
# Sample Usage:
#
# TODO: modify and test this in flavors other than debian
class zendserver::ssl {

  include zendserver::params

  case $::operatingsystem {
    'centos', 'fedora', 'redhat': {
      package { $zendserver::params::ssl_package:
        require => Package['httpd']
      }
      file { $zendserver::params::sslconfig_to:
        ensure  => file,
        content => template($zendserver::params::sslconfig_from),
        notify  => Service['httpd']
      }
    }
    'ubuntu', 'debian': {
      a2mod { 'ssl':
        ensure => present
      }
    }
    default: {
      package { $zendserver::params::ssl_package:
        require => Package['httpd']
      }
      file { $zendserver::params::sslconfig_to:
        ensure  => file,
        content => template($zendserver::params::sslconfig_from),
        notify  => Service['httpd']
      }
    }
  }
}
