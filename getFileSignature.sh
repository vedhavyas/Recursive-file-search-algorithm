#!/bin/bash
#set -x;

tempFolder=$2/temp;
absPath=$1;
finalFile=$4/$3;
processedFile=$4/processedFilePath.txt;
cpuSummary=$4/host_summary.txt;
configFile=$4/config.txt;
SAVEIFS=$IFS;
IFS=$(echo -en "\n\b");

## tarFile function starts here##
tarFile(){
#dir=`echo $1 | cut -d'.' -f1`;
dir=`echo $1 | awk -F. '{t="";for(i=1;i<=NF-1;i++){ t=t$i"."} printf("%s",t)}'`;
dir=`echo "${dir%?}"`;
mkdir -p $dir
tar -x --file=$1 --overwrite -C $dir;
cd $dir;
if [ "$(ls -A $dir)" ]; then
listTar=$dir/*;
for j in $listTar
do
if ! [[ -L "$j" ]]; then
ext=`echo "${j##*.}"`;
grep -i $ext $configFile >/dev/null;
if [ $? != 0 ]
then
  if [ -d $j ] ; then
     folder $j `pwd`;
  elif [[ $j =~ \.t?gz$ ]] ; then
     tarFile $j `pwd`;
  elif [[ $j =~ \.t?bz2$ ]]; then
     bz2File $j `pwd`;
  elif [[ $j =~ \.t?bz$ ]]; then
     bz2File $j `pwd`;
  elif [[ $j =~ \.zip$ ]]; then
     zipFile $j `pwd`;
  else
     echo -n `basename $j` >> $finalFile;
     echo -n `basename $j` >> $processedFile;
     echo -n "   -   " >> $processedFile;
     echo $j | awk -F/ '{t="";
                        for (i=2;i<NF;i++){
                               if ($i =="temp"){
                                    j=i;
                                   }
                               }
                        for (i=j+1;i<NF;i++){
                               t=t$i"/";
                               }
                               print t;
                       }' >> $processedFile;
     echo `md5sum $j | awk '{print " - "  $1}'`   >> $finalFile;
    
  fi
fi
fi
done
fi
cd $2;
}

## zipFile function starts here ##
zipFile(){

#dir=`echo $1 | cut -d'.' -f1`;
dir=`echo $1 | awk -F. '{t="";for(i=1;i<=NF-1;i++){ t=t$i"."} printf("%s",t)}'`;
dir=`echo "${dir%?}"`;
mkdir -p $dir
cd $dir;
unzip -o $1 >/dev/null 2>&1 ;
if [ "$(ls -A $dir)" ]; then
listZip=$dir/*;
for m in $listZip
do
if ! [[ -L "$m" ]]; then
ext=`echo "${m##*.}"`;
grep -i $ext $configFile >/dev/null;
if [ $? != 0 ]
then
  if [ -d $m ] ; then
     folder $m `pwd`;
  elif [[ $m =~ \.t?gz$ ]] ; then
     tarFile $m `pwd`;
  elif [[ $m =~ \.t?bz2$ ]]; then
     bz2File $m `pwd`;
  elif [[ $m =~ \.t?bz$ ]]; then
     bz2File $m `pwd`;
  elif [[ $m =~ \.zip$ ]]; then
     zipFile $m `pwd`;
  else
     echo -n `basename $m` >> $finalFile;
     echo -n `basename $m` >> $processedFile;
     echo -n "   -   " >> $processedFile;
     echo $m | awk -F/ '{t="";
                        for (i=2;i<NF;i++){
                               if ($i =="temp"){
                                    j=i;
                                   }
                               }
                        for (i=j+1;i<NF;i++){
                               t=t$i"/";
                               }
                               print t;
                       }' >> $processedFile;  
     echo `md5sum $m | awk '{print " - "  $1}'`   >> $finalFile;

  fi
fi
fi
done
fi
cd $2;

}
## bz2File function starts here ##
bz2File(){

#dir=`echo $1 | cut -d'.' -f1`;
dir=`echo $1 | awk -F. '{t="";for(i=1;i<=NF-1;i++){ t=t$i"."} printf("%s",t)}'`;
dir=`echo "${dir%?}"`;
mkdir -p $dir
cd $dir;
bzip2 -df $1;
if [ "$(ls -A $dir)" ]; then
listBzip=$dir/*;
for l in $listBzip
do
if ! [[ -L "$l" ]]; then
ext=`echo "${l##*.}"`;
grep -i $ext $configFile >/dev/null;
if [ $? != 0 ]
then
  if [ -d $l ] ; then
     folder $l `pwd`;
  elif [[ $l =~ \.t?gz$ ]] ; then
     tarFile $l `pwd`;
  elif [[ $l =~ \.t?bz2$ ]]; then
     bz2File $l `pwd`;
  elif [[ $l =~ \.t?bz$ ]]; then
     bz2File $l `pwd`;
  elif [[ $l =~ \.zip$ ]]; then
     zipFile $l `pwd`;
  else
     echo -n `basename $l` >> $finalFile;
     echo -n `basename $l` >> $processedFile;
    echo -n "   -   " >> $processedFile;
    echo $l | awk -F/ '{t="";
                        for (i=2;i<NF;i++){
                               if ($i =="temp"){
                                    j=i;
                                   }
                               }
                        for (i=j+1;i<NF;i++){
                               t=t$i"/";
                               }
                               print t;
                       }' >> $processedFile;
     echo `md5sum $l | awk '{print " - "  $1}'`   >> $finalFile;

  fi
fi
fi
done
fi
cd $2;

}
## folder function starts here##
folder(){

cd $1;
if [ "$(ls -A $1)" ]; then
listDir=$1/*;
for k in $listDir
do
if ! [[ -L "$k" ]]; then
ext=`echo "${k##*.}"`;
grep -i $ext $configFile >/dev/null;
if [ $? != 0 ]
then
if [ -d $k ] ; then
    folder $k `pwd`;
elif [[ $k =~ \.t?gz$ ]] ; then
    tarFile $k `pwd`;
elif [[ $k =~ \.t?bz2$ ]]; then
    bz2File $k `pwd`;
elif [[ $k =~ \.t?bz$ ]]; then
    bz2File $k `pwd`;
elif [[ $k =~ \.zip$ ]]; then
    zipFile $k `pwd`;
else
    echo -n `basename $k` >> $finalFile;
    echo -n `basename $k` >> $processedFile;
    echo -n "   -   " >> $processedFile;
    echo $k | awk -F/ '{t="";
                        for (i=2;i<NF;i++){
                               if ($i =="temp"){
                                    j=i;
                                   }
                               }
                        for (i=j+1;i<NF;i++){
                               t=t$i"/";
                               }
                               print t;
                       }' >> $processedFile;
    echo `md5sum $k | awk '{print " - "  $1}'`   >> $finalFile;
 
fi
fi
fi
done
fi
cd $2;
}



## main function starts here##

if [ -d $tempFolder ] ; then
rm -rf $tempFolder ;
fi

if [ -f $finalFile ] ; then
rm -rf $finalFile ;
fi

if [ -f $processedFile ] ; then
rm -rf $processedFile ;
fi

if [ -f $cpuSummary ] ; then
rm -rf $cpuSummary ;
fi

mkdir $tempFolder;
cp -r $absPath/* $tempFolder;

cd $tempFolder;
echo "================================" >> $cpuSummary;
echo "       SERVER DETAILS           " >> $cpuSummary;
echo "================================" >> $cpuSummary;
ulimit -a  >>$cpuSummary >&1 &
echo "================================" >> $cpuSummary;
cat /proc/cpuinfo >>$cpuSummary >&1 &
echo "================================" >> $cpuSummary;
cat /proc/meminfo >>$cpuSummary >&1 &
echo "================================" >> $cpuSummary;
date >>$cpuSummary >&1 &
echo "================================" >> $cpuSummary;

if [ "$(ls -A $tempFolder)" ]; then
mainList=$tempFolder/*;
echo "==============================" >> $finalFile;
echo "   File Name - Md5Sum Bytes   "  >> $finalFile;
echo "==============================" >> $finalFile;
echo "==============================" >> $processedFile;
echo "   File name - File path      " >> $processedFile;
echo "==============================" >> $processedFile; 

for i in $mainList
do
if ! [[ -L "$i" ]]; then
ext=`echo "${i##*.}"`;
grep -i $ext $configFile >/dev/null;
if [ $? != 0 ]
then
  if [ -d $i ] ; then
     folder $i `pwd`;
  elif [[ $i =~ \.t?gz$ ]] ; then
       tarFile $i `pwd`;
  elif [[ $i =~ \.t?bz2$ ]]; then
       bz2File $i `pwd`;
  elif [[ $i =~ \.t?bz$ ]]; then
       bz2File $i `pwd`;
  elif [[ $i =~ \.zip$ ]]; then 
       zipFile $i `pwd`;
  else
    echo -n `basename $i` >> $finalFile;
    echo -n `basename $i` >> $processedFile;
    echo -n "   -   " >> $processedFile;
    echo $i | awk -F/ '{t="";
                        for (i=2;i<NF;i++){
                               if ($i =="temp"){
                                    j=i;
                                   }
                               }
                        for (i=j+1;i<NF;i++){
                               t=t$i"/";
                               }
                               print t;
                       }' >> $processedFile;
    echo `md5sum $i | awk '{print " - "  $1}'`   >> $finalFile;
  fi
fi
fi
done
fi
rm -rf $tempFolder;
IFS=$SAVEIFS;
