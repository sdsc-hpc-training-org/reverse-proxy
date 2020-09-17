# Cleans up the ~/.jupyter/rps directory
function cleanup() {
    slurm_id=$1
    config_path=$2
    #echo "Cleanup $slurm_id $config_path"
    # while the slurm id is available, do not remove the config file
    while true;
    do
        sq=$(squeue -h -u $USER -j $slurm_id)
        if [[ $? = 1 || $sq = "" ]];  then
            # the slurm id is invalid which means you can remove the config path
            # or the slurm id is valid but nothing is found.
            echo "Removing $config_path"
            rm $config_path
            exit 0
        fi
    done
}
