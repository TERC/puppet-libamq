#<persistenceAdapter>
#
#<amqPersistenceAdapter directory="${activemq.base}/activemq-data" maxFileLength="32mb"/>
#
#<memoryPersistenceAdapter/>
#
# Requires > 5.8
#<replicatedLevelDB
#      directory="activemq-data"
#      replicas="3"
#      bind="tcp://0.0.0.0:0"
#      zkAddress="zoo1.example.org:2181,zoo2.example.org:2181,zoo3.example.org:2181"
#      zkPassword="password"
#      zkPath="/activemq/leveldb-stores"
#      />
# Requires > 5.8
#<levelDB directory="activemq-data"/>
#
#<kahaDB directory="${activemq.data}/kahadb"/>
#</persistenceAdapter>

define libamq::persistenceAdapter($target,
                                  $ensure            = 'present',
                                  $type              = 'memory',
                                  $directory         = nil,    
                                  $use_nio           = true,
                                  $sync_on_write     = false,
                                  $max_file_length   = '32mb',
                                  $persistent_index  = true,
                                  $max_checkpoint_message_add_size = '4kb',
                                  $cleanup_interval  = '30000',
                                  $index_bin_size    = '1024',
                                  $index_key_size    = '96',
                                  $index_page_size   = '16kb',
                                  $directory_archive = nil,
                                  $archive_data_logs = false,
                                  $read_threads      = '10', 
                                  $sync              = true,
                                  $log_size   = '104857600',
                                  $log_write_buffer_size = '4194304',
                                  $verify_checksums  = false,
                                  $paranoid_checks   = false,
                                  $index_factory = 'org.fusesource.leveldbjni.JniDBFactory, org.iq80.leveldb.impl.Iq80DBFactory',
                                  $index_max_open_files = '1000',
                                  $index_block_restart_interval = '16',
                                  $index_write_buffer_size = '6291457',
                                  $index_block_size  = '4096',
                                  $index_cache_size  = '268535456',
                                  $index_compression = 'snappy',
                                  $log_compression   = 'none',
                                  $replicas          = nil,
                                  $zk_address        = nil,
                                  $zk_password       = nil,
                                  $zk_path           = nil,
                                  $bind              = "tcp://0.0.0.0:0",
) {
  $base_match     = "/beans/broker/persistenceAdapter"
  $amq_match      = "amqPersistenceAdapter"
  $kaha_match     = "kahaDB"
  $memory_match   = "memoryPersistenceAdapter"
  $jdbc_match     = ""
  $level_match    = "levelDB"
  $replevel_match = "replicatedLevelDB"
  
  case $type {
    'amq': {
    }
    'kahadb': {
    }
    'leveldb': {
      if !$directory {
        $directory = "LevelDB"
      }
    }
    'memory': {
    }
    'jdbc': {
      fail() # Not supported - see http://activemq.apache.org/jdbc-support.html     
    }
    'replicatedleveldb': {
      if !$directory {
        $directory = "LevelDB"
      }
      if !$replicas {
        fail()
      }
      if !$zk_address {
        fail()
      }
      if !$zk_password {
        fail()
      }
      if !$zk_path {
        fail()
      }
    }
    default: {
      fail()
    }
  }                              
  case $ensure {
    'present': {
      
    }
    'absent': {
      
    }
    default: {
      fail()
    }
  }                
}

# Specific persistenceAdapters, you should only ever have one, and puppet will validate this
# on the target as when it gets set above, it will be distilled into one resource name.

# AMQ persistence adapter:
# http://activemq.apache.org/amq-message-store.html
define libamq::persistenceAdapter::amq($target,
                                                 $ensure            = 'present',
                                                 $directory         = nil,    #   
                                                 $use_nio           = true,   # use NIO to write messages to the data logs
                                                 $sync_on_write     = false,  # sync every write to disk
                                                 $max_file_length   = '32mb', # a hint to set the maximum size of the message data logs
                                                 $persistent_index  = true,   # use a persistent index for the message logs. 
                                                                              # If this is false, an in-memory structure is maintained
                                                 $max_checkpoint_message_add_size = '4kb',
                                                 $cleanup_interval  = '30000',# time (ms) before checking for a discarding/moving message data logs 
                                                                              # that are no longer used
                                                 $index_bin_size    = '1024', # default number of bins used by the index. The bigger the bin size - 
                                                                              # the better the relative performance of the index
                                                 $index_key_size    = '96',   # the size of the index key - the key is the message id
                                                 $index_page_size   = '16kb', # the size of the index page - the bigger the page - the better the write performance of the index
                                                 $directory_archive = nil,    # the path to the directory to use to store discarded data logs,
                                                 $archive_data_logs = false,  # if true data logs are moved to the archive directory instead of being deleted 
                                            
) {
  libamq::persistenceAdapter { $name:
    type                            => 'amq',
    target                          => $target,
    ensure                          => $ensure,
    use_nio                         => $use_nio,
    sync_on_write                   => $sync_on_write,
    max_file_length                 => $max_file_length,
    persistent_index                => $persistent_index,
    max_checkpoint_message_add_size => $max_checkpoint_message_add_size,
    cleanup_interval                => $cleanup_interval,
    index_bin_size                  => $index_bin_size,
    index_key_size                  => $index_key_size,
    index_page_size                 => $index_page_size,
    directory_archive               => $directory_archive,
    archive_data_logs               => $archive_data_logs
  }
}

define libamq::persistenceAdapter::kahaDB($target,
                                                    $ensure            = 'present',
                                                    $directory         = nil,    #  
) {
  libamq::persistenceAdapter { $name:
    type                            => 'kahadb',
    target                          => $target,
    ensure                          => $ensure,
    directory                       => $directory,
  }
}

define libamq::persistenceAdapter::levelDB($target,
                                                     $ensure            = 'present',
                                                     $directory         = 'LevelDB',
                                                     $read_threads      = '10',         # The number of concurrent IO read threads to allowed. 
                                                     $sync              = true,         # If set to false, then the store does not sync logging operations to disk
                                                     $log_size          = '104857600',  # The max size (in bytes) of each data log file before log file rotation occurs.
                                                     $log_write_buffer_size = '4194304',# The maximum amount of log data to build up before writing to the file system.
                                                     $verify_checksums  = false,        # Set to true to force checksum verification of all data that is read from the file system.
                                                     $paranoid_checks   = false,        # Make the store error out as soon as possible if it detects internal corruption.
                                                     # The factory classes to use when creating the LevelDB indexes
                                                     $index_factory = 'org.fusesource.leveldbjni.JniDBFactory, org.iq80.leveldb.impl.Iq80DBFactory',
                                                     $index_max_open_files = '1000',    # Number of open files that can be used by the index.
                                                     $index_block_restart_interval = '16', # Number keys between restart points for delta encoding of keys.
                                                     $index_write_buffer_size = '6291457', # Amount of index data to build up in memory before converting to a sorted on-disk file.
                                                     $index_block_size  = '4096',       # The size of index data packed per block.
                                                     $index_cache_size  = '268535456',  # The maximum amount of off-heap memory to use to cache index blocks.
                                                     $index_compression = 'snappy',     # The type of compression to apply to the index blocks. Can be snappy or none.
                                                     $log_compression   = 'none',       # The type of compression to apply to the log records. Can be snappy or none.
) {
  libamq::persistenceAdapter { $name:
    type                         => 'leveldb',
    target                       => $target,
    ensure                       => $ensure,
    directory                    => $directory,
    read_threads                 => $read_threads,
    sync                         => $sync,
    log_size                     => $log_size,
    log_write_buffer_size        => $log_write_buffer_size,
    verify_checksums             => $verify_checksums,
    paranoid_checks              => $paranoid_checks,
    index_factory                => $index_factory,
    index_max_open_files         => $index_max_open_files,
    index_block_restart_interval => $index_block_restart_interval,
    index_write_buffer_size      => $index_write_buffer_size,
    index_block_size             => $index_block_size,
    index_cache_size             => $index_cache_size,
    index_compression            => $index_compression,
    log_compression              => $log_compression,
  }
}

define libamq::persistenceAdapter::memory($target,
                                                    $ensure            = 'present',
) {
  libamq::persistenceAdapter { $name:
    type                         => 'memory',
    target                       => $target,
    ensure                       => $ensure,
  }  
}

define libamq::persistenceAdapter::replicatedLevelDB($target,
                                                               $replicas,
                                                               $zk_address,
                                                               $zk_password,
                                                               $zk_path,
                                                               $bind              = "tcp://0.0.0.0:0",
                                                               $directory         = 'LevelDB',
                                                               $ensure            = 'present',
                                                               $read_threads      = '10',         # The number of concurrent IO read threads to allowed. 
                                                               $sync              = true,         # If set to false, then the store does not sync logging operations to disk
                                                               $log_size          = '104857600',  # The max size (in bytes) of each data log file before log file rotation occurs.
                                                               $log_write_buffer_size = '4194304',# The maximum amount of log data to build up before writing to the file system.
                                                               $verify_checksums  = false,        # Set to true to force checksum verification of all data that is read from the file system.
                                                               $paranoid_checks   = false,        # Make the store error out as soon as possible if it detects internal corruption.
                                                               # The factory classes to use when creating the LevelDB indexes
                                                               $index_factory = 'org.fusesource.leveldbjni.JniDBFactory, org.iq80.leveldb.impl.Iq80DBFactory',
                                                               $index_max_open_files = '1000',    # Number of open files that can be used by the index.
                                                               $index_block_restart_interval = '16', # Number keys between restart points for delta encoding of keys.
                                                               $index_write_buffer_size = '6291457', # Amount of index data to build up in memory before converting to a sorted on-disk file.
                                                               $index_block_size  = '4096',       # The size of index data packed per block.
                                                               $index_cache_size  = '268535456',  # The maximum amount of off-heap memory to use to cache index blocks.
                                                               $index_compression = 'snappy',     # The type of compression to apply to the index blocks. Can be snappy or none.
                                                               $log_compression   = 'none',       # The type of compression to apply to the log records. Can be snappy or none.
) {
  libamq::persistenceAdapter { $name:
    type                         => 'replicatedleveldb',
    target                       => $target,
    ensure                       => $ensure,
    directory                    => $directory,
    read_threads                 => $read_threads,
    sync                         => $sync,
    log_size                     => $log_size,
    log_write_buffer_size        => $log_write_buffer_size,
    verify_checksums             => $verify_checksums,
    paranoid_checks              => $paranoid_checks,
    index_factory                => $index_factory,
    index_max_open_files         => $index_max_open_files,
    index_block_restart_interval => $index_block_restart_interval,
    index_write_buffer_size      => $index_write_buffer_size,
    index_block_size             => $index_block_size,
    index_cache_size             => $index_cache_size,
    index_compression            => $index_compression,
    log_compression              => $log_compression,
    replicas                     => $replicas,
    zk_address                   => $zk_address,
    zk_password                  => $zk_password,
    zk_path                      => $zk_path,
    bind                         => $bind,          
  }
}
