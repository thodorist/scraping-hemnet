#!/usr/bin/env bash

yesterday=$(date -d "yesterday" '+%Y-%m-%d')


file_location="/home/theotheolog/scraping-hemnet/links/"$yesterday"_links.txt"
#file_location="/home/theotheolog/scraping-hemnet/temp_file.txt"

if grep -q 'https://www.hemnet.se/nyb' $file_location
then
    echo 'yes'
    cat $file_location | grep 'https://www.hemnet.se/nybyggnadsprojekt/' > /home/theotheolog/scraping-hemnet/new_house_projects/$yesterday.txt
    mutt -s"New housing projects" theologitis.t@gmail.com < /home/theotheolog/scraping-hemnet/new_house_projects/$yesterday.txt
else
    echo 'no'
fi