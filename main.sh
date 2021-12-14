#!/bin/bash
if [[ $UID != 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

if [[ $(which curl 2>/dev/null | wc -l) == 0 ]]; then echo "Please install curl" && exit 1; fi
if [[ $(which tar 2>/dev/null | wc -l) == 0 ]]; then echo "Please install tar" && exit 1; fi

if [[ $(which grype 2>/dev/null | wc -l) == 0 ]]
then
    curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /bin
else
    echo "grype is already installed, skiping"
    echo ""
fi

if [[ $(which syft 2>/dev/null | wc -l) == 0 ]]
then
    curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /bin
else
    echo "syft is already installed, skiping"
    echo ""
fi

syft dir:/ -o json > ./wholesystem-$(date +%Y-%m-%d).json 2> /dev/null
grype sbom:./wholesystem-$(date +%Y-%m-%d).json | grep -i log4j | tee vuln_output-$(date +%Y-%m-%d).txt