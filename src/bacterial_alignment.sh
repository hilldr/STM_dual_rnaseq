#! /bin/bash
## KALLISTO PROCESSING SCRIPT
## alignment to Salmonella Typhimurium transcriptome
##
## David R. Hill
## -----------------------------------------------------------------------------
## Setup variables
## start time
DT1=$(date '+%d/%m/%Y %H:%M:%S')
## email address for notifications
EMAIL=d2.david.hill@gmail.com

## -----------------------------------------------------------------------------
## Salmonella enterica subsp. enterica serovar Enteritidis str. P125109
## GenBank: AM933172.1
## genome index file
INDEX=../data/genomes/GCF_000009505.1_ASM950v1_cds_from_genomic.fna.gz.idx
## This is the directory where the kallisto results will be deposited
RESULTDIR=../results/Run_2374/SE/
## make the folder to deposit results
mkdir -p $RESULTDIR
## this is the directory that contains the fastq directories
for dir in ../data/Run_2374/oriordan/*
## for loop will iterate through each directory and find fastq files and run
## kallisto with specified arguments
do
    for file in $dir/*.fastq*
    do
	SHORTNAME=$(basename "$file")
	NAME2="${SHORTNAME##*/}"	
	DIRNAME="${NAME2%.*}"  
	## These settings are for single-end 50 bp reads
	kallisto quant -i $INDEX \
    		 --output-dir=$RESULTDIR/$DIRNAME \
    		 --threads=8 \
    		 --bootstrap-samples=100 \
    		 --single \
    		 --fragment-length=50 \
    		 --sd=1 \
    		 $file
    done
done

## -----------------------------------------------------------------------------
## Salmonella enterica Subsp. enterica serovar Typhi Ty2
## Genbank: AE014613.1
## genome index file
INDEX=../data/genomes/GCF_000007545.1_ASM754v1_cds_from_genomic.fna.gz.idx
## This is the directory where the kallisto results will be deposited
RESULTDIR=../results/Run_2374/ST/
## make the folder to deposit results
mkdir -p $RESULTDIR

## this is the directory that contains the fastq directories
for dir in ../data/Run_2374/oriordan/*
## for loop will iterate through each directory and find fastq files and run
## kallisto with specified arguments
do
    for file in $dir/*.fastq*
    do
	SHORTNAME=$(basename "$file")
	NAME2="${SHORTNAME##*/}"	
	DIRNAME="${NAME2%.*}"  
	## These settings are for single-end 50 bp reads
	kallisto quant -i $INDEX \
    		 --output-dir=$RESULTDIR/$DIRNAME \
    		 --threads=8 \
    		 --bootstrap-samples=100 \
    		 --single \
    		 --fragment-length=50 \
    		 --sd=1 \
    		 $file
    done
done

## -----------------------------------------------------------------------------
## Salmonella enterica Subsp. enterica serovar Typhimurium SL1344
## GenBank: FQ312003.1
## genome index file
INDEX=../data/genomes/GCF_000210855.2_ASM21085v2_cds_from_genomic.fna.gz.idx
## This is the directory where the kallisto results will be deposited
RESULTDIR=../results/Run_2374/STM/
## make the folder to deposit results
mkdir -p $RESULTDIR

## this is the directory that contains the fastq directories
for dir in ../data/Run_2374/oriordan/*
## for loop will iterate through each directory and find fastq files and run
## kallisto with specified arguments
do
    for file in $dir/*.fastq*
    do
	SHORTNAME=$(basename "$file")
	NAME2="${SHORTNAME##*/}"	
	DIRNAME="${NAME2%.*}"  
	## These settings are for single-end 50 bp reads
	kallisto quant -i $INDEX \
    		 --output-dir=$RESULTDIR/$DIRNAME \
    		 --threads=8 \
    		 --bootstrap-samples=100 \
    		 --single \
    		 --fragment-length=50 \
    		 --sd=1 \
    		 $file
    done
done

## -----------------------------------------------------------------------------
## Send email notification of script completion
DT2=$(date '+%d/%m/%Y %H:%M:%S')
echo "Kalliso run initiated at $DT1 complete at $DT2" | mail -s "Kallisto complete" $EMAIL
