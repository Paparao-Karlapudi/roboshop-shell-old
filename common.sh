script_location=$(pwd)
LOG=/tmp/roboshop.log
status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
  fi
}

print() {
  echo -e "\e[33m $1 \e[0m"
}
LOAD_SCHEMA()
{
  if [ ${schema_load} == "true" ]; then
    if [ ${schema_type} == "mongo" ]; then
     print "copy mongo repo file"
    cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
    status_check

     print "install mongo org-shell"
    yum install mongodb-org-shell -y &>>${LOG}
    status_check

     print "uploading schema"
    mongo --host mongodb-dev.pappikdev.in </app/schema/${component}.js &>>${LOG}
    status_check
    fi
  fi
}

SYSTEMD_SERVICE() {

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
}

APP_PREREQ() {
    print "adding user"
    id roboshop &>>${LOG}
    if [ $? -ne 0 ];
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

    print "Extracting ${component} file"
    cd /app
    unzip /tmp/${component}.zip &>>${LOG}
    status_check
}

Nodejs() {
   print "Configuring nodejs repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
  status_check

   print "Install nodejs"
  yum install nodejs -y &>>${LOG}
  status_check

  APP_PREREQ

   print "npm installing"
  npm install &>>${LOG}
  status_check

SYSTEMD_SERVICE

LOAD_SCHEMA
}

MAVEN(){
  print "Install maven"
  yum install maven -y &>>${LOG}
  status_check

  APP_PREREQ

  print "Build a Package"
  mvn clean package &>>${LOG}
  status_check

  print "Copy App file to App location"
  mv target/${component}-1.0.jar ${component}.jar &>>${LOG}
  status_check

  SYSTEMD_SERVICE
}