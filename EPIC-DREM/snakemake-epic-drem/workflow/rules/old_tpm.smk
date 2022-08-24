rule old_tpm:
  input:
    fc_q30 = "data/rna/counts/fc_hs_q30RNA_epifunc.rds"
  output:
    tpm = "data/rna/counts/tpm.tsv",
    filtered = "data/drem-input/filtered_tpm.tsv"
  params:
    names = expand("{sample}_{rep}", sample=DATASETS, rep=REPLICATES),
    rep = "rep"
  conda: "../envs_local/tidyverse.yaml"
  script:
    "../scripts/old_tpm.R"
