#!/bin/bash
## Script to install and run cloudwatch agent
yum update -y
yum install -y awslogs
systemctl start awslogsd
systemctl enable awslogsd
systemctl is-enabled awslogsd