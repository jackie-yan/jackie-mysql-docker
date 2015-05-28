#!/bin/bash

VOLUME_HOME="/var/lib/mysql"
SAMPLE_DATA_FILE=${FILE:-/magento_data.sql}
USER=${USER:-user}
PASS=${PASS:-password}

if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"  
    /create_mysql_admin_user.sh
else
    echo "=> Using an existing volume of MySQL"
fi

# Create the magento database if it doesn't exist. 
if [[ ! -d $VOLUME_HOME/magento ]]; then

    # Start MySQL
    /usr/bin/mysqld_safe > /dev/null 2>&1 &

    RET=1
    while [[ RET -ne 0 ]]; do
        echo "=> Waiting for confirmation of MySQL service startup"
        sleep 5
        mysql -uroot -e "status" > /dev/null 2>&1
        RET=$?
    done

    echo "========================================================================"
    echo
    echo "MySQL user:" $USER
    echo "MySQL password:" $PASS
    echo "MySQL file:" $SAMPLE_DATA_FILE
    echo
    echo "========================================================================"

   # Create the database and the user 
   mysql -uroot -e \
     "CREATE DATABASE magento; \
      CREATE USER '$USER'@'localhost' IDENTIFIED BY '$PASS';
      GRANT ALL PRIVILEGES ON *.* TO '$USER'@'localhost' WITH GRANT OPTION;
      CREATE USER '$USER'@'%' IDENTIFIED BY '$PASS';
      GRANT ALL PRIVILEGES ON *.* TO '$USER'@'%' WITH GRANT OPTION;"
    
    echo "Initializing the database with sample data"
    mysql -uroot -e \
         "use magento; source $SAMPLE_DATA_FILE;"
        if [ $? -ne 0 ] ; then
		echo >&2 "Couldn't initialize the DB. Ensure proper permissions have been given"
		exit 1
	fi
    echo "database with sample data completed"
    mysqladmin -uroot shutdown
    sleep 5
fi

exec supervisord -n
