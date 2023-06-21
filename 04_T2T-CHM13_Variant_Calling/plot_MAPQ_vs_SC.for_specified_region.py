import pysam
import seaborn as sns
import argparse
from matplotlib import pyplot as plt

# Create an argument parser to parse command-line arguments
parser = argparse.ArgumentParser(description="Plot number of soft clipped bases and mapping quality score from BAM file")
parser.add_argument('--bam', required=True, help='path to input BAM file')
parser.add_argument('--region', help='specific region to plot (format: "chromosome:start-end")')
parser.add_argument('--png', required=True, help='path to output PNG file')
parser.add_argument('--mapping_type', choices=['unique', 'multi'], default='unique_and_multi', help='mapping type to plot')
parser.add_argument('--title', help='title of the plot')
args = parser.parse_args()

# Extract the paths to the input BAM file, the output PNG file, the specific region, and the mapping type from the command-line arguments
output_png = args.png
input_bam = args.bam
region = args.region
mapping_type = args.mapping_type
title = args.title

# Open the input BAM file using pysam
bam_file = pysam.AlignmentFile(input_bam, "rb")

# Initialize empty lists to store the number of soft clipped bases and mapping qualities
soft_clipped_bases = []
mapping_qualities = []

# Iterate over each read in the BAM file
for read in bam_file.fetch(region=region):
    # Check the mapping type and filter the reads accordingly
    if mapping_type == 'unique' and not ('XS' in read.tags or 'XA' in read.tags):
        # Retrieve the CIGAR string for the read
        cigar = read.cigar
        # Calculate the number of soft clipped bases by summing the lengths of cigar operations with code 4 (soft clipping)
        soft_clip_bases = sum(length for op, length in cigar if op == 4)
        # Append the number of soft clipped bases and mapping quality to the respective lists
        soft_clipped_bases.append(soft_clip_bases)
        mapping_qualities.append(read.mapping_quality)
    elif mapping_type == 'multi' and ('XA' in read.tags):
        # Retrieve the CIGAR string for the read
        cigar = read.cigar
        # Calculate the number of soft clipped bases by summing the lengths of cigar operations with code 4 (soft clipping)
        soft_clip_bases = sum(length for op, length in cigar if op == 4)
        # Append the number of soft clipped bases and mapping quality to the respective lists
        soft_clipped_bases.append(soft_clip_bases)
        mapping_qualities.append(read.mapping_quality)
    elif mapping_type != 'unique' and mapping_type != 'multi' and not ('XS' in read.tags):
        # Retrieve the CIGAR string for the read
        cigar = read.cigar
        # Calculate the number of soft clipped bases by summing the lengths of cigar operations with code 4 (soft clipping)
        soft_clip_bases = sum(length for op, length in cigar if op == 4)
        # Append the number of soft clipped bases and mapping quality to the respective lists
        soft_clipped_bases.append(soft_clip_bases)
        mapping_qualities.append(read.mapping_quality)

# Set the plotting style and context using seaborn
sns.set_style("dark")
sns.set_context("paper")

# Create a figure for the plot
plt.figure(figsize=(3, 5))

# Use seaborn scatterplot to plot the number of soft clipped bases on the x-axis and mapping qualities on the y-axis
sns.scatterplot(y=soft_clipped_bases, x=mapping_qualities, alpha=0.5)

# Set the x-axis label and y-axis label
plt.ylabel('Number of Soft Clipped Bases')
plt.xlabel('Mapping Quality Score')

# Calculate the number of reads plotted
num_reads_plotted = len(soft_clipped_bases)

# Get the original title
original_title = title if title else ''

# Set the updated title with the number of reads plotted
updated_title = f'{original_title} (n={num_reads_plotted})'

# Set the title of the plot
plt.title(updated_title)

# Save the plot as a PNG file
plt.savefig(output_png)

