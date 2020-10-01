# Arg 1 is the time to parse
# any other args are invalid and will be ignored
parse_time() {
    IFS=':' read -ra TIME <<< "$1"
    IFS=' '
    if [ ${#TIME[*]} -ne 3 ]
    then
        if [ ${#TIME[*]} = 1 ]
        then
            if [ ${TIME[0]} -ge 60 ]
            then
                # then divide it up into hours, minutes, etc
                hrs=$(( ${TIME[0]}/60 ))
                min=$(( ${TIME[0]}%60 ))
                hrsiz=${#hrs}
                minsiz=${#min}
                if [ $hrsiz -lt 2 ]; then
                    hrs="0$hrs"
                fi
                if [ $minsiz -lt 2 ]; then
                    min="0$min"
                fi
                echo "$hrs:$min:00"
                return 0
            elif [ ${TIME} -le 0 ]
            then
                echo "Error: Negative Time Invalid"
                exit 1
            else
                echo "00:${TIME[0]}:00"
                return 0
            fi
        else
            echo "Error: Invalid time format"
            exit 1
        fi
    else
        echo $1
        return 1
    fi
}


