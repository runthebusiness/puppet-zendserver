# Class: zendserver::params
#
# This class manages Apache HTTP server parameters.
# Adapted from httpd module
#
# Parameters:
# - $user that Apache runs as
# - $group that Apache runs as
# - $httpd_name is the name of the package and service on the distribution
# - $config_from is the source of the httpd.conf file
# - $config_to is the destination of the httpd.conf file
# - $ssl_package is the name of the Apache SSL package
# - $sslconfig_from is the source of the ssl.conf file for mod_ssl
# - $sslconfig_to is the destination of the ssl.conf file
# - $php_package is the name of the package that provided PHP
# - $phpconf_from is the source of the php.ini file for php
# - $phpconf_to is the destination of the php.ini file
# - $httpd_dev is the name of the Apache development libraries package
# - $deflateconfig_from is the source of the deflate.conf file for mod_deflate
# - $deflateconfig_to is the destination of the deflate.conf file
#
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class zendserver::params {

  case $::operatingsystem {
    'centos', 'redhat', 'fedora': {
      #TODO: Currently these settings are from the httpd module, they need to verifying and testing for zendserver
      $user = 'apache'
      $group = 'apache'
      $httpd_name = 'httpd'
      case $::operatingsystemrelease {
        /^5\.\d*$/: {
          $php_package = 'php53'
          }
        default:{
          $php_package = 'php'
        }
      }
      $ssl_package = 'mod_ssl'
      $httpd_dev  = 'httpd-devel'
      $vdir = '/etc/httpd/conf.d'
      $errdir = '/var/www/error'
      $config_to = '/etc/httpd/conf/httpd.conf'
      $config_from = "${module_name}/httpd.conf.RHEL.erb"
      $sslconfig_to = '/etc/httpd/conf.d/ssl.conf'
      $sslconfig_from = "${module_name}/ssl.conf.RHEL.erb"
      $deflateconfig_to = '/etc/httpd/conf.d/00-deflate.conf'
      $deflateconfig_from = "puppet:///${module_name}/deflate.conf"
      $phpconfig_to = '/etc/php.ini'
      $phpconfig_from = "${module_name}/php.ini.RHEL.erb"
    }
    'ubuntu', 'debian': {
      $user = 'www-data'
      $group = 'www-data'
      $httpd_name = 'apache2'
      $php_package = 'libapache2-mod-php5'
      $ssl_package = 'apache-ssl'
      $httpd_dev  = [ 'libaprutil1-dev', 'libapr1-dev', 'apache2-prefork-dev' ]
      $vdir = '/etc/apache2/sites-enabled/'
      $errdir = '/usr/share/apache2/error/'
      $config_to = '/etc/apache2/conf.d/localized-error-pages'
      $config_from = "${module_name}/localized-error-pages.Debian.erb"
      $deflateconfig_to = '/etc/apache2/mods-available/deflate.conf'
      $deflateconfig_from = "puppet:///${module_name}/deflate.conf"
      $phpconfig_to = '/etc/php5/cli/php.ini'
      $phpconfig_from = "${module_name}/php.ini.Debian.erb"
      $zendinstalldir = "/usr/local/zend/"
    }
    default: {
      $user = 'www-data'
      $group = 'www-data'
      $httpd_name = 'apache2'
      $php_package = 'libapache2-mod-php5'
      $ssl_package = 'apache-ssl'
      $httpd_dev  = [ 'libaprutil1-dev', 'libapr1-dev', 'apache2-prefork-dev' ]
      $vdir = '/etc/apache2/sites-enabled/'
      $errdir = '/usr/share/apache2/error/'
      $config_to = '/etc/apache2/conf.d/localized-error-pages'
      $config_from = "${module_name}/localized-error-pages.Debian.erb"
      $deflateconfig_to = '/etc/apache2/mods-available/deflate.conf'
      $deflateconfig_from = "puppet:///${module_name}/deflate.conf"
      $phpconfig_to = '/etc/php5/cli/php.ini'
      $phpconfig_from = "${module_name}/php.ini.Debian.erb"
      $zendinstalldir = "/usr/local/zend/"
    }
  }
}
