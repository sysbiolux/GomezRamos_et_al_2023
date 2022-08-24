rule peak_calling:
  input: 
    bam = expand(["data/atac/bam/{sample}_{rep}.bam"], rep=REPLICATES, allow_missing=True),
    blacklist = "references/{}.blacklist.bed.gz".format(config["genome"])
  output: 
    peaks = "data/atac/peaks/{sample}.narrowPeak",
    bedgraph = "data/atac/peaks/{sample}.bg"
  params:
    name = "{sample}",
    folder = "data/atac/peaks",
    exclude = "chrM",
    replicate = ",".join(expand("data/atac/bam/{sample}_{rep}.bam",rep = REPLICATES, allow_missing=True))
  conda: "../envs_local/genrich.yaml"
  shell:
    """
    Genrich -t {params.replicate} -o {output.peaks} \
    -k {output.bedgraph} -e {params.exclude} \
    -E {input.blacklist} -r \
    -f {params.folder}/{params.name}.log -m 30 -j -a 500 -g 15 -l 15 -d 50
    """
