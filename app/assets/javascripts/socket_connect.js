function socketConnect() {
    var socket = new WebSocket("ws://localhost:3000/connect");
    socket.onopen = function() {
        console.log("onopen")
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
        var responseObject = JSON.parse(event.data) ;
        console.log(responseObject);
        if (responseObject.redirect == "true") {
            $.ajax({
                url: responseObject.redirect_url,
                type: "GET",
                dataType: 'script',
                error: function() {
                    alert('Что-то пошло не так')
                },
                success: function() {console.log("success")}
            });
        };
    };

    socket.onerror = function(error) {
        alert("Ошибка " + error.message);
    };
    // Make the function wait until the connection is made...

    function connection() {
        return socket;
    }

    connection.send_message = function(msg){
        // Wait until the state of the socket is not ready and send the message when it is...
        waitForSocketConnection(socket, function(){
            console.log("message sent!!!");
            socket.send(msg);
        });
    }

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

            },
            5); // wait 5 milisecond for the connection...
    }

    connection.close = function() {
        socket.close();
    }

    connection.reset = function(){
        socketConnect();
    }

    connection.ready_state = function(){
        return socket.readyState;
    }

    connection.wait_for_socket_connection = function(callback){
        waitForSocketConnection(socket, callback)
    }

    window.currentSocketConnection = connection;
    return connection;
};


function getCurrentConnection(){
    return window.currentSocketConnection;
};









