define libamq::tempDestinationAuthorizationEntry(
  $queue,
  $target = $name,
  $write  = false,
  $read   = false,
  $admin  = false,
  $ensure = 'present',
) {
  $match   = '/beans/broker/plugins/authorizationPlugin/map/authorizationMap/tempDestinationAuthorizationEntry'
  $changes = [
    "set ${match}/tempDestinationAuthorizationEntry/#attribute/write \"${write}\"",
    "set ${match}/tempDestinationAuthorizationEntry/#attribute/read \"${read}\"",
    "set ${match}/tempDestinationAuthorizationEntry/#attribute/admin \"${admin}\"",
  ]
  case $ensure {
    'present': {
      if !$admin {
        fail 'Must set admin if ensure is set to present'
      }
      if !$write {
        fail 'Must set write if ensure is set to present'
      }
      if !$read {
        fail 'Must set read if ensure is set to present'
      }
      xmlfile_modification { "${target}: set tempDestinationAuthorizationEntry":
        changes => $changes,
        file    => $target,
        require => Xmlfile_modification [ "${target}: add authorizationEntry queue ${queue}" ],
      }
      # Implicitly sort plugins.  As of AMQ5.4 everything inside the plugins node must
      # be alphabetical.
      xmlfile_modification { "${target}: tempDestinationAuthorizationEntry sort plugins":
        changes => 'sort /beans/broker/plugins',
        file    => $target,
        require => Xmlfile_modification["${target}: set tempDestinationAuthorizationEntry" ],
      }
    }
    'absent': {
      xmlfile_modification { "${target}: remove tempDestinationAuthorizationEntry":
        changes => "rm ${match}",
        file    => $target,
        onlyif  => "match ${match} size > 0",
      }
    }
    default: {
    }
  }
}