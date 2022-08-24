rule get_tpm:
  input:
    fc_q30 = "data/rna/counts/fc_q30.rds"
  output:
    tpm = "data/rna/counts/tpm.tsv",
    filtered = "data/drem-input/deg_tpm.tsv"
  params:
    names = expand("{sample}_{rep}", sample=DATASETS, rep=REPLICATES),
    rep = "Rep"
  conda: "../envs_local/tidyverse.yaml"
  script:
    "../scripts/test_tpm_deg.R"
