#!/bin/bash

#SBATCH --job-name="R.DeepVariant (Joint_Genotyping) ,set1, manual config, ref=47S_operon consensus+ T2T_masked"
#SBATCH --chdir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts
#SBATCH --output=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/cons_uniq_morphs.T2T_masked_small_blast_hits/Deepvariant/out/02.02.DeepVariant_JointGenotyping_MF0.05.MQ30.BQ15.SC10.unfiltered_config.%A_%a.out
#SBATCH --error=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/cons_uniq_morphs.T2T_masked_small_blast_hits/Deepvariant/err/02.02.DeepVariant_JointGenotyping_MF0.05.MQ30.BQ15.SC10.unfiltered_config.%A_%a.err
#SBATCH --cpus-per-task=16
#SBATCH --qos=debug
#SBATCH --time=00:40:00
#SBATCH --constraint=highmem



# Load required packages
module load glnexus 

########################################################
#     Variant Calling (GVCF format) JoingGenotyping    #
########################################################



dir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/04.DeepVariant/Consensus_Uniq_Morphs/masked.small_blast_hits.genes.pseudogenes
outpath=${dir}/Joint_Genotyping/output_unfiltered_config_MinFreq0.05.MQ30.BQ15.SC10
intermediate_files=${outpath}/intermediate_files

mkdir -p ${outpath}

gVCF1=${dir}/CHM13_1_S182/output_unfiltered_MinFreq0.05.MQ30.BQ15.SC10/CHM13_1_S182_T2T_RNAseq.DeepVariant.output.g.vcf.gz
gVCF2=${dir}/CHM13_2_S183/output_unfiltered_MinFreq0.05.MQ30.BQ15.SC10/CHM13_2_S183_T2T_RNAseq.DeepVariant.output.g.vcf.gz
#gVCF3=${dir}/CHM13/output_unfiltered_MinFreq0.05.MQ10.BQ10.SC10/CHM13_T2T_RNAseq.DeepVariant.output.g.vcf.gz

config=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/00_data/DeepVariant/GLnexus/DeepVariant_rRNA.yml

: '
Initially i tried config DeepVariant_WES and DeepVariant_unfiltered
#Reg=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/T2T_rDNA.Cons_uniq_morphs_genes.bed
SET1 A : DeepVariant_unfiltered
SET1 B : config  <-- manual config
'

/apps/GLNEXUS/1.4.1/Linux-x86-64/bin/glnexus_cli \
--config DeepVariant_unfiltered \
--dir ${intermediate_files} \
--bed /gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/T2T_rDNA.Cons_uniq_morphs.bed \
${gVCF1} ${gVCF2}  > ${outpath}/DeepVariant_T2T_RNAseq.JG.bcf


# Convert bcf file to vcf
module load bcftools
bcftools convert -O z -o ${outpath}/DeepVariant_T2T_RNAseq.JG.vcf.gz ${outpath}/DeepVariant_T2T_RNAseq.JG.bcf

gunzip -k ${outpath}/DeepVariant_T2T_RNAseq.JG.vcf.gz 
# CHROM POS ID REF ALT QUAL FILTER INFO FORMAT AF=0.5;AQ=32GT:DP:AD:GQ:PL:RNC
# Convert vcf file to table 
module load java/8u201 gatk/4.3.0.0
gatk --java-options "-Xmx4g" VariantsToTable \ 
        -V ${outpath}/DeepVariant_T2T_RNAseq.JG.vcf \
	-F CHROM -F POS -F ID -F TYPE -F AF -F AQ -F AC -F AN -F REF -F ALT -F QUAL -F MULTI-ALLELIC \
	-F FILTER -F MQ -F QD -F SOR -F FS -F VAR -GF GT -GF AD -GF DP -GF PL -GF GQ -GF RNC \
        -O ${outpath}/DeepVariant_T2T_RNAseq.JG.output.table \
        --show-filtered true
