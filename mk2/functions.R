plot_gsea <- function(df, es_col="E", pval_col="adj.P.Val") {

  df <- df %>% arrange(-.data[[pval_col]])
  df$log10_pval <- -log10(df[[pval_col]])

	df$Title <- .cleanup_ids(df$Title)
	df$Title <- factor(df$Title, levels=df$Title)
  
  ggplot(df, 
         aes_string(x="Title", y="log10_pval", fill=es_col)) + geom_bar(stat="identity") +
         xlab("") +
         ylab("-log10(FDR)") +
         coord_flip()


}

.cleanup_ids <- function(ids) {
  ids <- gsub("_", " ", ids)

  #return(ids)

  ids <- strsplit(ids, " ")
  min.l <- min(sapply(ids, length))

  max_prefix <- 0
  for(i in 1:min.l) {

    if(length(unique(sapply(ids, function(x) x[i]))) == 1L) {
      max_prefix <- i
    }
  }

  if(max_prefix > 0) {
    ids <- lapply(ids, function(x) x[ -1:-max_prefix ])
  }

  ids <- unlist(lapply(ids, paste, collapse=" "))

  if(!any(grepl("[a-z]", ids))) {
    ids <- tolower(ids)
    substr(ids, 1, 1) <- toupper(substr(ids, 1, 1))
  }

  ids
}


ggplot_gene <- function(x, group, 
                        groups=list(1:2, 3:4),
                        annotation=NULL, ...) {

  df <- data.frame(Expression=x, Group=group)

  p1 <- ggplot(df, aes(x=Group, y=Expression)) + 
      geom_jitter(width = .2, size=1, alpha=.5) +
      geom_boxplot(fill=NA, outlier.shape = NA) 
      
  if(!is.null(annotation)) {
    p1 <- add_pval(p1, groups, annotation = annotation, ...)
  }

  p1

}

ggplot_disco <- function(df,
                         lfc1="log2FoldChange.g1",
                         lfc2="log2FoldChange.g2",
                         pval1="padj.g1",
                         pval2="padj.g2") {

  df$disco <- 1





}




