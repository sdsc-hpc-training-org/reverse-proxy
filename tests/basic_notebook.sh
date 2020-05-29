#!/bin/bash
## ======================================================================
## This is an example batch script which can be submitted as part of a
## reverse proxy jupyter notebook. This batch script creates the jupyter
## notebook on a compute node, while the start notebook script is used to
## submit this batch script. You should never submit this batch script on
## its own, e.g. `sbatch batch_notebook.sh`. Don't do that :). You can
## specify this particluar batch script by using the -b flag, e.g.
## ./start_notebook.sh -b batch/batch_jupyterlab.sh
## ======================================================================

## This function takes  one parameter, the PID of the jupyter notebook process
## The function returns the port which that jupyter notebook is running on.
function get_jupyter_port() {
    PID=$1
    GREP_OUT=""
    while [ -z $GREP_OUT ]; do
        GREP_OUT=$(grep -lr $PID /home/$USER/.local/share/jupyter/runtime/)
    done
    PORT=$(cat $GREP_OUT | grep "port")
    PORT=${PORT#*'"port":'}
    PORT=${PORT:0:5}
    echo $PORT
}


#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH -p compute
#SBATCH --wait 0

# DO NOT EDIT BELOW THIS LINE

API_TOKEN=$1
TMPFILE=$2

# Get the comet node's IP (really just the hostname)
IP="$(hostname -s)"
jupyter notebook --ip $IP --config "$TMPFILE".py &

JUPYTER_PID=$!
echo "Jupyter PID: $JUPYTER_PID"
PORT=$(get_jupyter_port $JUPYTER_PID)

# redeem the API_TOKEN given the untaken port
url='"https://manage.comet-user-content.sdsc.edu/redeemtoken.cgi?token=$API_TOKEN&port=$PORT"'

# Redeem the API_TOKEN
eval curl $url

# waits for all child processes to complete, which means it waits for the jupyter notebook to be terminated
wait
