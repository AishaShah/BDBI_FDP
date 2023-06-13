
import sys

if "--help" in sys.argv:
    print("Usage: rename_or_extract_rDNA_fasta_sequences.py <filename> [chr] [sequence_number ...]")
    print("Arguments:")
    print("  <filename>            Path to the input file")
    print("  [chr]                 Optional: Specify the chromosome name")
    print("  [sequence_number ...] Optional: Specify the sequence_number(s) of chr to print")
    sys.exit(0)

filename = sys.argv[1]
if len(sys.argv) > 2:
    chr_input=sys.argv[2]
    sequence_number = sys.argv[3:]
else:
    chr_input=[]
    sequence_number = []

#filename = "check2.fa"
# input chr name and operon numbers seperated by space
file = open(filename, "r")

i = 0
prev = ""
operons = {}
for line in file:
    l=line.rstrip()
    if l:  # Skip empty lines
        if line[0] == ">":
            seq_name = line
            chr = seq_name[1:6]
            current_chr = chr
            if current_chr == prev:
                i += 1
            else:
                i = 1
                prev = current_chr
            #seq_name = seq_name +">" + chr + "_operon_" + str(i) + "\n"
            seq_name = ">" + chr + "_operon_" + str(i) + "\n"
        else:
            if chr not in operons:
                operons[chr] = [seq_name + line]
            else:
                operons[chr].append(seq_name + line)

file.close()

# Print the contents of the operons dictionary
if chr_input:
    for x in sequence_number:
        print(operons[chr_input][int(x)-1], end='')

else:
    for sequence_name, seqs in operons.items():
        for sequence in seqs:
            print(sequence)




