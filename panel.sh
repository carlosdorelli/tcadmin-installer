#!/bin/bash

set -e

######## CHECAGENS GERAIS #########

# SAI COM ERRO SE O USUÁRIO NÃO FOR ROOT
if [[ $EUID -ne 0 ]]; then
  echo "* ESTE SCRIPT DEVE SER EXECUTADO POR USUÁRIOS COM PERMISSÃO ROOT (SUDO)" 1>&2
  exit 1
fi

########## VARIÁVEIS ############
GITHUB_SOURCE="master"

## FQDN=""

####### CHECAGEM DE SISTEMA OPERACIONAL #######

detect_distro() {
  if [ -f /etc/os-release ]; then
    # FREEDESKTOP.ORG E SYSTEMD
    . /etc/os-release
    OS=$(echo "$ID" | awk '{print tolower($0)}')
    OS_VER=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then
    # LINUXBASE.ORG
    OS=$(lsb_release -si | awk '{print tolower($0)}')
    OS_VER=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$(echo "$DISTRIB_ID" | awk '{print tolower($0)}')
    OS_VER=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS="debian"
    OS_VER=$(cat /etc/debian_version)
  elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    OS="SuSE"
    OS_VER="?"
  elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    OS="Red Hat/CentOS"
    OS_VER="?"
  else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    OS_VER=$(uname -r)
  fi

  OS=$(echo "$OS" | awk '{print tolower($0)}')
  OS_VER_MAJOR=$(echo "$OS_VER" | cut -d. -f1)
}

check_os_comp() {
  CPU_ARCHITECTURE=$(uname -m)
  if [ "${CPU_ARCHITECTURE}" != "x86_64" ]; then # check the architecture
    print_warning "Detected CPU architecture $CPU_ARCHITECTURE"
    print_warning "Using any other architecture than 64 bit (x86_64) will cause problems."

    echo -e -n "* Are you sure you want to proceed? (y/N):"
    read -r choice

    if [[ ! "$choice" =~ [Yy] ]]; then
      print_error "Installation aborted!"
      exit 1
    fi
  fi

  case "$OS" in
  ubuntu)
    PHP_SOCKET="/run/php/php8.0-fpm.sock"
    [ "$OS_VER_MAJOR" == "18" ] && SUPPORTED=true
    [ "$OS_VER_MAJOR" == "20" ] && SUPPORTED=true
    ;;
  debian)
    PHP_SOCKET="/run/php/php8.0-fpm.sock"
    [ "$OS_VER_MAJOR" == "9" ] && SUPPORTED=true
    [ "$OS_VER_MAJOR" == "10" ] && SUPPORTED=true
    [ "$OS_VER_MAJOR" == "11" ] && SUPPORTED=true
    ;;
  centos)
    PHP_SOCKET="/var/run/php-fpm/pterodactyl.sock"
    [ "$OS_VER_MAJOR" == "7" ] && SUPPORTED=true
    [ "$OS_VER_MAJOR" == "8" ] && SUPPORTED=true
    ;;
  *)
    SUPPORTED=false
    ;;
  esac

  # exit if not supported
  if [ "$SUPPORTED" == true ]; then
    echo "* $OS $OS_VER is supported."
  else
    echo "* $OS $OS_VER is not supported"
    print_error "Unsupported OS"
    exit 1
  fi
}

##### PRINCIPAIS FUNÇÕES DA INSTALAÇÃO #####

# INSTALAR MONO
install_mono() {
  echo "* [INSTALAÇÃO] Começando a Instalação do MONO."


  
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
  echo "* [INSTALAÇÃO] MONO Instalado com sucesso!"
}

# Install composer
install_composer() {
  echo "* Installing composer.."
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
  echo "* Composer installed!"
}