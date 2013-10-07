# Generic wrapper to augeas modification of activemq.xml file
define libamq::transportConnector( $uri_prefix = 'tcp', 
                                   $address = '0.0.0.0', 
                                   $port = '6166', 
                                   $options = nil,
                                   $target,
                                   $ensure = 'present' ) {
  if $options {
    $uri = "${uri_prefix}://${address}:${port}?${options}"
  } else {
    $uri = "${uri_prefix}://${address}:${port}"
  }
  $match = "/beans/broker/transportConnectors/transportConnector[#attribute/name = \"${name}\"]"
  $changes = [
    "set /beans/broker/transportConnectors/transportConnector[last()+1]/#attribute/name \"${type}\"",
  ]

  case $ensure {
    'present': {
      xmlfile_modification { "${target}: add transportConnector ${name}":
        changes => $changes,
        file    => $target,
        onlyif  => "match ${match} size == 0",
      } ->
      xmlfile_modification { "${target}: set transportConnector ${name} uri":
        changes => "set ${match}/#attribute/uri \"${uri}\"",
        file    => $target,
        onlyif  => "get ${match}/#attribute/uri",
      }
    }
    'absent': {
      xmlfile_modification { "${target}: remove transportConnector ${name}":
        file    => $target,
        changes => "rm ${match}",
        onlyif  => "match ${match} size == 1",
      }
    }
  }
}

# Sugar for specific connectors
define libamq::transportConnector::stomp( $address = '0.0.0.0',
                                          $port    = '6161',
                                          $options = nil,
                                          $ssl     = false,
                                          $target,
                                          $ensure  = 'present' ) {
  if $ssl {
    $uriprefix = "stomp+ssl"
  } else {
    $uriprefix = "stomp+nio"
  }
  libamq::transportConnector { $name:
    uri_prefix => $uriprefix,
    address    => $address, 
    port       => $port,
    target     => $target,
    ensure     => $ensure,
    options    => $options, 
  }
}

