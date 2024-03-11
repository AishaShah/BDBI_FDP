#!/bin/bash


#SBATCH --job-name="stat SC10: T2T_rDNA trimmed candidate RNAseq reads mapped to masked T2T (genes and PS) + blast hits + rDNA_genes_consensus (bwa)"
#SBATCH --chdir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts
#SBATCH --output=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/cons_uniq_morphs.T2T_masked_small_blast_hits/out/01.02.02.B.statistics.SC10.%A_%a.out
#SBATCH --error=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/scripts/cons_uniq_morphs.T2T_masked_small_blast_hits/err/01.02.02.B.statistics.SC10.%A_%a.err
#SBATCH --array=1-2
#SBATCH --cpus-per-task=16
#SBATCH --qos=bsc_ls
#SBATCH --time=00:50:00


# Refrence : Consensus for 45S + 5S + T2T.masked(annotated genes and PS + blast hits)

# load modules
module load htslib # Nord3v2
module load samtools # Nord3v2


export sample_id=$(sed -n "${SLURM_ARRAY_TASK_ID}p" T2T_RNAseq.tab  | cut -f1)

outpath=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/01_mapping/Consensus_Uniq_Morphs/masked.small_blast_hits.genes.pseudogenes.trimmedQC/${sample_id}
outdir=/gpfs/projects/bsc83/Projects/ribosomal_RNAs/Aisha/T2T_variant_calling/03_T2T_RNAseq_variant_calling/01_mapping/Consensus_Uniq_Morphs/masked.small_blast_hits.genes.pseudogenes.trimmedQC/statistics.f2F2308
#outfile=${outdir}/${sample_id}.counts
outfile=${outdir}/${sample_id}.new.SC10.counts
mkdir -p ${outdir}

################################################################
#   Statistics                                                 #
################################################################


echo "**************************************"
echo "Start counting reads  : $(date)"
#outfile_with_sc=${outpath}/${sample_id}.sorted.RG.filtered_f2F2308.bam
#outfile_without_sc=${outpath}/${sample_id}.sorted.RG.filtered_f2F2308.SC10.bam


#samtools view  ${outpath}/${sample_id}.sorted.RG.filtered_f2F2308.SC10.bam | grep "XA:"| grep -v "SA:" | awk '/T2T\_45S\,([+-][0-9]*)\,/ {print $18}'  | awk -F":" '$1=$1' OFS="\t" | awk '{print $3}' | awk -F "T2T_45S" '{print "T2T_45S"$2}' | awk -F";|,|+|-" '$1=$1' OFS="\t" |awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' | awk '{
#  cigar=$3;
#  n=length(cigar);
#  left_soft=0;
#  right_soft=0;
#  i=1;
#  while(i<=n) {
#    len="";
#    while(substr(cigar,i,1)~/[0-9]/) {
#      len=len substr(cigar,i,1);
#      i++;
#    }
#    op=substr(cigar,i,1);
#    i++;
#    if(op=="S") {
#      if(left_soft==0) {
#        left_soft=len;
#      } else {
#        right_soft=len;
#      }
#    }
#  }
#  soft_clipped=left_soft+right_soft;
#  total=151;
#  print $1,$2,$3,$4,soft_clipped ,soft_clipped*100/total"%";
#}' > ${outpath}/${sample_id}.sorted.RG.filtered_f2F2308.SC10.Not_primary_alignment_to_T2T_45S.bed




MM_bed=${outpath}/${sample_id}.sorted.RG.filtered_f2F2308.SC10.Not_primary_alignment_to_T2T_45S.bed
MNP_45S=$(awk '{if($2>0 && $2<13363) print}' ${MM_bed} | awk '{if($5<=10) print}' |wc -l)
MNP_5ETS=$(awk '{if($2>1 && $2<3652) print}' ${MM_bed} | awk '{if($5<=10) print}' | wc -l)
MNP_18S=$(awk '{if($2>3654 && $2<5521) print}' ${MM_bed}  | awk '{if($5<=10) print}' | wc -l)
MNP_ITS1=$(awk '{if($2>5522 && $2<6597) print}' ${MM_bed} | awk '{if($5<=10) print}' | wc -l)
MNP_58S=$(awk '{if($2>6599 && $2<6754) print}' ${MM_bed}  | awk '{if($5<=10) print}' | wc -l)
MNP_ITS2=$(awk '{if($2>6755 && $2<7922) print}' ${MM_bed} | awk '{if($5<=10) print}' | wc -l)
MNP_28S=$(awk '{if($2>7924 && $2<13002) print}' ${MM_bed} | awk '{if($5<=10) print}' | wc -l)
MNP_3ETS=$(awk '{if($2>13003 && $2<13363) print}' ${MM_bed} | awk '{if($5<=10) print}' | wc -l)

M_T2T=$((${MNP_45S}))

#bam=${outpath}/${sample_id}.sorted.RG.filtered_f2F2308.bam
bam=${outpath}/${sample_id}.sorted.RG.filtered_f2F2308.SC10.bam
# (after filteration --> remove unmapped, secondary,supplementary)
# Total reads mapped 
TOTAL_IN_BAM=$(samtools view -c ${bam})
T_45S=$(samtools view -c ${bam} T2T_45S)
T_T2T=$((${TOTAL_IN_BAM}-${T_45S}))

T_5ETS=$(samtools view -c ${bam} T2T_45S:1-3652)
T_18S=$(samtools view -c ${bam} T2T_45S:3654-5521)
T_ITS1=$(samtools view -c ${bam} T2T_45S:5522-6597)
T_58S=$(samtools view -c ${bam} T2T_45S:6599-6754)
T_ITS2=$(samtools view -c ${bam} T2T_45S:6755-7922)
T_28S=$(samtools view -c ${bam} T2T_45S:7924-13002)
T_3ETS=$(samtools view -c ${bam} T2T_45S:13003-13363)
T_5S=$(samtools view -c ${bam} T2T_5S)

# Total Multimapped reads having primary alignments with rDNA consensus
M_45S=$(samtools view ${bam} T2T_45S | grep "XA:" | wc -l)
M_5ETS=$(samtools view ${bam} T2T_45S:1-3652 | grep "XA:" | wc -l)
M_18S=$(samtools view ${bam} T2T_45S:3654-5521 | grep "XA:" | wc -l)
M_ITS1=$(samtools view ${bam} T2T_45S:5522-6597 | grep "XA:" | wc -l)
M_58S=$(samtools view ${bam} T2T_45S:6599-6754 | grep "XA:" | wc -l)
M_ITS2=$(samtools view ${bam} T2T_45S:6755-7922 | grep "XA:" | wc -l )
M_28S=$(samtools view ${bam} T2T_45S:7924-13002 | grep "XA:" | wc -l)
M_3ETS=$(samtools view ${bam} T2T_45S:13003-13363 | grep "XA:" | wc -l)
M_5S=$(samtools view ${bam} T2T_5S | grep "XA:" | wc -l)

MNP_T2T=$((${M_45S}+${M_5S}))


# Total UniquelyMapped reads
Total_uniquely_mapped=$(samtools view ${bam} | grep -v "XA:" | wc -l)
U_45S=$(samtools view ${bam} T2T_45S | grep -v "XA:" | wc -l)
U_T2T=$((${Total_uniquely_mapped}-${U_45S}))

U_5ETS=$(samtools view ${bam} T2T_45S:1-3652 | grep -v "XA:" | wc -l)
U_18S=$(samtools view ${bam} T2T_45S:3654-5521 | grep -v "XA:" | wc -l)
U_ITS1=$(samtools view ${bam} T2T_45S:5522-6597 | grep -v "XA:" | wc -l)
U_58S=$(samtools view ${bam} T2T_45S:6599-6754 | grep -v "XA:" | wc -l)
U_ITS2=$(samtools view ${bam} T2T_45S:6755-7922 | grep -v "XA:" | wc -l )
U_28S=$(samtools view ${bam} T2T_45S:7924-13002 | grep -v "XA:" | wc -l)
U_3ETS=$(samtools view ${bam} T2T_45S:13003-13363 | grep -v "XA:" | wc -l)
U_5S=$(samtools view ${bam} T2T_5S | grep -v "XA:" | wc -l)

# $((${one}+${two}))
echo "sample" "region" "mapped_reads" "Total_Multimapped" "Multimapped_PA" "Multimapped_SA" "UniquelyMapped" >> ${outfile}
echo ${sample_id} "T2T" ${T_T2T} "NA" ${M_T2T} ${MNP_T2T} ${U_T2T} >> ${outfile}
echo ${sample_id} "45S" ${T_45S} $((${M_45S}+${MNP_45S})) ${M_45S} ${MNP_45S} ${U_45S} >> ${outfile}
echo ${sample_id} "5ETS" ${T_5ETS} $((${M_5ETS}+${MNP_5ETS})) ${M_5ETS} ${MNP_5ETS} ${U_5ETS} >> ${outfile}
echo ${sample_id} "18S" ${T_18S} $((${M_18S}+${MNP_18S})) ${M_18S} ${MNP_18S} ${U_18S} >> ${outfile}
echo ${sample_id} "ITS1" ${T_ITS1} $((${M_ITS1}+${MNP_ITS1})) ${M_ITS1} ${MNP_ITS1} ${U_ITS1} >> ${outfile}
echo ${sample_id} "5-8S" ${T_58S} $((${M_58S}+${MNP_58S})) ${M_58S} ${MNP_58S} ${U_58S} >> ${outfile}
echo ${sample_id} "ITS2" ${T_ITS2} $((${M_ITS2}+${MNP_ITS2})) ${M_ITS2} ${MNP_ITS2} ${U_ITS2} >> ${outfile}
echo ${sample_id} "28S" ${T_28S} $((${M_28S}+${MNP_28S})) ${M_28S} ${MNP_28S} ${U_28S} >> ${outfile}
echo ${sample_id} "3ETS" ${T_3ETS} $((${M_3ETS}+${MNP_3ETS})) ${M_3ETS} ${MNP_3ETS} ${U_3ETS} >> ${outfile}
echo ${sample_id} "5S" ${T_5S} ${M_5S} ${M_5S} "NA" ${U_5S} >> ${outfile}

echo "End counting reads : $(date)"
echo "**************************************"
echo ""

