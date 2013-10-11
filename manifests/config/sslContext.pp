# Creates or modifies an SSLContext
define libamq::sslContext(
  $keystore,
  $keystore_password,
  $truststore,
  $truststore_password,
  $ensure = 'present',
  $target = $name,
){
  # Only support one SSL context
  $match = '/beans/broker/plugins/sslContext/sslContext'
  case $ensure {
    'present': {
      # add SSLContext
    }
    'absent': { 
    }
    default: {
      fail "Invalid value for ensure ${ensure}"
    }
  }
}