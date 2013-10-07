define libamq::simpleAuthenticationUser( $username = $name,
                                         $password = nil,
                                         $groups   = nil,
                                         $ensure   = 'present',
                                         $target ) {
                                 
  $match     = "/beans/broker/plugins/simpleAuthenticationPlugin/users/authenticationUser[#attribute/username = \"${username}\"]"
  $changes   = "set /beans/broker/plugins/simpleAuthenticationPlugin/users/authenticationUser[last()+1]/#attribute/username \"${username}\""
  
  case $ensure {
    'present': {
      # Create the user if it doesn't exist
      xmlfile_modification { "${target}: add simpleAuthenticationUser ${username}":
        changes => $changes,
        file    => $target,
        onlyif  => "match ${match} size == 0",
      }
      # Fixup groups
      if $groups {
        xmlfile_modification { "${target}: set simpleAuthenticationUser ${username} groups":
          changes => "set ${match}/#attribute/groups \"${groups}\"",
          file    => $target,
          onlyif  => "get ${match}/#attribute/groups != \"${groups}\"",
          require => Xmlfile_modification[ "${target}: add simpleAuthenticationUser ${username}" ],
        }
      }
      # Fixup password
      if $password {
        xmlfile_modification { "${target}: set simpleAuthenticationUser ${username} password":
          changes => "set ${match}/#attribute/password \"${password}\"",
          file    => $target,
          onlyif => "get ${match}/#attribute/password != \"${password}\"",
          require => Xmlfile_modification[ "${target}: add simpleAuthenticationUser ${username}" ],
        }
      }
    }
    'absent': {
      xmlfile_modification { "${target}: remove simpleAuthenticationUser ${username}":
        changes => "rm ${match}",
        file    => $target,
        onlyif  => "match ${match} size == 1",
      }
    }
  }
}
