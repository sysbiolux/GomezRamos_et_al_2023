rule affinity_prep:
  input:
    files = expand("data/atac/affinities/{sample}.txt", sample=DATASETS),
    tpm = "data/drem-input/filtered_tpm.tsv"
  params:
    names = expand("{sample}", sample=DATASETS),
    genome = "{}".format(config["genome"])
  output:
    affinities = "data/drem-input/affinities.tsv"
  conda: "../envs_local/tidyverse.yaml"
  script:
    "../scripts/affinities_drem-input.R"
