
mkdir c2010

cd c2010

mkdir unzipped
mkdir concatenated
mkdir keyed
mkdir combined
mkdir sorted

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
for i in $(seq -f "%05g" 1 47); do sort ./combined/ready"$i"2010.txt > ./sorted/sorted"$i"2010.csv; done;


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
# trim all leading white space - maybe not necessary?

# trim all trailing white space
cat geofile2010raw.csv | awk 'BEGIN{ FS=" *,"; OFS="," } {$1=$1; print $0}' > geofile2010.csv

# add key
awk -F "\"*,\"*" '{print $2 $7}' geofile2010.csv > geo_key.csv

# paste key
paste -d , geo_key.csv geofile2010.csv > c2010_geo_complete.csv

# sort
sort c2010_geo_complete.csv > c2010_geo_sorted.csv

# join

# add types into geography fields

# create schema files
    # prepend geography columns into all schema files

# load to csv bucket

# load to bigquery

# 6 2 3 2 3 2 7 1 1 2 3 2 2 5 2 2 5 2 2 6 1 4 2 5 2 2 4 5 2 1 3 5 2 6 1 5 2 5 2 5 3 5 2 5 3 1 1 5 2 1 1 2 3 3 6 1 3 5 5 2 5 5 5 14 14 90 1 1 9 9 11 12 2 1 6 5 8 8 8 8 8 8 8 8 8 2 2 2 3 3 3 3 3 3 2 2 2 1 1 5 18