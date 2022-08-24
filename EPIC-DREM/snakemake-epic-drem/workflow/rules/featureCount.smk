rule featureCount:
  input:
    bams = expand("data/rna/star/{sample}_{rep}.Aligned.sortedByCoord.out.bam", sample=DATASETS, rep=REPLICATES),
    annotation = "references/{}.annotation.gtf".format(config["species"])
  output:
    fc_q30 = "data/rna/counts/fc_q30.rds",
    stat = "data/rna/counts/fc_stats.summary"
  params:
    annotation = "references/{}.annotation.gtf".format(config["species"])
  threads: 8
  conda: "../envs_local/renv.yaml"
  script:
    "../scripts/featureCounts.R"
