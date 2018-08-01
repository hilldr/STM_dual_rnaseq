#! /bin/bash
## script to download and index bacterial genomes
## for RNA-seq alignment in kallisto
## DAVID R. HILL
## -----------------------------------------------------------------------------

## make directory for genomes
mkdir -p ../data/genomes

## Salmonella enterica subsp. enterica serovar Enteritidis str. P125109
## GenBank: AM933172.1
rsync --copy-links --times --verbose rsync://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Salmonella_enterica/latest_assembly_versions/GCF_000009505.1_ASM950v1/GCF_000009505.1_ASM950v1_cds_from_genomic.fna.gz ../data/genomes

## Salmonella enterica Subsp. enterica serovar Typhi Ty2
## Genbank: AE014613.1
rsync --copy-links --times --verbose rsync://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Salmonella_enterica/latest_assembly_versions/GCF_000007545.1_ASM754v1/GCF_000007545.1_ASM754v1_cds_from_genomic.fna.gz ../data/genomes

## Salmonella enterica Subsp. enterica serovar Typhimurium SL1344
## GenBank: FQ312003.1
rsync --copy-links --times --verbose rsync://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Salmonella_enterica/latest_assembly_versions/GCF_000210855.2_ASM21085v2/GCF_000210855.2_ASM21085v2_cds_from_genomic.fna.gz ../data/genomes

for file in ../data/genomes/*.fna.gz
do
    kallisto index --index=$file
done
