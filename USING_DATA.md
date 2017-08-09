
## How do I use this data?


Click on the red 'Compose Query' button in the top left of the dataset page:

- [Census 2010 SF1 Tables](https://bigquery.cloud.google.com/dataset/censusbigquery:c2010tables)


Here are some example queries to get you started:


**Housing Units by County in Colorado:**

```
SELECT name, h0100001 FROM [censusbigquery:c2010tables.H10] 
    WHERE stusab = 'CO' and sumlev = '050';
```

**Find 10 most populous counties:**

```
SELECT name, stusab, p0010001 FROM [censusbigquery:c2010tables.P1] 
    WHERE sumlev = '050' and p0010001 > 1000000 
    ORDER BY p0010001 DESC LIMIT 10
```

**Rank States according to median age:**

```
SELECT name, p0130001 FROM [censusbigquery:c2010tables.P13] 
    WHERE sumlev = '040' and geocomp = '00' 
    ORDER BY p0130001 DESC LIMIT 10
```

**Rank Large Cities according to median age:**

```
SELECT name, stusab, p0130001 FROM [censusbigquery:c2010tables.P13] 
    WHERE sumlev = '160' and pop100 > 100000 
    ORDER BY p0130001 DESC LIMIT 10
```

As you may have noticed from the above queries, I have purposely [denormalized](https://cloud.google.com/bigquery/preparing-data-for-loading) the data for improved query performance.  In the vast majority of cases, you should not need any JOINs in your data.


You can also use BigQuery through APIs written in [many different languages](https://cloud.google.com/bigquery/create-simple-app-api).


If you need to access the data by sequence number table, you can find that here:

- [Census 2010 SF1 Sequence Number Tables (advanced)](https://bigquery.cloud.google.com/dataset/censusbigquery:c2010)