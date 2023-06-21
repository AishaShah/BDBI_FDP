#!/bin/bash

#SBATCH --job-name="LCL WGS samples CRAM to fastq"
#SBATCH --chdir=/gpfs/projects/bsc83/Data/ribosomal_RNA/PRJNA733656/WGS.1000_GENOMES/1000.Genomes.30X/scripts
#SBATCH --output=/gpfs/projects/bsc83/Data/ribosomal_RNA/PRJNA733656/WGS.1000_GENOMES/1000.Genomes.30X/scripts/out/cram2fastq.%A_%a.out
#SBATCH --error=/gpfs/projects/bsc83/Data/ribosomal_RNA/PRJNA733656/WGS.1000_GENOMES/1000.Genomes.30X/scripts/err/cram2fastq.%A_%a.err
#SBATCH --array=24-48
#SBATCH --cpus-per-task=16
#SBATCH --qos=bsc_ls
#SBATCH --time=08:00:00



genome_id_list=/gpfs/projects/bsc83/Data/ribosomal_RNA/PRJNA733656/WGS.1000_GENOMES/1000.Genomes.30X/scripts/PRJNA733656.1000_Genomes_ID.txt
export genome_id=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${genome_id_list} | cut -f2)

reference=/gpfs/projects/bsc83/Data/ribosomal_RNA/PRJNA733656/WGS.1000_GENOMES/1000.Genomes.30X/00_reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa
cram_path=/gpfs/projects/bsc83/Data/ribosomal_RNA/PRJNA733656/WGS.1000_GENOMES/1000.Genomes.30X/00_Cram_files
outpath=/gpfs/projects/bsc83/Data/ribosomal_RNA/PRJNA733656/WGS.1000_GENOMES/1000.Genomes.30X/01_fastq_files.nord3/${genome_id}

#create file named $genome_id if it doesn't exist before
# Check if the directory for above genome already exists
  if [[ ! -d "$outpath" ]]; then
    echo "Creating directory: $outpath"
    mkdir "$outpath"
  fi

# load required modules
module unload openmpi #(MN4)
module load impi samtools #(MN4)
#module load htslib samtools # (Nord3v2)
#module load java/8u131 picard

cram_file=${cram_path}/${genome_id}.final.cram
# index bam file
samtools index ${cram_file}

# bamToFastq
#/apps/PICARD/2.20.0/picard.jar  #(MN4)
#java -jar /apps/PICARD/2.20.0/picard.jar \
java -jar /apps/PICARD/2.27.4/picard.jar \
     SamToFastq \
     I=${cram_file} \
     FASTQ=${outpath}/${genome_id}.fastq_1.gz \
     SECOND_END_FASTQ=${outpath}/${genome_id}.fastq_2.gz \
     UNPAIRED_FASTQ=${outpath}/${genome_id}.fastq_unpaired.gz \
     INCLUDE_NON_PF_READS=true \
     INCLUDE_NON_PRIMARY_ALIGNMENTS=false \
     REFERENCE_SEQUENCE=${reference} \
     TMP_DIR=$TMPDIR
