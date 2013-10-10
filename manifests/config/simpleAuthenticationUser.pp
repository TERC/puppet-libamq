# Create a simpleAuth user
# TODO: Pull in AMQ config documentation and translate it to human!
define libamq::simpleAuthenticationUser(
  $target,
  $username = $name,
  $password = false,
  $groups   = false,
  $ensure   = 'present',
) {
  $match     = "/beans/broker/plugins/simpleAuthenticationPlugin/users/authenticationUser[#attribute/username = \"${username}\"]"
  $changes   = "set /beans/broker/plugins/simpleAuthenticationPlugin/users/authenticationUser[last()+1]/#attribute/username \"${username}\""

  case $ensure {
    'present': {
      if !$groups {
        fail 'Must set groups if ensure is set to present'
      }
      if !$password {
        fail 'Must set password if ensure is set to present'
      }
      xmlfile_modification { "${target}: add simpleAuthenticationUser ${username}":
        changes => $changes,
        file    => $target,
        onlyif  => "match ${match} size < 1",
      }
      xmlfile_modification { "${target}: set simpleAuthenticationUser ${username} groups":
        changes => "set ${match}/#attribute/groups \"${groups}\"",
        file    => $target,
        onlyif  => "get ${match}/#attribute/groups != \"${groups}\"",
        require => Xmlfile_modification[ "${target}: add simpleAuthenticationUser ${username}" ],
      }
      xmlfile_modification { "${target}: set simpleAuthenticationUser ${username} password":
        changes => "set ${match}/#attribute/password \"${password}\"",
        file    => $target,
        onlyif  => "get ${match}/#attribute/password != \"${password}\"",
        require => Xmlfile_modification[ "${target}: add simpleAuthenticationUser ${username}" ],
      }
      # AMQ as of 5.4 needs to have plugins contained within the broker stanza sorted alphabetically
      # so we just implicitly sort the stanza after any modification to it.
      xmlfile_modification { "${target}: simpleAuthenticationUser ${username} sort plugins":
        changes => 'sort /beans/broker/plugins',
        file    => $target,
        require => Xmlfile_modification[
          "${target}: set simpleAuthenticationUser ${username} password",
          "${target}: set simpleAuthenticationUser ${username} groups",
          "${target}: add simpleAuthenticationUser ${username}" ],
      }
    }
    'absent': {
      xmlfile_modification { "${target}: remove simpleAuthenticationUser ${username}":
        changes => "rm ${match}",
        file    => $target,
        onlyif  => "match ${match} size > 0",
      }
    }
    default: {
      fail "Invalid value for ensure ${ensure}"
    }
  }
}
