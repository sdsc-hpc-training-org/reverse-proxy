#!/bin/bash
function get_port() {

    PID=$1
    NETSTAT_INFO=""
    while [ -z "$NETSTAT_INFO" ]
    do
        NETSTAT_INFO=$(netstat -ltnp | grep $PID)
        for chunk in $NETSTAT_INFO
        do
            POSSIBLE_PORT=$(echo $chunk | tail -c 5)
            if [[ $POSSIBLE_PORT =~ ^[0-9]{4}*$ ]]; then
                echo $POSSIBLE_PORT
            fi
        done
    done
}

get_port $1
