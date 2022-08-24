rule index_rna:
  input: "data/rna/star/{sample}.Aligned.sortedByCoord.out.bam"
  output: "data/rna/star/{sample}.Aligned.sortedByCoord.out.bam.bai"
  conda: "../envs_local/alignment.yaml"
  threads: 8
  shell:
    """
    samtools index -b {input} -@{threads}
    """


rule bam_summary:
  input: 
    bam = expand(["data/rna/star/{sample}_{rep}.Aligned.sortedByCoord.out.bam"], rep=REPLICATES, sample = DATASETS),
    index = expand(["data/rna/star/{sample}_{rep}.Aligned.sortedByCoord.out.bam.bai"], rep=REPLICATES, sample = DATASETS)
  output: "data/rna/qc/bam_summary.npz"
  conda: "../envs_local/bedops.yaml"
  threads: 8
  shell: 
    """
    multiBamSummary bins --bamfiles {input.bam} -o {output} --smartLabels -p {threads}
    """

rule correlations:
  input: "data/rna/qc/bam_summary.npz"
  output: "data/rna/qc/heatmap_correlation.png"
  conda: "../envs_local/bedops.yaml"
  shell:
    """
    plotCorrelation -in {input} --corMethod "spearman" --skipZeros \
        --whatToPlot heatmap --plotNumbers -o {output}
    """

rule pca:
  input: "data/rna/qc/bam_summary.npz"
  output: "data/rna/qc/pca.png"
  conda: "../envs_local/bedops.yaml"
  shell:
    """
    plotPCA -in {input} -o {output} --transpose
    """

rule bam_summary_atac:
  input:
    bam = expand(["data/atac/bam/{sample}_{rep}.sorted.bam"], sample = DATASETS, rep=REPLICATES),
    index = expand(["data/atac/bam/{sample}_{rep}.sorted.bam.bai"], sample = DATASETS, rep=REPLICATES)
  output: "data/atac/qc/bam_summary.npz"
  conda: "../envs_local/bedops.yaml"
  threads: 8
  shell:
    """
    multiBamSummary bins --bamfiles {input.bam} -o {output} --smartLabels -p {threads}
    """

rule correlations_atac:
  input: "data/atac/qc/bam_summary.npz"
  output: "data/atac/qc/heatmap_correlation.png"
  conda: "../envs_local/bedops.yaml"
  shell:
    """
    plotCorrelation -in {input} --corMethod "spearman" --skipZeros \
        --whatToPlot heatmap --plotNumbers -o {output}
    """

rule pca_atac:
  input: "data/atac/qc/bam_summary.npz"
  output: "data/atac/qc/pca.png"
  conda: "../envs_local/bedops.yaml"
  shell:
    """
    plotPCA -in {input} -o {output} --transpose
    """
