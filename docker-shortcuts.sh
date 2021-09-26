

### Containers ###################################################################

# List Running Processes
dls() {
  docker ps
}

# List All Running Processes
dll() {
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
docker-killall() {
    dsar
    dras
}
alias dka='docker-killall'


# Docker get an ext ip
dip() {
  if [[ $# == 0 ]]
    then
      echo "Which container? Provide 1 argument."
      return 0
  fi
   docker inspect --format='{{.NetworkSettings.IPAddress}}' $1
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
	docker run --name pgadmin4 -p 81:80 -v /home/geoff/pg:/var/lib/pgadmin/storage --dns=172.17.0.1 --dns=10.90.0.2 --dns=8.8.8.8 -e 'PGADMIN_DEFAULT_EMAIL=geoffrey.hoffman@advinow.com' -e 'PGADMIN_DEFAULT_PASSWORD=P@55w0rd' -d dpage/pgadmin4;;

  esac

}


docker-enter() {
  if [[ $# == 0 ]]
    then
      echo "Which container? Provide 1 argument."
      return 0
  fi

  docker exec -ti -e "COLUMNS=200 LINES=51" $1 bash
}
alias de='docker-enter'

docker-mysql() {
   docker exec -it db sh -c 'exec mysql -uroot -p"${MYSQL_ROOT_PASSWORD}"'
}
alias dmysql='docker-mysql'

# Soft Start Docker app
function docker-up()
{
    denv up
}
alias dup='docker-up'

function docker-down()
{
    denv down
}
alias ddn='docker-down'

function docker-reset()
{
    docker-down
    docker-up
}
alias dre='docker-reset'

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
        docker-compose -f docker-compose.tim.yml up -d
        cd -
        echo "Done."
    fi

    if [[ "$1" == "down" ]] || [[ "$1" == "dn" ]]
        then
        echo "Taking Down Docker Environment..."
        cd ${DOCKER_HOME}
        docker-compose -f docker-compose.tim.yml down
        cd -
        echo "Done."
    fi

    if [[ "$1" == "reset" ]] || [[ "$1" == "reload" ]]
        then
          denv down
          denv up
    fi

}

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

### Messages ###################################################################


PGADMIN_DEFAULT_EMAIL=webmaster@advinow.com
PGADMIN_DEFAULT_PASSWORD=P@55w0rd


echo "Shared Environment: Docker shortcuts loaded."

