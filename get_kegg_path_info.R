# how to get KEGG pathway info
library(tidyverse)
library(KEGGREST)
pth_id <- KEGGREST::keggList("pathway", "hsa")

kegg_info_lst = list()
for(idx in 241:length(pth_id)) {
  lst1 = KEGGREST::keggGet(names(pth_id)[idx])[[1]]
  if("GENE" %in% names(lst1)) {
    str1 <- lst1$GENE %>% grep("^[A-Z]+", ., value = T) %>% 
      str_split("; ", simplify = T) %>% as.data.frame() %>% 
      dplyr::rename("gene_name" = "V1", "description" = "V2")
    str2 <- lst1$GENE %>% grep("^[0-9]+", ., value = T)
    kegg_info_lst[[names(pth_id)[idx]]] <- 
      data.frame(path_id = names(pth_id)[idx], path_name = pth_id[idx]) %>% 
      data.frame(., str1)
  }
}
kegg_pth_info = kegg_info_lst %>% bind_rows() %>% 
  mutate(path_name = case_when(grepl("Homo sapiens", path_name) ~ str_sub(path_name, end = -24), 
                               TRUE ~ path_name))
write_csv(kegg_pth_info, "kegg_hsa_all_pth_genes.csv") # 20250310

