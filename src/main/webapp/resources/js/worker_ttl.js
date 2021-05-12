//출처: http://micropilot.tistory.com/2462 []
//var window = self;

/*

  The Worker: WorkerGlobalScope

  Inside the worker, the keywords "self" and "this"
  are the same thing and both are the equivalent
  to the global WorkerGlobalScope

*/

//importScripts('jquery-1.10.2.min.js');
//console.log("JQuery version:", $.fn.jquery);


onmessage = function(msg) { 
	console.log('Start of Worker Codes...'+msg.data);
	
	var start = new Date().getTime(); 
	var current = 0; 
	var cnt = 0;
	var param = {
			  chk  : "ttlcommet"
				};
	
	var tid = setInterval(function(){ 
		var xhr	=	new XMLHttpRequest();
		var url	=	"/ttl/ttlcomet.do";
		xhr.open("GET", url, false);
		//xhr.send();
		xhr.send(httpBuildQuery(param));
		if(xhr.status != 200) {
			console.log("#에러 확인#");
			console.log(xhr.responseText);
			throw Error(xhr.status + " " + xhr.statusText + ": " + url);
			//postMessage(xhr.status + " " + xhr.statusText + ": " + url);
			//postMessage('{isTrusted: true, data: "{"ttl":null,"trResult":"false","trMsg":"success"}"}');
		}
		console.log(xhr.responseText);
		postMessage(xhr.responseText);
	}, 2000);
	
	function callTp() {
		
	}
	
	function callWa() {
		
	}
	/*
	if(msg.data == "A") {
		console.log("a");
		document.getElementById("t_curr").value(msg.data);
	} else if(msg.data == "B"){
		document.getElementById("bid_snam").value(msg.data);
	}
	*/
};


var httpBuildQuery = function(params) {
	if (typeof params === 'undefined' || typeof params !== 'object') {
	    params = {};
	    return params;
	}
    var query = '';
    var index = 0;
    for (var i in params) {
        index++;
        var param = i;
        var value = params[i];
        if (index == 1) {
            query += param + '=' + value;
        } else {

            query += '&' + param + '=' + value;
        }
    }
    return query;
};

