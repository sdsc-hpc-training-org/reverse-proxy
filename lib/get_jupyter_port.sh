## This function takes  one parameter, the PID of the jupyter notebook process
## The function returns the port which that jupyter notebook is running on.
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

