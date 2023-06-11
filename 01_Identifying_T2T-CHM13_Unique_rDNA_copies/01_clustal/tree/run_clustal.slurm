#!/bin/bash
#SBATCH --job-name="consensus_Uniq_Clu_aln"
#SBATCH --output=slurm.%j.out
#SBATCH --error=slurm.%j.err
#SBATCH --mail-type=end
#SBATCH --mail-user=aisha.shah@alum.esci.upf.edu
#SBATCH --time=02:00:00
#SBATCH --qos=debug
#SBATCH -N 2
#SBATCH -n 2
module load clustal

clustalo -i uniq_morphs_T2T_rRNA_with_uniq_consensus.aln --outfmt=a2m -o realign_uniq_morphs_T2T_rRNA_with_uniq_consensus2.aln --threads=8  --distmat-out=uniq_distances_2.out --guidetree-out=guide_tree2.out --clustering-out=clustering_file2.out --full 


