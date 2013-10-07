# Create a simpleAuth user
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
        fail 'Must define groups if a user may be added'
      }
      if !$password {
        fail 'Must set password if a user may be added'
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
