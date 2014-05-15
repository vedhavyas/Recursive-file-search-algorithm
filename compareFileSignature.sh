#!/bin/bash

if [ $# -lt 5 ] ; then
echo -e "Usage: $0 <Md5file1> <Md5file2> <processedFilePath1> <processedFilePath2> <OutPut File name>\n"  ;
exit 0 ;
fi

tempFile=$5_temporaryFile;
finalFile=$5;

if [ -f $finalFile ] ; then
rm -rf $finalFile ;
fi

sort $1 > $5_temp1;
sort $2 > $5_temp2;
diff $5_temp1 $5_temp2 > $tempFile;
rm -rf $5_temp1 $5_temp2 ; 

if [[ -s $tempFile ]] ; then
echo "Md5 bytes didnt match. Please check $finalFile for more details";
echo "Failed" >> $finalFile;
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
echo "Sucess" >> $finalFile;
echo "Congratulations.... Md5 bytes Matched" >> $finalFile;
echo "Congratulations.... Md5 bytes Matched";
fi ;
rm -rf $tempFile;
