#!/usr/bin/env bash

# store yesterday and the day before yesterday in YYYY-MM-DD format
yesterday=$(date -d "yesterday" '+%Y-%m-%d')
two_days_ago=$(date -d "2 days ago" '+%Y-%m-%d')

username="theotheolog"

# create a specific directory each day to store the html code
mkdir /home/"$username"/scraping-hemnet/htmls/"$yesterday"_htmls/

# variable 'i' keeps track of which pages we are scraping
i=1
# variable 'scrape' is true until we find a listing 2 days old
scrape="true"

# find the web pages to scrape until we ran across an old listing
while [ "$scrape" = "true" ]
do
    curl "https://www.hemnet.se/bostader?by=creation&housing_form_groups%5B%5D=apartments&location_ids%5B%5D=17744&order=desc&page=$i&preferred_sorting=true" \
	> /home/"$username"/scraping-hemnet/htmls/"$yesterday"_htmls/file_"$i"_to_scrape.txt
    # find the starting point of listings of the previous day
    if grep -Fq "<span datetime=\"$yesterday" /home/"$username"/scraping-hemnet/htmls/"$yesterday"_htmls/file_"$i"_to_scrape.txt
	then
	# if we find a house that is 2 days old, we stop iterating
	if grep -Fq "<span datetime=\"$two_days_ago" /home/"$username"/scraping-hemnet/htmls/"$yesterday"_htmls/file_"$i"_to_scrape.txt
	    then
		# isolate all the individual web links of each and every listing,
		# start from yesterdays listings up until (and not including) listings that are 2 days old
		cat /home/"$username"/scraping-hemnet/htmls/"$yesterday"_htmls/file_"$i"_to_scrape.txt | \
		sed -n '/<span datetime=\"'$yesterday'/,$p' | sed -n '/<span datetime=\"'$two_days_ago'/q;p' | \
		egrep 'href=\"https://www.hemnet.se/bostad/|href=\"https://www.hemnet.se/nybyggnadsprojekt/' | \
		sed 's/href=//g' | sed 's/"//g' | sed 's/ //g' >> /home/"$username"/scraping-hemnet/links/"$yesterday"_links.txt
		
		scrape="false"
		echo "I scraped page $i"
		echo "I should stop on page $i"
	# if we didn't find any listing 2 days old, we keep iterating
	else
	    # isolate all the individual web links of each and every listing,
	    # start(or continue) from those listings that were posted on the previous day
	    cat /home/"$username"/scraping-hemnet/htmls/"$yesterday"_htmls/file_"$i"_to_scrape.txt | sed -n '/<span datetime=\"'$yesterday'/,$p' | \
	    egrep 'href=\"https://www.hemnet.se/bostad/|href=\"https://www.hemnet.se/nybyggnadsprojekt/' | \
	    sed 's/href=//g' | sed 's/"//g'| sed 's/ //g' >> /home/"$username"/scraping-hemnet/links/"$yesterday"_links.txt
	
	    echo "I scraped page $i"
	    echo "I should scrape the next page, $((i+1))"
	fi

    fi
    i=$((i+1))

done


