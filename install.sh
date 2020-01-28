#!/bin/bash

# Test to see if user is running with root privileges.
if [[ "${UID}" -ne 0 ]]
then
    echo 'Must execute with sudo or root user!' >&2
    exit 1
fi

# Ensure system is up to date
apt-get update -y 

# Install dependencies
apt-get install build-essential libncurses5-dev libncursesw5-dev libreadline6-dev libffi-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libsqlite3-dev libgdbm-dev tk8.5-dev libssl-dev openssl python3-pip -y

# Install nGINx web server
apt-get install nginx -y

# Install Flask app framework
pip3 install flask

# Install Sqlite DB
apt-get install sqlite3 -y

# Install uWSGI app server
pip3 install uwsgi

# Create flask_app directory
mkdir -p /var/www/flask_app/
cp -r . /var/www/flask_app/
chown -R www-data:www-data /var/www/flask_app/
cd /var/www/flask_app/

# Create socket file for uwsgi and chmod to 666
touch flask_app_uwsgi.sock
chmod 666 flask_app_uwsgi.sock

# Create directory for uwsgi logs
mkdir -p /var/log/uwsgi

# Import tables in the sqlite DB
sqlite3 database.db < create_tables.sql

# Update nginx config files
rm -f /etc/nginx/sites-enabled/default
ln -s /var/www/flask_app/flask_app_nginx.conf /etc/nginx/conf.d/

# Create uWSGI service and enable it
cp uwsgi.service /etc/systemd/system/uwsgi.service
systemctl enable uwsgi.service
systemctl start uwsgi.service

# Install RPI GPIO libraries
pip3 install rpi.gpio

# Install Adafruit DHT libraries
git clone https://github.com/adafruit/Adafruit_Python_DHT.git
cd Adafruit_Python_DHT/
python3 setup.py install

# Restart nginx & uwsgi service
systemctl restart uwsgi.service
service nginx restart

# Check exit code
if [[ $? -eq 0 ]]
then 
 echo -e "\033[1;32mSuccessfully installed the Raspbian Stack :)\033[0m" >&2
 exit 0
else
 echo -e "\033[1;31mFailed to install the Raspbian Stack...\033[0m" >&2
 exit 1
fi
