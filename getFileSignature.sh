#!/bin/bash
#set -x;


tempFolder=$2/temp;
absPath=$1;
finalFile=$4/$3;
appendName=`echo $3 | awk -F. '{print $1}'`;
processedFile=$4/$appendName-processedFilePath.txt;
cpuSummary=$4/host_summary.txt;
configFile=$4/config.txt;
uniqueFile=$4/$3_uniqueNumber.txt;
SAVEIFS=$IFS;
unwar=`echo $5 | awk -F= '{print $NF}'`;
IFS=$(echo -en "\n\b");
excludeList=`cat $configFile | grep exclude | awk -F'[=,]' '{for(i=2;i<=NF;i++){print $i}}'`;
includeList=`cat $configFile | grep include | awk -F'[=,]' '{for(i=2;i<=NF;i++){print $i}}'`;

## tarFile function starts here##
tarFile(){
dir=`echo $1 | awk -F. '{print $1}'`;
mkdir -p $dir
tar -x --file=$1 --overwrite -C $dir;
cd $dir;
if [ "$(ls -A $dir)" ]; then
listTar=$dir/*;
for j in $listTar
do
if ! [[ -L "$j" ]]; then
file=`echo $j | awk -F/ '{print $NF}'`;
ext=`echo "${file##*.}"`;
retFile=0;
retExt=0;

for s in $excludeList
do
if [ $file == $s ]
then
retFile=1;
fi
if [ $ext == $s ]
then
retExt=1;
fi
done

if [ $retFile != 1 -o $retExt != 1 ]
then
  if [ -d $j ] ; then
     folder $j `pwd`;
  elif [[ $j =~ \.t?gz$ ]] ; then
     tarFile $j `pwd`;
  elif [[ $j =~ \.tar$ ]]; then
       tarFile $j `pwd`;
  elif [[ $j =~ \.t?bz2$ ]]; then
     tarFile $j `pwd`;
  elif [[ $j =~ \.t?bz$ ]]; then
     bz2File $j `pwd`;
  elif [[ $j =~ \.zip$ ]]; then
     zipFile $j `pwd`;
  elif [[ $j =~ \.war$ ]]; then
       if [ $unwar == 'true' ];then
       mv $j $file.zip;
       zipFile $j `pwd`;
       else
         retFile=0;
         retExt=0;
         for t in $includeList
         do
	 if [ $ext == $t ]
         then
         retExt=1;
         fi
         if [ $file == $t ]
         then
         retFile=1;
         fi
         done
         if [ $retFile == 1 -o $retExt == 1 ]
         then
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
         retFile=0;
         retExt=0;
        fi
      fi 	 
  else
    retFile=0;
    retExt=0;
    for t in $includeList
    do
    if [ $ext == $t ]
    then
    retExt=1;
    fi
    if [ $file == $t ]
    then
    retFile=1;
    fi
    done
    if [ $retExt == 1 -o $retFile == 1 ]
    then
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
     retFile=0;
     retExt=0;
    fi
  fi
fi
fi
done
fi
cd $2;
}

## zipFile function starts here ##
zipFile(){

dir=`echo $1 | awk -F. '{print $1}'`;
mkdir -p $dir
cd $dir;
unzip -o $1 >/dev/null 2>&1 ;
if [ "$(ls -A $dir)" ]; then
listZip=$dir/*;
for m in $listZip
do
if ! [[ -L "$m" ]]; then
file=`echo $m | awk -F/ '{print $NF}'`;
ext=`echo "${file##*.}"`;
retFile=0;
retExt=0;
for s in $excludeList
do
if [ $file == $s ]
then
retFile=1;
fi
if [ $ext == $s ]
then
retExt=1;
fi
done

if [ $retFile != 1 -o $retExt != 1 ]
then
  if [ -d $m ] ; then
     folder $m `pwd`;
  elif [[ $m =~ \.t?gz$ ]] ; then
     tarFile $m `pwd`;
  elif [[ $m =~ \.tar$ ]]; then
       tarFile $m `pwd`;
  elif [[ $m =~ \.t?bz2$ ]]; then
     tarFile $m `pwd`;
  elif [[ $m =~ \.t?bz$ ]]; then
     bz2File $m `pwd`;
  elif [[ $m =~ \.zip$ ]]; then
     zipFile $m `pwd`;
  elif [[ $m =~ \.war$ ]]; then
       if [ $unwar == 'true' ];then
       zipFile $m `pwd`;
       else
         retFile=0;
         retExt=0;
         for t in $includeList
         do
	 if [ $ext == $t ]
         then
         retExt=1;
         fi
         if [ $file == $t ]
         then
         retFile=1;
         fi  
         done
         if [ $retExt == 1 -o $retFile == 1 ]
         then
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
         retFile=0;
         retExt=0;
        fi
      fi 	 
  else
    retFile=0;
    retExt=0;
    for t in $includeList
    do
    if [ $ext == $t ]
    then
    retExt=1;
    fi
    if [ $file == $t ]
    then
    retFile=1;
    fi
    done
    if [ $retExt == 1 -o $retFile == 1 ]
    then
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
     retFile=1;
     retExt=1;
  fi
  fi
fi
fi
done
fi
cd $2;

}
## bz2File function starts here ##
bz2File(){

dir=`echo $1 | awk -F. '{print $1}'`;
mkdir -p $dir
cd $dir;
bzip2 -df $1;
if [ "$(ls -A $dir)" ]; then
listBzip=$dir/*;
for l in $listBzip
do
if ! [[ -L "$l" ]]; then
file=`echo $l | awk -F/ '{print $NF}'`;
ext=`echo "${file##*.}"`;
retFile=0;
retExt=0;
for s in $excludeList
do
if [ $file == $s ]
then
retFile=1;
fi
if [ $ext == $s ]
then
retExt=1;
fi
done

if [ $retFile != 1 -o $retExt != 1 ]
then
  if [ -d $l ] ; then
     folder $l `pwd`;
  elif [[ $l =~ \.t?gz$ ]] ; then
     tarFile $l `pwd`;
  elif [[ $l =~ \.tar$ ]]; then
       tarFile $l `pwd`;
  elif [[ $l =~ \.t?bz2$ ]]; then
     tarFile $l `pwd`;
  elif [[ $l =~ \.t?bz$ ]]; then
     bz2File $l `pwd`;
  elif [[ $l =~ \.zip$ ]]; then
     zipFile $l `pwd`;
  elif [[ $l =~ \.war$ ]]; then
       if [ $unwar == 'true' ];then
       zipFile $l `pwd`;
       else
         retFile=0;
         retExt=0;
         for t in $includeList
         do
	 if [ $ext == $t ]
         then
         retExt=1;
         fi
         if [ $file == $t ]
         then
         retFile=1;
         fi
         done
         if [ $retExt == 1 -o $retFile == 1 ]
         then
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
         retFile=0;
         retExt=0; 
        fi
      fi 
  else
    retFile=0;
    retExt=0;
    for t in $includeList
    do
    if [ $ext == $t ]
    then
    retExt=1;
    fi
    if [ $file == $t ]
    then
    retFile=1;
    fi 
    done
    if [ $retExt == 1 -o $retFile == 1 ]
    then
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
     retFile=0;
     retExt=0;
  fi
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
file=`echo $k | awk -F/ '{print $NF}'`;
ext=`echo "${file##*.}"`;
retFile=0;
retExt=0;
for s in $excludeList
do
if [ $file == $s ]
then
retFile=1;
fi
if [ $ext == $s ]
then
retExt=1;
fi
done

if [ $retFile != 1 -o $retExt != 1 ]
then
if [ -d $k ] ; then
    folder $k `pwd`;
elif [[ $k =~ \.t?gz$ ]] ; then
     tarFile $k `pwd`;
elif [[ $k =~ \.tar$ ]]; then
       tarFile $k `pwd`;
elif [[ $k =~ \.t?bz2$ ]]; then
    tarFile $k `pwd`;
elif [[ $k =~ \.t?bz$ ]]; then
    bz2File $k `pwd`;
elif [[ $k =~ \.zip$ ]]; then
    zipFile $k `pwd`;
elif [[ $k =~ \.war$ ]]; then
       if [ $unwar == 'true' ];then
       zipFile $k `pwd`;
       else
         retFile=0;
         retExt=0; 
         for t in $includeList
         do
	 if [ $ext == $t ]
         then
         retExt=1;
         fi
         if [ $file == $t ]
         then
         retFile=1;
         fi
         done
         if [ $retExt == 1 -o $retFile == 1 ]
         then
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
         retFile=0;
         retExt=0;
        fi
      fi 	
else
    retFile=0;
    retExt=0;
    for t in $includeList
    do
    if [ $ext == $t ]
    then
    retExt=1;
    fi
    if [ $file == $t ]
    then
    retFile=1;
    fi 
    done
	if [ $retExt == 1 -o $retFile == 1 ]
    then
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
    retFile=0;
    retExt=0;
fi
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

if [ -f $uniqueFile ] ; then
rm -rf $uniqueFile ;
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
file=`echo $i | awk -F/ '{print $NF}'`;
ext=`echo "${file##*.}"`;
retFile=0;
retExt=0;
for s in $excludeList
do
if [ $file == $s ]
then
retFile=1;
fi
if [ $ext == $s ]
then
retExt=1;
fi
done
if [ $retFile != 1 -o $retExt != 1 ]
then
  if [ -d $i ] ; then
     folder $i `pwd`;
  elif [[ $i =~ \.t?gz$ ]] ; then
       tarFile $i `pwd`;
  elif [[ $i =~ \.tar$ ]]; then
       tarFile $i `pwd`;
  elif [[ $i =~ \.t?bz2$ ]]; then
       tarFile $i `pwd`;
  elif [[ $i =~ \.t?bz$ ]]; then
       bz2File $i `pwd`;
  elif [[ $i =~ \.zip$ ]]; then 
       zipFile $i `pwd`;
  elif [[ $i =~ \.war$ ]]; then
       if [ $unwar == 'true' ];then
       zipFile $i `pwd`;
       else
         retFile=0;
         retExt=0;
         for t in $includeList
         do
	 if [ $ext == $t ]
         then
         retExt=1;
         fi
         if [ $file == $t ]
         then
         retFile=1;
         fi  
         done
         if [ $retExt == 1 -o $retFile == 1 ]
         then
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
         retFile=0;
         retExt=0;
        fi
      fi      
  else
    retFile=0;
    retExt=0;
    for t in $includeList
    do
    if [ $ext == $t ]
    then
    retExt=1;
    fi
    if [ $file == $t ]
    then
    retFile=1;
    fi 
    done
    if [ $retInc == 1 -o $retFile == 1 ]
    then
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
    retFile=0;
    retExt=0;
  fi
  fi
fi
fi
done
fi
echo `sort $finalFile | cksum` >> $uniqueFile;
rm -rf $tempFolder;
IFS=$SAVEIFS;
