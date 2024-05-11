#!/bin/bash
source /program/sbgrid.shrc
##locate to the folder has all the AF2 models' folder and extra density##
for file in *
do
      echo $file
      colores /path/to/extradensity.mrc ${file} -res 6.0 -cutoff 0.01 -deg 15.0 ##change res according to your map and cutoff is the contour level## 
      mkdir ../output/${file}_out
      mv col_* ../output/${file}_out/.
      mv 
done

