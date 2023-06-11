#!/bin/bash
#SBATCH --job-name="Clu_aln_per_chr queue=bsc_ls"
#SBATCH --output=chrR.slurm.%j.out
#SBATCH --error=chrR.slurm.%j.err
#SBATCH --mail-type=end
#SBATCH --mail-user=aisha.shah@alum.esci.upf.edu
#SBATCH --time=15:00:00
#SBATCH --qos=bsc_ls
#SBATCH -N 1
#SBATCH -n 16
module load clustal
#clustalo -i T2T_rRNA45S_uniq_morphs_44kb.fa --outfmt=a2m -o T2T_rRNA45S_uniq_morphs_44kb.aln --threads=16 --distmat-out=T2T_rRNA45S_uniq_morphs_44kb_distances.out --guidetree-out=T2T_rRNA45S_uniq_morphs_44kb_guide_tree.nwk --percent-id --full

clustalo -i T2T_rRNA45S_uniq_morphs_44kb.chrR.fa --outfmt=a2m -o T2T_rRNA45S_uniq_morphs_44kb.chrR.2.aln --threads=16 --distmat-out=T2T_rRNA45S_uniq_morphs_44kb.chrR_distances.2.out --guidetree-out=T2T_rRNA45S_uniq_morphs_44kb.chrR_guide_tree.2.nwk --percent-id --full
