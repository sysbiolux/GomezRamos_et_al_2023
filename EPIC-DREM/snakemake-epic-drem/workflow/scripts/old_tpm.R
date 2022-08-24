library(tidyverse)
library(DESeq2)

fc_hs_q30RNA <- readRDS(snakemake@input[["fc_q30"]])
count_matrix <- fc_hs_q30RNA$counts %>% 
  as_tibble(rownames = "GeneID") %>% 
  mutate(GeneID = str_sub(GeneID,1,15))

# # construct gene length table (only do once)
# 
gene_length <- fc_hs_q30RNA$annotation %>%
  dplyr::select(GeneID, Length) %>% 
  mutate(GeneID = str_sub(GeneID,1,15))


filtered <- count_matrix

getTpm <- function(filtered){ # x: usually the "filtered"
  
  # load("~/iris/workflow/rnaseq_function/gene_length.RData")
  
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

tpm <- getTpm(filtered) 
tpm %>% mutate(astro = (ASTRO_D65_I_20190426_reads.Aligned.sortedByCoord.out.q30.bam +
                          ASTRO_D65_II_20190507_reads.Aligned.sortedByCoord.out.q30.bam +
                          ASTRO_D65_III_20190510_reads.Aligned.sortedByCoord.out.q30.bam)/3,
               D15neg = (D15_negsort_20190312_reads.Aligned.sortedByCoord.out.q30.bam +
                           D15_negsort_20190320_reads.Aligned.sortedByCoord.out.q30.bam +
                           D15_negsort_20190403_reads.Aligned.sortedByCoord.out.q30.bam)/3,
               D15 = (D15_possort_20190213_reads.Aligned.sortedByCoord.out.q30.bam +
                           D15_possort_20190228_reads.Aligned.sortedByCoord.out.q30.bam +
                           D15_possort_20190312_reads.Aligned.sortedByCoord.out.q30.bam)/3,
               D30 = (D30_possort_20190228_reads.Aligned.sortedByCoord.out.q30.bam +
                           D30_possort_20190321_reads.Aligned.sortedByCoord.out.q30.bam +
                           D30_possort_20190328_reads.Aligned.sortedByCoord.out.q30.bam)/3,
               D50neg = D50_negsort_20190430_reads.Aligned.sortedByCoord.out.q30.bam,
               D50 = (D50_possort_20190430_reads.Aligned.sortedByCoord.out.q30.bam +
                           D50_possort_20190612_reads.Aligned.sortedByCoord.out.q30.bam +
                           D50_possort_20190717_reads.Aligned.sortedByCoord.out.q30.bam)/3,
               smNPC = (smNPC_20190312_reads.Aligned.sortedByCoord.out.q30.bam +
                          smNPC_20190319_reads.Aligned.sortedByCoord.out.q30.bam +
                          smNPC_20190322_reads.Aligned.sortedByCoord.out.q30.bam)/3) %>% 
  select(GeneID, smNPC, D15, D30, D50) -> drem_input


drem_input_pos_filt <- drem_input %>% 
  dplyr::select(GeneID, smNPC, D15, D30, D50) %>% 
  filter(!(smNPC == 0 & D15 == 0 & D30 == 0 & D50 == 0)) %>% 
  filter((smNPC >= 1 | D15 >=1 | D30 >=1 | D50 >= 1))

#drem_input_neg <- drem_input %>% 
#  dplyr::select(GeneID, smNPC, D15neg, D50neg) %>% 
#  filter(!(smNPC == 0 & D15neg == 0 & D50neg == 0))

write_tsv(drem_input_pos_filt, snakemake@output[["filtered"]])
write_tsv(drem_input, snakemake@output[["tpm"]])

#write_tsv(drem_input_pos_filt, "rna/tpm_drem_input_pos_filt.tsv")
#write_tsv(drem_input_neg, "rna/tpm_drem_input_neg_filt.tsv")

#drem_input_all <- drem_input %>% 
#  filter(!(smNPC == 0 & D15pos == 0 & D30pos == 0 & D50pos == 0 & D15neg == 0 & D50neg == 0 & astro == 0))

#write_tsv(drem_input_all, "rna/tpm_drem_input_all-samples.tsv")
