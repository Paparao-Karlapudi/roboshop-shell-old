source common.sh

print "Install Nginx"
yum install nginx -y &>>${LOG}
status_check

print " Enable Nginx "
systemctl enable nginx &>>${LOG}
status_check

print start Nginx
systemctl start nginx &>>${LOG}

print "Remove Nginx Old content "
rm -rf /usr/share/nginx/html/* &>>${LOG}
status_check


print " Download Frontend Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
status_check
cd /usr/share/nginx/html

print "Extract Frontend Content"
unzip /tmp/frontend.zip &>>${LOG}
status_check

print "Copy config files"
cp "$script_location"/files/frontend-roboshop /etc/nginx/default.d/roboshop.conf
status_check

print "Restart Nginx"
systemctl restart nginx &>>${LOG}
