source common.sh
if [ -z "root_mysql_password" ]; then
  echo "variable roo_mysql_password is missing"
fi

print "Disable mySQL default module"
dnf module disable mysql -y &>>${LOG}
status_check

print"Copy mysql repo file"
cp ${script_location}/files/mysql.repo /etc/yum.repos.d/myswl.repo &>>${LOG}
status_check

print "Install MySQL server"
yum install mysql-community-server -y &>>${LOG}

print"Enable Mysql"
systemctl enable mysqld &>>${LOG}

print "start Mysql"
systemctl start mysqld &>>${LOG}

print "Reset default database password"
mysql_secure_installation --set-root-pass RoboShop@1 &>>${LOG}

