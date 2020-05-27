#!/bin/bash
# This script is a work in progress.

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
url='"https://manage.comet-user-content.sdsc.edu/redeemtoken.cgi?token=$API_TOKEN&port=8888"'

eval curl $url && singularity exec /share/apps/compute/singularity/images/tensorflow/tensorflow-cpu.simg jupyter notebook --no-browser --ip $IP --config "$TMPFILE".py

# Waits for the notebook to start and gets the port
PORT=""
while [ -z "$PORT" ]
do
    PORT=$(grep '1\.' $TMPFILE)
    PORT=${PORT#*".local:"}
    PORT=${PORT:0:4}
done

# redeem the API_TOKEN given the untaken port

# Redeem the API_TOKEN

# waits for all child processes to complete, which means it waits for the jupyter notebook to be terminated
wait
