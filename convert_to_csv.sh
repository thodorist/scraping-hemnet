#!/usr/bin/env bash

yesterday=$(date -d "yesterday" '+%Y-%m-%d')

username="theotheolog"

mkdir /home/$username/scraping-hemnet/datalayers/$yesterday/

## write headers to a CSV file named "data_YYYY-MM-DD.csv"
echo "property_id,broker_firm,broker_agency_id,location,municipality,postal_city,"\
"images_count,new_production,offers_selling_price,"\
"street_address,floor,rooms,living_area,price_per_m2,price,borattavgift,"\
"upcoming_open_houses,long_description,has_floorplan,"\
"publication_date,construction_year,housing_cooperative,amenities,"\
"listing_package_type,water_distance,coastline_distance" > /home/$username/scraping-hemnet/csv_files/data_$yesterday.csv

j=1

# iterate through all house listings from the last day
for i in $(cat /home/"$username"/scraping-hemnet/links/"$yesterday"_links.txt | grep 'https://www.hemnet.se/bostad')
do
    # isolate the part of the html code that is providing with the data, save it into a specific location
    curl $i | sed -n '/dataLayer =/,$p' | sed -n '/dataLayer.push/q;p' > /home/$username/scraping-hemnet/datalayers/$yesterday/datalayer_$j.txt
    file_to_read="/home/$username/scraping-hemnet/datalayers/$yesterday/datalayer_$j.txt"

    # property_id
    id=$(cat $file_to_read | grep -Po '"id":\K[^,]+')

    # broker_firm
    broker_firm=$(cat $file_to_read | grep -Po 'broker_firm":"\K[^"]+' | sed 's/,//g')

    # agency_id
    agency_id=$(cat $file_to_read | grep -Po 'broker_agency_id":\K[^,]+')

    # location
    location=$(cat $file_to_read | grep -Po 'location":"\K[^"]+')

    # municipality
    municipality=$(cat $file_to_read | grep -Po 'municipality":"\K[^"]+')

    # postal_city
    postal_city=$(cat $file_to_read | grep -Po 'postal_city":"\K[^"]+')

    # images_count
    images_count=$(cat $file_to_read | grep -Po 'images_count":\K[^,]+')


    # new_production
    new_production=$(cat $file_to_read | grep -Po 'new_production":\K[^,]+')


    # offers_selling_price
    offers_selling_price=$(cat $file_to_read | grep -Po 'offers_selling_price":\K[^,]+')

    # street_address
    street_address=$(cat $file_to_read | grep -Po 'street_address":"\K[^"]+' | cut -d',' -f1)

    # floor
    floor=$(cat $file_to_read | grep -Po 'street_address":"\K[^"]+' | cut -d',' -f2)

    # rooms
    rooms=$(cat $file_to_read | grep -Po 'rooms":\K[^,]+')

    # living_area
    living_area=$(cat $file_to_read | grep -Po 'living_area":\K[^,]+')

    # price_per_sq_m2
    price_per_sq_m2=$(cat $file_to_read | grep -Po 'price_per_m2":\K[^,]+')

    # price
    price=$(cat $file_to_read | grep -Po '"price":\K[^,]+')

    # borattavgift
    borattavgift=$(cat $file_to_read | grep -Po 'borattavgift":\K[^,]+')

    # upcoming_open_houses
    upcoming_open_houses=$(cat $file_to_read | grep -Po 'upcoming_open_houses":\K[^,]+')

    # long_description
    long_description=$(cat $file_to_read | grep -Po 'long_description":\K[^,]+')

    # has_floor_plan
    has_floor_plan=$(cat $file_to_read | grep -Po 'has_floorplan":\K[^,]+')

    # publication_date
    publication_date=$(cat $file_to_read | grep -Po 'publication_date":"\K[^"]+')


    # construction_year
    construction_year=$(cat $file_to_read | grep -Po 'construction_year":"\K[^"]+')


    # housing_cooperative
    housing_cooperative=$(cat $file_to_read | grep -Po 'housing_cooperative":"\K[^"]+' | sed 's/,//g')

    # amenities
    amenities=$(cat $file_to_read | grep -Po 'amenities":\[\K[^]]+' | sed 's/"//g' | sed 's/,/ /g')

    # listing_package_type
    listing_package_type=$(cat $file_to_read | grep -Po 'listing_package_type":"\K[^"]+')

    # water_distance
    water_distance=$(cat $file_to_read | grep -Po 'water_distance":\K[^"]+' | sed 's/[^0-9]//g')

    # coastline_distance
    coastline_distance=$(cat $file_to_read | grep -Po 'coastline_distance":\K[^"]+' | sed 's/[^0-9]//g')

    # append the data into "data_YYYY-MM-DD.csv" file
echo "$id,$broker_firm,$agency_id,$location,$municipality,$postal_city,$images_count,"\
"$new_production,$offers_selling_price,"\
"$street_address,$floor,$rooms,$living_area,$price_per_sq_m2,$price,$borattavgift,"\
"$upcoming_open_houses,$long_description,"\
"$has_floor_plan,$publication_date,$construction_year,$housing_cooperative,"\
"$amenities,$listing_package_type,$water_distance,$coastline_distance" >> /home/$username/scraping-hemnet/csv_files/data_$yesterday.csv

    j=$((j+1))

done


