angular.module('Dashboard.Filters', [])

.filter('descNumber',  function() {
    return function(number) {
        var str = parseInt(number);
        
        if (str > 1000) {
            str = Math.floor(str/1000) + 'K';
        }
        
        return str;
    };
})

.filter('upperCase', function() {
	return function(word) {
		if (word !== undefined) {
			return word.charAt(0).toUpperCase() + word.slice(1);
		};
	};
})