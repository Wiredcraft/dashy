var Q = require('q'),
    db = require('./db'),
    cradle = require('cradle');

module.exports = {
    read : read
}

function read() {
    var def = Q.defer();

    db.initSourcesDB().then(function(database) {
        // get source info
        database.view('sources/all', {}, function(err, data) {
            // read view document error
            if (err) return def.reject(new Error('Read sources error'));
            
            // return data
            def.resolve(data || {});
        });
    }, function(err) {
        def.reject(err);
    });

    return def.promise;
}
