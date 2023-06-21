#!/bin/bash


#SBATCH --job-name="SC10 allow only 10 first and last bases to be soft clipped (trimmed candidate rDNA reads) "
#SBATCH --chdir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts
#SBATCH --output=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/cons_uniq_morphs.T2T_masked_small_blast_hits/out/01.02.B.remove_soft_clipped.SC10.%A_%a.out
#SBATCH --error=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/cons_uniq_morphs.T2T_masked_small_blast_hits/err/01.02.B.remove_soft_clipped.SC10.%A_%a.err
#SBATCH --array=1-2
#SBATCH --cpus-per-task=16
#SBATCH --qos=bsc_ls
#SBATCH --time=05:00:00


# Refrence : Consensus for 45S + 5S + T2T.masked(annotated genes and PS + blast hits)

# load modules
module load htslib # Nord3v2
module load samtools # Nord3v2
module load samclip

export sample_id=$(sed -n "${SLURM_ARRAY_TASK_ID}p" T2T_RNAseq.tab  | cut -f1)
outpath=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/01_mapping/Consensus_Uniq_Morphs/masked.small_blast_hits.genes.pseudogenes.trimmedQC/${sample_id}
reference=/gpfs/projects/bsc83/Data/assemblies/T2T/masked_rDNA.Genes_And_Pseudogenes/mask_small_blast_hits/T2T.rDNA_masked_genes_and_pseudogenes.Consensus_45S.5S.fa


##################################################################
# Remove soft cliped reads (min-allowed soft-clipped bases = 10) # 10 or 20???? max clip length to allow = 10 --> summing up SC of both ends? 
##################################################################


echo "**************************************"
echo "Remove over soft clipped reads  : $(date)"

samtools view -h ${outpath}/${sample_id}.sorted.RG.filtered_f2F2308.bam | samclip --ref ${reference} --max 10 | samtools sort > ${outpath}/${sample_id}.sorted.RG.filtered_f2F2308.SC10.bam
samtools view -h ${outpath}/${sample_id}.sorted.RG.filtered_f2F2308.bam | samclip --ref ${reference} --max 10 --invert | samtools sort > ${outpath}/${sample_id}.sorted.RG.filtered_f2F2308.Soft_clipped_reads_only_SC10.bam
samtools index ${outpath}/${sample_id}.sorted.RG.filtered_f2F2308.SC10.bam
samtools index ${outpath}/${sample_id}.sorted.RG.filtered_f2F2308.Soft_clipped_reads_only_SC10.bam

echo "End removing over soft clipped reads : $(date)"
echo "**************************************"
echo ""




