script_location=$(pwd)
LOG=/tmp/roboshop.log
status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
  else
    echo -e "\e[32m FAILURE \e[0m"
  fi
}

print() {
  echo -e "\e[33m $1 \e[0m"
}

Nodejs() {
   print "Configuring nodejs repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
  status_check

   print "Install nodejs"
  yum install nodejs -y &>>${LOG}
  status_check

  print "adding user"
  id roboshop &>>${LOG}
  if [ &? -ne 0 ];
  then
     useradd roboshop &>>${LOG}
  fi
  status_check

   print "making app dir"
  mkdir -p /app &>>${LOG}
  status_check

  print "downloading zip"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
  status_check

   print "removing prev files"
  rm -rf /app/* &>>${LOG}
  status_check

   print "cd to app"
  cd /app
  status_check

   print "unzip user file"
  unzip /tmp/${component}.zip &>>${LOG}
  status_check

   print "npm installing"
  npm install &>>${LOG}
  status_check

   print "copying script"
  cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.service &>>${LOG}
  status_check

   print  "Daemon reloading"
  systemctl daemon-reload &>>${LOG}
  status_check

   print "Enabling ${component}"
  systemctl enable ${component} &>>${LOG}
  status_check

   print "starting ${component}"
  systemctl start ${component} &>>${LOG}
  status_check

   print "copy mongo repo"
  cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
  status_check

   print "install mongo org-shell"
  yum install mongodb-org-shell -y &>>${LOG}
  status_check

   print "uploading schema"
  mongo --host mongodb-dev.pappikdev.in </app/schema/${component}.js &>>${LOG}
  status_check
}