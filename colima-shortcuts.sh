#!/bin/bash

function colima_start() {
    colima start --cpu 4 --memory 12 --disk 40
}
alias cstart='colima_start'

function colima_stop() {
    colima stop
}
alias cstop='colima_stop'

function is_colima_running() {
    cpid=`ps aux | pgrep colima`
    re='^[0-9]+$'
    if ! [[ $cpid =~ $re ]] ; then
        dpid=`ps aux | grep docker`
        if ! [[ $dpid =~ $re ]] ; then
            echo "Neither Docker or Colima is running"
        else
            echo "Docker is running ($dpid)"
        fi
    else
        echo "Colima is running ($cpid)"
    fi
}
alias icr='is_colima_running'

function is_docker_running() {
    is_colima_running
}
alias idr='is_docker_running'

