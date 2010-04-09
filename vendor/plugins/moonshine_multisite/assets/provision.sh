#!/bin/bash

# test

echo This installer will set up this computer for development or a server.  It will do a number of package installs, including rails, mysql and ruby enterprise edition.  If you have a working rails setup already, you should probably not use this installer unless you\'ve looked at it and know what it will do.
echo
echo "Parameters: ./provision.sh (server|dev) (canada|mh)"
echo
read -p "Press enter to continue, or ctrl-C to abort."

ruby_output="$(which ruby)"

if [ -z "$ruby_output" ]; then
    sudo apt-get -q -y install ruby
fi

rm provision.rb
wget http://github.com/andrewroth/moonshine_multisite/raw/ministry_hacks/assets/provision.rb
ruby provision.rb $1 $2
