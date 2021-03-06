#!/bin/bash

# This script collects data and calculates rudimentary statistics on rates of deletions and mismatches in the first 
# 16 bases of SbfI digested newRAD fastq files

# Motif of first 16 bases:
## 2bp of SbfI in Ligation1 Adapter - 8bp of BARCODE - 4bp of SbfI overhang, ligation 1 site - 2 bp of SbfI in individual
## Oligo                            - Oligo          - 1 Strand Oligo, 1 Fish                - Fish

# For this script to work, ".fq" files must use the R1/R2 naming convention and be located in the same directory as 
# you are running this script "bash ErrorRateCalculation.bash".

# To run:
# bash ErrorRateCalculation.bash

ErrorRateCalc () {
	fqBase=$1
	for barcode in CGATGCTCTGCA AAGCCGGTTGCA; do 
		for read in R1 R2; do 
			echo fqBase,read,barcode,P1del,P2del,PropP1Del,PropP2Del,PropNoDels,PropOneIns,PropTwoIns > ${fqBase}_${barcode}_${read}_Summary.csv #Finish adding summary statistics here and line 53
			# Calculating number of delitions in position 1

			TwoDels=$(agrep -3 -D100 -I100 "^${barcode}" ${fqBase}.${read}.fq | head -n -1 | wc -l)
			OneDels=$(agrep -3 -D100 -I100 "^.${barcode}" ${fqBase}.${read}.fq | head -n -1 | wc -l)
			NoDels=$(agrep -3 -D100 -I100 "^..${barcode}" ${fqBase}.${read}.fq | head -n -1 | wc -l)
			OneIns=$(agrep -3 -D100 -I100 "^...${barcode}" ${fqBase}.${read}.fq | head -n -1 | wc -l)
			TwoIns=$(agrep -3 -D100 -I100 "^....${barcode}" ${fqBase}.${read}.fq | head -n -1 | wc -l)
			AllOutcomes=$(($TwoDels + $OneDels + $NoDels + $OneIns + $TwoIns))
			echo $TwoDels $OneDelds $NoDels $OneIns $TwoIns



			P1del=$(($TwoDels + $OneDels))
			P2del=$OneDels


			PropP1Del=$(echo $P1del / $AllOutcomes | bc -l)
			PropP2Del=$(echo $P2del / $AllOutcomes | bc -l)
			PropTwoDels=$(echo $TwoDels / $AllOutcomes | bc -l)
			PropOneDels=$(echo $OneDels / $AllOutcomes | bc -l)
			PropNoDels=$(echo $NoDels / $AllOutcomes | bc -l) 
			PropOneIns=$(echo $OneIns / $AllOutcomes | bc -l)
			PropTwoIns=$(echo $TwoIns / $AllOutcomes | bc -l)
			echo $PropP1Del $PropP2Del $PropNoDels $PropOneIns $PropTwoIns

			echo $PropTwoDels + $PropOneDels + $PropNoDels + $PropOneIns + $PropTwoIns | bc -l


			NoDelsSub1=$(agrep -3 -D100 -I100 "^..${barcode}" ${fqBase}.${read}.fq | head -n -1 | cut -c 1 | grep -cv G)


			agrep -3 -D100 -I100 "^..${barcode}" ${fqBase}.${read}.fq | head -n -1 > ${fqBase}.${read}.${barcode}.NoDels.seq
			agrep -3 -D100 -I100 "^...${barcode}" ${fqBase}.${read}.fq | head -n -1 | cut -c 2- >> ${fqBase}.${read}.${barcode}.NoDels.seq
			agrep -3 -D100 -I100 "^....${barcode}" ${fqBase}.${read}.fq | head -n -1 | cut -c 3- >> ${fqBase}.${read}.${barcode}.NoDels.seq
			P1Sub=$(cut -c 1 ${fqBase}.${read}.${barcode}.NoDels.seq | grep -cv G)
			AllNoDelsOutcomes=$(wc -l ${fqBase}.${read}.${barcode}.NoDels.seq | cut -d " " -f1)
			PropP1Sub=$(echo $P1Sub / $AllNoDelsOutcomes | bc -l)

			agrep -3 -D100 -I100 "^....${barcode}" ${fqBase}.${read}.fq | head -n -1 | sed 's/^/z/g' >> ${fqBase}.${read}.${barcode}.NoDels.seq
			P2Sub=$(cut -c 2 ${fqBase}.${read}.${barcode}.NoDels.seq | grep -cv G)
			AllNoDelsOutcomes=$(wc -l ${fqBase}.${read}.${barcode}.NoDels.seq | cut -d " " -f1)
			PropP2Sub=$(echo $P2Sub / $AllNoDelsOutcomes | bc -l)

			cut -c 1-16 ${fqBase}.${read}.${barcode}.NoDels.seq | sed -e 's/\(.\)/\1,/g' | cut -c 1-31 | sed "s/^/$fqBase,$barcode,$read,/g" > ${fqBase}_${barcode}_${read}.csv #save to file
			
			#Output Summary Stats
			echo ${fqBase},${read},${barcode},$P1del,$P2del,$PropP1Del,$PropP2Del,$PropNoDels,$PropOneIns,$PropTwoIns >> ${fqBase}_${barcode}_${read}_Summary.csv #add more
		done
	done

}
export -f ErrorRateCalc
#run function in parallel
ls *R1.fq | sed 's/\.R1\.fq//g' | parallel -j 7 --no-notice ErrorRateCalc {} 
