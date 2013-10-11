# ### libamq::authorizationEntry::queue
# ----------------
# Creates or modifies an ActiveMQ authorizationPlugin entry for a specified queue.
# 
# Queue supports AMQ wildcard syntax
# - . is used to separate names in a path
# - * is used to match any name in a path
# - > is used to recursively match any destination starting from this name
#
# #### Arguments
#
# target
# : the xmlfile resource this entry should be placed in
#
# queue
# : the queue this entry applies to.
# 
# read
# : What groups or users can can browse and consume from the destination.  Required if ensure is set to present.
#
# write
# : What groups or users can send messages to the destination.  Required if ensure is set to present.
#
# admin
# : What groups or users have full permissions.  Required if ensure is set to present.
#
# ensure
# : present or absent.  Defaults to present.
# ----------------
define libamq::authorizationEntry::queue(
  $target,
  $queue,
  $write  = false,
  $read   = false,
  $admin  = false,
  $ensure = 'present',
) {
  $match   = "/beans/broker/plugins/authorizationPlugin/map/authorizationMap/authorizationEntries/authorizationEntry[#attribute/queue == \"${queue}\"]"
  $changes = "set /beans/broker/plugins/authorizationPlugin/map/authorizationMap/authorizationEntries/authorizationEntry[last()+1]/#attribute/queue \"${queue}\""
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
      xmlfile_modification { "${target}: add authorizationEntry queue ${queue}":
        file    => $target,
        changes => $changes,
        onlyif  => "match ${match} size < 1",
      }
      xmlfile_modification { "${target}: set authorizationEntry queue ${queue} write":
        changes => "set ${match}/#attribute/write \"${write}\"",
        onlyif  => "get ${match}/#attribute/write != \"${write}\"",
        file    => $target,
        require => Xmlfile_modification [ "${target}: add authorizationEntry queue ${queue}" ],
      }
      xmlfile_modification { "${target}: set authorizationEntry queue ${queue} read":
        changes => "set ${match}/#attribute/read \"${read}\"",
        onlyif  => "get ${match}/#attribute/read != \"${read}\"",
        file    => $target,
        require => Xmlfile_modification [ "${target}: add authorizationEntry queue ${queue}" ],
      }
      xmlfile_modification { "${target}: set authorizationEntry queue ${queue} admin":
        changes => "set ${match}/#attribute/admin \"${admin}\"",
        onlyif  => "get ${match}/#attribute/admin != \"${admin}\"",
        file    => $target,
        require => Xmlfile_modification [ "${target}: add authorizationEntry queue ${queue}" ],
      }
      # Implicitly sort plugins.  As of AMQ5.4 everything inside the plugins node must
      # be alphabetical.
      xmlfile_modification { "${target}: authorizationEntry queue ${queue} sort plugins":
        changes => 'sort /beans/broker/plugins',
        file    => $target,
        require => Xmlfile_modification[
          "${target}: set authorizationEntry queue ${queue} admin",
          "${target}: set authorizationEntry queue ${queue} read",
          "${target}: set authorizationEntry queue ${queue} write",
          "${target}: add authorizationEntry queue ${queue}"
        ],
      }
    }
    'absent': {
      xmlfile_modification { "${target}: remove authorizationEntry queue ${queue}":
        file    => $target,
        changes => "rm ${match}",
        onlyif  => "match ${match} size > 0",
      }
    }
    default: {
      fail "Invalid value for ensure ${ensure}"
    }
  }
}

# ### libamq::authorizationEntry::topic
# ----------------
# Creates or modifies an ActiveMQ authorizationPlugin entry for a specified topic.
# 
# Topic supports AMQ wildcard syntax
# - . is used to separate names in a path
# - * is used to match any name in a path
# - > is used to recursively match any destination starting from this name
#
# #### Arguments
#
# target
# : the xmlfile resource this entry should be placed in.  Required.
#
# topic
# : the queue this entry applies to.  Required.
# 
# read
# : What groups or users can can browse and consume from the destination.  Required if ensure is set to present.
#
# write
# : What groups or users can send messages to the destination.  Required if ensure is set to present.
#
# admin
# : What groups or users have full permissions.  Required if ensure is set to present.
#
# ensure
# : present or absent.  Defaults to present.
# ----------------
define libamq::authorizationEntry::topic(
  $target,
  $topic,
  $write  = false,
  $read   = false,
  $admin  = false,
  $ensure = 'present',
) {
  $match   = "/beans/broker/plugins/authorizationPlugin/map/authorizationMap/authorizationEntries/authorizationEntry[#attribute/topic == \"${topic}\"]"
  $changes = "set /beans/broker/plugins/authorizationPlugin/map/authorizationMap/authorizationEntries/authorizationEntry[last()+1]/#attribute/topic \"${topic}\""
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
      xmlfile_modification { "${target}: add authorizationEntry topic ${topic}":
        file    => $target,
        changes => $changes,
        onlyif  => "match ${match} size < 1",
      }
      xmlfile_modification { "${target}: set authorizationEntry topic ${topic} write":
        changes => "set ${match}/#attribute/write \"${write}\"",
        onlyif  => "get ${match}/#attribute/write != \"${write}\"",
        file    => $target,
        require => Xmlfile_modification [ "${target}: add authorizationEntry topic ${topic}" ],
      }
      xmlfile_modification { "${target}: set authorizationEntry topic ${topic} read":
        changes => "set ${match}/#attribute/read \"${read}\"",
        onlyif  => "get ${match}/#attribute/read != \"${read}\"",
        file    => $target,
        require => Xmlfile_modification [ "${target}: add authorizationEntry topic ${topic}" ],
      }
      xmlfile_modification { "${target}: set authorizationEntry topic ${topic} admin":
        changes => "set ${match}/#attribute/admin \"${admin}\"",
        onlyif  => "get ${match}/#attribute/admin != \"${admin}\"",
        file    => $target,
        require => Xmlfile_modification [ "${target}: add authorizationEntry topic ${topic}" ],
      }
      # Implicitly sort plugins.  As of AMQ5.4 everything inside the plugin node must
      # be alphabetical.
      xmlfile_modification { "${target}: authorizationEntry topic ${topic} sort plugins":
        changes => 'sort /beans/broker/plugins',
        file    => $target,
        require => Xmlfile_modification[
          "${target}: set authorizationEntry topic ${topic} admin",
          "${target}: set authorizationEntry topic ${topic} read",
          "${target}: set authorizationEntry topic ${topic} write",
          "${target}: add authorizationEntry topic ${topic}"
        ],
      }
    }
    'absent': {
      xmlfile_modification { "${target}: remove authorizationEntry topic ${topic}":
        file    => $target,
        changes => "rm ${match}",
        onlyif  => "match ${match} size > 0",
      }
    }
    default: {
      fail "Invalid value for ensure ${ensure}"
    }
  }
}

# ### libamq::authorizationEntry
# ----------------
# Creates or modifies an ActiveMQ authorizationPlugin entry, creating both a queue and a topic
# 
# Queue and topic support AMQ wildcard syntax
# - . is used to separate names in a path
# - * is used to match any name in a path
# - > is used to recursively match any destination starting from this name
#
# #### Arguments
#
# target
# : the xmlfile resource this entry should be placed in
#
# queue
# : the queue this entry applies to.  Will be set to topic if none specified.
# 
# topic
# : the topic this entry applies to.  Will be set to queue if none specified.
# 
# read
# : What groups or users can can browse and consume from the destination.  Required if ensure is set to present.
#
# write
# : What groups or users can send messages to the destination.  Required if ensure is set to present.
#
# admin
# : What groups or users have full permissions.  Required if ensure is set to present.
#
# ensure
# : present or absent.  Defaults to present.
# ----------------
define libamq::authorizationEntry(
  $target,
  $queue  = nil,
  $topic  = nil,
  $write  = false,
  $read   = false,
  $admin  = false,
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