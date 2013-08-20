angular.module('Dashboard.Formatters', [])

.factory('Number', function() {

    return function(n, prepend, append) {

        if(prepend == undefined){
            prepend = "";
        }
        if(append == undefined){
            append = "";
        }

        n = n.toFixed().replace(/\B(?=(\d{3})+(?!\d))/g, ","); //Comma formatting

        if (append === 'M' || append === 'm') {
            n = n.slice(0, n.length - 8);
        };

        if (append === 'K' || append === 'k') {
           n = n.slice(0, n.length - 4);
        };

        n = prepend + n + append;

        return n;
    };

})

.factory('sortTime', function() {

    return function(data, ascending) {
        if(ascending == true) {
            data.sort(function(x, y) { return x['time'] - y['time'] })    
        } else {
            data.sort(function(x, y) { return y['time'] - x['time'] })
        }  

    }
})