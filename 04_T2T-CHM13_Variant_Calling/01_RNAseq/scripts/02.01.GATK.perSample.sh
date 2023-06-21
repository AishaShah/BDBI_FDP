#!/bin/bash


#SBATCH --job-name="GATK: (MQ30.BQ15.MAA20.GC75000.SC10) Variant_Calling using ploidy 10 (per sample) , ref=47S_operon consensus+T2T_masked"
#SBATCH --chdir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts
#SBATCH --output=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/cons_uniq_morphs.T2T_masked_small_blast_hits/GATK/out/02.01.T2T_masked.GATK.pldy_10.perSample.MQ30.BQ15.MAA20.GC75000.SC10.bqsr.%A_%a.out
#SBATCH --error=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/cons_uniq_morphs.T2T_masked_small_blast_hits/GATK/err/02.01.T2T_masked.GATK.pldy_10.perSample.MQ30.BQ15.MAA20.GC75000.SC10.bqsr.%A_%a.err
#SBATCH --array=1-2
#SBATCH --cpus-per-task=16
#SBATCH --qos=debug
#SBATCH --time=02:00:00
#SBATCH --constraint=highmem




export sample_id=$(sed -n "${SLURM_ARRAY_TASK_ID}p" T2T_RNAseq.tab  | cut -f1)
ploidy=$1
inpath=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/01_mapping/Consensus_Uniq_Morphs/masked.small_blast_hits.genes.pseudogenes

reference=/gpfs/projects/bsc83/Data/assemblies/T2T/T2T_rDNA/T2T_rDNA.fa

# Load required packages
module load htslib # Nord3
module load samtools # not needed?
module load java gatk/4.2.6.1 # Nord3: use versions greater than 4.1.6 to solve bug with MNP variants
#module load java/8u201 gatk/4.1.4.1 # mn3
#module load java/8u201 gatk/4.3.0.0 # mn3


# STEP 1 : variant calling indiviually for two libraries cHM13_1_182 and CHM13_2_183


########################################################
#     Variant Calling (GVCF format) per library        #
########################################################


outpath=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/03.HaplotypeCaller/Consensus_Uniq_Morphs/masked.small_blast_hits.genes.pseudogenes/bqsr.using.benchmark_variants/output_MQ30.BQ15.MAA20.GC75000.SC10.p10/${sample_id}
mkdir -p ${outpath}

bamfile=${inpath}/BQSR_Using_Benchmark_Variants/${sample_id}/${sample_id}.sorted.RG.filtered_f2F2308.SC10.bqsr.bam
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
