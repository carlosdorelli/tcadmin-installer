#!/bin/bash

set -e

VERSION="v1.0.0"

# Sai com erro caso o usuário não seja root
if [[ $EUID -ne 0 ]]; then
  echo "* You need root permissions for this script. Do 'sudo su -'." 1>&2
  exit 1
fi

# Checa pelo curl
if ! [ -x "$(command -v curl)" ]; then
  echo "* O curl é necessário para que o script funcione!"
  echo "* Instale-o através do comando 'apt install curl'"
  exit 1
fi

output() {
  echo -e "* ${1}"
}

error() {
  COLOR_RED='\033[0;31m'
  COLOR_NC='\033[0m'

  echo ""
  echo -e "* ${COLOR_RED}ERROR${COLOR_NC}: $1"
  echo ""
}

done=false

output
output "TCAdmin Installer @ $VERSION"
output
output "Copyright (C) 2021, Carlos 'Eldremor' Dorelli, <carlos@timberhost.com.br>"
output "https://github.com/eldremor/tcadmin-installer"
output
output "This is custom script and it's not related to TCAdmin.com"

output

panel() {
  bash <(curl -s https://raw.githubusercontent.com/eldremor/tcadmin-installer/panel.sh)
}

mysql() {
  bash <(curl -s https://raw.githubusercontent.com/eldremor/tcadmin-installer/mysql.sh)
}

while [ "$done" == false ]; do
  options=(
    "Install TCAdmin"
    "Install MYSQL + Mariadb"
  )

  actions=(
    "panel"
    "mysql"
  )

  output "Which option do you choose?"

  for i in "${!options[@]}"; do
    output "[$i] ${options[$i]}"
  done

  echo -n "* Input 0-$((${#actions[@]}-1)): "
  read -r action

  [ -z "$action" ] && error "Choose a option" && continue

  valid_input=("$(for ((i=0;i<=${#actions[@]}-1;i+=1)); do echo "${i}"; done)")
  [[ ! " ${valid_input[*]} " =~ ${action} ]] && error "Invalid option!"
  [[ " ${valid_input[*]} " =~ ${action} ]] && done=true && eval "${actions[$action]}"
done