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

# appimage apps - symlink the current version
alias pstmn='cd ~/Apps/postman-linux && ./postman &' 
alias neo4j='cd ~/Apps/neo4j-desktop && ./neo4j &'
alias shcut='cd ~/Apps/shotcut-linux && ./shotcut &'

# system navigation
alias goproj='cd ~/Projects/'
alias gooe='cd ~/Projects/AdviNow/orchestration-engine'
alias gopat='cd ~/Projects/AdviNow/patient-app'

#Open file explorer at location
alias open='xdg-open'

alias ll='ls -la'
alias llh='ls -lhart'




# Complete
echo "Shared Environment: Bash Shortcuts loaded."
