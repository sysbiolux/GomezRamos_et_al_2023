library(tidyverse)
library(qdapTools)

files <-  snakemake@input[["files"]]
names <- unlist(snakemake@params[["names"]])
path_info <- map(files, function(x){
  read_csv(x, col_names = x) %>% 
    separate(x, into = c("info", "count"), sep = ":") %>% 
    mutate(count = as.double(count)) %>% 
    spread(info, count)})

names(path_info) <- files %>% str_sub(22L, -6L) 

counts_samples <- list_df2df(path_info) %>% rename(Sample = X1) %>% 
  select(Sample, `Number of peaks`, `Number of footprints`)  %>% 
  gather(Information, count, -Sample) %>% 
  as_tibble %>% 
  mutate(Information = factor(Information, levels = c("Number of peaks", "Number of footprints")),
         Sample = fct_relevel(Sample, names)) 

counts_samples %>% ggplot(aes(x=Sample, y = count, stat = "Identity", fill = Information)) + 
  geom_bar(stat = "Identity", position = "dodge") + scale_fill_hue(l=60, c=30) +
  coord_flip() -> counts_peaks_fp

write_tsv(counts_samples, snakemake@output[["counts"]])
ggsave(snakemake@output[["img"]], counts_peaks_fp, dpi = 300, width = 5, height = 6)
