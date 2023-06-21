import pysam
import seaborn as sns
import argparse
from matplotlib import pyplot as plt

# Create an argument parser to parse command-line arguments
parser = argparse.ArgumentParser(description="Plot Alignment Score and number of soft clipped bases from BAM file")
parser.add_argument('--bam', required=True, help='path to input BAM file')
parser.add_argument('--region', help='specific region to plot (format: "chromosome:start-end")')
parser.add_argument('--png', required=True, help='path to output PNG file')
args = parser.parse_args()

# Extract the paths to the input BAM file, the output PNG file, and the specific region from the command-line arguments
output_png = args.png
input_bam = args.bam
region = args.region

# Open the input BAM file using pysam
bam_file = pysam.AlignmentFile(input_bam, "rb")

# Initialize empty lists to store the Alignment Scores and number of soft clipped bases
alignment_scores = []
soft_clipped_bases = []

# Iterate over each read in the BAM file
for read in bam_file.fetch(region=region):
    # Retrieve the Alignment Score (AS tag) and the CIGAR string for the read
    alignment_score = read.get_tag('AS')
    cigar = read.cigar

    # Calculate the number of soft clipped bases by summing the lengths of cigar operations with code 4 (soft clipping)
    soft_clip_bases = sum(length for op, length in cigar if op == 4)

    # Append the Alignment Score and the number of soft clipped bases to the respective lists
    alignment_scores.append(alignment_score)
    soft_clipped_bases.append(soft_clip_bases)

# Set the plotting style and context using seaborn
sns.set_style("dark")
sns.set_context("paper")

# Create a figure for the plot
plt.figure(figsize=(10, 6))

# Use seaborn scatterplot to plot the Alignment Scores on the x-axis and the number of soft clipped bases on the y-axis
sns.scatterplot(x=alignment_scores, y=soft_clipped_bases, alpha=0.5)

# Set the x-axis label and y-axis label
plt.xlabel('Alignment Score')
plt.ylabel('Number of Soft Clipped Bases')

# Save the plot as a PNG file
plt.savefig(output_png)

