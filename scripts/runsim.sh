### Example bash script to run, syntax is specific to the Hyak supercomputer at the University of Washington

#!/bin/bash

## specifications
#PBS -l nodes=1:ppn=16,mem=40gb,feature=16core
#PBS -l walltime=180:00:00

## Specify model name
#PBS -N 04a.RaceAllEq.p05

## Put the STDOUT and STDERR from jobs into the below directory in a single file 
#PBS -o /gscratch/csde/goodreau/Mardham/04a.RaceAllEq.p05/
#PBS -e /gscratch/csde/goodreau/Mardham/04a.RaceAllEq.p05/
#PBS -j oe

## Specify working directory
#PBS -d /gscratch/csde/goodreau/Mardham/04a.RaceAllEq.p05/

module load r_3.2.0

R CMD BATCH --vanilla 03.sim.R 03.sim.Rout
