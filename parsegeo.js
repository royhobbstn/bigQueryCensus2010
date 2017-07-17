var csv = require('csv');
var fs = require('fs');




var stream = fs.createWriteStream('./c2010/geofile2010raw2.csv');

fs.createReadStream('./c2010/geofile2010raw.csv').pipe(
    csv.parse()).pipe(
    csv.transform(function(record) {
        console.log(record);
        return record.slice(54);
    })).pipe(
    csv.stringify()).pipe(stream);

stream.on('error', function(error) {
    console.log('ERROR');
    console.log(error);
});

stream.on('finish', function() {
    console.log('file has been written');
});
