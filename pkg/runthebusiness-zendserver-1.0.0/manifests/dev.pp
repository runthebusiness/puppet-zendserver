# Class: zendserver::dev
#
# This class installs Apache development libraries.
# Adapted from 5UbZ3r0/httpd module
#
# Parameters:
#
# Actions:
#   - Install Apache development libraries
#
# Requires:
#
# Sample Usage:
#
class zendserver::dev {
  include zendserver::params

  package{ $zendserver::params::httpd_dev:
    ensure => installed
  }
}
