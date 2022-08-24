rule multiqc:
  input:
    fastqc_atac = "../atac/fastq/{sample}_read1.fastqc.html",
    fastqc_rna = "../rna/fastq/{sample}_read1.fastqc.html",
    fastq_screen = "qc/fastq_screen/{sample}_read1.fastq_screen.txt",
    star = "../rna/star/{sample}.Aligned.sortedByCoord.out.bam",
    featureCounts = "../rna/counts/fc_stats.summary" 
  output: "../multiqc/{sample}_multiqc.html"
