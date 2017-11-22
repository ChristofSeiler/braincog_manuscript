#!/bin/bash
#
#all commands that start with SBATCH contain commands that are just used by SLURM for scheduling
#################
#time you think you need; default is one hour
#in minutes in this case
#SBATCH --time=04:00:00
#################
#quality of service; think of it as job priority
#SBATCH --qos=normal
#################
#number of nodes you are requesting
#SBATCH --nodes=1
#################
#memory per node; default is 4000 MB per CPU
#SBATCH --mem=6000
#you could use --mem-per-cpu; they mean what we are calling cores
#################
#task to run per node; each node has 16 cores, "task" is "core" really
#SBATCH --ntasks=4
#don't use --cpus-per-task on this cluster
#################
#get emailed about job BEGIN, END, and FAIL
###SBATCH --mail-type=ALL
#################
#who to send email to; please change to your email
###SBATCH  --mail-user=<YOUR_ACTUAL_EMAIL_ADDRESS>
#################

module load R/3.2.0

# reference image
fixed=$1

# moving image
moving=$2

# moving prefix
movingPrefix=$3

echo Demons registration: $fixed $moving $movingPrefix
rpiLCClogDemons -f $fixed -m $moving -d 5 -r 2 -R 1 -C 3 -a 30x20x10 -x 0 -b 0.2 -S 0.15 -V --output-transform ${movingPrefix}SVF.nii.gz --output-image ${movingPrefix}Demons.nii.gz --output-displacement-field ${movingPrefix}DVF.nii.gz

echo Compute logarithm of Jacobian determinant: $moving $output
SVFLogJacobian -i ${movingPrefix}SVF.nii.gz -o ${movingPrefix}LogJacDet.nii.gz

# take voxelwise exponential
echo Compute Jacobian determinant: $output $outputExp
Rscript VoxelwiseExp.R ${movingPrefix}LogJacDet.nii.gz ${movingPrefix}JacDet.nii.gz
