## monte carlo simulation: 100 replicates of the procedure shown in the
## paper

## output directory
outdir <- "montecarlo"
dir.create(path=outdir, showWarnings = FALSE)

## number of replicates
n_sim <- 100

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

one_replicate_ds2 <- function(covar, counts) {
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
for(i in 1:n_sim) {
  ds2 <- one_replicate_ds2(covar, counts)

  file_name <- file.path(outdir, sprintf("ds2_%d.rds", i))
  saveRDS(ds2, file=file_name)
}

