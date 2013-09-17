/*
    Gaug.es Worker
    $ node gaugesWorker.js <Interval(Seconds)> <Gaug.es Title> <Database Name>
    Use 'n' instead of a number to run one time.
*/

var http = require('http');
var https = require('https');

// Get arguments
var intval = process.argv[2];
var name = process.argv[3].toString();
var database = process.argv[4].toString();

// Get Gaug.es data
var getData = function(callback) {
    var options = {
        host: 'secure.gaug.es',
        path: '/gauges',
        headers: {'X-Gauges-Token': 'fb42a9864d5b86f982629fb740f1114f'}
    };
    https.get(options, function(res) {
        var response = '';
        res.on('data', function(d) {
            var data = d.toString();
            response += data;
        });

        res.on('end', function() {
            callback(response);
        });
    });
};

// Post to Dashy CouchDB
var postData = function(dataString) {
    var headers = {
        'Content-Type': 'application/json'
    };

    var options = {
        host: '127.0.0.1',
        port: 4000,
        path: '/'+database,
        method: 'POST',
        headers: headers
    };

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

    req.write(dataString);
    req.end();
}

// Time
var getTime = function() {
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
    var time = "" + year + "-" + month + "-" + day + "T" + hours + ":" + minutes + ":" + seconds + timezone + "";
    return time;
}

// Worker Logic
var worker = function() {
    getData(function(data) {
        var d = JSON.parse(data);
        var array = d.gauges;
        var thisData = {};
        thisData.data = {};

        for(i = 0; i < array.length; i++) {
            if(array[i].title === name) {
                thisData.time = getTime();
                thisData.data.value = array[i].today.views;
            }
        };

        var dataString = JSON.stringify(thisData);
        postData(dataString);
    });
}

// Run once
worker();
// If interval run once every interval
if(intval !== 'n') {
    intval = intval * 1000;
    setInterval(function() {
        worker();
    }, intval);    
}