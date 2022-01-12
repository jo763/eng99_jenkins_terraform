#!/bin/bash


#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install nginx -y

sudo apt-get install git -y
sudo systemctl enable nginx
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs -y
sudo npm install pm2 -g
sudo systemctl restart nginx
sudo systemctl enable nginx

