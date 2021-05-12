<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String authenMethod = (String) session.getAttribute("authenMethod");
	String saveAuth = (String) session.getAttribute("saveAuth");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	var pTranID = "";
	var pStatus = "";
	
	$(document).ready(function() {
		var d = new Date();
		$("#ojSubAccountStockIn").html($("#ojSubAccount").html());
		changeToSubAccountInterStock($("#ojSubAccount").val());
				
		$(".datepicker").datepicker({
			showOn      : "button",
			dateFormat  : "dd/mm/yy",
			changeYear  : true,
			changeMonth : true
		});
		$("#cmvEndDateSIn").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
		d.setMonth(d.getMonth() - 1);
		var ye = 0 ;
		var mo = 0;
		if((d.getMonth() - 1) < 0){
			ye = 1;
			mo = ((d.getMonth() - 1) + 12);
		}
		$("#cmvStartDateSIn").datepicker("setDate", d.getDate() + "/" + (mo + 1) + "/" + (d.getFullYear() - ye));
		
		getStockTransferList();
		hksStockTransactionHistoryIn();
	});
	
	function changeToSubAccountInterStock(valu) {
		//lengOjSubAccount = (valu % lengOjSubAccount) + 1;
		$("#ojSubAccount").val(valu);
		$("#ojSubAccountStockIn").val((valu % lengOjSubAccount) + 1);
	}
	
	function changeFromSubAccountInterStock(valu) {
		$("#ojSubAccountStockIn").val(valu);
		$("#ojSubAccount").val((valu % lengOjSubAccount) + 1);
		getStockTransferList();
	}
	
	function changeSubAccountInterStock111() {
		//var se = $("#ojTranferSubAccountStockIn").val();
		var se = $("#ojSubAccount").val();
		
		if (se == 1){
			se = 2;
		}
		else if (se == 2)
		{
			se = 1;
		}
		else{
			se = 1;
		}
		$("#ojSubAccountStockIn").val(se);
	}
	
	function getSubAccount() {
		var param = {
				mvClientID	:	"<%= session.getAttribute("clientID") %>"
			};

			$.ajax({
				dataType  : "json",
				cache		: false,
				url       : "/trading/data/getSubAccount.do",
				data      : param,
				success   : function(data) {
					//console.log("Sub stock List");
					//console.log(data);
					$("#ojSubAccountStockIn option").remove();
					for (var i = 0; i < data.jsonObj.mainResult.length; i++) {
						$("#ojSubAccountStockIn").append("<option value='" + data.jsonObj.mainResult[i].tradingAccSeq + "'>"+ data.jsonObj.mainResult[i].subAccountID + "</option>");
					}		
					/* 
					$("#ojTranferSubAccountStockIn option").remove();
					for (var i = 0; i < data.jsonObj.mainResult.length; i++) {
						$("#ojTranferSubAccountStockIn").append("<option value='" + data.jsonObj.mainResult[i].tradingAccSeq + "'>"+ data.jsonObj.mainResult[i].subAccountID + "</option>");
					}
					 */
					//changeSubAccountInterStock($("#ojSubAccount").val());
				},
				error     :function(e) {					
					console.log(e);
				}
			});
	}
	
	function getStockTransferList() {
		$("#tab3").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: $("#ojSubAccount option:selected").text()
		};

		$.ajax({
			dataType  : "json",
			url       : "/banking/data/listInstrumenPortfolio.do",
			data      : param,
			cache: false,
			success   : function(data) {
				//console.log("===Stock transfer internal===");
				//console.log(data);
									
				if(data.jsonObj.mainResult != null) {
					var htmlStr    = "";						
					var sortList = data.jsonObj.mainResult.slice(0);
					sortList.sort(function(a,b) {
					    var x = a.instrumentID.toLowerCase();
					    var y = b.instrumentID.toLowerCase();
					    return x < y ? -1 : x > y ? 1 : 0;
					});
					$("#ojStockIn option").remove();
					for(var i=0; i < sortList.length; i++) {
						var rowData = sortList[i];
						$("#ojStockIn").append("<option value='" + JSON.stringify(rowData) + "'>"+ rowData.instrumentID + "</option>");
					}
					if (sortList.length > 0) {
						firstSelectStock(JSON.stringify(sortList[0]));
					}
					
				}
				$("#tab3").unblock();
				
			},
			error     :function(e) {
				console.log(e);
				$("#tab3").unblock();
			}
		});
	}
	
	function hksStockTransactionHistoryIn() {
		$("#tab3").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	  : "<%= session.getAttribute("subAccountID") %>",
				mvStartDate       : $("#cmvStartDateSIn").val(),
				mvEndDate         : $("#cmvEndDateSIn").val(),				
				mvTranType		  : $("#ojStatusSIn").val(),			
				limit             : $("#limit").val(),
				start             : ($("#page").val() == "0" ? "0" : (($("#page").val() - 1) * $("#limit").val()))
		};

		$.ajax({
			dataType  : "json",
			url       : "/banking/data/enquiryInstrumentDW.do",
			asyc      : true,
			cache	  : false,
			data      : param,
			success   : function(data) {
				//console.log("===enquiryInstrumentDW===");
				//console.log(data);
				if(data.jsonObj != null) {
					var cashAdvanceTransaction = "";

					if(data.jsonObj.mainResult != null) {
						for(var i=0; i < data.jsonObj.mainResult.length; i++) {
							var hcth = data.jsonObj.mainResult[i];
							cashAdvanceTransaction += "<tr>";
							cashAdvanceTransaction += "	<td class=\"text_center\">" + hcth.tradeDate + "</td>"; 
							cashAdvanceTransaction += "	<td class=\"text_center\">" + hcth.settleDate + "</td>";
							cashAdvanceTransaction += "	<td class=\"text_center\">" + hcth.tranID + "</td>";
							cashAdvanceTransaction += "	<td class=\"text_center\">" + hcth.refId + "</td>";
							cashAdvanceTransaction += "	<td class=\"text_center\">" + hcth.stockCode + "</td>";
							cashAdvanceTransaction += "	<td class=\"text_center\">" + hcth.marketID + "</td>";
							cashAdvanceTransaction += "	<td class=\"text_right\">" + hcth.amount + "</td>";
							cashAdvanceTransaction += "	<td class=\"text_center\">" + getTranType(hcth.txnType) + "</td>";
							cashAdvanceTransaction += "	<td class=\"text_center\">" + getStatus(hcth.settleStatus) + "</td>";
							cashAdvanceTransaction += "	<td class=\"text_left\">" + hcth.remark + "</td>";
							cashAdvanceTransaction += "</tr>";
						}
					}
					drawPage(data.jsonObj.totalCount, $("#limit").val(), (parseInt($("#page").val()) == "0" ? "1" : parseInt($("#page").val())));
					$("#trCashAdvanceTransactionStockIn").html(cashAdvanceTransaction);
					$("#tab3").unblock();
				}
				
			},
			error     :function(e) {
				console.log(e);
				$("#tab3").unblock();
			}
		});
	}
	
	function getTranType(transType) {
		if(transType == "I") {
			if ("<%= langCd %>" == "en_US") {
			return "Internal";
			} else {
				return "Nội bộ";
			}
		} else if(transType == "W") {
			if ("<%= langCd %>" == "en_US") {
			return "Withdrawable";
			} else {
				return "Rút";
			}
		} else if(transType == "D") {
			if ("<%= langCd %>" == "en_US") {
				return "Deposit";
			} else {
				return "Nộp";
			}
		}
	}
	
	function getStatus(status) {
		if(status == "U") {
			if ("<%= langCd %>" == "en_US") {
			return "Un-Settle";
			} else {
				return "Chưa duyệt";
			}
		} else if(status == "S") {
			if ("<%= langCd %>" == "en_US") {
			return "Settled";
			} else {
				return "Đã duyệt";
			}
		}
	}

	function onFocusIn(tagId) {
		if($("#" + tagId).val() == "0") {
			$("#" + tagId).val("");
		}
	}

	function onFocusOut(tagId) {
		if($("#" + tagId).val() == "") {
			$("#" + tagId).val("0");
		}
	}
	
	function transferAmountCalc() {
		var mvAmount   = $("#transferQtyStockIn").val().replace(/,/g,'');		
		$("#transferQtyStockIn").val(numIntFormat(mvAmount));	
		if(mvAmount != "" && mvAmount != "0" &&  parseFloat(mvAmount) > 0){
			
		} else {
			if(Number(mvAmount) <= 0) {
				$("#transferQtyStockIn").val(0);
			}
		}
	}	
	

	function authCheckStockIn(divGubun, tranID, status) {
		pTranID = tranID;
		pStatus = status;

		var param = {
				divId               : "divIdAuthTransferStockIn",
				divType             : divGubun
		};
		$("#tab3").block({message: "<span>LOADING...</span>"});
		$.ajax({
			type     : "POST",
			url      : "/common/popup/authConfirm.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				$("#tab3").unblock();
				$("#divIdAuthTransferStockIn").fadeIn();
				$("#divIdAuthTransferStockIn").html(data);
			},
			error     :function(e) {
				$("#tab3").unblock();
				console.log(e);
				
			}
		});
	}

	function authCheckOK(divGubun) {
		if(divGubun == "submit_stockin") {
			dofundtransferStockIn();
		}
	}

	function cashTransferPlaceCancelStockIn() {
		
		$("#transferQtyStockIn").val("0");
		$("#remarkStockIn").val("");		
	}

	function checkFundTransferTimeStockIn() {
		if($("#ojSubAccountStockIn").val() == $("#ojTranferSubAccountStockIn").val()) {
			if ("<%= langCd %>" == "en_US") {
				alert("Please select a difference sub account to transfer.");	
			} else {
				alert("Vui lòng chọn 1 tiểu khoản khác tiểu khoản hiện tại.");
			}
			return;
		}

		if($("#transferQtyStockIn").val() < 1) {
			if ("<%= langCd %>" == "en_US") {
				alert("Qty should not be blank.");	
			} else {
				alert("Số lượng không thế trống");
			}
			return;
		}

		$("#tab3").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		}
		$.ajax({
			dataType  : "json",
			url       : "/banking/data/checkFundTransferTime.do",
			asyc      : true,
			data	  : param,
			cache	  : false,
			success   : function(data) {
				if(data != null) {
					$("#tab3").unblock();
					if(data.jsonObj.mvFundTransferResult == "SUCCESS") {
						if ("<%= authenMethod %>" != "matrix") {
							stockInCheckOTP();
						} else {
							authCheckStockIn("submit_stockin", "", "");
						}
						//authCheckStockIn("submit_stockin", "", "");
					} else {
						alert(data.jsonObj.mvFundTransferResult);
					}
				}
			},
			error     :function(e) {
				console.log(e);
				$("#tab3").unblock();
			}
		});
	}	

	function dofundtransferStockIn() {
		$("#tab3").block({message: "<span>LOADING...</span>"});
		
		if ($("#remarkStockIn").val() == "") {
			if ("<%= langCd %>" == "en_US") {
				$("#remarkStockIn").val("Stock Transfer Internal");	
			} else {
				$("#remarkStockIn").val("Chuyen CK noi bo");
			}
		}
		
		var encodeBase64 = utoa("" + "|" + "" + "|" + "" + "|" + $("#remarkStockIn").val());
		
		var param = {
				mvSubAccountID		: $("#ojSubAccount option:selected").text(),
				mvDestSubAccountID	: $("#ojSubAccountStockIn option:selected").text(),
				mvDestTradingAccSeq	: $("#ojSubAccountStockIn").val(),
				mvMarketID			: $("#marketID").val(),
				mvInstrumentID		: $("#ojStockIn option:selected").text(),
				mvRemark			: $("#remarkStockIn").val(),
				mvQty				: $("#transferQtyStockIn").val().replace(/,/g,''),
				mvBase64			: encodeBase64
		};
		
		//console.log(param);

		$.ajax({
			dataType  : "json",
			url       : "/banking/data/dofundtransferStockIn.do",
			asyc      : true,
			data      : param,
			success   : function(data) {
				//console.log("dofundtransferStockIn");
				//console.log(data);
				$("#tab3").unblock();				
				$("#ojStatusSIn").val("I");
				
				getStockTransferList();
				hksStockTransactionHistoryIn();
		
				alert(data.jsonObj.errorMessage);
				cashTransferPlaceCancelStockIn();
			},
			error     :function(e) {
				console.log(e);
				$("#tab3").unblock();
			}
		});
	}

	var util 		= 	new PageUtil();
	function drawPage(totCnt, pageSize, curPage) {
		util.totalCnt 	= 	totCnt; 		//	게시물의 총 건수
		util.pageRows 	= 	pageSize; 		// 	한번에 출력될 게시물 수
		util.disPagepCnt= 	5; 				//	화면 출력 페이지 수
		util.curPage 	= 	curPage;  		//	현재 선택 페이지
		util.setTotalPage();
		fn_DrowPageNumber();
	}

	function fn_DrowPageNumber() {
		$(".pagination").html(util.Drow());
	}

	function goPage(pageNo) {
		$("#page").val(pageNo);
		hksStockTransactionHistoryIn();
	}

	function next() {
		var page		=	util.getNext();
		util.curPage    =	page;
		goPage(page);
	}

	function prev() {
		var page		=	util.getPrev();
		util.curPage    =	page;
		goPage(page);
	}
	
	function convNum(v) {
		var rt	=	v.split(",").join("");
		rt		=	upDownNumList(String(parseFloat(rt)));
		return rt;
	}
	
	function formatNumber(num) {
		if(num.indexOf('.') != -1) {
			var priceSpl = num.split(".");
			if(priceSpl[1].length == 1) {
				num = priceSpl[0] + "." + priceSpl[1] + "00";
			} else if (priceSpl[1].length == 2) {
				num = priceSpl[0] + "." + priceSpl[1] + "0";
			}
		}
		return num;
	}
	
	function isNum() {
		var key	=	event.keyCode;
		if(!(key==8||key==9||key==13||key==46||key==144||(key>=48&&key<=57)||key==110||key==190)) {
			event.returnValue	=	false;
		}
	}
	
	// Key Event
	function keyDownEvent(id, e) {
		if ($("#" + id).val() == "0") {
			if (e.keyCode == "190") {
				$("#" + id).val("0");
			} else {
				$("#" + id).val("");
			}
		}
	}
	
	function stockSelect(stockDataInfo) {
		firstSelectStock(stockDataInfo);		
	}
	
	function firstSelectStock(stockDataInfo) {
		var stockData = JSON.parse(stockDataInfo);
		$("#marketID").val(stockData.marketID);
		$("#tdMaxTransfer").html(numIntFormat((stockData.drawbleQty)));
		//$("#tdMaxTransfer").html(stockData.drawbleQty);
	}
	
	function stockInCheckOTP() {
		var param = {
				mvUserID 		: '<%=session.getAttribute("ClientV")%>'
			};
		$.ajax({
			url      : "/trading/data/mCheckOTP.do",
			contentType	:	"application/json; charset=utf-8",
			data     : param,
			dataType : "json",
			success  : function(data) {
				//console.log("Check OTP");
				//console.log(data);
				if (data.otpResponseCheck.result != "0") {
					authOtpCheckIn();
				} else {					
					authCheckOK("submit_stockin", "", "");
				}
			}
		});	
	}
	
	function authOtpCheckIn() {
		var param = {
				divId               : "divIdOTPStockIn",
				divType             : "stockTranferInternal"
		};

		$.ajax({
			type     : "POST",
			url      : "/common/popup/otpConfirm.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				$("#divIdOTPStockIn").fadeIn();
				$("#divIdOTPStockIn").html(data);
			},
			error     :function(e) {					
				console.log(e);
			}
		});
	}
</script>
<div class="tab_content banking">	
	<input type="hidden" id="page" name="page" value="1"/>
	<input type="hidden" id="limit" name="limit" value="15"/>
	
	<input type="hidden" id="marketID" name="marketID" value=""/>

	<div role="tabpanel" class="tab_pane" id="tab3">
		<div class="wrap_left">
			<div class="tf_place same on">
				<div class="group_table">
					<table class="table no_bbt list_type_01">
						<caption><%= (langCd.equals("en_US") ? "Stock Transfer Internal" : "Thực hiện chuyển chứng khoán nội bộ") %></caption>
						<colgroup>
							<col width="150" />
							<col />
						</colgroup>
						<tbody>
							<%-- <tr>
								<th scope="row"><%=(langCd.equals("en_US") ? "Tranfer sub account" : "Chuyển từ tài khoản")%></th>
								<td class="text_left">
									<select style="margin-top:-3px;color:black;font-weight:600;" id="ojTranferSubAccountStockIn" onChange="changeSubAccountInterStock()">
									</select>
								</td>
							</tr> --%>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Stock Symbol" : "Mã chứng khoán") %></th>
								<td class="text_left">
									<select style="margin-top:-3px;color:black;font-weight:600;" id="ojStockIn" onchange="stockSelect(this.value);">
									</select>
								</td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Max Qty Transfer" : "K.L chuyển tối đa") %></th>
								<td id="tdMaxTransfer"></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Transfer type" : "Loại hình<br />chuyển khoản") %></th>
								<td class="text_left">
									<div>
										<input type="radio" id="type_ef" name="type_sm" value="1" checked="checked"/>
										<label for="type_ef"><%= (langCd.equals("en_US") ? "Transfer Stock Internal" : "Chuyển CK nội bộ") %></label>
									</div>									
								</td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Beneficiary<br />sub account" : "Tài khoản<br />thụ hưởng") %></th>
								<td class="text_left">									
									<select style="margin-top:-3px;color:black;font-weight:600;" id="ojSubAccountStockIn" onChange="changeFromSubAccountInterStock(this.value)"></select>
								</td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Account type" : "Loại tài khoản") %></th>
								<td><%= (langCd.equals("en_US") ? "Internal Account" : "Tài khoản nội bộ") %></td>
							</tr>							
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Transfer Quantity" : "Số CK chuyển khoản") %></th>
								<td class="input"><input class="text won" type="text" id="transferQtyStockIn" name="transferQtyStockIn" value="0" onkeyup="transferAmountCalc()" onfocus="onFocusIn(this.id)" onBlur="onFocusOut(this.id)" onkeypress="isNum();" onkeydown="keyDownEvent(this.id, event)"></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Remark" : "Ghi chú") %></th>
								<td class="input"><input class="text" type="text" id="remarkStockIn" name="remarkStockIn" value=""></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="mdi_bottom cb">
					<input class="color" type="button" value="<%= (langCd.equals("en_US") ? "Submit" : "Thực hiện") %>" onclick="checkFundTransferTimeStockIn()"/>
					<input type="reset" value=<%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %> onclick="cashTransferPlaceCancelStockIn()"/>
				</div>
			<% if(langCd.equals("en_US")) { %>
				<p class="em">* Please select a difference sub account with current sub account.</p>
			<% } else { %>
				<p class="em">* Vui lòng chọn 1 tiểu khoản khác với tiểu khoản hiện tại.</p>
			<% } %>
			</div>
			<!-- // .tf_place.same -->
		</div>
		<div class="wrap_right">
			<div class="search_area in">
				<label for="fromSearch"><%= (langCd.equals("en_US") ? "From" : "Từ ngày") %></label>
				<input type="text" id="cmvStartDateSIn" name="mvStartDateSIn" class="datepicker" />
				<label for="toSearch"><%= (langCd.equals("en_US") ? "To" : "Đến ngày") %></label>
				<input type="text" id="cmvEndDateSIn" name="mvEndDateSIn" class="datepicker" />
				
				<select id="ojStatusSIn">
					<option value="ALL"><%= (langCd.equals("en_US") ? "All" : "Tất cả") %></option>
					<option value="I" selected><%= (langCd.equals("en_US") ? "Internal" : "Nội bộ") %></option>
					<option value="D"><%= (langCd.equals("en_US") ? "Deposit" : "Nộp") %></option>
					<option value="W"><%= (langCd.equals("en_US") ? "Withdrawable" : "Rút") %></option>
				</select>

				<button class="btn" type="button" onclick="hksStockTransactionHistoryIn()"><%= (langCd.equals("en_US") ? "Search" : "Tra cứu") %></button>
			</div>

			<div class="group_table double">
				<table class="table">
					<caption><%= (langCd.equals("en_US") ? "Stock Transfer Transaction" : "Giao dịch chuyển chứng khoán") %></caption>
					<colgroup>
						<col width="60" />
						<col />
						<col />
						<col />
						<col />
						<col />
						<col />
						<col width="60" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col"><%= (langCd.equals("en_US") ? "Trade Date" : "Ngày GD") %></th>							
							<th scope="col"><%= (langCd.equals("en_US") ? "Settle Date" : "Ngày giá trị") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Trans ID" : "Mã GD") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Ref Trans ID" : "Mã GD tham khảo") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Stock Symbol" : "Mã CK") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Market" : "Sàn") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Transfer Qty" : "K.L chuyển") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Trans Type" : "Loại GD") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Trans Status" : "Trạng thái GD") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Remarks" : "Ghi chú") %></th>
						</tr>						
					</thead>
					<tbody id="trCashAdvanceTransactionStockIn">
					</tbody>
				</table>
			</div>

			<div class="pagination"></div>
		</div>
	</div>
</div>
<div id="divIdAuthTransferStockIn" class="modal_wrap"></div>
<div id="divIdOTPStockIn" class="modal_wrap"></div>
</html>
