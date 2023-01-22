source common.sh
print "Install Nginx"
yum install nginx -y &>>${LOG}

print "Remove Nginx Old Content"
rm -rf /usr/share/nginx/html/* &>>${LOG}
status_check()
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
status_check()
cd /usr/share/nginx/html

echo -e "\e[35m Extract Frontend Content\e[0m"
unzip /tmp/frontend.zip &>>${LOG}
status_check()

echo -e "\e[35m Copy config files\e[0m"
cp "$script_location"/files/frontend-roboshop /etc/nginx/default.d/roboshop.conf
status_check()

echo -e "\e[35m Enable Nginx\e[0m"
systemctl enable nginx &>>${LOG}
status_check()

echo -e "\e[35m Restart Nginx\e[0m"
systemctl restart nginx &>>${LOG}
status_check()