rule merge_bam:
  input: expand("data/atac/bam/{sample}_{rep}.bam", rep=REPLICATES, allow_missing=True)
  output: 
    bam = "data/atac/bam_merged/{sample}.bam",
    sorted = "data/atac/bam_merged/{sample}.sorted.bam",
    index = "data/atac/bam_merged/{sample}.sorted.bam.bai"
  conda: "../envs_local/alignment.yaml"
  shell:
    """
    samtools merge {output.bam} {input}
    samtools sort {output.bam} > {output.sorted}
    samtools index -b {output.sorted}
    """
