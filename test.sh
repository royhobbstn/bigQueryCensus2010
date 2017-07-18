#!/bin/bash

# numberargs=$#
loopstates="$@"

#if [ $# -eq 0 ]
#then 
#loopstates=${!states[@]};
#fi
echo $loopstates;

for var in $loopstates
do

if [ "$var"  == "al" ]
then curl --progress-bar https://www2.census.gov/census_2010/04-Summary_File_1/Alabama/al2010.sf1.zip -O;
fi
if [ "$var" == "ak" ]
then curl --progress-bar https://www2.census.gov/census_2010/04-Summary_File_1/Alaska/ak2010.sf1.zip -O;
fi
if [ "$var" == "az" ]
then curl --progress-bar https://www2.census.gov/census_2010/04-Summary_File_1/Arizona/az2010.sf1.zip -O;
fi

done;