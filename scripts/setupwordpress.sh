#!/bin/bash
## Update wp-config with setting
## Check for development environment variable
instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed 's/[a-z]$//'`"
environment=$(aws ec2 describe-tags --region ${EC2_REGION} --filters "Name=resource-id,Values=${instance_id}" | grep -2 Environment | grep Value | tr -d ' ' | cut -f2 -d: | tr -d '"' | tr -d ',')

## Case Select Parameters based on Environment
case $environment in
    Prod)
        ParamStore="MySecureSQLPassword"
        ;;
    Dev)
        ParamStore="DevMySecureSQLPassword"
        ;;
    Stg)
        ParamStore="StgMySecureSQLPassword"
        ;;
    *)
        ParamStore="DevMySecureSQLPassword"
        ;;
esac

## Get settings from Param store
##Get secure Param
paravalue=$(aws ssm get-parameters --region us-west-2 --names ${ParamStore} --with-decryption --query Parameters[0].Value)
paravalue=`echo $paravalue | sed -e 's/^"//' -e 's/"$//'`
##Get Values
values=(${paravalue//;/ })
hostdb=${values}
db=${values[1]}
user=${values[2]}
pwd=${values[3]}

##Copy & update parameters file
cd /var/www/html
cp wp-config-sample.php wp-config.php
### Update Values
sed -i "s/database_name_here/$db/g" wp-config.php
sed -i "s/username_here/$user/g" wp-config.php
sed -i "s/password_here/$pwd/g" wp-config.php
sed -i "s/localhost/$hostdb/g" wp-config.php

##Set Permissions
chmod -R 755 /var/www/html/
