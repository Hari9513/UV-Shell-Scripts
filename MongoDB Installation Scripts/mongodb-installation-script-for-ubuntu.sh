#!/bin/sh
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get update

if [ -d "/data/db/" ]; 
   then
   sudo chmod -R 777 /data/
else
    sudo mkdir -p /data/db/
    sudo chmod -R 777 /data/
fi

sudo apt-get install -y --allow-unauthenticated mongodb-org

if [ "$(lsb_release -sr)" == "14.04" ];
	then 
    sudo service mongod start
elif [ "$(lsb_release -sr)" == "16.04" ];
	then
	cat << EOF | sudo tee /etc/systemd/system/mongodb.service &> /dev/null
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl start mongodb

fi