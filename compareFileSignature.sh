#!/bin/bash

if [ $# -lt 4 ] ; then
echo -e "Usage: $0 <Md5file1> <Md5file2> <processedFilePath1> <processedFilePath2>\n"  ;
exit 0 ;
fi

tempFile="temporaryFile";
finalFile="comparedResults";
sort $1 > temp1;
sort $2 > temp2;
diff temp1 temp2 > $tempFile;
rm -rf temp1 temp2 ; 

if [[ -s $tempFile ]] ; then
echo "Md5 bytes didnt match. Please check $finalFile for more details";
echo -e "Mismatched Data in $1 :  " >> $finalFile;
echo "-----------------------" >> $finalFile;
str=`awk '{if ($1 == "<"){ print $2 }}' $tempFile`;
for i in $str
do
echo `grep $i $3` >> $finalFile;
done
echo "-----------------------" >> $finalFile;
echo -e "Mismatched Data in $2 :  " >> $finalFile;
echo "-----------------------" >> $finalFile;
str2=`awk '{if ($1 == ">"){ print $2 }}' $tempFile`;
for i in $str2
do
echo `grep $i $4` >> $finalFile;
done
echo "-----------------------" >> $finalFile;
else
echo "Congratulations.... Md5 bytes Matched" >> $finalFile;
echo "Congratulations.... Md5 bytes Matched";
fi ;
rm -rf $tempFile;
