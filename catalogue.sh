 source common.sh
 print "Configuring nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}

 print "Install nodejs"
yum install nodejs -y &>>${LOG}

 print "adding user"
useradd roboshop &>>${LOG}

 print "making aap dir"
mkdir -p /app &>>${LOG}

print "downloading zip"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}

 print "removing prev files"
rm -rf /app/* &>>${LOG}

 print "cd to app"
cd /app

 print "unzip catalogue file"
unzip /tmp/catalogue.zip &>>${LOG}

 print "npm installing"
npm install &>>${LOG}

 print "copying script"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}

 print" Daemon reloading"
systemctl daemon-reload &>>${LOG}

 print "Enabling catalogue"
systemctl enable catalogue &>>${LOG}

 print"starting catalogue"
systemctl start catalogue &>>${LOG}

 print "copy mongo repo"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}

 print "install mongo org-shell"
yum install mongodb-org-shell -y &>>${LOG}

 print "uploading schema"
mongo --host mongodb-dev.pappikdev.in </app/schema/catalogue.js &>>${LOG}