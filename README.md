# bigQueryCensus2010
Automate loading of Census 2010 data into Google BigQuery


## Prerequisites:

I VERY highly recommend running this from a Google Compute Instance for performance and simplicity.

Make sure to check the box that says:
*ALLOW FULL ACCESS TO ALL CLOUD APIs*

If you plan on loading the entire 2010 Census, allocate an Instance with **325GB**.  

If you insist on running this elsewhere, you will need to have the **gsutil** and **bq** tools pre-installed.  You can get them by installing the [Google Cloud SDK](https://cloud.google.com/sdk/downloads) on the machine you wish to run the bigQueryACS script from.
I haven't tested on anything other than Google Compute Engine Debian and Ubuntu 16.04, so your mileage may vary on other OS's.

Other than that, you will need to make sure you have unzip and git installed (the Google Compute instances I've tested with did not have it.)

```sudo apt-get install unzip git```


## Installation:

Clone this repo:

```
git clone https://github.com/royhobbstn/bigQueryCensus2010.git
cd bigQueryCensus2010
```


## Using the Script

Like this for Colorado:
```
bash c2010_bq.sh co
```

More than one State?
```
bash c2010_bq.sh de co hi
```

All the States?  That's the default (will take a very long time, see below)
```
bash c2010_bq.sh
```

**Warning:** To avoid the unfortunate situation of the script dying when the terminal unexpectedly disconnects (trust me, it will!), I would advise running larger jobs through [screen](https://kb.iu.edu/d/acuy).
```
screen
bash c2010_bq.sh
```

Then press Ctrl-a, followed by 'd' (without the quotes) to go about your normal business.

When you want to check back in, type:
```
screen -r
```

When finished, exit a screen like you would with a normal session:
```
exit
```



## Customization

By default, this script will load the data files into a bucket called ```c2010_stage```.  It will create a BigQuery schema named ```acs1115```.
To change these defaults, edit the environmental variables at the top of the code block:

```sudo vi c2010_bq.sh```

You'll see something like:

```
#configure these variables
databucket=c2010_stage;
bigqueryschema=c2010;
```

These correspond to the Google Storage Bucket and Google Big Query Schemas you would like to use.  Give them unique names that make sense to you (if unfamiliar with VIM, press the 'i' key to start editing).  

Then [exit VIM](https://stackoverflow.blog/2017/05/23/stack-overflow-helping-one-million-developers-exit-vim/).



## Benchmarks

As with the ACS script, a bigger instance doesn't necessarily lead to faster loads. Network speed is the main contributor to performance.


## How do I use this data?

Google has a [GUI](https://bigquery.cloud.google.com/queries/) if you have any one-off or exploratory queries you'd like to run.

Here's an example query for finding the Median Household Income for all counties in Colorado.

```
TODO Query
```

As you may have noticed from the above query, I have purposely [denormalized](https://cloud.google.com/bigquery/preparing-data-for-loading) the data for improved query performance.  In the vast majority of cases, you should not need any JOINs in your data.


You can also use BigQuery through APIs written in [many different languages](https://cloud.google.com/bigquery/create-simple-app-api).


## Sequence Number Tables?

Yeah, I know.  It's a pain to have to look up not only the field that corresponds to the statistic that you're looking for, but also the sequence table.  [Here's a document that can help.](https://www2.census.gov/programs-surveys/acs/summary_file/2015/documentation/user_tools/ACS_5yr_Seq_Table_Number_Lookup.xls) 
If you don't want to go through the pain of looking up sequence numbers, good news!  I have another script for that.  It turns all of those sequence tables into logical census tables.

You can run the query as a bash script:

```
TODO bash createSQL.sh
```

If you used a non-default bigQuery schema name, you'll need to edit the configuration variables at the top of the file:

```sudo vi createSQL.sh```

You'll see something like:

```
#configure these variables
currentbigqueryschema=c2010;
bigquerytableschema=c2010tables;
```

```currentbigqueryschema``` is where your bigQuery sequence tables are currently located.

```bigquerytableschema``` is a new schema where you want the table files to end up.


### This will not be quick either

TODO Benchmark

### Using Table Data

When all is said and done, your new [GUI](https://bigquery.cloud.google.com/queries/) query will look like this:


```
TODO
```

