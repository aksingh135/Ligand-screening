#!/bin/bash
#SBATCH -Adocking
#SBATCH --account=gts-pppy3
#SBATCH -N10 --ntasks-per-node=14
#SBATCH -t26:30:00
#SBATCH -qinferno
#SBATCH -oReport-%dock_neg.out
#SBATCH --mail-type=BEGIN,END,FAIL #SBATCH --mail-user=asingh970@gatech.edu
srun bash ./run_vina_pos.sh
