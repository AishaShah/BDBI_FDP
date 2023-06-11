#!/bin/bash
#SBATCH --job-name="28S_Clu_aln_with_consensus"
#SBATCH --output=slurm.%j.out
#SBATCH --error=slurm.%j.err
#SBATCH --mail-type=end
#SBATCH --mail-user=aisha.shah@alum.esci.upf.edu
#SBATCH --time=02:00:00
#SBATCH --qos=debug
#SBATCH -N 2
#SBATCH -n 2
module load clustal

clustalo -i 28S_fasta_consensus28S.fa --outfmt=a2m -o 28S_fasta_trimmed.aln --threads=8 --distmat-out=distance_matrix_28S_with_consensus_trimmed.out --full

