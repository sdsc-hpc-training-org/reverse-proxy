# SDSC Reverse Proxy Service

## Notes:
* we should remind people about software dependencies: 
   * loading modules and environments: this works by
       * installing module and reloading the notebook, you don't have kill the job.

The reverse proxy service relies on you handling your own python package installation. It was designed with Anaconda in mind {?Miniconda?}. You can install Anaconda on your login node using wget: `wget https://repo.continuum.io/archive/Anaconda3-2018.12-Linux-x86_64.sh`.

Many data scientists are very familiar with Anaconda. If not, check it out [here](https://www.anaconda.com/products/individual)

You can install python packages in a conda environment while your notebook is running. This is useful if you forgot a package, you won't have to worry about cancelling and restarting your job before installing.

### Usage: ./start_notebook.sh [-p <string>] [-d <string>] [-A <string>] [time]
  
```
Default Dir: /home/$USER
Default Allocation is your sbatch default allocation
Default Time is 30 mins
```
(If you don't know what $USER is, try this command: `echo $USER`. This is just your comet username)

## Some common examples
Start a notebook with all defaults
`./start_notebook`

Start a notebook in the debug queue
`./start_notebook -d ~ -p debug 30`

Start a notebook in the compute queue
`./start_notebook -d ~ -A ddp363 -p compute 60`

## Arguments
* [-p <string>] the partition to wait for. debug or compute
* [-d <string>] the top-level directory of your jupyter notebook
* [-A <string>] the project allocation to be used for this notebook
* [time]        the amount of time in minutes to run this notebook for
  
## Example Notebooks
 
* list of notebooks here that are in repo
