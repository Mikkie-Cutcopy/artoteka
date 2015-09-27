//$(document).ready(function () {
    var socket = new WebSocket("ws://localhost:3000/message");

    socket.onopen = function() {
        alert("Соединение установлено.");
    };

    socket.onclose = function(event) {
        if (event.wasClean) {
            alert('Соединение закрыто чисто');
        } else {
            alert('Обрыв соединения'); // например, "убит" процесс сервера
        }
        alert('Код: ' + event.code + ' причина: ' + event.reason);
    };

    socket.onmessage = function(event) {
        alert("Получены данные " + event.data);
    };

    socket.onerror = function(error) {
        alert("Ошибка " + error.message);
    };


    function sendMessage(msg){
        // Wait until the state of the socket is not ready and send the message when it is...
        waitForSocketConnection(socket, function(){
            console.log("message sent!!!");
            socket.send(msg);
        });
    }

// Make the function wait until the connection is made...
    function waitForSocketConnection(socket, callback){
        setTimeout(
            function () {
                if (socket.readyState === 1) {
                    console.log("Connection is made")
                    if(callback != null){
                        callback();
                    }
                    return;

                } else {
                    console.log("wait for connection...")
                    waitForSocketConnection(socket, callback);
                }

            }, 5); // wait 5 milisecond for the connection...
    }
    sendMessage("Hello world");
//})


