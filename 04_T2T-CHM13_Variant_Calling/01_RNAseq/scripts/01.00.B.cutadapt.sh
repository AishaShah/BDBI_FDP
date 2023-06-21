#!/bin/bash

#SBATCH --job-name="T2T_rDNA candidate RNAseq reads quality control"
#SBATCH --chdir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts
#SBATCH --output=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/cons_uniq_morphs.T2T_masked_small_blast_hits/out/01.00.B.cutadapt.%A_%a.out
#SBATCH --error=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/cons_uniq_morphs.T2T_masked_small_blast_hits/err/01.00.B.cutadapt.%A_%a.err
#SBATCH --array=1-2
#SBATCH --cpus-per-task=16
#SBATCH --qos=bsc_ls
#SBATCH --time=04:00:00


# Load required packages
module load anaconda
module load fastqc
source activate trim-galore

# Paths and variables
export sample_id=$(sed -n "${SLURM_ARRAY_TASK_ID}p" T2T_RNAseq.tab  | cut -f1)

INPATH=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/00_data/nucmer/Consensus_Uniq_Morphs/T2T_RNAseq/${sample_id}/fastq
fastq1=${INPATH}/${sample_id}_L002_R1_001_T2T_rDNA.fastq
fastq2=${INPATH}/${sample_id}_L002_R2_001_T2T_rDNA.fastq
OUTPATH=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/00_data/nucmer/Consensus_Uniq_Morphs/T2T_RNAseq/${sample_id}/fastq.trimmedQC
OUT_QC=${OUTPATH}/fastqQC
OUT_fastq=${OUTPATH}/fastq
mkdir -p ${OUT_fastq}
mkdir -p ${OUT_QC}



trim_galore --paired --cores 16 --fastqc_args "--outdir ${OUT_QC}" --gzip --stringency=5 --quality=20 --length=50 -o ${OUT_fastq} ${fastq1} ${fastq2}
