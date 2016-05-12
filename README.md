# Mahara dev tools

These are a couple of little scripts that I've written to help me
quickly re-install or update my local Mahara dev site.

# maharawipe.sh

This script will "wipe" a local Mahara site. It re-creates the database,
deletes the contents of the dataroot directory, and runs the command-line
installer script. It takes around 15 seconds, in Postgres.

## Usage

 maharawipe.sh [site name]
 
If the "site name" is left off, it'll run on your default site.

## Requirements

This script assumes that you already have a Mahara site configured
and installed. If not, follow the steps here:
https://wiki.mahara.org/wiki/Developer_Area/Developer_Environment

It also assumes you are on a Linux machine with bash. The default
configuration uses the "pwgen" utility to generate a random
password after each re-install. In Ubuntu this is available
by doing "sudo apt-get install pwgen".

If you are using mysql, the script assumes that you have your
current user set up as a root user in your local mysql database,
with passwordless access. (And if you are using that insecure
setup, make sure it's firewalled and not accessible to the
outside world.)

## Installation & Configuration

If your Mahara developer environment is based on the instructions
on the wiki page linked to above, this script will probably
just work automatically with its defaults.

If not, you can configure it by creating a file at ~/.mahara-devtools.cfg
and placing some configuration values into it like this:

 webdir=/var/www                 # Parent directory of your Mahara checkout
 adminemail=EXAMPLE@example.com  # Email address of admin user in Mahara
 adminpw=SOMEPASSWORD            # Admin user's password
 defaultsite=DEFAULTSITE         # Name of your Mahara checkout

For instance if I had a mahara instance at /var/www/maharadev1 and
/var/www/maharadev2, and I did most of my work in the maharadev1 checkout,
I'd set webdir to "/var/www" and defaultsite to "maharadev1".

For ease of use, I recommend aliasing it into your /usr/local/bin directory:

 sudo ln -s /PATH/TO/mahara-devtools/maharawipe.sh /usr/local/bin/maharawipe

# maharaupgrade.sh

This script will run the command-line upgrade script for a local
Mahara site. I wrote it because I just got tired of having to
type in the full "sudo -u www-data" needed to ensure the correct
permissions in the dataroot directory.

## Usage

 maharaupgrade.sh [site name]
 
If the "site name" is left off, it'll run on your default site.

## Installation & Configuration

Same as the maharawipe.sh script. It even usesv the same "~/.mahara-devtools.cfg"
configuration file to determine where the Mahara code is located.

I also recommend aliasing it into your /usr/local/bin directory:

 sudo ln -s /PATH/TO/mahara-devtools/maharaupgrade.sh /usr/local/bin/maharaupgrade

# maharacron.sh

This script will run the Mahara cron script, optionally also resetting
the "nextrun" time for one or all cron tasks so that they'll run immediately.

## Usage

 maharacron.sh [site name] [-(n|r (core.<callfunction>|<plugintype>.<pluginname>.<callfunction>))]
 
By default it resets the nextrun time for every cron task.

The "-n" option tells it *not* to reset the nextrun time of any cron task.

The "-r" option tells it to only reset the nextrun time of one specific cron task.
The name of the crontask should be "core.<callfunction>" for "core" tasks (i.e. in the
"cron" table), or "<plugintype>.<pluginname>.<callfunction>" for a task belonging
to a plugin.

The "-r" option can be provided multiple times to specify multiple tasks to reset.

Example:

 maharacron.sh -r core.activity_process_queue -r auth.ldap.auth_ldap_sync_cron

# Copyright

Copyright 2016 Aaron Wells
Distributed under the GNU Public License version 3