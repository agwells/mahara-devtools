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

 sudo ln -s /usr/local/bin/maharawipe /PATH/TO/mahara-devtools/maharawipe.sh

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

 sudo ln -s /usr/local/bin/maharaupgrade /PATH/TO/mahara-devtools/maharaupgrade.sh

# Copyright

Copyright 2016 Aaron Wells
Distributed under the GNU Public License version 3