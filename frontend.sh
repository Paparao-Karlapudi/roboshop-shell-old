

yum install nginx -y &>>${LOG}


rm -rf /usr/share/nginx/html/* &>>${LOG}

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

cd /usr/share/nginx/html


unzip /tmp/frontend.zip &>>${LOG}



cp "$script_location"/files/frontend-roboshop /etc/nginx/default.d/roboshop.conf



systemctl enable nginx &>>${LOG}



systemctl restart nginx &>>${LOG}
