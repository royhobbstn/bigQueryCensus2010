
mkdir c2010

cd c2010

mkdir unzipped
mkdir concatenated

wget https://www2.census.gov/census_2010/04-Summary_File_1/Colorado/co2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Connecticut/ct2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Delaware/de2010.sf1.zip

unzip -qq co2010.sf1.zip -d unzipped
unzip -qq ct2010.sf1.zip -d unzipped
unzip -qq de2010.sf1.zip -d unzipped

# combine data files
for i in $(seq -f "%05g" 1 47); do cat ./unzipped/*"$i"2010.sf1 > ./concatenated/cat"$i"2010.txt; done;

# add key

# sort

# combine geo files
cat ./unzipped/*geo2010.sf1 > ./concatenated/geo2010.txt

# convert to csv
# https://www.census.gov/prod/cen2010/doc/sf1.pdf
# is there a schema difference between state and national

$ cat gd.dat
E116005/29/19930E001E000
E122001/23/19940E001E003
E104006/04/19940E001E003
$ cat gd.sh
awk -v FIELDWIDTHS='4 1 10 1 4 4' -v OFS=',' '
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
    ' gd.dat
$ gd.sh
E116,0,05/29/1993,0,E001,E000
E122,0,01/23/1994,0,E001,E003
E104,0,06/04/1994,0,E001,E003
$

# add key

# sort

# join


# create schema files
    # prepend geography columns into all schema files

# load to csv bucket

# load to bigquery
