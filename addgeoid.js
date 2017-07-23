var csv = require('csv');
var fs = require('fs');

// reference: https://www.census.gov/rdo/pdf/0GEOID_Construction_for_Matching.pdf

var stream = fs.createWriteStream('./c2010/c2010_geo_complete3.csv');

fs.createReadStream('./c2010/c2010_geo_complete2.csv').pipe(
    csv.parse()).pipe(
    csv.transform(function(record) {
        record[65] = record[65].trim();
        
        if(record[1] === '230') {
            record.push(record[5] + record[31]);
        } else if(record[1] === '281') {
            record.push(record[5] + record[22] + record[26]);
        } else if(record[1] === '060') {
            record.push(record[5] + record[6] + record[9]);
        } else if(record[1] === '067') {
            record.push(record[5] + record[6] + record[9] + record[54]);
        } else if(record[1] === '170') {
            record.push(record[5] + record[19]);
        } else if(record[1] === '160') {
            record.push(record[5] + record[12]);
        } else if(record[1] === '140') {
            record.push(record[5] + record[6] + record[15]);
        } else if(record[1] === '150') {
            record.push(record[5] + record[6] + record[15] + record[16]);
        } else if(record[1] === '750') {
            record.push(record[5] + record[6] + record[15] + record[17]);
        } else if(record[1] === '500') {
            record.push(record[5] + record[47]);
        } else if(record[1] === '610') {
            record.push(record[5] + record[48]);
        } else if(record[1] === '620') {
            record.push(record[5] + record[49]);
        } else if(record[1] === '950') {
            record.push(record[5] + record[56]);
        } else if(record[1] === '960') {
            record.push(record[5] + record[57]);
        } else if(record[1] === '970') {
            record.push(record[5] + record[58]);
        } else {
            record.push('');
        }
        
        // TODO as needed: 280, 700 (see link, special notes)
        
        return record;
    })).pipe(
    csv.stringify()).pipe(stream);

stream.on('error', function(error) {
    console.log('ERROR');
    console.log(error);
});

stream.on('finish', function() {
    console.log('file has been written');
});


/*
EXAMPLE RECORD PRE-TRANSFORMATION

[ 0 'DE0003851',    KEY (my created field)
  1 '080',          SUMLEV
  2 '00',           GEOCOMP
  3 '3',            REGION
  4 '5',            DIVISION
  5 '10',           STATE
  6 '001',          COUNTY
  7 'H1',           COUNTYCC
  8 '18',           COUNTYSC
  9 '92220',        COUSUB
 10 'Z5',           COUSUBCC
 11 '14',           COUSUBSC
 12 '28440',        PLACE
 13 'C1',           PLACECC
 14 '08',           PLACESC
 15 '043202',       TRACT
 16 '',             BLKGRP
 17 '',             BLOCK
 18 '',             IUC
 19 '',             CONCIT
 20 '',             CONCITCC
 21 '',             CONCITSC
 22 '',             AIANHH
 23 '',             AIANHHFP
 24 '',             AIANHHCC
 25 '',             AIHHTLI
 26 '',             AITSCE
 27 '',             AITS
 28 '',             AITSCC
 29 '',             TTRACT
 30 '',             TBLKGRP
 31 '',             ANRC
 32 '',             ANRCCC
 33 '20100',        CBSA
 34 '18',           CBSASC
 35 '99999',        METDIV
 36 '999',          CSA
 37 '99999',        NECTA
 38 '00',           NECTASC
 39 '99999',        NECTADIV
 40 '999',          CNECTA
 41 'N',            CBSAPCI
 42 'N',            NECTAPCI
 43 '',             UA
 44 '',             UASC
 45 '',             UATYPE
 46 '',             UR
 47 '',             CD
 48 '',             SLDU
 49 '',             SLDL
 50 '',             VTD
 51 '',             VTDI
 52 '',             RESERVE2
 53 '',             ZCTA5
 54 '',             SUBMCD
 55 '',             SUBMCDCC
 56 '',             SDELM
 57 '',             SDSEC
 58 '',             SDUNI
 59 '1640088',                      AREALAND
 60 '0',                            AREAWATR
 61 'Census Tract 432.02 (part)',   NAME
 62 'S',                            FUNCSTAT
 63 '',                             GCUNI
 64 '7',                            POP100
 65 '3',                            HU100
 66 '+39.0007942',                  INTPTLAT
 67 '-075.4555020',                 INTPTLON
 68 'CT',                           LSADC
 69 'P',                            PARTFLAG
 70 '',             RESERVE3
 71 '',             UGA
 72 '01779781',     STATENS
 73 '00217271',     COUNTYNS
 74 '01935616',     COUSUBNS
 75 '02390191',     PLACENS
 76 '',             CONCITNS
 77 '',             AIANHHNS
 78 '',             AITSNS
 79 '',             ANRCNS
 80 '',             SUBMCDNS
 81 '',             CD113
 82 '',             CD114
 83 '',             CD115
 84 '',             SLDU2
 85 '',             SLDU3
 86 '',             SLDU4
 87 '',             SLDL2
 88 '',             SLDL3
 89 '',             SLDL4
 90 '',             AIANHHSC
 91 '00',           CSASC
 92 '00',           CNECTASC
 93 '1',            MEMI
 94 '9',            NMEMI
 95 '',             PUMA
 96 ''              RESERVED ]

*/