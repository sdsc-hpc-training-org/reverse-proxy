#!/bin/bash

# Argument 1 should be the Reverse Proxy API token
# Argument 2 should be the tmpfile path

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH -p debug
#SBATCH -o /dev/null
#SBATCH --wait 0

# DO NOT EDIT BELOW THIS LINE

API_TOKEN=$1
TMPFILE=$2
# Get the comet node's IP
IP="$(hostname -s).local"
#echo "Tempfile: $TMPFILE"
jupyter notebook --ip $IP --config "$TMPFILE".py | tee $TMPFILE &

# Waits for the notebook to start and gets the port
PORT=""
while [ -z "$PORT" ]
do
    PORT=$(grep '1\.' $TMPFILE)
    PORT=${PORT#*".local:"}
    PORT=${PORT:0:4}
done

# redeem the API_TOKEN given the untaken port
url='"https://manage.comet-user-content.sdsc.edu/redeemtoken.cgi?token=$API_TOKEN&port=$PORT"'

# Redeem the API_TOKEN
eval curl $url | tee -a $TMPFILE

# waits for all child processes to complete, which means it waits for the jupyter notebook to be terminated
wait
