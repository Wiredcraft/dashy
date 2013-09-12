// charts directives
angular.module('Dashboard.Blocks', [])

// linechart
.directive('linechart', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            templates: '@',
            data: '@'
        },
        template: '<div class="chart"><div class="y_axis"></div><div class="x_axis"></div></div>',
        controller: function($scope, $element, $timeout, Widgets, parseTime) {
            //Loop through content, find linechart options
            var templates = JSON.parse($scope.templates);
            var tmpls, refresh, source, attr;
            angular.forEach(templates, function(data, index) {
                if(data.template === "linechart") {
                    tmpls = data.options;
                    refresh = data.refresh;
                    source = data.source;
                    if(data.dataKey) {
                        attr = data.dataKey;
                    }
                }
            });

            var graph,
                maxSize = tmpls.points,
                pointName = 'Value';

            // Graph Initialize function
            var init = function (aData) {
                // select rickshaw color palette
                var palette = new Rickshaw.Color.Palette({ scheme: 'spectrum14' });

                // Graph Options
                graph = new Rickshaw.Graph({
                    element: $element[0],
                    renderer: 'line',
                    width: $element.width(),
                    height: $element.height(),
                    series: [{
                        color: palette.color(),
                        data: aData,
                        name: pointName
                    }],
                    interpolation: 'linear'
                });

                var x_ticks = new Rickshaw.Graph.Axis.X( {
                    graph: graph,
                    orientation: 'bottom',
                    element: $element.find('.x_axis')[0],
                    pixelsPerTick: 200,
                    tickFormat: function(time) {
                        // changes for python time format
                        return moment(time*1000).format('HH:mm:ss')
                    }
                });

                var y_ticks = new Rickshaw.Graph.Axis.Y( {
                    graph: graph,
                    orientation: 'left',
                    tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
                    element: $element.find('.y_axis')[0]
                });

                // Render All
                graph.render();
            }

            var formatData = function(x) {
                var y = [];
                angular.forEach(x, function(data, index) {
                    time = parseTime(data.value.time).getTime();
                    data.value.time = time / 1000; // Rickshaw uses s not ms
                    y.push({ 'x': data.value.time, 'y': data.value.data.value });
                });
                y.sort(function(a, z) { return a['x'] - z['x'] });
                if(y.length >= maxSize) {
                    y = y.slice(y.length - maxSize);
                }
                return y;
            }

            // Initialize Chart
            Widgets.getWidgetData(source).then(function(data) {
                data = formatData(data);
                init(data);
            });
            setInterval(function() {
                Widgets.getWidgetData(source).then(function(data) {
                    var upData = formatData(data);
                    angular.forEach(graph.series, function(series, index) {
                        series.data = upData
                    });
                    graph.update();
                })
            }, refresh)

        }
    }
})


// Countdown Directive
.directive('countdown', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            templates: '@'
        },
        templateUrl: 'blocks/block_templates/countdown.tpl.html',
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
            templates: '@'
        },
        templateUrl: 'blocks/block_templates/delta.tpl.html',
        controller: function($scope, $element, Widgets, parseTime) {
            // Get delta options
            var templates = JSON.parse($scope.templates);
            var tmpls, refresh, source, attr;
            angular.forEach(templates, function(data, index) {
                if(data.template === "delta") {
                    tmpls = data.options;
                    refresh = data.refresh;
                    source = data.source;
                    if(data.dataKey) {
                        attr = data.dataKey;
                    }
                }
            });

            var delta = function(data) {
                // Parse data to json
                var sData = data;
                
                // format time
                angular.forEach(sData, function(data, index) {
                    data.value.time = parseTime(data.value.time);
                });

                // Order Information by date
                sData.sort(function(a, b) { return a['value']['time'] - b['value']['time'] });

                // Custom defined key?
                if(attr) {key = attr} else {key = 'value'}

                // Data points to show all or user amount
                if(sData.length >= tmpls.points) {
                    sData = sData.slice(sData.length - tmpls.points)
                }

                // Get first and last value
                var base = sData[0].value.data[key],
                    length = sData.length - 1,
                    current = sData[length].value.data[key],
                    diff = ((current / base) * 100);

                // Determine status
                var status;
                if (diff > 100) {
                    dir = "+";
                    status = 'up';
                } else if (diff === 100) {
                    dir = "="
                    status = 'equal'
                } else {
                    dir = "-";
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

            Widgets.getWidgetData(source).then(function(data) {
                delta(data);
            })
            setInterval(function() {
                Widgets.getWidgetData(source).then(function(data) {
                    delta(data);
                })
            }, refresh)

        }
    };
})

// Sum Directive
.directive('sum', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            templates: '@'
        },
        templateUrl: 'blocks/block_templates/sum.tpl.html',
        controller: function($scope, $element, $timeout, Number, Widgets, parseTime) {
            // Loop through content, find options
            var templates = JSON.parse($scope.templates);
            var tmpls, refresh, source, attr;
            angular.forEach(templates, function(data, index) {
                if(data.template === "sum") {
                    tmpls = data.options;
                    refresh = data.refresh;
                    source = data.source;
                    if(data.dataKey) {
                        attr = data.dataKey;
                    }
                }
            });

            // Widget Logic
            var sum = function(data) {
                // Data -> JSON, set vars.
                var sData = data,
                    append = tmpls.append,
                    prepend = tmpls.prepend,
                    sub = tmpls.subtitle,
                    total = 0;

                // format time
                angular.forEach(sData, function(data, index) {
                    data.value.time = parseTime(data.value.time);
                });

                // sort by time
                sData.sort(function(a, z) { return a['x'] - z['x'] });

                // If custom key
                if(attr) {key = attr;} else {key = 'value'}

                // Data points to show all or user amount
                if(sData.length >= tmpls.points) {
                    sData = sData.slice(sData.length - tmpls.points)
                }                

                // Addition is fun!
                angular.forEach(sData, function(data, index, source){
                    total += data.value.data[key];
                });

                // Set data to scope
                total = Number(total, prepend, append);
                $scope.sum = total;
                $scope.sub = sub;
            }

            Widgets.getWidgetData(source).then(function(data) {
                sum(data);
            })
            setInterval(function() {
                Widgets.getWidgetData(source).then(function(data) {
                    sum(data);
                })
            }, refresh)

        }
    };
})

// List Directive
.directive('list', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            templates: '@'
        },
        templateUrl: 'blocks/block_templates/list.tpl.html',
        controller: function($scope, $element, $timeout, $compile, Widgets, parseTime) {
            // Loop through content, find options
            var templates = JSON.parse($scope.templates);
            var tmpls, refresh, source, attr;
            angular.forEach(templates, function(data, index) {
                if(data.template === "list") {
                    tmpls = data.options;
                    refresh = data.refresh;
                    source = data.source;
                    if(data.dataKey) {
                        attr = data.dataKey;
                    }
                }
            });

            // Widget Logic
            var list = function(data) {
                var sData = [];
                $scope.list = [];   

                sData = data,
                nLimit = parseInt(tmpls.limit);

                if(attr) {key = attr;} else {key = 'value'}

                $scope.class='error'; // error by default

                // Parse Date
                angular.forEach(sData, function(data, index) {
                    data.value.since = moment(data.value.time, 'YYYY-MM-DDThh:mm:ssZ').fromNow();                    
                    data.value.time = parseTime(data.value.time);
                });

                // Most recent at top
                sData.sort(function(a, b) { return b['value']['time'] - a['value']['time'] });

                // Limit list to user given limit
                if(sData.length >= nLimit) {
                    sData = sData.slice(0, nLimit)
                }     

                // If data has img info, use it!
                // BUG WITH IMAGES HERE!!! TO FIX (list template <img> commented out for now)
                if(sData[0].value.data.image !== undefined) {
                    $scope.class = 'image';
                    $scope.image = true;
                } else {
                    $scope.class = 'status';
                }

                // Slap data into the scope
                angular.forEach(sData, function(data, index) {
                    $scope.list.push(data);
                });
            };

            // Start widget
            Widgets.getWidgetData(source).then(function(data) {
                list(data);
            })
            // Keep widget updated
            setInterval(function() {
                Widgets.getWidgetData(source).then(function(data) {
                    list(data);
                })
            }, refresh)

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

// New Gauge directive
.directive('gauge', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            templates: '@'
        },
        controller: function($scope, $element, $timeout, Widgets, parseTime) {
            $timeout(function() {
                // Loop through content, find gauge options
                var templates = JSON.parse($scope.templates);
                var tmpls, refresh, source, attr;
                angular.forEach(templates, function(data, index) {
                    if(data.template === "gauge") {
                        tmpls = data.options;
                        refresh = data.refresh;
                        source = data.source;
                        if(data.dataKey) {
                            attr = data.dataKey;
                        }
                    }
                });
                
                // Set Up
                var pi = Math.PI,
                    width = $element.width(),
                    height = $element.height();

                var iR = (width/2) - 50;
                var oR = (width/2) - 10;

                var color = 'rgba(41, 128, 185, 1)';

                var max = tmpls.max || 100, // get max possible or make 100 (for percents)
                    min = tmpls.min || 0, // get min or 0 for default
                    current = 0;

                // Arc Defaults
                var arc = d3.svg.arc()
                    .innerRadius(iR)
                    .outerRadius(oR)
                    .startAngle(-90 * (pi/180))

                // Place svg element
                var svg = d3.select($element[0]).append("svg")
                    .attr("width", width)
                    .attr("height", height)
                    .append("g")
                    .attr("transform", "translate(" + width / 2 + "," + height / 1.4 + ")")

                // Append background arc to svg
                var background = svg.append("path")
                    .datum({endAngle: 90 * (pi/180)})
                    .style("fill", "rgba(106, 106, 106, 0.2)")
                    .attr("d", arc);

                // Append foreground arc to svg
                var foreground = svg.append("path")
                    .datum({endAngle: -90 * (pi/180)})
                    .style("fill", color)
                    .attr("d", arc);

                // Display Max value
                var maxText = svg.append("text")
                    .attr("transform", "translate("+ (iR + ((oR - iR)/2)) +",15)") // Set between inner and outer Radius
                    .attr("text-anchor", "middle")
                    .style("font-family", "Helvetica")
                    .style("fill", "grey")
                    .text(max)

                // Display Min value
                var minText = svg.append("text")
                    .attr("transform", "translate("+ -(iR + ((oR - iR)/2)) +",15)") // Set between inner and outer Radius
                    .attr("text-anchor", "middle")
                    .style("font-family", "Helvetica")
                    .style("fill", "grey")
                    .text(min)

                // Display Current value
                var current = svg.append("text")
                    .attr("text-anchor", "middle")
                    .style("font-family", "Helvetica")
                    .style("fill", "rgb(211, 212, 212)")
                    .style("font-size", "50")
                    .text(current)

                // Animation function
                function arcTween(transition, newAngle) {
                  transition.attrTween("d", function(d) {
                    var interpolate = d3.interpolate(d.endAngle, newAngle);
                    return function(t) {
                      d.endAngle = interpolate(t);
                      return arc(d);
                    };
                  });
                }

                // Update logic
                function gaugeUpdate(x) {
                    angular.forEach(x, function(data, key){
                        data.value.time = parseTime(data.value.time);
                    });
                    x.sort(function(a, z) { return z['value']['time'] - a['value']['time'] });
                    cVal = x[0].value.data.value;
                    gVal = ((cVal * 180) / max);
                    gVal = (gVal - 90) * (pi/180);

                    // If value too large, only animate to full gauge, not over
                    if(gVal > 1.5707963267948966) { gVal = 1.5707963267948966 };
                    
                    // Update Gauge
                    foreground.transition()
                        .duration(700)
                        .call(arcTween, gVal)
                    current.transition()
                        .text(cVal)
                    return;
                }

                // Start widget
                Widgets.getWidgetData(source).then(function(data) {
                    gaugeUpdate(data);
                })
                // Widget updating
                setInterval(function() {
                    Widgets.getWidgetData(source).then(function(data) {
                        gaugeUpdate(data);
                    })
                }, refresh)

            }, 0);
        }
    };
})

// Markdown directive
.directive('markdown', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            templates: '@'
        },
        controller: function($scope, $element, $compile, Widgets) {
            // Loop through content, find gauge options
            var templates = JSON.parse($scope.templates);
            var tmpls, refresh, source, attr;
            angular.forEach(templates, function(data, index) {
                if(data.template === "markdown") {
                    tmpls = data.options;
                    refresh = data.refresh;
                    source = data.source;
                }
            });

            // Prep showdown converter
            var converter = new Showdown.converter();

            // Markdown logic
            var markdown = function(mdData) {
                var html = converter.makeHtml(mdData)
                $element.replaceWith($compile(html)($scope))
            }
            markdown(tmpls.markdown)
        }
    }
})