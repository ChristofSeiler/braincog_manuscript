#!/bin/bash

# Tensor-Based Morphometry

ext=FSPGR.nii.gz
extLength=${#ext}
filter=*${ext}
for moving in $filter
do
    (( nameLength = ${#moving} - $extLength ))
    movingPrefix=${moving:0:nameLength}

    echo Prepocessing: $movingPrefix
    sbatch Preprocessing.sbatch $moving ${movingPrefix}
done
