
function docker_restart(){
    osascript -e 'quit app "Docker"'
    open -a Docker
}

### Containers ###################################################################

# List Running Processes
dls() {
  docker ps
}

# Compact List All Running Processes
dll() {
  docker ps -a --format 'table {{ .ID }}\t{{ .Image }}\t{{ .Names }}\t{{ .Status }}\t{{ .Ports }}'
}

dall() {
  docker ps -a
}


# Docker stop
dsto() {
  if [[ $# == 0 ]]
    then
      echo "Which container? Provide 1 argument."
      return 0
  fi
  docker stop $1
}

# Docker start
dsta() {
  if [[ $# == 0 ]]
    then
      echo "Which container? Provide 1 argument."
      return 0
  fi
  docker start $1
}

# Docker remove
drm() {
  if [[ $# == 0 ]]
    then
      echo "Which container? Provide 1 argument."
      return 0
  fi
  docker rm $1
}

docker_take_down(){
  if [[ $# == 0 ]]
    then
      echo "Which container? Provide 1 argument."
      return 0
  fi
  docker stop $1
  docker rm $1
}
alias dtd='docker_take_down'

# Docker stop all running
dsar() {
    if [[ $# == 0 ]]
      then
        docker ps | tail -n +2 |cut -d ' ' -f 1 | xargs docker stop
    else
        dsto $1;
    fi
}
alias dstop='dsar'

# Docker remove all stopped
dras() {
    docker ps -a | tail -n +2 | grep Exited | cut -d ' ' -f 1 | xargs docker rm
}

# Docker kill all
docker_killall() {
    dsar
    dras
}
alias dka='docker_killall'


# Docker get an ext ip
dip() {
  if [[ $# == 0 ]]
    then
      echo "Which container? Provide 1 argument."
      return 0
  fi
   docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1
}

drun() {
  if [[ $# == 0 ]]
    then
      echo "Which container? Provide 1 argument."
      return 0
  fi

  case "$1" in

    "redis" )
        docker run -d --name redis -e APP=redis -p 6379:6379 redis:latest;;

    "db" )
      docker run -d --name db --volumes-from mysql_data -e APP=db -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} -p 3306:3306 db:latest;;

    "app" )
        docker run -d --name app -e APP=app --link redis:redis --link db:db -v ~/Projects:/Projects app:latest;;

    "web" )
        docker run -d --name web -e APP=web --link app:app --volumes-from app -p 80:80 -p 443:443 web:latest;;

    "pgadmin4" )
	      docker run --name pgadmin4 -p 81:80 -v /home/geoff/pg:/var/lib/pgadmin/storage --dns=172.17.0.1 --dns=10.90.0.2 --dns=8.8.8.8 -e 'PGADMIN_DEFAULT_EMAIL=ghoffman1@wayfair.com' -e 'PGADMIN_DEFAULT_PASSWORD=P@55w0rd' -d dpage/pgadmin4;;

  esac

}


docker_enter() {
  if [[ $# == 0 ]]
    then
      echo "Which container? Provide 1 argument."
      return 0
  fi

  docker exec -ti -e "COLUMNS=200 LINES=51" $1 bash
}
alias de='docker_enter'

docker_mysql() {
   docker exec -it db sh -c 'exec mysql -uroot -p"${MYSQL_ROOT_PASSWORD}"'
}
alias dmysql='docker_mysql'

# Soft Start Docker app
function docker_up()
{
    denv up
}
alias dup='docker_up'

function docker_down()
{
    denv down
}
alias ddn='docker_down'

function docker_reset()
{
    docker-down
    docker-up
}
alias dre='docker_reset'

function denv ()
{
  if [[ $# == 0 ]]
    then
      echo "Do you want to bring the Docker environment up or down?"
      return 0
  fi
    if [[ "$1" == "up" ]]
        then
        echo "Bringing Up Docker Environment..."
        cd ${DOCKER_HOME}
        docker-compose up -d
        cd -
        echo "Done."
    fi

    if [[ "$1" == "down" ]] || [[ "$1" == "dn" ]]
        then
        echo "Taking Down Docker Environment..."
        cd ${DOCKER_HOME}
        docker-compose down
        cd -
        echo "Done."
    fi

    if [[ "$1" == "reset" ]] || [[ "$1" == "reload" ]]
        then
          denv down
          denv up
    fi

}

function docker_build_up {
    cd ${DOCKER_HOME}
    export COMPOSE_PROJECT_NAME='dolceclock'
    docker-compose up --build --force-recreate -d
    dll
}
alias dbu='docker_build_up'

### Images ###################################################################

# List Docker Images
dim() {
   docker images
}

# Remove a Docker Image
dri() {
  if [[ $# == 0 ]]
    then
      echo
      echo "Remove which image? Provide 1 argument. Here are the images you have..."
      echo
      dim
      echo
      return 0
  fi
   docker rmi $1
}

# remove all images
function docker_rmi_all(){
  read -p "Are you sure you want to nuke your docker environment completely? <y/N> " prompt
  if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
  then
      docker rmi -f $(docker images -q)
  else
    exit 0
  fi

}
alias drmi='docker_rmi_all'

# remove untagged images
function di_rmi_untagged()
{
  docker rmi $(docker images -q --filter "dangling=true") --force
}
alias drirmu='di_rmi_untagged'

# list all images
function docker_image_list()
{
  docker images
}
alias dii='docker_image_list'
alias dil='docker_image_list'

function docker_remove_all_none_images()
{
   docker images | grep '<none>' | awk -F' ' '{print $3}' | xargs docker rmi
}
alias dimrma='docker_remove_all_none_images'
alias drani='docker_remove_all_none_images'

### Containers ################################################################

# wipe all containers
function docker_container_remove_all()
{
  read -p "Are you sure you want to kill all your Docker containers? <y/N> " prompt
  if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
  then
    docker rm -f $(docker ps -a -q)
  else
    exit 0
  fi
}
alias dcrma='docker_container_remove_all'

# remove all stopped containers
function docker_remove_stopped(){
  docker rm $(docker ps -a | grep Exited | awk '{print $1}')
}
alias dcrms='docker_remove_stopped'


### Volumes ###################################################################

function docker_volume_list(){
    docker volume ls
}
alias dvl='docker_volume_list'

function docker_volume_remove(){
    if [ $# -eq 0 ]; then
        echo "docker_volume_remove requires 1 arg"
    else
        docker volume rm $1
    fi
}
alias dvr='docker_volume_remove'

function docker_volume_remove_dangling(){
    docker volume ls -f "dangling=true" | xargs docker volume rm
}
alias dvrd='docker_volume_remove_dangling'

function docker_volume_prune(){
    docker volume prune
}
alias dvp='docker_volume_prune'


## Networking ##################################################################

function docker_show_ports() {
    if [ $# -eq 0 ]; then
        echo "   error: docker_show_ports requires 1 arg"
        echo "   usage: dsp <container>"
        return 1
    else
       docker inspect --format='{{range $p, $conf := .Config.ExposedPorts}} {{$p}} {{end}}' $1
    fi
}
alias dsp='docker_show_ports'

## Dockerized Apps #############################################################

# Run Composer from a container
# alias composer="docker run -it --rm -u $UID -v `pwd`:/app composer:latest `which composer`"


# Run any version of PHP by changing this alias
# alias php="docker run -it --rm -u $UID -v `pwd`:/app php:cli /usr/local/bin/php"


### Miscellaneous ###################################################################

function docker_build_oe(){
    docker-compose -f docker-compose.tim.yml build
}
alias dboe='docker_build_oe'

function docker_run_oe(){
    docker-compose -f docker-compose.tim.yml up -d
}
alias droe='docker_run_oe'

function docker_logs(){
    docker logs $1
}
alias dlg='docker_logs'

function docker_logs_follow(){
    docker logs $1 --follow
}
alias dlf='docker_logs_follow'

function docker_logs_grep(){
    if [ $# -ne 2 ]; then
        echo "   error: docker_logs_grep requires 2 args"
        echo "   usage: dlgr <container> <grepfor>"
        return 1
    else
       docker logs $1 2>&1 | grep $2
    fi
}
alias dlgr='docker_logs_grep'


# From https://forums.docker.com/t/how-can-i-list-tags-for-a-repository/32577/8
function docker_list_all_tags() { 
    local repo=${1} 
    local page_size=${2:-100} 
    [ -z "${repo}" ] && echo "Usage: listTags <repoName> [page_size]" 1>&2 && return 1 
    local base_url="https://registry.hub.docker.com/api/content/v1/repositories/public/library/${repo}/tags" 
     
    local page=1 
    local res=$(curl "${base_url}?page_size=${page_size}&page=${page}" 2>/dev/null) 
    local tags=$(echo ${res} | jq --raw-output '.results[].name') 
    local all_tags="${tags}" 
 
    local tag_count=$(echo ${res} | jq '.count')   
 
    ((page_count=(${tag_count}+${page_size}-1)/${page_size}))  # ceil(tag_count / page_size) 
 
    for page in $(seq 2 $page_count); do 
        tags=$(curl "${base_url}?page_size=${page_size}&page=${page}" 2>/dev/null | jq --raw-output '.results[].name') 
        all_tags="${all_tags}${tags}" 
    done 
 
    echo "${all_tags}" | sort 
} 
alias dlat='docker_list_all_tags'



### Messages ###################################################################


PGADMIN_DEFAULT_EMAIL=webmaster@localhost
PGADMIN_DEFAULT_PASSWORD=P@55w0rd


echo "Shared Environment: Docker shortcuts loaded."

