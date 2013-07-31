angular.module('Dashboard.Models', [])
.factory('Widgets', ['$http', '$q', function($http, $q) {
    var Widgets = {},
        apiUrl = 'http://127.0.0.1:4000/';

    // get widgets info
    Widgets.getWidgetList = function() {
        var deferred = $q.defer(),
            sUrl = apiUrl + 'widget';

        $http.get(sUrl).success(function(widgets) {
            deferred.resolve(widgets);
        }).error(function(err) {
            deferred.reject(err);
        });

        return deferred.promise;
    };

    // get each widget info
    Widgets.getWidgetData = function(sourceName) {
        var deferred = $q.defer(),
            sUrl = apiUrl+sourceName;

        $http.get(sUrl).success(function(data) {
            deferred.resolve(data);
        }).error(function(err) {
            deferred.reject(err);
        });

        return deferred.promise;
    };

    return Widgets;
}])

.factory('Sources', ['$http', '$q', function($http, $q) {
    var Sources = {},
        apiUrl = 'http://127.0.0.1:4000/sources';

    Sources.getSources = function() {
        var deferred = $q.defer();

        $http.get(apiUrl).success(function(data) {
            deferred.resolve(data);
        }).error(function(err) {
            deferred.reject(err);
        });

        return deferred.promise;
    };

    return Sources;
}])

.factory('Admin', ['$http', '$q', function($http, $q) {
    var Admin = {},
    apiUrl = 'http://127.0.0.1:4000/widget/';

    Admin.addWidget = function(data) {
        var deferred = $q.defer();

        console.log(data);

        $http.post(apiUrl, data).success(function(response) {
            deferred.resolve(data);
            console.log(response);
        }).error(function(err) {
            deferred.reject(err);
            console.log(err);
        });

        return deferred.promise;
    };

    Admin.deleteWidget = function(id) {
        var deferred = $q.defer();

        $http.delete(apiUrl + id).success(function(data) {
            deferred.resolve(data);
        }).error(function(err) {
            deferred.reject(err);
        })

        return deferred.promise;
    };

    return Admin;
}])