#!/bin/bash
## ======================================================================
## Usage
##     ./start_notebook.sh [-p <string>] [-d <string>] [-A <string>] [-b <string>] [-t time]
## 
##       -d: Default Dir is /home/$USER
##       -A: Default Allocation is your sbatch default allocation
##       -b: Default batch script is ./batch/batch_notebook.sh
##       -t: Default time is 30 minutes
##       
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
jupyter notebook --ip $IP --config "$TMPFILE".py | tee $TMPFILE &

# Waits for the notebook to start and gets the port
PORT=""
while [ -z "$PORT" ]
do
    PORT=$(grep '1\.' $TMPFILE)
    PORT=${PORT#*".local:"}
    PORT=${PORT:0:4}
done

echo "Port: $PORT"

# redeem the API_TOKEN given the untaken port
url='"https://manage.comet-user-content.sdsc.edu/redeemtoken.cgi?token=$API_TOKEN&port=$PORT"'

# Redeem the API_TOKEN
eval curl $url | tee -a $TMPFILE

# waits for all child processes to complete, which means it waits for the jupyter notebook to be terminated
wait
