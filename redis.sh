source common.sh
print "Install redis repo file"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${LOG}
status_check

print "Enabling Redis"
dnf module enable redis:remi-6.2 -y &>>${LOG}
status_check

print "Installing Redis"
yum install redis -y &>>${LOG}
status_check

print "Updating conf file of Redis"
sed -i -e 's/127.0.0.1/0.0.0.0/gi' /etc/redis.conf &>>${LOG}
status_check

print "Enable Redis"
systemctl enable redis &>>${LOG}
status_check

print "Start Redis"
systemctl start redis &>>${LOG}
status_check