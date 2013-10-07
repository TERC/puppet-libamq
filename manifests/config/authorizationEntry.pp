# A message queue
define libamq::authorizationEntry::queue(
  $target,
  $queue,
  $write  = nil,
  $read   = nil,
  $admin  = nil,
  $ensure = 'present',
) {
  $match   = "/beans/broker/plugins/authorizationPlugin/map/authorizationEntries/authorizationEntry[#attribute/queue == \"${queue}\"]"
  $changes = "set /beans/broker/plugins/authorizationPlugin/map/authorizationEntries/authorizationEntry[last()+1]/#attribute/queue \"${queue}\""
  case $ensure {
    'present': {
      xmlfile_modification { "${target}: add authorizationEntry queue ${queue}":
        file    => $target,

      }
      if $write {
        xmlfile_modification { "${target}: set authorizationEntry queue ${queue} write":
          file    => $target,
          require => Xmlfile_modification [ "${target}: add authorizationEntry queue ${queue}" ],
        }
      }
      if $read {
        xmlfile_modification { "${target}: set authorizationEntry queue ${queue} read":
          file    => $target,
          require => Xmlfile_modification [ "${target}: add authorizationEntry queue ${queue}" ],
        }
      }
      if $admin {
        xmlfile_modification { "${target}: set authorizationEntry queue ${queue} admin":
          file    => $target,
          require => Xmlfile_modification [ "${target}: add authorizationEntry queue ${queue}" ],
        }
      }
    }
    'absent': {
      xmlfile_modification { "${target}: remove authorizationEntry queue ${queue}":
        file    => $target,
      }
    }
    default: {
      fail "Invalid value for ensure ${ensure}"
    }
  }
}

# A message topic
define libamq::authorizationEntry::topic(
  $target,
  $topic,
  $write  = nil,
  $read   = nil,
  $admin  = nil,
  $ensure = 'present',
) {
  $match   = "/beans/broker/plugins/authorizationPlugin/map/authorizationEntries/authorizationEntry[#attribute/topic == \"${topic}\"]"
  $changes = "set /beans/broker/plugins/authorizationPlugin/map/authorizationEntries/authorizationEntry[last()+1]/#attribute/topic \"${topic}\""
  case $ensure {
    'present': {
      xmlfile_modification { "${target}: add authorizationEntry topic ${topic}":
        file    => $target,
      }
      if $write {
        xmlfile_modification { "${target}: set authorizationEntry topic ${topic} write":
          file    => $target,
          require => Xmlfile_modification [ "${target}: add authorizationEntry topic ${topic}" ],
        }
      }
      if $read {
        xmlfile_modification { "${target}: set authorizationEntry topic ${topic} read":
          file    => $target,
          require => Xmlfile_modification [ "${target}: add authorizationEntry topic ${topic}" ],
        }
      }
      if $admin {
        xmlfile_modification { "${target}: set authorizationEntry topic ${topic} admin":
          file    => $target,
          require => Xmlfile_modification [ "${target}: add authorizationEntry topic ${topic}" ],
        }
      }
    }
    'absent': {
      xmlfile_modification { "${target}: remove authorizationEntry topic ${topic}":
        file    => $target,
      }
    }
    default: {
      fail "Invalid value for ensure ${ensure}"
    }
  }
}

# Generally the queue is the same as the topic, so we provide this sugar definition
define libamq::authorizationEntry(
  $target,
  $queue  = nil,
  $topic  = nil,
  $write  = nil,
  $read   = nil,
  $admin  = nil,
  $ensure = 'present',
) {
  if $topic {
    if !$queue {
      $queue = $topic
    }
  } elsif $queue {
    if !$topic {
      $topic = $queue
    }
  } else {
    fail 'Must set topic or queue'
  }
  libamq::authorizationEntry::queue { $name:
    ensure => $ensure,
    queue  => $queue,
    admin  => $admin,
    write  => $write,
    read   => $read,
    target => $target,
  }
  libamq::authorizationEntry::topic { $name:
    ensure => $ensure,
    topic  => $queue,
    admin  => $admin,
    write  => $write,
    read   => $read,
    target => $target,
  }
}