PoisosonFitting.py

This script is developed to fit poisson distributions for the copy numbers of intact V-ATPase or V0-only V-ATPase assemblies for ISVs from wild-type and Syp-/- mouse brains.
To run this script, install dependent modules (matplotlib:3.7.1, scipy:1.10.1, numpy:1.24.2). 

For installation, it is recommended to use conda:

conda create -n poissonfit

conda activate poissonfit

conda install pip

pip install matplotlib

pip install scipy

pip install numpy

To run the script, type

python PoissonFitting.py

To change the input, edit PoissonFitting.py and change the following lines:

allWT0 = np.array([2228])  # number of WT ISVs without intact V-ATPase 
allKO0 = np.array([927])   # number of KO ISVs without intact V-ATPase
allWTExp =  np.array([945, 290, 72, 15, 4,0,0, 0])   # array with observed copy numbers (>=1) of intact V-ATPases in WT ISVs
allKOExp =  np.array([688 , 419, 218, 79,28, 11 ,6, 4])   # array with observed copy numbers (>=1) of intact V-ATPases in for KO ISVs
x = np.array([1,2,3,4,5,6,7,8])   # array with min and max copy numbers 

...

    allKO0 = np.array([233])  # number of KO ISVs without V0-only V-ATPase
    allKOExp =  np.array([130, 46, 11, 1, 0,0,0, 0]) # array with observed copy numbers (>=1) of V0-only V-ATPases in KO ISVs
...
     allWT0 = np.array([197]) # number of WT ISVs without V0-only V-ATPase
     allWTExp =  np.array([86, 18, 2, 0, 0,0,0, 0]) # array with observed copy numbers (>=1) of V0-only V-ATPases in WT ISVs


The output will be:

intact V-ATPase from WT:
the scaled factor: 2822.68, the lambda:0.62
average residue 4.66

intact V-ATPase from syp-/-:
the scaled factor: 1921.26, the lambda:1.32
total residue 14.85

V0-only from WT:
the scaled factor: 372.93, the lambda:0.71
average residue 0.34

V0-only from syp-/-:
the scaled factor: 313.77, the lambda:0.42
average residue 0.20

Plots will be in the .svg files.






