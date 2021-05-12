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
	
	console.log('NEWS WORKER---Start of Worker Codes...'+msg.data);
	console.log(msg);
	var start = new Date().getTime(); 
	var current = 0; 
	var cnt = 0; 
	
	var param = {
			  symb  : ""
			, skey  : ""
			, fdat  : ""
			, tdat  : ""
			, word  : ""
			, mark	: "0"
			, lang  : msg.data
		};
	
	console.log(param);
	
	var tid = setInterval(function(){ 
		var xhr	=	new XMLHttpRequest();
		var url	=	"/market/data/getMarketNewsTop3List.do";
		xhr.open("GET", url, false);
		//xhr.send();
		xhr.send(httpBuildQuery(param));
		if(xhr.status != 200) {
			throw Error(xhr.status + " " + xhr.statusText + ": " + url);
		}
		postMessage(xhr.responseText);
	}, 120000);
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
