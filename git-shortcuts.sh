#!/bin/bash 
#
# Faster git
#

function git_add_all_and_commit() {
   if [ $# -eq 0 ]
     then
     echo "You must supply a commit message"
     exit 0
   fi
   git add .
   git commit -m "$1"
}

function git_add_all_commit_and_push() {
   git add .
   git commit -m "$1"
   git push
}

function git_amend_last_commit_message_and_push() {
   git commit --amend -m "$1"
   git push --force
}

alias gp='git_add_all_commit_and_push'
alias gs='git status'
alias gl='git log --pretty --oneline'
alias gd='git diff'
alias ga='git_amend_last_commit_message_and_push'
alias gc='git_add_all_and_commit'
# Git Last Tag
alias glt='git fetch && git tag -l | tail -n 1'

# git sync
function git_sync(){
    git fetch
    git checkout development
    git pull
    git checkout master
    git pull
    git checkout development
}

# Git Diff pilot
function git_diff_pilot(){
    git_sync
    git log --pretty --oneline development..master
}
alias gdpilot='git_diff_pilot'

# Git Diff prod
function git_diff_prod(){
    git_sync
    tag = `glt`
    git log --pretty --oneline master..$tag
}
alias gdprod='git fetch && git log --pretty --oneline master..$(glt)'



echo "Shared Environment: Git Shortcuts loaded."
