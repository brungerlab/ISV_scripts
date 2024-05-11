# Introduction

Script files and codes for CryoEM and CryoET data processing and analysis for Wang et al. (2024). Many of the shell (.sh) scripts are written for batch execution on the Sherlock Linux cluster at Stanford University using the Slurm workload manager. Please modify according to your location computing resources. 

## MotionCorrection Scripts

* BatchMotionCor2ForTomo.sh

This script is for motion correction using MotionCor2.

## DriftCombine Scripts

* BatchDriftComb.sh

This batch job runs a Python script that takes the motion-corrected frames and mdoc file information and creates tomogram stacks ordered from —degrees to +degrees.  

## AreTomo Scripts

* BatchAreTomo.sh

This AreTomo script is for aligning and reconstructing the full tomogram only.

* BatchAreTomoForCAREdenoise.sh

This AreTomo script aligns and reconstructs the even and odd tomograms for CryoCARE denoising using the full tomo reconstruction information.

## cryoCARE Scripts

* cryoCARE.sh

This cryoCARE script is for reconstructing the de-noised full tomogram only. The required parameter files are: train_config.json, train_data_config.json, and predict_config.json.

## CoLoRes Script

* colores.sh

This CoLoRes script evaluates the fit between models and maps.

## PyTom Scripts

* BatchPyTom.job

This PyTom script is for template matching (particle picking) of V-ATPases in tomograms.

## Rosetta Scripts

These scripts can be used for individual chain remodeling based on cryo-EM maps.

* asym_ref.sh

Change the resolution and absolute pathway parameters corresponding to the working directory.

asym_ref.xml: put in the same directory with asym_ref.sh

* run.job

Change the absolute pathway of asym_ref.sh corresponding to the working directory.

* submit_jobs.sh

Change the absolute pathway of run.job corresponding to the working directory, and it will submit 1199-1100=100 jobs on Sherlock, so be cautious to submit it to the lab node.

* extract_scores.sh

## Bootstrap Script

* bootstrap.R

This code, written in R, calculates the confidence intervals for the mean and median of the data using the Bootstrapping method.

## Poisson Fitting

* PoissonFitting.py

This Python script performs a least-square fit of a Poisson function to copy number distributions. See README.txt for instructions.



