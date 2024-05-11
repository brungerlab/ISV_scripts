##run.job: need to change the absolute pathway of asym_ref.sh corresponding to the working directory.

#!/bin/bash
#SBATCH -p owners,normal,brunger
#SBATCH --time=12:00:00
#SBATCH --mem=10G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --job-name=model
source ~/.bashrc
bash ../../asym_ref.sh >run.log