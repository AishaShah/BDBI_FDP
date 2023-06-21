#!/bin/bash


#SBATCH --job-name="GATK:Variant_Calling (per sample) , ref=47S_operon consensus+T2T_masked"
#SBATCH --chdir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts
#SBATCH --output=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts/out/02.01.GATK.perSample.MQ30.BQ15.MAA20.GC75000.SC10.bqsr.%A_%a.out
#SBATCH --error=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts/err/02.01.GATK.perSample.MQ30.BQ15.MAA20.GC75000.SC10.bqsr.%A_%a.err
#SBATCH --array=1-4
#SBATCH --cpus-per-task=16
#SBATCH --qos=debug
#SBATCH --time=01:00:00
#SBATCH --constraint=highmem



ploidy=$1
export sample_id=$(sed -n "${SLURM_ARRAY_TASK_ID}p" T2T_WGS.tab | cut -f1)
inpath=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/01_mapping/T2T_rDNA_candidate_rRNA
reference=/gpfs/projects/bsc83/Data/assemblies/T2T/T2T_rDNA/T2T_rDNA.fa

# Load required packages
module load htslib # Nord3
module load samtools # not needed?
#module load java gatk/4.2.6.1 # Nord3: use versions greater than 4.1.6 to solve bug with MNP variants
#module load java/8u201 gatk/4.1.4.1 # mn3
module load java/8u201 gatk/4.3.0.0 # mn3

# STEP 1 : variant calling indiviually for four libraries
#ploidy=20
#ploidy=50

########################################################
#     Variant Calling (GVCF format) per library        #
########################################################


outpath=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/02_HaplotypeCaller/Consensus_Uniq_Morphs/output_MQ30.BQ15.MAA20.GC75000.SC10.p10/${sample_id}
mkdir -p ${outpath}


bamfile=${inpath}/${sample_id}/${sample_id}.sorted.RG.filtered_f2F2308.SC10.bqsr.bam
intervals=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/T2T_rDNA.Cons_uniq_morphs.bed

echo "Executing sample ID: $sample_id"
# Perform variant calling of one sample avoiding soft-clipped bases
gatk --java-options "-Xmx115g -Xms100g" HaplotypeCaller \
-I ${bamfile} \
-R ${reference} \
-O ${outpath}/${sample_id}.ploidy_${ploidy}.output.g.vcf.gz \
-L ${intervals} \
--minimum-mapping-quality 30 \
--mapping-quality-threshold-for-genotyping 30 \
--min-base-quality-score 15 \
--max-alternate-alleles 20 \
--max-genotype-count 75000 \
--dont-use-soft-clipped-bases true \
-ploidy ${ploidy} \
-ERC GVCF
