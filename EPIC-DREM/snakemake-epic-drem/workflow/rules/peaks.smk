rule peaks:
  input:
    file = "data/atac/peaks/{sample}.narrowPeak"
  output:
    peaks = "data/atac/peaks/{sample}_adj.narrowPeak"
  conda: "../envs_local/tidyverse.yaml"
  script: 
    "../scripts/peaks.R"
