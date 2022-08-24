rule get_rgtdata:
  input:
    genome = "references/{}.fa".format(config["species"]),
    chromsizes = "references/{}.chrom.sizes".format(config["species"]),
    gtf = "references/{}.annotation.gtf".format(config["species"])
  output:
    rgtdata = directory("rgtdata"),
    annotation = "rgtdata/{}/genes_Gencode_{}.bed".format(config["genome"],config["genome"]),
    refseq = "rgtdata/{}/genes_RefSeq_{}.bed".format(config["genome"],config["genome"]),
    alias = "rgtdata/{}/alias_{}.txt".format(config["genome"],config["alias"]),
    config = "rgtdata/data.config",
    chromsizes = "rgtdata/{}/chrom.sizes.{}".format(config["genome"],config["genome"]),
    genome = "rgtdata/{}/genome_{}.fa".format(config["genome"],config["genome"]),
    gtf = "rgtdata/{}/annotation.gtf".format(config["genome"])
  threads: 1
  shell:
    """
    wget https://github.com/CostaLab/reg-gen/archive/master.zip
    unzip master.zip
    cp -r reg-gen-master/data/* {output.rgtdata}/
    rm master.zip
    rm -r reg-gen-master
    cp config/data.config {output.config}
    cp config/data.config.user rgtdata/data.config.user
    cp {input.genome} {output.genome}
    cp {input.chromsizes} {output.chromsizes}
    cp {input.gtf} {output.gtf}
    """
