# Variant Calling For T2T-CHM13 WGS data
TFGL-AISHA SHAH

## Pre-processing bam files :

We have 21 downsampled bam files for each of 4 WGS libraries:

1.  First we extract Candidate rDNA reads using nucmer script given in
    directory  
    BDBI_FDP/nucmer_script/Extract_Candidate_reads_by_Nucmer.sh  
    See readme in above mentioned directory to see what nucmer script
    do.

    ``` bash
    for sample_id in SRR1997411 SRR3189741 SRR3189742 SRR3189743; do

      sbatch Extract_Candidate_reads_by_Nucmer.sh --array=1-21 ${list_of_sample_ID_names}

    done
    ```

2.  First we map them all to rDNA consensus using following scripts

    ``` bash
    for sample_id in SRR1997411 SRR3189741 SRR3189742 SRR3189743; do

      sbatch 01.01.bwa.candidate_rRDNA_to_T2T_rDNA.sh "$sample_id"

    done
    ```

<!-- -->

2.  We merge all bam files for 4 libraries to have one bam per library
    instead of 21  
    All the scripts below uses for arrays to run for each sample in
    parallel

    ``` bash
    sbatch 01.02.merge_bams.sh 
    ```

3.  Removing over soft-clipped reads

    ``` bash
    sbatch 02.00.01.remove_over_softClipped.sh
    ```

4.  Applying base quality score recalibration using Gold-standard set of
    variants ss input.vcf

    ``` bash
    sbatch 02.00.02.BQSR.sh
    ```

5.  Variant calling by GATK per sample using ploidy 2, 5 and 10 and
    joint genotyping output gvcf files of 4 libraries to get one vcf
    file

    ``` bash
    sbatch 02.01.GATK.perSample.SC10.bqsr ${ploidy}
    sbatch 02.02.GATK.JointGenotyping.SC10.bqsr ${ploidy}
    ```

6.  Variant calling by Deepvariant per sample and Joint genotypyng all
    of them using GLnexus

    ``` bash
    sbatch 03.01.DeepVariant.perSample.SC10.bqsr
    sbatch 03.02.DeepVariant.JointGenotyping.SC10.bqsr
    ```
