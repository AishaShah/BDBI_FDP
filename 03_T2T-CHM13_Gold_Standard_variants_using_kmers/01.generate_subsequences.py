#!/usr/bin/env python

###########################################
####            FUNCTIONS              ####
###########################################

'''
INPUT : 
        1.fasta file, one comple fasta sequence was in single line --> no line breaks 
        2.Size of subsequences to be generated
        3.Output directory prefix
        4.Coverage (how many time each kmer seq will be repeated) --> not implemented yet
EXAMPLE : 

subsequences.py test.fa 150 test_directory

OUTPUT : A directory having fasta and fastq files for subsequences
'''


'''
FUNCTION NAME : generate_subsequences()
INPUT         : Fasta Sequence, size of subsequences
OUTPUT        : Two list having all subsequences of given fasta sequence and window size
                List 1: Fasta sequences --> we can modify the script to just print these sequences instead of storing them (to optimize)
                List 2 : fastq sequences

Example :
Seq                    : ACGTA
SubSeq_size            : 4
Number of subsequences : len(Seq) - SubSeq_size + 1 --> 5-4+1 = 2
Output                 : [ [>seq_name_sub_seq_1:1-4 , ACGT], 
                           [>seq_name_sub_seq_2:2-5 , CGTA]  ]
                         
                         [[@seq_name_sub_seq_1 1 length=4 , ACGT, +seq_name_sub_seq_1 1 length=4 , IIII], 
                          [@seq_name_sub_seq_2 2 length=4 , CGTA, +seq_name_sub_seq_2 2 length=4 , IIII]  ]
'''


def generate_subsequences(seq, SubSeq_size, seq_name): 
    sub_sequences_fastq=[]                      # dictionary to store all subsequences (fastq format)
    sub_sequences_fasta = []                    # dictionary to store all subsequences (fasta format)
    n_SubSeq = len(seq) - SubSeq_size + 1       # number of subsequences to be generated
    for i in range(n_SubSeq):
        sub_seq = seq[i:i + SubSeq_size]
        ## FOR FASTA
        sub_seq_name = seq_name + "_sub_sequence_" + str(i+1) + ":" + str(i+1) + "-" +str(i+SubSeq_size)
        sub_sequences_fasta.append([sub_seq_name,sub_seq]) 

        ## FOR FASTQ
        seq_name_fastq=seq_name[1:] + "_sub_sequence_" + str(i+1) + " " + str(i+1) + " " + "length=" + str(SubSeq_size) ## header for fastq
        line1="@"+seq_name_fastq 
        line3="+"+seq_name_fastq 
        quality="I"*SubSeq_size
        sub_sequences_fastq.append([line1, sub_seq,line3,quality])
        
    return (sub_sequences_fasta,sub_sequences_fastq)


# This Function prints out all subsequences generated for all input sequences in FASTA file

def print_SubSeqs_fasta(Sub_Sequences,filename,coverage):
    f = open(filename,'w') 
    for sequence in Sub_Sequences:
        for SubSeq in sequence:
            for i in range(coverage):
                f.write(SubSeq[0] + '\n') ## name
                f.write(SubSeq[1] + '\n') ## sequence
    f.close()


# This Function prints out all subsequences generated for all input sequences in FASTQ file
def print_SubSeqs_fastq(Sub_Sequences,filename,coverage):
    f = open(filename,'w')
    for sequence in Sub_Sequences:
        for SubSeq in sequence:
            for i in range(coverage):
                f.write(SubSeq[0]+ '\n') ## name
                f.write(SubSeq[1]+ '\n') ## sequence
                f.write(SubSeq[2]+ '\n') ## name
                f.write(SubSeq[3]+ '\n') ## quality
    f.close()

###########################################
####          MAIN code                ####
###########################################


import sys
import os

# Check if help parameter is passed
if "-h" in sys.argv or "--help" in sys.argv:
    print("Usage: python script.py <filename> <SubSequence_size> <out_dir_name> <coverage>")
    print("Arguments:")
    print("  <filename>           Path to the input file")
    print("  <SubSequence_size>   Size of subsequences to be generated")
    print("  <out_dir_name>       Output directory name")
    print("  <coverage>           Coverage (how many times each subsequence will be repeated)")
    sys.exit(0)



filename = sys.argv[1]      # INPUT file name from terminal
SubSequence_size = int(sys.argv[2]) # INPUT sub_sequence size
out_dir_name=sys.argv[3] # output directory name
coverage = int(sys.argv[4])
## Creatinga new directory for output files
#Initialize the directory name
dirname = out_dir_name +".len_"+str(SubSequence_size)+".cov_"+str(coverage) 
#Check the directory name exist or not
if os.path.isdir(dirname) == False:
    #Create the directory
    os.mkdir(dirname)
    #Print success message
    print("Directory named "+dirname+" is created.")
else:
    #Print the message if the directory exists
    print("The directory "+dirname+"already exists.")





#filename="one_seq.fa"
file = open(filename, "r")

# Dictionaries to store Sub_Sequences for all input sequences --> not necessary -_> we can just print them instaed of storing
Sub_Sequences_fasta=[]
Sub_Sequences_fastq=[]

          
for line in file:
    if line.rstrip():      # Ignore empty lines
        if line[0] == ">": # Read sequence name
            seq_name = line.rstrip()
        else:
            sequence=line.rstrip()
            sub_seq_fasta,sub_seq_fastq=generate_subsequences(sequence,SubSequence_size,seq_name) # Generate subsequences
            # Append subsequnces to Sub_Sequences dictionary
            Sub_Sequences_fasta.append(sub_seq_fasta)
            Sub_Sequences_fastq.append(sub_seq_fastq)

file.close()

 

fasta_file=dirname+"/T2T_rRNA_SubSequences.len_" + str(SubSequence_size) + ".cov_" + str(coverage) +".fa"
fastq_file=dirname+"/T2T_rRNA_SubSequences.len_" + str(SubSequence_size) + ".cov_" + str(coverage) +".fq"


## Print Subsequences for all input sequences
print_SubSeqs_fasta(Sub_Sequences_fasta,fasta_file,coverage)
print_SubSeqs_fastq(Sub_Sequences_fastq,fastq_file,coverage)














