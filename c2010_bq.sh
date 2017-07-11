
mkdir c2010

cd c2010

wget https://www2.census.gov/census_2010/04-Summary_File_1/Colorado/co2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Connecticut/ct2010.sf1.zip
wget https://www2.census.gov/census_2010/04-Summary_File_1/Delaware/de2010.sf1.zip

unzip -qq co2010.sf1.zip -d unzipped
unzip -qq ct2010.sf1.zip -d unzipped
unzip -qq de2010.sf1.zip -d unzipped