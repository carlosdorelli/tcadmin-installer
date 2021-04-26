#!/bin/bash

set -e

VERSAO="v1.0.0"

# Sai com erro caso o usuário não seja root
if [[ $EUID -ne 0 ]]; then
  echo "* Você precisa ter privilégios do root (sudo) para executar o script!" 1>&2
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
  echo -e "* ${COLOR_RED}ERRO${COLOR_NC}: $1"
  echo ""
}

done=false

output "Instalador Automático do TCAdmin @ $VERSAO"
output
output "Copyright (C) 2021, Carlos Dorelli, <carlos@timberhost.com.br>"
output "https://github.com/eldremor/tcadmin-installer"
output
output "Esse script não é oficial e não tem relações com o TCAdmin.com!"

output

painel() {
  bash <(curl -s https://raw.githubusercontent.com/vilhelmprytz/eldremor/tcadmin-installer/$VERSAO/install-panel.sh)
}

mysql() {
  bash <(curl -s https://raw.githubusercontent.com/vilhelmprytz/eldremor/tcadmin-installer/$VERSAO/install-wings.sh)
}

while [ "$done" == false ]; do
  options=(
    "Instalar o TCAdmin (Para Ubuntu 18.04)"
    "Instalar MYSql + Mariadb (Recomendado - não use sqlite)"
  )

  actions=(
    "painel"
    "mysql"
  )

  output "Qual opção você escolhe?"

  for i in "${!options[@]}"; do
    output "[$i] ${options[$i]}"
  done

  echo -n "* Input 0-$((${#actions[@]}-1)): "
  read -r action

  [ -z "$action" ] && error "Escolha algo!" && continue

  valid_input=("$(for ((i=0;i<=${#actions[@]}-1;i+=1)); do echo "${i}"; done)")
  [[ ! " ${valid_input[*]} " =~ ${action} ]] && error "Opção inválida!"
  [[ " ${valid_input[*]} " =~ ${action} ]] && done=true && eval "${actions[$action]}"
done