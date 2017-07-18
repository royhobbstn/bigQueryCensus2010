#!/bin/bash

#configure these variables
databucket=c2010_stage;
bigqueryschema=c2010;

dir=$(pwd)
LOG_FILE="$dir/c2010_logfile.txt"
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)


starttime="start: `date +"%T"`"


sudo apt-get install unzip

mkdir c2010

cd c2010

mkdir unzipped
mkdir concatenated
mkdir keyed
mkdir combined
mkdir sorted
mkdir joined


# numberargs=$#
loopstates="$@"

#if [ $# -eq 0 ]
#then 
#loopstates=${!states[@]};
#fi

for var in $loopstates
do
if [$var -eq 'al']; then wget https://www2.census.gov/census_2010/04-Summary_File_1/Alabama/al2010.sf1.zip; fi;
if [$var -eq 'ak']; then wget https://www2.census.gov/census_2010/04-Summary_File_1/Alaska/ak2010.sf1.zip; fi;
if [$var -eq 'az']; then wget https://www2.census.gov/census_2010/04-Summary_File_1/Arizona/az2010.sf1.zip; fi;
wget https://www2.census.gov/census_2010/04-Summary_File_1/Arkansas/ar2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/California/ca2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Colorado/co2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Connecticut/ct2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Delaware/de2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/District_of_Columbia/dc2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Florida/fl2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Georgia/ga2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Hawaii/hi2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Idaho/id2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Illinois/il2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Indiana/in2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Iowa/ia2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Kansas/ks2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Kentucky/ky2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Louisiana/la2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Maine/me2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Maryland/md2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Massachusetts/ma2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Michigan/mi2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Minnesota/mn2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Mississippi/ms2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Missouri/mo2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Montana/mt2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/National/us2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Nebraska/ne2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Nevada/nv2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/New_Hampshire/nh2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/New_Jersey/nj2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/New_Mexico/nm2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/New_York/ny2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/North_Carolina/nc2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/North_Dakota/nd2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Ohio/oh2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Oklahoma/ok2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Oregon/or2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Pennsylvania/pa2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Puerto_Rico/pr2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Rhode_Island/ri2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/South_Carolina/sc2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/South_Dakota/sd2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Tennessee/tn2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Texas/tx2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Utah/ut2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Vermont/vt2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Virginia/va2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Washington/wa2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/West_Virginia/wv2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Wisconsin/wi2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Wyoming/wy2010.sf1.zip

unzip -qq al2010.sf1.zip -d unzipped
unzip -qq ak2010.sf1.zip -d unzipped
unzip -qq az2010.sf1.zip -d unzipped
unzip -qq ar2010.sf1.zip -d unzipped
unzip -qq ca2010.sf1.zip -d unzipped
unzip -qq co2010.sf1.zip -d unzipped
unzip -qq ct2010.sf1.zip -d unzipped
unzip -qq de2010.sf1.zip -d unzipped
unzip -qq dc2010.sf1.zip -d unzipped
unzip -qq fl2010.sf1.zip -d unzipped
unzip -qq ga2010.sf1.zip -d unzipped
unzip -qq hi2010.sf1.zip -d unzipped
unzip -qq id2010.sf1.zip -d unzipped
unzip -qq il2010.sf1.zip -d unzipped
unzip -qq in2010.sf1.zip -d unzipped
unzip -qq ia2010.sf1.zip -d unzipped
unzip -qq ks2010.sf1.zip -d unzipped
unzip -qq ky2010.sf1.zip -d unzipped
unzip -qq la2010.sf1.zip -d unzipped
unzip -qq me2010.sf1.zip -d unzipped
unzip -qq md2010.sf1.zip -d unzipped
unzip -qq ma2010.sf1.zip -d unzipped
unzip -qq mi2010.sf1.zip -d unzipped
unzip -qq mn2010.sf1.zip -d unzipped
unzip -qq ms2010.sf1.zip -d unzipped
unzip -qq mo2010.sf1.zip -d unzipped
unzip -qq mt2010.sf1.zip -d unzipped
unzip -qq us2010.sf1.zip -d unzipped
unzip -qq ne2010.sf1.zip -d unzipped
unzip -qq nv2010.sf1.zip -d unzipped
unzip -qq nh2010.sf1.zip -d unzipped
unzip -qq nj2010.sf1.zip -d unzipped
unzip -qq nm2010.sf1.zip -d unzipped
unzip -qq ny2010.sf1.zip -d unzipped
unzip -qq nc2010.sf1.zip -d unzipped
unzip -qq nd2010.sf1.zip -d unzipped
unzip -qq oh2010.sf1.zip -d unzipped
unzip -qq ok2010.sf1.zip -d unzipped
unzip -qq or2010.sf1.zip -d unzipped
unzip -qq pa2010.sf1.zip -d unzipped
unzip -qq pr2010.sf1.zip -d unzipped
unzip -qq ri2010.sf1.zip -d unzipped
unzip -qq sc2010.sf1.zip -d unzipped
unzip -qq sd2010.sf1.zip -d unzipped
unzip -qq tn2010.sf1.zip -d unzipped
unzip -qq tx2010.sf1.zip -d unzipped
unzip -qq ut2010.sf1.zip -d unzipped
unzip -qq vt2010.sf1.zip -d unzipped
unzip -qq va2010.sf1.zip -d unzipped
unzip -qq wa2010.sf1.zip -d unzipped
unzip -qq wv2010.sf1.zip -d unzipped
unzip -qq wi2010.sf1.zip -d unzipped
unzip -qq wy2010.sf1.zip -d unzipped
done

# combine data files
for i in $(seq -f "%05g" 1 47); do echo "combining seq $i"; cat ./unzipped/*"$i"2010.sf1 > ./concatenated/cat"$i"2010.txt; done;

# add key
for i in $(seq -f "%05g" 1 47); do echo "adding key $i"; awk -F "\"*,\"*" '{print $2 $5}' ./concatenated/cat"$i"2010.txt > ./keyed/keyed"$i"2010.txt; done;

# paste key
for i in $(seq -f "%05g" 1 47); do echo "pasting key $i"; paste -d , ./keyed/keyed"$i"2010.txt ./concatenated/cat"$i"2010.txt > ./combined/ready"$i"2010.txt; done;

# sort
for i in $(seq -f "%05g" 1 47); do echo "sorting seq $i"; sort ./combined/ready"$i"2010.txt > ./sorted/"$i"c2010.csv; done;


# combine geo files
echo "combining all geo files"
cat ./unzipped/*geo2010.sf1 > ./concatenated/geo2010.txt

# convert to csv
# https://www.census.gov/prod/cen2010/doc/sf1.pdf

# insert quotes at position 226, 317 to prevent commas in NAME field from being interpreted as new columns
echo "formatting geography name field"
sed -i.aaa 's/.\{226\}/&"/' ./concatenated/geo2010.txt
sed -i.aab 's/.\{317\}/&"/' ./concatenated/geo2010.txt


# turn non-delimited into comma delimited (accounting for quotes inserted above)
echo "converting geography file from txt to comma delimited"
awk -v FIELDWIDTHS='6 2 3 2 3 2 7 1 1 2 3 2 2 5 2 2 5 2 2 6 1 4 2 5 2 2 4 5 2 1 3 5 2 6 1 5 2 5 2 5 3 5 2 5 3 1 1 5 2 1 1 2 3 3 6 1 3 5 5 2 5 5 5 14 14 92 1 1 9 9 11 12 2 1 6 5 8 8 8 8 8 8 8 8 8 2 2 2 3 3 3 3 3 3 2 2 2 1 1 5 18' -v OFS=',' '
   BEGIN {
      WidthsCount = split(FIELDWIDTHS, Widths);
   }
   {
      fixe = $0;
      pos  = 1;
      for (i=1; i<=WidthsCount; i++) {
         len = Widths[i];
         $i = substr(fixe, pos, len);
         pos += len;
      }
      print;
   }
    ' ./concatenated/geo2010.txt > geofile2010raw.csv

echo "installing nodejs"
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install node

npm install

cd ..
# trim whitespace from NAME
echo "trimming whitespace from geography NAME field"
node parsegeo.js

cd c2010

# trim all leading and trailing white space
echo "trimming trailing and leading whitespace from all other geography fields"
sed -i.bat -E 's/(^|,)[[:blank:]]+/\1/g; s/[[:blank:]]+(,|$)/\1/g' geofile2010raw2.csv

# add key
echo "creating geography unique key"
awk -F "\"*,\"*" '{print $2 $7}' geofile2010raw2.csv > geo_key.csv

# paste key
echo "pasting geography unique key"
paste -d , geo_key.csv geofile2010raw2.csv > c2010_geo_complete.csv

# delete columns that will be duplicated in data files
echo "deleting duplicate columns"
cut -d, -f2,3,6,7,8 --complement c2010_geo_complete.csv > c2010_geo_complete2.csv

# sort
echo "sorting geofile"
sort c2010_geo_complete2.csv > c2010_geo_sorted.csv

# join
cd sorted
for file in *.csv; do echo "joining $file with geography"; join -t , -1 1 -2 1 ../c2010_geo_sorted.csv $file > ../joined/$file; done;

cd ../joined

# load to csv bucket
echo "removing $databucket bucket (if exists)"
gsutil rb gs://$databucket

echo "creating $databucket bucket"
gsutil mb gs://$databucket

echo "copying finished files"
gsutil cp *.csv gs://$databucket

cd ../../schemas/

# load to bigquery
echo "creating c2010 bigQuery schema"
bq mk $bigqueryschema

unique=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1);

# load estimate files to bigQuery async
echo "creating bigQuery upload jobs to $bigqueryschema schema"
for file in *.csv; do value=`cat $file`; snum=`expr "/$file" : '.*\(.\{10\}\)\.'`; bq --nosync --job_id=$snum$unique load $bigqueryschema.seq$snum gs://$databucket/$file $value; done;


#cleanup
echo "cleaning up temp files on hard drive"
cd ..

rm -rf c2010

echo "all done."


echo $starttime
echo "end: `date +"%T"`"

# MISC Process Notes

# prepare schema files by converting access db to csv.
# then use: 
# for file in cut*.csv; do cut -d, -f1-5 --complement $file > cut$file; done;
# to remove first 5 columns
# then append the :float type to all fields
# sed -i -e 's/,/:float,/g' filename (all fields except last, which was done manually)
# combine seq 45 PT1 and PT2, delete PT2 file
# geography columns then appended into each schema file using:
# for file in *.csv; do cat ../table_shells/geoStateschema.txt $file > ../schemas/$file; done;
# remove unnecessary mod and PT1 suffix
# saved permanently to repo so this transformation only happens once