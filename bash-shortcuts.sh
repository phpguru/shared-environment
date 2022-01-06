#!/bin/bash 
#
# Faster bash
#


alias listening='netstat -tulpn | grep LISTEN'
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

# Complete
echo "Shared Environment: Bash Shortcuts loaded."
