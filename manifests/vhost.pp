# Definition: zendserver::vhost
#
# This class installs Apache Virtual Hosts.
# Adapted from 5UbZ3r0/httpd module
#
# Parameters:
# - $content: the content of the configuration file, or
# - $source:  the source of the configuration file
# - $priority: the priority of the file (default: 00)
# - $autorestart: whether or not to automatically restart Httpd (default: true)
#
# Actions:
# - Installs Apache Virtual Hosts
#
# Requires:
# - The HTTPD class
#
#  httpd::vhost { 'site.name.fqdn':
#    priority => '20',
#    content => '
#      <virtualhost *:80>
#      ....
#      </virtualhost>
#    ',
#  }
#

define zendserver::vhost(
  $content = undef,
  $priority = '00',
  $source = undef,
  $autorestart = true,
){

  include zendserver::params
  if $autorestart == true {
	  file { "${zendserver::params::vdir}/${priority}-${name}.conf":
	    ensure  => file,
	    content => $content,
	    source  => $source,
	    owner   => 'root',
	    group   => 'root',
	    mode    => '0644',
	    notify  => Service['httpd']
	  }
	  
	} else {
	  file { "${zendserver::params::vdir}/${priority}-${name}.conf":
      ensure  => file,
      content => $content,
      source  => $source,
      owner   => 'root',
      group   => 'root',
      mode    => '0644'
    }
	}
}
