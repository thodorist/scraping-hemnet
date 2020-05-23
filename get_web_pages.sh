#!/usr/bin/env bash

# store todays date in YYYY-MM-DD format
today=$(date +%Y-%m-%d)

# create a specific directory each day to store the html code
mkdir /home/theotheolog/scraping-hemnet/htmls/"$today"_htmls/

# set the variables "i" and "scrape" so that we will only scrape new listings
i=1
scrape="true"

# find the web pages to scrape until we ran across an old listing
while [ "$scrape" = "true" ]
do
    curl "https://www.hemnet.se/bostader?by=creation&housing_form_groups%5B%5D=apartments&location_ids%5B%5D=17744&order=desc&page=$i&preferred_sorting=true" \
	 > /home/theotheolog/scraping-hemnet/htmls/"$today"_htmls/file_"$i"_to_scrape.txt
    
    if grep -Fq ">Igår" /home/theotheolog/scraping-hemnet/htmls/"$today"_htmls/file_"$i"_to_scrape.txt
	# if we ran across a listing from previous day, we should exit the loop
	then
	    # isolate all the individual web links of each and every listing
	    cat /home/theotheolog/scraping-hemnet/htmls/"$today"_htmls/file_"$i"_to_scrape.txt | sed -n '/>Igår/q;p' | grep 'href=\"https://www.hemnet.se/bostad/' \
	     | sed 's/href=//g' | sed 's/"//g'| sed 's/ //g' >> /home/theotheolog/scraping-hemnet/links/"$today"_links.txt
	    
	    scrape="false"
	    echo "I should stop on page $i"
	# if we don't find an old listing, we keep iterating
	else
	    # isolate all the individual web links of each and every listing
	    cat /home/theotheolog/scraping-hemnet/htmls/"$today"_htmls/file_"$i"_to_scrape.txt | grep 'href=\"https://www.hemnet.se/bostad/' | \
	     sed 's/href=//g' | sed 's/"//g'| sed 's/ //g' >> /home/theotheolog/scraping-hemnet/links/"$today"_links.txt
	    
	    echo "I scraped page $i"
	    echo "I should scrape the next page, $((i+1))"
	    i=$(( i+1 ))
    fi

done

