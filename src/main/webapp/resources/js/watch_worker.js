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
			console.log(++cnt+'. Worker Job'); 
			current = new Date().getTime(); 
			if((current-start) >= 10000) { 
				clearInterval(tid); 
				console.log('End of Worker Codes'); 
				postMessage('End of Worker Codes'); 
			} 
	}, 1000);
	
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

