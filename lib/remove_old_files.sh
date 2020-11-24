# remove all old files in $1 that are greater than $2 hours old
function remove_old_files() {
  for file in $1/*
  do
    # on comet
    #lastModificationSeconds=$(date +%s -r $file)
    #currentSeconds=$(date +%s)

    # osx
    lastModificationSeconds=$(date -r $file +%s)
    currentSeconds=$(date +%s)

    elapsedSeconds=$((currentSeconds - lastModificationSeconds))
    if [[ $elapsedSeconds > $2 ]]; then
      rm $file
    fi
  done
}
