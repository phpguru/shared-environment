#!/bin/bash 
#
# Faster git
#
function git_add_all_commit_and_push() {
   git add .
   git commit -m "$1"
   git push
}
alias gp='git_add_all_commit_and_push'
alias gs='git status'
alias gl='git log --pretty --oneline'


echo "Shared Environment: Git Shortcuts loaded."
