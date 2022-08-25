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

[Genrich](https://github.com/jsh58/Genrich) is performing the following tasks:

- exclude reads mapping to the mitochondrial (`-e chrM`)
- remove duplicates, like MarkDuplicates according to the reference, fast since sorted by read names (`-r`)
- filter low mapping quality (`-m 30`). Standard threshold used that results in 0.1% error.
- filter out reads (`-E`) in regions known as non mappable (`hg38.blacklist.bed.gz`) downloaded [http://mitra.stanford.edu](http://mitra.stanford.edu/kundaje/akundaje/release/blacklists/hg38-human/hg38.blacklist.bed.gz)
- `-j` for ATAC-seq settings, adjusting for the +5/-5 due to Tn5.

Jochen found that to get sharper peaks with better separation, one should use `-a 150 -g 15 -l 15 -d 50` 
(`-a 150` to include small peak intervals, 
`-d 50` is good enough for separation and `-d 25` might cut the peaks too narrow.)

Several output files are produced:

- `narrowPeak` with `-o`
- `BedGraph` with `-k`. Can be converted to bigwig after sorting by chr, position
- `log file` with `-f`. Those specific files to Genrich can be used to re-call peaks faster

Of note, we observed a substantial improvement when Genrich version *0.6* was released. This is the release used.


! the `*.filtered.narrowPeak` files used as input for HINT-ATAC and EPIC-DREM were generated using these parameters
`-a 500 -g 15 -l 15 -d 50`


- Command and arguments to generate BedGraph from BAM files.

```
parallel -j 6 "Genrich -j -v -a 500 -g 15 -l 15 -d 50 -t {} -o {.}_filtered.narrowPeak -k {.}.bg -f {.}.log " ::: *.bam
```