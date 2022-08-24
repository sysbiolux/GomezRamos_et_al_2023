rule idrem:
  input:
    tpm = "data/drem-input/filtered_tpm.tsv",
    affinities = "data/drem-input/affinities.tsv",
    script = "workflow/drem/drem-execution-info_4split_dev02.txt",
    drem = "idrem-master/idrem.jar"
  output: "data/idrem/drem-model_4splits_dev02.txt"
  params: 
    script = "../workflow/drem/drem-execution-info_4split_dev02.txt",
    drem = "idrem.jar",
    output = "../data/idrem/drem-model_4splits_dev02.txt"
  conda: "../envs_local/drem.yaml"
  shell:
    """
    cd idrem-master
    java -mx20G -jar {params.drem} -b {params.script} {params.output} 
    """
