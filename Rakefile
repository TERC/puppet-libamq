require 'rubygems'
require 'puppet-lint'
require 'puppetlabs_spec_helper/rake_tasks'

# Bunch of places where we really, really need to be over 80 characters.
PuppetLint.configuration.send("disable_80chars")

# I really don't want to split the module the way puppet lint wants me to
# I'd rather keep all of the definitions inside the config directory.
PuppetLint.configuration.send('disable_autoloader_layout')
