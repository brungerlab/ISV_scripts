#!/bin/bash
#SBATCH --job-name=driftcomb
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=1
#SBATCH --mem=92G
#SBATCH ###CPU partition names###
#SBATCH --output=driftcomb.%j.%N.out
#SBATCH --error=driftcomb.%j.%N.err
#SBATCH --mail-user=xxx@xxxx.com ###your email address###
#SBATCH --mail-type=ALL

ml add python
ml add libjpeg-turbo
ml biology imod

Mdocs="$1" ##This is the directory containing the Mdocs
Correct="$2" ##This is the directory of the MC2-corrected files
Comb="$3" ##This is where you want things to end up
if [ ! -d $Comb ]; then mkdir $Comb; fi


for i in "$Mdocs"/*.mrc.mdoc
do
FILE="${i%.mrc.mdoc}"
f="$(basename -- $FILE)"
python /path/to/drift_combine_final_K3.py "$Correct"/ "$Mdocs"/"$f".mrc.mdoc "$Comb"/"$f".st
mkdir "$Comb"/"$f"
mv "$Comb"/"$f".* "$Comb"/"$f"/
done
