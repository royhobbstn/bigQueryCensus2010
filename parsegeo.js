var csv = require('csv');
var fs = require('fs');




var stream = fs.createWriteStream('./geofile2010raw2.csv');

fs.createReadStream('./geofile2010raw.csv').pipe(
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
