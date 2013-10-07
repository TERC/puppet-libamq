# Creates or modifies an SSLContext
define libamq::sslContext(
  $target,
  $keystore,
  $keystore_password,
  $truststore,
  $truststore_password,
  $ensure = 'present',
){
  $match = "/beans/broker/plugins/sslContext/sslContext[#attribute/keyStore == \"${keystore}\"][#attribute/trustStore == \"${truststore}\"]"
}