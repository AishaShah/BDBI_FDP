#!/bin/bash


#SBATCH --job-name=02.map.219.rRNA45S.to.T2T.non.degenerate.consensus.bwa.RG.index
#SBATCH --chdir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/02_variant_calling_using_kmers/scripts/
#SBATCH --output=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/02_variant_calling_using_kmers/scripts/out/02.map.219.rRNA45S.to.T2T.non.degenerate.consensus.bwa.RG.index.%A_%a.out
#SBATCH --error=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/02_variant_calling_using_kmers/scripts/err/02.map.219.rRNA45S.to.T2T.non.degenerate.consensus.bwa.RG.index.%A_%a.err
#SBATCH --cpus-per-task=16
#SBATCH --qos=debug
#SBATCH --time=02:00:00

inpath=$1
outpath=$2
mkdir -p ${outpath}
fastq=${inpath}

bwa_index=/gpfs/projects/bsc83/Data/assemblies/T2T/T2T_rDNA/T2T_rDNA

# load modules
module load htslib # Nord3v2
module load samtools # Nord3v2
module load gcc/8.5.0 bwa # Nord3v2

################################################################
#  Mapping fastq of unique operons to non degenerate consensus #
################################################################

# bwa mapping
bwa mem -t 16 -h 1000 ${bwa_index} ${fastq} | samtools view -hb -F 4 -F 2048 | samtools sort -T ${outpath}/T2T_rRNA47S_Subsequences_len_151. --threads 16  -o ${outpath}/T2T_rRNA47S_Subsequences_len_${SLURM_ARRAY_TASK_ID}.sorted.bam -


#############################################
#      ADDING RG TAG IN BAM FILE            #
#############################################


# gatk
module load java/8u131

java -jar /apps/PICARD/2.27.4/picard.jar AddOrReplaceReadGroups \
       I=${outpath}/T2T_rRNA47S_Subsequences_len_151.sorted.bam \
       O=${outpath}/T2T_rRNA47S_Subsequences_len_151.sorted.RG.bam \
       RGID=rRNA45S_151 \
       RGLB=lib1 \
       RGPL=ILLUMINA \
       RGPU=unit1 \
       RGSM=rRNA45S_151

#############################################
#            INDEXING BAM FILE              #
#############################################
samtools index ${outpath}/T2T_rRNA47S_Subsequences_len_151.sorted.RG.bam 

