var http = require('http')

var getData = function(callback) {
	http.get("http://127.0.0.1:4000/builds", function(res) {
		var data = ''

		res.on('data', function(chunk) {
			data += chunk;
		});

		res.on('close', function(err) {
			console.log(err)
		});

		res.on('end', function(){
			var obj = JSON.parse(data);
			callback(obj)
		});
	});
};

var statuses = ["pass", "fail"];
var messages = ["Build Successful", "Build Failure"];

getData(function(data) {
	var dataLength = data.length - 1;

	for(i = 0; i <= dataLength; i++) {
		var current = data[i];

		var x = Math.random() * 1;
		x = x.toFixed();

		var date = new Date()
		var year = date.getFullYear();
		var month = date.getDate();
		var day = date.getDay();
		var hours = date.getHours();
		var minutes = date.getMinutes();
		var seconds = date.getSeconds();
		var time = "" + year + "-" + month + "-" + day + "T" + hours + ":" + minutes + ":" + seconds + "Z";

		var newData = {
			_id: current.id,
			_rev: current.key,
			time: time,
			data: {
				status: statuses[x],
				message: messages[x],
				repository: current.value.data.repository,
				title: current.value.data.title,
				test: current.value.data.tests
			}
		}

		var newDataString = JSON.stringify(newData);

		var headers = {
			'Content-Type': 'application/json'
		};

		var options = {
			host: '127.0.0.1',
			port: 4000,
			path: '/builds',
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

		req.write(newDataString);
		req.end();
	}

});