echo -e "\e[35m Configuring nodejs repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}

echo -e "\e[35m Install nodejs\e[0m"
yum install nodejs -y &>>${LOG}

echo -e "\e[35m adding user\e[0m"
useradd roboshop &>>${LOG}

echo -e "\e[35m maing aap dir\e[0m"
mkdir -p /app &>>${LOG}

echo -e "\e[ downloading zip \e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}

echo -e "\e[35m removing prev files \e[0m"
rm -rf /app/* &>>${LOG}

echo -e "\e[35m Install Nginx\e[0m"
cd /app

echo -e "\e[35m Install Nginx\e[0m"
unzip /tmp/catalogue.zip &>>${LOG}

echo -e "\e[35m Install Nginx\e[0m"
npm install &>>${LOG}

echo -e "\e[35m Install Nginx\e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}

echo -e "\e[35m Install Nginx\e[0m"
systemctl daemon-reload &>>${LOG}

echo -e "\e[35m Install Nginx\e[0m"
systemctl enable catalogue &>>${LOG}

echo -e "\e[35m Install Nginx\e[0m"
systemctl start catalogue &>>${LOG}

echo -e "\e[35m Install Nginx\e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}

echo -e "\e[35m Install Nginx\e[0m"
yum install mongodb-org-shell -y &>>${LOG}

echo -e "\e[35m Install Nginx\e[0m"
mongo --host mongodb-dev.pappikdev.in </app/schema/catalogue.js &>>${LOG}