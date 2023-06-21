#!/bin/bash


#SBATCH --job-name=T2T_rDNA_merge_bams
#SBATCH --chdir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts
#SBATCH --output=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts/out/T2T_rDNA_merge_bams.%A_%a.out
#SBATCH --error=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts/err/T2T_rDNA_merge_bams.%A_%a.err
#SBATCH --array=1-4
#SBATCH --cpus-per-task=8
#SBATCH --qos=debug
#SBATCH --time=02:00:00

# load modules
module load htslib
module load samtools

export sample_id=$(sed -n "${SLURM_ARRAY_TASK_ID}p" T2T_WGS.tab  | cut -f1)
inpath=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/01_mapping/T2T_rDNA_candidate_rRNA/${sample_id}
outpath=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/01_mapping/T2T_rDNA_candidate_rRNA/${sample_id}


# the following command will merge all file with .sorted.RG tag in name in given inpath directory which just contains our bam files for one WGS library reading sample ID from text file
files=`ls -1 -d "${inpath}/"* | grep "RG.filtered" | grep -v ".bai"`

# merge bam files
samtools merge --threads 8 -o ${outpath}/${sample_id}.sorted.RG.filtered_f2F2308.bam ${files}
samtools index ${outpath}/${sample_id}.sorted.RG.filtered_f2F2308.bam
