## Summarize bacterial genome alignments
## David R. Hill 2018-09-13
## -----------------------------------------------------------------------------

## load prerequisites
library(magrittr)


## function to extract run info data from a directory
info_df <- function(dir) {
    info.files <- list.files(path = dir,
                         pattern = "run_info.json",
                         full.names = TRUE,
                         recursive = TRUE)
    df <- mapply(
        FUN = function(x) {
            ## load library for json files
            data <- jsonlite::fromJSON(x, flatten = TRUE) %>%
                as.data.frame()
            data$Sample_ID <- strsplit(x, split = "/")[[1]][6]
            data$Sample_ID <- strsplit(data$Sample_ID, split = "_")[[1]][1] %>%
                paste0("Sample_",.)
            data$idx <- strsplit(as.vector(data$call), split = " ")[[1]][4] %>%
                gsub("../data/genomes/", "", x = .)
            return(data)
        },
        x = info.files,
        SIMPLIFY = FALSE)
    return(df)
}

read_stats <- function(dir) {
       read.files <- list.files(path = dir,
                                pattern = "abundance.tsv",
                                full.names = TRUE,
                                recursive = TRUE)
       df <- mapply(
           FUN = function(x) {
               ## load TSV
               data <- readr::read_delim(file = x,
                                         col_names = TRUE,
                                         delim = "\t",
                                         col_types = "cdddd") %>%
                   dplyr::summarize(sum_est_counts = sum(est_counts),
                                    mean_est_counts = mean(est_counts),
                                    over_5_est_counts = sum(est_counts > 5),
                                    not_0_est_counts = sum(est_counts > 0))
               data$Sample_ID <- strsplit(x, split = "/")[[1]][6]
               data$Sample_ID <- strsplit(data$Sample_ID, split = "_")[[1]][1] %>%
                   paste0("Sample_",.)
               return(data)
           },
           x = read.files,
           SIMPLIFY = FALSE)
       return(df)

       }
                                    


## extract data from run info files, concatenate into dataframe, & write out
SE.info <- info_df(dir = "../../results/Run_2374/SE") %>%
    do.call("rbind", .) %>%
    dplyr::left_join(
               readr::read_csv(file = "../../data/Run_2374/Run_2374_oriordan.csv",
                               skip = 18,
                               col_names = TRUE),
               by = 'Sample_ID') %>%
    dplyr::left_join(read_stats(dir = "../../results/Run_2374/SE") %>%
                     do.call("rbind",.),
                     by = 'Sample_ID') %>%
    dplyr::left_join(
               readr::read_csv(file = "../../data/genome_index.csv",
                               col_names = TRUE),
               by = 'idx')

write.csv(SE.info, file = "../../results/SE_alignment_stats.csv")

## extract data from run info files, concatenate into dataframe, & write out
ST.info <- info_df(dir = "../../results/Run_2374/ST") %>%
    do.call("rbind", .) %>%
    dplyr::left_join(
               readr::read_csv(file = "../../data/Run_2374/Run_2374_oriordan.csv",
                               skip = 18,
                               col_names = TRUE),
               by = 'Sample_ID') %>%
    dplyr::left_join(read_stats(dir = "../../results/Run_2374/ST") %>%
                     do.call("rbind",.),
                     by = 'Sample_ID') %>%
    dplyr::left_join(
               readr::read_csv(file = "../../data/genome_index.csv",
                               col_names = TRUE),
               by = 'idx')

write.csv(ST.info, file = "../../results/ST_alignment_stats.csv")

## extract data from run info files, concatenate into dataframe, & write out
STM.info <- info_df(dir = "../../results/Run_2374/STM") %>%
    do.call("rbind", .) %>%
    dplyr::left_join(
               readr::read_csv(file = "../../data/Run_2374/Run_2374_oriordan.csv",
                               skip = 18,
                               col_names = TRUE),
               by = 'Sample_ID') %>%
    dplyr::left_join(read_stats(dir = "../../results/Run_2374/STM") %>%
                     do.call("rbind",.),
                     by = 'Sample_ID') %>%
    dplyr::left_join(
               readr::read_csv(file = "../../data/genome_index.csv",
                               col_names = TRUE),
               by = 'idx')

write.csv(STM.info, file = "../../results/STM_alignment_stats.csv")

## extract data from run info files, concatenate into dataframe, & write out
Hs.info <- info_df(dir = "../../results/Run_2374/H_sapiens") %>%
    do.call("rbind", .) %>%
    dplyr::left_join(
               readr::read_csv(file = "../../data/Run_2374/Run_2374_oriordan.csv",
                               skip = 18,
                               col_names = TRUE),
               by = 'Sample_ID') %>%
    dplyr::left_join(read_stats(dir = "../../results/Run_2374/H_sapiens") %>%
                     do.call("rbind",.),
                     by = 'Sample_ID') %>%

    dplyr::left_join(
               readr::read_csv(file = "../../data/genome_index.csv",
                               col_names = TRUE),
               by = 'idx')

write.csv(Hs.info, file = "../../results/Hs_alignment_stats.csv")

## combine all alignment stats
aln.stats <- rbind(SE.info,
                   ST.info,
                   STM.info,
                   Hs.info)
write.csv(aln.stats, file = "../../results/ALL_alignment_stats.csv")
