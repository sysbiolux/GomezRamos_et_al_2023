rule fastqc:
  input: 
    atac = "data/atac/fastq/{sample}.fastq.gz",
  output:
    atac = "data/atac/fastqc/{sample}_fastqc.html",
  conda: "../envs_local/fastq.yaml"
  shell:
    """
    fastqc {input.atac}

    cp data/atac/fastq/{wildcards.sample}_fastqc.html {output.atac}
    """

rule fastqc_rna:
  input:
    rna = "data/rna/fastq/{sample}.fastq.gz"
  output:
    rna = "data/rna/fastqc/{sample}_fastqc.html"
  conda: "../envs_local/fastq.yaml"
  shell:
    """
    fastqc {input.rna}

    cp data/rna/fastq/{wildcards.sample}_fastqc.html {output.rna}
    """

rule multiqc:
  input:
    qc_atac = expand(["data/atac/fastqc/{sample}_{rep}_{read}_fastqc.html"], sample = DATASETS, rep = REPLICATES, read = ["read1", "read2"]),
    qc_rna = expand(["data/rna/fastqc/{sample}_{rep}_fastqc.html"], sample = DATASETS, rep = REPLICATES), 
  output:
    multiqc = "data/multiqc/multiqc_report.html"
  conda: "../envs_local/multiqc.yaml"
  shell:
    """
    multiqc -d -dd 2 data/ -o data/multiqc/ 
    """
