#!/bin/bash

#configure these variables
currentbigqueryschema=c2010;
bigquerytableschema=c2010tables;


rm -rf c2010tables

mkdir c2010tables

cd c2010tables

mkdir schemas

mkdir sql


sed 1d ../DATA_FIELD_DESCRIPTORS.csv > no_header.csv

awk -F, '$6 ~ /^[0-9]+$/' no_header.csv > columns_list.csv

cut -d, -f4 --complement columns_list.csv > nodesc.csv

sed 's/\"//g' nodesc.csv > noquotes.csv

echo "creating individual table shells"
while IFS=',' read f1 f2 f3 f4 f5 f6; do echo -n ",$f4" >> "./schemas/$f3.txt"; done < noquotes.csv;

while IFS=',' read f1 f2 f3 f4 f5 f6; do echo -n " FROM $currentbigqueryschema.seq000"`printf $f2`"c2010;\"" > "./schemas/$f3.sch"; done < noquotes.csv;


cd schemas

for file in *.txt; do cat $file ${file:0:-4}.sch > ../sql/${file:0:-4}.red; done

cd ../sql

unique=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1);

for file in *.red; do sed -i "1s;^;bq query --batch --nosync --job_id=${file:0:-4}_$unique --allow_large_results --destination_table=$bigquerytableschema.${file:0:-4} \"SELECT KEY,SUMLEV,GEOCOMP,REGION,DIVISION,STATE,COUNTY,COUNTYCC,COUNTYSC,COUSUB,COUSUBCC,COUSUBSC,PLACE,PLACECC,PLACESC,TRACT,BLKGRP,BLOCK,IUC,CONCIT,CONCITCC,CONCITSC,AIANHH,AIANHHFP,AIANHHCC,AIHHTLI,AITSCE,AITS,AITSCC,TTRACT,TBLKGRP,ANRC,ANRCCC,CBSA,CBSASC,METDIV,CSA,NECTA,NECTASC,NECTADIV,CNECTA,CBSAPCI,NECTAPCI,UA,UASC,UATYPE,UR,CD,SLDU,SLDL,VTD,VTDI,RESERVE2,ZCTA5,SUBMCD,SUBMCDCC,SDELM,SDSEC,SDUNI,AREALAND,AREAWATR,NAME,FUNCSTAT,GCUNI,POP100,HU100,INTPTLAT,INTPTLON,LSADC,PARTFLAG,RESERVE3,UGA,STATENS,COUNTYNS,COUSUBNS,PLACENS,CONCITNS,AIANHHNS,AITSNS,ANRCNS,SUBMCDNS,CD113,CD114,CD115,SLDU2,SLDU3,SLDU4,SLDL2,SLDL3,SLDL4,AIANHHSC,CSASC,CNECTASC,MEMI,NMEMI,PUMA,RESERVED,GEO_ID,FILEID,STUSAB,CHARITER,CIFSN,LOGRECNO;" $file; done;

echo "executing sql"

bq mk $bigquerytableschema

for file in *.red; do bash $file; done;


echo "all done here. queries may still be processing on bigQuery."
