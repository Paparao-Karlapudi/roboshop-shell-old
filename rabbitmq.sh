source common.sh
if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo "Variable roboshop_rabbitmq_password is needed"
  exit
fi

print "Configuring Erlang Yum"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${LOG}
status_check

print "Configuring RabbitMQ yum repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
status_check

print "Install erlang and RabbitMQ"
yum install erlang rabbitmq-server -y &>>${LOG}
status_check

print "Enable Rabbitmq"
systemctl enable rabbitmq-server &>>${LOG}
status_check

print "start rabbitmq"
systemctl start rabbitmq-server &>>${LOG}
status_check

print "Add Application User"
rabbitmqctl list_users | grep roboshop &>>${LOG}
if [ $? -ne 0 ]; then
 rabbitmqctl add_user roboshop ${roboshop_rabbitmq_password} &>>${LOG}
fi
status_check

print "Add tags to Application User"
rabbitmqctl set_user_tags roboshop administrator &>>${LOG}
status_check

print "Copy mysql repo file"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
status_check
