#!/bin/bash
## Determines whether the the command is available
## Arg 1: command to check
## Arg 2: Fail message
function check_available() {
    cmd=$1
    err_msg=$2
    if [[ $(which $cmd 2> /dev/null) != "" ]]; then
        return 0
    else
        echo "$cmd not found on compute node"
        echo $err_msg
        return 1
    fi
}
