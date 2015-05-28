#mysql docker

A basic image for docker mysql images such as [jackie/mysql]
Usage
Basic Example

Git clone and cd into it
```no-highlight
docker build -t=jackie/mysql .
```
```no-highlight
docker run -d -p 3306 jackie/mysql 
```

#Connecting to MySQL

The first time that you run your container, 
a new user admin with all privileges will be created in MySQL with a password. 

Also create magento database and new magento user. eg: 

- MySQL user: user
- MySQL password: password

To get the password, check the logs of the container.

sudo docker logs container_id

========================================================================
You can now connect to this MySQL Server using:

    mysql -uadmin -pdoaHaz8Nhuoi -h<host> -P<port>

Please remember to change the above password as soon as possible!
MySQL user 'root' has no password but only allows local connections

========================================================================
Waiting for confirmation of MySQL service startup
========================================================================

- MySQL user: user
- MySQL password: password
- MySQL file: /magento_data.sql

========================================================================
Initializing the database with sample data
database with sample data completed


