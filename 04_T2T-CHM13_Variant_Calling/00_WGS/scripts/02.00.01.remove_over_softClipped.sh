#!/bin/bash


#SBATCH --job-name="T2T DNAseq : Remove Over softClipped"
#SBATCH --chdir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts
#SBATCH --output=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts/out/02.00.01.remove_over_softClipped.%A_%a.out
#SBATCH --error=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts/err/02.00.01.remove_over_softClipped.%A_%a.err
#SBATCH --array=1-4
#SBATCH --cpus-per-task=16
#SBATCH --qos=debug
#SBATCH --time=01:00:00

# load modules

module load htslib samtools
module load samclip 

export sample_id=$(sed -n "${SLURM_ARRAY_TASK_ID}p" T2T_WGS.tab  | cut -f1)

reference=/gpfs/projects/bsc83/Data/assemblies/T2T/masked_rDNA.Genes_And_Pseudogenes/mask_small_blast_hits/T2T.rDNA_masked_genes_and_pseudogenes.Consensus_45S.5S.fa
inpath=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/01_mapping/T2T_rDNA_candidate_rRNA/${sample_id}



echo "**************************************"
echo "Remove over soft clipped reads  : $(date)"

samtools view -h ${inpath}/${sample_id}.sorted.RG.filtered_f2F2308.bam | samclip --ref ${reference} --max 10 | samtools sort > ${inpath}/${sample_id}.sorted.RG.filtered_f2F2308.SC10.bam
samtools index ${inpath}/${sample_id}.sorted.RG.filtered_f2F2308.SC10.bam

echo "End removing over soft clipped reads : $(date)"
echo "**************************************"
echo ""


