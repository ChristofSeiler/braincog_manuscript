#!/bin/bash
#
#all commands that start with SBATCH contain commands that are just used by SLURM for scheduling
#################
#time you think you need; default is one hour
#in minutes in this case
#SBATCH --time=01:00:00
#################
#quality of service; think of it as job priority
#SBATCH --qos=normal
#################
#number of nodes you are requesting
#SBATCH --nodes=1
#################
#memory per node; default is 4000 MB per CPU
#SBATCH --mem=4000
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

# load modules
module load fsl

# set arguments
moving=$1
movingPrefix=$2

# N4 bias field correction
echo N4 bias field correction
./N4BiasFieldCorrection/N4BiasFieldCorrection $moving ${movingPrefix}N4.nii.gz

# skull stripping
echo Skull stripping
bet ${movingPrefix}N4.nii.gz ${movingPrefix}N4.Brain.nii.gz -m -f 0.2
##runROBEX.sh $moving ${movingPrefix}Brain.nii.gz ${movingPrefix}Brain.Mask.nii.gz
