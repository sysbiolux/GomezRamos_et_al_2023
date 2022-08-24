rule adapter_removal:
  input: 
    read1 = "data/rna/fastq/worRNA/{sample}.worRNA_fwd.fastq.gz",
    read2 = "data/rna/fastq/worRNA/{sample}.worRNA_rev.fastq.gz",
  output:
    read1 = "data/rna/fastq/trimmed/{sample}.worRNA_fwd.trim.fastq.gz",
    read2 = "data/rna/fastq/trimmed/{sample}.worRNA_rev.trim.fastq.gz"
  params:
    adapter1 = "AGATCGGAAGAGCACACGTCTGAACTCCAGTCA",
    adapter2 = "AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT"
  conda: "../envs_local/rna_preprocessing.yaml"
  shell:
    """
    AdapterRemoval --file1 {input.read1} --file2 {input.read2} --output1 {output.read1} --output2 {output.read2} \
    --adapter1 {params.adapter1} --adapter2 {params.adapter2} --gzip --trimqualities --trimns
    """
