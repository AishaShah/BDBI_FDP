#!/bin/bash


#SBATCH --job-name="DV DNAseq JG:Variant_Calling , ref=47S_operon consensus+T2T_masked"
#SBATCH --chdir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts
#SBATCH --output=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts/out/03.02.DV.JG.MF0.01.MQ30.BQ15.SC10.unfiltered.%A_%a.out
#SBATCH --error=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts/err/03.02.DV.JG.MF0.01.MQ30.BQ15.SC10.unfiltered.%A_%a.err
#SBATCH --array=1
#SBATCH --cpus-per-task=48
#SBATCH --qos=debug
#SBATCH --time=00:30:00
#SBATCH --constraint=highmem



# Load required packages
module load glnexus

########################################################
#     Variant Calling (GVCF format) JoingGenotyping    #
########################################################


dir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/04.DeepVariant/Consensus_Uniq_Morphs
outpath=${dir}/Joint_Genotyping/output_unfiltered_MinFreq0.01.MQ30.BQ15.SC10
intermediate_files=${outpath}/intermediate_files

mkdir -p ${outpath}

S1=SRR1997411
S2=SRR3189741
S3=SRR3189742
S4=SRR3189743

gVCF1=${dir}/${S1}/output_MinFreq0.01.MQ30.BQ15.SC10/${S1}_T2T_DNAseq.DeepVariant.output.g.vcf.gz
gVCF2=${dir}/${S2}/output_MinFreq0.01.MQ30.BQ15.SC10/${S2}_T2T_DNAseq.DeepVariant.output.g.vcf.gz
gVCF3=${dir}/${S3}/output_MinFreq0.01.MQ30.BQ15.SC10/${S3}_T2T_DNAseq.DeepVariant.output.g.vcf.gz
gVCF4=${dir}/${S4}/output_MinFreq0.01.MQ30.BQ15.SC10/${S4}_T2T_DNAseq.DeepVariant.output.g.vcf.gz
#gVCF3=${dir}/CHM13/output_unfiltered_MinFreq0.05.MQ10.BQ10.SC10/CHM13_T2T_RNAseq.DeepVariant.output.g.vcf.gz


: '
Initially i tried config DeepVariant_WES and DeepVariant_unfiltered
#Reg=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/T2T_rDNA.Cons_uniq_morphs_genes.bed
SET1 A : DeepVariant_unfiltered
SET1 B : DeepVariantWGS
'

/apps/GLNEXUS/1.4.1/Linux-x86-64/bin/glnexus_cli \
--config DeepVariant_unfiltered \
--dir ${intermediate_files} \
--bed /gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/T2T_rDNA.Cons_uniq_morphs.bed \
${gVCF1} ${gVCF2} ${gVCF3} ${gVCF4}> ${outpath}/DeepVariant_T2T_DNAseq.JG.bcf


# Convert bcf file to vcf
module load bcftools
bcftools convert -O z -o ${outpath}/DeepVariant_T2T_DNAseq.JG.vcf.gz ${outpath}/DeepVariant_T2T_DNAseq.JG.bcf

gunzip -k ${outpath}/DeepVariant_T2T_DNAseq.JG.vcf.gz

module load java/8u201 gatk/4.3.0.0

gatk --java-options "-Xmx4g -Xms4g" VariantsToTable \
-V ${outpath}/DeepVariant_T2T_DNAseq.JG.vcf \
-F CHROM -F POS -F ID -F TYPE -F AF -F AQ -F AC -F AN -F REF -F ALT -F QUAL -F MULTI-ALLELIC -F FILTER -F MQ -F QD -F SOR -F FS -F VAR -GF GT -GF AD -GF DP -GF PL -GF GQ -GF RNC \
-O ${outpath}/DV_DNAseq.unfiltered.MinFreq0.01.MQ30.BQ15.SC10.table
