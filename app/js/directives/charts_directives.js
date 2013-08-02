// charts directives
angular.module('Dashboard.Charts', [])

// linechart directive
.directive('linechart', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            data: '@'
        },
        controller: function($scope, $element, $timeout) {
            $timeout(function () {
                var axisData = JSON.parse($scope.data),
                    width = $element.width(),
                    height = $element.height(),
                    parseDate = d3.time.format("%d-%b-%y").parse, // date format like this '28-Mar-12'
                    x = d3.time.scale().range([0, width]),
                    y = d3.scale.linear().range([height, 0]),
                    xAxis = d3.svg.axis().scale(x).orient("bottom"),
                    yAxis = d3.svg.axis().scale(y).orient("left"),
                    line = d3.svg.line()
                        .x(function(d) { 
                            return x(d.value.date); 
                        })
                        .y(function(d) { 
                            return y(d.value.amount); 
                        }),
                    svg = d3.select($element[0]).append("svg").attr("width", width).attr("height", height).append("g");

                angular.forEach(axisData, function(data, index, source){
                    var target = data.value;

                    target.date = parseDate(target.date);
                    target.amount = +target.amount.toFixed();
                });

                // sort by date, its important, linechart need
                axisData.sort(function (x, y) { return x['value']['date'] - y['value']['date'] })

                x.domain(d3.extent(axisData, function(d) { return d.value.date; }));
                y.domain(d3.extent(axisData, function(d) { return d.value.amount; }));

                // line
                svg.append("path").datum(axisData).attr("class", "line").attr("d", line);

            }, 0)
        }
    };
})

// Countdown Directive
.directive('countdown', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            data: '@',
            templates: '@'
        },
        templateUrl: 'templates/countdown.html',
        controller: function($scope, $element, $timeout) {
            var oDate = JSON.parse($scope.templates).countdown,
                timer = function () {
                    countdown();
                    $timeout(timer, 1000);
                },
                countdown = function () {
                    var now = moment() , //get the current moment  or usr moment(oDate.startdate, 'YYYYMMDD')
                        then = moment(oDate.enddate, 'YYYYMMDD'), // format the enddate 
                        ms = then.diff(now, 'milliseconds', true); // get the difference from now to then in ms
                    
                    // Years
                    // ms = then.diff(now, 'milliseconds', true);
                    // years = Math.floor(moment.duration(ms).asYears()); // get the duration as years and round down
                    // then = then.subtract('years', years); // subtract years from the original moment 
                    
                    // Months
                    // ms = then.diff(now, 'milliseconds', true);
                    // months = Math.floor(moment.duration(ms).asMonths()); // get the duration as months and round down
                    // then = then.subtract('months', months).subtract('days'); // subtract months from the original moment 
                    
                    // Days
                    ms = then.diff(now, 'milliseconds', true);
                    days = Math.floor(moment.duration(ms).asDays());  // get the duration as days and round down
                    then = then.subtract('days', days); // subtract days from the original moment 
                    
                    // Hours
                    ms = then.diff(now, 'milliseconds', true);
                    hours = Math.floor(moment.duration(ms).asHours()); // get the duration as hours and round down
                    then = then.subtract('hours', hours); // subtract hours from the original moment 
                    
                    // Minutes
                    ms = then.diff(now, 'milliseconds', true);
                    minutes = Math.floor(moment.duration(ms).asMinutes()); // get the duration as minutes and round down
                    then = then.subtract('minutes', minutes); // subtract minutes from the original moment 

                    // Seconds
                    ms = then.diff(now, 'milliseconds', true); // get the duration as seconds and round down
                    seconds = Math.floor(moment.duration(ms).asSeconds());

                    $scope.date = {
                        // 'desc' : moment(oDate.enddate, "YYYYMMDD").fromNow(),
                        // 'years' : years,
                        // 'months' : months,
                        'days' : days,
                        'hours' : hours,
                        'minutes' : minutes,
                        'seconds' : seconds
                    }
                };

            // start the count down func
            timer()   
        }
    };
})

// Delta directive
.directive('delta', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            data: '@',
            templates: '@'
        },
        templateUrl: 'templates/delta.html',
        controller: function($scope, $element) {
            var sData = JSON.parse($scope.data),
                parseDate = d3.time.format("%d-%b-%y").parse; // Correct time formatting
            
            angular.forEach(sData, function(data, index, source) {
                var target = data.value;
                target.date = parseDate(target.date);
            });
            
            // Order Information by date
            sData.sort(function(a, b) { return a['value']['date'] - b['value']['date'] });

            var base = sData[0].value.amount,
                length = sData.length - 1,
                current = sData[length].value.amount,
                diff = ((current / base) * 100);

            var status;
            if (diff > 100) {
                dir = "⬆";
                status = 'up';
            } else if (diff === 100) {
                dir = "="
                status = 'equal'
            } else {
                dir = "⬇";
                status = 'down'
            }

            diff = diff - 100;
            diff = diff.toFixed();

            $scope.delta = {
                'difference' : diff + "%",
                'direction' : dir,
                'status' : status
            }
        }
    };
})

// Sum Directive
.directive('sum', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            templates: '@',
            data: '@'
        },
        templateUrl: 'templates/sum.html',
        controller: function($scope, $element, $timeout, Number) {
            var sData = JSON.parse($scope.data),
                tmpls = JSON.parse($scope.templates),
                append = tmpls.sum.append,
                prepend = tmpls.sum.prepend,
                sub = tmpls.sum.subtitle,
                total = 0;

            angular.forEach(sData, function(data, index, source){
                total += data.value.amount;
            });

            total = Number(total, prepend, append);
            $scope.sum = total;
            $scope.sub = sub;
        }
    };
})

// List Directive
.directive('list', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            templates: '@',
            data: '@'
        },
        templateUrl: 'templates/list.html',
        controller: function($scope, $element, $timeout) {
            var sData = JSON.parse($scope.data),
                tmpls = JSON.parse($scope.templates).list,
                nLimit = parseInt(tmpls.limit);

            var array = [];
            angular.forEach(sData, function(data, index) {
                if (data.value.time !== undefined) {
                    data.value.time = moment(data.value.time).fromNow();
                };
                array.push(data.value);
            });

            // Show status icons if builds, img if not
            $scope.builds = false;
            if (sData[0].value.status !== undefined) {
                $scope.builds = true;
            };

            // Data into scope
            if (nLimit) {   // if has limit attr
                $scope.list = array.splice(0, nLimit);
            } else {
                $scope.list = array;
            }
        }
    }
})

// Announcement Directive
.directive('announcement', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            templates: '@',
            data: '@'
        },
        templateUrl: 'templates/announcement.html',
        controller: function($scope, $element) {
            var sData = JSON.parse($scope.templates).announcement;
            $scope.announcement = sData.announcement;
            $scope.sub = sData.subtitle;     
        }
    };
})

// Picture directive
.directive('picture', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            templates: '@',
            data: '@'
        },
        templateUrl: 'templates/picture.html',
        controller: function($scope, $element) {
            var sData = JSON.parse($scope.data),
                image = sData[0].value.image;

            $scope.imageUrl = image;

        }
    }
})

// Gauge
.directive('gauge', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            templates: '@',
            data: '@'
        },
        templateUrl: "templates/gauge.html",
        controller: function($scope, $element) {
            var sData = JSON.parse($scope.data),
                tmpls = JSON.parse($scope.templates);

            var svg = d3.select($element[0]).append("svg");
            var pi = Math.PI;

            var min = parseFloat(tmpls.gauge.min);
            var max = parseFloat(tmpls.gauge.max);
            var current = sData[0].value.amount;

            // No higher/lower than max/min
            if (current > max) {
                current = max;
            }
            if (current < min) {
                current = min;
            }

            // Color Scheme
            var prct = ((current / max) * 100),
                color = undefined;

            if (prct < 34) {
                color = "#3c9b33";
            } else if (prct > 66) {
                color = "#aa3f38"
            } else {
                color = "#c2bb48"
            }

            // Calculate draw angle
            var drawAng = (((current * 180) / max) - 90);

            var arc = d3.svg.arc()
                .innerRadius(50)
                .outerRadius(90)
                .startAngle(-90 * (pi/180))
                .endAngle(drawAng * (pi/180))

            svg.append("path")
                .attr("fill", color)
                .attr("d", arc)
                .attr("transform", "translate(130,100)")

            $scope.value = current;

        }
    }
})



