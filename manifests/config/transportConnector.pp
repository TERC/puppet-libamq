# Generic wrapper to augeas modification of activemq.xml file
define libamq::transportConnector(
  $target,
  $connector_name = $name,
  $uri_prefix = 'tcp',
  $address = '0.0.0.0',
  $port = '6166',
  $options = nil,
  $ensure = 'present',
){
  if $options {
    $uri = "${uri_prefix}://${address}:${port}?${options}"
  } else {
    $uri = "${uri_prefix}://${address}:${port}"
  }
  $match = "/beans/broker/transportConnectors/transportConnector[#attribute/name = \"${connector_name}\"]"
  $changes = [
    "set /beans/broker/transportConnectors/transportConnector[last()+1]/#attribute/name \"${connector_name}\"",
  ]

  case $ensure {
    'present': {
      xmlfile_modification { "${target}: add transportConnector ${connector_name}":
        changes => $changes,
        file    => $target,
        onlyif  => "match ${match} size == 0",
      } ->
      xmlfile_modification { "${target}: set transportConnector ${connector_name} uri":
        changes => "set ${match}/#attribute/uri \"${uri}\"",
        file    => $target,
        onlyif  => "get ${match}/#attribute/uri",
      }
    }
    'absent': {
      xmlfile_modification { "${target}: remove transportConnector ${connector_name}":
        file    => $target,
        changes => "rm ${match}",
        onlyif  => "match ${match} size == 1",
      }
    }
    default: {
      fail ("Unknown value for ensure ${ensure}")
    }
  }
}

# Sugar for specific connectors
define libamq::transportConnector::stomp(
  $target,
  $connector_name = $name,
  $address = '0.0.0.0',
  $port    = '6161',
  $options = nil,
  $ssl     = false,
  $ensure  = 'present',
){
  if $ssl {
    $uriprefix = 'stomp+ssl'
  } else {
    $uriprefix = 'stomp+nio'
  }
  libamq::transportConnector { $name:
    ensure         => $ensure,
    connector_name => $connector_name,
    uri_prefix     => $uriprefix,
    address        => $address,
    port           => $port,
    target         => $target,
    options        => $options,
  }
}

