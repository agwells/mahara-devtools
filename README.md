# maharawipe.sh

This is a quick little script to automate the process of "wiping"
a local Mahara site; that is, emptying it of all data and doing
a clean install.

# Requirements

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

# Installation & Configuration

If your Mahara developer environment is based on the instructions
on the wiki page linked to above, this script will probably
just work automatically with its defaults.

If not, you can configure it by creating a file at ~/.maharawipe.cfg
and placing some configuration values into it like this:

 webdir=/var/www                 # Parent directory of your Mahara checkout
 adminemail=EXAMPLE@example.com  # Email address of admin user in Mahara
 adminpw=SOMEPASSWORD            # Admin user's password
 defaultsite=DEFAULTSITE         # Name of your Mahara checkout

For instance if I had a mahara instance at /var/www/maharadev1 and
/var/www/maharadev2, and I did most of my work in the maharadev1 checkout,
I'd set webdir to "/var/www" and defaultsite to "maharadev1".

For ease of use, I recommend aliasing it into your /usr/local/bin directory:

 sudo ln -s /usr/local/bin/maharawipe /PATH/TO/maharawipe/maharawipe.sh

# Usage

 maharawipe.sh [site name]
 
If the "site name" is left off, it'll run on your default site.