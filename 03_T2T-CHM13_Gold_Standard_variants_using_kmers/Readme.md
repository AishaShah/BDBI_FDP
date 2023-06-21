# Creating Gold standard set of variants in T2T-CHM13 genome using
Gold-standard set of variants
TFGL-AISHA SHAH

<img src="images/Screenshot%20from%202023-06-21%2018-52-43.png"
data-fig-align="center"
alt="Pipline for Extracting Gold-Standard set of variants in T2T-Genome" />

For extracting variants present in T2T-CHM13 genome with their Allele
frequencies, we simulated kmers of 219 rDNA copies using script
`01.generate_subsequences.py` :  
This script generates fasta and fastq files for kmers. In fastq each
base is assigned the highest possible base quality.

(we do not introduce any sequencing errors)

``` bash
python3 01.generate_subsequences.py --help
```

    Usage: python generate_sunsequences.py <filename> <SubSequence_size> <out_dir_name> <coverage>
    Arguments:
      <filename>           Path to the input file
      <SubSequence_size>   Size of subsequences to be generated
      <out_dir_name>       Output directory name
      <coverage>           Coverage (how many times each subsequence will be repeated)

We generated these reads with their coverage in T2T-CHM13 genome i.e
using coverage=1

``` bash
python3 01.generate_subsequences.py T2T_rDNA45S_219_fasta_sequences.fa 151 ${outpath} 1
```

We used bwa-mem to map these reads using script
`02.map_kmer_to_consnesus.bwa.addRG.index.sh`

``` bash
sbatch 02.map_kmer_to_consnesus.bwa.addRG.index.sh ${kmers_FASTQ_file} ${outpath}
```

And Finally we use GATK haplotype Caller to call variants using script
`03.GATK_haploCall.sh`

``` bash
sbatch 03.GATK_haploCall.sh ${kmers_mapped_to_consensus_BAM} ${outpath}
```
