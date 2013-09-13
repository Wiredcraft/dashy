showDistance = 50;

$(document).ready(function() {
    $("#menu").hide();
});

function showNavBar() {
    $("#menu").show('slow', 'linear');
};

$(document).mousemove(function(ev) {
    var ev = ev || window.event;
    if(ev.pageX <= showDistance) {
        showNavBar()
    } else if (ev.pageX > showDistance) {
        $("#menu").hide('slow', 'linear');
    }
});