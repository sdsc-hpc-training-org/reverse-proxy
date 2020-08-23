#!/bin/bash
## ======================================================================
## This is an example batch script which can be submitted as part of a
## reverse proxy jupyter notebook. This batch script creates the jupyter
## notebook on a compute node, while the start notebook script is used to
## submit this batch script. You should never submit this batch script on
## its own, e.g. `sbatch batch_notebook.sh`. Don't do that :). You can
## specify this particluar batch script by using the -b flag, e.g.
## ./start_notebook.sh -b batch/batch_notebook.sh
## ======================================================================

## You can add your own slurm directives here, but they will override
## anything you gave to the start_notebook script like the time, partition, etc
#PBS -l nodes=1
#PBS -o jupyterlab-torque.out
#PBS -e jupyterlab-torque.out

# DO NOT EDIT BELOW THIS LINE
#PBS -V
source $start_root/lib/get_jupyter_port.sh

# Get the comet node's IP (really just the hostname)
IP="$(hostname -s).local"

# NOTE: You will need to have jupyterlab installed on your system.
if [[  $(which jupyterlab 2> /dev/null) = "" ]]
then
    echo "Jupyter lab can be installed using 'conda install jupyterlab'"
fi

jupyter lab --ip $IP --config $config --no-browser &

# the last pid is stored in this variable
JUPYTER_PID=$!
PORT=$(get_jupyter_port $JUPYTER_PID)

# redeem the api_token given the untaken port
url='"https://manage.$cluster-user-content.sdsc.edu/redeemtoken.cgi?token=$api_token&port=$PORT"'

# Redeem the api_token
eval curl $url

# try to remove the config file.
rm $config

# waits for all child processes to complete, which means it waits for the jupyter notebook to be terminated
wait
