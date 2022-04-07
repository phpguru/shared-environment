# Shared Environment (shenv)

## Overview

The shared environment consists of 

- Bash shortcuts - aliases and custom functions
- Docker shortcuts - aliases and custom functions
- Git completion - to make common git commands faster in terminal
- Git prompt - to make git branch name tab completion and bash prompt better

## Usage

1. Clone the repository to ~/.shenv, 
1. Set PROJECT_HOME to point to your projects folder, e.g. /home/<YOUR_USER>/Projects 
1. Set the DOCKER_HOME environment variable to /home/<YOUR-USER>/Projects/AdviNow/docker-development
1. Add the below code to your ~/.bashrc (Linux) or ~/.bash_profile (Mac)
1. Reload your terminal or `source ~/.bashrc`

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
