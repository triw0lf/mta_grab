#!/bin/bash
# A program from checking new posts to Malware Traffic Analysis and downloading artifact data from today 

IFS=$'\n'

# Assign current date to variable in format that matches MTA article format 

DATE='date "+%Y/%m/%d"'

# Store the RSS feed in a text file for parsing 

FILE='/root/mta_rss_list.txt'

# Get initial RSS listing from Malware Traffic Analysis

curl https://www.malware-traffic-analysis.net/blog-entries.rss > "$FILE"

# If today's date is found in the RSS feed, then pull out the direct article link and download all artifacts except the packet captures. Unzip all artifacts to the running folder and remove the downloaded zip file
# If no articles match today's date, then print there are no new articles and end program. 
if  grep -i "$DATE" $FILE ; then
        lines=($(grep -i "$DATE" $FILE))
        for x in ${lines[@]}; do
                URL="$(echo $x | sed -e 's/<[^>]*>//g' | awk '$1=$1')"
        done
        wget -r -l1 -H -t1 -nd -N -np -A.zip --reject-regex '(.*)pcap.zip$' -erobots=off "$URL"
        unzip -P infected "*.zip"
        rm *.zip
else
        echo "No new articles today."
fi

