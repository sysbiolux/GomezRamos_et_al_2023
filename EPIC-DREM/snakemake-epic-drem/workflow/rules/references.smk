rule get_genome:
  output: 
    genome = "references/{}.fa".format(config["species"])
  params:
    species = "{}".format(config["species"]),
    datatype = "dna",
    build= "{}".format(config["build"]),
    release = "{}".format(config["release"])
  log: "logs/get_genome.log"
  wrapper:
    "master/bio/reference/ensembl-sequence"

rule get_annotation:
  output: "references/{}.annotation.gtf".format(config["species"])
  params: 
    species = "{}".format(config["species"]),
    fmt="gtf",
    build= "{}".format(config["build"]),
    release = "{}".format(config["release"])
  log: "logs/get_annotation.log"
  wrapper:
    "master/bio/reference/ensembl-annotation"


rule get_2bit:
  input: "references/{}.fa".format(config["species"])
  output: "references/{}.2bit".format(config["species"])
  conda: "../envs_local/ucsc.yaml"
  shell:
    """
    faToTwoBit {input} {output}
    """

rule get_chrSizes:
  input: "references/{}.2bit".format(config["species"])
  output: "references/{}.chrom.sizes".format(config["species"])
  conda: "../envs_local/ucsc.yaml"
  shell:
    """
    twoBitInfo {input} stdout | sort -k2rn > {output}
    """

rule get_blacklist:
  output: "references/{}.blacklist.bed.gz".format(config["genome"])
  shell:
    """
    wget -O {output} http://mitra.stanford.edu/kundaje/akundaje/release/blacklists/{config[genome]}-{config[alias]}/{config[genome]}.blacklist.bed.gz
    """

rule rna_index:
  input:
    genome = "references/{}.fa".format(config["species"]),
    gtf = "references/{}.annotation.gtf".format(config["species"])
  output: "references/star_index/star_index.txt"
  params:
    genomeDir = "references/star_index"
  threads: 12
  conda: "../envs_local/star.yaml"
  shell:
    """
    STAR --runThreadN {threads} --genomeSAindexNbases 12\
    --runMode genomeGenerate \
    --genomeDir {params.genomeDir} \
    --genomeFastaFiles {input.genome} \
    --sjdbGTFfile {input.gtf} \
    --sjdbOverhang 99

    ls {params.genomeDir} > {output}
    """

rule bwa_index:
  input: "references/{}.fa".format(config["species"])
  output: "references/{}.fa.pac".format(config["species"])
  conda: "../envs_local/alignment.yaml"
  shell:
    """
    bwa index -a bwtsw {input}
    """

rule genes:
  input: "references/{}.annotation.gtf".format(config["species"])
  output:  "references/{}.genes.bed".format(config["species"])
  conda: "../envs_local/tepic_clean.yaml"
  shell:
    """
    grep 'transcript_biotype "protein_coding"' {input}  | \
    awk '($3=="exon") {{printf("%s\t%s\t%s\\n",$1,int($4)-1,$5);}}' |\
    sort -T . -k1,1 -k2,2n | bedtools merge > {output}
    """
