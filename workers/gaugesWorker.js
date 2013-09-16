var http = require('https');

// Get Gaug.es data
var getData = function(callback) {
	var options = {
		host: 'secure.gaug.es',
		path: '/gauges',
		headers: {'X-Gauges-Token': 'fb42a9864d5b86f982629fb740f1114f'}
	};
	http.get(options, function(res) {
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


// Time
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


// getData(function(data) {
// 	var d = JSON.parse(data);
// 	var array = d.gauges;

// 	for(i = 0; i < array.length; i++) {
// 		if(array[i].title === 'Wiredcraft.com' || array[i].title === 'devo.ps') {
// 			console.log(array[i].today)
// 		}
// 	};
// });