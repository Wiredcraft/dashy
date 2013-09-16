module.exports = {
    host : '127.0.0.1',
    clientDirectory : './build',
    port : 4000,
    dbport : 5984,
    widgetsDB : 'widgets',
    sourcesDB : 'sources',
    sourceDB : {
        githubrepos: {
            // couchdb view content
            viewDocContent : {
                all : {
                    map : function(doc) {
                        if (doc.time && doc.data) {
                            emit(doc._rev,{
                                'time' : doc.time,
                                'data' : doc.data
                            });
                        }
                    }
                }
            },
            // for basic validate at router side
            validate : function (oData) {
                if (oData && oData.time && oData.data) {
                    return false;
                } else {
                    return true;
                }
            }
        },
        commits: {
            // couchdb view content
            viewDocContent : {
                all : {
                    map : function(doc) {
                        if (doc.time && doc.data) {
                            emit(Date.parse(doc.time),{
                                'time' : doc.time,
                                'data' : doc.data
                            });
                        }
                    }
                }
            },
            // for basic validate at router side
            validate : function (oData) {
                if (oData && oData.time && oData.data) {
                    return false;
                } else {
                    return true;
                }
            }
        },
        builds: {
            // couchdb view content
            viewDocContent : {
                all : {
                    map : function(doc) {
                        if (doc.time && doc.data) {
                            emit(doc._rev,{
                                'time' : doc.time,
                                'data' : doc.data
                            });
                        }
                    }
                }
            },
            // for basic validate at router side
            validate : function (oData) {
                if (oData && oData.time && oData.data) {
                    return false;
                } else {
                    return true;
                }
            }
        },
        pictures: {
            // couchdb view content
            viewDocContent : {
                all : {
                    map : function(doc) {
                        if (doc.time && doc.data) {
                            emit(doc._rev,{
                                'time' : doc.time,
                                'data' : doc.data
                            });
                        }
                    }
                }
            },
            // for basic validate at router side
            validate : function (oData) {
                if (oData && oData.time && oData.data) {
                    return false;
                } else {
                    return true;
                }
            }
        },
        internet: {
            //couchdb view content
            viewDocContent : {
                all : {
                    map : function(doc) {
                        if (doc.time && doc.data) {
                            emit(doc._rev,{
                                'time' : doc.time,
                                'data' : doc.data
                            });
                        }
                    }
                }
            },
            // for basic validate at router side
            validate : function (oData) {
                if (oData && oData.time && oData.data) {
                    return false;
                } else {
                    return true;
                }
            }
        }
    }
}
