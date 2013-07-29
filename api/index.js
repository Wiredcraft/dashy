var http = require('http'),
    path = require('path'),
    express = require('express'),
    routes = require('./routers'),
    settings = require('./settings');
    app = express();

app.configure(function() {
    app.use(express.favicon());
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express.cookieParser());
    app.use(express.errorHandler());
    app.use(express.static(path.join(__dirname, '../app')));
    app.use(app.router);

    app.use(function(req, res, next) {
        // Access-Control-Allow-Origin must be explicit or Allow-Credentials
        // would fail.
        res.header('Access-Control-Allow-Origin', req.get('Origin'));

        // @see
        // https://developer.mozilla.org/en-US/docs/HTTP/Access_control_CORS
        res.header('Access-Control-Allow-Credentials', 'true');

        // @see http://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol
        res.header('Access-Control-Allow-Methods', [
            'HEAD',
            'GET',
            'POST',
            'PUT',
            'DELETE',
            'TRACE',
            'OPTIONS',
            'CONNECT',
            'PATCH'
        ].join(', '));

        // @see http://en.wikipedia.org/wiki/List_of_HTTP_header_fields
        res.header('Access-Control-Allow-Headers', [
            'Accept',
            'Accept-Charset',
            'Accept-Encoding',
            'Accept-Language',
            'Accept-Datetime',
            'Authorization',
            'Cache-Control',
            'Connection',
            'Cookie',
            'Content-Length',
            'Content-MD5',
            'Content-Type',
            'Date',
            'User-Agent',
            'X-Requested-With'
        ].join(', '));

        next();
    });

    app.options('*', function(req, res, next) {
        return res.send(200, [
            'HEAD',
            'GET',
            'POST',
            'PUT',
            'DELETE',
            'TRACE',
            'OPTIONS',
            'CONNECT',
            'PATCH'
        ].join(','));
    });
});

// api routers
routes(app);

// creat server
http.createServer(app).listen(settings.port, settings.host)
.on('listening', function() {
    console.log('Server start: ' + settings.host + ':' + settings.port);
})
.on('error', function(err) {
    if (err.code === 'EADDRINUSE') {
        console.log('Port ' + settings.port + ' is already in use by another process.');
    } else {
        console.log(err);
    }
});

