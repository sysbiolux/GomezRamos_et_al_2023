library(tidyverse)
library(DESeq2)


fc_q30 <- readRDS(snakemake@input[["fc_q30"]])
names_col <- unlist(snakemake@params[["names"]])
names_samples <- unique(str_remove(names_col, paste0("_",snakemake@params[["rep"]],"[12345]")))
timepoints <- str_remove(names_col, paste0("_",snakemake@params[["rep"]],"[12345]"))
count_matrix <- fc_q30$counts 
colnames(count_matrix) <- c(names_col)

coldata <- cbind(names_col, timepoints)
colnames(coldata) <- c("Sample", "Timepoint")

dds <- DESeqDataSetFromMatrix(countData = count_matrix,
                              colData = coldata,
                              design = ~ Timepoint)

dds <- estimateSizeFactors(dds)

count_matrix_norm <- counts(dds, normalized=TRUE) %>% 
  as_tibble(rownames = "GeneID")

# # construct gene length table (only do once)



# 
gene_length <- fc_q30$annotation %>%
  dplyr::select(GeneID, Length) 


getTpm <- function(filtered){ # x: usually the "filtered"
  
  gene_length <- gene_length %>% 
    mutate(length_kb = Length/1000)
  all_info <- left_join(filtered, gene_length, by = c("GeneID")) 
  
  rpk <- filtered %>% select(-GeneID)%>% 
    sweep(., 1, all_info$length_kb, "/")
  rownames(rpk) <- filtered$GeneID
  
  # scaling factor
  scale_factor <- apply(rpk, 
                        2, function(x) sum(x))/1000000
  
  # normalize to library size
  tpm <- rpk %>% 
    sweep(., 2, scale_factor, "/") %>% 
    rownames_to_column(var = "GeneID") 
  
  return(tpm)
}

####

mean_tpm <- function(sample, tpm){
  sample <- c("GeneID", names_samples)
  map_dfc(sample, function(sample){
    if(sample == "GeneID"){
      tpm %>% select(all_of(sample))
    }else{
      name <- enquo(sample)
      tpm %>% 
        mutate(!!name := rowMeans(select(., starts_with(sample)), na.rm = TRUE)) %>% 
        select(!!name)
    }
    
  }) 
}






tpm <- getTpm(count_matrix_norm)


tpm_mean <- mean_tpm(list(names_samples), tpm) %>%
  mutate(GeneID = str_sub(GeneID, 1L, 15L)) 
###

#change filtering step. add options in config

drem_input_filt <- 
  tpm_mean %>% 
  gather(sample, tpm, -GeneID) %>% 
  group_by(GeneID) %>% 
  # arrange(GeneID) %>% 
  mutate(min = min(tpm)) %>% 
  filter(min > 0) %>% 
  spread(sample, tpm) %>% 
  dplyr::select(-min) %>% 
  dplyr::select("GeneID", all_of(names_samples))



write_tsv(drem_input_filt, snakemake@output[["filtered"]])
write_tsv(tpm_mean, snakemake@output[["tpm"]])


