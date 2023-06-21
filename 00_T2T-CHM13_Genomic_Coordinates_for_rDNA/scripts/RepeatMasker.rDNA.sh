#!/bin/bash

#SBATCH --job-name="test Repeat Masker"
#SBATCH --output=/gpfs/projects/bsc83/Data/assemblies/T2T/scripts/out/RepeatMasker.rDNA.%A.out
#SBATCH --error=/gpfs/projects/bsc83/Data/assemblies/T2T/scripts/err/RepeatMasker.rDNA.%A.err
#SBATCH --cpus-per-task=8
#SBATCH --ntasks=1
#SBATCH --qos=debug
#SBATCH --time=01:00:00
#SBATCH --constraint=highmem



# load modules
module load python/3.7.4 repeatmasker/4.1.1
path=/gpfs/projects/bsc83/Data/assemblies/T2T/RepeatMasker/Masked_rDNA45S_ShortRepeats
INFILE=/gpfs/projects/bsc83/Data/assemblies/T2T/T2T_rDNA/T2T_rDNA.fa



RepeatMasker  -species human -noint -norna -gff -dir /gpfs/projects/bsc83/Data/assemblies/T2T/RepeatMasker/Masked_rDNA45S_ShortRepeats -html /gpfs/projects/bsc83/Data/assemblies/T2T/T2T_rDNA/T2T_rDNA.fa

