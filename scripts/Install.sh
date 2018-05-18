#!/bin/bash
### Script to setup web server
sudo yum install -y httpd 
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2

sudo systemctl enable httpd
sudo service httpd start
sudo systemctl is-enabled httpd