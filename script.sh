#!/bin/bash


sudo apt update -y
sudo apt install nginx -y

sudo mkdir /var/www/html/assets
git clone https://github.com/shivam779823/Blue-Green-deploy-MIG.git
cd Blue-Green-deploy-MIG
sed -i "s/TOTO/${color}/g" index.html
sed -i "s/XX/${version}/g" index.html
sed -i "s/NS/${ns}/g" index.html


sudo mv assets/* /var/www/html/assets/
sudo mv * /var/www/html/
sudo systemctl restart nginx
