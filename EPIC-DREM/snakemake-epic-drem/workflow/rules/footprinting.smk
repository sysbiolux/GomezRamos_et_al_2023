rule footprinting:
  input:
    bam = "data/atac/bam_merged/{sample}.sorted.bam",
    peak = "data/atac/peaks/{sample}.narrowPeak",
    genome = "rgtdata/{}/genome_{}.fa".format(config["genome"],config["genome"]),
    annotation = "rgtdata/{}/genes_Gencode_{}.bed".format(config["genome"],config["genome"]),
    chromsizes = "rgtdata/{}/chrom.sizes.{}".format(config["genome"],config["genome"]),
    refseq = "rgtdata/{}/genes_RefSeq_{}.bed".format(config["genome"],config["genome"]),
    alias = "rgtdata/{}/alias_{}.txt".format(config["genome"],config["alias"]),
    gtf = "rgtdata/{}/annotation.gtf".format(config["genome"]),
    index = "data/atac/bam_merged/{sample}.sorted.bam.bai"
  output: 
    peaks = "data/atac/footprints/{sample}.bed",
    info = "data/atac/footprints/{sample}.info"
  params:
    prefix = "{sample}",
    loc= "data/atac/footprints/",
    organism="{}".format(config["genome"])
  conda: "../envs_local/rgt_updated.yaml"
  shell:
    """
    export RGTDATA=`pwd`/rgtdata

    rgt-hint footprinting --atac-seq --paired-end \
    --organism={params.organism} --output-location={params.loc} --output-prefix={params.prefix} \
    {input.bam} {input.peak}
    """
    
rule rmtab:
  input: "data/atac/footprints/{sample}.bed"
  output: "data/atac/footprints/{sample}.rmtab.bed"
  shell:
    """
    sed 's/[[:space:]]*$//' {input} > {output}
    """
