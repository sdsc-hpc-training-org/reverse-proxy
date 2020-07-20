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

## This function takes  one parameter, the PID of the jupyter notebook process
## The function returns the port which that jupyter notebook is running on.
## DON'T EDIT THIS FUNCTION
function get_jupyter_port() {
    PID=$1
    GREP_OUT=""
    while [[ -z $GREP_OUT ]]; do
        sleep 1
        PORT_REGEX='^\s*\"port\":\s*\d+,$'
        JUP_PATH=$(jupyter --runtime-dir)
        GREP_OUT=$(grep -P $PORT_REGEX $(grep -lr $PID $JUP_PATH))
    done
    PORT=${GREP_OUT#*'"port":'}
    PORT=${PORT:0:5}
    echo $PORT
}


## Add your own Slurm directives here. They will overwrite any other
## arguments you passed into the start_notebook script

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --wait 0

## You can add your own modules here.
module purge
export MODULEPATH=$MODULEPATH:/share/apps/compute/modulefiles/applications

## adding spark for the summer institute specifically
module load spark/2.4.0


## You can use your own conda environment, but make sure it has the jupyter command installed.
echo "Jupyter location before activating shared env: $(which jupyter)"

# Activate the Summer Institute 2019 shared conda environment
source /share/apps/compute/si2019/miniconda3/etc/profile.d/conda.sh
conda activate
echo "Jupyter location after activating shared env: $(which jupyter)"

# DO NOT EDIT BELOW THIS LINE

# These variables are passed into the environment by `start_notebook`
echo "RPS token: $api_token"
echo "Config path: $config"

# Get the comet node's IP (really just the hostname)
IP="$(hostname -s).local"
jupyter notebook --ip $IP --config $config --no-browser &

# the last pid is stored in this variable
JUPYTER_PID=$!
PORT=$(get_jupyter_port $JUPYTER_PID)

# redeem the api_token given the untaken port
url='"https://manage.comet-user-content.sdsc.edu/redeemtoken.cgi?token=$api_token&port=$PORT"'

# Redeem the api_token
eval curl $url

# try to remove the config file.
rm $config

# waits for all child processes to complete, which means it waits for the jupyter notebook to be terminated
wait
