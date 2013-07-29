module.exports = {
    host : '127.0.0.1',
    clientDirectory : './app',
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
                        if (doc.date && doc.amount) {
                            emit(doc._rev,{
                                'date' : doc.date,
                                'amount' : doc.amount
                            });
                        }
                    }
                }
            },
            // for basic validate at router side
            validate : function (oData) {
                if (oData && oData.name && oData.status) {
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
                        if (doc.title && doc.time && doc.user && doc.img) {
                            emit(doc._rev,{
                                'title' : doc.title,
                                'time' : doc.time,
                                'user' : doc.user,
                                'img' : doc.img
                            });
                        }
                    }
                }
            },
            // for basic validate at router side
            validate : function (oData) {
                if (oData && oData.name && oData.status) {
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
                        if (doc.title && doc.status) {
                            emit(doc._rev,{
                                'title' : doc.title,
                                'status' : doc.status
                            });
                        }
                    }
                }
            },
            // for basic validate at router side
            validate : function (oData) {
                if (oData && oData.name && oData.status) {
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
                        if (doc.title && doc.image) {
                            emit(doc._rev,{
                                'title' : doc.title,
                                'image' : doc.image
                            });
                        }
                    }
                }
            },
            // for basic validate at router side
            validate : function (oData) {
                if (oData && oData.name && oData.status) {
                    return false;
                } else {
                    return true;
                }
            }
        }
    }
}
