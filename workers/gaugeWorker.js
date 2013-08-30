var http = require('http')

// get time
var date = new Date()
var year = date.getFullYear();
var month = date.getMonth() + 1;
var day = date.getDate();
var hours = date.getHours();
var minutes = date.getMinutes();
var seconds = date.getSeconds();
var timezone = '+0800';

// Month must be '08' instead of '8'
if(month.toString().length === 1) {
    var month = '0' + month;
}
// Same for day
if(day.toString().length === 1) {
    var day = '0' + month;
}

// Format the time to how Dashy likes it
// "yyyy-MM-ddTHH:mm:ssZ"
var time = "" + year + "-" + month + "-" + day + "T" + hours + ":" + minutes + ":" + seconds + timezone + "";

// Get a value
var nVal = Math.floor(Math.random() * 799);

var data = {
    time: time,
    data: {
        value: nVal
    }
}

var dataString = JSON.stringify(data);

var headers = {
    'Content-Type': 'application/json'
};

var options = {
    host: '127.0.0.1',
    port: 4000,
    path: '/internet',
    method: 'POST',
    headers: headers
};

// Prepare POST logic
var req = http.request(options, function(res) {
    res.setEncoding('utf-8');

    var responseString = '';

    res.on('data', function(data) {
        responseString += data;
    });

    res.on('end', function() {
        var resultObject = JSON.parse(responseString);
        console.log(resultObject)
    });

    req.on('error', function(e) {
        console.log("Error: " + e)
    });
});

console.log(dataString);

req.write(dataString);
req.end();