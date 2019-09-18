# fastqTOOLS

Scripts to manipulate and extract data from fastq files

* [pasteIndices2Reads.bash](https://github.com/cbirdlab/fastqTOOLS/blob/master/pasteIndices2Reads.bash)
  Script that pastes Index1 and Index2 reads to the beginning of Read1 and Read2
* [stdDemultiplex.bash](https://github.com/cbirdlab/fastqTOOLS/blob/master/stdDemultiplex.bash)
  Script to modify PIRE Fish ID's to the desired fastq base name and add `GG` to the barcodes in the demultiplex decode files
* [ErrorRateCalculation.bash](https://github.com/cbirdlab/fastqTOOLS/blob/master/ErrorRateCalculation.bash)
  Script that outputs the propotion of sequences with insertions or deletions before a given barcode.
