# ATAC-seq processing

by **Jochen Ohnmacht & A. Ginolhac**

## raw reads processing and mapping to hg38

Steps: FASTQ -> trimming -> mapping.

Workflow in paleomix where:

- trimming with AdapterRemoval with parameters
    + adapter1 and adapter2 are CTGTCTCTTATACACATCT
    + min length after trimming 35
    + no collapse of overlapping reads
    + rest is as default



- mapping with BWA. 

The backtrack and not the `mem` algorithm is picked because the reads are rather short and we want precise genome locations


- reference is the human genome **GRCh38, patch 1** (`GRCh38.p1.fasta`) 

All unplaced contigs are kept (so 194 chromosomes/contigs in total) to allow reads to map wherever they exhibit similarities.
The minimal mapping quality of **30** will then be used to filter out misplaced reads or reads with low-confidence mapping.

Once the BAM files obtained, no filtering except the unampped is done.
Files are sorted by read names instead of genome coordinates. This latter step is also where we keep only the canonical references: autosomes, gonosomes and mitochondrial references.

## Peak calling with Genrich

- Version 0.6 https://github.com/jsh58/Genrich

- Command and arguments to generate BedGraph from BAM files.

```
parallel -j 6 "Genrich -j -v -a 500 -g 15 -l 15 -d 50 -t {} -o {.}_filtered.narrowPeak -k {.}.bg -f {.}.log " ::: *.bam
```