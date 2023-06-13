#!/bin/bash
#SBATCH --job-name="Uniq_Clu_aln"
#SBATCH --output=slurm.%j.out
#SBATCH --error=slurm.%j.err
#SBATCH --mail-type=end
#SBATCH --mail-user=aisha.shah@alum.esci.upf.edu
#SBATCH --time=02:00:00
#SBATCH --qos=debug
#SBATCH -N 2
#SBATCH -n 2
module load clustal
cd 13kb/
clustalo -i uniq_morphs_T2T_rRNA_with_consensus_of_219.fa --outfmt=a2m -o uniq_morphs_T2T_rRNA_with_consensus_of_219.aln --threads=8  --distmat-out=uniq_morphs_T2T_rRNA_with_consensus_of_219.distances --guidetree-out=uniq_morphs_T2T_rRNA_with_consensus_of_219.tree --full --percent-id


