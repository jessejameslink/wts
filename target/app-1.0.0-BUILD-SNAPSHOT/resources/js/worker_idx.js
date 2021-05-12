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
	
	
	var tid = setInterval(function(){ 
	
		var xhr	=	new XMLHttpRequest();
		var url	=	"/home/homeJisu.do";
		xhr.open("GET", url, false);
		xhr.send();
		if(xhr.status != 200) {
			throw Error(xhr.status + " " + xhr.statusText + ": " + url);
		}
		
		postMessage(xhr.responseText);
	
	}, 15000);
	
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

