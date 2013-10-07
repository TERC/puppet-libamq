# Class: libamq
#
# This module manages libamq
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
import "config/*.pp"

class libamq {
  xmlfile { '/tmp/activemq.xml':
    ensure  => present,
    content => template('libamq/activemq.xml.erb'),
  }
  libamq::storeUsage  { '/tmp/activemq.xml': value => '2 gb' }
  libamq::tempUsage   { '/tmp/activemq.xml': value => '200 mb' }
  libamq::memoryUsage { '/tmp/activemq.xml': value => '40 mb' }
  libamq::authorizationEntry { 'mcollective': queue => 'mcollective', target => '/tmp/activemq.xml' }
  libamq::simpleAuthenticationUser { 'test': target => '/tmp/activemq.xml' }
}
