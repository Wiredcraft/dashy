var dates = [
	"2013-03-01T00:00:00Z",
	"2013-03-02T00:00:00Z",
	"2013-03-03T00:00:00Z",
	"2013-03-04T00:00:00Z",
	"2013-03-05T00:00:00Z",
	"2013-03-06T00:00:00Z",
	"2013-03-07T00:00:00Z",
	"2013-03-08T00:00:00Z",
	"2013-03-09T00:00:00Z",
	"2013-03-10T00:00:00Z",
	"2013-03-11T00:00:00Z",
	"2013-03-12T00:00:00Z",
	"2013-03-13T00:00:00Z",
	"2013-03-14T00:00:00Z",
	"2013-03-15T00:00:00Z",
	"2013-03-16T00:00:00Z",
	"2013-03-17T00:00:00Z",
	"2013-03-18T00:00:00Z",
	"2013-03-19T00:00:00Z",
	"2013-03-20T00:00:00Z",
	"2013-03-21T00:00:00Z",
	"2013-03-22T00:00:00Z",
	"2013-03-23T00:00:00Z",
	"2013-03-24T00:00:00Z",
	"2013-03-25T00:00:00Z",
	"2013-03-26T00:00:00Z",
	"2013-03-27T00:00:00Z",
	"2013-03-28T00:00:00Z",
	"2013-03-29T00:00:00Z",
	"2013-03-30T00:00:00Z",
	"2013-04-01T00:00:00Z",
	"2013-04-02T00:00:00Z",
	"2013-04-03T00:00:00Z",
	"2013-04-04T00:00:00Z",
	"2013-04-05T00:00:00Z",
	"2013-04-06T00:00:00Z",
	"2013-04-07T00:00:00Z",
	"2013-04-08T00:00:00Z",
	"2013-04-09T00:00:00Z",
	"2013-04-10T00:00:00Z",
	"2013-04-11T00:00:00Z",
	"2013-04-12T00:00:00Z",
	"2013-04-13T00:00:00Z",
	"2013-04-14T00:00:00Z",
	"2013-04-15T00:00:00Z",
	"2013-04-16T00:00:00Z",
	"2013-04-17T00:00:00Z",
	"2013-04-18T00:00:00Z",
	"2013-04-19T00:00:00Z",
	"2013-04-20T00:00:00Z",
	"2013-04-21T00:00:00Z",
	"2013-04-22T00:00:00Z",
	"2013-04-23T00:00:00Z",
	"2013-04-24T00:00:00Z",
	"2013-04-25T00:00:00Z",
	"2013-04-26T00:00:00Z",
	"2013-04-27T00:00:00Z",
	"2013-04-28T00:00:00Z",
	"2013-04-29T00:00:00Z",
	"2013-04-30T00:00:00Z",
	"2013-05-01T00:00:00Z",
	"2013-05-02T00:00:00Z",
	"2013-05-03T00:00:00Z",
	"2013-05-04T00:00:00Z",
	"2013-05-05T00:00:00Z",
	"2013-05-06T00:00:00Z",
	"2013-05-07T00:00:00Z",
	"2013-05-08T00:00:00Z",
	"2013-05-09T00:00:00Z",
	"2013-05-10T00:00:00Z",
	"2013-05-11T00:00:00Z",
	"2013-05-12T00:00:00Z",
	"2013-05-13T00:00:00Z",
	"2013-05-14T00:00:00Z",
	"2013-05-15T00:00:00Z",
	"2013-05-16T00:00:00Z",
	"2013-05-17T00:00:00Z",
	"2013-05-18T00:00:00Z",
	"2013-05-19T00:00:00Z",
	"2013-05-20T00:00:00Z",
	"2013-05-21T00:00:00Z",
	"2013-05-22T00:00:00Z",
	"2013-05-23T00:00:00Z",
	"2013-05-24T00:00:00Z",
	"2013-05-25T00:00:00Z",
	"2013-05-26T00:00:00Z",
	"2013-05-27T00:00:00Z",
	"2013-05-28T00:00:00Z",
	"2013-05-29T00:00:00Z",
	"2013-05-30T00:00:00Z"
]

function randomInt(min, max) {
	return Math.floor(Math.random() * (max - min + 1)) + min;
}



for(i = 0; i < dates.length; i++) {

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

	time = dates[i];

	if(i <= 10) {
		x = randomInt(100, 400);
	} else if(i <= 20 && i > 10) {
		x = randomInt(200, 300);
	} else if(i <= 30 && i > 20) {
		x = randomInt(300, 400);
	} else if(i <= 40 && i >30) {
		x = randomInt(400, 500);
	} else if(i <= 50 && i > 40) {
		x = randomInt(500, 600);
	} else {
		x = randomInt(500, 600);
	}

	var data = {
		time: time,
		data: {
			value: x
		}
	}

	var dataString = JSON.stringify(data);

	req.write(dataString);
	req.end();
}