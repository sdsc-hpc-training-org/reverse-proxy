#!/bin/bash
## ======================================================================
## This is an example batch script which can be submitted as part of a
## reverse proxy jupyter notebook. This batch script creates the jupyter
## notebook on a compute node, while the start notebook script is used to
## submit this batch script. You should never submit this batch script on
## its own, e.g. `sbatch batch_assumport.sh`. Don't do that :). You can
## specify this particluar batch script by using the -b flag, e.g.
## ./start_notebook.sh -b batch/batch_jupyterlab.sh
## ======================================================================

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH -p compute
#SBATCH --wait 0

# DO NOT EDIT BELOW THIS LINE

API_TOKEN=$1
TMPFILE=$2

echo "Api_token: $API_TOKEN"
echo "Tempfile: $TMPFILE"

# Get the comet node's IP

IP="$(hostname -s).local"
jupyter notebook --ip $IP --config "$TMPFILE".py --no-browser &

echo "Started Jupyter notebook"

PORT="8888"

echo "Port: $PORT"

# redeem the API_TOKEN given the untaken port
url='"https://manage.comet-user-content.sdsc.edu/redeemtoken.cgi?token=$API_TOKEN&port=$PORT"'

# Redeem the API_TOKEN
eval curl $url

# waits for all child processes to complete, which means it waits for the jupyter notebook to be terminated
wait
