#!/bin/bash
#
#all commands that start with SBATCH contain commands that are just used by SLURM for scheduling
#################
#time you think you need; default is one hour
#in minutes in this case
#SBATCH --time=24:00:00
#################
#quality of service; think of it as job priority
#SBATCH --qos=normal
#################
#number of nodes you are requesting
#SBATCH --nodes=1
#################
#memory per node; default is 4000 MB per CPU
#SBATCH --mem=8000
#you could use --mem-per-cpu; they mean what we are calling cores
#################
#task to run per node; each node has 16 cores, "task" is "core" really
#SBATCH --ntasks=1
#don't use --cpus-per-task on this cluster
#################
#get emailed about job BEGIN, END, and FAIL
###SBATCH --mail-type=ALL
#################
#who to send email to; please change to your email
###SBATCH  --mail-user=<YOUR_ACTUAL_EMAIL_ADDRESS>
#################

# create affine initialization
$ANTSPATH/buildtemplateparallel.sh -d 3 -m 1x0x0 -t RA -s CC -c 5 -n 0 -o MY *.N4.Brain.nii.gz

# create template with affine intialization
$ANTSPATH/buildtemplateparallel.sh -d 3 -m 30x50x20 -t GR -s CC -c 5 -n 0 -z RA_iteration_3/MYtemplate.nii.gz -o MY *.N4.Brain.nii.gz
