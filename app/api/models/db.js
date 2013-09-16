var Q = require('q'),
    cradle = require('cradle'),
    settings = require('../settings'),
    couch = new cradle.Connection(settings.host || 'http://127.0.0.1', settings.dbport || 5984);

module.exports = {
    initWidgetsDB : initWidgetsDB,
    initSourcesDB : initSourcesDB,
    initSourceDB : initSourceDB
}

// for get widgets database , and detect widgets database if it exsits
function initWidgetsDB() {
    var def = Q.defer(),
        db = couch.database(settings.widgetsDB);

    // detect database if exist
    db.exists(function(err, exists) {
        // if err
        if (err) return def.reject(err);
        // if exists return it
        if (exists) return def.resolve(db);
        // if not exsits, create it
        db.create(function(err) {
            // create error
            if (err) return def.reject(new Error('create widget db error'));

            // creat view document
            db.save('_design/widgets', {
                all : {
                    map : function(doc) {
                        if (doc.content && doc.config && doc.layout) {
                            emit(doc._rev,{
                                'content' :doc.content,
                                'config' : doc.config,
                                'layout' : doc.layout
                            });
                        }
                    }
                }
            }, function (err, res) {
                if (err) return def.reject(new Error('save widget db view error'));
                // create success
                return def.resolve(db);
            });
        });
    });

    return def.promise;
}

// for datasources collection
function initSourcesDB() {
    var def = Q.defer(),
        db = couch.database(settings.sourcesDB);

    // detect database if exist
    db.exists(function(err, exists) {
        // if err
        if (err) return def.reject(err);
        // if exists return it
        if (exists) return def.resolve(db);
        // if not exsits, create it
        db.create(function(err) {
            // create error
            if (err) return def.reject(new Error('create sources db error'));

            // creat view document
            db.save('_design/sources', {
                all : {
                    map : function(doc) {
                        if (doc.name) {
                            emit(doc._rev,{
                                'name' :doc.name
                            });
                        }
                    }
                }
            }, function (err, res) {
                if (err) return def.reject(new Error('save sources db view error'));
                def.resolve(db);
            });
        });
    });

    return def.promise;
}

// for get datasource database , and detect datasource database if it exsits
function initSourceDB(dbname) {
    var def = Q.defer(),
        db = couch.database(dbname);

    // detect database if exist
    db.exists(function(err, exists) {
        // if err
        if (err) return def.reject(err);
        // if exists return it
        if (exists) return def.resolve(db);
        // if source doesnt have the setting information, will prevent to create database
        if (!settings['sourceDB'][dbname]) return def.reject(new Error('cant find source of '+ dbname + ' setting information.'));

        // if not exsits, create it
        db.create(function(err) {
            // create error
            if (err) return def.reject(new Error('create db ' + dbname + ' error'));

            // creat view document
            db.save('_design/source', settings['sourceDB'][dbname]['viewDocContent'], function (err, res) {
                if (err) return def.reject(new Error('save db ' + dbname + ' view error'));
                
                // update datasources
                initSourcesDB().then(function (database) {
                    database.save(dbname, { 'name' : dbname }, function (err, res) {
                        // create datasources document error
                        if (err) return def.reject(new Error('create sources document error'));

                        // create success
                        def.resolve(db);
                    });            
                }, function (err) {
                    def.reject(new Error('init sources databse error'));
                })                
            });
        });
    });

    return def.promise;
}
