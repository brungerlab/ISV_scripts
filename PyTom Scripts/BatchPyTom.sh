#!/bin/bash 
#SBATCH --job-name=pytom_tm
#SBATCH --partition=XXX ###GPU partition names###
#SBATCH --nodes=1
#SBATCH --gres=gpu:4
#SBATCH --mem=118G
#SBATCH --output=pytom.%j.%N.out 
#SBATCH --error=pytom.%j.%N.err 
#SBATCH --time=168:00:00
#SBATCH --mail-user=xxx@xxxx.com ###your email address###
#SBATCH --mail-type=ALL

date
source /path/to/miniconda3/etc/profile.d/conda.sh ##install the PyTom_tm by conda###
conda activate pytom_tm

IN_DIR="$1"

for TOMO in $IN_DIR/*; do
BASE=$(basename $TOMO)
cd $TOMO; echo "Working on $TOMO"
mkdir pytom;

pytom_match_template.py -t /path/to/the/template/VATPase_filter_invt_binvol.mrc -m /path/to/the/mask/VATPase_cylinder_mask.mrc -v "${BASE}_full_rec.mrc" -d "/path/to/full/tomo/${IN_DIR}/${BASE}/pytom/" -a "${BASE}.rawtlt" --high-pass 500 --per-tilt-weighting --non-spherical-mask --angular-search 7.00 -g 0 1 2 3

pytom_estimate_roc.py -j "pytom/${BASE}_full_rec_job.json" -n 200 -r 18 --bins 8 --crop-plot > "pytom/${BASE}_roc.log"

pytom_extract_candidates.py -j "pytom/${BASE}_full_rec_job.json" -n 200 -r 18 -c -1

awk '{if(NR > 17) print $1"\t"$2"\t"$3}' "pytom/${BASE}_full_rec_particles.star" > "pytom/${BASE}_full_rec_coordinates.txt"

awk '{print $1*2, $2*2, $3*2}' "pytom/${BASE}_full_rec_coordinates.txt" > "pytom/${BASE}_full_rec_coordinates2.txt"

cd ../..
done
Date
