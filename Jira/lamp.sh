#!/bin/bash
yum update -y
amazon-linux-extras install -y lamp-mariadb10.2-php7.2
yum install -y httpd mariadb-server
systemctl start httpd
systemctl enable httpd
echo "hello world" > /var/www/html/index.html
echo `hostname` >> /var/www/html/index.html