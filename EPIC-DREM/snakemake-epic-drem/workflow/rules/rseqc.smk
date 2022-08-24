rule rseqc:
  input: 
    file = "../rna/star/d0_rep1.Aligned.sortedByCoord.out.bam",
    ref = "references/mm10_RefSeq.bed"
  output: "../rna/qc/d0_rep1_strand_info.txt"
  conda: "../envs_local/fastq.yaml"
  shell:
    """
    infer_experiment.py -r {input.ref} -i {input.file} > {output}
    """
