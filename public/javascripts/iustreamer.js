
Event.observe(window, 'load', function() {
    var fade=setTimeout("fadeout()",3500);
    var hide=setTimeout("$('mensaje').hide()",4800);
});
function fadeout(){
    new Effect.Opacity("mensaje", {duration:1.5, from:1.0, to:0.0});
}

