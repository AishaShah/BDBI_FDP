#!/bin/bash


#SBATCH --job-name="DV DNAseq:Variant_Calling per sample , ref=47S_operon consensus+T2T_masked"
#SBATCH --chdir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts
#SBATCH --output=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts/out/03.01.DV.pldy_10.perSample.MF0.01.MQ30.BQ15.SC10.%A_%a.out
#SBATCH --error=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/scripts/err/03.01.DV.pldy_10.perSample.MF0.01.MQ30.BQ15.SC10.%A_%a.err
#SBATCH --array=1-4
#SBATCH --cpus-per-task=48
#SBATCH --qos=debug
#SBATCH --time=00:30:00
#SBATCH --constraint=highmem



export sample_id=$(sed -n "${SLURM_ARRAY_TASK_ID}p" T2T_WGS.tab | cut -f1)

inpath=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/01_mapping/T2T_rDNA_candidate_rRNA


###################################
reference=/gpfs/projects/bsc83/Data/assemblies/T2T/masked_rDNA.Genes_And_Pseudogenes/mask_small_blast_hits/T2T.rDNA_masked_genes_and_pseudogenes.Consensus_45S.5S.fa
# Load required packages
module load singularity # MN3

# STEP 1 : variant calling indiviually for two libraries cHM13_1_182 and CHM13_2_183

########################################################
#     Variant Calling (GVCF format) per library        #
########################################################
#model=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/00_data/DeepVariant

dir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/WGS/cons_uniq_morphs.T2T_masked_small_blast_hits/04.DeepVariant/Consensus_Uniq_Morphs/${sample_id}
outpath=${dir}/output_MinFreq0.01.MQ30.BQ15.SC10
intermediate_results=${outpath}/intermediate_results_dir
mkdir -p ${intermediate_results}
bamfile=${inpath}/${sample_id}/${sample_id}.sorted.RG.filtered_f2F2308.SC10.bqsr.bam

echo "Executing sample ID: $sample_id"

singularity run /apps/SINGULARITY/images/deepvariant_1.4.0.sif run_deepvariant \
--model_type=WGS \
--ref=${reference} \
--reads=${bamfile} \
--sample_name=${sample_id} \
--output_vcf=${outpath}/${sample_id}_T2T_DNAseq.DeepVariant.output.vcf.gz \
--output_gvcf=${outpath}/${sample_id}_T2T_DNAseq.DeepVariant.output.g.vcf.gz \
--num_shards=48 \
--regions="T2T_45S T2T_5S" \
--make_examples_extra_args="vsc_min_count_snps=1,vsc_min_fraction_snps=0.01,vsc_min_count_indels=1,vsc_min_fraction_indels=0.01,min_mapping_quality=30,min_base_quality=15" \
--intermediate_results_dir ${intermediate_results} \
--postprocess_variants_extra_args="debug_output_all_candidates=ALT,cnn_homref_call_min_gq=1"


: '
for WGS data , deepvariant dosent work if we add filter --make_examples_extra_args="channels="
--make_examples_extra_args="channels=,vsc_min_count_snps=1,vsc_min_fraction_snps=0.05,vsc_min_count_indels=1,vsc_min_fraction_indels=0.05,min_mapping_quality=30,min_base_quality=15" \
--intermediate_results_dir ${intermediate_results} \
--postprocess_variants_extra_args="debug_output_all_candidates=ALT,cnn_homref_call_min_gq=1"
'

