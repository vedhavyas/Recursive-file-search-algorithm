Sanity test tool - used to check if the binaries in the production site match the binaries provided by the Configuration Management team

Content files :

1. startProcess.sh 
2. getFileSignature.sh
3. compareFileSignature.sh
4. config.txt
5. README.txt 

Extracting the Tool:

1. untar the sanityTestTool.tar.gz file with command "tar -zcvf sanityTestTool.tar.gz"
2. A folder sanityTestTool will be created with above mentioned files in it.

Usage of the tool :

'CD ' into the "sanityTestTool" directory.


1. config.txt - add the list of necessary extensions that are to excluded in a single line with (,) as a seperator. Most of the commonly excluded extensions are already included in it.

2. startProcess.sh - requires 3 command line arguments
   Usage: sh startProcess.sh <absolute path to build> <absolute path to a temporary directory> <outputfile name>
 
   absolute path to build - The path where the build or the patch exists.
   absolute path to a temporary directory - The path on a filesystem which holds thrice the size of the build.
   outputfile name - File to which the MD5sum bytes to be written.

3. Once the operation is done, script will generate 3 files in the "sanityTestTool" directory 
   1. host_summary.txt - contains the Host Details like Server info, Memory info 
   2. MD5sum file - name of the file will be same as the 3rd command line argument given during the start of the script. Holds filename and its MD5sum bytes
   3. processedFilePath.txt - contains File and is path to file (Relative path)

4. Follow steps 1,2,3 at the production as well as CM site.

5. After the 4th step, there will be host_summary.txt, MD5sum file, processedFilePath.txt for each site.

6. CompareFileSignature.sh - compare the MD5 files of the both sites
   Usage: sh compareFileSignature.sh <Md5file 1> <Md5file 2> <processedFilePath 1> <processedFilePath 2> 
   Md5file 1 - MD5file of site 1
   Md5file 2 - MD5file of site 2
   processedFilePath 1 - ProcessedFilePath.txt of site 1
   processedFilePath 2 - ProcessedFilePath.txt of site 2

7. If there is any mismatch of MD5sum bytes, the details will be there on comparedResults file.

