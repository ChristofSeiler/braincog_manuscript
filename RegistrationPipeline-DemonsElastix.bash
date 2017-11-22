#!/bin/bash

template=GR_iteration_3/MYtemplate.nii.gz

# Tensor-Based Morphometry

ext=Ants.Affine.nii.gz
extLength=${#ext}
filter=*${ext}
for moving in $filter
do
    (( nameLength = ${#moving} - $extLength ))
    movingPrefix=${moving:0:nameLength}

    echo Demons: $movingPrefix
    sbatch DemonsRegistrationLCC.sbatch $template $moving ${movingPrefix}Demons.

    echo Elastix: $movingPrefix
    sbatch ElastixRegistrationBSpline.sbatch $template $moving ${movingPrefix}Elastix.
done
