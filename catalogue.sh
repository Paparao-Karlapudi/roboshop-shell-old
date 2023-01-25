 source common.sh

 print "Configuring nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

 print "Install nodejs"
yum install nodejs -y &>>${LOG}
status_check

 print "adding user"
 id roboshop &>>${LOG}
 if [ &? -ne 0 ]; then
   useradd roboshop &>>${LOG}
fi
status_check

 print "making aap dir"
mkdir -p /app &>>${LOG}
status_check

print "downloading zip"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

 print "removing prev files"
rm -rf /app/* &>>${LOG}
status_check

 print "cd to app"
cd /app
status_check

 print "unzip catalogue file"
unzip /tmp/catalogue.zip &>>${LOG}
status_check

 print "npm installing"
npm install &>>${LOG}
status_check

 print "copying script"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check

 print  "Daemon reloading"
systemctl daemon-reload &>>${LOG}
status_check

 print "Enabling catalogue"
systemctl enable catalogue &>>${LOG}
status_check

 print "starting catalogue"
systemctl start catalogue &>>${LOG}
status_check

 print "copy mongo repo"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check

 print "install mongo org-shell"
yum install mongodb-org-shell -y &>>${LOG}
status_check

 print "uploading schema"
mongo --host mongodb-dev.pappikdev.in </app/schema/catalogue.js &>>${LOG}
status_check