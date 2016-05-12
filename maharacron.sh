#/bin/bash

# Resets all the mahara cron tasks, and runs the crontab.

# Usage: maharacron.sh [name of site] [-n|-r <cron task>]
# Options:
#   -n: Don't reset any cron tasks
#   -r: Reset only the crontask with this name (core.callfunction or plugintype.pluginname.callfunction)
#
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
if [[ $1 && ! $1 == -* ]]
then
    sitename=$1
    # Tell getopts to ignore this one
    OPTIND=2
else
    sitename=$defaultsite
fi

docroot=$webdir/$sitename/htdocs
echo "Running cron for Mahara site at $docroot"
echo $reset

dbtype=`php -r "error_reporting(0); include '$docroot/config.php'; echo \\$cfg->dbtype;"`
dbname=`php -r "error_reporting(0); include '/$docroot/config.php'; echo \\$cfg->dbname;"`
dbprefix=`php -r "error_reporting(0); include '$docroot/config.php'; echo \\$cfg->dbprefix;"`

reset=all
while getopts nr: opt; do
    case $opt in
        n)
            reset=none
            ;;
        r)
            reset=one
            type=$(echo $OPTARG | cut -d. -f1)
            if [[ $type == 'core' ]]; then
                table=cron
                plugin=
                callfunction=$(echo $OPTARG | cut -d. -f2)
            else
                table=${type}_cron
                plugin=$(echo $OPTARG | cut -d. -f2)
                callfunction=$(echo $OPTARG | cut -d. -f3)
            fi
            
            if [[ -z "$callfunction" ]]; then
                echo "ERROR: invalid cron task name '{$opt}'"
                exit 1
            fi

            if [[ -z "$plugin" ]]; then
                echo "Resetting task ${table}.${callfunction}"
                sudo -u postgres psql -e -d $dbname -c "UPDATE ${dbprefix}cron SET nextrun=null WHERE callfunction='${callfunction}';"
            else
                echo "Resetting task ${table}.${plugin}.${callfunction}"
                sudo -u postgres psql -e -d $dbname -c "UPDATE ${dbprefix}${table} SET nextrun=null WHERE plugin='${plugin}' AND callfunction='${callfunction}';"
            fi
            ;;
    esac
done

exit

if [[ $dbtype == "postgres"* ]]; then
    case $reset in
        none)
            echo "Not resetting any tasks..."
            ;;
        all)
            echo "Resetting all cron tasks..."
            echo "   core..."
            sudo -u postgres psql -d $dbname -c "UPDATE ${dbprefix}cron SET nextrun=null;"
            plugintypes=("artefact" "auth" "blocktype" "export" "grouptype" "import" "interaction" "module" "notification" "search")
            for plugin in "${plugintypes[@]}"; do
                echo "    ${plugin}..."
                sudo -u postgres psql -d $dbname -c "UPDATE ${dbprefix}${plugin}_cron SET nextrun=null;"
            done
            ;;
    esac
else 
    echo "Task resetting only supported in Postgres currently... not resetting any tasks."
fi

sudo -u www-data php $docroot/lib/cron.php
