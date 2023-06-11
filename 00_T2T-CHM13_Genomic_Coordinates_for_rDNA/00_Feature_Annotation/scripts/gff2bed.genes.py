import os, sys,re

i=0
for line in sys.stdin:
  i+=1
  if line.startswith('#'):
    continue

  try:
    contig,pred,f,s,e,dot,strand,score,comment = line.split('\t')
  except:
    sys.stderr.write( "Warning: Wrong line %s: %s\n" % ( i,str(line.split('\t')) ) )
    continue

  if f == "gene":

    g = comment.split(';')[1]
    g_biotype = comment.split(';')[3] # gene biotype
    gene_name = comment.split(';')[5]
    
## try using regex
    biotype=re.search("gene_biotype=(.*?);",comment).group(1)
    source=re.search("source_gene_common_name=(.*?);",comment).group(1)
    geneId=re.search("gene_id=(.*?);",comment).group(1)
    name=re.search("Name=(.*?);",comment).group(1)
    #gene_name=re.search("gene_name=(.*?);",comment).group(1)

    s,e = int(s),int(e)
    #BED is 0-based, half-open
    s = s - 1
    print "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s" % ( contig,str(s),str(e),strand,f,biotype,source,geneId,name)


'''
are there any other columns???
source_transcript=ENST00000423796.1;
source_transcript_name=AC114498.1-201;
source_gene=ENSG00000235146.2;
transcript_modes=transMap;
gene_biotype=lncRNA;
transcript_biotype=lncRNA;
alignment_id=ENST00000423796.1-1;frameshift=nan;
exon_annotation_support=1,1;
intron_annotation_support=1;
transcript_class=ortholog;
valid_start=True;valid_stop=True;
adj_start=nan;adj_stop=nan;
proper_orf=True;level=2;
transcript_support_level=5;
tag=not_best_in_genome_evidence,basic;
havana_gene=OTTHUMG00000002329.1;
havana_transcript=OTTHUMT00000006707.1;
paralogy=nan;
unfiltered_paralogy=ENST00000423796.1-2;
gene_alternate_contigs=chr6:172104635-172111468;
source_gene_common_name=AC114498.1;
transcript_id=CHM13_T0000001;
gene_id=CHM13_G0000001;
Parent=CHM13_G0000001;
transcript_name=AC114498.1-201;
ID=CHM13_T0000001;
Name=AC114498.1;
gene_name=AC114498.1;
alternative_source_transcripts=N/A;
collapsed_gene_ids=N/A;
collapsed_gene_names=N/A;
extra_paralog=False
'''
