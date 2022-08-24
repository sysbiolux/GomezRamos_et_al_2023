rule drem:
  input:
    tpm = "data/drem-input/filtered_tpm.tsv",
    affinities = "data/drem-input/affinities.tsv",
    script = "workflow/drem/drem-execution-info.txt",
    drem = "drem2/drem.jar"
  output: "data/drem/drem-model.txt"
  conda: "../envs_local/drem.yaml"
  shell:
    """
    java -mx16G -jar {input.drem} -b {input.script} {output} 
    """
