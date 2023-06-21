# Variant Calling For T2T-CHM13 RNAseq data
TFGL-AISHA SHAH

## Pre-processing bam files :

We have 1 bam files for each of 2 RNAseq libraries:

1.  First we extract Candidate rDNA reads using nucmer script given in
    directory  
    BDBI_FDP/nucmer_script/Extract_Candidate_reads_by_Nucmer.sh  
    See readme in above mentioned directory to see what nucmer script
    do.

    ``` bash
    sbatch Extract_Candidate_reads_by_Nucmer.sh --array=1-2 ${list_of_sample_ID_names}
    ```

2.  First we remove adaptors, trim sequences and map them all to rDNA
    consensus using following scripts  
    **All the scripts below uses for arrays to run for each sample in
    parallel**

    ``` bash
    sbatch 01.00.B.cutadapt.sh
    sbatch 01.01.B.candidate_rRNA_reads_to_T2T_masked_genes_and_pseudogenes.bwa.sh
    ```

3.  Removing over soft-clipped reads

    ``` bash
    sbatch 01.02.01.B.remove_soft_clipped.sh
    ```

4.  Variant calling by GATK per sample using ploidy 2, 5 and 10 and
    joint genotyping output gvcf files of 4 libraries to get one vcf
    file

    ``` bash
    sbatch 02.01.GATK.perSample.sh ${ploidy}
    sbatch 02.02.GATK.JointGenotyping.sh ${ploidy}
    ```

5.  Variant calling by Deepvariant per sample and Joint genotypyng all
    of them using GLnexus

    ``` bash
    sbatch 02.01.DeepVariant.perSample.sh
    sbatch 02.02.DeepVariant.JointGenotyping.sh
    ```
