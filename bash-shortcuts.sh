#!/bin/bash 
#
# Faster bash
#


function get_machine_type {
   unameOut="$(uname -s)"
   case "${unameOut}" in
      Linux*)     machine=Linux;;
      Darwin*)    machine=Mac;;
      CYGWIN*)    machine=Cygwin;;
      MINGW*)     machine=MinGw;;
      *)          machine="UNKNOWN:${unameOut}"
    esac
    echo "$machine"
}

function list_open_ports {
   unameOut=$(get_machine_type)
   case "${unameOut}" in
      Linux*)     netstat -tulpn | grep LISTEN;;
      Mac*)       lsof -i -P | grep -i "listen";;
      Cygwin*)    netstat -tulpn | grep LISTEN;;
      MinGw*)     netstat -tulpn | grep LISTEN;;
      *)          machine="UNKNOWN:${unameOut}"
    esac
}

function better_clear() {
    source ~/.bash_profile
    clear
}
alias c='better_clear'


alias listening='list_open_ports'
alias lh='ls -lhart'

# system navigation
alias goproj='cd ~/Projects/'
alias gosoe='cd ~/Projects/spoton-environment'

alias ll='ls -la'
alias llh='ls -lhart'

# OpenSSL Commands
function openssl_generate_key() {
    openssl genrsa -out "$1.key" 4096
}
alias sslkey='openssl_generate_key'

function openssl_generate_csr() {
    openssl req -new -key "$1.key" -out "$1.csr" -sha256 -config "$1.cnf"
}
alias sslcsr='openssl_generate_csr'

function openssl_generate_self_signed_certificate() {
    openssl x509 -req -days 3650 -sha256 -in "$1.csr" -CA "${ROOT_CA_CRT}" -CAkey "${ROOT_CA_KEY}" -CAcreateserial -out "$1.crt" -extfile "$1.cnf" -extensions v3_req
}
alias sslcrt='openssl_generate_self_signed_certificate'

function what_is_my_ip() {
    wget -qO- ifconfig.me
}
alias myip='what_is_my_ip'



# Complete
echo "Shared Environment: Bash Shortcuts loaded."
