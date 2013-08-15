/*
	A Quick Example of a Worker.
	============================
	The process of this worker is:
	 - Get all documents in the builds database
	 - Loop through each set of data
	  - Create new Data object
	  - Insert data id and revision for updating the document
	  - Insert old repo url, title, and tests
	  - Insert new values for status and message
	  - POST new data back to CouchDB

	Currently using a POST Method, to use PUT you must include the document ID after the url (eg. url/builds/:documentID) and the _rev value from the GET must be included.
	Because I'm posting the data with the _id & _rev field included I can just POST to /builds and CouchDB knows to replace the old version.

	Not all workers should update data, for example in githubrepos database, it should add new values, while leaving hte old values alone, therefore no GET calls are required.
	Similarly commits should not update data, it should post new data.
*/

var http = require('http')

// Get builds data from CouchDB
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

// Possible build statuses & messages
var statuses = ["pass", "fail"];
var messages = ["Build Successful", "Build Failure"];

// Call getData function
// Start processing the returned data
getData(function(data) {
	var dataLength = data.length - 1;

	// Loop through all returned data
	for(i = 0; i <= dataLength; i++) {
		var current = data[i];

		// Randomly select 0 or 1
		// Will be used to decide whether build fail/success
		var x = Math.random() * 1;
		x = x.toFixed();

		// Get the time this data changed
		var date = new Date()
		var year = date.getFullYear();
		var month = date.getDate();
		var day = date.getDay();
		var hours = date.getHours();
		var minutes = date.getMinutes();
		var seconds = date.getSeconds();

		// Format the time to how Dashy likes it
		var time = "" + year + "-" + month + "-" + day + "T" + hours + ":" + minutes + ":" + seconds + "Z";

		// Create new data object
		// Keep some old data like title & repoUrl
		// Add new time and status/message
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

		// Stringify to POST
		var newDataString = JSON.stringify(newData);

		// Prepare POST Headers
		var headers = {
			'Content-Type': 'application/json'
		};

		// Prepare POST options
		var options = {
			host: '127.0.0.1',
			port: 4000,
			path: '/builds',
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

		// Call POST function
		req.write(newDataString);
		req.end();
	}

});