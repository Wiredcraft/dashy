showDistance = 50;
animateSpeed = 200 //ms

$(document).ready(function() {
    $("#menu").hide();
});

function showNavBar() {
    $("#menu").show(animateSpeed, 'linear');
};

$(document).mousemove(function(ev) {
    var ev = ev || window.event;
    if(ev.pageX <= showDistance) {
        showNavBar()
    } else if (ev.pageX > showDistance) {
        $("#menu").hide(animateSpeed, 'linear');
    }
});