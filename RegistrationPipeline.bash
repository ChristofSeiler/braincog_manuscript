#!/bin/bash

template=GR_iteration_3/MYtemplate.nii.gz

# Tensor-Based Morphometry

ext=N4.Brain.nii.gz
extLength=${#ext}
filter=*${ext}
for moving in $filter
do
    (( nameLength = ${#moving} - $extLength ))
    movingPrefix=${moving:0:nameLength}

    echo Ants: $movingPrefix
    sbatch AntsRegistrationSyN.sbatch $template $moving ${movingPrefix}Ants.
done
