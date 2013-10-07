# What actually sets up a persistenceAdapter
define libamq::persistenceAdapter(
  $target,
  $ensure                          = 'present',
  $type                            = 'memory',
  $directory                       = nil,
  $use_nio                         = true,
  $sync_on_write                   = false,
  $max_file_length                 = '32mb',
  $persistent_index                = true,
  $max_checkpoint_message_add_size = '4kb',
  $cleanup_interval                = '30000',
  $index_bin_size                  = '1024',
  $index_key_size                  = '96',
  $index_page_size                 = '16kb',
  $directory_archive               = nil,
  $archive_data_logs               = false,
  $read_threads                    = '10',
  $sync                            = true,
  $log_size                        = '104857600',
  $log_write_buffer_size           = '4194304',
  $verify_checksums                = false,
  $paranoid_checks                 = false,
  $index_factory                   = 'org.fusesource.leveldbjni.JniDBFactory, org.iq80.leveldb.impl.Iq80DBFactory',
  $index_max_open_files            = '1000',
  $index_block_restart_interval    = '16',
  $index_write_buffer_size         = '6291457',
  $index_block_size                = '4096',
  $index_cache_size                = '268535456',
  $index_compression               = 'snappy',
  $log_compression                 = 'none',
  $replicas                        = nil,
  $zk_address                      = nil,
  $zk_password                     = nil,
  $zk_path                         = nil,
  $bind                            = 'tcp://0.0.0.0:0',
) {
  $base_match     = '/beans/broker/persistenceAdapter'
  $amq_match      = 'amqPersistenceAdapter'
  $kaha_match     = 'kahaDB'
  $memory_match   = 'memoryPersistenceAdapter'
  $jdbc_match     = ''
  $level_match    = 'levelDB'
  $replevel_match = 'replicatedLevelDB'

  case $type {
    'amq': {
    }
    'kahadb': {
    }
    'leveldb': {
      if !$directory {
        $directory = 'LevelDB'
      }
    }
    'memory': {
    }
    'jdbc': {
      fail 'jdbc type not supported'
    }
    'replicatedleveldb': {
      if !$directory {
        $directory = 'LevelDB'
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
      fail "Invalid value for ensure ${ensure}"
    }
  }
  case $ensure {
    'present': {
    }
    'absent': {
    }
    default: {
      fail "Invalid value for ensure ${ensure}"
    }
  }
}

# Specific persistenceAdapters, you should only ever have one, and puppet will validate this
# on the target as when it gets set above, it will be distilled into one resource name.
# AMQ persistence adapter:
# http://activemq.apache.org/amq-message-store.html
define libamq::persistenceAdapter::amq(
  $target,
  $ensure            = 'present',
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
) {
  libamq::persistenceAdapter { $name:
    ensure                          => $ensure,
    type                            => 'amq',
    target                          => $target,
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

# persistenceAdapter kahaDB
define libamq::persistenceAdapter::kahaDB(
  $target,
  $ensure            = 'present',
  $directory         = nil,
) {
  libamq::persistenceAdapter { $name:
    ensure                          => $ensure,
    type                            => 'kahadb',
    target                          => $target,
    directory                       => $directory,
  }
}

# persistenceAdapter levelDB
define libamq::persistenceAdapter::levelDB(
  $target,
  $ensure                       = 'present',
  $directory                    = 'LevelDB',
  $read_threads                 = '10',
  $sync                         = true,
  $log_size                     = '104857600',
  $log_write_buffer_size        = '4194304',
  $verify_checksums             = false,
  $paranoid_checks              = false,
  $index_factory                = 'org.fusesource.leveldbjni.JniDBFactory, org.iq80.leveldb.impl.Iq80DBFactory',
  $index_max_open_files         = '1000',
  $index_block_restart_interval = '16',
  $index_write_buffer_size      = '6291457',
  $index_block_size             = '4096',
  $index_cache_size             = '268535456',
  $index_compression            = 'snappy',
  $log_compression              = 'none',
) {
  libamq::persistenceAdapter { $name:
    ensure                       => $ensure,
    type                         => 'leveldb',
    target                       => $target,
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

# persistenceAdapter Memory
define libamq::persistenceAdapter::memory(
  $target,
  $ensure = 'present',
) {
  libamq::persistenceAdapter { $name:
    ensure => $ensure,
    type   => 'memory',
    target => $target,
  }
}

# persistenceAdapter replicatedLevelDB
define libamq::persistenceAdapter::replicatedLevelDB(
  $target,
  $replicas,
  $zk_address,
  $zk_password,
  $zk_path,
  $bind                         = 'tcp://0.0.0.0:0',
  $directory                    = 'LevelDB',
  $ensure                       = 'present',
  $read_threads                 = '10',
  $sync                         = true,
  $log_size                     = '104857600',
  $log_write_buffer_size        = '4194304',
  $verify_checksums             = false,
  $paranoid_checks              = false,
  $index_factory                = 'org.fusesource.leveldbjni.JniDBFactory, org.iq80.leveldb.impl.Iq80DBFactory',
  $index_max_open_files         = '1000',
  $index_block_restart_interval = '16',
  $index_write_buffer_size      = '6291457',
  $index_block_size             = '4096',
  $index_cache_size             = '268535456',
  $index_compression            = 'snappy',
  $log_compression              = 'none',
) {
  libamq::persistenceAdapter { $name:
    ensure                       => $ensure,
    type                         => 'replicatedleveldb',
    target                       => $target,
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
