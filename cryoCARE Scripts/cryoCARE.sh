#!/bin/bash 
#SBATCH --job-name=cryoCARE
#SBATCH --partition=XXX ###GPU partition names###
#SBATCH --nodes=1
#SBATCH --gres=gpu:4
#SBATCH --mem=118G
#SBATCH --output=cryocare.%j.%N.out 
#SBATCH --error=cryocare.%j.%N.err 
#SBATCH --time=168:00:00
#SBATCH --mail-user=xxx@xxxx.com ###your email address###
#SBATCH --mail-type=ALL

date
source /path/to/miniconda3/etc/profile.d/conda.sh ##install the cryoCARE by conda###
conda activate cryocare_11

IN_DIR="$1"
for TOMO in $IN_DIR/*; do
BASE=$(basename $TOMO)
cd $TOMO; 
echo "Working on $TOMO"
even="/path/even/tomo/${IN_DIR}_even/${BASE}/${BASE}_rec.mrc"
odd="/path/odd/tomo/${IN_DIR}_odd/${BASE}/${BASE}_rec.mrc"
echo '{
  "even": [
    "'"$even"'"
  ],
  "odd": [
    "'"$odd"'"
  ],
  "patch_shape": [
    64,
    64,
    64
  ],
"num_slices": 1200,
  "split": 0.9,
  "tilt_axis": "Z",
  "n_normalization_samples": 500,
  "path": "cryocare_trained"
}' > train_data_config.json
echo '{
  "train_data": "cryocare_trained",
  "epochs": 100,
  "steps_per_epoch": 200,
  "batch_size": 16,
  "unet_kern_size": 3,
  "unet_n_depth": 3,
  "unet_n_first": 16,
  "learning_rate": 0.0004,
  "model_name": "model_name",
  "path": "cryocare_trained",
  "gpu_id": [0,1,2,3]
}' > train_config.json
echo '{
  "path": "cryocare_trained/model_name.tar.gz",
  "even": "'"$even"'",
  "odd": "'"$odd"'",
  "n_tiles": [4,4,4],
  "output": "cryocare_denoised",
  "overwrite": "False",
  "gpu_id": 0
}' > predict_config.json
cryoCARE_extract_train_data.py --conf train_data_config.json
cryoCARE_train.py --conf train_config.json
cryoCARE_predict.py --conf predict_config.json
cd ../..
done
date
