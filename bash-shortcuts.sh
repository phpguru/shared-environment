#!/bin/bash 
#
# Faster bash
#


alias listening='netstat -tulpn | grep LISTEN'
alias lh='ls -lhart'


# OpenVPN3 Shortcuts
alias vpnu='openvpn3 session-start --config ~/.openvpn3/advinow.conf'
alias vpns='openvpn3 sessions-list'
alias vpnr='openvpn3 session-manage --config ~/.openvpn3/advinow.conf --restart'
function vpn_down(){
	DBUS=$(vpns | head -n2 | tail -n1 | awk '{print $2}')
	openvpn3 session-manage --session-path $DBUS --disconnect
}
alias vpnd='vpn_down'
alias vpnk='sudo pkill openvpn'

# appimage apps
alias pstm='cd ~/Apps/Postman-linux-x86_64-8.11.1/Postman && ./Postman' 
alias neo4j='cd ~/Apps/neo4j-desktop-1.4.7 && ./neo4j-desktop-1.4.7-x86_64.AppImage'

# system navigation
alias goproj='cd ~/Projects/'
alias gooe='cd ~/Projects/AdviNow/orchestration-engine'
alias gopat='cd ~/Projects/AdviNow/patient-app'

#Open file explorer at location
alias open='xdg-open'
=======

echo "Shared Environment: Bash Shortcuts loaded."
