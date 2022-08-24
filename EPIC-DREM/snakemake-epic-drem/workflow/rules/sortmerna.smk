rule sortmerna:
  input:
    read1 = "rna/fastq/{sample}_r1.fastq.gz",
    read2 = "rna/fastq/{sample}_r2.fastq.gz",
    rfam58s = "references/sortmerna/rfam-5.8s-database-id98.fasta",
    rfam5s = "references/sortmerna/rfam-5s-database-id98.fasta",
    silva18s = "references/sortmerna/silva-euk-18s-id95.fasta",
    silva28s = "references/sortmerna/silva-euk-28s-id98.fasta"
  output:
    ribosomal_read1 = "rna/fastq/ribosomal/{sample}.wrRNA_fwd.fastq.gz",
    ribosomal_read2 = "rna/fastq/ribosomal/{sample}.wrRNA_rev.fastq.gz",
    worRNA_read1 = "rna/fastq/worRNA/{sample}.worRNA_fwd.fastq.gz",
    worRNA_read2 = "rna/fastq/worRNA/{sample}.worRNA_rev.fastq.gz"
  params:
    prefribo = "rna/fastq/ribosomal/{sample}.wrRNA",
    prefworRNA = "rna/fastq/worRNA/{sample}.worRNA"
  conda: "envs_local/rna_preprocessing.yaml"
  shell:
    """
    sortmerna -ref {input.rfam58s} -ref {input.rfam5s} \
    -ref {input.silva18s} -ref {input.silva28s} --workdir ./rna/sortmerna_{wildcards.sample} \
    -reads {input.read1} -reads {input.read2} --fastx -paired_in --aligned {params.prefribo} \
    --other {params.prefworRNA} --out2 True -threads 2
    
    gzip {params.prefribo}_fwd.fastq
    gzip {params.prefribo}_rev.fastq
    gzip {params.prefworRNA}_fwd.fastq
    gzip {params.prefworRNA}_rev.fastq
    """
