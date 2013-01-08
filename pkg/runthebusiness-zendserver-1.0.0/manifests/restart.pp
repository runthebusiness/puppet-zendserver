# Class: zendserver::restart
#
# runs the restart command. Some times it is nice to be able to trigger this with in our manifests
#
# Parameters:

# Sample Usage:
#  ::zendserver::restart{"zendservertriggerrestart":
#  }
#
define zendserver::restart(

) {

	# use params
	include zendserver::params

	# restart zend after additional packages are loaded
	exec {'${name}_restartzend':
		command=>"/bin/bash zendctl.sh restart",
		path => ["/usr/bin", "/usr/sbin", "/bin", "/sbin", "${zendserver::params::zendinstalldir}bin"],
	}


}
