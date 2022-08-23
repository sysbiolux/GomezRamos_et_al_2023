# GomezRamos_et_al_2023

Code used for the analysis of the RNA-seq, ATAC-seq and ChIP-seq datasets produced in this study. Original fastq files deposited in https://ega-archive.org/, under the accession number EGAD00001009288.    

## Getting started

Different folders are included in this repository:

- RNA-seq folder: contains all the code used for RNA-seq analysis. Two different datasets were analyzed: time course differentiation of mDAN, including smNPC and Astrocytes at day 65 of differentiation, and TF KD samples. 

- ATAC-seq folder: contains all the code used for ATAC-seq analysis of the time course data. Remember that ATAC and RNA sequencing are paired samples. Used the date of the fastq files to associate both datasets

- ChIP-seq folder: contains all the code used for ChIP-seq analysis. Take into account that although single-end sequencing was used, R1 and R2 fastq files are available per sample. Please check the guidelines of Active Motif to understand why (https://www.activemotif.com/documents/2056.pdf) 

