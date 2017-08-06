#!/bin/bash

#configure these variables
databucket=c2010_stage;
bigqueryschema=c2010;

dir=$(pwd)
LOG_FILE="$dir/c2010_out_logfile.txt"
ERR_FILE="$dir/c2010_err_logfile.txt"

exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${ERR_FILE} >&2)


starttime="start: `date +"%T"`"

sudo apt-get install -y unzip gawk

mkdir c2010

cd c2010

mkdir unzipped
mkdir concatenated
mkdir keyed
mkdir combined
mkdir sorted
mkdir joined


declare -A states; states[al]=Alabama; states[ak]=Alaska; states[az]=Arizona; states[ar]=Arkansas; states[ca]=California; states[co]=Colorado; states[ct]=Connecticut; states[de]=Delaware; states[dc]=District_of_Columbia; states[fl]=Florida; states[ga]=Georgia; states[hi]=Hawaii; states[id]=Idaho; states[il]=Illinois; states[in]=Indiana; states[ia]=Iowa; states[ks]=Kansas; states[ky]=Kentucky; states[la]=Louisiana; states[me]=Maine; states[md]=Maryland; states[ma]=Massachusetts; states[mi]=Michigan; states[mn]=Minnesota; states[ms]=Mississippi; states[mo]=Missouri; states[mt]=Montana; states[ne]=Nebraska; states[nv]=Nevada; states[nh]=New_Hampshire; states[nj]=New_Jersey; states[nm]=New_Mexico; states[ny]=New_York; states[nc]=North_Carolina; states[nd]=North_Dakota; states[oh]=Ohio; states[ok]=Oklahoma; states[or]=Oregon; states[pa]=Pennsylvania; states[pr]=Puerto_Rico; states[ri]=Rhode_Island; states[sc]=South_Carolina; states[sd]=South_Dakota; states[tn]=Tennessee; states[tx]=Texas; states[ut]=Utah; states[vt]=Vermont; states[va]=Virginia; states[wa]=Washington; states[wv]=West_Virginia; states[wi]=Wisconsin; states[wy]=Wyoming;

# TODO future consideration: need GEOIDs in expanded format first
# states[us]=National;


numberargs=$#
loopstates="$@"

if [ $# -eq 0 ]
then 
loopstates=${!states[@]};
fi


for var in $loopstates
do
    echo "downloading $var"
    echo "https://www2.census.gov/census_2010/04-Summary_File_1/${states[$var]}/$var/2010.sf1.zip"
    curl --progress-bar https://www2.census.gov/census_2010/04-Summary_File_1/${states[$var]}/"$var"2010.sf1.zip -O
    echo "unzipping $var"
    unzip -qq "$var"2010.sf1.zip -d unzipped
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


echo "changing encoding from latin to utf8"
iconv -f iso-8859-1 -t utf-8 ./concatenated/geo2010.txt > ./concatenated/geo2010iconv.txt

# convert to csv
# https://www.census.gov/prod/cen2010/doc/sf1.pdf

# insert quotes at position 226, 317 to prevent commas in NAME field from being interpreted as new columns
echo "formatting geography name field"
sed 's/.\{226\}/&"/' ./concatenated/geo2010iconv.txt > ./concatenated/geo1.txt
sed 's/.\{317\}/&"/' ./concatenated/geo1.txt > ./concatenated/geo2.txt



# turn non-delimited into comma delimited (accounting for quotes inserted above)
echo "converting geography file from txt to comma delimited"
LC_ALL=en_US.UTF-8 gawk -v FIELDWIDTHS='6 2 3 2 3 2 7 1 1 2 3 2 2 5 2 2 5 2 2 6 1 4 2 5 2 2 4 5 2 1 3 5 2 6 1 5 2 5 2 5 3 5 2 5 3 1 1 5 2 1 1 2 3 3 6 1 3 5 5 2 5 5 5 14 14 92 1 1 9 9 11 12 2 1 6 5 8 8 8 8 8 8 8 8 8 2 2 2 3 3 3 3 3 3 2 2 2 1 1 5 18' -v OFS=',' '
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
    ' ./concatenated/geo2.txt > geofile2010raw.csv

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

cd ..

# use nodejs to add geoid field based on specific logic
echo "adding geoid field"
node addgeoid.js

cd c2010

# sort
echo "sorting geofile"
sort c2010_geo_complete3.csv > c2010_geo_sorted.csv

# join
cd sorted
for file in *.csv; do echo "joining $file with geography"; join -t , -1 1 -2 1 ../c2010_geo_sorted.csv $file > ../joined/$file; done;

cd ../joined

# load to csv bucket
echo "removing $databucket bucket (if exists)"
gsutil rm -r gs://$databucket

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

# rm -rf c2010

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