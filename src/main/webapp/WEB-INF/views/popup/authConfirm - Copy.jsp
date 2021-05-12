<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String authenMethod = (String) session.getAttribute("authenMethod");
	String saveAuth = (String) session.getAttribute("saveAuth");
%>

<!--
		authCheckOK(divType) : 부모 페이지 내에 실행할 Method
		divId                : 부모 페이지 내에서 사용할 pop div ID명
		divType              : 부모 페이지로 사용할 pop div 처리구분
 -->

<html>
<head>

<script>
	$(document).ready(function() {
		//console.log("<%=authenMethod%>");
		//console.log("<%=saveAuth%>");
		authConfirm();
		document.getElementById("wordMatrixValue01").addEventListener("keyup", forceKeyUpMatrix, false);
		document.getElementById("wordMatrixValue02").addEventListener("keyup", forceKeyUpMatrix, false);
	});
	
	function forceKeyUpMatrix(e)
	{
	  if(this.value.length==$(this).attr("maxlength")){
		  $("#wordMatrixValue02").focus();
		}
	}
	
	function authConfirm(confirm){
		$("#divAuthLayer").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID		 : 	"<%=session.getAttribute("subAccountID")%>",
				/* wordMatrixKey01      : $("#mvWordMatrixKey01").text(),
				wordMatrixKey02      : $("#mvWordMatrixKey02").text(),
				wordMatrixValue01    : $("#wordMatrixValue01").val(),
				wordMatrixValue02    : $("#wordMatrixValue02").val(), */
				
				wordMatrixKey01      : $("#<%=request.getParameter("divId")%> #divAuthLayer #mvWordMatrixKey01").text(),
				wordMatrixKey02      : $("#<%=request.getParameter("divId")%> #divAuthLayer #mvWordMatrixKey02").text(),
				wordMatrixValue01    : $("#<%=request.getParameter("divId")%> #divAuthLayer #wordMatrixValue01").val(),
				wordMatrixValue02    : $("#<%=request.getParameter("divId")%> #divAuthLayer #wordMatrixValue02").val(),
				
				serialnumber         : $("#<%=request.getParameter("divId")%> #divAuthLayer #serialnumber").val(),
				mvSaveAuthenticate   : $("#<%=request.getParameter("divId")%> #divAuthLayer #saveAuthenticate").is(':checked')
		};
		
		//console.log(param);

		$.ajax({
			dataType  : "json",
			url       : "/trading/data/authCardMatrix.do",
			data      : param,
			aync      : true,
			success   : function(data) {
				
				$("#divAuthLayer").unblock();
				//console.log("===AUTHEN===");
				//console.log(data);
				if(data != null) {
					if(data.jsonObj.mvSuccess == "FAIL") {
						var authCard = data.jsonObj.mvClientCardBean;
						//console.log(authCard);
						/* $("#mvWordMatrixKey01").html(authCard.mvWordMatrixKey01);
						$("#mvWordMatrixKey02").html(authCard.mvWordMatrixKey02); */
						
						$("#<%=request.getParameter("divId")%> #divAuthLayer #mvWordMatrixKey01").html(authCard.mvWordMatrixKey01);
						$("#<%=request.getParameter("divId")%> #divAuthLayer #mvWordMatrixKey02").html(authCard.mvWordMatrixKey02);
						
						$("#<%=request.getParameter("divId")%> #divAuthLayer #serialnumber").val(authCard.serialnumber);
						$("#divAuth").css("display","block");
						
						if(data.jsonObj.mvClientCardBean.mvErrorCode != "CARD006"){ // not New Card
							alert(data.jsonObj.mvMessage);
							$("#<%=request.getParameter("divId")%> #divAuthLayer #wordMatrixValue01").val("");
							$("#<%=request.getParameter("divId")%> #divAuthLayer #wordMatrixValue02").val("");
						}	
						
						if(data.jsonObj.mvClientCardBean.mvErrorCode == "SERVER_ERROR"){
							$("#divAuth").css("display","none");
							$("#btnAuthConfirm").css("display","none");
						}
					} else if(data.jsonObj.mvSuccess == "SUCCESS") {
						$("#divAuth").css("display","none");
						$("#divAuthMsg").css("display","block");
						if(confirm && confirm =="confirm"){
							authCheckOK('<%=request.getParameter("divType")%>');	// 부모 페이지 내에 실행할 Method
							cancel();
						}
					}
				}
			},
			error     :function(e) {
				console.log(e);
				$("#divAuthLayer").unblock();
			}

		});
	}

	function cancel() {
		 
	<%-- 	var tagId = '<%=request.getParameter("divId")%>';
		$("#" + tagId).fadeOut("normal", function() {
	        $(this).remove();
	    });  --%>
	    
		var tagId = '<%=request.getParameter("divId")%>';
		$("#" + tagId).fadeOut();
	}
</script>

</head>
<body>

	<!-- Buy : Authentication -->
	<div id="divAuthLayer" class="modal_layer auth" style="top: 10%; left: 35%;">
		<div class="layer_add">
			<h2 class="layer_add_title"><%=(langCd.equals("en_US") ? "Authentication" : "Xác thực")%></h2>
			<div class="form_area">
				<div id="divAuth">
					<ul class="security_check">
						<li><strong id="mvWordMatrixKey01"></strong><input type="password" id="wordMatrixValue01" name="wordMatrixValue01" value="" maxlength="1" /></li>
						<li><strong id="mvWordMatrixKey02"></strong><input type="password" id="wordMatrixValue02" name="wordMatrixValue02" value="" maxlength="1" /></li>
					</ul>
					<div>
						<input type="checkbox" id="saveAuthenticate" name="saveAuthenticate" checked="checked"> <label for="saveA"><%=(langCd.equals("en_US") ? "Save Authentication?" : "Lưu xác thực?")%></label>
					</div>
					<div style="padding: 20px;">
						<span style="color:blue !important;"><%= (langCd.equals("en_US") ? "*Warning: Saving authentication maybe potentially risk to your account if you lose your phone or password." : "*Cảnh báo: Việc lưu xác thực có thể dẫn đến rủi ro cho tài khoản giao dịch nếu bạn bị mất thiết bị hoặc mật khẩu.") %></span>
					</div>
				</div>
				<div id="divAuthMsg" style="display: none;">
					<strong><%=(langCd.equals("en_US") ? "Do you want to do this action ?" : "Bạn có muốn thực hiện chức năng này không?")%></strong>
				</div>
			</div>
			
			<div class="btn_wrap">
				<button id="btnAuthConfirm" class="add" type="button" onclick="authConfirm('confirm');"><%=(langCd.equals("en_US") ? "OK" : "OK")%></button>
				<button type="button" onclick="cancel();"><%=(langCd.equals("en_US") ? "Cancel" : "Hủy")%></button>
			</div>
		</div>
	</div>
	<!-- //Buy : Authentication -->
</body>

</html>