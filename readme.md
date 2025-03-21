# Shared Environment (shenv)

## Overview

The shared environment consists of 

- Bash shortcuts - aliases and custom functions
- Docker shortcuts - aliases and custom functions
- Git completion - to make common git commands faster in terminal
- Git prompt - to make git branch name tab completion and bash prompt better

## Usage

1. Clone the repository:  `cd ~ && git clone git@github.com/phpguru/shared-environment ~/.shenv`, 
1. Set PROJECT_HOME to point to your projects folder, e.g. /home/<YOUR-USER>/Projects 
1. Set the DOCKER_HOME environment variable to /home/<YOUR-USER>/Projects/<YOUR-PROJECT>
1. Add the below code to your ~/.bashrc (Linux) or ~/.bash_profile (Mac) or ~/.zshrc (M1/M2 Mac)
1. Reload your terminal or `source ~/.bashrc`
1. Once this is done, you can forever more just use the 'c' alias (see better_clear)

```
for file in ~/.shenv/*.sh;
do
    source $file
done
```

Once you've done this, you can enjoy...

### Git goodies

   - git prompt -- shows the branch you are on with coloring
   - git completion -- enables tab-completion of branch names

### Git aliases

   - `gs` ~ git status -- what changed
   - `gp $message` ~ git add . && git commit -m $message && git push

### Docker aliases

   - `dll` ~ docker ps -a -- which containers are running
   - `dim` ~ docker images -- which Docker images you have pulled locally
   - `dsto $container` ~ docker stop $container -- stop a container
   - `de $container` ~ docker exec -it $container /bin/bash -- docker exec into a container shell

### Bash aliases

   - `lh` ~ ls -lhart -- list human readable
   - `listening` ~ netstat -tulpn | grep LISTEN -- which ports are open on your box

... and lots more. Read the provided .sh files for more details.

Please feel free to contribute your own git, docker and bash aliases.

### Notes

This works in conjunction with/on top of 
[oh my zsh](https://ohmyz.sh/) 
or the port of oh my zsh to bash [oh my bash](https://github.com/ohmybash/oh-my-bash)
to augment the shortcuts and customizations that they provide. I strongly encourage 
checking those out first, since a thousand people way smarter than me
have contributed there, and the feature set is very large. I wrote these shortcuts
well before someone pointed me to oh-my-whatever. Oddly, I found many of the Docker shortcuts
I made are not present in those. 

The scripts and add-ons in this repo have not been well tested on `zsh`.
If you find a bug in zsh, please provide a PR.

There are some old, residual, opinionated stuff lingering in here from some of my 
past projects with PHP, MySQL, Redis and so on. If it bugs you, send a PR.

