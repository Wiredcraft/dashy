angular.module('Dashboard.Admin', [])

// Add Widget controller
// Work in progress
.controller('AddCtrl', ['$scope', 'Sources', '$http',
    function($scope, Sources, $http) {

        $scope.dbWidgets = {
            "linechart": {
                "points": 0
            },
            "delta": {},
            "gauge": {
                "min": 0,
                "max": 0,
            },
            "sum": {
                "append": "",
                "prepend": "",
                "subtitle": ""
            },
            "list": {
                "limit": 0
            },
            "picture": {},
            "gauge": {},
            "countdown": {
                "startdate": 0,
                "enddate": 0
            },
            "announcement": {
                "announcement": "",
                "subtitle": ""
            }
        }

        $scope.sources = Sources.getSources();

        $scope.widget = {};
        $scope.realWidget;
        $scope.addWidget = function(widget){
            $scope.realWidget = {
                "_id" : widget._id,
                "config": {
                    "refresh": widget.config.refresh,
                    "source": widget.config.source,
                },
                "content": {
                    "title": widget.content.title
                },
                "layout": {
                    "data-row": widget.layout.data_row,
                    "data-col": widget.layout.data_col,
                    "data-sizex": widget.layout.data_sizex,
                    "data-sizey": widget.layout.data_sizey
                }
            }
            console.log($scope.realWidget);

            // $scope.test = {
            //    "_id": "Testsingsers",
            //    "config": {
            //        "refresh": 1000,
            //        "source": {
            //            "announcement": "This is a test!",
            //            "sub": "Subtitle!",
            //            "startdate": "20130717",
            //            "enddate": "20140101"
            //        }
            //    },
            //    "content": {
            //        "title": "Announcements!",
            //        "templates": {
            //            "announcement": {
            //            },
            //            "countdown": {
            //            }
            //        }
            //    },
            //    "layout": {
            //        "data-row": 1,
            //        "data-col": 3,
            //        "data-sizex": 4,
            //        "data-sizey": 2
            //    }
            // }

            // $http.post('http://127.0.0.1:4000/widget', $scope.test).success(function(response) {
            //     console.log(response);
            // }).error(function(err) {
            //     console.log(err);
            // });

        }

    }
])