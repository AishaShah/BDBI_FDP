#!/bin/bash


# Read the links from file

dir=~/marenostrum/Data/ribosomal_RNA/PRJNA733656/WGS.1000_GENOMES/1000.Genomes.30X/00_Cram_files
mkdir "$dir"

while read -r link; do


  # Extract the directory name i.e genomeId from the link
  # dir=$(echo "$link" | awk -F '/' '{print $8}' | awk -F '.' '{print $1}')
   file=$(echo "$link" | awk -F '/' '{print $8}')
  
  # Check if the directory for above genome already exists
  #if [[ ! -d "$dir" ]]; then
  #  echo "Creating directory: $dir"
  #  mkdir "$dir"
  #fi

  if [[ -f "$dir/$file" ]]; then
        echo "File $file already exists in directory $dir, skipping download"
    else
        echo "Downloading $file to directory $dir"
        wget "$link" -P "$dir"
   fi
done < PRJNA733656.1000_Genomes_ID.ftp_links.HG02588.txt

# TEST link ---> PRJNA733656.1000_Genomes_ID.ftp_links.HG02588.txt
# Links for files to be downloaded --> PRJNA733656.1000_Genomes_ID.ftp_links.txt
