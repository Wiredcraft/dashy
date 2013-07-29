angular.module('Dashboard.Formatters', [])

.factory('Number', function() {

    return function(n, prepend, append) {
        // console.log('number = ', n, 'append = ', append, 'prepend = ', prepend);
        // Reminders for Jamie
        // var i = parseInt(n); //Number
        // var f = n.toFixed(); //String
        // var u = n.toFixed(2); //2 Decimal places

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