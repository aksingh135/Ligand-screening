#!/bin/bash
#SBATCH -Adocking
#SBATCH --account=gt****
#SBATCH -N10 --ntasks-per-node=14
#SBATCH -thr:min:sec
#SBATCH -qinferno
#SBATCH -oReport-%dock_neg.out
#SBATCH --mail-type=BEGIN,END,FAIL #SBATCH --mail-user=asingh970@gatech.edu
srun bash ./run_vina.sh
