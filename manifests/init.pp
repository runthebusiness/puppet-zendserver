# zendserver
#
# Installs and manages zendserver
# Adapted from 5UbZ3r0/httpd module
#
# Parameters:
#  - phpversion: the version of php to get zendserver for (Default: 5.3)
#  - ce: comunity eddition true or false (Default: true)
#  - extra_extensions_zend_server: ensure for related package (Default: latest)
#  - java_bridge_zend_server: ensure for related package (Default: latest)
#  - loader_zend_server: ensure for related package (Default: latest)
#  - phpmyadmin_zend_server: ensure for related package (Default: latest)
#  - zend_server_framework_dojo: ensure for related package (Default: latest)
#  - zend_server_framework_extras: ensure for related package (Default: latest)
#  - source_zend_server: ensure for related package (Default: latest)
#  - control_panel_zend_server: ensure for related package (Default: latest)
#  - ibmdb2_zend_server: ensure for related package (Default: absent)
#  - pdo_ibm_zendserver: ensure for related package (Default: absent)
#  - ensure: ensure for package (Default: latest))
#  - webportalpassword: password for zend web portal (Default: undef)
#  - deflate: turns On (or Off) httpd compression (Default: disabled)
#  - configphp: whether or not to configure php (Default: false)
#  - managesource: whether or not to manage its own source (Default: false)



# Sample Usage:
#  ::zendserver{"zendserverinstall":
#  }
#
define zendserver(
	$phpversion="5.3",
	$ce=true,
	$extra_extensions_zend_server="latest",
	$java_bridge_zend_server="latest",
	$loader_zend_server="latest",
	$phpmyadmin_zend_server="latest",
	$zend_server_framework_dojo="latest",
	$zend_server_framework_extras="latest",
	$source_zend_server="latest",
	$control_panel_zend_server="latest",
	$ibmdb2_zend_server="absent",
	$pdo_ibm_zendserver="absent",
	$ensure="latest",
	$webportalpassword=undef,
	$deflate = false,
	$configphp = false,
	$managesource = false,
) {

	# use params
	include zendserver::params

	# Different setups for different operating systems. Only ubuntu and debian are set up.
	case $::operatingsystem {
		'centos', 'redhat', 'fedora': {
      #TODO: fill in for other flavors
		}
		'ubuntu', 'debian': {
			# set up sources list:
			if $managesource == true {
				apt::source {"repos-zend-com_zend-server_deb_server_non-free":
					location    => 'http://repos.zend.com/zend-server/deb',
					release     => ' ',
					repos       => 'server non-free',
					key_source  => 'http://repos.zend.com/zend.key',
					include_src => false
				}
			}
		}
		default: {
      #TODO: fill in for other flavors
		}
	}

	# install core package:
	if $ce == true {
		$packagename = "zend-server-ce-php-${phpversion}"
	} else {
		$packagename = "zend-server-php-${phpversion}"
	}
	
	case $::operatingsystem {
		'centos', 'redhat', 'fedora': {
      #TODO: fill in for other flavors
		}
		'ubuntu', 'debian': {
			if $managesource == true {
				package {$packagename:
					ensure => $ensure,
					require=>Apt::Source["repos-zend-com_zend-server_deb_server_non-free"]
				}
			} else {
			  package {$packagename:
          ensure => $ensure
        }
			}
		}
		default: {
      #TODO: fill in for other flavors
		}
	}


	# install or remove related packages
	::zendserver::additional{"zendserveradditionalinstall":
		require=>package[$packagename]
	}

	# make sure the service is running
	service {'httpd':
		ensure    => running,
		name      => $zendserver::params::httpd_name,
		enable    => true,
		require=>package[$packagename]
	}

	# restart zend after additional packages are loaded
	exec {'restartzend':
		command=>"/bin/bash zendctl.sh restart",
		path => ["/usr/bin", "/usr/sbin", "/bin", "/sbin", "${zendserver::params::zendinstalldir}bin"],
		subscribe => [::Zendserver::Additional["zendserveradditionalinstall"]],
	}



	# from httpd module
	# set up the a2mod plugin -- not sure what it does
	A2mod { require => Package[$packagename], notify => Service['httpd']}
	@a2mod {
		'rewrite' : ensure => present;
		'headers' : ensure => present;
		'expires' : ensure => present;
	}

	# from httpd module
	# Install custom configurations (varies if it's debian or rhel-like)
	#
	file { $zendserver::params::config_to:
		ensure  => file,
		content => template($zendserver::params::config_from),
		notify  => Service['httpd'],
		require=>package[$packagename]
	}


	# from httpd module
	# If mod_deflate is enabled, copy the configuration
	#
	if $deflate == true {
		case $::operatingsystem {
			Debian, Ubuntu: {
				@a2mod {
					'deflate' : ensure => present;
				}
			}
			default: {
			}
		}
		file { $zendserver::params::deflateconfig_to:
			ensure => file,
			source => $zendserver::params::deflateconfig_from,
			notify => Service['httpd'],
			require=>package[$packagename]
		}
	}

	# from httpd module
	# Custom error pages
	#
	file { $zendserver::params::errdir:
		ensure  => directory,
		recurse => true,
		purge   => false,
		source  => "puppet:///${module_name}/error",
		ignore  => '\.svn',
		notify  => Service['httpd'],
		require=>package[$packagename]
	}


	if $configphp == true {
		# make sure that php is set up:
		class {'zendserver::php':
			phpversion=>$phpversion,
			require=>package[$packagename]
		}
	}

	# set the web portal password if configured to do so. Access the control panel at: http://myip:10081
	if $webportalpassword != undef {
		exec {'setwebportalpassword':
			command=>"/bin/bash zs-setup set-password '${webportalpassword}'",
			path => ["/usr/bin", "/usr/sbin", "/bin", "/sbin", "${zendserver::params::zendinstalldir}bin"],
			require=>package[$packagename]
		}
	}

  # link php to /bin
  file {"phplinktobin":
    ensure  => "link",
    path=>"/bin/php",
    target=>"${zendserver::params::zendinstalldir}/bin/php",
    require=>package[$packagename]
  }

}
