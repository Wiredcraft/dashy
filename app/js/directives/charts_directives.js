// charts directives
angular.module('Dashboard.Charts', [])

// linechart directive
// .directive('linechart', function() {
//     return {
//         restrict: 'E',
//         replace: true,
//         scope: {
//             templates: '@'
//         },
//         controller: function($scope, $element, $timeout, Widgets) {
//             $timeout(function () {
//                 // Loop through content, find linechart options
//                 var templates = JSON.parse($scope.templates);
//                 var tmpls, refresh, source, attr;
//                 angular.forEach(templates, function(data, index) {
//                     if(data.template === "linechart") {
//                         tmpls = data.options;
//                         refresh = data.refresh;
//                         source = data.source;
//                         if(data.dataKey) {
//                             attr = data.dataKey;
//                         }
//                     }
//                 });

//                 var linechart = function(data) {
//                     // Remove old graph, replace with new graph
//                     angular.element($element[0]).children().remove();

//                     var axisData = data,
//                         width = $element.width(),
//                         height = $element.height(),
//                         // parseDate = d3.time.format("%d-%b-%y").parse, // date format like this '28-Mar-12'
//                         parseDate = d3.time.format("%Y-%m-%dT%H:%M:%SZ").parse, // date format like "2013-08-14T19:23:45Z" 
//                         x = d3.time.scale().range([0, width]),
//                         y = d3.scale.linear().range([height, 0]),
//                         xAxis = d3.svg.axis().scale(x).orient("bottom"),
//                         yAxis = d3.svg.axis().scale(y).orient("left"),
//                         line = d3.svg.line()
//                             .x(function(d) { 
//                                 return x(d.value.date); 
//                             })
//                             .y(function(d) { 
//                                 return y(d.value.amount);
//                             }),
//                         area = d3.svg.area()
//                             .x(function(d) {
//                                 return x(d.value.date);
//                             })
//                             .y0(height)
//                             .y1(function(d) {
//                                 return y(d.value.amount);
//                             }),
//                         svg = d3.select($element[0]).append("svg").attr("width", width).attr("height", height).append("g");

//                     angular.forEach(axisData, function(data, index, source){
//                         var target = data.value;
//                         if (target.data[attr]) { // If data object uses custom key
//                             target.amount = +target.data[attr];
//                             target.amount.toFixed();
//                         } else { // If data object uses value
//                             target.amount = +target.data.value.toFixed(); //target.amount
//                         }
//                         target.date = parseDate(target.time);
//                     });

//                     // sort by date, its important, linechart need
//                     axisData.sort(function (x, y) { return x['value']['date'] - y['value']['date'] })

//                     x.domain(d3.extent(axisData, function(d) { return d.value.date; }));
//                     y.domain(d3.extent(axisData, function(d) { return d.value.amount; }));

//                     // line
//                     svg.append("path").datum(axisData).attr("class", "area").attr("d", area);
//                     svg.append("path").datum(axisData).attr("class", "line").attr("d", line);
//                 }

//                 Widgets.getWidgetData(source).then(function(data) {
//                     linechart(data);
//                 })
//                 setInterval(function() {
//                     Widgets.getWidgetData(source).then(function(data) {
//                         linechart(data);
//                     })
//                 }, refresh)

//             }, 0)
//         }
//     };
// })

//Rickshaw Chart
.directive('linechart', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            templates: '@',
            data: '@'
        },
        controller: function($scope, $element, $timeout, Widgets) {
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
                maxSize = 20,
                pointName = 'Value',
                parseDate = d3.time.format("%Y-%m-%dT%H:%M:%SZ").parse;

            // Graph Initialize function
            var init = function (aData) {
                // select rickshaw color palette
                var palette = new Rickshaw.Color.Palette({ scheme: 'spectrum14' });

                // Graph Options
                graph = new Rickshaw.Graph({
                    element: $element[0],
                    renderer: 'area',
                    width: $element.width(),
                    height: $element.height(),
                    series: [{
                        color: palette.color(),
                        data: aData,
                        name: pointName
                    }]
                });

                // Hover Effect
                // var hoverDetail = new Rickshaw.Graph.HoverDetail({
                //     graph: graph
                // });

                // Display X Axis
                var xAxis = new Rickshaw.Graph.Axis.Time({
                    graph: graph
                });

                // Display Y Axis
                var yAxis = new Rickshaw.Graph.Axis.Y({
                    graph: graph
                });

                // Render All
                graph.render();

                // xAxis.render();
                // yAxis.render();
            }

            var formatData = function(x) {
                var y = [];
                angular.forEach(x, function(data, index) {
                    time = parseDate(data.value.time).getTime();
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
            templates: '@'
        },
        templateUrl: 'templates/delta.html',
        controller: function($scope, $element, Widgets) {
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
                var sData = data,
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
        templateUrl: 'templates/sum.html',
        controller: function($scope, $element, $timeout, Number, Widgets) {
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
        templateUrl: 'templates/list.html',
        controller: function($scope, $element, $timeout, $compile, Widgets, SortTime) {
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
                nLimit = parseInt(tmpls.limit),
                parseDate = d3.time.format("%Y-%m-%dT%H:%M:%SZ").parse;

                if(attr) {key = attr;} else {key = 'value'}

                $scope.class='error'; // error by default

                // Parse Date
                angular.forEach(sData, function(data, index) {
                    data.value.since = moment(data.value.time, 'YYYY-MM-DDThh:mm:ssZ').fromNow();
                    data.value.time = parseDate(data.value.time);
                });

                // Most recent at top
                sData.sort(function(a, b) { return b['value']['time'] - a['value']['time'] });

                // If data has img info, use it!
                // BUG WITH IMAGES HERE!!! TO FIX (list template <img> commented out for now)
                if(sData[0].value.data.image !== undefined) {
                    $scope.class = 'image';
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

// Announcement Directive
.directive('announcement', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            templates: '@'
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
            templates: '@'
        },
        templateUrl: 'templates/picture.html',
        controller: function($scope, $element, Widgets) {
            // Loop through content, find options
            var templates = JSON.parse($scope.templates);
            var tmpls, refresh, source, attr;
            angular.forEach(templates, function(data, index) {
                if(data.template === "picture") {
                    tmpls = data.options;
                    refresh = data.refresh;
                    source = data.source;
                    if(data.dataKey) {
                        attr = data.dataKey;
                    }
                }
            });

            var picture = function(data) {
                var sData = data;
                angular.forEach(sData, function(data) {
                    var parseDate = d3.time.format("%Y-%m-%dT%H:%M:%SZ").parse;
                    data.value.time = parseDate(data.value.time);
                });
                sData.sort(function(a, b) { return b['value']['time'] - a['value']['time'] });
                image = sData[0].value.data.image;
                $scope.imageUrl = image;
            }

            Widgets.getWidgetData(source).then(function(data) {
                picture(data);
            })
            setInterval(function() {
                Widgets.getWidgetData(source).then(function(data) {
                    picture(data);
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
        controller: function($scope, $element, $timeout, Widgets) {
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

                var color = 'rgba(184, 179, 255, 1)';

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
                    .style("fill", "rgba(184, 179, 255, 0.1)")
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

                var parseDate = d3.time.format("%Y-%m-%dT%H:%M:%SZ").parse;

                var gaugeUpdate = function(x) {
                    angular.forEach(x, function(data, key){
                        data.value.time = parseDate(data.value.time);
                    });
                    x.sort(function(a, z) { return z['value']['time'] - a['value']['time'] });
                    cVal = x[0].value.data.value;
                    gVal = ((cVal * 180) / max);
                    gVal = (gVal - 90) * (pi/180);

                    // If value too large, only animate to full gauge, not over
                    if(gVal > 1.5707963267948966) { gVal = 1.5707963267948966 };
                    
                    // Update Gauge
                    current.transition()
                        .text(cVal)
                    foreground.transition()
                        .duration(700)
                        .call(arcTween, gVal);
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

                // Update animation
                function arcTween(transition, newAngle) {
                  transition.attrTween("d", function(d) {
                    var interpolate = d3.interpolate(d.endAngle, newAngle);
                    return function(t) {
                      d.endAngle = interpolate(t);
                      return arc(d);
                    };
                  });
                }


            }, 0);
        }
    };
})