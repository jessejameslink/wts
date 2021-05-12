$(document).ready(function() {	
	$whatchlist = $("#whatchlist").tabs({
		activate: function (event, ui) {
			var $activeTab = $("#whatchlist").tabs('option', 'active');
			console.log("whatchlist>"+$activeTab);
		}
	});
	
	$stockInfo = $("#stockInfo").tabs({
		activate: function (event, ui) {
			var $activeTab = $("#stockInfo").tabs('option', 'active');
			console.log("stockInfo>"+$activeTab);
			if($activeTab == 1){
				stockInfosList();
				stockInfos = setInterval(stockInfosList,4000);
			}else{
				console.log("ClearInterval >> stockInfos")
				clearInterval(stockInfos);
			}
		}
	});
	
	$currentTab = $("#current").tabs({
		activate: function (event, ui) {
			var $activeTab = $("#current").tabs('option', 'active');
			console.log("current>"+$activeTab);
		}
	});
	
	$orders = $("#orders").tabs({
		activate: function (event, ui) {
			var $activeTab = $("#orders").tabs('option', 'active');
		}
	});
	
	$( "select" ).selectmenu();	
});

function myBalance(){
	console.log("myBalance");
}


function myPendingOrder(){
	var param = {
			chk						:"orderList"
	};
	$.ajax({
		url:'/data/ttlCall.jsp',
		data:param,
	    dataType: 'json',
	    success: function(data){
	    	console.log(data);
	    	
			var dList = data.mvOrderBeanList;
			var str = "";
			copydata = dList;
			if(dList.length != 0){
				for(var i=0;i<dList.length;i++){
					var canceled = dList[i].mvCancelIcon;
					var modify = dList[i].mvModifyIcon;
					orderInfo[dList[i].mvOrderID] = dList[i];
					
					str += "<tr id='"+dList[i].mvOrderID+"'>";
					str += "<td>"+objToStringCenModi(canceled,dList[i].mvOrderID,dList[i].mvOrderGroupID) +" "+objToStringCenModi(modify,dList[i].mvOrderID,dList[i].mvOrderGroupID) +"</td>";
					str += "<td class='text_center'>"+i+" </td>";
					str += "<td class='text_left'>"+dList[i].mvStockID+" | "+dList[i].mvMarketID+"</td>";
					str += "<td class='text_center'>"+mvStatusToString(dList[i].mvStatus)+" </td>";					
					str += "<td>"+dList[i].mvQty+" </td>";
					str += "<td>"+dList[i].mvPrice+" </td>";
					str += "<td>"+dList[i].mvPendingQty+" </td>";
					str += "</tr>";
					
				}
				
				
			    $("#pendingOrder").html(str);					    
			    loadingHide()
			}	 		
	    }
	});
}

function stopRTS(){
	clearInterval(ttmRespone);
	clearInterval(accountBalanceRepone);
	clearInterval(checkSessions);	
	//clearInterval(stockInfos);
}

function startRTS(){
	ttmRespone = setInterval(ttlcomet, 3000);
	accountBalanceRepone = setInterval(accountbalance,8000);
	checkSessions = setInterval(checkSession,7000);		
	//stockInfos = setInterval(stockInfosList,4000);
}

function startSellTRS(){
	stockInfos = setInterval(stockInfosList,4000);
}

function stopSellTRS(){
	clearInterval(stockInfos);
}

function executedHistory(){
	console.log("executedHistory");
}