# Class: zendserver::php
#
# This class installs PHP for Apache zend server.
# Adapted from 5UbZ3r0/httpd module. Untested as it seems unnecessary
#
# Parameters:
#  - phpversion: the version of php to get zendserver for (Default: 5.3)
#
# Actions:
#   - Install Apache PHP package
#
# Requires:
#
# Sample Usage:
#
class zendserver::php (
	$phpversion="5.3"
) {
  include zendserver::params

  package {"zendserverphppackage":
  	name=>"libapache2-mod-php-${phpversion}-zend-server",
    ensure => present
  }

  file {"zendserverphpini":
  	path=>"/usr/local/zend/etc/php.ini",
    ensure  => file,
    content => template("zendserver/php.ini.Debian.erb"),
    require => Package ["zendserverphppackage"],
    notify  => Service['httpd']
  }
}
