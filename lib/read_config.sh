function read_config() {
  hostnameToMatch=$1
  awkout=$(awk '/^Host/{flag=1;next}flag{print}' .config |  sed -e 's/^[ \t]*//')
  line=0
  # this loops over all the lines
  host=()
  #echo Hostname to Match: $hostnameToMatch
  while IFS=$'\n' read -ra OUT; do
    # this should be one line
    if [ $((line%5)) -eq 0 ]; then
      # at some point could sort the host array
      # to allow users to add to config in any order
      [[ $hostnameToMatch =~ ${host[0]} ]] && echo ${host[@]}
      host=()
    fi

    for i in "${OUT[@]}"; do
      IFS=':' read -r key value <<< "$i"
      host+=($value)
      line=$((line + 1))
    done
  done <<< "$awkout"
  [[ $hostnameToMatch =~ ${host[0]} ]] && echo ${host[@]}
}

