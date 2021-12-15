#!/bin/bash
if [[ $UID != 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi


if [[ $(which grype 2>/dev/null | wc -l) != 0 ]]
then
    echo "found grype, removing"
    rm -f $(which grype 2>/dev/null) 2>/dev/null
    rm -f /bin/grype 2>/dev/null
    echo "found grype, removing: DONE"
    echo ""
else
    echo "grype is not installed on this system"
fi


if [[ -d ~/.cache/grype/db/3/ ]]
then
    echo "found grype cached DB, removing"
    rm -rf ~/.cache/grype/db/3/
    echo "found grype cached DB, removing: DONE"
    echo ""
fi


if [[ $(which syft 2>/dev/null | wc -l) != 0 ]]
then
    echo "found syft, removing"
    rm -f $(which syft 2>/dev/null) 2>/dev/null
    rm -f /bin/syft 2>/dev/null
    echo "found syft, removing: DONE"
    echo ""
else
    echo "syft is not installed on this system"
fi


if [[ $(which grype 2>/dev/null | wc -l) != 0 ]] || [[ $(which syft 2>/dev/null | wc -l) != 0 ]] || [[ -d ~/.cache/grype/db/3/ ]]
then
    echo "We are done cleaning up."
else
    echo "Something went wrong."
fi