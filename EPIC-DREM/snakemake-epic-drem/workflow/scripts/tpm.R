library(tidyverse)


fc_q30 <- readRDS(snakemake@input[["fc_q30"]])
names_col <- unlist(snakemake@params[["names"]])
names_samples <- unique(str_remove(names_col, paste0("_",snakemake@params[["rep"]],"[12345]")))
count_matrix <- fc_q30$counts %>% 
  as_tibble(rownames = "GeneID")
colnames(count_matrix) <- c("GeneID", names_col)

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
      tpm %>% select(sample)
    }else{
      name <- enquo(sample)
      tpm %>% 
        mutate(!!name := rowMeans(select(., starts_with(sample)), na.rm = TRUE)) %>% 
        select(!!name)
    }

  }) 
}






tpm <- getTpm(count_matrix)


tpm_mean <- mean_tpm(list(names_samples), tpm) 
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
  dplyr::select("GeneID", names_samples)



write_tsv(drem_input_filt, snakemake@output[["filtered"]])
write_tsv(tpm_mean, snakemake@output[["tpm"]])


