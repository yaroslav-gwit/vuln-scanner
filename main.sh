#!/bin/bash
if [[ $UID != 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi


#_ CHECK DEPENDENCIES _#
if [[ $(which curl 2>/dev/null | wc -l) == 0 ]]; then echo "Please install curl" && exit 1; fi
if [[ $(which tar 2>/dev/null | wc -l) == 0 ]]; then echo "Please install tar" && exit 1; fi


#_ INSTALL SYFT AND GRYPE _#
if [[ $(which grype 2>/dev/null | wc -l) == 0 ]]
then
    curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /bin
else
    echo "grype is already installed, skipping"
    echo ""
fi

if [[ $(which syft 2>/dev/null | wc -l) == 0 ]]
then
    curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /bin
else
    echo "syft is already installed, skipping"
    echo ""
fi


#_ RENAME SYFT INDEXING RESULT FILES TO OLD, SO THAT THE VULNERABILITY REPORT WILL BE UP TO DATE _#
for JSON_RESULT in $(ls *_packagescan_*)
do
    mv ${JSON_RESULT} ${JSON_RESULT}.OLD
done


#_ START SYFT INDEXING EXCLUDING SOME FOLDERS _#
DIRS_TO_SCAN=$(ls -l / | grep '^d' | grep -vi 'lost+found\|mnt\|boot\|dev\|media' | awk '{ print $NF }')
for DIR in $DIRS_TO_SCAN
do
    SYFT_FILE_NAME=${DIR}_packagescan_$(date +%Y-%m-%d).json
    syft -q dir:/${DIR} -o json > ./${SYFT_FILE_NAME}
done


#_ CHECK INDEXED LIBRARIES FOR VULNERABILITIES _#
RESULTS_FILENAME=$(hostname)_vuln_output-$(date +%Y-%m-%d).txt
echo "Host: $(hostname)" > ${RESULTS_FILENAME}
echo "" >> ${RESULTS_FILENAME}
echo "List of vulnerabilities found:" >> ${RESULTS_FILENAME}

JSONS_TO_SCAN=$(ls *_packagescan_* | grep -v ".OLD")
for JSON in $JSONS_TO_SCAN
do
    echo ""
    echo "File scanned: ${JSON}">> ${RESULTS_FILENAME}
    grype -q sbom:./${JSON} | grep -i log4j | tee -a ${RESULTS_FILENAME}
done

echo "" >> ${RESULTS_FILENAME}
echo ""


#_ FINAL MESSAGE BEFORE EXIT _#
echo "All done! Checkout the ${RESULTS_FILENAME} file, and save it as a report"
echo ""