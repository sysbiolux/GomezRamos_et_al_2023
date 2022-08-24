rule tepic:
  input: 
    bed = "data/atac/footprints/{sample}.rmtab.bed",
    tepic = "TEPIC-master/Code/TEPIC.sh",
    twobit = "references/{}.2bit".format(config["species"]),
    trap = "TEPIC-master/Code/TRAPmulti",
    annotation = "references/{}.annotation.gtf".format(config["species"]),
    genome = "references/{}.fa".format(config["species"]),
    psem = "TEPIC-master/PWMs/2.1/JASPAR_PSEMs/{}".format(config["psems"])
  output: "data/atac/affinities/{sample}.txt"
  params:
    foutput = "data/atac/affinities",
    name = "{sample}"
  threads: 12
  conda: "../envs_local/tepic_clean.yaml"
  shell:
    """
    pwd
    which python
    {input.tepic} -v 0.01 -l -g {input.genome} -j -b {input.bed} \
    -o {params.foutput}/{params.name} -p {input.psem} -r {input.twobit} -a {input.annotation} -f {input.annotation} -w 50000 -c {threads}
    ls {params.foutput}/{params.name}*Thresholded_Decay_Sparse_Affinity_Gene_View.txt > {output}
    """
