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
alias gln='gl -n $1'
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
alias gsf='git_search_for'

function git_merge_main_into_current() {

    # Step 1: Get the current branch name
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    # Step 2: Check for uncommitted changes
    if [[ -n $(git status --porcelain) ]]; then
        git status -s
        sleep 1
        echo "The branch you are on has changes. Commit them first."
        return 1
    fi

    # Step 3: Store the current branch name in a variable (already done above as $current_branch)

    # Step 4: Define the main branch name
    main_branch=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)

    # Step 5: Switch to the main branch
    git checkout $main_branch

    # Step 6: Pull the latest changes from the main branch
    git pull

    # Step 7: Switch back to the current branch
    git checkout $current_branch

    # Step 8: Merge the main branch into the current branch
    git merge $main_branch

    # Step 9: Check for merge conflicts
    merge_status=$?
    if [[ $merge_status -ne 0 ]]; then
        echo "Merging $default_branch into $current_branch resulted in one or more merge conflicts. Please fix them and commit."
        return 1
    fi

    # Step 10: Commit changes
    git commit -m "Merged $default_branch into $current_branch to stay up-to-date with upstream changes."

    # Step 11: Push to remote
    git push
    
    # Step 12: Print the URL for creating a pull request
    remote_url=$(git config --get remote.origin.url)
    if [[ $remote_url == git@github.com:* ]]; then
        REPO_OWNER=$(echo $remote_url | sed -E 's/git@github.com:(.*)\/(.*)\.git/\1/')
        REPO_NAME=$(echo $remote_url | sed -E 's/git@github.com:(.*)\/(.*)\.git/\2/')
    else
        REPO_OWNER=$(echo $remote_url | sed -E 's/https:\/\/github.com\/(.*)\/(.*)\.git/\1/')
        REPO_NAME=$(echo $remote_url | sed -E 's/https:\/\/github.com\/(.*)\/(.*)\.git/\2/')
    fi

    pr_check_response=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
        "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/pulls?head=$REPO_OWNER:$current_branch")

    existing_pr=$(echo $pr_check_response | jq '.[0] | select(.state == "open")')
    if [[ -n "$existing_pr" ]]; then
        pr_url=$(echo $existing_pr | jq -r '.html_url')
        echo "An open pull request already exists for this branch: $pr_url"
    else
        echo "No existing pull request found. You can create one by visiting: https://github.com/$REPO_OWNER/$REPO_NAME/pull/new/$current_branch"
    fi

}
alias gmm='git_merge_main_into_current'

echo "Shared Environment: Git Shortcuts loaded."
