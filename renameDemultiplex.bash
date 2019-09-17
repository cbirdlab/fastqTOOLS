# This script converts the standard PIRE fish ID in a demultiplex file into an expanded base name for the fq files
# This script should be run line by line, first deleting the `-i` option of sed, until desired output is confirmed

# update these variables as neccessary
SpCODE=Sde
PREFIX=PIRE2019
SITE=Mat

# make sure that files don't have CRLF
ls *${SpCODE}*_demultiplex.txt | parallel --no-notice -q sed -i 's/\r$//g'

# add prefix
ls *${SpCODE}*_demultiplex.txt | parallel --no-notice -j12 -q sed -i "s/\t$SpCODE/\t$PREFIX-$SpCODE/" {} 

# add - after C or A
ls *${SpCODE}*_demultiplex.txt | parallel --no-notice -j12 -q sed -i "s/\($SpCODE-[AC]\)/\1-/" {} 

# add _ after the SITE
ls *${SpCODE}*_demultiplex.txt | parallel --no-notice -j12 -q sed -i "s/\($SITE\)/\1_/" {}

#make replacement suffix
ls *${SpCODE}*_demultiplex.txt | sed 's/_demultiplex.txt//' | sed "s/PI_$SpCODE\([123456789]\)/\1/" | \
sed "s/20190905[_-]PIRE[_-]$SpCODE-[AC][_-]//" | sed 's/^P/Plate/' | sed 's/1P/1Pool/' | sed 's/_/Seq1-/' | \
sed 's/$/-L4/' > ${SpCODE}_lab.txt

#make list of file names to change
ls *${SpCODE}*_demultiplex.txt > ${SpCODE}_dmx.txt

#add lab info
parallel --no-notice --link sed -i "s/$/-{2}/" {1} :::: ${SpCODE}_dmx.txt :::: ${SpCODE}_lab.txt

#add bandaid to separate plate
ls *${SpCODE}*_demultiplex.txt | parallel --no-notice -j12 "sed -i 's/_Plate/-Plate/' {} "

# fix pools by replacing -pool with _pool
ls *${SpCODE}*_demultiplex.txt | parallel --no-notice -j12 "sed -i 's/-Pool-/_Pool-/' {} "

#remove unneccessary files
rm ${SpCODE}_dmx.txt ${SpCODE}_lab.txt
