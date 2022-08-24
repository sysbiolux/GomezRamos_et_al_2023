rule atac_mapping:
  input:
    read1 = "data/atac/fastq/{sample}_read1.fastq.gz",
    read2 = "data/atac/fastq/{sample}_read2.fastq.gz",
    ref = "references/{}.fa".format(config["species"]),
    index = "references/{}.fa.pac".format(config["species"])
  output: 
    namesort = "data/atac/bam/{sample}.bam",
    positionsort = "data/atac/bam/{sample}.sorted.bam"
  threads: 12
  conda: "../envs_local/alignment.yaml"
  shell:
    """
    bwa mem -c {threads} {input.ref} {input.read1} {input.read2} | samtools sort -n -@12 -O BAM -o {output.namesort} -
     
    samtools sort {output.namesort} > {output.positionsort}
    samtools index -b {output.positionsort}

    """
