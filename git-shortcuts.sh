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


# Function to find the most recent tag matching a pattern and suggest the next SemVer tag
git_suggest_next_tag() {
    # Read the wildcard pattern from the user
    echo "Enter the wildcard pattern to match tags (e.g., '*-staging'): "
    read -r pattern

    # Find the most recent tag matching the pattern
    recent_tag=$(git tag -l "$pattern" --sort=-v:refname | head -n 1)

    if [[ -z "$recent_tag" ]]; then
        echo "No tags found matching pattern '$pattern'."
        exit 1
    fi

    echo "Most recent tag matching pattern: $recent_tag"

    # Extract the version number and suffix
    if [[ "$recent_tag" =~ ^(v[0-9]+)\.([0-9]+)\.([0-9]+)(.*)$ ]]; then
        major=${BASH_REMATCH[1]}
        minor=${BASH_REMATCH[2]}
        patch=${BASH_REMATCH[3]}
        suffix=${BASH_REMATCH[4]}

        # Increment the patch version
        next_patch=$((patch + 1))
        suggested_tag="${major}.${minor}.${next_patch}${suffix}"
        
        echo "Suggested next tag: $suggested_tag"
    else
        echo "Error: Unable to parse the tag '$recent_tag' using Semantic Versioning."
        exit 1
    fi
}
alias gtsnt=git_suggest_next_tag

# Function to manage Git tags with pagination
git_manage_tags_with_pagination() {
    # Read the wildcard pattern from the user
    echo "Enter the wildcard pattern to match tags (e.g., 'v*'): "
    read -r pattern

    # Find matching tags
    matching_tags=($(git tag -l "$pattern"))
    total_tags=${#matching_tags[@]}

    if [[ $total_tags -eq 0 ]]; then
        echo "No tags found matching pattern '$pattern'."
        exit 1
    fi

    # Pagination setup
    page_size=10
    current_page=0
    total_pages=$(( (total_tags + page_size - 1) / page_size ))  # Calculate total pages

    show_page() {
        echo
        echo "Page $((current_page + 1)) of $total_pages"
        echo "---------------------------------------"

        start=$((current_page * page_size))
        end=$((start + page_size - 1))
        if ((end >= total_tags)); then end=$((total_tags - 1)); fi

        for i in $(seq $start $end); do
            tag=${matching_tags[$i]}
            tag_date=$(git log -1 --format="%ai" "$tag")
            echo "$((i + 1))) $tag - Created on: $tag_date"
        done

        echo
        echo "[N] Next Page | [P] Previous Page | [D] Delete Tag | [Q] Quit"
        echo "Choose an option:"
    }

    delete_tag() {
        echo "Enter the number corresponding to the tag you want to delete:"
        read -r choice
        if [[ "$choice" =~ ^[0-9]+$ && $choice -ge 1 && $choice -le $total_tags ]]; then
            tag_to_delete=${matching_tags[$((choice - 1))]}
            echo "Deleting tag '$tag_to_delete'..."
            git tag -d "$tag_to_delete"  # Delete the local tag
            git push origin --delete "$tag_to_delete"  # Delete the remote tag (if applicable)
            echo "Tag '$tag_to_delete' deleted locally and remotely (if it existed)."

            # Remove the tag from the array and adjust indices
            unset 'matching_tags[$((choice - 1))]'
            matching_tags=("${matching_tags[@]}")  # Rebuild the array
            total_tags=${#matching_tags[@]}
            total_pages=$(( (total_tags + page_size - 1) / page_size ))
        else
            echo "Invalid choice. Please try again."
        fi
    }

    # Main loop
    while true; do
        show_page
        read -r option

        case $option in
        N|n)
            if ((current_page < total_pages - 1)); then
                ((current_page++))
            else
                echo "You are already on the last page."
            fi
            ;;
        P|p)
            if ((current_page > 0)); then
                ((current_page--))
            else
                echo "You are already on the first page."
            fi
            ;;
        D|d)
            delete_tag
            if ((current_page >= total_pages)); then
                current_page=$((total_pages - 1))  # Adjust if we delete the last tag on the last page
            fi
            ;;
        Q|q)
            echo "Exiting."
            break
            ;;
        *)
            echo "Invalid option. Please choose N, P, D, or Q."
            ;;
        esac
    done
}
alias gtmgr=git_manage_tags_with_pagination




function git_tag_cleanser() {
    echo "Fetching remote tags..."
    git fetch --tags

    echo "Comparing local and remote tags for conflicts..."
    git ls-remote --tags origin > remote_tags.txt

    for tag in $(git tag); do
        local_sha=$(git rev-list -n 1 "$tag")
        remote_sha=$(grep "refs/tags/$tag" remote_tags.txt | awk '{print $1}')

        if [[ "$local_sha" != "$remote_sha" && -n "$remote_sha" ]]; then
            echo "Deleting conflicting local tag: $tag (local SHA: $local_sha, remote SHA: $remote_sha)"
            git tag -d "$tag"
        fi
    done

    echo "Refetching tags to ensure synchronization..."
    git fetch --tags

    echo "Local tags are now synchronized with remote."
}
alias gtcln=git_tag_cleanser



function git_log_issue_search() {

    # Check if both arguments are provided
    if [ "$#" -ne 2 ]; then
        echo "Usage: $0 <ticket_prefix> <num_commits>"
        exit 1
    fi

    TICKET_PREFIX=$1
    NUM_COMMITS=$2

    # Get the git log, extract ticket numbers, sort and remove duplicates
    git log --pretty=oneline -n "$NUM_COMMITS" | \
    grep -oE "$TICKET_PREFIX-[0-9]+" | \
    sort -uV | while read -r ticket; do
        echo "$ticket"
    done
    echo
}
alias glis=git_log_issue_search









echo "Shared Environment: Git Shortcuts loaded."
