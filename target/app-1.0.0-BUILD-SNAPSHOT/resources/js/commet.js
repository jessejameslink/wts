function ttlInit(){
	$.ajax({
		url:'/data/ttlCall.jsp',
		data:{chk:"ttlInit"},
	    dataType: 'json',
	    success: function(data){
	    	console.log("======== >inti< =========");
	    	console.log(data);
	    	stockData = data.mvStockWatchList;
	    	stockSearch();
	    }
	});
}

//전체 주식뽑기		
//전체 스톡 담아두기
function stockSearch(){
	
	var param = {
		chk	:"stockSearch"
	};
	$.ajax({
		url:'/data/ttlCall.jsp',
		data:param,
	    dataType: 'json',
	    success: function(data){
	    	var dList = data.stockSearchList;
			
	    	for(var i=0;i<dList.length;i++){
	    		stockList[dList[i].stockCode] = [dList[i].mvMarketID,dList[i].lotSize];
	    	}
	    	console.log("stockSearch>>>>>>>>>>>> 주식종목 전체");
	    	console.log(stockList);
	    	getMarketDatabtn();
	    			
	    }
	});
}