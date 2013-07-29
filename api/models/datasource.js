var Q = require('q'),
    db = require('./db'),
    cradle = require('cradle');

module.exports = {
    create : create,
    read : read,
    update : update,
    del : del
}

function read(dbname) {
    var def = Q.defer();

    db.initSourceDB(dbname).then(function(database) {
        // get source info
        database.view('source/all', {}, function(err, data) {
            // read view document error
            if (err) return def.reject(new Error('Read source ' + dbname + ' error'));
            
            // return data
            def.resolve(data || {});
        });
    }, function(err) {
        def.reject(err);
    });

    return def.promise;
}

function create(dbname, oData) {
    var def = Q.defer();

    db.initSourceDB(dbname).then(function(database) {
        database.save(oData, function (err, res) {
            // create document error
            if (err) return def.reject(new Error('Create source of ' + dbname + 'document error'));

            // create success
            def.resolve(res || {});
        });
    }, function(err) {
        def.reject(err);
    });

    return def.promise;
}

function update(id, dbname, oData) {
    var def = Q.defer();

    db.initSourceDB(dbname).then(function(database) {
        database.save(id, oData, function (err, res) {
            // update document error
            if (err) return def.reject(new Error('Update source of ' + dbname + 'document error'));

            // update success
            def.resolve(res || {});
        });
    }, function(err) {
        def.reject(err);
    });

    return def.promise;
}

function del(id, dbname) {
    var def = Q.defer();

    db.initSourceDB(dbname).then(function(database) {
        database.remove(id, function (err, res) {
            // delete source document error
            if (err) return def.reject(new Error('Delete source of ' + dbname + 'document error'));

            // delete success
            def.resolve(res || {}); 
        });
    }, function(err) {
        def.reject(err);
    });

    return def.promise;
}
