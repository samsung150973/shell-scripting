#!/bun/bash
echo "Frontend automation script"

# rename hostname as frontend
set hostname frontend

#login as root user & install ngiix and start the service
sudo su -
yum install nginx -y
systemctl enable nginx
systemctl start nginx

# download the HTDOCS content and deploy it under the Nginx path.
curl -s -L -o /tmp/frontend.zip "<https://github.com/stans-robot-project/frontend/archive/main.zip>"

#Deploy in Nginx Default Location.
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf