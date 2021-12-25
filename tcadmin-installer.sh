#!/bin/bash

set -e

SCRIPT_VERSION="v0.1.0"
GITHUB_BASE_URL="https://raw.githubusercontent.com/carlosdorelli/tcadmin-installer"

LOG_PATH="/var/log/tcadmin-installer.log"

# SAI COM ERRO SE O USUÁRIO NÃO FOR ROOT
if [[ $EUID -ne 0 ]]; then
  echo "* ESTE SCRIPT DEVE SER EXECUTADO POR USUÁRIOS COM PERMISSÃO ROOT (SUDO)" 1>&2
  exit 1
fi

# CHECA PELO CURL
if ! [ -x "$(command -v curl)" ]; then
  echo "* O CURL NÃO ESTÁ INSTALADO EM SUA MÁQUINA!"
  echo "* INSTALE-O PARA QUE O SCRIPT FUNCIONE CORRETAMENTE."
  exit 1
fi

output() {
  echo -e "* ${1}"
}

error() {
  COLOR_RED='\033[0;31m'
  COLOR_NC='\033[0m'

  echo ""
  echo -e "* ${COLOR_RED}[ERRO]${COLOR_NC} $1"
  echo ""
}

execute() {
  echo -e "\n\n* tcadmin-installer $(date) \n\n" >> $LOG_PATH

  bash <(curl -s "$1") | tee -a $LOG_PATH
  [[ -n $2 ]] && execute "$2"
}

done=false

output
output "Script de Instalação TCAdmin @ $SCRIPT_VERSION"
output
output "Copyright (C) 2021 - 2022, Carlos Dorelli, <itscarlosdorelli@gmail.com>"
output "https://github.com/carlosdorelli/tcadmin-installer"
output
output "Para doações: https://github.com/carlosdorelli/tcadmin-installer?sponsor=1"
output "Este Script não tem ligação oficial com o TCAdmin, é de terceiros."
output

PAINEL_NORMAL="$GITHUB_BASE_URL/$SCRIPT_VERSION/panel.sh"

PANEL_NGINX="$GITHUB_BASE_URL/$SCRIPT_VERSION/panel-nginx.sh"

PANEL_MYSQL_NGINX="$GITHUB_BASE_URL/$SCRIPT_VERSION/panel-nginx-mysql.sh"

while [ "$done" == false ]; do
  options=(
    "Instalar o painel"
    "Instalar o painel com NGINX (SSL)"
    "Instalar o painel com MYSQL e NGINX (SSL) [RECOMENDADO]"
  )

  actions=(
    "$PANEL"
    "$PANEL_NGINX"
    "$PANEL_MYSQL_NGINX;"
  )

  output "[INSTALADOR] O que você quer fazer?"

  for i in "${!options[@]}"; do
    output "[$i] ${options[$i]}"
  done

  echo -n "* Input 0-$((${#actions[@]} - 1)): "
  read -r action

  [ -z "$action" ] && error "Você precisa escolher uma opção!" && continue

  valid_input=("$(for ((i = 0; i <= ${#actions[@]} - 1; i += 1)); do echo "${i}"; done)")
  [[ ! " ${valid_input[*]} " =~ ${action} ]] && error "Opção Inválida!"
  [[ " ${valid_input[*]} " =~ ${action} ]] && done=true && IFS=";" read -r i1 i2 <<< "${actions[$action]}" && execute "$i1" "$i2"
done