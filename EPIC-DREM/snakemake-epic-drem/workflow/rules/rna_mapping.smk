#def get_fastq_reads(wcs):
#    if wcs.endedness == 'PE':  # Paired-end
#        return ["data/rna/fastq/{sample}_read1.fastq.gz", "data/rna/fastq/{sample}_read2.fastq.gz"]
#
#    if wcs.endedness == 'SE':  # Single-end
#        return ["data/rna/fastq/{sample}.fastq.gz"]
#
#    raise(ValueError("Unrecognized wildcard value for 'endedness': %s" % wcs.endedness))



rule rna_mapping:
  input:
    reads = get_fastq_reads,
    ref = "references/star_index/star_index.txt"
  output: 
    aligned = "data/rna/star/{sample}.Aligned.sortedByCoord.out.bam"
  params:
    index = "references/star_index/",
    outSAMType = "BAM SortedByCoordinate",
    prefix = "data/rna/star/{sample}."
  conda: "../envs_local/star.yaml"
  threads: 12
  shell:
    """
    STAR  \
    --runThreadN {threads} \
    --genomeDir {params.index} \
    --readFilesIn {input.reads} \
    --readFilesCommand zcat \
    --outFileNamePrefix {params.prefix} \
    --outSAMunmapped Within \
    --outSAMtype {params.outSAMType} \
    --twopassMode Basic --limitOutSJcollapsed 1000000 --limitSjdbInsertNsj 1000000 \
    --outFilterMultimapNmax 100 --outFilterMismatchNmax 33 --outFilterMismatchNoverLmax 0.3 \
    --seedSearchStartLmax 14 --alignSJoverhangMin 15 --alignEndsType Local \
    --outFilterMatchNminOverLread 0 --outFilterScoreMinOverLread 0.3 --winAnchorMultimapNmax 50  \
    --alignSJDBoverhangMin 3 --quantMode GeneCounts --outSAMstrandField intronMotif \
    --outFilterType BySJout
    """
