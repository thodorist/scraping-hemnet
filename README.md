# Scraping housing data from hemnet
## [Hemnet](https://www.hemnet.se/) is the most popular marketplace for home buyers in Sweden

- Created a daily automation in bash which scrapes all residential properties that are being published for sale every day. Focus is only given to the wider Stockholm area.
- Property features (such as price, location, # of rooms, floor level, etc.) are being collected and transformed into `.csv` format.
- Notify me whenever there is a new housing project. Those type of properties usually do not require to go through a bidding process.
- The idea is to execute those scripts in sequence at a given time during the day to get all the listings that were published in the previous day.
