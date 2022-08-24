library(tidyverse)

peaks <-  read_tsv(snakemake@input[["file"]], 
                   col_names = c("chrom", "chromStart",
                                 "chromEnd", "name",
                                 "score", "strand",
                                 "signalValue", "pValue",
                                 "qValue", "peak"))

peaks_new <- peaks %>% mutate(chrom = str_remove(chrom, "chr"))

write_tsv(peaks_new, snakemake@output[["peaks"]], col_names = FALSE)
