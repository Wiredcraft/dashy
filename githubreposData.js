function randomInt (min, max) {
	return Math.floor(Math.random() * (max - min + 1)) + min;
}

var headers = {
	'Content-Type': 'application/json'
};

var options = {
	host: '127.0.0.1',
	port: 5984,
	path: '/githubrepos',
	method: 'POST',
	headers: headers
};

var http = require('http');

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

// req.write(dataString);
// req.end();

