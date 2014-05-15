#!/bin/bash
#set -x;

if [ $# -lt 3 ] ; then
echo -e "Usage: $0 <absolute path to build> <absolute path to a temporary directory> <outputfile name> <unwar=true/false>\n"  ;
exit 0 ;
fi

buildSize=`du -c $1 | grep total | awk '{print $1}'`;
df -kP $2 | awk '$3 ~ /[0-9]+/ { print $4 }' >/dev/null;
if [ $? != 0 ] 
then
tempSize=`df -k $2 | awk '$3 ~ /[0-9]+/ { print $4 }'`;
else 
tempSize=`df -kP $2 | awk '$3 ~ /[0-9]+/ { print $4 }'`;
fi
buildSize=$(( buildSize * 3 ));
if [ $tempSize -ge $buildSize ]; then
if [ $# -eq 3 ] ; then
sh getFileSignature.sh $1 $2 $3 `pwd` unwar=false &
else 
sh getFileSignature.sh $1 $2 $3 `pwd` $4 &
fi
pid=`ps -ef |grep "getFileSignature.sh" | awk '{if ($8 == "sh" && $9 == "getFileSignature.sh") {print $2}}'`;
echo  -n "Please wait - capturing MD5sum ";
while [ `ps aux | awk '{print $2 }' | grep $pid 2> /dev/null` ]
do
echo -n "/\/";
sleep 3;
done
echo "\/ done";
echo "Data capturing is done";
else
echo "Not enough available space on the File system where the temporary directory exists";
fi
