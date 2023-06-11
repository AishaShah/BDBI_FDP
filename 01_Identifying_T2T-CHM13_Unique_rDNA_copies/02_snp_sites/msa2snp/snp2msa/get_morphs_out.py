
import sys
filename = sys.argv[1]
# input chr name and operon numbers seperated by space
lst = input().split()
file = open(filename, "r")

operons = {}
for line in file:
    if line[0] == ">":
        seq_name = line
        chr = seq_name[1:6]
    else:
        if chr not in operons:
            operons[chr] = ['start from 1 \n', seq_name + line]
        else:
            operons[chr].append(seq_name + line)
file.close()
chr = lst[0]
lst = lst[1:]
for i in lst:
    print(operons[chr][int(i)], end='')
