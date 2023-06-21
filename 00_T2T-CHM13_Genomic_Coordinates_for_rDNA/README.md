# Feature Annotation in T2T-CHM13 Genome
TFGL-AISHA SHAH

# Coordinates for rDNA genes and rDNA-like regions in T2T-CHM13 genome

rDNA-like regions are pseudogenes or regions recognized by BLAST hits
that are highly identical to rDNA genes

Create bed file with all annotated genes in T2T-CHM13 genome using
T2T-gff3 file

``` bash
cat ../T2T.gff3 | python scripts/gff2bed.genes.py > T2T_gene_annotation.bed
```

Create bed file with annotated rDNA genes in above file
T2T_gene_annotation.bed Excluding rDNA anntated pseudogenes 6th column
have feature type

``` bash
cat T2T_gene_annotation.bed | awk '{if($6=="rRNA") print }' | grep -v "RNA5SP\|5S_rRNA\|AC243569.1\|5_8S_rRNA" > T2T_rDNA_gene_annotation.bed
```

Create bed file with annotated rDNA pseudogenes in
T2T_gene_annotation.bed 6th column have feature type. some of the
pseudogenes are wrongly annoatetd as rRNA instead of rRNA_pseudogene.

``` bash
cat T2T_gene_annotation.bed | awk '{if($6=="rRNA") print }' | grep "RNA5SP\|5S_rRNA\|AC243569.1\|5_8S_rRNA" > T2T_rDNA_pseudogene_annotation.bed
cat T2T_gene_annotation.bed | awk '{if($6=="rRNA_pseudogene") print }'>> T2T_rDNA_pseudogene_annotation.bed
sort -k1,1V -k2,2n  -k3,3n T2T_rDNA_pseudogene_annotation.bed > T2T_rDNA_pseudogene_annotation.bed
```

Naming Convention Changing names of rDNA sequences: Annotated pseudo
genes are named as GeneName-SP-X (X= 1 …Number of annotated pseufogenes)
Unannotated potential pseudogenes identified by blast are named as
GeneName-uSP-X

``` bash
./scripts/naming_convention.sh T2T_rDNA_annotation.sorted.bed
output file : T2T_rDNA_gene_annotation_names.sorted.bed
```

Check file **`02_T2T-CHM13_Identifying_Pseudogenes`** to see how
following bedfiles for rDNA-like regions were created:

1.  T2T_rDNA_blastn_unannotated_GENES_PS.bed
2.  T2T_rDNA_blastn_unannotated_GENES_PS_furtherMasking.sorted.bed

# Masking T2T-CHM13 genome :

We masked T2T-CHM13 genome in order to create a customized assembly for
effecient rDNA reads mapping and variant calling using WGS and RNAseq
data.

### Masking round 1 :

1.  All annotated genes in file `T2T_rDNA_gene_annotation.bed` were
    masked
2.  All annotated pseudogenes in file
    `T2T_rDNA_pseudogene_annotation.bed` were masked
3.  Blast hits that were covering 75% of gene length were masked :
    `T2T_rDNA_blastn_unannotated_GENES_PS.bed`

### Masking round 2 :

blast hits \> 30bp having percentage identity\>90% with rDNA genes File
name : `T2T_rDNA_blastn_unannotated_GENES_PS_furtherMasking.sorted`

since reads length are 151bp (T2T) and 76bp (GTEx) so it is better to
mask blast hits of length 30 bp and \> 90% identical to rDNA genes
