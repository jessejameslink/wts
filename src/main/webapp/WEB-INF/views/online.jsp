<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>ONLINE SERVICE</title>
<script type="text/javascript" src="<c:url value="/resources/js/jquery.min.js"/>" /></script>
<script type="text/javascript" src="<c:url value="/resources/js/jquery-ui.min.js"/>" /></script>
<script type="text/javascript" src="<c:url value="/resources/js/ajaxCommon.js"/>" /></script>

<script>
	$(document).ready(function() {
		// Button Event Start.
		$("#btnSubmit").click(function() {
			//authCardMatrix.action
			//submitAdvancePaymentCreation();
			//
			if(doValidateAdvance()){
				//checkAdvancePaymentTime();
				var param = {
						chk	:"checkAdvancePaymentTime"
				}
				
				$.ajax({
					url:'/data/ttlCall.jsp',
					data:param,
				    dataType: 'json',
				    success: function(data){
					 	//console.log(data);
					 	if(data.mvResult.length > 0){
					 		alert("err : mvResult.length > 0");

					 	}else{
					 		alert("Open Popup");
					 		//팝업에서 OK 하면
					 		//doAdvancePayment() 호출
					 		popupOpen(this);
					 	}
					}
				});
			}
		});

		$("#btnReset").click(function() {
			alert("버튼리셋");
		});
		// Button Event End.

		getCashAdvancePlace();
		getOrderMatchingList();
		getCashAdvanceTransaction();
	});

	function popupOpen(popUrl){
		var popOption = "width=370, height=360, resizable=no, menubar=no, location=no, scrollbars=no, status=no, directories=no;";    //팝업창 옵션(optoin)
		window.open(popUrl,"",popOption);
	}

	// 콤마 찍기
	function numberWithCommas(x) {
	    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}

	// Key Event
	function keyUpEvent() {
		$("#txtAdvancePayment").val(parseInt($("#txtAdvancePayment").val()));

		if($("#txtAdvancePayment").val() == "NaN"){
			$("#txtAdvancePayment").val("");
			$("#advanceFee").html(0);
		}
		if(parseInt($("#txtAdvancePayment").val()) > 0){
			if( parseFloat($("#cashAdvanceAvailable").text())*1000 <= $("#txtAdvancePayment").val()){
				$("#advanceFee").html(parseFloat($("#cashAdvanceAvailable").text()) * 0.0008);
			}else{
				$("#advanceFee").html(parseInt($("#txtAdvancePayment").val() * 0.0008));
			}
		}
	}

	function doValidateAdvance() {
		var advPayment = parseInt($("#txtAdvancePayment").val());
		if (advPayment <= 0) {
	    	//TTLUtils.showMessage( messageBox.title.error, messageBox.message.noAmount);
	        alert("err .");
	    	return false;
	    }

		/* var advanceAvailable = parseFloat(TTL.Utils.toTTLCurrencyFormat(me.txtAdvanceAvailable.getValue()));
	    advPayment = TTL.Utils.devideByCurrencyUnit(advPayment);
	    if (advanceAvailable < advPayment) {
	    	//TTLUtils.showMessage( messageBox.title.error, advance.msg.insufficientFund);
	    	alert("err 2.");
            return false;
        } */

	    return true;
	}

	function doAdvancePayment(mvSeriNo, mvAnswer, authenWin, saveAuthen){	}

	function submitAdvancePaymentCreation() {
		var param = {
				chk						:"submitAdvancePaymentCreation",
				lvAdvAvaiable					:numIntFormat(parseFloat(lvAdvAvaiable) * 1000),
				lvAdvRequest					:$("#advanceAmount").val(),
				lvAmount					:$("#advanceAmount").val()/1000,
				mvSeriNo					:"[5,A]|[4,F]",
				mvAnswer					:"7|4",
				mvSaveAuthenticate		:true
				
		};
		//console.log("submitAdvancePaymentCreation");
		$.ajax({
			url:'/data/ttlCall.jsp',
			data:param,
		    dataType: 'json',
		    success: function(data){
			 	//console.log(data);
			 	alert(data);
		    }

		});
	}

	function getCashAdvancePlace(){

		var param = {
				chk						:"getLocalAdvanceCreation",
				mvLastAction			:"OTHERSERVICES",
				mvChildLastAction		:"ADVANCEPAYMENT"

		};
		//console.log("Advance Place");
		$.ajax({
			url:'/data/ttlCall.jsp',
			data:param,
		    dataType: 'json',
		    success: function(data){
			 	//console.log(data);
			 	if(data.mvAdvanceBean != null){
			 		$("#cashAdvanceAvailable").html(data.mvAdvanceBean.advAvailable);
			 		$("#advanceFee").html(data.mvAdvanceBean.advFee);
			 	}else{
					alert("");
			 	}
		    }

		});
	}

	function getCashAdvanceTransaction(){

		var param = {
				chk						:"getCashAdvanceHistory",
				mvLastAction			:"OTHERSERVICES",
				mvChildLastAction		:"ADVANCEPAYMENT",
				key						:new Date().getTime(),
				_dc						:new Date().getTime(), // 수정중
				start	:0,
				limit	:15,
				page	:1
		};
		//console.log("Cash Advance Transaction");
		$.ajax({
			url:'/data/ttlCall.jsp',
			data:param,
		    dataType: 'json',
		    success: function(data){
			 	//console.log(data);
			 	if(data.list != null){
			 		var strList = "";
			 		for(var i = 0; i<data.list.length; i++){
			 			strList += "<tr>"
					 				+ "<td class='text_center'>" + data.list[i].creationTime + "</td>"		//
					 				+ "<td class='text_center'>" + data.list[i].totalLendingAmt + "</td>" 	// 콤마(.) * 1000
					 				+ "<td class='text_center'>" + data.list[i].interestAccured + "</td>" 	// Ad fee
					 				+ "<td class='text_center'>" + data.list[i].status + "</td>"		//	Status
					 				+ "<td class='text_center'>" + data.list[i].lastApprovaltime + "</td>"		// Last Update
					 				+ "<td class='text_center'>" + data.list[i].remark + "</td>"		// Note
					 				+ "</td>";
			 		}
			 		$("#advanceTransaction").html(strList);
			 	}else{
					alert("");
			 	}
		    }

		});
	}

	function getOrderMatchingList() {
		var param = {
				chk						:"querySoldOrders",
				mvLastAction			:"OTHERSERVICES",
				mvChildLastAction		:"ADVANCE",
				key						:new Date().getTime(),
				_dc						:new Date().getTime(), // 수정중
				start	:0,
				limit	:15,
				page	:1
		};
		//console.log("cash Advance");
		$.ajax({
			url:'/data/ttlCall.jsp',
			data:param,
		    dataType: 'json',
		    success: function(data){
			 	//console.log(data);
			 	if(data.mvChildBeanList != null){
			 		var strList = "";
			 		for(var i = 0; i<data.mvChildBeanList.length; i++){
			 			strList += "<tr>"
					 				+ "<td class='text_center'>" + data.mvChildBeanList[i].mvOrderID + "</td>"		//	ID
					 				+ "<td class='text_center'>" + data.mvChildBeanList[i].tradeDate + "</td>" 	// MatchingDate
					 				+ "<td class='text_center'>" + data.mvChildBeanList[i].cashSettleDay + "</td>" 	// MatchingDate
					 				+ "<td class='text_center'>" + data.mvChildBeanList[i].mvStockID + "</td>"		//
					 				+ "<td class='text_center'>" + data.mvChildBeanList[i].mvQuantity + "</td>"		//
					 				+ "<td class='text_center'>" + data.mvChildBeanList[i].mvFormatedAmount + "</td>"		//
					 				+ "<td class='text_center'>" + data.mvChildBeanList[i].tradingFee + "</td>"		//
					 				+ "<td class='text_center'>" +  "</td>"// tax 부분
					 				+ "</tr>";
			 		}
			 		$("#matchingList").html(strList);
			 	}else{
					alert("");
			 	}
		    }
		});
	}

	/* function checkAdvancePaymentTime() {
		var param = {
				chk				:"checkAdvancePaymentTime"
		}
		console.log("check Advance PaymentTime");
		$.ajax({
			url:'/data/ttlCall.jsp',
			data:param,
		    dataType: 'json',
		    success: function(data){
			 	console.log(data);
			 	if(data.mvResult.length > 0){
			 		alert("err : mvResult.length > 0");

			 	}else{
			 		alert("Open Popup");
			 		//팝업에서 OK 하면
			 		//doAdvancePayment() 호출
			 	}
			}
		});
	} */
</script>

</head>
  <body class="mdi">

  	<div>
		<!-- header -->
		<!-- //header -->

		<div class="mdi_container">
			<!-- tabs -->
			<div name="tabs">
				<ul class="nav nav_tabs " role="tablist">
					<li role="presentation" class="active"><a href="#tab1" aria-controls="tab1" role="tab" data-toggle="tab">CASH ADVANCE</a></li>
					<li role="presentation"><a href="#tab2" aria-controls="tab2" role="tab" data-toggle="tab">CASH ADVANCE BANK</a></li>
					<li role="presentation"><a href="#tab3" aria-controls="tab3" role="tab" data-toggle="tab">ODD LOT ORDER</a></li>
					<li role="presentation"><a href="#tab4" aria-controls="tab4" role="tab" data-toggle="tab">ENTITLEMENT ONLINE</a></li>
					<li role="presentation"><a href="#tab5" aria-controls="tab5" role="tab" data-toggle="tab">LOAN REFUND</a></li>
				</ul>
				<div class="tab_content online">

					<div role="tabpanel" class="tab_pane" id="tab1">
						<div class="wrap_left">
							<div class="group_table">
								<table class="table">
									<caption>Cash Advance Place</caption>
									<colgroup>
										<col width="62%">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th>Cash advance available</th>
											<td id="cashAdvanceAvailable">00,000,000</td>
										</tr>
										<tr>
											<th>Advance fee</th>
											<td id="advanceFee">00,000,000</td>
										</tr>
										<tr>
											<th>Advance amount</th>
											<td class="input"><input class="text won" type="text" id="txtAdvancePayment" value="" onkeyup="keyUpEvent()"></td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="mdi_bottom">
								<input type="button" id="btnSubmit" class="color" value="submit">
								<input type="button" id="btnReset" value="reset">
							</div>
						</div>
						<div class="wrap_right">
							<div class="grid_area" style="height:166px;">
								<div class="group_table">
									<table class="table">
										<caption>Cash Advance Transaction</caption>
										<colgroup>
											<col width="117">
											<col width="117">
											<col width="117">
											<col width="117">
											<col width="117">
											<col>
										</colgroup>
										<thead>
											<tr>
												<th>Date</th>
												<th>Advance amount</th>
												<th>Advance fee</th>
												<th>Processing status</th>
												<th>Last update</th>
												<th>Note</th>
											</tr>
										</thead>

										<tbody id="advanceTransaction"></tbody>

									</table>
								</div>
							</div>
							<div class="grid_area" style="height:166px;">
								<div class="group_table">
									<table class="table">
										<caption>Order Matching List</caption>
										<colgroup>
											<col width="100">
											<col width="110">
											<col width="110">
											<col width="110">
											<col width="100">
											<col width="100">
											<col width="100">
											<col>
										</colgroup>
										<thead>
											<tr>
												<th>ID</th>
												<th>Matching Date</th>
												<th>Payment Date</th>
												<th>Stock</th>
												<th>Volume</th>
												<th>Value (VND)</th>
												<th>Fee</th>
												<th>Tax</th>
											</tr>
										</thead>

										<tbody id="matchingList"></tbody>

									</table>
								</div>
							</div>
						</div>
					</div>
					<div role="tabpanel" class="tab_pane" id="tab2">
						<div class="wrap_left">
							<div class="group_table">
								<table class="table">
									<caption>Cash Advance Place</caption>
									<colgroup>
										<col width="62%">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th>Bank Account</th>
											<td>
												<select>
													<option>option</option>
													<option>option</option>
												</select>
											</td>
										</tr>
										<tr>
											<th>Cash advance available</th>
											<td id="cashAdvanceAvailable2">00,000,000</td>
										</tr>
										<tr>
											<th>Advance fee</th>
											<td>00,000,000</td>
										</tr>
										<tr>
											<th>Advance amount</th>
											<td class="input"><input class="text won" type="text" value="0"></td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="mdi_bottom">
								<input type="submit" value="submit">
								<input type="reset" value="reset">
							</div>
						</div>
						<div class="wrap_right">
							<div class="grid_area" style="height:166px;">
								<div class="group_table">
									<table class="table">
										<caption>Order Matching List</caption>
										<colgroup>
											<col width="40">
											<col width="100">
											<col width="100">
											<col width="100">
											<col width="100">
											<col width="100">
											<col width="100">
											<col width="100">
											<col width="100">
											<col width="100">
											<col>
										</colgroup>
										<thead>
											<tr>
												<th></th>
												<th>Contract ID</th>
												<th>Order ID</th>
												<th>Settlement Date</th>
												<th>Trade Date</th>
												<th>Stock ID</th>
												<th>Price</th>
												<th>Quantity</th>
												<th>Value</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td class="text_center"><input type="checkbox"></td>
												<td class="text_center">10294513</td>
												<td class="text_center">10294513</td>
												<td class="text_center">13/05/2016</td>
												<td class="text_center">13/05/2016</td>
												<td class="text_center">AAA</td>
												<td>00.00</td>
												<td>00.00</td>
												<td>00.00</td>
											</tr>
											<tr>
												<td class="text_center"><input type="checkbox"></td>
												<td class="text_center">10294513</td>
												<td class="text_center">10294513</td>
												<td class="text_center">13/05/2016</td>
												<td class="text_center">13/05/2016</td>
												<td class="text_center">AAA</td>
												<td>00.00</td>
												<td>00.00</td>
												<td>00.00</td>
											</tr>
											<tr>
												<td class="text_center"><input type="checkbox"></td>
												<td class="text_center">10294513</td>
												<td class="text_center">10294513</td>
												<td class="text_center">13/05/2016</td>
												<td class="text_center">13/05/2016</td>
												<td class="text_center">AAA</td>
												<td>00.00</td>
												<td>00.00</td>
												<td>00.00</td>
											</tr>
											<tr>
												<td class="text_center"><input type="checkbox"></td>
												<td class="text_center">10294513</td>
												<td class="text_center">10294513</td>
												<td class="text_center">13/05/2016</td>
												<td class="text_center">13/05/2016</td>
												<td class="text_center">AAA</td>
												<td>00.00</td>
												<td>00.00</td>
												<td>00.00</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="grid_area" style="height:172px;">
								<div class="group_table">
									<table class="table">
										<caption>Cash Advance Transaction</caption>
										<colgroup>
											<col width="117" />
											<col width="117" />
											<col width="117" />
											<col width="117" />
											<col width="117" />
											<col />
										</colgroup>
										<thead>
											<tr>
												<th>Date</th>
												<th>Advance amount</th>
												<th>Advance fee</th>
												<th>Processing status</th>
												<th>Last update</th>
												<th>Note</th>
											</tr>
										</thead>
										<tbody id=""></tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- //ííë¦¿ ì¬ì©ë¶ë¶ -->


  	</div>

<script>
//$(".group_table.type2 tbody tr:even").addClass("even");
$( "div[name=tabs]" ).tabs();
$( "select" ).selectmenu();
</script>
  </body>
</html>