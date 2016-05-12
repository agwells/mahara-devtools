#/bin/bash

# Usage: maharacron.sh [name of site]
# Copyright Aaron Wells 2016
# Distributed under the GPL3 license

## START CONFIGURATION
# You can place a shell script at ~/.mahara-devtools.cfg to define
# the values of webdir, adminemail, and adminpw

# Default config examples based on https://wiki.mahara.org/wiki/Developer_Area/Developer_Environment

# webdir: The directory that all your Mahara sites are listed under
webdir=~/code

#defaultsite: The default site to use if none is specified
defaultsite=mahara

if [ -f ~/.mahara-devtools.cfg ]; then
    . ~/.mahara-devtools.cfg
fi;

## END CONFIGURATION

# If no site name is provided, assume it's called "mahara" by default.
if [[ $1 ]]
then
    sitename=$1
else
    sitename=$defaultsite
fi

docroot=$webdir/$sitename/htdocs

echo "Running cron for Mahara site at $docroot"
sudo -u www-data php $docroot/lib/cron.php
