#!/bin/bash 
#SBATCH --job-name=mc2fortomo
#SBATCH --partition=XXX ###GPU partition names###
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --output=mc2.%j.%N.out 
#SBATCH --error=mc2.%j.%N.err 
#SBATCH --time=24:00:00
#SBATCH --mail-user=xxx@xxxx.com ###your email address###
#SBATCH --mail-type=ALL

ml system libtiff biology imod
export LD_LIBARARY_PATH=/libarary/path/to/motioncor2_01_30_2017:$LD_LIBRARY_PATH
module add cuda/11.5.0
IN_DIR="$1"
OUT_DIR="$2"
PixSize="$3"
Dose="$4"
###rename the gain ref as CountRef*.mrc###
echo "Here we go..."
if [[ -f "$IN_DIR/CountRef.mrc" ]]
then
        echo "CountRef is mrc"
else
        echo "CountRef is DM4"
        for file in $IN_DIR/CountRef*.dm4
        do
        dm2mrc $file $IN_DIR/CountRef.mrc
done
fi
for IMAGE in $IN_DIR/*.tif; do
  BASE=$(basename $IMAGE)
  if [ -f "$OUT_DIR/${BASE%.*}.mrc" ]; then
        echo "$OUT_DIR/${BASE%.*}.mrc exists"
  else
        /path/to/software/MotionCor2_1.6.3_Cuda115_Feb18_2023 -InTiff "$IMAGE" -OutMrc "$OUT_DIR/${BASE%.*}.mrc" -Gain $IN_DIR/*CountRef*.mrc -Patch 5 5 -FmRef 5 -Bft 300 -kV 300 -PixSize $PixSize -Throw 1 -FtBin 1 -Gpu 0 -SplitSum 1 ###will out put full, even, odd###
  fi done
if [ $? -eq 0 ]
then
    echo "Success, looks good!"
else
    echo "Finished with errors :("
fi