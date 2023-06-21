# Variant Calling For T2T-CHM13 data
TFGL-AISHA SHAH

Scripts for Variant Calling on WGS Data : `00_WGS/scripts` (check Readme
in this directory)

Scripts for Variant Calling on RNA-seq data : `00_WGS/scripts` (check
Readme in this directory)

Script `plot_AS_vs_SC.for_specified_region.py` is based on pysam and was
used to get plots for Alignemnet score vs number of soft clipped bases
for reades with specified mappy type and in specific region defined by
input parameters:  

``` bash
python3 plot_MAPQ_vs_SC.for_specified_region.py --help
```

    usage: plot_MAPQ_vs_SC.for_specified_region.py [-h] --bam BAM
                                                      [--region REGION] --png PNG
                                                      [--mapping_type {unique,multi}]
                                                      [--title TITLE]

    Plot number of soft clipped bases and mapping quality score from BAM file

    optional arguments:
      -h, --help            show this help message and exit
      --bam BAM             path to input BAM file
      --region REGION       specific region to plot (format: "chromosome:start-
                            end")
      --png PNG             path to output PNG file
      --mapping_type {unique,multi}
                            mapping type to plot
      --title TITLE         title of the plot

`plot_MAPQ_vs_SC.for_specified_region.py` is the same as above but plot
Mapping Qualities vs Numbe rof soft clipped bases.
