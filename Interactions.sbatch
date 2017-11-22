#!/bin/bash

#SBATCH --job-name=Simulations
#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12GB
##SBATCH --partition=stat
##SBATCH --partition=hns

if [[ "$SHERLOCK" == "1" ]]; then
	echo "Running on Sherlock 1.0"
	module load R/3.3.0
elif [[ "$SHERLOCK" == "2" ]]; then
	echo "Running on Sherlock 2.0"
	module load fftw/3.3.6
	module load R
else
	echo "Uh-oh, not sure where we are..."
	exit 1
fi

seed=$1
R -e "rmarkdown::render('Interactions.Rmd',output_file = 'Interactions_${seed}.html',params = list(seed = '${seed}'))"
