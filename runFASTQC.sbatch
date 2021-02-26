#!/bin/bash

# run fastqc on tamucc hpc
# runFASTQC.sbatch [source dir]

#SBATCH --job-name=fqc
#SBATCH --time=96:00:00
#SBATCH -p normal
#SBATCH --nodes=1

module load fastqc
module load parallel

# for help, `fastqc -h`

# set variable with path to fq files, accepts commandline arg
fqPATH=$1

# make dir to catch results
if [ ! -d FASTQC ]; then
  mkdir FASTQC
fi

# feed all files ending in fq to fastqc using parallel
ls ${fqPATH}*fq.gz | parallel --no-notice -j20 "fastqc {} -o FASTQC"
