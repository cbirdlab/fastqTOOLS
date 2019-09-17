#!/bin/bash
#this script adds index1 and index2 fastq files to the beginning of Read1 and Read2 fastq files
#the names of the index reads are lost but the name of the reads for Read1 and Read2 are retained

#make sure to set permissions on this file: 
#chmod 777 pasteIndices2Reads.bash

#this script is meant to be run in conjunction with GNU parallel
#ls *F.fq.gz | sed 's/\.F\.fq\.gz//g' | parallel -j7 --no-notice ./pasteIndices2Reads.bash {}

#read in file base name
BaseName=$1
#read in index1
INDEX1=${BaseName}_I1_001.fastq.gz
#read in index2
INDEX2=${BaseName}_I2_001.fastq.gz
#read in read1
READ1=${BaseName}.F.fq.gz
#read in read2
READ2=${BaseName}.R.fq.gz
#intermediate index file name
INDEX12=${BaseName}_I1I2.fastq
#New read1 with indexes file name
INDEX12_READ1=${BaseName}_I1I2.F.fq.gz
#New read2 with indexes file name
INDEX12_READ2=${BaseName}_I1I2.R.fq.gz

#this takes the two index reads, pastes them together, removes the names and plusses and saves intermediate file
paste -d "" <(zcat $INDEX1) <(zcat $INDEX2) | sed 's/@.*//g' | sed 's/\+\+//g' > $INDEX12

#add indexes to read 1
paste -d "" $INDEX12 <(zcat $READ1) | gzip > $INDEX12_READ1

#add indexes to read 2
paste -d "" $INDEX12 <(zcat $READ2) | gzip > $INDEX12_READ2

#remove intermediate file
rm $INDEX12