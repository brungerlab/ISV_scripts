#!/bin/bash 
#SBATCH --job-name=aretomo
#SBATCH --partition=XXX ###GPU partition names###
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --output=aretomo.%j.%N.out 
#SBATCH --error=aretomo.%j.%N.err 
#SBATCH --mem=167G
#SBATCH --time=48:00:00
#SBATCH --mail-user=xxx@xxxx.com ###your email address###
#SBATCH --mail-type=ALL
date
ml biology imod
module add cuda/11.5.0
ml system libtiff
IN_DIR="$1"
echo '''The tilt series should be organized like this:
TiltSeries/XXX/: XXX.rawtlt XXX.st
TiltSeries/YYY/: YYY.rawtlt YYY.st


TiltSeries_even/XXX/: XXX.rawtlt XXX.st
TiltSeries_even/YYY/: YYY.rawtlt YYY.st


TiltSeries_odd/XXX/: XXX.rawtlt XXX.st
TiltSeries_odd/YYY/: YYY.rawtlt YYY.st
'''
###do full tomo first, since the even or odd tomo needs the full tomo reconstruction parameters###

for TOMO in $IN_DIR/*; do
BASE=$(basename $TOMO)

cd ../../"${IN_DIR}_even"/$BASE/
your/path/to/AreTomo_1.3.4_Cuda115_Feb22_2023 -InMrc "${BASE}.st" -OutMrc "${BASE}_ali.mrc" -VolZ 0 -OutBin 4 -AlnFile ../../$TOMO/"${BASE}.st.aln" -PixSize 1.111
tilt -TILTFILE "../../$TOMO/${BASE}_ali_Imod/${BASE}.tlt" -IMAGEBINNED 4 -THICKNESS 1500 -RADIAL 0.35,0.035 -FULLIMAGE 4096,4096 -FakeSIRTiterations 20 "${BASE}_ali.mrc" "${BASE}_rec.mrc"
echo "even done"


cd ../../"${IN_DIR}_odd"/$BASE/
your/path/to/AreTomo_1.3.4_Cuda115_Feb22_2023 -InMrc "${BASE}.st" -OutMrc "${BASE}_ali.mrc" -VolZ 0 -OutBin 4 -AlnFile ../../$TOMO/"${BASE}.st.aln" -PixSize 1.111
tilt -TILTFILE "../../$TOMO/${BASE}_ali_Imod/${BASE}.tlt" -IMAGEBINNED 4 -THICKNESS 1500 -RADIAL 0.35,0.035 -FULLIMAGE 4096,4096 -FakeSIRTiterations 20 "${BASE}_ali.mrc" "${BASE}_rec.mrc"
echo "odd done"
cd ../..
done
date
