#! /bin/bash
yum update -y
yum install ruby -y
yum install wget -y

#Find Region
EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
EC2_REGION_TMP="`echo \"$EC2_AVAIL_ZONE\" | sed 's/[a-z]$//'`"
EC2_REGION="aws-codedeploy-$EC2_REGION_TMP"

echo "Downloading agent for the $EC2_REGION region"

cd /home/ec2-user
wget https://$EC2_REGION.s3.amazonaws.com/latest/install
chmod +x ./install
./install auto

echo "Agent installed, starting process"
service codedeploy-agent start
systemctl enable codedeploy-agent
service codedeploy-agent status
systemctl is-enabled codedeploy-agent

echo "Cleaning up"
rm install