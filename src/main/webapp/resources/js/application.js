$(function () {
    "use strict";


    var socket = atmosphere;
    var subSocket;
    var transport = 'websocket';
    
    //Sub account ID
    var clientID	=	window.CLIENT_ID;
    var serverUrl	=	window.RTS_IP;
    var serverUrlStatus	=	window.RTS_STATUS;
    // We are now ready to cut the request
    //46.10
    //var request = { url: 'http:10.0.46.10:8083/push/eqt/notification/' + clientID,
    
    //45.150
    //var request = { url: 'http:10.0.45.150:8083/push/eqt/notification/' + clientID,
    		
    //test.masvn.com
    var request = { url: serverUrlStatus + 'push/eqt/notification/' + clientID,
        contentType : "application/json",
        logLevel : 'debug',
        transport : transport ,
        trackMessageLength : true,
        reconnectInterval : 5	
    };
    
    request.onOpen = function(response) {
        //content.html($('<p>', { text: 'Atmosphere connected using ' + response.transport }));
        //input.removeAttr('disabled').focus();
        //status.text('Choose name:');
        transport = response.transport;
        //console.log("da ket noi den server");

        // Carry the UUID. This is required if you want to call subscribe(request) again.
        request.uuid = response.request.uuid;
    };

//    request.onClientTimeout = function(r) {
//        content.html($('<p>', { text: 'Client closed the connection after a timeout. Reconnecting in ' + request.reconnectInterval }));
//        subSocket.push(atmosphere.util.stringifyJSON({ author: author, message: 'is inactive and closed the connection. Will reconnect in ' + request.reconnectInterval }));
//        input.attr('disabled', 'disabled');
//        setTimeout(function (){
//            subSocket = socket.subscribe(request);
//        }, request.reconnectInterval);
//    };

//    request.onReopen = function(response) {
//        input.removeAttr('disabled').focus();
//        content.html($('<p>', { text: 'Atmosphere re-connected using ' + response.transport }));
//    };

    // For demonstration of how you can customize the fallbackTransport using the onTransportFailure function
//    request.onTransportFailure = function(errorMsg, request) {
//        atmosphere.util.info(errorMsg);@Ready
//        request.fallbackTransport = "long-polling";
//        header.html($('<h3>', { text: 'Atmosphere Chat. Default transport is WebSocket, fallback is ' + request.fallbackTransport }));
//    };

    request.onMessage = function (response) {

    //console.log("server da gui 1 tin nhan: ",response, response.responseBody);
	//alert(JSON.stringify(response.responseBody));
	//subSocket.push(atmosphere.util.stringifyJSON({ author: 'abc', message: '123' }));
        subscribedCallback(response.responseBody);
    };
 	request.onClose = function(response){
		
		console.log('on closed')		
	}

//    request.onClose = function(response) {
//        content.html($('<p>', { text: 'Server closed the connection after a timeout' }));
//        if (subSocket) {
//            subSocket.push(atmosphere.util.stringifyJSON({ author: author, message: 'disconnecting' }));
//        }
//        input.attr('disabled', 'disabled');
//    };

//    request.onError = function(response) {
//        content.html($('<p>', { text: 'Sorry, but there\'s some problem with your '
//            + 'socket or the server is down' }));
//        logged = false;
//    };

//    request.onReconnect = function(request, response) {
//        content.html($('<p>', { text: 'Connection lost, trying to reconnect. Trying to reconnect ' + request.reconnectInterval}));
//        input.attr('disabled', 'disabled');
//    };
    
    
    // Kết nối đến server và gọi method có annotation @Ready bên server
    subSocket = socket.subscribe(request); 
	
	
    
    

//    input.keydown(function(e) {
//        if (e.keyCode === 13) {
//            var msg = $(this).val();
//
//            // First message is always the author's name
//            if (author == null) {
//                author = msg;
//            }
//
//            subSocket.push(atmosphere.util.stringifyJSON({ author: author, message: msg }));
//            $(this).val('');
//
//            input.attr('disabled', 'disabled');
//            if (myName === false) {
//                myName = msg;
//            }
//        }
//    });

//    function addMessage(author, message, color, datetime) {
//        content.append('<p><span style="color:' + color + '">' + author + '</span> @ ' +
//            + (datetime.getHours() < 10 ? '0' + datetime.getHours() : datetime.getHours()) + ':'
//            + (datetime.getMinutes() < 10 ? '0' + datetime.getMinutes() : datetime.getMinutes())
//            + ': ' + message + '</p>');
//    }
});
