# Identifying rDNA-like regions in T2T-CHM13 genome
TFGL-AISHA SHAH

We used BLASTn to extract rDNA-like regions from T2T-CHM13 genome using
unique gene sequences annotated in T2T-CHM13 genome. See
01_T2T-CHM13_Identifying_Unique_rDNA_copies to check how we extract
unique sequences.

We used the following BLASTn command line:

``` bash

#!/bin/bash
#SBATCH --job-name="Blast_Run to look for pseudogenes in T2T"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1  
#SBATCH --cpus-per-task=6
#SBATCH --time=02:00:00
#SBATCH --qos=bsc_ls


module load blast
# first we create database for T2T-CHM13 genome

makeblastdb -in T2T_CHM13_Genome.fa -dbtype nucl -out T2T_database

blastn -query uniq_rDNA_gene_sequences.fa  
       -db T2T_database 
       -max_target_seqs 900000000 
       -outfmt "6 delim=     qaccver saccver pident nident length mismatch gapopen qlen slen qstart qend sstart send evalue bitscore sstrand"
       -out blast_T2T.out
       
# max_target_seqs 900000000  allows to output more than 50 hit for each input sequence
```

From the output file we , we created a bed file having coordinates for
all hits that have percentage identity \> 90% and length of aligned
region \> 75% of any gene length . We remove all hits that were
overalapping any annotated gene in T2T-CHM13 genome using bedintersect
with T2T-CHM13 annoatteion file and considered remaining hits as
potential unannotated pseudogenes because of their length and sequence
similarity.

Further, we also kept all hits that were \> 30bp in length and having \>
95% identical sequence compared to any rDNA gene. These were not
considered as potential an annotated pseudogenes because of short length
but were masked from T2T-CHM13 genome to avoid multimapping.
