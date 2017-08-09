
## How do I use this data?

Google has a [GUI](https://bigquery.cloud.google.com/queries/) if you have any one-off or exploratory queries you'd like to run.

- [Census 2010 SF1 Tables](https://bigquery.cloud.google.com/dataset/censusbigquery:c2010tables)
- [Census 2010 SF1 Sequence Number Tables (advanced)](https://bigquery.cloud.google.com/dataset/censusbigquery:c2010)


Here are some example queries to get you started (using the c2010tables schema).


*Housing Units by County in Colorado*

```
SELECT name, h0100001 FROM [censusbigquery:c2010tables.H10] WHERE stusab = 'CO' and sumlev = '050';
```

*Find 10 most populous counties:*

```
SELECT name, stusab, p0010001 FROM [censusbigquery:c2010tables.P1] WHERE sumlev = '050' and p0010001 > 1000000 order by p0010001 desc limit 10
```

*Rank States according to median age*

```
select name, p0130001 FROM [censusbigquery:c2010tables.P13] where sumlev = '040' and geocomp = '00' order by p0130001 desc limit 10
```

*Rank Large Cities according to median age*

```
select name, stusab, p0130001 FROM [censusbigquery:c2010tables.P13] where sumlev = '160' and pop100 > 100000 order by p0130001 desc limit 10
```

As you may have noticed from the above queries, I have purposely [denormalized](https://cloud.google.com/bigquery/preparing-data-for-loading) the data for improved query performance.  In the vast majority of cases, you should not need any JOINs in your data.


You can also use BigQuery through APIs written in [many different languages](https://cloud.google.com/bigquery/create-simple-app-api).