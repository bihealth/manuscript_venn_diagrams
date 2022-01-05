## monte carlo simulation: 100 replicates of the procedure shown in the
## paper

## output directory
outdir <- "montecarlo"
dir.create(path=outdir, showWarnings = FALSE)

## number of replicates
n_sim <- 100

## number of replicates per stratum (2 x n_stratum for one treatment/group)
## total sample size is 8 x n_stratum
n_stratum <- c(5, 10, 20)

## thresholds for the analysis
padj_thr <- 0.05
lfc_thr  <- 1.5

## lfc thresholds to test
lfc_thresholds <- c(0, 0.5, 1, 1.5, 2, 2.5, 3)

geo <- readRDS("GSE156063.geo")
covar <- as(phenoData(geo), "data.frame")

## remove columns with only one value
boring <- map_lgl(covar, ~ length(unique(.x)) == 1)
covar <- covar[ , !boring ] 

## clean up
covar <- covar %>% 
  dplyr::rename(gender = "gender:ch1") %>%
  mutate(disease = gsub(" .*", "", .data[["disease state:ch1"]])) %>%
  mutate(label = description) %>%
  mutate(group = disease) %>%
  arrange(description) %>%
  dplyr::select(all_of(c("title", "label", "gender", "disease", "group")))

counts <- read_csv("GSE156063_swab_gene_counts.csv.gz")
.tmp <- counts[[1]]
counts <- as.matrix(counts[,-1])
rownames(counts) <- .tmp
#counts <- counts[ , covar$description ]
counts <- counts[ , covar$label ]
lcpm   <- edgeR::cpm(counts, log=TRUE)
#stopifnot(all(colnames(counts) == covar$description))
stopifnot(all(colnames(counts) == covar$label))

annot <- data.frame(ENSEMBL = rownames(counts))

.tmp <- mapIds(org.Hs.eg.db, annot$ENSEMBL, column=c("ENTREZID"), keytype="ENSEMBL")
annot$ENTREZID <- .tmp[ match(annot$ENSEMBL, names(.tmp)) ]

.tmp <- mapIds(org.Hs.eg.db, annot$ENSEMBL, column=c("SYMBOL"), keytype="ENSEMBL")
annot$SYMBOL <- .tmp[ match(annot$ENSEMBL, names(.tmp)) ]

.tmp <- mapIds(org.Hs.eg.db, annot$ENSEMBL, column=c("GENENAME"), keytype="ENSEMBL")
annot$GENENAME <- .tmp[ match(annot$ENSEMBL, names(.tmp)) ]

sel <- covar$group %in% c("no", "SC2")
counts <- counts[ , sel ]
covar  <- covar[ sel, ]
covar$group <- as.character(covar$group)

one_replicate_ds2 <- function(covar, counts, n_stratum) {
  g1 <- covar %>% mutate(n=1:n()) %>%
    group_by(gender, disease) %>% slice_sample(n=n_stratum) %>% pull(n)
  g2 <- covar %>% mutate(n=1:n()) %>% filter(!n %in% g1) %>%
    group_by(gender, disease) %>% slice_sample(n=n_stratum) %>% pull(n)

  covar$group <- NA
  covar$group[g1] <- "G1"
  covar$group[g2] <- "G2"

  covar$group.disease <- paste0(covar$group, '_', covar$disease)

  sel <- c(g1, g2)

  ds2 <- DESeqDataSetFromMatrix(counts[,sel], colData=covar[sel, ],
    design=~ 0 + group.disease )

  DESeq(ds2)
}


## save the DS2 objects from each replication
for(nstrat in n_stratum) {
  # 2 x nstrat per group/treatment, 4 x nstrat per group
  message(sprintf("Group size %d", nstrat * 2))
  for(i in 1:n_sim) {

    message(i)
    ds2_file_name <- file.path(outdir, sprintf("ds2_%d_%d.rds", nstrat, i))

    if(!file.exists(ds2_file_name)) {
      ds2 <- one_replicate_ds2(covar, counts, nstrat)
      saveRDS(ds2, file=ds2_file_name)
    }

  }
}

ds2_files <- list.files(path = outdir, pattern = "ds2.*\\.rds", full.names = TRUE)

## get the results lists for the two contrasts (G1 and G2, respectively)
## for all the generated DS2 files
walk(ds2_files, ~ {
  ds2_file_name <- .x
  res_file_name <- gsub("ds2", "res", ds2_file_name)
  if(!file.exists(res_file_name)) {
    ds2 <- readRDS(ds2_file_name)
    res <- list()
    res$g1 <- results(ds2, contrast=c(-1, 1, 0, 0))
    res$g2 <- results(ds2, contrast=c(0, 0, -1, 1))
    res <- map(res, ~ .x %>% as.data.frame() %>%
     rownames_to_column("ENSEMBL") %>% 
     left_join(annot, by="ENSEMBL") %>%
     mutate(DEG=!is.na(padj) & abs(log2FoldChange) > lfc_thr & padj < padj_thr)) 
    saveRDS(res, file=res_file_name)
  }
  
})

files <- list.files(path = outdir, pattern = "^res.*\\.rds", full.names = TRUE)

all_res <- map(files, ~ { readRDS(.x) })
names(all_res) <- files

## create merged results making it easy to find the DEGs
merged_res <- map(all_res, ~ {
  res <- .x
  res.merged <- merge(res$g1, res$g2, by=c("ENSEMBL", "SYMBOL", "ENTREZID", "GENENAME"), suffixes=c(".g1", ".g2"))
})

merged_res <- map(n_stratum, ~ {
  merged_res[ grepl(sprintf("res_%d_", .x), names(merged_res)) ]
})
names(merged_res) <- n_stratum

saveRDS(merged_res, file=file.path(outdir, "merged_res.rds"))

one_replicate_gsea <- function(res.merged, mset, pval_thr, lfc_thr) {

  res.merged <- res.merged %>% 
      mutate(DEG.g1 = !is.na(padj.g1) & abs(log2FoldChange.g1) > lfc_thr & padj.g1 < padj_thr) %>%
      mutate(DEG.g2 = !is.na(padj.g2) & abs(log2FoldChange.g2) > lfc_thr & padj.g2 < padj_thr) 

  common <- res.merged %>% filter(DEG.g1 & DEG.g2) %>% pull(SYMBOL)
  fg <- list(g1 = res.merged %>% filter(DEG.g1) %>% pull(SYMBOL), 
             g2 = res.merged %>% filter(DEG.g2) %>% pull(SYMBOL))

  gsea_res <- map(fg, ~ tmodHGtest(fg=.x, bg=res.merged$SYMBOL, mset=mset))

  if(is.null(gsea_res[[1]]) || is.null(gsea_res[[2]])) {
    return(NULL)
  }

  gsea_res.merged <- merge(gsea_res$g1, gsea_res$g2, by=c("ID", "Title"), suffixes=c(".g1", ".g2"), all=T)
  gsea_res.merged
}


## gene set enrichment analysis.
## calculate the gene set enrichments for all selected LFC thresholds
for(lfc_thr in lfc_thresholds) {
  for(nstrat in as.character(n_stratum)) {
    file_name <- file.path(outdir, sprintf("gsea_res_%s_%s.rds", nstrat, lfc_thr))
    message(file_name)

    gsea_res <- imap(merged_res[[nstrat]], ~  {
                       message(.y)
      one_replicate_gsea(.x, mset=mset, pval_thr=padj_thr, lfc_thr=lfc_thr)})
    cat("\n")

    gsea_res <- gsea_res[ !map_lgl(gsea_res, is.null) ]

    saveRDS(gsea_res, file_name)
  }
}



