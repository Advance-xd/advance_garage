var inMenu = false


$(function() {
    addEventListener('message', function(event) {
        if(event.data.type == "open") {
            $('#general').hide();
            var array = event.data.cars
            for (var e in array) {
                var obj = array[e];


                $('#all tbody').append(`
                    <tr>
                        <th>Grafikkort ${obj}</th>
                        <th>99.9</th>
                        <th>69</th>
                    </tr>`)
            }
            
        }
        
        


    });
});

document.onkeyup = function(data){
    if (data.which == 27){
        close();
    }
}

function close() {
    $('#general, #waiting, #sellUI, #allUI, #buyUI, #topbar').hide();
    $('body').removeClass("active");
    $.post('http://advance_garage/close', "{}");
}