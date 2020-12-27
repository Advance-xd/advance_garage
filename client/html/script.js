var inMenu = false
let carselect = null
$('#general, #waiting, #sellUI, #allUI, #buyUI, #topbar').hide();

$(function() {
    addEventListener('message', function(event) {
        if(event.data.type == "open") {
            $("#all tbody").empty();
            $("#all thead").empty();
            $("#all tbody").hide();
            $('#general, #topbar').show();
            
            
        } else if(event.data.type == "car") {
            
            $('#all thead').append(`
                    <tr>
                        <th>${event.data.cars}</th>
                        <th>${event.data.plate}</th>
                        <td>
                            <input type="button"
                            class=""
                            value="Ta fram" 
                            onclick="spawn('${event.data.spawn}','${event.data.cars}','${event.data.plate}')"/>

                        </td>

                    </tr>`)
            /*$('#all tbody').append(`
                    <tr>
                        <th>${event.data.cars}</th>
                        <th>99.9</th>
                        <th>69</th>
                    </tr>`)*/
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

$('#close').click(function() {
    close()

})

$('#selectcar').click(function() {
    console.log('yeet')

})

function spawn(carr, names, platte) {
    close()
    $.post('http://advance_garage/spawnveh', JSON.stringify({veh: carr, name: names, plate: platte}));
}

/*<td>
<div class="svg-wrapper">
    <svg height="40" width="150" xmlns="http://www.w3.org/2000/svg">
        <rect id="shape" height="40" width="150" />
        <div id="text">
        <input height="1000" type="button"
                class=""
            value="submit" 
            onclick="test()">
        </div>
    </svg>
</td>
</div>*/