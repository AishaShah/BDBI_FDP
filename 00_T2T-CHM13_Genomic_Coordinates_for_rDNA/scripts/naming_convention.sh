#!/bin/bash

### NAMING CONVENTION

## replacing 5_8S_rRNA as RNA5-8SP and 5S_rRNA as RNA5SP


#FILE=/gpfs/projects/bsc83/Data/assemblies/T2T/feature_annotation/T2T_rDNA_annotation.sorted.bed
FILE=$1
PRINT_COLUMNS='print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9'
OUT_FILE=/gpfs/projects/bsc83/Data/assemblies/T2T/feature_annotation/check/T2T_rDNA_annotation_naming2.bed
OUT_FILE2=/gpfs/projects/bsc83/Data/assemblies/T2T/feature_annotation/check/T2T_rDNA_annotation_namesX.bed
BLAST_HITS=/gpfs/projects/bsc83/Data/assemblies/T2T/feature_annotation/T2T_rDNA_blastn_unannotated_GENES_PS.bed

# $9 have gene names, wrtie all annotated pseudogenes in OUT_FILE
cat ${FILE} | awk '{ gsub("5_8S_rRNA","RNA5-8SP0",$9) gsub("5S_rRNA","RNA5SP0",$9) ; print}' > ${OUT_FILE}

## Creating new names
awk '$9 ~ /RNA5SP[0-9]/ { print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" "RNA5SP-" ++n}' ${OUT_FILE} > ${OUT_FILE2}
awk '$9 ~ /RNA5S[0-9]/ {print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" "RNA5S-" ++n}' ${OUT_FILE} >> ${OUT_FILE2}

awk '$9 ~ /RNA5-8S[0-9]/ {print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" "RNA5_8S-" ++n}' ${OUT_FILE} >> ${OUT_FILE2}
awk '$9 ~ /RNA5-8SP[0-9]/ {print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t"  "RNA5_8SP-" ++n}' ${OUT_FILE} >> ${OUT_FILE2}

awk '$9 ~ /RNA18S[0-9]/ {print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" "RNA18S-" ++n}' ${OUT_FILE} >> ${OUT_FILE2}
awk '$9 ~ /RNA28S[0-9]/ {print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t"  "RNA28S-" ++n}' ${OUT_FILE} >> ${OUT_FILE2}
awk '$9 ~ /RNA45S[0-9]/ {print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t"  "RNA45S-" ++n}' ${OUT_FILE} >> ${OUT_FILE2}

cat ${BLAST_HITS} >> ${OUT_FILE2}

sort -k1,1V -k2,2n  -k3,3n ${OUT_FILE2} > T2T_rDNA_annotation_names.sortedX.bed
rm ${OUT_FILE}
