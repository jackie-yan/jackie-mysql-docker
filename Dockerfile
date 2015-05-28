FROM ubuntu:trusty
MAINTAINER Jackie <jyan@netstarter.com>

# Install packages
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install git 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libapache2-mod-php5
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-mysql
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-curl
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-mcrypt
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install pwgen 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php-apc
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-gd
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install nano


COPY magento_data.sql /

# Add image configuration and scripts
ADD start-mysqld.sh /start-mysqld.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL utils
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN chmod 755 /*.sh

# Add volumes for MySQL.
VOLUME ["/var/lib/mysql"]

RUN chmod 777  /magento_data.sql

EXPOSE 3306

CMD ["/run.sh"]

