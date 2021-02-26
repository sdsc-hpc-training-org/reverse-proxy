#!/bin/bash
##
## ======================================================================
## This is an example batch script which can be submitted as part of a
## reverse proxy jupyter notebook. This batch script creates the jupyter
## notebook on a compute node, while the start notebook script is used to
## submit this batch script. You should never submit this batch script on
## its own, e.g. `sbatch slurm-expanse/notebook.sh`. Don't do that :).
## You can specify this particluar batch script by using the -b flag, e.g.
## ./start-jupyter -b slurm-expanse/notebook.sh
## ======================================================================

## You can add your own slurm directives here, but they may override
## anything you gave to the start-jupyter script like the time, partition, etc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --export=ALL

## Environment
module purge
module load gpu
module load slurm
module load anaconda3
module load singularitypro

# DO NOT EDIT BELOW THIS LINE
source $start_root/lib/check_available.sh
source $start_root/lib/get_jupyter_port.sh
echo "Image: $image"

# Get the expanse node's IP (really just the hostname)
IP="$(hostname -s).eth.cluster"
check_available jupyter-notebook "Try 'conda install jupyter'" || exit 1
if [[ $image = "" ]]; then
    jupyter notebook --ip $IP --config $config --no-browser --notebook-dir $HOME &
else
    (singularity exec --cleanenv $image jupyter notebook --ip $IP --config $config --no-browser --notebook-dir $HOME ) &
fi

# get the pid of 'task 1', get shell running the previous singularity command
# the jupyter pid is stored in the variable $!
GREP_OUT=""
while [[ -z $GREP_OUT ]]; do
    sleep 1
    PORT_REGEX='^\s*\"port\":\s*\d+,$'
    JUP_PATH=$(jupyter --runtime-dir)
    RUNTIME_FILE="$(grep -lr $jupyter_token $JUP_PATH)"
    GREP_OUT=$(grep -P $PORT_REGEX $RUNTIME_FILE)
done
PORT=${GREP_OUT#*'"port": '}
PORT=${PORT:0:4}

# redeem the api_token given the untaken port
url='"https://manage.$endpoint/redeemtoken.cgi?token=$api_token&port=$PORT"'

# Redeem the api_token
eval curl $url

# try to remove the config file.
rm $config

# waits for all child processes to complete, which means it waits for the jupyter notebook to be terminated
wait
