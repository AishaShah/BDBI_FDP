#!/bin/bash


#SBATCH --job-name=Variant_Calling
#SBATCH --chdir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/02_variant_calling_using_kmers/scripts/
#SBATCH --output=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/02_variant_calling_using_kmers/scripts/out/03.01.haploCall.%A_%a.out
#SBATCH --error=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/02_variant_calling_using_kmers/scripts/err/03.01.haploCall.%A_%a.err
#SBATCH --cpus-per-task=8
#SBATCH --qos=debug
#SBATCH --time=02:00:00


# Load required packages
module load htslib # Nord3
module load samtools
#module load java gatk
module load java gatk/4.2.6.1 # Nord3: use versions greater than 4.1.6 to solve bug with MNP variants

# Variables and paths
reference=/gpfs/projects/bsc83/Data/assemblies/T2T/T2T_rDNA/T2T_rDNA.fa
bamfile=$1
outpath=$2
mkdir -p ${outpath}


# Perform variant calling of one sample avoiding soft-clipped bases
gatk --java-options "-Xmx4g" HaplotypeCaller \
-I ${bamfile} \
-R ${reference} \
-O ${outpath}/T2T_rRNA47S_uniq_operons_len_151.ploidy100.output.g.vcf.gz \
-RF MappingQualityReadFilter \
--minimum-mapping-quality 10 \
--dont-use-soft-clipped-bases true \
-ploidy 100 \
-ERC NONE

## Variants2table

vcf_name=${outpath}/T2T_rRNA47S_uniq_operons_len_151.ploidy100.output.g.vcf.gz

# Extract information from VCF files using GATK. Never parse on your own!!
gatk --java-options "-Xmx4g" VariantsToTable \
-V ${outpath}/${vcf_name} \
-F CHROM -F POS -F TYPE -F AF -F REF -F ALT -F VAR -GF GT -GF AD -GF DP -GF PL -GF GQ \
-O ${outpath}/chr151_T2T_rRNA47S_mapped2UniqueMorphsCons_len_151.ploidy100.table \
--show-filtered true # By default filtered positions are removed. To see them you need this flag
