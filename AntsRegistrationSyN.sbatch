#!/bin/bash
#
#all commands that start with SBATCH contain commands that are just used by SLURM for scheduling
#################
#time you think you need; default is one hour
#in minutes in this case
#SBATCH --time=02:00:00
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
#SBATCH --ntasks=4
#don't use --cpus-per-task on this cluster
#################
#get emailed about job BEGIN, END, and FAIL
###SBATCH --mail-type=ALL
#################
#who to send email to; please change to your email
###SBATCH  --mail-user=<YOUR_ACTUAL_EMAIL_ADDRESS>
#################

fixedImage=$1
movingImage=$2
output=$3
echo fixedImage=$fxedImage movingImage=$movingImage output=$output
$ANTSPATH/antsRegistrationSyN.sh -d 3 -f $fixedImage -m $movingImage -n 4 -o $output
$ANTSPATH/CreateJacobianDeterminantImage 3 ${output}1Warp.nii.gz ${output}JacDet.nii.gz
$ANTSPATH/CreateJacobianDeterminantImage 3 ${output}1Warp.nii.gz ${output}LogJacDet.nii.gz 1
$ANTSPATH/WarpImageMultiTransform 3 $movingImage ${output}Affine.nii.gz -R $fixedImage ${output}0GenericAffine.mat
