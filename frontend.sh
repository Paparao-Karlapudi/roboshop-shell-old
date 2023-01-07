script_location=$(pwd)
yum install nginx -y
systemctl enable nginx
systemctl start nginx
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
cp "$script_location"/files/frontend-roboshop /etc/nginx/default.d/roboshop.config
systemctl restart nginx