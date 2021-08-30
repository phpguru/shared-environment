#!/bin/bash 
#
# Faster bash
#

alias lh='ls -lhart'


alias neo4j='cd ~/Apps/neo4j-desktop-1.4.7 && ./neo4j-desktop-1.4.7-x86_64.AppImage'
alias vpnu='openvpn3 session-start --config ~/.openvpn3/advinow.conf'
alias vpns='openvpn3 sessions-list'
alias vpnr='openvpn3 session-manage --config ~/.openvpn3/advinow.conf --restart'
alias vpnd='openvpn3 session-manage --session-path ~/.openvpn3/advinow.conf --disconnect'
alias vpnk='sudo pkill openvpn'
alias pstm='cd ~/Apps/Postman-linux-x86_64-8.11.1/Postman && ./Postman' 

alias gooe='cd ~/Projects/AdviNow/orchestration-engine'
alias gopat='cd ~/Prohjects/AdviNow/patient-app'


echo "Shared Environment: Bash Shortcuts loaded."
