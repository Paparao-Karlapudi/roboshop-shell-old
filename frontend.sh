script_location=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[35m Install Nginx\e[0m"
yum install nginx -y &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[35m Remove Nginx Old content \e[0m"
rm -rf /usr/share/nginx/html/* &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[33m Download Frontend Content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

cd /usr/share/nginx/html

echo -e "\e[35m Extract Frontend Content\e[0m"
unzip /tmp/frontend.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[35m Copy config files\e[0m"
cp "$script_location"/files/frontend-roboshop /etc/nginx/default.d/roboshop.conf
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[35m Enable Nginx\e[0m"
systemctl enable nginx &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[35m Restart Nginx\e[0m"
systemctl restart nginx &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi