#/bin/bash

# Usage: maharawipe.sh [name of site]
# Copyright Aaron Wells 2016
# Distributed under the GPL3 license

## START CONFIGURATION
# You can place a shell script at ~/.mahara-devtools.cfg to define
# the values of webdir, adminemail, and adminpw

# Default config examples based on https://wiki.mahara.org/wiki/Developer_Area/Developer_Environment

# webdir: The directory that all your Mahara sites are listed under
webdir=~/code

# adminemail: The email address for the default admin account
adminemail=`git config --get user.email`

#adminpw: The password for the default admin user.
adminpw=`pwgen -N 1` # Generate a random password

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

dbtype=`php -r "error_reporting(0); include '$docroot/config.php'; echo \\$cfg->dbtype;"`
dataroot=`php -r "error_reporting(0); include '/$docroot/config.php'; echo \\$cfg->dataroot;"`
wwwroot=`php -r "error_reporting(0); include '/$docroot/config.php'; echo \\$cfg->wwwroot;"`
dbport=`php -r "error_reporting(0); include '/$docroot/config.php'; echo \\$cfg->dbport;"`
dbuser=`php -r "error_reporting(0); include '/$docroot/config.php'; echo \\$cfg->dbuser;"`
dbname=`php -r "error_reporting(0); include '/$docroot/config.php'; echo \\$cfg->dbname;"`
echo "Wiping Mahara site at $docroot with DB $dbname"

if [[ $dataroot == "" ]]
then
    echo "No dataroot at '$dataroot'. Is there a config.php file?"
    exit
fi

echo Clearing dataroot directory $dataroot
sudo rm -Rf "$dataroot/"*

if [[ $dbtype == "postgres"* ]]
then
    echo Dropping and recreating postgres database
    sudo -u postgres dropdb $dbname;
    sudo -u postgres createdb -O$dbuser $dbname;
fi

if [[ $dbtype == "mysql"* ]]
then
    # TODO: Make MySQL work without passwordless root auth from current user

    echo Dropping and recreating mysql database
    # Drop database
    mysql -e "drop database $dbname;"
    if [ $? = 0 ];
    then
        echo "dropped database '$dbname'";
    fi

    # Create database
    mysql -e "create database $dbname character set utf8;"
    if [ $? = 0 ];
    then
        echo "created database '$dbname'";
    fi
fi

echo Compiling CSS
make -C $webdir/$sitename

echo Running command-line installer
sudo -u www-data php $docroot/admin/cli/install.php -e=$adminemail -p=$adminpw
echo Admin user password: $adminpw
echo Go to it! $wwwroot