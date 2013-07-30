var settings = require('../settings'),
    widget = require('../models/widget'),
    datasource = require('../models/datasource'),
    datasources = require('../models/datasources');

module.exports =  function (app) {
    // WIDGET
    // GET
    app.get('/widget', function (req, res) {
        widget.read().then(function(data) {
            res.json(200, data);
        }, function(err) {
            // server error
            res.json(500, {
                status : 500,
                message: err
            });
        });
    });

    // // GET ID
    // app.get('/widget/:id', function (req, res) {
    //     var test = req.params.id;
    //     // console.log('id = ', id);

    //     widget.read(test).then(function(data) {
    //         res.json(200, data);
    //     }, function(err) {
    //         // server error
    //         res.json(500, {
    //             status : 500,
    //             message: err
    //         });
    //     });
    // });

    // POST
    app.post('/widget', function (req, res, next) {
        var oData = req.body;

        // invalid data
        if (!oData || !oData.content || !oData.config || !oData.layout)
        
        return res.json(400, {
            status : 400,
            message : 'Invalid data'
        })

        widget.create(oData).then(function(data) {
            res.json(200, data);
        }, function(err) {
            // server error
            res.json(500, {
                status : 500,
                message: err
            });
        });
    });

    // PUT
    app.put('/widget/:id', function (req, res) {
        var id = req.params.id,
            oData = req.body;

        // need id
        if (!id)

        return res.json(400, {
            status : 400,
            message : 'Need widget id!'
        })

        // invalid data
        if (!oData || !oData.content || !oData.config || !oData.layout)
        
        return res.json(400, {
            status : 400,
            message : 'Invalid data'
        })

        widget.update(id, oData).then(function(data) {
            res.json(200, data);
        }, function(err) {
            // server error
            res.json(500, {
                status : 500,
                message: err
            });
        });
    });

    // DELETE
    app.del('/widget/:id', function (req, res) {
        var id = req.params.id;

        // need id
        if (!id)

        return res.json(400, {
            status : 400,
            message : 'Need widget id!'
        })

        widget.del(id).then(function(data) {
            res.json(200, data);
        }, function(err) {
            // server error
            res.json(500, {
                status : 500,
                message: err
            });
        });
    });


    // DATASOURCES
    // GET
    app.get('/sources', function (req, res) {
        datasources.read().then(function(data) {
            res.json(200, data);
        }, function(err) {
            // server error
            res.json(500, {
                status : 500,
                message: err
            });
        });
    });

    // DATASOURCE
    // GET
    app.get('/:dbname', function (req, res) {
        var dbname = req.params.dbname;

        datasource.read(dbname).then(function(data) {
            res.json(200, data);
        }, function(err) {
            // server error
            res.json(500, {
                status : 500,
                message: err
            });
        });
    });

    // POST
    app.post('/:dbname', function (req, res, next) {
        var dbname = req.params.dbname,
            oData = req.body;

        // need database name
        if (!dbname)

        return res.json(400, {
            status : 400,
            message : 'Need database name!'
        })

        // invalid data
        if (settings['sourceDB'][dbname]['validate'](oData)) 
         
        return res.json(400, {
            status : 400,
            message : 'Invalid data'
        })

        datasource.create(dbname, oData).then(function(data) {
            res.json(200, data);
        }, function(err) {
            // server error
            res.json(500, {
                status : 500,
                message: err
            });
        });
    });

    // PUT
    app.put('/:dbname/:id', function (req, res, next) {
        var id = req.params.id,
            dbname = req.params.dbname,
            oData = req.body;

        if (!id) 
        return res.json(400, {
            status : 400,
            message : 'Need document id!'
        })

        // need database name
        if (!dbname)
        return res.json(400, {
            status : 400,
            message : 'Need database name!'
        })

        // invalid data
        if (settings['sourceDB'][dbname]['validate'](oData))
        return res.json(400, {
            status : 400,
            message : 'Invalid data'
        })

        datasource.update(id, dbname, oData).then(function(data) {
            res.json(200, data);
        }, function(err) {
            // server error
            res.json(500, {
                status : 500,
                message: err
            });
        });
    });

    // DELETE
    app.del('/:dbname/:id', function (req, res) {
        var id = req.params.id,
            dbname = req.params.dbname;

        if (!id) 
        return res.json(400, {
            status : 400,
            message : 'Need document id!'
        })

        // need database name
        if (!dbname)
        return res.json(400, {
            status : 400,
            message : 'Need database name!'
        })

        datasource.del(id, dbname).then(function(data) {
            res.json(200, data);
        }, function(err) {
            // server error
            res.json(500, {
                status : 500,
                message: err
            });
        });
    });
}
