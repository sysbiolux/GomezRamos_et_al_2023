rule bigwig:
  input: "data/atac/bam_merged/{sample}.sorted.bam"
  output: "data/atac/coverage/{sample}.bw"
  log: "log/atac/bigwig_{sample}.log"
  conda: "../envs_local/bedops.yaml"
  shell:
    """
    bamCoverage --bam {input} -o {output}
    """


rule peak_counts:
  input:
    files = expand("data/atac/footprints/{sample}.info", sample = DATASETS)
  output:
    counts = "data/atac/stats/peaks.tsv",
    img = "data/atac/visualize/peaks.png"
  params:
    names = expand("{sample}", sample = DATASETS)
  conda: "../envs_local/tidyverse.yaml"  
  script: 
    "../scripts/count_peaks_footprints.R"  

  
rule atac_matrix:
  input:
    bed = "references/{}.genes.bed".format(config["species"]),
    bigwig = "data/atac/coverage/{sample}.bw"
  output: "data/atac/visualize/{sample}.matrix.gz"
  conda: "../envs_local/bedops.yaml"
  shell:
    """
    computeMatrix reference-point -S {input.bigwig} -R {input.bed} \
      -a 1000 -b 1000 -out {output} 
    """

rule tss_heatmap:
  input: "data/atac/visualize/{sample}.matrix.gz"
  output: "data/atac/visualize/heatmap_{sample}.png"
  conda: "../envs_local/bedops.yaml"
  shell:
    """
    plotHeatmap -m {input} -out {output}
    """  
