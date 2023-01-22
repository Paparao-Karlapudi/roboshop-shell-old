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