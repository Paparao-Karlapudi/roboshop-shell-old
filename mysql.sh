source common.sh
if [ -z "root_mysql_password"]; then
  echo "variable roo_mysql_password is missing"
fi

print_head "Disable mySQL default module"
dnf module disable mysql -y &>>${LOG}
status_check

print_head "Copy mysql repo file"
cp ${script_location}/files/mysql.repo /etc/yum.repos.d/myswl.repo &>>${LOG}
status_check

print_head "Install MySQL server"
yum install mysql-community-server -y &>>${LOG}

print_head "Enable Mysql"
systemctl enable mysqld &>>${LOG}

print_head "start Mysql"
systemctl start mysqld &>>${LOG}

print_head "Reset default database password"
mysql_secure_installation --set-root-pass RoboShop@1 &>>${LOG}

