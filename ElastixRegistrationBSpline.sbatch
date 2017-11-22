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

# output folder
output=$3

# parameter file
param=Parameters_BSpline.txt

echo Registration: $fixed $moving
mkdir ${output}Output
elastix -f $fixed -m $moving -p $param -out ${output}Output

# compute full Jacobian maps
echo Compute Jacobian determinant
bSplineTransform=${output}Output/TransformParameters.0.txt
transformix -in $moving -tp $bSplineTransform -out ${output}Output -def all -jac all
mv ${output}Output/spatialJacobian.nii.gz ${output}JacDet.nii.gz
Rscript ~/Research/TurnerSyndrome/VoxelwiseLog.R ${output}JacDet.nii.gz ${output}LogJacDet.nii.gz
