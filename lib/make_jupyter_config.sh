function make_jupyter_config () {
    config=$1
    token=$2
    root_dir=$3
    echo "c.NotebookApp.token = '$token'" | cat >> "$config"
    if [[ $root_dir = "" ]]; then
        root_dir=/home/$USER/
    fi
    echo "c.NotebookApp.notebook_dir = '$root_dir'" | cat >> "$config"
    echo "c.NotebookApp.allow_origin = '*'" | cat >> "$config"
    #echo "c.NotebookApp.allow_remote_access = True" | cat >> "$config"
}
