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

## extract data from run info files, concatenate into dataframe, & write out
SE.info <- info_df(dir = "../../results/Run_2374/SE") %>%
    do.call("rbind", .) %>%
    dplyr::left_join(
               readr::read_csv(file = "../../data/Run_2374/Run_2374_oriordan.csv",
                               skip = 18,
                               col_names = TRUE),
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
    dplyr::left_join(
               readr::read_csv(file = "../../data/genome_index.csv",
                               col_names = TRUE),
               by = 'idx')

write.csv(STM.info, file = "../../results/STM_alignment_stats.csv")
