# Cleans up the ~/.jupyter/rps directory
function cleanup() {
    slurm_id=$1
    config_path=$2
    #echo "Cleanup $slurm_id $config_path"
    # while the slurm id is available, do not remove the config file
    while true;
    do
        sq=$(squeue -h -u $USER -j $slurm_id 2> /dev/null)
        if [[ $? = 1 || $sq = "" && $(ls $config_path) != "" ]];  then
            # the slurm id is invalid which means you can remove the config path
            # or the slurm id is valid but nothing is found.
            rm $config_path &> /dev/null
            exit 0
        fi
        sleep 10
    done
}
