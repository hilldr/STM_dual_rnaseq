## R script to export kallisto results to matrix with DESeq2
## David R. Hill
## -----------------------------------------------------------------------------

getwd()  ## Should be ../STM_dual_rnaseq/src

## Differential expression of kallisto results with DESeq2
kallisto.results.dir.hs <- "../results/Run_2286/H_sapiens/"
kallisto.results.dir.stm <- "../results/Run_2286/STM/"
## create directory to deposit results
results.dir <- "../results/DESeq2_human/"
dir.create(path = results.dir, recursive = TRUE)

## read in table with sample metadata
## load using the UM core provided sample submission form
samples <- readr::read_csv(file = "../data/Run_2286/Run_2286_oriordan.csv",
                           skip = 18)

## create experimental design labels from Description string
samples$group <- gsub('.{2}$', '', samples$Description)
samples$hr <- c(rep('8', 8), rep('24', 2))

## setup access to kallisto read files (human alignment)
files <- file.path(kallisto.results.dir.hs,
                   paste0(samples$Sample_Name,"_S",
                          as.numeric(rownames(samples)),
                          "_L007_R1_001.fastq"),
                   "abundance.tsv") 

## set sample names as description_rep#_seq_rep#
names(files) <- samples$Description
## check that all files are found
if (all(file.exists(files)) == FALSE) {
    print("kallisto files not found")
    stop()
}

## associate transcripts with gene IDs
## create biomart reference
mart <- biomaRt::useMart(biomart = "ENSEMBL_MART_ENSEMBL",
  dataset = "hsapiens_gene_ensembl",
  host = 'ensembl.org')
## create index of gene names
tx2gene <- biomaRt::getBM(attributes = c("ensembl_transcript_id",
                                         "external_gene_name"),
                          mart = mart)

## import kallisto data and generate count dataframe (dds)
## http://bioconductor.org/packages/release/bioc/vignettes/tximport/inst/doc/tximport.html
library(readr)
txi <- tximport::tximport(files,
                          type = "kallisto",
                          tx2gene = tx2gene)

## export abundance counts
write.csv(txi$abundance, file = file.path(results.dir, "complete_dataset_txi.csv"))

library(DESeq2)
## https://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html
dds <- DESeq2::DESeqDataSetFromTximport(txi,
                                        colData = samples,
                                        design = ~ group) # hr ~ status
## pre-filter out counts < 1
dds <- dds[rowSums(counts(dds)) > 1, ]

## write out normalized expression counts
dds <- DESeq2::estimateSizeFactors(dds)
ddscounts <- DESeq2::counts(dds, normalized = TRUE)

## write expression matrix to file
write.csv(ddscounts, file =  file.path(results.dir, "complete-dataset_DESeq2-normalized-counts.csv"))
save(dds, file = file.path(results.dir, "dds.Rdata"))

## clear working memory
rm(list = ls())
