#!/bin/bash
#SBATCH --job-name="Clustal_aln"
#SBATCH --output=slurm.%A_%a.out
#SBATCH --error=slurm.%A_%a.err
#SBATCH --mail-type=end
#SBATCH --mail-user=aisha.shah@alum.esci.upf.edu
#SBATCH --time=02:00:00
#SBATCH --qos=bsc_ls
#SBATCH -N 1
#SBATCH --cpus-per-task=16



module load clustal
clustalo -i T2T_rDNA45S.consensus.24_uniq_morphs.fa -o T2T_rDNA45S.consensus.24_uniq_morphs.aln --threads=8 --distmat-out=T2T_rDNA45S.consensus.24_uniq_morphs.distances.out --percent-id --full

