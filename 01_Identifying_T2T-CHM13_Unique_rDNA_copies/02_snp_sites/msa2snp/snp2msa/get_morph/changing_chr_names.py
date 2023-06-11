
import sys
filename = sys.argv[1]
file = open(filename, "r")


list_names = ["chr13_operon_1", "chr13_operon_6", "chr13_operon_74", "chr13_operon_75", "chr13_operon_76",
              "chr14_operon_1", "chr14_operon_2", "chr14_operon_16",
              "chr15_operon_1", "chr15_operon_2", "chr15_operon_18", "chr15_operon_34", "chr15_operon_35", "chr15_operon_50",
              "chr21_operon_1", "chr21_operon_2", "chr21_operon_18", "chr21_operon_55", "chr21_operon_56",
              "chr22_operon_1", "chr22_operon_18", "chr22_operon_19", "chr22_operon_20", "chr22_operon_21"]

seq = 0
for line in file:
    if line[0] == ">":
        seq_name = line
        # print(seq_name)
        seq_name = ">" + list_names[seq]
        print(seq_name)
        seq = seq+1
    else:
        print(line)

file.close()
