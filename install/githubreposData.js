var dates = [
	"1-Mar-13",
	"2-Mar-13",
	"3-Mar-13",
	"4-Mar-13",
	"5-Mar-13",
	"6-Mar-13",
	"7-Mar-13",
	"8-Mar-13",
	"9-Mar-13",
	"10-Mar-13",
	"11-Mar-13",
	"12-Mar-13",
	"13-Mar-13",
	"14-Mar-13",
	"15-Mar-13",
	"16-Mar-13",
	"17-Mar-13",
	"18-Mar-13",
	"19-Mar-13",
	"20-Mar-13",
	"21-Mar-13",
	"22-Mar-13",
	"23-Mar-13",
	"24-Mar-13",
	"25-Mar-13",
	"26-Mar-13",
	"27-Mar-13",
	"28-Mar-13",
	"29-Mar-13",
	"30-Mar-13",
	"1-Apr-13",
	"2-Apr-13",
	"3-Apr-13",
	"4-Apr-13",
	"5-Apr-13",
	"6-Apr-13",
	"7-Apr-13",
	"8-Apr-13",
	"9-Apr-13",
	"10-Apr-13",
	"11-Apr-13",
	"12-Apr-13",
	"13-Apr-13",
	"14-Apr-13",
	"15-Apr-13",
	"16-Apr-13",
	"17-Apr-13",
	"18-Apr-13",
	"19-Apr-13",
	"20-Apr-13",
	"21-Apr-13",
	"22-Apr-13",
	"23-Apr-13",
	"24-Apr-13",
	"25-Apr-13",
	"26-Apr-13",
	"27-Apr-13",
	"28-Apr-13",
	"29-Apr-13",
	"30-Apr-13"
]

function randomInt(min, max) {
	return Math.floor(Math.random() * (max - min + 1)) + min;
}



for(i = 0; i < 51; i++) {

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