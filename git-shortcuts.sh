#!/bin/bash 
#
# Faster git
#

function git_add_all_and_commit() {
   if [ $# -eq 0 ]
     then
     echo "You must supply a commit message"
     return 1
   fi
   git add .
   git commit -m "$1"
}

function git_add_all_commit_and_push() {
   if [ $# -eq 0 ]
     then
     echo "You must supply a commit message"
     return 1
   fi
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
    git checkout dev
    git pull
    git checkout main
    git pull
    git checkout dev
    git merge main
}
alias gsy='git_sync'

# Git Diff pilot
function git_diff_branch(){
    git_sync
    git log --pretty --oneline $1..main
}
alias gdpilot='git_diff_branch'

# Git Diff prod
function git_diff_prod(){
    git_sync
    tag = `glt`
    git log --pretty --oneline main..$tag
}
alias gdprod='git fetch && git log --pretty --oneline master..$(glt)'

# Git branch am I on?
function git_branch_current(){
    git branch -a | grep '*'
}
alias gbr='git_branch_current'

function git_branch_list_all(){
    git branch -a
}
alias gbra='git_branch_list_all'

function git_branch_delete() {
   if [ $# -eq 0 ]
     then
     echo "You must supply a branch to delete"
     return 1
   fi
   git branch -D $1
}
alias 'gbd'=git_branch_delete

# Git Checkout 
function git_checkout_branch(){
    git checkout $1
}
alias gco='git_checkout_branch'

# Git Checkout -b
function git_create_branch(){
    git checkout -b $1
}
alias gcb='git_create_branch'

function git_pull(){
    git fetch
    git pull
}
alias gpu='git_pull'

function git_branch_prune(){
    git fetch -p ; git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -d
}
alias gpr='git_branch_prune'

function git_branch_prune_force(){
    git fetch -p ; git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -D
}
alias gprf='git_branch_prune_force'

function git_checkout_new_branch(){
    git checkout -b $1
}
alias gcb='git_checkout_new_branch'

function git_search_for(){
   git rev-list --all | xargs git grep "$1"
}



echo "Shared Environment: Git Shortcuts loaded."
