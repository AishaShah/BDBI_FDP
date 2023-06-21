#!/bin/bash

#SBATCH --job-name="Plotting MAPQ vs SC for kept reads"
#SBATCH --chdir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts
#SBATCH --output=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/cons_uniq_morphs.T2T_masked_small_blast_hits/out/03.plot_BAM_stats.%A_%a.out
#SBATCH --error=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/cons_uniq_morphs.T2T_masked_small_blast_hits/err/03.plot_BAM_stats.%A_%a.err
#SBATCH --cpus-per-task=16
#SBATCH --qos=bsc_ls
#SBATCH --time=03:00:00


module load htslib # Nord3v2
module load samtools # Nord3v2
module load sambamba # Nord3v2
module load python/3.9.10

DIR=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/cons_uniq_morphs.T2T_masked_small_blast_hits
#python3 ${PATH}/plot_MAPQ_vs_SC.py --bam /gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/01_mapping/Consensus_Uniq_Morphs/masked.small_blast_hits.genes.pseudogenes/CHM13_1_S182/CHM13_1_S182.sorted.RG.filtered_f2F2308.SC10.bam --png ${PATH}/Soft_clipped_reads_removed_SC10.MAPQ_vs_SC.png

SAMPLE_ID=CHM13_1_S182

## Plotting MAPQ vs Number of Soft-clipped Reads for uniquely mapped reads in specified region


# READS KEPT
BAM=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/01_mapping/Consensus_Uniq_Morphs/masked.small_blast_hits.genes.pseudogenes/${SAMPLE_ID}/${SAMPLE_ID}.sorted.RG.filtered_f2F2308.SC10.bam
python3 ${DIR}/plot_MAPQ_vs_SC.for_specified_region.Uniquely_Mapped.py --bam ${BAM} --png ${DIR}/plots/${SAMPLE_ID}.Reads_Kept.SC10.MAPQ_vs_SC.18S_region.UM.png --region T2T_45S:3653-5521
python3 ${DIR}/plot_MAPQ_vs_SC.for_specified_region.Uniquely_Mapped.py --bam ${BAM} --png ${DIR}/plots/${SAMPLE_ID}.Reads_Kept.SC10.MAPQ_vs_SC.28S_region.UM.png --region T2T_45S:7923-13002

BAM_TRIMMED=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/01_mapping/Consensus_Uniq_Morphs/masked.small_blast_hits.genes.pseudogenes.trimmedQC/${SAMPLE_ID}/${SAMPLE_ID}.sorted.RG.filtered_f2F2308.SC10.bam
python3 ${DIR}/plot_MAPQ_vs_SC.for_specified_region.Uniquely_Mapped.py --bam ${BAM_TRIMMED} --png ${DIR}/plots/${SAMPLE_ID}.trimmedQC.Reads_Kept.SC10.MAPQ_vs_SC.18S_region.UM.png --region T2T_45S:3653-5521
python3 ${DIR}/plot_MAPQ_vs_SC.for_specified_region.Uniquely_Mapped.py --bam ${BAM_TRIMMED} --png ${DIR}/plots/${SAMPLE_ID}.trimmedQC.Reads_Kept.SC10.MAPQ_vs_SC.28S_region.UM.png --region T2T_45S:7923-13002

# before removing soft clipped reads
BAM_TRIMMED_unfiltered=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/01_mapping/Consensus_Uniq_Morphs/masked.small_blast_hits.genes.pseudogenes.trimmedQC/${SAMPLE_ID}/${SAMPLE_ID}.sorted.RG.filtered_f2F2308.bam
python3 ${DIR}/plot_MAPQ_vs_SC.for_specified_region.Uniquely_Mapped.py --bam ${BAM_TRIMMED_unfiltered} --png ${DIR}/plots/${SAMPLE_ID}.trimmedQC.unfiltered.MAPQ_vs_SC.18S_region.UM.png --region T2T_45S:3653-5521
python3 ${DIR}/plot_MAPQ_vs_SC.for_specified_region.Uniquely_Mapped.py --bam ${BAM_TRIMMED_unfiltered} --png ${DIR}/plots/${SAMPLE_ID}.trimmedQC.unfiltered.MAPQ_vs_SC.28S_region.UM.png --region T2T_45S:7923-13002

BAM_unfiltered=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/01_mapping/Consensus_Uniq_Morphs/masked.small_blast_hits.genes.pseudogenes/${SAMPLE_ID}/${SAMPLE_ID}.sorted.RG.filtered_f2F2308.bam
python3 ${DIR}/plot_MAPQ_vs_SC.for_specified_region.Uniquely_Mapped.py --bam ${BAM_unfiltered} --png ${DIR}/plots/${SAMPLE_ID}.unfiltered.MAPQ_vs_SC.18S_region.UM.png --region T2T_45S:3653-5521
python3 ${DIR}/plot_MAPQ_vs_SC.for_specified_region.Uniquely_Mapped.py --bam ${BAM_unfiltered} --png ${DIR}/plots/${SAMPLE_ID}.unfiltered.MAPQ_vs_SC.28S_region.UM.png --region T2T_45S:7923-13002


