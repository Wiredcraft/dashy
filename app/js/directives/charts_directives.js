// charts directives
angular.module('Dashboard.Charts', [])

// linechart directive
.directive('linechart', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            data: '@',
            templates: '@'
        },
        controller: function($scope, $element, $timeout) {
            $timeout(function () {
                // Loop through content, find linechart options
                var templates = JSON.parse($scope.templates);
                var tmpls, refresh, attr;
                angular.forEach(templates, function(data, index) {
                    if(data.template === "linechart") {
                        tmpls = data.options;
                        refresh = data.refresh;
                        if(data.dataKey) {
                            attr = data.dataKey;
                        }
                    }
                });

                var linechart = function() {
                    // Remove old graph, replace with new graph
                    angular.element($element[0]).children().remove();

                    var axisData = JSON.parse($scope.data),
                        width = $element.width(),
                        height = $element.height(),
                        // parseDate = d3.time.format("%d-%b-%y").parse, // date format like this '28-Mar-12'
                        parseDate = d3.time.format("%Y-%m-%dT%H:%M:%SZ").parse, // date format like "2013-08-14T19:23:45Z" 
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
                        area = d3.svg.area()
                            .x(function(d) {
                                return x(d.value.date);
                            })
                            .y0(height)
                            .y1(function(d) {
                                return y(d.value.amount);
                            }),
                        svg = d3.select($element[0]).append("svg").attr("width", width).attr("height", height).append("g");

                    angular.forEach(axisData, function(data, index, source){
                        var target = data.value;
                        if (target.data[attr]) { // If data object uses custom key
                            target.amount = +target.data[attr];
                            target.amount.toFixed();
                        } else { // If data object uses value
                            target.amount = +target.data.value.toFixed(); //target.amount
                        }
                        target.date = parseDate(target.time);
                    });

                    // sort by date, its important, linechart need
                    axisData.sort(function (x, y) { return x['value']['date'] - y['value']['date'] })

                    x.domain(d3.extent(axisData, function(d) { return d.value.date; }));
                    y.domain(d3.extent(axisData, function(d) { return d.value.amount; }));

                    // line
                    svg.append("path").datum(axisData).attr("class", "area").attr("d", area);
                    svg.append("path").datum(axisData).attr("class", "line").attr("d", line);
                }

                $scope.$watch('data', function (aft, bef) {
                    linechart();
                }, true);

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
            // Loop through content, find options
            var templates = JSON.parse($scope.templates);
            var tmpls, refresh;
            angular.forEach(templates, function(data, index) {
                if(data.template === "countdown") {
                    tmpls = data.options;
                    refresh = data.refresh
                }
            });

            // Widget logic
            var oDate = tmpls,
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
            var delta = function() {
                // Get delta options
                var templates = JSON.parse($scope.templates);
                var tmpls, refresh, attr;
                angular.forEach(templates, function(data, index) {
                    if(data.template === "delta") {
                        tmpls = data.options;
                        refresh = data.refresh;
                        if(data.dataKey) {
                            attr = data.dataKey;
                        }
                    }
                });

                // Parse data to json
                var sData = JSON.parse($scope.data),
                    parseDate = d3.time.format("%Y-%m-%dT%H:%M:%SZ").parse; // Correct time formatting
                
                // format time
                angular.forEach(sData, function(data, index) {
                    data.value.time = parseDate(data.value.time);
                });

                // Order Information by date
                sData.sort(function(a, b) { return a['value']['time'] - b['value']['time'] });

                // Custom defined key?
                if(attr) {key = attr} else {key = 'value'}

                // Get first and last value
                var base = sData[0].value.data[key],
                    length = sData.length - 1,
                    current = sData[length].value.data[key],
                    diff = ((current / base) * 100);

                // Determine status
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

                // Place data into scope
                $scope.delta = {
                    'difference' : diff + "%",
                    'direction' : dir,
                    'status' : status
                }                
            }

            $scope.$watch('data', function (aft, bef) {
                delta();
            }, true); 

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
            // Loop through content, find options
            var templates = JSON.parse($scope.templates);
            var tmpls, refresh, attr;
            angular.forEach(templates, function(data, index) {
                if(data.template === "sum") {
                    tmpls = data.options;
                    refresh = data.refresh;
                    if(data.dataKey) {
                        attr = data.dataKey;
                    }
                }
            });

            // Widget Logic
            var sum = function() {
                // Data -> JSON, set vars.
                var sData = JSON.parse($scope.data),
                    append = tmpls.append,
                    prepend = tmpls.prepend,
                    sub = tmpls.subtitle,
                    total = 0;

                // If custom key
                if(attr) {key = attr;} else {key = 'value'}

                // Addition is fun!
                angular.forEach(sData, function(data, index, source){
                    total += data.value.data[key];
                });

                // Set data to scope
                total = Number(total, prepend, append);
                $scope.sum = total;
                $scope.sub = sub;
            }

            $scope.$watch('data', function (aft, bef) {
                sum();
            }, true);

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
        controller: function($scope, $element, $timeout, sortTime) {
            // Loop through content, find options
            var templates = JSON.parse($scope.templates);
            var tmpls, refresh, attr;
            angular.forEach(templates, function(data, index) {
                if(data.template === "list") {
                    tmpls = data.options;
                    refresh = data.refresh;
                    if(data.dataKey) {
                        attr = data.dataKey;
                    }
                }
            });

            // Widget Logic
            var list = function() {
                var sData = JSON.parse($scope.data),
                nLimit = parseInt(tmpls.limit),
                parseDate = d3.time.format("%Y-%m-%dT%H:%M:%SZ").parse;

                if(attr) {key = attr;} else {key = 'value'}

                var array = [];
                angular.forEach(sData, function(data, index) {
                    if (data.value.time !== undefined) {
                        data.value.data.since = moment(data.value.time).fromNow();
                        data.value.time = parseDate(data.value.time);
                    };
                    array.push(data.value);
                });

                // Show status icons if builds, img if not
                $scope.builds = false;
                if (sData[0].value.data.status !== undefined) {
                    $scope.builds = true;
                };

                array.sort(function (x, y) { return y['time'] - x['time'] })

                // Data into scope
                if (nLimit) {   // if has limit attr
                    $scope.list = array.splice(0, nLimit);
                } else {
                    $scope.list = array;
                }
            };

            $scope.$watch('data', function() {
                list();
            }, true);

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
            // Loop through content, find countdown options
            var templates = JSON.parse($scope.templates);
            var tmpls, refresh;
            angular.forEach(templates, function(data, index) {
                if(data.template === "announcement") {
                    tmpls = data.options;
                    refresh = data.refresh
                }
            });

            // Widget Logic
            $scope.announcement = tmpls.announcement;
            $scope.sub = tmpls.subtitle;     
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
            var picture = function() {
                var sData = JSON.parse($scope.data)
                angular.forEach(sData, function(data) {
                    var parseDate = d3.time.format("%Y-%m-%dT%H:%M:%SZ").parse;
                    data.value.time = parseDate(data.value.time);
                });
                sData.sort(function(a, b) { return b['value']['time'] - a['value']['time'] });
                image = sData[0].value.data.image;
                $scope.imageUrl = image;
            }

            $scope.$watch('data', function() {
                picture();
            }, true);

        }
    }
})

// Clock directive
.directive('clock', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
        },
        controller: function($scope, $element, $timeout) {
            $timeout(function () {
                var fields, width, height, offSetX, offSetY, pi, scaleSecs, scaleMins, scaleHours, vis, clockGroup, render;

                fields = function() {
                    var currentTime, hour, minute, second;
                    currentTime = new Date();
                    second = currentTime.getSeconds();
                    minute = currentTime.getMinutes() + second / 60;
                    hour = currentTime.getHours() + minute / 60;
                    return data = [
                        {
                            "unit": "seconds",
                            "numeric": second
                        },
                        {
                            "unit": "minutes",
                            "numeric": minute
                        },
                        {
                            "unit": "hours",
                            "numeric": hour
                        }
                    ];
                };

                // config
                width = $element.width();
                height = $element.height();
                offSetX = 125;
                offSetY = 100;

                pi = Math.PI;
                scaleSecs = d3.scale.linear().domain([0, 59 + 999/1000]).range([0, 2 * pi]);
                scaleMins = d3.scale.linear().domain([0, 59 + 59/60]).range([0, 2 * pi]);
                scaleHours = d3.scale.linear().domain([0, 11 + 59/60]).range([0, 2 * pi]);

                // Append clockGroup
                vis = d3.select($element[0])
                    .append("svg:svg")
                    .attr("width", width)
                    .attr("height", height);

                clockGroup = vis.append("svg:g")
                    .attr("transform", "translate(" + offSetX + "," + offSetY + ")");

                clockGroup.append("svg:circle")
                    .attr("r", 80).attr("fill", "none")
                    .attr("class", "clock outercircle")
                    .attr("stroke", "rgba(184, 179, 255, 0.5)")
                    .attr("stroke-width", 2);

                clockGroup.append("svg:circle")
                    .attr("r", 4)
                    .attr("fill", "#b8b3ff")
                    .attr("class", "clock innercircle");

                // render clockHands
                render = function(data) {
                    var hourArc, minuteArc, secondArc;

                    clockGroup.selectAll(".clockhand").remove();

                    secondArc = d3.svg.arc().innerRadius(0).outerRadius(70)
                        .startAngle(function(d) { return scaleSecs(d.numeric); })
                        .endAngle(function(d) { return scaleSecs(d.numeric); });

                    minuteArc = d3.svg.arc().innerRadius(0).outerRadius(70)
                        .startAngle(function(d) { return scaleMins(d.numeric); })
                        .endAngle(function(d) { return scaleMins(d.numeric); });

                    hourArc = d3.svg.arc().innerRadius(0).outerRadius(50)
                        .startAngle(function(d) { return scaleHours(d.numeric % 12); })
                        .endAngle(function(d) { return scaleHours(d.numeric % 12); });

                    clockGroup.selectAll(".clockhand")
                        .data(data)
                        .enter()
                        .append("svg:path")
                        .attr("d", function(d) {
                            if (d.unit === "seconds") {
                                return secondArc(d);
                            } else if (d.unit === "minutes") {
                                return minuteArc(d);
                            } else if (d.unit === "hours") {
                                return hourArc(d);
                            }
                        })
                        .attr("class", "clockhand")
                        .attr("stroke", "#b8b3ff")
                        .attr("stroke-width", function(d) {
                            if (d.unit === "seconds") {
                                return 2;
                            } else if (d.unit === "minutes") {
                                return 3;
                            } else if (d.unit === "hours") {
                                return 3;
                            }
                        })
                        .attr("fill", "none");
                };

                // render the clock
                render(fields());
                // and keep it ticking
                setInterval(function() {
                    render(fields());
                }, 1000);

            }, 0) //$timeout
        }
    };
})

//Gauge directive
.directive('gauge', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            data: '@',
            templates: '@'
        },
        controller: function($scope, $element, $timeout) {
            $timeout(function () {
                // Loop through content, find countdown options
                var templates = JSON.parse($scope.templates);
                var tmpls, refresh;
                angular.forEach(templates, function(data, index) {
                    if(data.template === "gauge") {
                        tmpls = data.options;
                        refresh = data.refresh
                    }
                });

                var powerGauge,
                    sData = JSON.parse($scope.data),
                    gauge = function(configuration) {
                        var that = {},
                            config = {
                                size                     : ($element.width() - 20),
                                clipWidth                : $element.width(),
                                clipHeight               : $element.height()/1.5,
                                ringInset                : 20,
                                ringWidth                : 40,
                                pointerWidth             : 10,
                                pointerTailLength        : 5,
                                pointerHeadLengthPercent : 0.9,
                                
                                minValue                 : tmpls.min || 0,
                                maxValue                 : tmpls.max || 1000,

                                minAngle                 : -90,
                                maxAngle                 : 90, 

                                transitionMs             : 3500,
                                majorTicks               : 5,
                                labelFormat              : d3.format(',g'),
                                labelInset               : 10,
                                arcColorFn               : d3.interpolateHsl(d3.rgb('#AEAEFF'), d3.rgb('#383872'))
                            },
                            range, r, pointerHeadLength, svg, arc, scale, ticks, tickData, pointer,
                            value = 0,
                            donut = d3.layout.pie(),
                            deg2rad = function(deg) {
                                return deg * Math.PI / 180;
                            },
                            newAngle = function(d) {
                                var newAngle = config.minAngle + (scale(d) * range);
                                return newAngle;
                            },
                            configure = function(configuration) {
                                var prop = undefined;

                                for ( prop in configuration ) {
                                    config[prop] = configuration[prop];
                                }

                                range = config.maxAngle - config.minAngle;
                                r = config.size / 2;
                                pointerHeadLength = Math.round(r * config.pointerHeadLengthPercent);

                                // a linear scale that maps domain values to a percent from 0..1
                                scale = d3.scale.linear()
                                    .range([0,1])
                                    .domain([config.minValue, config.maxValue]);

                                ticks = scale.ticks(config.majorTicks);
                                tickData = d3.range(config.majorTicks).map(function() {return 1/config.majorTicks;});

                                arc = d3.svg.arc()
                                    .innerRadius(r - config.ringWidth - config.ringInset)
                                    .outerRadius(r - config.ringInset)
                                    .startAngle(function(d, i) {
                                        var ratio = d * i;
                                        return deg2rad(config.minAngle + (ratio * range));
                                    })
                                    .endAngle(function(d, i) {
                                        var ratio = d * (i+1);
                                        return deg2rad(config.minAngle + (ratio * range));
                                    });
                            },
                            centerTranslation = function() {
                                return 'translate('+r +','+ r +')';
                            },
                            isRendered = function() {
                                return (svg !== undefined);
                            },
                            render = function(newValue) {
                                svg = d3.select($element[0])
                                    .append('svg:svg')
                                        .attr('class', 'gauge')
                                        .attr('width', config.clipWidth)
                                        .attr('height', config.clipHeight);

                                var centerTx = centerTranslation();

                                var arcs = svg.append('g')
                                        .attr('class', 'arc')
                                        .attr('transform', centerTx);

                                arcs.selectAll('path')
                                        .data(tickData)
                                    .enter().append('path')
                                        .attr('fill', function(d, i) {
                                            return config.arcColorFn(d * i);
                                        })
                                        .attr('d', arc);

                                var lg = svg.append('g')
                                        .attr('class', 'label')
                                        .attr('transform', centerTx);
                                lg.selectAll('text')
                                        .data(ticks)
                                    .enter().append('text')
                                        .attr('transform', function(d) {
                                            var ratio = scale(d);
                                            var newAngle = config.minAngle + (ratio * range);
                                            return 'rotate(' +newAngle +') translate(0,' +(config.labelInset - r) +')';
                                        })
                                        .text(config.labelFormat);

                                var lineData = [ [config.pointerWidth / 2, 0], 
                                                [0, -pointerHeadLength],
                                                [-(config.pointerWidth / 2), 0],
                                                [0, config.pointerTailLength],
                                                [config.pointerWidth / 2, 0] ];
                                var pointerLine = d3.svg.line().interpolate('monotone');
                                var pg = svg.append('g').data([lineData])
                                        .attr('class', 'pointer')
                                        .attr('transform', centerTx);

                                pointer = pg.append('path')
                                    .attr('d', pointerLine/*function(d) { return pointerLine(d) +'Z';}*/ )
                                    .attr('transform', 'rotate(' +config.minAngle +')');

                                update(newValue === undefined ? 0 : newValue);
                            },
                            update = function(newValue, newConfiguration) {
                                if ( newConfiguration  !== undefined) {
                                    configure(newConfiguration);
                                }
                                var ratio = scale(newValue);
                                var newAngle = config.minAngle + (ratio * range);
                                pointer.transition()
                                    .duration(config.transitionMs)
                                    .ease('elastic')
                                    .attr('transform', 'rotate(' +newAngle +')');
                            };

                        that.configure = configure;

                        that.isRendered = isRendered;
                       
                        that.render = render;
                        
                        that.update = update;

                        configure(configuration);
                        
                        return that;
                    };

                powerGauge = gauge();
                powerGauge.render();

                // Need to add sort by time!!
                $scope.$watch('data', function (aft, bef) {
                    var sData = JSON.parse(aft);
                    angular.forEach(sData, function(data) {
                        var parseDate = d3.time.format("%Y-%m-%dT%H:%M:%SZ").parse;
                        data.value.time = parseDate(data.value.time);
                    });
                    sData.sort(function(a, b) { return b['value']['time'] - a['value']['time'] });
                    powerGauge.update(sData[0].value.data.value);
                }, true);

            }, 0)           
        }
    }
});