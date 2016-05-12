#/bin/bash

make -C /home/aaronw/www/mahara
sudo -u www-data php /home/aaronw/www/mahara/htdocs/admin/cli/upgrade.php
