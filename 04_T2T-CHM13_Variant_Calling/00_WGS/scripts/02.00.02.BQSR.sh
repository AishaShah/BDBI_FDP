#!/bin/bash


#SBATCH --job-name=02.00.T2T_BQSR
#SBATCH --chdir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts
#SBATCH --output=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts/out/02.00.02.BQSR.%A_%a.out
#SBATCH --error=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts/err/02.00.02.BQSR.%A_%a.err
#SBATCH --array=1-4
#SBATCH --cpus-per-task=16
#SBATCH --qos=debug
#SBATCH --time=02:00:00

# load modules
#module load java gatk # Nord3v2
module load java/8u201 gatk/4.3.0.0 #mn3
module load htslib samtools


export sample_id=$(sed -n "${SLURM_ARRAY_TASK_ID}p" T2T_WGS.tab  | cut -f1)

dir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/01_mapping/T2T_rDNA_candidate_rRNA
outpath=${dir}/BQSR_Using_Benchmark_Variants/${sample_id}
out_recal=${dir}/BQSR_Using_Benchmark_Variants/recalibration_tables
inpath=${dir}/${sample_id}
reference=/gpfs/projects/bsc83/Data/assemblies/T2T/masked_rDNA.Genes_And_Pseudogenes/mask_small_blast_hits/T2T.rDNA_masked_genes_and_pseudogenes.Consensus_45S.5S.fa
bamfile=${inpath}/${sample_id}.sorted.RG.filtered_f2F2308.SC10.bam
vcf=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/02_variant_calling_using_kmers/03.HaplotypeCaller/consensus_unique_morphs/len_151/ploidy_100/T2T_rRNA47S_uniq_operons_len_151.ploidy100.output.vcf.gz
intervals=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/T2T_rDNA.Cons_uniq_morphs.bed
mkdir -p ${outpath}
mkdir -p ${out_recal}



#############################################
#              BQSR table                   #
#############################################

echo "**************************************"
echo "Start BQSR table: $(date)"


gatk BaseRecalibrator \
   -R ${reference} \
   -I ${bamfile} \
   -L ${intervals} \
   --known-sites ${vcf} \
   -O ${out_recal}/${sample_id}.sorted.RG.filtered_f2F2308.SC10.recal_data.table

#############################################
#              ApplyBQSR                    #
#############################################
echo "**************************************"
echo "Start BQSR : $(date)"
echo ""


recalibration_table=${out_recal}/${sample_id}.sorted.RG.filtered_f2F2308.SC10.recal_data.table

gatk ApplyBQSR \
   -R ${reference} \
   -I ${bamfile} \
   --bqsr-recal-file ${recalibration_table} \
   -O ${inpath}/${sample_id}.sorted.RG.filtered_f2F2308.SC10.bqsr.bam

echo "End BQSR : $(date)"
echo "**************************************"
echo ""


samtools index ${inpath}/${sample_id}.sorted.RG.filtered_f2F2308.SC10.bqsr.bam



# https://gatk.broadinstitute.org/hc/en-us/articles/5358896138011-BaseRecalibrator
