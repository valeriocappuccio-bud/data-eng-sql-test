# Data Engineer Tech Interview
This repo is to:
* make it simple to setup the environment to answer the technical questions
* provide example solutions to the questions

## Setup
This will spin up a postgres container and an sqlpad to make sql queries on it.
```bash
docker-compose up -d
```
1. Open your browser on http://localhost:3000 to connect connect to sqlpad and login with ``admin`` as both username and password
2. Create a connection to postgres (call it any name) using Host/Server/IP Address = ``postgres``, Database = ``bud``, Database Username = ``admin`` and Database = ``admin``.

## Cleanup
```bash
docker-compose down --remove-orphans -v
```

## Questions
### Design tables
Design a database schema that handles the following data.
* Merchants: this is a table of companies that you might buy goods from either online or in person
* Transactions: this is a list of credit card transactions for people from the past year

### Query data
* How much has been spent each day for merchant {x}?
* How much does each merchant bring in per day?
* How many merchants have a spend of over £100 for each day in the last year?
* What are the top 5 industries that people spend the most money in?
* What indexes would you think about adding to these tables?
* Rank each person and return them sorted (with a column for rank) by those who spent the most for merchant {x}?
* Rank each merchant by person and return them sorted (with a column for rank) by those who spent the most for all merchants.
