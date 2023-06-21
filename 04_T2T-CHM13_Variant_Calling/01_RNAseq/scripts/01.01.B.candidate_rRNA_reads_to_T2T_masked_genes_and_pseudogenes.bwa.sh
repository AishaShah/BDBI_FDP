#!/bin/bash


#SBATCH --job-name="T2T_rDNA trimmed candidate RNAseq reads mapped to masked T2T (genes and PS) blast + rDNA_genes_consensus (bwa)"
#SBATCH --chdir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts
#SBATCH --output=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/cons_uniq_morphs.T2T_masked_small_blast_hits/out/01.01.B.candidate_rRNA_reads_to_T2T_masked_genes_and_pseudogenes.bwa.%A_%a.out
#SBATCH --error=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/cons_uniq_morphs.T2T_masked_small_blast_hits/err/01.01.B.candidate_rRNA_reads_to_T2T_masked_genes_and_pseudogenes.bwa.%A_%a.err
#SBATCH --array=1,2
#SBATCH --cpus-per-task=16
#SBATCH --qos=debug
#SBATCH --time=02:00:00


# Refrence : Consensus for 45S + 5S + T2T.masked(annotated genes and PS + blast hits > 30bp)

# load modules
module load htslib # Nord3v2
module load samtools # Nord3v2
module load gcc/8.5.0 bwa # Nord3v2


export sample_id=$(sed -n "${SLURM_ARRAY_TASK_ID}p" T2T_RNAseq.tab  | cut -f1)
inpath=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/00_data/nucmer/Consensus_Uniq_Morphs/T2T_RNAseq/${sample_id}/fastq.trimmedQC/fastq
outpath=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/01_mapping/Consensus_Uniq_Morphs/masked.small_blast_hits.genes.pseudogenes.trimmedQC/${sample_id}


mkdir -p ${outpath}

fastq1=${inpath}/${sample_id}_L002_R1_001_T2T_rDNA_val_1.fq.gz
fastq2=${inpath}/${sample_id}_L002_R2_001_T2T_rDNA_val_2.fq.gz

################################################################
#  BWA index for consensus
################################################################

bwa_index=/gpfs/projects/bsc83/Data/assemblies/T2T/masked_rDNA.Genes_And_Pseudogenes/mask_small_blast_hits/T2T.rDNA_masked_genes_and_pseudogenes.Consensus_45S.5S

###############################################################################################################
#  Mapping fastq of unique operons to non degenerate rDNA consensus + T2T (masked rDNA genes and pseudogenes) #
###############################################################################################################

echo "*****************************************************************************************************"
echo "Start mapping candidate rDNA reads from T2T_RNAseq with unique morphs consensus + masked T2T: $(date)"

bwa mem -t 16 -h 1000 -R $(echo "@RG\tID:${sample_id}\tSM:${sample_id}\tLB:lib1\tPL:ILLUMINA\tPU:unit1") ${bwa_index} ${fastq1} ${fastq2} | samtools sort -T ${outpath}/${sample_id}. --threads 16  -o ${outpath}/${sample_id}.sorted.RG.bam -

echo "End Mapping: $(date)"
echo "*****************************************************************************************************"
echo ""


##################################################
#   2.1      INDEXING BAM FILE                   #
##################################################
# is this step needed? to visualize all reads in IGV before filtering we need index file

samtools index ${outpath}/${sample_id}.sorted.RG.bam

## SINCE STEPS BELOW ARE NOT WORKING I AM FILTERING BAM FILE HERE 


################################################################
#   2.2      INDEXING and FILTERING BAM FILE                   #
################################################################

# Extracting uniquly mapped and properly paired reads

echo "**************************************"
echo "Start filtering bam  : $(date)"

samtools view -bh -f 2 -F 2308 ${outpath}/${sample_id}.sorted.RG.bam > ${outpath}/${sample_id}.sorted.RG.filtered_f2F2308.bam

samtools index ${outpath}/${sample_id}.sorted.RG.filtered_f2F2308.bam

echo "End filtering : $(date)"
echo "**************************************"
echo ""










