# zendserver::additional
#
# Installs additional and related packages
#
# Parameters:
#  - phpversion: the version of php to get zendserver for (Default: 5.3)
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


# Sample Usage:
#  ::zendserver::additional{"zendserveradditionalinstall":
#  }
#
define zendserver::additional (
	$phpversion="5.3",
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
) {

	# install or remove related packages
	package {"php-${phpversion}-extra-extensions-zend-server":
       ensure => $extra_extensions_zend_server
	}

	package {"php-${phpversion}-java-bridge-zend-server":
       ensure => $java_bridge_zend_server
	}

	package {"php-${phpversion}-loader-zend-server":
       ensure => $loader_zend_server
	}

	package {"phpmyadmin-zend-server":
       ensure => $phpmyadmin_zend_server
	}

	package {"zend-server-framework-dojo":
       ensure => $zend_server_framework_dojo
	}

	package {"zend-server-framework-extras":
       ensure => $zend_server_framework_extras
	}

	package {"php-${phpversion}-source-zend-server":
       ensure => $source_zend_server
	}

	package {"control-panel-zend-server":
       ensure => $control_panel_zend_server
	}

	package {"php-${phpversion}-ibmdb2-zend-server":
       ensure => $ibmdb2_zend_server
	}

	package {"php-${phpversion}-pdo-ibm-zendserver":
       ensure => $pdo_ibm_zendserver
	}

}
