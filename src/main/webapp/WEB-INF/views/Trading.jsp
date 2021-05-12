
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%--
<%@ include file = "<c:url value='/include/header.jsp'/>" %>
 --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script type="text/javascript" src="/resources/js/whatchlist.js""></script>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>MIRAE ASSET WTS</title>
<script>

	var stockList = [];		//전체주식
	var common = {
		mvStockId:"",
		beforStockId:"",
		mvMarketId:"",
		securityF:"",
		securityS:"",
		firstflag:"",
		ModifyId:"",
		modifyGroupid:"",
		modifyTargetId:"",
		modifyTargetGroupId:"",
		cancelTargetId:"",
		cancelTargetGroupId:"",
		genmodifyOrderStatus:{}
	};
	var orderInfo = {};
	var copydata = {};
	var stockData = {};
	var stockDataTemp = {};
	var ttmRespone = null;
	var accountBalanceRepone = null;
	var checkSessions = null;
	var authconfirm = true;
	var stockInfos = null;
	var nowStockInfos = {};

	$(document).ready(function() {
		$( "select" ).selectmenu();
		changelanguage();
		//resignContract();
	});


	function changelanguage(){

		$.ajax({
			url:'/data/ttlCall.jsp',
			data:{
				chk:"changelanguage",
				mvCurrentLanguage:"vi_VN",
				request_locale:"vi_VN"
			},
		    dataType: 'json',
		    success: function(data){
		    	//console.log(">>>>>>>>>> changelanguage <<<<<<<<<<<<<")
		    	//console.log(data);
		    	//authCardMatrix();

		    	ttlInit();
		    }
		});
	}

	function resignContract(){
		var mess = "";
		var mess1 = "";
		if ("<%= langCd %>" == "en_US") {
			mess1 = 'Please come back after!';
			mess = '<h3 style = "color: blue"> resignContract MAS is pleased to announce the official launch of an upgraded version of the securities trading system from May 11 2020 to May 14 2020. Please comeback again. <br> </h3> <h3 style = "color: blue"> <br><br> Quý khách vui lòng trở lại sau. <br> Sincerely thank you. <br> </p>';
		} else {
			mess1 = 'Xin vui lòng trở lại sau!';
			mess = '<h3 style="color:blue">MAS trân trọng thông báo chính thức đưa vào vận hành hệ thống giao dịch chứng khoán phiên bản nâng cấp từ ngày 11 tháng 05 năm 2020 đến ngày 14 tháng 05 năm 2020.<br></h3><h3 style="color:blue"><br>Quý khách vui lòng trở lại sau. <br>Trân trọng cảm ơn.<br></p>';
		}
			$.blockUI({ 
	            message: $('#displayBox'), 
	            css: { 
	                top:  ($(window).height() - 400) /3 + 'px', 
	                left: ($(window).width() - 600) /2 + 'px', 
	                width: '800px',
	                heigth:'600px'               
	            },
	          	message: '<img src="https://www.masvn.com/docs/image/1-OTP.jpg" width="200px" height="400px">',
				//message: mess,
	    		//timeout:   10000 
		
	    	}); 
			$('.blockOverlay').attr('title', mess1 ).click($.unblockUI);
	}
	
	function ttlInit(){
		loadingShow();
		$.ajax({
			url:'/data/ttlCall.jsp',
			data:{chk:"ttlInit"},
		    dataType: 'json',
		    success: function(data){
		    	//console.log("======== >inti< =========");
		    	//console.log(data);
		    	if(data != null){
		    		stockData = data.mvStockWatchList;
		    		stockDataTemp = stockData;
		    	}
		    	stockSearch();
		    }
		});
	}

	function ttlInitOlyOne(id){
		loadingShow();
		$.ajax({
			url:'/data/ttlCall.jsp',
			data:{chk:"ttlInit"},
		    dataType: 'json',
		    success: function(data){
		    	//console.log("======== >inti Refresh< =========");
		    	//console.log(data);
		    	if(data != null){
		    		stockData = data.mvStockWatchList;
		    		stockDataTemp = stockData;
		    	}

		    	for(var i=0;i<stockData.length;i++){
					var data = stockData[i].mvStockWatchID;
					if(data.indexOf(common.beforStockId) != -1){
						stockWatchID = data;
					}
				}

				//console.log(">>>>>>>>>> unregisterParam 2<<<<<<<<<<");

				param = {
					action:"unregister",
					symbol:common.beforStockId,
					marketId:stockList[common.beforStockId][0],
					stockWatchID:stockWatchID,
					xtype:"dynStockWatch",
					chk:"unregister"
				};

				//console.log("Unregister");
				//console.log(param);

				$.ajax({
					url:'/data/ttlCall.jsp',
					data:param,
				    dataType: 'json',
				    success: function(data){
				    	//console.log("---------> ttlcometRegisterNowPrice Unregister<----------");
				    	//console.log(data);
				    	ttlcometRegisterNowPriceCreate(id);
				    },
				    error:function(e){
				    	//console.log(e);
				    	console.log("eeeeeeeeeee"+e)
				    	loadingHide()
				    }
				});
		    }
		});
	}


	//전체 스톡 담아두기
	//stockList[stockID][marketID,lotSize(거래수량단위)]
	function stockSearch(){

		var param = {
			chk	:"stockSearch"
		};
		$.ajax({
			url:'/data/ttlCall.jsp',
			data:param,
		    dataType: 'json',
		    success: function(data){
		    	try{
		    		var dList = data.stockSearchList;

			    	for(var i=0;i<dList.length;i++){
			    		stockList[dList[i].stockCode] = [dList[i].mvMarketID,dList[i].lotSize];
			    	}
			    	//console.log("stockSearch>>>>>>>>>>>> 주식종목 전체");
			    	//console.log(stockList);
			    	getMarketDatabtn();
		    	}catch(e){
		    		alertMsg("전체주식 가져오기 실패.")
		    		loadingHide();
		    	}


		    }
		});
	}

	//관신종목 가져오기
	function getMarketDatabtn(){

		var param = {
				chk:"getMarketData"
		};
		$.ajax({
			url:'/data/ttlCall.jsp',
			data:param,
		    dataType: 'json',
		    success: function(data){
		    	//console.log(">>>>>>>>>>> getMarketDatabtn <<<<<<<<<<<");
		    	//console.log(data);
		    	try{
		    		var dList = data.mvMarketData;
					var str = "";
			    	for(var i=0;i<dList.length;i++){
			    		str += "<tr id='"+dList[i].mvSymbol+"' onClick=\"stockStatusUpdate('"+dList[i].mvSymbol+"','"+dList[i].mvNominalPrice+"')\">";

			    		str += "<td class='text_left'>"+dList[i].mvSymbol+"</td>"; //mvSymbol
						str += "<td class='text_left'>"+dList[i].mvMarketID+"</td>"; //mvSymbol

						str += "<td class='upper'>"+dList[i].mvCeilingPrice+"</td>";
						str += "<td class='lower'>"+dList[i].mvFloorPrice+"</td>";
						str += "<td class='same'>"+dList[i].mvReferencePrice+"</td>";

						str += getCurrent(dList[i].mvBestBid1Price,dList[i].mvBestBid1Css);
						str += getCurrent(dList[i].mvBestBid1Volume,dList[i].mvBestBid1Css);

						str += getCurrent(dList[i].mvNominalPrice,dList[i].mvOpenPriCss);
						str += getCurrent(dList[i].mvMatchQty,dList[i].mvMatchQtyCss);
						str += getCurrent(dList[i].mvNoalPriSubRefPri,dList[i].mvOpenPriCss);
						str += getCurrent(dList[i].mvNoalPriPerRate,dList[i].mvNoalPriPerRateCss);
						str += getCurrent(dList[i].mvTotalTradingQty,dList[i].mvTalVolCss);

						str += getCurrent(dList[i].mvBestOffer1Price,dList[i].mvBestOffer1Css);
						str += getCurrent(dList[i].mvBestOffer1Volume,dList[i].mvBestOffer1Css);

						str += getCurrent(dList[i].mvOpenPrice,dList[i].mvOpenPriCss);
						str += getCurrent(dList[i].mvHighPrice,dList[i].mvOpenPriCss);
						str += getCurrent(dList[i].mvLowPrice,dList[i].mvOpenPriCss);

						str += "<td>"+dList[i].mvBuyForeignQty+"</td>";
						str += "<td>"+dList[i].mvSellForeignQty+"</td>";
						str += "<td>"+dList[i].mvCurrentRoom+"</td>";

						str += "</tr>";
					}
			    	$("#whatchListTbl").html(str);
			    	orderList();
		    	}catch(e){
		    		alertMsg("관심종목 리스트 오류");
		    		loadingHide();
		    	}
		    }
		});
	}

	function stockStatusUpdate(id,ref){
		loadingShow();
		var goUnregister = false;

		if(common.mvStockId == ""){
			goUnregister = true;
		}

		common.mvStockId = id;
		common.mvMarketId = stockList[id][0];

		var param = {
				mvInstrument			:id,
				mvMarketId				:stockList[id][0],
				mvBS					:"B",
				mvEnableGetStockInfo	:"N",
				mvAction				:"OI.BP",
				chk						:"stockStatusUpdate"
		};
		//console.log(param);
		$.ajax({
			url:'/data/ttlCall.jsp',
			data:param,
		    dataType: 'json',
		    success: function(data){
		    	//console.log("-------------------- stock Update -------------------");
		    	//console.log(data);
		    	try{
		    		if(data != null){
		    			var dList = data.mvStockInfoBean;
		    			nowStockInfos = dList;
				    	common.refId = ref;

				    	$("#buystockCodeVal").html(id);
				    	$("#enterOrderExpected").html(Number(dList.mvBuyingPowerd.replace(/,/gi,""))/(1-Number(dList.mvMarginPercentage) / 100));
				    	$("#lending").html(Number(dList.mvMarginPercentage));
				    	$("#buyordValume").val(stockList[id][1]);
				    	$("#buyordPrice").val(ref);
				    	$("#enterOrderNetfee").html();


				    	if(goUnregister){
				    		ttlcometRegisterNowPriceCreate(id);
				    	}else{
				    		ttlcometRegisterNowPriceUnregist(id);
				    	}
		    		}else{

		    		}
		    	}catch(e){
		    		console.log(e);
		    		//alertMsg("주식정보 가져오기 실패. 다시가져오세요");
		    		$("#loginBar").hide();
		    	}


		    }
		});
	}

	function stockInfosList(){
		var param = {
			mvLastAction:"PORTFOLIOENQUIRY",
			mvChildLastAction:"PORTFOLIO",
			chk:"stockInfoList"
		}
		$.ajax({
			url:'/data/ttlCall.jsp',
			data:param,
		    dataType: 'json',
		    success: function(data){
		    	//console.log("stockInfosList");
		    	//console.log(data);
		    	var dList = data.mvStockBalanceInfo;
		    	var str = "";

		    	for(var i=0;i<dList.length;i++){
					str += "<tr onClick=\"stockStatusUpdate('"+dList[i].mvStockCode+"','')\">";
					str += "<td>"+(i+1)+"</td>";
					str += "<td class='text_center'>"+dList[i].mvStockCode+" </td>"; //mvSymbol
					str += "<td class='text_center'>"+dList[i].mvTotalValue+" </td>";
					str += "<td>"+dList[i].mvTTodayBuy+" </td>";
					str += "<td>"+dList[i].mvTTodaySell+" </td>";
					str += "<td></td>";
					str += "<td></td>";
					str += "<td></td>";
					str += "<td></td>";
					str += "<td></td>";
					str += "<td></td>";
					str += "<td></td>";
					str += "<td></td>";
					str += "</tr>";
				}
			    $("#stockInfoList").html(str);
		    }
		});
	}




	function orderList(){
			var param = {
					chk	:"orderList"
			};
			$.ajax({
				url:'/data/ttlCall.jsp',
				data:param,
			    dataType: 'json',
			    success: function(data){
			    	//console.log(data);
			    	try{
			    		var dList = data.mvOrderBeanList;
						var str = "";
						copydata = dList;
						if(dList.length != 0){
							for(var i=0;i<dList.length;i++){
								var canceled = dList[i].mvCancelIcon;
								var modify = dList[i].mvModifyIcon;
								orderInfo[dList[i].mvOrderID] = dList[i];
								var className = "";

								(i%2 == 0) ? className = "even" : "";

								str += "<tr class='"+className+"' id='"+dList[i].mvOrderID+"'>";
								str += "<td>"+objToStringCenModi(canceled,dList[i].mvOrderID,dList[i].mvOrderGroupID) +" "+objToStringCenModi(modify,dList[i].mvOrderID,dList[i].mvOrderGroupID) +"</td>";
								str += "<td>"+dList[i].mvStockID+" </td>";
								str += "<td><p>"+(dList[i].mvBSValue.toString() == "B" ? "Buy" : "Sell")+"</p><p>"+dList[i].mvPrice+"</p> </td>";
								str += "<td><p>"+dList[i].mvQty+"</p><p>"+dList[i].mvPendingQty+"</p> </td>";
								str += "<td><p>"+dList[i].mvFilledQty+"</p><p>"+dList[i].mvAvgPrice+"</p> </td>";
								str += "<td>"+mvStatusToString(dList[i].mvStatus)+" </td>";
								str += "<td><p>"+oderTyleVal(dList[i].mvOrderTypeValue)+"</p><p>"+(dList[i].mvBSValue.toString() == "B" ? parseInt((dList[i].mvNetAmtValue-dList[i].mvGrossAmt)*1000) : parseInt((dList[i].mvGrossAmt-dList[i].mvNetAmtValue)*1000))+"</p> </td>";
								if(objToString(dList[i].mvRejectReasonDetail) != ""){
									str += "<td><p><a href=\"javascript:reasonAlert(\'"+dList[i].mvRejectReasonDetail+"\')\">Detail Reason</a></p><p>"+dList[i].mvStopOrderExpiryDate+"</p> </td>";
								}else{
									str += "<td><p>-</p><p>"+dList[i].mvStopOrderExpiryDate+"</p> </td>";
								}
								str += "</tr>";

							}

						    $("#orderList").html(str);

						}
						if(common.firstflag == ""){
							startRTS();
						}
						common.firstflag = "Y";
						loadingHide();
			    	}catch(e){
			    		startRTS();
			    		common.firstflag = "Y";
						loadingHide();
			    	}

			 		//accountbalance();
			    }
			});


	}


	function orderlistRegister(){
		$.ajax({
			url:'/data/ttlCall.jsp',
			data:{chk:"orderlistUpdate"},
		    dataType: 'json',
		    success: function(data){
		    	//console.log("ORDERLIST COMMET REGISTER SET");
		    	orderList();

		    }
		});
	}

	function originData(id) {
		var body = "";
	    for(var i=0;i<copydata.length;i++){
	    	var head = "";

	    	if(id == copydata[i].mvOrderID){
		    	body += "<tr>";
			    for(var keys in copydata[i]){
			    	head += "<th>"+keys+"</th>";
			    	body += "<td>"+copydata[i][keys]+"</td>";
			    }

			    body += "</tr>";
			    $("#originOrderhead").html(head);
	    	}
	    }

	    $("#originOrderbody").html(body);

	}


	//주문가능 시간 체크
	function queryMarketStatusInfo(){
		loadingShow();
		$.ajax({
			url:'/data/ttlCall.jsp',
			data:{chk:"queryMarketStatusInfo",mvMarketID:common.mvMarketId},
		    dataType: 'json',
		    success: function(data){
		    	//console.log("queryMarketStatusInfo >> 주문가능 시간체크");
		    	//console.log(data);
		    	if(data.mvMarketTime != null){
		    		enterOrder();
		    	}else{
		    		var market = "";
		    		if(data.mvMarketID == "HA"){
		    			market = "HNX";
		    		}else if(data.mvMarketID == "HO"){
		    			market = "HOSE";
		    		}
		    		alertMsg("Out of Time for order in "+market);
		    		loadingHide();
		    	}

		    }
		});
	}


	//주문내기
	function enterOrder(mode){


			var orderType = "L";
			var price = "";
			var volume = "";
			$("#orderType").selectmenu({
				change:function(evt,ui){
					orderType = ui.item.value;
				}
			})

			price = $("#buyordPrice").val();
			volume = $("#buyordValume").val();


			if(Number(nowStockInfos.mvCeiling) < price){
				alertMsg("Order price is out of price spread ("+nowStockInfos.mvFloor+" to "+nowStockInfos.mvCeiling+"), please input again")
				loadingHide();
				return;
			}

			if(Number(nowStockInfos.mvFloor) > price){
				alertMsg("Order price is out of price spread ("+nowStockInfos.mvFloor+" to "+nowStockInfos.mvCeiling+"), please input again")
				loadingHide();
				return;
			}

			if(price == "" || volume == ""){
				alertMsg("price Insert Or volume Insert");
				return;
			}

			var param = {
					mvBS						:$('input[name=orderBSall]:checked').val(),
					mvStockCode					:common.mvStockId,
					mvLending					:$("#lending").text(),
					mvBuyingPower				:parseInt($("#enterOrderExpected").text()).toString(),
					mvOrderTypeValue			:orderType,
					mvQuantity					:volume,
					mvPrice						:price,
					mvGrossAmt					:"",
					mvNetFee					:"",//$("#netFree").val(),
					mvMarketID					:common.mvMarketId,
					refId						:common.refId,
					mvWaitOrder					:"off",
					mvGoodTillDate				:"",//$("#expiryDay").val(),
					mvAfterServerVerification	:"Y",
					extgen1372					:"",
					extgen1373					:"",
					extgen1374					:"",
					mvBankID					:"",
					mvBankACID					:"",
					chk							:"enterOrder"
			};

			//console.log(">>>>>>>>>>>>> order Param <<<<<<<<<<<<<<<<");
			//console.log(param);
			 $.ajax({
				url:'/data/ttlCall.jsp',
				data:param,
			    dataType: 'json',
			    success: function(data){
			    	//console.log("---------> ORDER <----------")
			    	//console.log(data);
			    	try{
			    		if(data != null){
				    		if(data.mvReturnCode > 0 || data.success != true){
					    		loadingHide();
					    		enterorderfail();
					    	}else{
					    		ttlcometRegisterOrderList();
					    	}
				    	}else{
				    		loadingHide();
				    		enterorderfail();
				    	}
			    	}catch(e){
			    		loadingHide();
			    		enterorderfail();
			    	}

			    },
			    error:function(e){
			    	//alertMsg("주문오류 콘솔확인");
			    	console.log(e)
			    }
			});

	}


	function enterorderfail(){
		 $.ajax({
			url:'/data/ttlCall.jsp',
			data:{chk:"enterorderfail"},
		    dataType: 'json',
		    success: function(data){
		    	//console.log("---------> ORDER enterorderfail<----------")
		    	//console.log(data);
		    	if(data.mvFailBean.mvErrorMsg == "HKSERROR0006"){
		    		alertMsg(" Out of time for order \n ReturnCode : "+data.mvFailBean.mvErrorMsg+" Msg : "+data.mvFailBean.mvGoodTillDescription);
		    	}else{
		    		alertMsg("주문이상 ReturnCode : "+data.mvFailBean.mvErrorMsg+" Msg : "+data.mvFailBean.mvGoodTillDescription);
		    	}


		    },
		    error:function(e){
		    	//alertMsg("주문오류 콘솔확인");
		    	console.log(e)
		    }
		});

	}

	function cancelOrder(id,groupid){
		loadingShow();

			var param = {
					AfterServerVerification	:"Y",
					BuySell					:"B",
					ORDERID					:orderInfo[id].mvOrderID,
					ORDERGROUPID			:orderInfo[id].mvOrderGroupID,
					StockCode				:orderInfo[id].mvStockID,
					MarketID				:orderInfo[id].mvMarketID,
					Quantity				:orderInfo[id].mvQtyValue,
					Price					:orderInfo[id].mvAvgPriceValue,
					OSQty					:orderInfo[id].mvQtyValue,
					FILLEDQTY				:orderInfo[id].mvFilledQty,
					OrderTypeValue			:orderInfo[id].mvOrderTypeValue,
					GOODTILLDATE			:"",
					StopTypeValue			:orderInfo[id].mvStopTypeValue,
					StopPrice				:orderInfo[id].mvStopPriceValue,
					SavePass				:"N",
					PasswordConfirmation	:"",
					mvAllorNothing			:orderInfo[id].mvAllorNothing,
					mvOrderId				:orderInfo[id].mvOrderID,
					mvMarketId				:orderInfo[id].mvMarketID,
					mvStockId				:orderInfo[id].mvStockID,
					mvInstrumentName		:"",
					mvPric					:orderInfo[id].mvAvgPriceValue,
					mvQutityFormat			:orderInfo[id].mvQtyValue,
					mvFilledQty				:orderInfo[id].mvFilledQty,
					mvOSQty					:orderInfo[id].mvQtyValue,
					mvOrderType				:orderInfo[id].mvOrderTypeValue,
					password				:"",
					mvSecurityCode			:"",
					mvSeriNo				:"",
					mvAnswer				:"",
					mvSaveAuthenticate		:"true",
					mvInputTime				:orderInfo[id].mvInputTime,
					mvStatus				:orderInfo[id].mvStatus,
					mvGoodTillDate			:"",
					chk						:"CancelOrder"
			};

			//console.log(param);
			 $.ajax({
				url:'/data/ttlCall.jsp',
				data:param,
			    dataType: 'json',
			    success: function(data){
			    	//console.log("---------> Cancel <----------")
			    	//console.log(data);
			    	if(data.mvReturnResult == "CancelOrderFail"){
			    		alertMsg('취소 실패');
			    		loadingHide();
			    	}else{
			    		orderlistRegister();
			    	}

			    },
			    error:function(e){
			    	console.log(e)
			    }
			});

	}

	function genmodifyOrder(id,groupid){

			var param = {
					mvOrderId:			orderInfo[id].mvOrderID,
					mvBSValue:			orderInfo[id].mvBSValue,
					mvStockId:			orderInfo[id].mvStockID,
					mvMarketId:			orderInfo[id].mvMarketID,
					mvPriceValue:		orderInfo[id].mvPrice,
					mvQtyValue:			orderInfo[id].mvQtyValue,
					mvCancelQtyValue:	orderInfo[id].mvCancelQtyValue,
					mvInputTime:		orderInfo[id].mvInputTime,
					mvStopTypeValue:	orderInfo[id].mvStopTypeValue,
					mvStopPriceValue:	orderInfo[id].mvStopPriceValue,
					mvStopOrderExpiryDate:		orderInfo[id].mvStopOrderExpiryDate,
					mvOrderTypeValue:	orderInfo[id].mvOrderTypeValue,
					mvAllOrNothing:		orderInfo[id].mvAllorNothing,
					mvValidityDate:		orderInfo[id].mvValidityDate,
					mvActivationDate:	orderInfo[id].mvActivationDate,
					mvGoodTillDate:		orderInfo[id].mvGoodTillDate,
					mvRemark:			orderInfo[id].mvRemark,
					mvContactPhone:		orderInfo[id].mvContactPhone,
					mvGrossAmt:			orderInfo[id].mvGrossAmt,
					mvNetAmtValue:		orderInfo[id].mvNetAmtValue,
					mvSCRIP:			orderInfo[id].mvSCRIP,
					mvlotSize:			orderInfo[id].mvLotSize,
					mvOrderGroupId:		groupid,
					mvBaseNetAmtValue:	orderInfo[id].mvGrossAmt,
					mvAvgPriceValue:	orderInfo[id].mvAvgPriceValue,
					mvFilledQty:		orderInfo[id].mvFilledQty,
					mvStatus:			orderInfo[id].mvStatus,
					chk						:"genmodifyOrder"
			};
			//console.log(orderInfo[id]);
			//console.log(param);
			 $.ajax({
				url:'/data/ttlCall.jsp',
				data:param,
			    dataType: 'json',
			    success: function(data){
			    	//console.log("---------> genmodifyOrder <----------")
			    	//console.log(data);
			    	var dList = data.mvGenModifyOrderBean;

			    	$("#mvstockModal").text(dList.mvStockId);
			    	$("#mvPriceModal").val(dList.mvNewPrice);
			    	$("#mvVolumeModal").val(dList.mvNewQty);
			    	$("#fffl").text(dList.floor);
			    	$("#cccl").text(dList.ceiling);

			    	$("#modalPop").show();

			    	common.ModifyId = id;
			    	common.modifyGroupid = groupid;
			    	common.genmodifyOrderStatus = dList;
			    	//console.log(common.genmodifyOrderStatus);
			    },
			    error:function(e){
			    	console.log(e)
			    }
			});


	}

	function ModifyOrder(id,groupid){

			var param = {
					mvCurrencyId			:common.genmodifyOrderStatus.mvCurrencyId,
					mvMaxLotPerOrder		:common.genmodifyOrderStatus.mvMaxLotPerOrder,
					mvOrigPrice				:common.genmodifyOrderStatus.mvPrice,
					mvOrigQty				:common.genmodifyOrderStatus.mvNewQty,
					mvOrigStopPrice			:"",
					mvStopPrice				:"",
					mvOrigPriceValue		:common.genmodifyOrderStatus.mvOrigPriceValue,
					mvOrigQtyValue			:common.genmodifyOrderStatus.mvOrigQtyValue,
					mvCancelQtyValue		:common.genmodifyOrderStatus.mvCancelQtyValue,
					mvAveragePrice			:common.genmodifyOrderStatus.mvAveragePrice,
					mvAllOrNothing			:common.genmodifyOrderStatus.mvAllOrNothing,
					mvStopOrderType			:"N",
					mvValidityDate			:common.genmodifyOrderStatus.mvValidityDate,
					mvActivationDate		:common.genmodifyOrderStatus.mvActivationDate,
					mvAllowOddLot			:common.genmodifyOrderStatus.mvAllowOddLot,
					mvRemark				:common.genmodifyOrderStatus.mvRemark,
					mvContactPhone			:common.genmodifyOrderStatus.mvContactPhone,
					mvGrossAmtValue			:common.genmodifyOrderStatus.mvGrossAmtValue,
					mvNetAmtValue			:common.genmodifyOrderStatus.mvNetAmtValue,
					mvSCRIP					:common.genmodifyOrderStatus.mvSCRIP,
					mvIsPasswordSaved		:common.genmodifyOrderStatus.mvIsPasswordSaved,
					mvStopTypeValue			:common.genmodifyOrderStatus.mvStopTypeValue,
					mvPasswordConfirmation	:common.genmodifyOrderStatus.mvPasswordConfirmation,
					mvOrderId				:common.genmodifyOrderStatus.mvOrderIdValue,
					mvGoodTillDate			:common.genmodifyOrderStatus.mvGoodTillDateValue,
					mvBS					:common.genmodifyOrderStatus.mvBSValue,
					mvOrderGroupId			:common.genmodifyOrderStatus.mvOrderGroupId,
					mvOrderType				:common.genmodifyOrderStatus.mvOrderTypeValue,
					mvFormIndexpage			:"Y",
					mvStopValue				:"",
					mvFilledQty				:common.genmodifyOrderStatus.mvFilledQty,
					mvLotSizeValue			:common.genmodifyOrderStatus.mvLotSizeValue,
					mvStopOrderExpiryDate	:common.genmodifyOrderStatus.mvStopOrderExpiryDate,
					OrderId					:common.genmodifyOrderStatus.mvOrderId,
					mvMarketId				:common.genmodifyOrderStatus.mvMarketId,
					mvStockId				:common.genmodifyOrderStatus.mvStockId,
					mvStockName				:common.genmodifyOrderStatus.mvInstrumentName,
					mvPrice					:common.genmodifyOrderStatus.mvCurrencyId,
					mvNewPrice				:$("#mvPriceModal").val(),
					mvQty					:common.genmodifyOrderStatus.mvNewQty,
					mvNewQty				:$("#mvVolumeModal").val(),
					OrderType				:(common.genmodifyOrderStatus.mvOrderType == "Giới hạn" ? "Limit" : "Giới hạn"),
					GoodTillDate			:common.genmodifyOrderStatus.mvGoodTillDate,
					mvGrossAmt				:"VND $0.00",
					Password				:"",
					mvSecurityCode			:"",
					mvStatus				:common.genmodifyOrderStatus.mvStatus,
					mvSeriNo				:"",
					mvAnswer				:"",
					mvSaveAuthenticate		:"false",
					chk						:"hksModifyOrder"
			};
			//console.log(param);
			 $.ajax({
				url:'/data/ttlCall.jsp',
				data:param,
			    dataType: 'json',
			    success: function(data){
			    	//console.log("---------> Modify <----------")
			    	//console.log(data);
			    	if(data != null){
			    		if(data.returnCode > 0 || data.success != true){
				    		alertMsg("수정이상 ReturnCode : "+data.returnCode+" Msg : "+data.mvResult);
				    		loadingHide();
				    	}else{
				    		ttlcometRegisterOrderList();
				    	}
				    	$("#modalPop").hide();
			    	}


			    },
			    error:function(e){
			    	console.log(e)
			    }
			});
	}

	function ModifyCancel(){
		$("#modalPop").hide();
	}

	function checkSession(){
		$.ajax({
			url:'/data/ttlCall.jsp',
			data:{chk:"checkSession"},
		    dataType: 'json',
		    success: function(data){
		    	//console.log(data);

		    },
		    error:function(e){
		    	//console.log(e);
		    	//console.log("eeeeeeeeeee")
		    }
		});
	}

	function ttlcometRegisterOrderList(){
		$.ajax({
			url:'/data/ttlCall.jsp',
			data:{chk:"ordercheck"},
		    dataType: 'json',
		    success: function(data){
		    	//console.log("---------> Dynimic Order List Register  <----------");
		    	//console.log(data);
		    	orderList();

		    },
		    error:function(e){
		    	console.log(e);
		    	//console.log("eeeeeeeeeee")
		    }
		});
	}


	function ttlcomet(){
		$.ajax({
			url:'/data/ttlCall.jsp',
			data:{chk:"ttlcommet"},
		    dataType: 'json',
		    success: function(data){
		    	//console.log("---------> ttlComet <----------");
		    	//console.log(data)


		    	for(var key in data){
		    		if(key == "mvAlert"){
		    			//console.log("알림 업데이트");
		    			//console.log(data[key]);
		    			//orderList();
						mvAlert(data[key]);
		    		}else if(key == "mvMarketIndexList"){
		    			//console.log("mvMarketIndexList")
		    			//console.log(data[key]);
		    		}else if(key == "mvStockWatchList"){
		    			//console.log("왓치리스트및현재가 업데이트");
		    			realBind(data[key]);
		    		}else if(key == "time"){
		    			alertMsg(data[key]);
		    		}else if(key == "mvDynamicUpdatedOrderList"){
		    			//console.log("주문정보 업데이트");
		    			//console.log(data[key]);
		    			DynamicUpdateOrderList(data[key]);
		    			orderList();

		    		}
		    	}


		    },
		    error:function(e){
		    	//console.log(e);
		    	console.log("eeeeeeeeeee"+e)
		    }
		});
	}

	function ttlcometRegisterNowPriceUnregist(id){
		var param = {};
		var stockWatchID = "";

		//console.log(">>>>>>>>>> unregisterParam <<<<<<<<<<"+common.beforStockId);
		//console.log(stockData)

		if(stockData == "undefined" || stockData === undefined){
			//console.log(">>>>>>>>>>>>>>>>>> stockData Delete???????? <<<<<<<<<<<<<<<<<<<<<");
			ttlInitOlyOne(id);
		}else{
			for(var i=0;i<stockData.length;i++){
				var data = stockData[i].mvStockWatchID;
				if(data.indexOf(common.beforStockId) != -1){
					stockWatchID = data;
				}
			}

			//console.log(">>>>>>>>>> unregisterParam 2<<<<<<<<<<");

			param = {
				action:"unregister",
				symbol:common.beforStockId,
				marketId:stockList[common.beforStockId][0],
				stockWatchID:stockWatchID,
				xtype:"dynStockWatch",
				chk:"unregister"
			};

			//console.log("Unregister");
			//console.log(param);

			$.ajax({
				url:'/data/ttlCall.jsp',
				data:param,
			    dataType: 'json',
			    success: function(data){
			    	//console.log("---------> ttlcometRegisterNowPrice Unregister<----------");
			    	//console.log(data);
			    	ttlcometRegisterNowPriceCreate(id);
			    },
			    error:function(e){
			    	console.log(e);
			    	//console.log("eeeeeeeeeee"+e)
			    	loadingHide()
			    }
			});
		}


	}

	function ttlcometRegisterNowPriceCreate(id){
		var param = {};
		var stockWatchID = "";
		common.beforStockId = id;
		param = {
			action:"register",
			symbol:common.mvStockId,
			marketId:common.mvMarketId,
			<%--
			stockWatchID:"<%=id%>stockmarketprice",
			 --%>
			xtype:"dynStockWatch",
			chk:"nowPricecheck"
		};

		//console.log("CreateRegister");
		//console.log(param);

		$.ajax({
			url:'/data/ttlCall.jsp',
			data:param,
		    dataType: 'json',
		    success: function(data){
		    	//console.log("---------> ttlcometRegisterNowPrice CreateRegister<----------");
		    	//console.log(data);
		    	var count = 0;

		    	for(var idx in data){
		    		if(idx == "mvStockWatchList"){
		    			openNowPrice(data.mvStockWatchList);
		    		}
		    	}
		    	loadingHide();

		    },
		    error:function(e){
		    	//console.log(e);
		    	//console.log("eeeeeeeeeee"+e)
		    	loadingHide()
		    }
		});
	}

	function realBind(data){
		//console.log(data)
		var str = "";

		for(var i=0;i<data.length;i++){
    		//str += "<tr id='"+dList[i].mvSymbol+"' onClick=\"stockStatusUpdate('"+dList[i].mvSymbol+"','"+dList[i].mvNominalPrice+"')\">";

    		str += "<td class='text_left'>"+data[i].mvSymbol+"</td>"; //mvSymbol
			str += "<td class='text_left'>"+data[i].mvMarketID+"</td>"; //mvSymbol

			str += "<td class='upper'>"+data[i].mvCeilingPrice+"</td>";
			str += "<td class='lower'>"+data[i].mvFloorPrice+"</td>";
			str += "<td class='same'>"+data[i].mvReferencePrice+"</td>";

			str += getCurrent(data[i].mvBestBid1Price,data[i].mvBestBid1Css);
			str += getCurrent(data[i].mvBestBid1Volume,data[i].mvBestBid1Css);

			str += getCurrent(data[i].mvNominalPrice,data[i].mvOpenPriCss);
			str += getCurrent(data[i].mvMatchQty,data[i].mvMatchQtyCss);
			str += getCurrent(data[i].mvNoalPriSubRefPri,data[i].mvOpenPriCss);
			str += getCurrent(data[i].mvNoalPriPerRate,data[i].mvNoalPriPerRateCss);
			str += getCurrent(data[i].mvTotalTradingQty,data[i].mvTalVolCss);

			str += getCurrent(data[i].mvBestOffer1Price,data[i].mvBestOffer1Css);
			str += getCurrent(data[i].mvBestOffer1Volume,data[i].mvBestOffer1Css);

			str += getCurrent(data[i].mvOpenPrice,data[i].mvOpenPriCss);
			str += getCurrent(data[i].mvHighPrice,data[i].mvOpenPriCss);
			str += getCurrent(data[i].mvLowPrice,data[i].mvOpenPriCss);

			str += "<td>"+data[i].mvBuyForeignQty+"</td>";
			str += "<td>"+data[i].mvSellForeignQty+"</td>";
			str += "<td>"+data[i].mvCurrentRoom+"</td>";

			//str += "</tr>";
			$("#"+data[i].mvSymbol).html(str);
			$("#"+data[i].mvSymbol).click(function(){
				stockStatusUpdate(data[i].mvSymbol,data[i].mvNominalPrice);
			});
		}

	}

	function openNowPrice(data){

		var rData = data[0];
		var mList = rData.mvMarketDataBean;
		var tableList = [];

		if(rData.mvHistoricalChartDataBeanList > 0){
			tableList = rData.mvHistoricalChartDataBeanList[0].mvHistoricalData;
		}

		$("#BidmvNominalPrice").html(mList.mvNominalPrice);
		$("#BidmvNoalPriSubRefPri").html(mList.mvNoalPriSubRefPri);
		$("#BidmvReferencePrice").html(mList.mvReferencePrice);
		$("#BidmvFloorPrice").html(mList.mvFloorPrice);
		$("#BidmvCeilingPrice").html(mList.mvCeilingPrice);
		$("#BidmvLowPrice").html(mList.mvLowPrice);
		$("#BidmvHighPrice").html(mList.mvHighPrice);
		$("#BidmvOpenPrice").html(mList.mvOpenPrice);
		$("#BidavgPrice").html(mList.avgPrice);
		$("#BidmvMatchQty").html(mList.mvMatchQty);
		$("#BidmvNoalPriPerRate").html(mList.mvNoalPriPerRate);

		$("#BidmvTotalVol").html(mList.mvTotalVol);
		$("#BidmvBuyForeignQty").html(mList.mvBuyForeignQty);
		$("#BidmvSellForeignQty").html(mList.mvSellForeignQty);
		$("#BidmvCurrentRoom").html(mList.mvCurrentRoom);

		$("#BidmvBestBid1Volume").html(mList.mvBestBid1Volume);
		$("#BidmvBestBid1Price").html(mList.mvBestBid1Price);
		$("#BidmvBestBid1Css").html(mList.mvBestBid1Css);
		$("#BidmvBestBid2Volume").html(mList.mvBestBid2Volume);
		$("#BidmvBestBid2Price").html(mList.mvBestBid2Price);
		$("#BidmvBestBid2Css").html(mList.mvBestBid2Css);
		$("#BidmvBestBid3Volume").html(mList.mvBestBid3Volume);
		$("#BidmvBestBid3Price").html(mList.mvBestBid3Price);
		$("#BidmvBestBid3Css").html(mList.mvBestBid3Css);


		$("#BidmvBestOffer1Price").html(mList.mvBestOffer1Price);
		$("#BidmvBestOffer1Volume").html(mList.mvBestOffer1Volume);
		$("#BidmvBestOffer1Css").html(mList.mvBestOffer1Css);

		$("#BidmvBestOffer2Price").html(mList.mvBestOffer2Price);
		$("#BidmvBestOffer2Volume").html(mList.mvBestOffer2Volume);
		$("#BidmvBestOffer2Css").html(mList.mvBestOffer2Css);

		$("#BidmvBestOffer3Price").html(mList.mvBestOffer3Price);
		$("#BidmvBestOffer3Volume").html(mList.mvBestOffer3Volume);
		$("#BidmvBestOffer3Css").html(mList.mvBestOffer3Css);


	}


	function DynamicUpdateOrderList(data){
		var dList = data;
		var str = "";
		var targetId = "";

		if(dList.length != 0){
			for(var i=0;i<dList.length;i++){
				var canceled = dList[i].mvCancelIcon;
				var modify = dList[i].mvModifyIcon;
				targetId = dList[i].mvOrderID;
				orderInfo[dList[i].mvOrderID] = dList;

				str += "<td>"+objToStringCenModi(canceled,dList[i].mvOrderID,dList[i].mvOrderGroupID) +" "+objToStringCenModi(modify,dList[i].mvOrderID,dList[i].mvOrderGroupID) +"</td>";
				str += "<td>"+dList[i].mvStockID+" </td>";
				str += "<td><p>"+(dList[i].mvBSValue.toString() == "B" ? "Buy" : "Sell")+"</p><p>"+dList[i].mvPrice+"</p> </td>";
				str += "<td><p>"+dList[i].mvQty+"</p><p>"+dList[i].mvPendingQty+"</p> </td>";
				str += "<td><p>"+dList[i].mvFilledQty+"</p><p>"+dList[i].mvAvgPrice+"</p> </td>";
				str += "<td>"+mvStatusToString(dList[i].mvStatus)+" </td>";
				str += "<td><p>"+oderTyleVal(dList[i].mvOrderTypeValue)+"</p><p>"+(dList[i].mvBSValue.toString() == "B" ? parseInt((dList[i].mvNetAmtValue-dList[i].mvGrossAmt)*1000) : parseInt((dList[i].mvGrossAmt-dList[i].mvNetAmtValue)*1000))+"</p> </td>";
				if(objToString(dList[i].mvRejectReasonDetail) != ""){
					str += "<td><p><a href=\"javascript:reasonAlert(\'"+dList[i].mvRejectReasonDetail+"\')\">Detail Reason</a></p><p>"+dList[i].mvInputTime+"</p> </td>";
				}else{
					str += "<td><p>-</p><p>"+dList[i].mvInputTime+"</p> </td>";
				}

				$("#"+targetId).html(str);

			}



		}
	}

	function accountbalance(){
		$.ajax({
			url:'/data/ttlCall.jsp',
			data:{chk:"accountbalance"},
		    dataType: 'json',
		    success: function(data){
		    	//console.log(">>>>>>>>>> accountBalance <<<<<<<<<<<<");
		    	//console.log(data)
		    	if(data != null){
		    		if(data.mvResult =="SYSTEM_MAINTENANCE"){
		    			location.href="/wts/US/logout.jsp";
		    			return;
		    		}
			    	var Ldata = data.mvList;

			    	if(Ldata.length == 0){
			    		////console.log(data)
			    		////console.log("accountbalance is No Data");
			    	}else{
			    		////console.log(data)
			    		$("#mvBuyingPowerd").text(Ldata[0].mvBuyingPowerd);
				    	$("#mvAvailableBalance").text(Ldata[0].mvAvailableBalance);
				    	$("#mvWithdrawableAmount").text(Ldata[0].mvWithdrawableAmount);
				    	$("#mvTemporaryHoldCash").text(Ldata[0].mvTemporaryHoldCash);
				    	$("#mvPendingBuy").text(Number(Ldata[0].mvPendingBuy.replace(/,/gi,""))*1000);
				    	$("#mvOutstandingLoan").text(Number(Ldata[0].mvOutstandingLoan)*1000);
				    	$("#mvBuyHoldAmount").text(Ldata[0].mvBuyHoldAmount);
				    	$("#mvPendingSettled").text(Ldata[0].mvPendingSettled);
				    	$("#mvAdvanceableAmount").text(Ldata[0].mvAdvanceableAmount);
			    	}
		    	}

		    },
		    error:function(e){
		    	//console.log(e);
		    	console.log("eeeeeeeeeee"+e)
		    }
		});
	}

function objToStringCenModi (obj,id,groupid) {
    var str = '';

    /* <input class="btn_del" type="button" value="delete">
	<button type="button">M</button> */

    if(typeof obj=='object'){
		str = "";
    }else{
        if(typeof obj=='string'){
        	if(obj.indexOf("Cancel_over") > -1){
        		//"resources/images/vi_VN/Modify_over.gif"
        		str = "<input type='button' class='btn_del' onClick='cancelOrder(\""+id+"\",\""+groupid+"\")' id='cancle_'"+id+" value='cancel'>";
        	}else if(obj.indexOf("Modify_over") > -1){
        		//"resources/images/vi_VN/Cancel_over.gif"
        		str = "<button onClick='genmodifyOrder(\""+id+"\",\""+groupid+"\")' id='ModifyOrder_'"+id+" type='button'>M</button>";
        	}

        }
    }
    return str;
}


function objToString (obj,id) {
    var str = '';
    if(typeof obj=='object'){
		str = "";
    }else{
        if(typeof obj=='string'){
        	str = "<input type='button' onClick='cancelOrder()' id='cancle_'"+id+" value='cancel'>";
        }
    }
    return str;
}

function reasonAlert(str){
	//console.log(str);
	alertMsg(str);
}

function oderTyleVal(str){
	var result = "";

	if(str == "L") result = "Normal";
	if(str == "O") result = "ATO";
	if(str == "C") result = "ATC";
	if(str == "P") result = "Put through";
	if(str == "M") result = "MP";
	if(str == "B") result = "MOK";
	if(str == "Z") result = "MAK";
	if(str == "R") result = "MTL";

	return result;
}


function mvStatusToString(stus){
	switch(stus){
		case "SOI":
			if ("<%= langCd %>" == "en_US") {
				stus = "Stop Inactive Order";	
			} else {
				stus = "Chưa kích hoạt";
			}
			break;
		case "IAV":
			if ("<%= langCd %>" == "en_US") {
				stus = "Inactive";
			} else {
				stus = "Chưa kích hoạt";
			}
			break;
		case "SOR":
			if ("<%= langCd %>" == "en_US") {
				stus = "Stop Ready";
			} else {
				stus = "Lệnh dừng";
			}
			break;
		case "PAP":
			if ("<%= langCd %>" == "en_US") {
				stus = "Pending Approval";
			} else {
				stus = "Chờ duyệt";
			}
			break;
		case "PAM":
			if ("<%= langCd %>" == "en_US") {
				stus = "Pending Approval";
			} else {
				stus = "Chờ duyệt";
			}
			break;
		case "PAS":
			if ("<%= langCd %>" == "en_US") {
				stus = "Pending Approval";
			} else {
				stus = "Chờ duyệt";
			}
			break;
		case "PAI":
			if ("<%= langCd %>" == "en_US") {
				stus = "Pending Approval";
			} else {
				stus = "Chờ duyệt";
			}
			break;
		case "PSB":
			if ("<%= langCd %>" == "en_US") {
			stus = "Ready To Send";
			} else {
				stus = "Sẵn sàng gửi";
			}
			break;
		case "STB":
			if ("<%= langCd %>" == "en_US") {
			stus = "Sending";
			} else {
				stus = "Đang gửi";
			}
			break;
		case "WRN":
			if ("<%= langCd %>" == "en_US") {
			stus = "Price Warning";
			} else {
				stus = "Cảnh báo giá";
			}
			break;
		case "BIX":
			if ("<%= langCd %>" == "en_US") {
			stus = "Queue";
			} else {
				stus = "Chờ khớp";
			}
			break;
		case "ACK":
			if ("<%= langCd %>" == "en_US") {
			stus = "Queue";
			} else {
				stus = "Chờ khớp";
			}
			break;
		case "AMS":
			if ("<%= langCd %>" == "en_US") {
			stus = "Modify Sent";
			} else {
				stus = "Đã gửi sửa";
			}
			break;
		case "ACS":
			if ("<%= langCd %>" == "en_US") {
			stus = "Cancel Sent";
			} else {
				stus = "Đã gửi hủy"
			}
			break;
		case "BPM":
			if ("<%= langCd %>" == "en_US") {
			stus = "Watting Cancel";
			} else {
				stus = "Chờ hủy";
			}
			break;
		case "BMS":
			if ("<%= langCd %>" == "en_US") {
			stus = "Sending";
			} else {
				stus = "Đang gửi";
			}
			break;
		case "BSS":
			if ("<%= langCd %>" == "en_US") {
			stus = "Sending";
			} else {
				stus = "Đang gửi";
			}
			break;
		case "REJ":
			if ("<%= langCd %>" == "en_US") {
			stus = "Reject";
			} else {
				stus = "Đã từ chối";
			}
			break;
		case "CAN":
			if ("<%= langCd %>" == "en_US") {
			stus = "Cancelled";
			} else {
				stus = "Đã hủy";
			}
			break;
		case "WA":
			if ("<%= langCd %>" == "en_US") {
				stus = "Waiting";
			} else {
				stus = "Chờ xác nhận";
			}
			break;
		case "FEX":
			if ("<%= langCd %>" == "en_US") {
				stus = "Fully Executed";
			} else {
				stus = "Khớp toàn bộ";
			}
			break;
		case "PEX":
			if ("<%= langCd %>" == "en_US") {
				stus = "Partially Filled";
			} else {
				stus = "Khớp một phần";
			}
			break;
		case "Q":
			if ("<%= langCd %>" == "en_US") {
				stus = "Queued";
			} else {
				stus = "Chờ khớp";
			}
			break;
		case "WC":
			if ("<%= langCd %>" == "en_US") {
			stus = "Waiting Cancel";
			} else {
				stus = "Chờ hủy";
			}
			break;
		case "WM":
			if ("<%= langCd %>" == "en_US") {
			stus = "Waiting Modify";
			} else {
				stus = "Chờ sửa";
			}
			break;
		case "KLL":
			if ("<%= langCd %>" == "en_US") {
			stus = "Killed";
			} else {
				stus = "Đã từ chối";
			}
			break;				
		case "FLL":
			if ("<%= langCd %>" == "en_US") {
			stus = "Fully Filled";
			} else {
				stus = "Khớp toàn bộ";
			}
			break;
		case "FLC":
			if ("<%= langCd %>" == "en_US") {
			stus = "Partial Filled (Partial Cancel)";
			} else {
				stus = "Khớp 1 phần (Hủy 1 phần)";
			}
			break;
		case "FAK":
			if ("<%= langCd %>" == "en_US") {
			stus = "Filled and Killed";
			} else {
				stus = "Khớp và hủy";
			}
			break;
		case "MPA":
			if ("<%= langCd %>" == "en_US") {
			stus = "Waiting Approval";
			} else {
				stus = "Chờ duyệt";
			}
			break;
		case "MPS":
			if ("<%= langCd %>" == "en_US") {
			stus = "Waiting Modify";
			} else {
				stus = "Chờ sửa";
			}
			break;
		case "MSD":
			if ("<%= langCd %>" == "en_US") {
			stus = "Sending";
			} else {
				stus = "Đang gửi";
			}
			break;
		case "WRR":
			if ("<%= langCd %>" == "en_US") {
			stus = "Price Warning";
			} else {
				stus = "Cảnh báo giá";
			}
			break;
		case "CPD":
			if ("<%= langCd %>" == "en_US") {
			stus = "Completed";
			} else {
				stus = "Đã hoàn thành";
			}
			break;
		case "EXP":
			if ("<%= langCd %>" == "en_US") {
			stus = "Expired";
			} else {
				stus = "Hết hiệu lực";
			}
			break;
		case "PXP":
			if ("<%= langCd %>" == "en_US") {
			stus = "Partially Expire";
			} else {
				stus = "Hết hạn 1 phần";
			}
			break;
		case "CON":
			if ("<%= langCd %>" == "en_US") {
			stus = "Conditional";
			} else {
				stus = "Lệnh điều kiện";
			}
			break;
		case "COI":
			if ("<%= langCd %>" == "en_US") {
			stus = "COI";
			} else {
				stus = "COI";
			}
			break;
		case "OCO":
			if ("<%= langCd %>" == "en_US") {
			stus = "OCO";
			} else {
				stus = "OCO";
			}
			break;
		case "OCI":
			if ("<%= langCd %>" == "en_US") {
			stus = "OCI";
			} else {
				stus = "OCI";
			}
			break;
		case "ALF":
			if ("<%= langCd %>" == "en_US") {
			stus = "Be Allocated";
			} else {
				stus = "Be Allocated (Fully Filled)";
			}
			break;
		case "UND":
			if ("<%= langCd %>" == "en_US") {
			stus = "Undefined";
			} else {
				stus = "Undefined";
			}
			break;
		case "NEW":
			if ("<%= langCd %>" == "en_US") {
				stus = "New";	
			} else {
				stus = "Chờ xử lý";
			}
			break;
		case "IAT":
			if ("<%= langCd %>" == "en_US") {
			stus = "Inactive";
			} else {
				stus = "Không hiệu lực";
			}
			break;
		case "SND":
			if ("<%= langCd %>" == "en_US") {
			stus = "Sending";
			} else {
				stus = "Đang gởi";
			}
			break;
		case "TRIG":
			if ("<%= langCd %>" == "en_US") {
			stus = "Trigger Order";
			} else {
				stus = "Lệnh điều kiện";
			}
			break;
		default:
			stus = "";
			break;
		}
	return stus;
}



function mvAlert(obj){
	var str = "";
	/*
	<div id="noticeForm" class="layer_bottom" style="display:none;">
			<strong id="nfCodeName">MAWMVN (Code)</strong>
			<p id="nfContent">(09:01) 134,500 ▲ 1,500 +5.08%, foreign +56,862 : 8Day continue net sale</p>
			<input class="close" type="button" value="close">
		</div> */


	for(var i = 0;i<obj.length;i++){
		str += '<strong id="nfCodeName">'+obj[i].stockId+' Update Type :'+obj[i].alertType+'</strong>';
		str += '<p id="nfContent">'+obj[i].alertTime+' , '+obj[i].orderStatus+' , '+obj[i].orderId+', '+obj[i].orderGroupId+'</p>';
		str += '<input class="close" type="button" value="close">';
	}

	$("#noticeForm").html(str).show();
	setTimeout(function(){
		$("#noticeForm").hide('slow');
	},6500);
}
	</script>
</head>
  <body class="mdi">

  	<div>
		<!-- header -->
		<header>
			<div class="container">
				<h1><img src="/resources/images/logo.png" alt="MIRAE ASSET WTS"></h1>

				<!-- information -->
				<div id="information">
					<h2 class="screen_out">최근 조회 종목,주요지수,주요뉴스</h2>
					<div class="wrap_ticker">
						<div>
							<h3 class="screen_out">주요지수 (국내/해외)</h3>
							<div class="group_index">
								<!-- KOSPI -->
								<div class="index_area">
									<h4>Dow Jones</h4>
									<ul class="items">
										<li class="item1 up">1,947.10</li>
										<li class="item2 up arrow"><span class="caret"></span>2.46</li>
										<li class="item3 up">+0.13</li>
									</ul>
									<div class="move_area">
										<button type="button" class="btn_prev"><span class="screen_out">이전</span></button>
										<button type="button" class="btn_next"><span class="screen_out">다음</span></button>
									</div>
								</div>
								<!-- //KOSPI -->
								<!-- DOW -->
								<div class="index_area pl25">
									<h4>DOW</h4>
									<ul class="items">
										<li class="item1 low">16,297.89</li>
										<li class="item2 low arrow"><span class="caret"></span>50.58</li>
										<li class="item3 low">-0.31</li>
									</ul>
									<div class="move_area">
										<button type="button" class="btn_prev"><span class="screen_out">이전</span></button>
										<button type="button" class="btn_next"><span class="screen_out">다음</span></button>
									</div>
								</div>
								<!-- //DOW -->
							</div>
							<!-- NEWS -->
							<div class="group_news">
								<h3 class="screen_out">주요뉴스</h3>
								<ul class="items">
									<li>VN NEWS , CSV - to Hold 2016 AGM on April 29... (11:00</li>
								</ul>
								<div class="move_area">
									<button type="button" class="btn_prev"><span class="screen_out">이전 뉴스</span></button>
									<button type="button" class="btn_next"><span class="screen_out">다음 뉴스</span></button>
								</div>
							</div>
							<!-- //NEWS -->
						</div>
					</div>
				</div>
				<!-- // information -->

				<!-- gnb -->
				<div class="group_gnb">
					<ul class="wts_menu">
						<li class="on">
							<button type="button">WATCH LIST</button>
						</li>
						<li class="wide">
							<button type="button">CURRENT STATUS</button>
						</li>
						<li class="wide">
							<button type="button">MARKET INFORMATION</button>
						</li>
						<li>
							<button type="button">INDEXCHART</button>
						</li>
						<li>
							<button type="button">BANKING</button>
						</li>
						<li class="wide">
							<button type="button">ACCOUNT INFORMATION</button>
						</li>
					</ul>
				</div>
				<!-- //gnb -->

				<div class="side">
					<div class="buttons">
						<button type="button">eng</button>
						<button type="button">viet</button>
						<button type="button">logout</button>
					</div>
					<div class="text">
						<strong>077C080123</strong>
						<em>Nnnnnn nnnn nnn</em>
						<em>Nnnnnn nnnn nnn</em>
						<span>Trandate 21/05/2016 18:18:18</span>
					</div>
				</div>
			</div>
		</header>
		<!-- //header -->


		<!-- 템플릿 사용부분 -->
		<div class="mdi_container">
			<div class="mdi_content">
				<!-- LEFT -->
				<div class="wrap_left">
					<!-- tabs -->
					<div name="tabs" id="whatchlist">
						<ul class="nav nav_tabs " role="tablist">
							<li role="presentation" class="active"><a href="#tab1" aria-controls="tab1" role="tab" data-toggle="tab">My Stocks</a></li>
							<li role="presentation"><a href="#tab2" aria-controls="tab2" role="tab" data-toggle="tab">Sector</a></li>
							<li role="presentation"><a href="#tab3" aria-controls="tab3" role="tab" data-toggle="tab">Ranking</a></li>
						</ul>
						<div class="tab_content">

							<div role="tabpanel" class="tab_pane" id="tab1">
								<!-- My Stocks -->
								<div class="btn_group">
									<div>
										<ul>
											<li><button class="on" type="button">Group 1</button></li>
											<li><button type="button">Group</button></li>
											<li><button type="button">Group</button></li>
											<li><button type="button">Group</button></li>
										</ul>
									</div>
									<div class="btn_paging">
										<button class="prev" type="button">prev</button>
										<button class="next" type="button">next</button>
									</div>
									<button class="btn_write" type="button">+ Add</button>
								</div>
								<div class="grid_area" style="height:199px; overflow:scroll;">
									<div class="group_table" style="widtH:990px;">
										<table class="table">
											<colgroup>
												<col width="35">
												<col width="35">
												<col width="40">
												<col width="40">
												<col width="40">
												<col width="60">
												<col width="40">
												<col width="60">
												<col width="40">
												<col width="40">
												<col width="70">
												<col width="50">
												<col width="70">
												<col width="40">
												<col width="40">
												<col width="40">
												<col width="40">
												<col width="70">
												<col width="70">
												<col>
											</colgroup>
											<thead>
												<tr>
													<th class="bd_bt2" colspan="2">Name</th>
													<th class="bd_bt2" colspan="3">Reference</th>
													<th class="bd_bt2" colspan="2">Best Bid</th>
													<th class="bd_bt2" colspan="5">Matching</th>
													<th class="bd_bt2" colspan="2">Best Ask</th>
													<th class="bd_bt2" colspan="3">Price history</th>
													<th class="bd_bt2" colspan="3">Foreign Investment</th>
												</tr>
												<tr>
													<th>Stock</th>
													<th>Market</th>
													<th>CE</th>
													<th>FL</th>
													<th>Ref</th>
													<th>Pri.1</th>
													<th>Vol.1</th>
													<th>Price</th>
													<th>Vol</th>
													<th>+/-</th>
													<th>%</th>
													<th>Total Vol.</th>
													<th>Pri.1</th>
													<th>Vol.1</th>
													<th>Open</th>
													<th>High</th>
													<th>Low</th>
													<th>F.Buy</th>
													<th>F.Sell</th>
													<th>Room</th>
												</tr>
											</thead>
											<tbody id="whatchListTbl">

											</tbody>
										</table>
									</div>
								</div>
								<!-- //My Stocks -->
							</div>

							<div role="tabpanel" class="tab_pane" id="tab2">
								<!-- Sector -->
								<div class="grid_area" style="height:199px;">
								Sector
								</div>
								<!-- //Sector -->
							</div>

							<div role="tabpanel" class="tab_pane" id="tab3">
								<!-- Ranking -->
								<div class="grid_area" style="height:199px;">
								Ranking
								</div>
								<!-- //Ranking -->
							</div>
						</div>
					</div>
					<!-- tabs -->
					<div name="tabs" id="stockInfo">
						<ul class="nav nav_tabs " role="tablist">
							<li role="presentation" class="active"><a href="#tab21" aria-controls="tab21" role="tab" data-toggle="tab">Order Journal</a></li>
							<li role="presentation"><a href="#tab22" aria-controls="tab22" role="tab" data-toggle="tab">Balance</a></li>
							<li role="presentation"><a href="#tab23" aria-controls="tab23" role="tab" data-toggle="tab">Chart</a></li>
							<li role="presentation"><a href="#tab24" aria-controls="tab24" role="tab" data-toggle="tab">Daily</a></li>
							<li role="presentation"><a href="#tab25" aria-controls="tab25" role="tab" data-toggle="tab">Timely</a></li>
							<li role="presentation"><a href="#tab26" aria-controls="tab26" role="tab" data-toggle="tab">Stock news</a></li>
							<!-- <li role="presentation"><a href="#tab26" aria-controls="tab26" role="tab" data-toggle="tab">Pending order</a></li>
							<li role="presentation"><a href="#tab27" aria-controls="tab27" role="tab" data-toggle="tab">Executed history</a></li> -->
						</ul>
						<div class="tab_content">
							<div role="tabpanel" class="tab_pane" id="tab21">
								<div class="search_area in total">
									<div class="pull_left">
										<label for="ojSel1">Select</label>
										<select id="ojSel1">
											<option>All</option>
										</select>
										<label for="ojSel2">Type</label>
										<select id="ojSel2">
											<option>All</option>
										</select>
										<label for="ojSel3">Buy/Sell</label>
										<select id="ojSel3">
											<option>All</option>
										</select>
									</div>
									<div class="pull_right">
										<span class="stock_search">
											<label for="stockInp">Stock</label>
											<input id="stockInp" type="text">
										</span>
										<button type="button" onClick="orderList()">Search</button>
										<span class="total">Total(Fee + Tax) : 0</span>
									</div>
								</div>
								<div class="grid_area" style="height:201px; overflow-y:scroll;">
									<div class="group_table center">
										<table class="table">
											<colgroup>
												<col width="70">
												<col width="70">
												<col width="95">
												<col width="95">
												<col width="95">
												<col width="95">
												<col width="95">
												<col>
											</colgroup>
											<thead>
												<tr>
													<th rowspan="2">Cancel /<br>Modify</th>
													<th rowspan="2">Stock</th>
													<th class="bd_bt2">Buy/Sell</th>
													<th class="bd_bt2">Vol</th>
													<th class="bd_bt2">Executed Vol.</th>
													<th rowspan="2">status</th>
													<th class="bd_bt2">Type</th>
													<th class="bd_bt2">Reject Reason</th>
												</tr>
												<tr>
													<th>Price (VND)</th>
													<th>Pending Vol.</th>
													<th>Avg Price.</th>
													<th>Fee + Tax</th>
													<th>Date</th>
												</tr>
											</thead>
											<tbody id="orderList">

											</tbody>
										</table>
									</div>
								</div>
							</div>

							<div role="tabpanel" class="tab_pane" id="tab22">
								<h3>Cash</h3>
								<div class="grid_area" style="height:120px;">
									<div class="group_table" style="width:800px;">
										<table class="table">
											<colgroup>
												<col width="90">
												<col width="100">
												<col width="70">
												<col width="70">
												<col width="100">
												<col width="80">
												<col width="80">
												<col width="80">
												<col>
											</colgroup>
											<thead>
												<tr>
													<th rowspan="2">Buying power</th>
													<th class="bd_bt2">Cash balance<br>(withdrawable)</th>
													<th rowspan="2">Available advance</th>
													<th rowspan="2">Temporary<br>hold cash</th>
													<th class="bd_bt2">Hold for pending<br>purchase</th>
													<th rowspan="2">Pending approval for withdrawal</th>
													<th class="bd_bt2">Outstanding loan</th>
													<th rowspan="2">Cash<br>Deposit</th>
													<th rowspan="2">Selling stock in<br>margin portfolio</th>
												</tr>
												<tr>
													<th>Withdrawable<br>(include advance)</th>
													<th>Hold for executed<br>purchase</th>
													<th class="low">Margin call<br>(By Options)</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td id="mvBuyingPowerd">00,000,000</td>
													<td>
														<p id="mvSettledBalance">000</p>
														<p id="mvWithdrawableAmount">000</p>
													</td>
													<td id="mvAdvanceableAmount">000</td>
													<td id="mvTemporaryHoldCash">000</td>
													<td>
														<p id="mvBuyHoldAmount">000</p>
														<p id="mvPendingSettled">000</p>
													</td>
													<td>000</td>
													<td>
														<p id="mvOutstandingLoan">00,000,000</p>
														<p class="low" >00,000,000</p>
													</td>
													<td id="mvSupplementCash">00</td>
													<td>00,000,000</td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
								<h3>Stock</h3>
								<div class="grid_area" style="height:190px; overflow:scroll;">
									<div class="group_table" style="width:980px;">
										<table class="table">
											<colgroup>
												<col width="30">
												<col width="50">
												<col width="80">
												<col width="80">
												<col width="80">
												<col width="80">
												<col width="80">
												<col width="80">
												<col width="80">
												<col width="80">
												<col width="80">
												<col width="80">
												<col>
											</colgroup>
											<thead>
												<tr>
													<th rowspan="3">No.</th>
													<th rowspan="3">Stock</th>
													<th class="bd_bt2" colspan="6">Volume</th>
													<th class="bd_bt2">Price</th>
													<th class="bd_bt2" colspan="2">Portfolio Assessment</th>
													<th class="bd_bt2" colspan="2">(%) Margin</th>
												</tr>
												<tr>
													<th class="bd_bt2">Total volume</th>
													<th class="bd_bt2">Hold in day</th>
													<th class="bd_bt2">T1 Buy</th>
													<th class="bd_bt2">Mortgage</th>
													<th class="bd_bt2">Await trading</th>
													<th class="bd_bt2">Await withdrawa</th>
													<th class="bd_bt2">Avg. price</th>
													<th class="bd_bt2">Buy value</th>
													<th class="bd_bt2">P/L</th>
													<th class="bd_bt2">%Lend</th>
													<th class="bd_bt2">%Maint.</th>
												</tr>
												<tr>
													<th>Usable</th>
													<th>T0 Buy</th>
													<th>T2 Buy</th>
													<th>Hold</th>
													<th>Await deposit</th>
													<th>Pend. entitlemen</th>
													<th>Current price</th>
													<th>Market value</th>
													<th>%P/L</th>
													<th>Lending value</th>
													<th>Maintenance value</th>
												</tr>
											</thead>
											<tbody id="stockInfoList">

											</tbody>
										</table>
									</div>
								</div>
							</div>

							<div role="tabpanel" class="tab_pane" id="tab23">
							Chart
							</div>
							<div role="tabpanel" class="tab_pane" id="tab24">
								Daily
							</div>

							<div role="tabpanel" class="tab_pane" id="tab25">
								<div class="grid_area" style="height:238px; overflow-y:scroll;">
									<div class="group_table">
										<table class="table">
											<colgroup>
												<col>
												<col width="120">
												<col width="120">
												<col width="120">
												<col width="120">
												<col width="120">
											</colgroup>
											<thead>
												<tr>
													<th>Time</th>
													<th>Current</th>
													<th>+/-</th>
													<th>%Change</th>
													<th>Executed vol.</th>
													<th>Volume</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td class="text_center">09:49:17</td>
													<td>00,000,000</td>
													<td class="arrow up">00,000,000</td>
													<td class="low">-000</td>
													<td>000</td>
													<td>00,000,000</td>
												</tr>
												<tr>
													<td class="text_center">09:49:17</td>
													<td>00,000,000</td>
													<td class="arrow up">00,000,000</td>
													<td class="low">-000</td>
													<td>000</td>
													<td>00,000,000</td>
												</tr>
												<tr>
													<td class="text_center">09:49:17</td>
													<td>00,000,000</td>
													<td class="arrow up">00,000,000</td>
													<td class="low">-000</td>
													<td>000</td>
													<td>00,000,000</td>
												</tr>
												<tr>
													<td class="text_center">09:49:17</td>
													<td>00,000,000</td>
													<td class="arrow up">00,000,000</td>
													<td class="low">-000</td>
													<td>000</td>
													<td>00,000,000</td>
												</tr>
												<tr>
													<td class="text_center">09:49:17</td>
													<td>00,000,000</td>
													<td class="arrow up">00,000,000</td>
													<td class="low">-000</td>
													<td>000</td>
													<td>00,000,000</td>
												</tr>
												<tr>
													<td class="text_center">09:49:17</td>
													<td>00,000,000</td>
													<td class="arrow up">00,000,000</td>
													<td class="low">-000</td>
													<td>000</td>
													<td>00,000,000</td>
												</tr>
												<tr>
													<td class="text_center">09:49:17</td>
													<td>00,000,000</td>
													<td class="arrow up">00,000,000</td>
													<td class="low">-000</td>
													<td>000</td>
													<td>00,000,000</td>
												</tr>
												<tr>
													<td class="text_center">09:49:17</td>
													<td>00,000,000</td>
													<td class="arrow up">00,000,000</td>
													<td class="low">-000</td>
													<td>000</td>
													<td>00,000,000</td>
												</tr>
												<tr>
													<td class="text_center">09:49:17</td>
													<td>00,000,000</td>
													<td class="arrow up">00,000,000</td>
													<td class="low">-000</td>
													<td>000</td>
													<td>00,000,000</td>
												</tr>
												<tr>
													<td class="text_center">09:49:17</td>
													<td>00,000,000</td>
													<td class="arrow up">00,000,000</td>
													<td class="low">-000</td>
													<td>000</td>
													<td>00,000,000</td>
												</tr>
												<tr>
													<td class="text_center">09:49:17</td>
													<td>00,000,000</td>
													<td class="arrow up">00,000,000</td>
													<td class="low">-000</td>
													<td>000</td>
													<td>00,000,000</td>
												</tr>
												<tr>
													<td class="text_center">09:49:17</td>
													<td>00,000,000</td>
													<td class="arrow up">00,000,000</td>
													<td class="low">-000</td>
													<td>000</td>
													<td>00,000,000</td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>

							<div role="tabpanel" class="tab_pane" id="tab26">
								Stock news
							</div>

							<div role="tabpanel" class="tab_pane" id="tab26" style="display:none;">
								<div class="search_area in total">
									<div class="pull_left">
										<div class="radio_area">
											<input type="radio" id="" name=""><label for="">All</label>
											<input type="radio" id="" name=""><label for="">SELL</label>
											<input type="radio" id="" name=""><label for="">BUY</label>
										</div>
									</div>
									<div class="pull_right">
										<button type="button">Search</button>
									</div>
								</div>
								<div class="grid_area" style="height:199px;">
									<div class="group_table">
										<table class="table">
											<colgroup>
												<col width="70">
												<col width="70">
												<col>
												<col width="120">
												<col width="120">
												<col width="120">
												<col width="120">
											</colgroup>
											<thead>
												<tr>
													<th></th>
													<th>No.</th>
													<th>Stock | Market</th>
													<th>Order Type</th>
													<th>Order volume</th>
													<th>Order price</th>
													<th>Pending vol.</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td class="btn_del"><input type="button" value="delete"></td>
													<td class="text_center">000</td>
													<td class="text_left">ABV (HNX)</td>
													<td class="text_center">Type</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
												</tr>
												<tr class="even">
													<td class="btn_del"><input type="button" value="delete"></td>
													<td class="text_center">000</td>
													<td class="text_left">ABV (HNX)</td>
													<td class="text_center">Type</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
												</tr>
												<tr>
													<td class="btn_del"><input type="button" value="delete"></td>
													<td class="text_center">000</td>
													<td class="text_left">ABV (HNX)</td>
													<td class="text_center">Type</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
												</tr>
												<tr class="even">
													<td class="btn_del"><input type="button" value="delete"></td>
													<td class="text_center">000</td>
													<td class="text_left">ABV (HNX)</td>
													<td class="text_center">Type</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
												</tr>
												<tr>
													<td class="btn_del"><input type="button" value="delete"></td>
													<td class="text_center">000</td>
													<td class="text_left">ABV (HNX)</td>
													<td class="text_center">Type</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
												</tr>
												<tr class="even">
													<td class="btn_del"><input type="button" value="delete"></td>
													<td class="text_center">000</td>
													<td class="text_left">ABV (HNX)</td>
													<td class="text_center">Type</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
												</tr>
												<tr>
													<td class="btn_del"><input type="button" value="delete"></td>
													<td class="text_center">000</td>
													<td class="text_left">ABV (HNX)</td>
													<td class="text_center">Type</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
												</tr>
												<tr class="even">
													<td class="btn_del"><input type="button" value="delete"></td>
													<td class="text_center">000</td>
													<td class="text_left">ABV (HNX)</td>
													<td class="text_center">Type</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
												</tr>
												<tr>
													<td class="btn_del"><input type="button" value="delete"></td>
													<td class="text_center">000</td>
													<td class="text_left">ABV (HNX)</td>
													<td class="text_center">Type</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
												</tr>
												<tr class="even">
													<td class="btn_del"><input type="button" value="delete"></td>
													<td class="text_center">000</td>
													<td class="text_left">ABV (HNX)</td>
													<td class="text_center">Type</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
													<td>00,000,000</td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>

							<div role="tabpanel" class="tab_pane" id="tab27" style="display:none;">
								<div class="search_area in total">
									<div class="pull_left">
										<div class="stock_search">
											<strong>Stock</strong>
											<input class="text" type="text" id="" name="">
										</div>
									</div>
									<div class="pull_right">
										<button type="button">Search</button>
									</div>
								</div>
								<div class="grid_area" style="height:199px;">
									<div class="group_table">
										<table class="table">
											<colgroup>
												<col width="90">
												<col width="100">
												<col width="100">
												<col width="100">
												<col width="100">
												<col width="100">
												<col>
											</colgroup>
											<thead>
												<tr>
													<th>No.</th>
													<th rowspan="2">Stock | Market</th>
													<th class="bd_bt2">Order Type</th>
													<th class="bd_bt2">Order vol.</th>
													<th class="bd_bt2">Order price</th>
													<th class="bd_bt2">Pending vol.</th>
													<th class="bd_bt2">Modify vol.</th>
													<th rowspan="2">Status</th>
												</tr>
												<tr>
													<th>Original Order</th>
													<th>Trading Type</th>
													<th>Executed vol.</th>
													<th>Executed price</th>
													<th>Executed value amount</th>
													<th>Cancel vol.</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td class="text_left">
														<p class="btn_del">
															<input type="button" value="delete">
															<span>000</span>
														</p>
														<p class="text_center">00,000,000</p>
													</td>
													<td class="text_left">ABV (HNX)</td>
													<td class="text_center">
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>00,000,000</td>
												</tr>
												<tr class="even">
													<td class="text_center">
														<p class="btn_del">
															<input type="button" value="delete">
															<span>000</span>
														</p>
														<p class="text_center">00,000,000</p>
													</td>
													<td class="text_left">ABV (HNX)</td>
													<td class="text_center">
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>00,000,000</td>
												</tr>
												<tr>
													<td class="text_left">
														<p class="btn_del">
															<input type="button" value="delete">
															<span>000</span>
														</p>
														<p class="text_center">00,000,000</p>
													</td>
													<td class="text_left">ABV (HNX)</td>
													<td class="text_center">
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>00,000,000</td>
												</tr>
												<tr class="even">
													<td class="text_center">
														<p class="btn_del">
															<input type="button" value="delete">
															<span>000</span>
														</p>
														<p class="text_center">00,000,000</p>
													</td>
													<td class="text_left">ABV (HNX)</td>
													<td class="text_center">
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>
														<p>00,000,000</p>
														<p>00,000,000</p>
													</td>
													<td>00,000,000</td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- //LEFT -->
				<!-- RIGHT -->
				<div class="wrap_right">

					<!-- tabs -->
					<div name="tabs" id="current">
						<ul class="nav nav_tabs mgt0" role="tablist">
							<li role="presentation" class="active"><a href="#tab31" aria-controls="tab31" role="tab" data-toggle="tab">BID</a></li>
							<!-- <li role="presentation"><a href="#tab32" aria-controls="tab32" role="tab" data-toggle="tab">CUR</a></li> -->
						</ul>
						<div class="tab_content">
							<div role="tabpanel" class="tab_pane" id="tab31">
								<!-- BID -->
								<div class="group_table price">
									<table class="table">
										<colgroup>
											<col width="14.5%">
											<col width="20.5%">
											<col>
											<col width="22.5%">
											<col width="20.5%">
										</colgroup>
										<thead>
											<tr>
												<th>Eve</th>
												<th>Sell</th>
												<th>13:28:21</th>
												<th>Buy</th>
												<th>Eve</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td class="bg_blue text_left up"><div>+100</div></td>
												<td id="BidmvBestBid1Volume" class="bg_blue bar"><div>1,766<div style="width:50%;"></div></div></td>
												<td id="BidmvBestBid1Price" class="bg_blue bold"><div class="low sel_box"><div></div></td>
												<th class="white text_left"><div>CUR</div></th>
												<td id="BidmvNominalPrice"><div></div></td>
											</tr>
											<tr>
												<td class="bg_blue text_left up"><div>+100</div></td>
												<td id="BidmvBestBid2Volume" class="bg_blue bar"><div>1,766<div style="width:80%;"></div></div></td>
												<td id="BidmvBestBid2Price" class="bg_blue bold"><div class="same sel_box"><div></div></div></td>
												<th class="white text_left"><div>Change</div></th>
												<td id="BidmvNoalPriSubRefPri"><div></div></td>
											</tr>
											<tr>
												<td class="bg_blue bd_bt2"><div></div></td>
												<td id="BidmvBestBid3Volume" class="bg_blue bd_bt2"><div></div></td>
												<td id="BidmvBestBid3Price" class="bg_blue bold bd_bt2"><div class="up sel_box"><div></div></div></td>
												<th class="white text_left bd_bt2"><div>%Chg</div></th>
												<td class="bd_bt2"><div id="BidmvNoalPriPerRate"></div></td>
											</tr>

											<tr>
												<th class="white text_left"><div>Open</div></th>
												<td><div id="BidmvOpenPrice"></div></td>
												<td id="BidmvBestOffer3Price" class="bg_red bold"><div class="low sel_box"><div></div></div></td>
												<td id="BidmvBestOffer3Volume" class="bg_red text_right"><div></div></td>
												<td class="bg_red"><div></div></td>
											</tr>
											<tr>
												<th class="white text_left"><div>High</div></th>
												<td><div id="BidmvHighPrice"></div></td>
												<td id="BidmvBestOffer2Price" class="bg_red bold"><div class="up arrow sel_box"><div></div></div></td>
												<td id="BidmvBestOffer2Volume" class="bg_red text_right bar"><div>00<div style="width:50%;"></div></div></td>
												<td class="bg_red"><div></div></td>
											</tr>
											<tr>
												<th class="white text_left bd_bt2"><div>Low</div></th>
												<td class="bd_bt2"><div id="BidmvLowPrice"></div></td>
												<td id="BidmvBestOffer1Price" class="bg_red bold bd_bt2"><div class="low arrow sel_box"><div></div></div></td>
												<td id="BidmvBestOffer1Volume" class="bg_red text_right bd_bt2 bar"><div><div style="width:80%;"></div></div></td>
												<td class="bg_red bd_bt2"><div></div></td>
											</tr>
											<tr>
												<th  class="white text_left bd_bt2"><div id="BidmvMatchQty">Volume</div></th>
												<td class="bd_bt2"><div id="BidmvMatchQty"></div></td>
												<td class="bold" rowspan="2"><div class="up sel_box"><div></div></div></td>
												<th class="white text_left bd_bt2"><div>Last volume</div></th>
												<td><div></div></td>
											</tr>
											<tr>
												<td class="text_left"><div></div></td>
												<td><div>1,766</div></td>
												<td class="low"><div></div></td>
												<td><div></div></td>
											</tr>
										</tbody>
									</table>
								</div>
								<!-- //BID -->
							</div>
							<div role="tabpanel" class="tab_pane" id="tab32" style="display:none;">
								<!-- CUR -->
								<ul class="summary_area">
									<li>HNX</li>
									<li>large-cap<br>(stock)</li>
									<li>HNX300</li>
									<li>Normal 30%<br>Credit</li>
								</ul>
								<div class="group_table type1">
									<table class="table">
										<colgroup>
											<col width="23%">
											<col width="30%">
											<col width="23%">
											<col>
										</colgroup>
										<tbody>
											<tr>
												<th>CUR</th>
												<td>17,000</td>
												<th>Cei</th>
												<td>22,550</td>
											</tr>
											<tr>
												<th>+/-</th>
												<td class="up arrow">350</td>
												<th>Flo</th>
												<td>12,150</td>
											</tr>
											<tr>
												<th>%Change</th>
												<td>-2.02</td>
												<th>Limt</th>
												<td>5,200</td>
											</tr>
											<tr>
												<th>Ask vol</th>
												<td>17,000</td>
												<th>BID Unit</th>
												<td>50</td>
											</tr>
											<tr>
												<th>Bid vol</th>
												<td>16,950</td>
												<th>Face val</th>
												<td>5,000
												(VND)</td>
											</tr>
											<tr>
												<th>Open</th>
												<td>17,200</td>
												<th>Capital</th>
												<td>5,714 VND</td>
											</tr>
											<tr>
												<th>High</th>
												<td>17,350</td>
												<th>Issued</th>
												<td>114,285,871</td>
											</tr>
											<tr>
												<th>Low</th>
												<td>16,950</td>
												<th>FL. Room</th>
												<td>114,285,871</td>
											</tr>
											<tr>
												<th>Prev Close</th>
												<td>17,350</td>
												<th>T. Room</th>
												<td>102,133,389</td>
											</tr>
											<tr>
												<th>Last vol</th>
												<td>732,702</td>
												<th>For. Room</th>
												<td>10.63</td>
											</tr>
											<tr>
												<th>Volume</th>
												<td>411,851</td>
												<th>For.Buy</th>
												<td>9,000</td>
											</tr>
											<tr>
												<th>Total PRI</th>
												<td>7,059M VMD</td>
												<th>For. Sell</th>
												<td>9,000</td>
											</tr>
											<tr>
												<th>Mkt Cap</th>
												<td>19,429 (BVMD)</td>
												<th></th>
												<td></td>
											</tr>
										</tbody>
									</table>
								</div>
								<!-- //CUR -->
							</div>
						</div>
					</div>
					<!-- tabs -->
					<div name="tabs" id="orders">
						<ul class="nav nav_tabs mgt0" role="tablist">
							<li role="presentation" class="active"><a href="#tab41" aria-controls="tab41" role="tab" data-toggle="tab">ENTER ORDER</a></li>
							<!-- <li role="presentation"><a href="#tab42" aria-controls="tab42" role="tab" data-toggle="tab">SELL</a></li>
							<li role="presentation"><a href="#tab43" aria-controls="tab43" role="tab" data-toggle="tab">MODIFY</a></li>
							<li role="presentation"><a href="#tab44" aria-controls="tab44" role="tab" data-toggle="tab">CANCEL</a></li> -->
						</ul>
						<div class="tab_content">
							<div role="tabpanel" class="tab_pane" id="tab41">
								<!-- BUY -->
								<div class="group_table type4">
									<!-- <div class="search_area in total">
										<div class="radio_area">
											<input type="radio" id="a1" name="aa"><label for="a1">General</label>
											<input type="radio" id="a2" name="aa"><label for="a2">Credit</label>
										</div>
									</div> -->
									<table>
										<caption></caption>
										<colgroup>
											<col width="160">
											<col>
										</colgroup>
										<!-- <tr>
											<th>Symbol</th>
											<td>
												<div class="search_area">
													<label for="" class="screen_out">화면번호 검색</label>
													<input type="text" id="" class="search_num" value="037620">
													<button type="button" class="btn_recent"><span class="screen_out">최근조회 목록 보기</span></button>

													<button type="button" class="btn_search" name="refcode_search"><span class="screen_out">검색하기</span></button>
													<input class="search_input" type="text" value="Stock Code">
												</div>
											</td>
										</tr> -->
										<tr>
											<th>Buy/Sell</th>
											<td>
												<div class="radio_area">
													<input type="radio" id="orderBSb" name="orderBSall" value="B" checked><label for="orderBSb">Buy</label>
													<input type="radio" id="orderBSs" name="orderBSall" value="S"><label for="orderBSs">Sell</label>
												</div>
											</td>
										</tr>
										<tr>
											<th>Buy all / Sell all</th>
											<td>
												<div class="radio_area">
													<input type="radio" id="orderBSallb" name="orderBSall" value="B"><label for="orderBSallb">Buy</label>
													<input type="radio" id="orderBSalls" name="orderBSall" value="S"><label for="orderBSalls">Sell</label>
												</div>
											</td>
										</tr>
										<tr>
											<th>Stock / % Lending</th>
											<td><span id="buystockCodeVal"></span> / <span id="lending"></span> %</td>
										</tr>
										<tr>
											<th> Expected (buying Power)</th>
											<td id="enterOrderExpected">000,000,000</td>
										</tr>
										<tr>
											<th>Order Type</th>
											<td>
												<select id="orderType" title="주문옵션구분선택">
													<option value="L">LO</option>
													<option value="O">ATO</option>	<!-- opening price -->
													<option value="C">ATC</option>	<!-- closing price -->
													<option value="M">MP</option>	<!-- 상한가 -->
													<option value="Z">MAK</option>  <!-- 부분체결 되면 나머지는 캔슬 -->
													<option value="B">MOK</option>	<!-- 전원 체켤이 안되면 완전 캔슬 -->
													<option value="R">MTL</option>	<!-- 100주중 50주만 체결되면 나머지는 한틱 더 높은 가겨으로 주문 -->
												</select>
											</td>
										</tr>
										<tr>
											<th>Volume</th>
											<td><input class="text won" id="buyordValume" type="text" value="0 VND"></td>
										</tr>
										<tr>
											<th>Price</th>
											<td><input class="text won" id="buyordPrice" type="text" value="0 VND"></td>
										</tr>
										<tr>
											<th>value</th>
											<td id="buyordvalue"></td>
										</tr>
										<tr>
											<th>Net fee</th>
											<td id="enterOrderNetfee">0.00</td>
										</tr>
										<tr>
											<th>Expiry date</th>
											<td>
												<input type="checkbox">
												<input type="text" class="datepicker" placeholder="">
											</td>
										</tr>
										<tr>
											<th>Advanced</th>
											<td>
												<input type="checkbox">
												<input type="text" class="datepicker" placeholder="">
											</td>
										</tr>
									</table>

									<div class="mdi_bottom cb">
										<!-- <strong class="share">
											Available for purchase<br><em>0</em> shares
										</strong> -->
										<input type="submit" onClick="queryMarketStatusInfo()" value="submit">
										<input type="reset" value="reset">
									</div>
								</div>
								<!-- //BUY -->
							</div>

							<div role="tabpanel" class="tab_pane" id="tab42" style="display:none;">
								<!-- SELL -->
								<div class="group_table type4">
									<div class="search_area in total">
										<div class="radio_area">
											<input type="radio" id="" name=""><label for="">General</label>
											<input type="radio" id="" name=""><label for="">Credit</label>
										</div>
									</div>
									<table>
										<caption></caption>
										<colgroup>
											<col width="100">
											<col>
										</colgroup>
										<tr>
											<th>Symbol</th>
											<td>
												<div class="search_area">
													<label for="" class="screen_out">화면번호 검색</label>
													<input type="text" id="" class="search_num" value="037620">
													<button type="button" class="btn_recent"><span class="screen_out">최근조회 목록 보기</span></button>
													<!-- layer_newest -->
													<div class="layer_newest" style="display:none;">
														<ul>
															<li>
																<strong>일이삼사오육칠팔구십</strong><em>000000</em>
																<input type="button" value="삭제후닫기">
															</li>
															<li>
																<strong>일이삼사오육칠팔구십</strong><em>000000</em>
																<input type="button" value="삭제후닫기">
															</li>
															<li>
																<strong>일이삼사오육</strong><em>000000</em>
																<input type="button" value="삭제후닫기">
															</li>
															<li>
																<strong>일이삼사오육칠팔구십</strong><em>000000</em>
																<input type="button" value="삭제후닫기">
															</li>
														</ul>
														<button type="button">전체삭제</button>
													</div>
													<!-- //layer_newest -->
													<button type="button" class="btn_search" name="refcode_search"><span class="screen_out">검색하기</span></button>
													<input class="search_input" type="text" value="Stock Code">
												</div>
												<!-- <button type="button">신용가능</button> -->
											</td>
										</tr>
										<tr>
											<th>Order Type</th>
											<td>
												<select id="" title="주문옵션구분선택">
													<option>시간외</option>
													<option>최유리</option>
													<option>최우선</option>
													<option>조건부</option>
												</select>
											</td>
										</tr>
										<tr>
											<th><strong>Price</strong></th>
											<td>
												<input class="text won" type="text" value="0 VND">
											</td>
										</tr>
										<tr>
											<th><strong>Volume</strong></th>
											<td>
												<input class="text won" type="text" value="0 Shares">
											</td>
										</tr>
									</table>

									<div class="mdi_bottom cb">
										<strong class="share">
											Available for purchase<br><em>0</em> shares
										</strong>
										<button type="button">SELL</button>
									</div>
								</div>
								<!-- //SELL -->
							</div>

							<div role="tabpanel" class="tab_pane" id="tab43" style="display:none;">
								<!-- MODIFY -->
								<div class="group_table type4">
									<table>
										<caption></caption>
										<colgroup>
											<col width="100">
											<col>
										</colgroup>
										<tr>
											<th>Symbol</th>
											<td>
												<div class="search_area">
													<label for="" class="screen_out">화면번호 검색</label>
													<input type="text" id="" class="search_num" value="037620">
													<button type="button" class="btn_recent"><span class="screen_out">최근조회 목록 보기</span></button>
													<!-- layer_newest -->
													<div class="layer_newest" style="display:none;">
														<ul>
															<li>
																<strong>일이삼사오육칠팔구십</strong><em>000000</em>
																<input type="button" value="삭제후닫기">
															</li>
															<li>
																<strong>일이삼사오육칠팔구십</strong><em>000000</em>
																<input type="button" value="삭제후닫기">
															</li>
															<li>
																<strong>일이삼사오육</strong><em>000000</em>
																<input type="button" value="삭제후닫기">
															</li>
															<li>
																<strong>일이삼사오육칠팔구십</strong><em>000000</em>
																<input type="button" value="삭제후닫기">
															</li>
														</ul>
														<button type="button">전체삭제</button>
													</div>
													<!-- //layer_newest -->
													<button type="button" class="btn_search" name="refcode_search"><span class="screen_out">검색하기</span></button>
													<input class="search_input" type="text" value="Stock Code">
												</div>
											</td>
										</tr>
										<tr>
											<th>Modify Type</th>
											<td>
												<div class="radio_area">
													<input type="radio" id="" name=""><label for="">All modify</label>
													<input type="radio" id="" name=""><label for="">Part modify</label>
												</div>
											</td>
										</tr>
										<tr>
											<th>Original Order</th>
											<td>
												<input class="text won" type="text" value="0">
											</td>
										</tr>
										<tr>
											<th><strong>Price</strong></th>
											<td>
												<input class="text won" type="text" value="0 VND">
											</td>
										</tr>
										<tr>
											<th><strong>Volume</strong></th>
											<td>
												<input class="text won" type="text" value="0 Shares">
											</td>
										</tr>
									</table>

									<div class="mdi_bottom cb">
										<strong class="share">
											<input class="text" type="text" placeholder="Order No.">
										</strong>
										<button type="button">MODIFY</button>
									</div>
								</div>
								<!-- //MODIFY -->
							</div>

							<div role="tabpanel" class="tab_pane active" id="tab44" style="display:none;">
								<!-- CANCEL -->
								<div class="group_table type4">
									<table>
										<caption></caption>
										<colgroup>
											<col width="100">
											<col>
										</colgroup>
										<tr>
											<th>Symbol</th>
											<td>
												<div class="search_area">
													<label for="" class="screen_out">화면번호 검색</label>
													<input type="text" id="" class="search_num" value="037620">
													<button type="button" class="btn_recent"><span class="screen_out">최근조회 목록 보기</span></button>
													<!-- layer_newest -->
													<div class="layer_newest" style="display:none;">
														<ul>
															<li>
																<strong>일이삼사오육칠팔구십</strong><em>000000</em>
																<input type="button" value="삭제후닫기">
															</li>
															<li>
																<strong>일이삼사오육칠팔구십</strong><em>000000</em>
																<input type="button" value="삭제후닫기">
															</li>
															<li>
																<strong>일이삼사오육</strong><em>000000</em>
																<input type="button" value="삭제후닫기">
															</li>
															<li>
																<strong>일이삼사오육칠팔구십</strong><em>000000</em>
																<input type="button" value="삭제후닫기">
															</li>
														</ul>
														<button type="button">전체삭제</button>
													</div>
													<!-- //layer_newest -->
													<button type="button" class="btn_search" name="refcode_search"><span class="screen_out">검색하기</span></button>
													<input class="search_input" type="text" value="Stock Code">
												</div>
											</td>
										</tr>
										<tr>
											<th>Cancel Type</th>
											<td>
												<div class="radio_area">
													<input type="radio" id="" name=""><label for="">All cancel</label>
													<input type="radio" id="" name=""><label for="">Part cancel</label>
												</div>
											</td>
										</tr>
										<tr>
											<th>Original Order</th>
											<td>
												<input class="text won" type="text" value="0">
											</td>
										</tr>
										<tr>
											<th><strong>Volume</strong></th>
											<td>
												<input class="text won" type="text" value="0 Shares">
											</td>
										</tr>
									</table>

									<div class="mdi_bottom cb">
										<strong class="share">
											<input class="text" type="text" placeholder="Order No.">
										</strong>
										<button type="button">CANCEL</button>
									</div>
								</div>
								<!-- //CANCEL -->
							</div>

						</div>
					</div>
				</div>
				<!-- //RIGHT -->
			</div>
		</div>
		<!-- //템플릿 사용부분 -->
		<%--
		<%@ include file = "<c:url value="/include/footer.jsp"/>" %>
		 --%>
  	</div>
  </body>
</html>