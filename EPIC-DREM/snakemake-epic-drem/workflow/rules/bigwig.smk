rule bigwig:
  input: "../atac/peaks/{sample}.bg"
  output: "../atac/viz/{sample}.bw"
