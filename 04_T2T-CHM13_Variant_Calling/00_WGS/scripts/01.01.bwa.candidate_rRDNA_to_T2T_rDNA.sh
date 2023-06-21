#!/bin/bash


#SBATCH --job-name=T2T_rDNA_candidate_rRNA_reads_bwa_SRR1997411
#SBATCH --chdir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts
#SBATCH --output=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts/out/T2T_rDNA_candidate_rRNA_reads_bwa.%A_%a.out
#SBATCH --error=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts/err/T2T_rDNA_candidate_rRNA_reads_bwa.%A_%a.err
#SBATCH --array=1-21
#SBATCH --cpus-per-task=8
#SBATCH --qos=debug
#SBATCH --constraint=highmem
#SBATCH --time=00:15:00

:'
SRR1997411
SRR3189741
SRR3189742
SRR3189743
'

# load modules
module load htslib
module load samtools
#module load gcc/8.5.0 bwa # Nord3v2
module load gcc/11.2.0 bwa #mn3

sample_id=$1
export part_number=$(sed -n "${SLURM_ARRAY_TASK_ID}p" splitted_fq.tab | awk '{print $1}')
inpath=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/00_data/fastq_files/${sample_id}/candidate_rRNA
outpath=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/01_mapping/T2T_rDNA_candidate_rRNA/${sample_id}
mkdir -p ${outpath}
fastq1=${inpath}/${sample_id}_1.part_${part_number}.nucmer.fastq.gz
fastq2=${inpath}/${sample_id}_2.part_${part_number}.nucmer.fastq.gz
reference=/gpfs/projects/bsc83/Data/assemblies/T2T/masked_rDNA.Genes_And_Pseudogenes/mask_small_blast_hits/T2T.rDNA_masked_genes_and_pseudogenes.Consensus_45S.5S.fa
bwa_index=/gpfs/projects/bsc83/Data/assemblies/T2T/masked_rDNA.Genes_And_Pseudogenes/mask_small_blast_hits/T2T.rDNA_masked_genes_and_pseudogenes.Consensus_45S.5S


###############################################################################################################
#  Mapping fastq of unique operons to non degenerate rDNA consensus + T2T (masked rDNA genes and pseudogenes) #
###############################################################################################################
echo "*****************************************************************************************************"
echo "Start mapping candidate rDNA reads from T2T_RNAseq with unique morphs consensus + masked T2T: $(date)"
# bwa mapping
bwa mem -t 16 -h 1000 -R $(echo "@RG\tID:${sample_id}\tSM:${sample_id}\tLB:lib1\tPL:ILLUMINA\tPU:unit1") ${bwa_index} ${fastq1} ${fastq2} | samtools sort --threads 16 -T ${outpath}/${sample_id}.${part_number}  -o ${outpath}/${sample_id}.${part_number}.sorted.RG.bam -

echo "End Mapping: $(date)"
echo "*****************************************************************************************************"
echo ""


################################################################
#   2.2      INDEXING and FILTERING BAM FILE                   #
################################################################

: ' 
Extracting properly paired reads
-f 2 : keep properly apired reads only
-F 4 : remove unmapped
-F 2048 : remove supplementart reads
-F 256 : remove secondary reads
samtools flag 2308
0x904	2308	UNMAP,SECONDARY,SUPPLEMENTARY
so we can use -f 2 -F 2308
'

echo "**************************************"
echo "Start filtering bam  : $(date)"

samtools view -bh -f 2 -F 2308 ${outpath}/${sample_id}.${part_number}.sorted.RG.bam > ${outpath}/${sample_id}.${part_number}.sorted.RG.filtered_f2F2308.bam

samtools index ${outpath}/${sample_id}.${part_number}.sorted.RG.filtered_f2F2308.bam

echo "End filtering : $(date)"
echo "**************************************"
echo ""
