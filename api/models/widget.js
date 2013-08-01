var Q = require('q'),
    db = require('./db'),
    cradle = require('cradle');

module.exports = {
    create : create,
    read : read,
    update : update,
    del : del
}

function read(id) {
    var def = Q.defer();

    db.initWidgetsDB().then(function(database) {
        // If no ID get widgets/all
        if(id == null || id == undefined) {
            // get widgets info
            database.view('widgets/all', {}, function(err, data) {
                // read view document error
                if (err) return def.reject(new Error('Read widget error'));
                
                // return data
                def.resolve(data || {});
            });  
        } else {
            // Get specific widget
            database.get(id, function(err, data) {
                if(err) return def.reject(new Error('Read widget error'));

                def.resolve(data || {});
            });
        }
    }, function(err) {
        def.reject(err);
    });

    return def.promise;
}

function create(oData) {
    var def = Q.defer();

    db.initWidgetsDB().then(function(database) {
        database.save(oData, function (err, res) {
            // create widget document error
            if (err) return def.reject(new Error('Create widget error'));

            // create success
            def.resolve(res || {}); 
        });
    }, function(err) {
        def.reject(err);
    });

    return def.promise;
}

function update(id, oData) {
    var def = Q.defer();

    db.initWidgetsDB().then(function(database) {
        database.save(id, oData, function (err, res) {
            // update widget document error
            if (err) return def.reject(new Error('Update widget error'));

            // update success
            def.resolve(res || {}); 
        });
    }, function(err) {
        def.reject(err);
    });

    return def.promise;
}

function del(id) {
    var def = Q.defer();

    db.initWidgetsDB().then(function(database) {
        database.remove(id, function (err, res) {
            // create widget document error
            if (err) return def.reject(new Error('Delete widget error'));

            // create success
            def.resolve(res || {}); 
        });
    }, function(err) {
        def.reject(err);
    });

    return def.promise;   
}