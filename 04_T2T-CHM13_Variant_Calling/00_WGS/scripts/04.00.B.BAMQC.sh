#!/bin/bash


#SBATCH --job-name="BAMQC T2T-WGS (without trimming and adaptor removal) "
#SBATCH --chdir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts
#SBATCH --output=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts/out/04.00.B.BAMQC.%A_%a.err
#SBATCH --error=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts/err/04.00.B.BAMQC.%A_%a.err
#SBATCH --array=1-4
#SBATCH --cpus-per-task=16
#SBATCH --qos=bsc_ls
#SBATCH --time=05:00:00


# Refrence : Consensus for 45S + 5S + T2T.masked(annotated genes and PS + blast hits)

# load modules
# mn3
module load intel mkl impi/2017.4 java/16.0.1 python mosdepth bedtools samtools picard/3.0.0 bamqc


export sample_id=$(sed -n "${SLURM_ARRAY_TASK_ID}p" T2T_WGS.tab  | cut -f1)
outpath=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/01_mapping/T2T_rDNA_candidate_rRNA/${sample_id}
reference=/gpfs/projects/bsc83/Data/assemblies/T2T/masked_rDNA.Genes_And_Pseudogenes/mask_small_blast_hits/T2T.rDNA_masked_genes_and_pseudogenes.Consensus_45S.5S.fa

bamqc_outpath=${outpath}/BAMQC/
mkdir -p ${bamqc_outpath}
##################################################################
# BAMQC (before removing over soft clipped reads)
##################################################################


echo "**************************************"
echo "Start BAMQC  : $(date)"
bamqc --gff /gpfs/projects/bsc83/Data/assemblies/T2T/T2T_rDNA/T2T_rDNA.gff3 --outdir ${bamqc_outpath} --threads 16 ${outpath}/${sample_id}.sorted.RG.filtered_f2F2308.bam ${outpath}/${sample_id}.sorted.RG.filtered_f2F2308.SC10.bam

echo "End BAMQC : $(date)"
echo "**************************************"
echo ""




