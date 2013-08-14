setInterval(function() {

	var items = [
		{
			"repository": "http://github.com/wiredcraft/borat",
			"title": "Borat"
		},
		{
			"repository": "http://github.com/wiredcraft/dashy",
			"title": "Dashy"
		},
		{
			"repository": "http://github.com/wiredcraft/moleskin",
			"title": "Moleskin"
		},
		{
			"repository": "http://github.com/AppSlapper/AppNap",
			"title": "AppNap"
		},
		{
			"repository": "http://github.com/wiredcraft/ShanghaiOS.org",
			"title": "Shanghai OS"
		},
		{
			"repository": "http://github.com/devo-ps/devo.ps",
			"title": "Devo.ps"
		},
		{
			"repository": "http://github.com/wiredcraft/Embarq",
			"title": "Embarq"
		}
	];

	var statuses = ["pass", "fail"];
	var messages = ["Build Successful", "Build Failure"];


	var y = Math.random() * (items.length - 1);
	y = y.toFixed();

	var x = Math.random() * 1;
	x = x.toFixed();

	var item = items[y]
	var status = statuses[x]
	var message = messages[x]

	var date = new Date()
	var year = date.getFullYear();
	var month = date.getDate();
	var day = date.getDay();
	var hours = date.getHours();
	var minutes = date.getMinutes();
	var seconds = date.getSeconds();
	var time = "" + year + "-" + month + "-" + day + "T" + hours + ":" + minutes + ":" + seconds + "Z";

	var data = {
		time: time,
		data: {
			repository: item.respository,
			title: item.title,
			status: status,
			message: message
		}
	}

	var dataString = JSON.stringify(data);


	var headers = {
		'Content-Type': 'application/json',
		'Content-Length': dataString.length
	};

	var options = {
		host: '127.0.0.1',
		port: 4000,
		path: '/builds',
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

	req.write(dataString);
	req.end();

}, 10000)