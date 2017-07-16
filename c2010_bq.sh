
mkdir c2010

cd c2010

mkdir unzipped
mkdir concatenated
mkdir keyed
mkdir combined
mkdir sorted
mkdir joined

wget https://www2.census.gov/census_2010/04-Summary_File_1/Connecticut/ct2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Delaware/de2010.sf1.zip

unzip -qq ct2010.sf1.zip -d unzipped
unzip -qq de2010.sf1.zip -d unzipped

# combine data files
for i in $(seq -f "%05g" 1 47); do cat ./unzipped/*"$i"2010.sf1 > ./concatenated/cat"$i"2010.txt; done;

# add key
for i in $(seq -f "%05g" 1 47); do awk -F "\"*,\"*" '{print $2 $5}' ./concatenated/cat"$i"2010.txt > ./keyed/keyed"$i"2010.txt; done;

# paste key
for i in $(seq -f "%05g" 1 47); do paste -d , ./keyed/keyed"$i"2010.txt ./concatenated/cat"$i"2010.txt > ./combined/ready"$i"2010.txt; done;

# sort
for i in $(seq -f "%05g" 1 47); do sort ./combined/ready"$i"2010.txt > ./sorted/"$i"c2010.csv; done;


# combine geo files
cat ./unzipped/*geo2010.sf1 > ./concatenated/geo2010.txt

# convert to csv
# https://www.census.gov/prod/cen2010/doc/sf1.pdf
# is there a schema difference between state and national?

# turn non-delimited into comma delimited
awk -v FIELDWIDTHS='6 2 3 2 3 2 7 1 1 2 3 2 2 5 2 2 5 2 2 6 1 4 2 5 2 2 4 5 2 1 3 5 2 6 1 5 2 5 2 5 3 5 2 5 3 1 1 5 2 1 1 2 3 3 6 1 3 5 5 2 5 5 5 14 14 90 1 1 9 9 11 12 2 1 6 5 8 8 8 8 8 8 8 8 8 2 2 2 3 3 3 3 3 3 2 2 2 1 1 5 18' -v OFS=',' '
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

# remove + from lat - maybe not necessary?

# trim all leading and trailing white space
sed -i.bat -E 's/(^|,)[[:blank:]]+/\1/g; s/[[:blank:]]+(,|$)/\1/g' geofile2010raw.csv

# add key
awk -F "\"*,\"*" '{print $2 $7}' geofile2010raw.csv > geo_key.csv

# paste key
paste -d , geo_key.csv geofile2010raw.csv > c2010_geo_complete.csv

# delete columns that will be duplicated in data files
cut -d, -f2,3,6,7,8 --complement c2010_geo_complete.csv > c2010_geo_complete2.csv

# sort
sort c2010_geo_complete2.csv > c2010_geo_sorted.csv

# join
cd sorted
for file in *.csv; do echo "joining $file with geography"; join -t , -1 1 -2 1 ../c2010_geo_sorted.csv $file > ../joined/$file; done;

cd ../joined

# load to csv bucket
gsutil rb gs://c2010_stage

gsutil mb gs://c2010_stage
gsutil cp *.csv gs://c2010_stage

cd ../schemas/

# load to bigquery
bq mk c2010

unique=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1);

# load estimate files to bigQuery async
for file in *.csv; do value=`cat $file`; snum=`expr "/$file" : '.*\(.\{3\}\)\.'`; bq --nosync --job_id=$snum$unique load --ignore_unknown_values c2010.seq$snum gs://c2010_stage/$file $value; done;




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