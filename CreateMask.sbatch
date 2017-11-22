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

module load fsl
module load R/3.2.0

# our mean
mean=$1

# affine registration
flirt -in $FSLDIR/data/standard/MNI152_T1_1mm_brain.nii.gz -ref $mean -out FSL.Template.Brain.To.Mean.nii.gz -omat FSL.Template.Brain.To.Mean.mat

# define atlases
atlas_cort=$FSLDIR/data/atlases/HarvardOxford/HarvardOxford-cort-maxprob-thr25-1mm.nii.gz
atlas_cort_to_mean=FSL.Atlas.Cort.To.Mean.nii.gz

atlas_sub_cort=$FSLDIR/data/atlases/HarvardOxford/HarvardOxford-sub-maxprob-thr25-1mm.nii.gz
atlas_sub_cort_to_mean=FSL.Atlas.Sub.Cort.To.Mean.nii.gz

atlas_cerebellum=$FSLDIR/data/atlases/Cerebellum/Cerebellum-MNIfnirt-maxprob-thr25-1mm.nii.gz
atlas_cerebellum_to_mean=FSL.Atlas.Cerebellum.To.Mean.nii.gz

# affine registration
flirt -in $atlas_cort -ref $mean -out $atlas_cort_to_mean -init FSL.Template.Brain.To.Mean.mat -applyxfm -interp nearestneighbour
flirt -in $atlas_sub_cort -ref $mean -out $atlas_sub_cort_to_mean -init FSL.Template.Brain.To.Mean.mat -applyxfm -interp nearestneighbour
flirt -in $atlas_cerebellum -ref $mean -out $atlas_cerebellum_to_mean -init FSL.Template.Brain.To.Mean.mat -applyxfm -interp nearestneighbour

# tissue segmentation to create mask separate grey and white matter mask
ext=.nii.gz
extLength=${#ext}
(( nameLength = ${#mean} - $extLength ))
meanPrefix=${mean:0:nameLength}

bet $mean ${meanPrefix}.Brain.nii.gz -m
mv ${meanPrefix}.Brain_mask.nii.gz Brain.Matter.nii.gz
fast ${meanPrefix}.Brain.nii.gz
Rscript ImageThresholdRange.R ${meanPrefix}.Brain_seg.nii.gz Gray.Matter.nii.gz 2 2
Rscript ImageThresholdRange.R ${meanPrefix}.Brain_seg.nii.gz White.Matter.nii.gz 3 3
