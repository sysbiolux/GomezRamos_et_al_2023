library("Rsubread")

bams <- snakemake@input[["bams"]]
annot <- snakemake@params[["annotation"]]

fc_q30 <- featureCounts(files = bams, annot.ext = annot, 
                    nthreads = snakemake@threads, 
                    minMQS = 30,
                    isGTFAnnotationFile = TRUE,
		    GTF.featureType = "exon", 
                    GTF.attrType.extra = "gene_name",
                    GTF.attrType = "gene_id",
                    isPairedEnd = FALSE,
  		    strandSpecific = 0) 
write.table(fc_q30$stat, file = snakemake@output[["stat"]], row.names = FALSE, quote = FALSE, sep = "\t")
saveRDS(fc_q30, file = snakemake@output[["fc_q30"]])
