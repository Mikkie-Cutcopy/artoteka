/**
 * Created by mikkie on 06.12.15.
 */
$(document).on('click', '#new_room_connect', submitAfterConnect)
$(document).on('click', '#new_session', socketConnect)

function submitAfterConnect(){
    var connection = socketConnect();
    connection.wait_for_socket_connection(function(){
        $('#new_room_submit').submit();
    })
};
