###
# This script will load the thresholded affinities from TEPIC 
# and convert them to the input affinity table needed fo DREM
###


library(tidyverse)
library(annotables)
library(qdapTools)

files <-  snakemake@input[["files"]]
names(files) <- unlist(snakemake@params[["names"]])
tpm <- read_tsv(snakemake@input[["tpm"]])
organism <- snakemake@params[["genome"]]

if(organism == "hg38"){
  genome <- grch38
  }else if(organism == "hg37"){
  genome <- grch37
  }else if(organism == "mm10"){
  genome <- grcm38
}


tp <- colnames(tpm)[2:length(colnames(tpm))]

expressed <- tpm %>% 
  gather(sample, tpm, -GeneID) %>%
  group_by(GeneID) %>%
  arrange(GeneID) %>%
  mutate(tpm_cutoff = case_when(tpm > 1 ~ 1,
                                TRUE ~ 0),
         sum_tpm = sum(tpm_cutoff)) %>%
  filter(sum_tpm >= 1) %>%
  dplyr::select(-tpm_cutoff, -sum_tpm) %>%
  spread(sample, tpm) %>%
  select(GeneID) %>% 
  inner_join(genome %>% dplyr::select(ensgene, symbol), by = c("GeneID"="ensgene"))

affinities <- map(files, function(x){read_tsv(read_lines(x))})

affinities <- map2(affinities, names(affinities), function(x,y){
  affinities_filtered <- x %>% 
    dplyr::rename("Input" = Affinity,
                  "Gene"= geneID) %>% 
    mutate(TF_vars = TF) %>%
    mutate(TF_vars = case_when(str_detect(TF_vars, "var") ~ str_sub(TF_vars,1L, -8L),
                               TRUE ~ TF_vars),
           TF_dimers = TF_vars) %>% 
    separate(TF_vars, into = c("dimer1", "dimer2"), sep = "::") %>% 
    mutate(expressed = case_when((dimer1 %in% expressed$symbol | dimer2 %in% expressed$symbol) ~ 1,
                                 TRUE ~ 0)) %>% 
    filter(expressed == 1) %>% 
    dplyr::select(TF, Gene, Input)  
  
}) %>% list_df2df() %>% 
  dplyr::rename("Timepoint" = X1) %>% 
  dplyr::select(TF, Gene, Input, Timepoint)

write_tsv(affinities, snakemake@output[["affinities"]])

