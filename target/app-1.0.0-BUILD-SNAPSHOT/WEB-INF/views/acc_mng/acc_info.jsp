<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>
<HTML>

 <head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>ACCOUNT MANAGEMENT</title>

	<link href="/resources/css/common.css" rel="stylesheet">
	<!--
	<script type="text/javascript" src="/resources/js/jquery-1.10.2.min.js"></script>

	 -->
	<!-- RTS Relate Script -->
	<style>
	table th label {color: #666666;}
	</style>
	<!--  
	<script type="text/javascript" src="/resources/js/jquery-1.10.2.min.js"></script>
	<script type="text/javascript" src="/resources/js/jquery-ui.min.js"></script>
	<script type="text/javascript" src="/resources/js/function_comm.js?600"></script>
	<script type="text/javascript" src="/resources/js/nexClient.js"></script>
	<script type="text/javascript" src="/resources/js/socket.io.js"></script>

	-->
	<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>

	<script>
		$(document).ready(function(){
			init();
		});

		function init() {
			$("#tab1").block({message: "<span>LOADING...</span>"});
			var param	=	{
					mvClientID : "<%= session.getAttribute("clientID") %>"
			};

			$.ajax({
				url:'/accInfo/getAccInfo.do',
				data:param,
				cache: false,
			  	dataType: 'json',
			  	success: function(data){
			  		//console.log("=====ACC INFO SEARCH1=======");
			  		//console.log(data);
			  		if(data.jsonObj.mvPersonnalProfileBean != null) {
				  		var odata	=	data.jsonObj.mvPersonnalProfileBean;
				  		var odataagent	=	data.jsonObj.mvAgentList;
						var mvName			=	odata.mvName;
						var mvAddress		=	odata.mvAddress;
						var mvAccountNumber	=	odata.mvAccountNumber;
						var mvIDNumber		=	odata.mvIDNumber;
						var mvEamil			=	odata.mvEmail;
						var mvPhoneNumber	=	odata.mvPhoneNumber;
	
						$("#hn").val(mvName);
						$("#pi").val(mvIDNumber);
	
						$("#a1").val(mvAccountNumber);
						$("#email").val(mvEamil);
	
						$("#phone").val(mvPhoneNumber);
						$("#addr").val(mvAddress);
	
						for(var i = 0; i < odataagent.length; i++) {
							$("#auth").val(odataagent[i].agentAttorney);
							$("#idn").val(odataagent[i].agentIDNumber);
							$("#an").val(odataagent[i].agentName);
							$("#phone2").val(odataagent[i].agentPhone);
						}
			  		} else {
			  			if("<%= langCd %>" == "en_US") {
			  				alert("No Search Data");
			  			} else {
			  				alert("Không tìm thấy dữ liệu");
			  			}
			  		}
					$("#tab1").unblock();
			  	}
			});
		}

		function chgPwd() {
			$("#tab1").block({message: "<span>LOADING...</span>"});
			var param	=	{};

			var	curPwd	=	$("#curPwd").val();
			var newPwd	=	$("#newPwd").val();
			var retPwd	=	$("#retPwd").val();

			if(curPwd == "") {
				if ("<%= langCd %>" == "en_US") {
					alert("please input current password");	
				} else {
					alert("Nhập mật khẩu hiện tại");
				}
				$("#curPwd").focus();
				$("#tab1").unblock();
				return;
			}
			
			if(newPwd != retPwd) {
				if ("<%= langCd %>" == "en_US") {
					alert("password is not match");	
				} else {
					alert("Mật khẩu không khớp");
				}
				$("#tab1").unblock();
				return;
			}
			param.oldPassword			=	curPwd;
			param.password				=	newPwd;
			param.mvSubAccountID		=  	"<%= session.getAttribute("subAccountID") %>";
			
			$.ajax({
				url:'/accInfo/chgPwd.do',
				data:param,
			  	dataType: 'json',
			  	cache:false,
			  	success: function(data){
			  		//console.log("Change Password Return");
			  		//console.log(data);
					$("#tab1").unblock();
					if(data.jsonObj.success == true) {
						if ("<%= langCd %>" == "en_US") {
							alert("Success change password");	
						} else {
							alert("Đổi mật khẩu thành công");
						}
					} else {
						if ("<%= langCd %>" == "en_US") {
							alert("Fail change password");	
						} else {
							alert("Đổi mật khẩu thất bại");
						}
					}
					location.reload();
			  	},
			  	error : function (data) {
			  		$("#tab1").unblock();
			  		//console.log(data);
			  		if ("<%= langCd %>" == "en_US") {
						alert("Fail change password");	
					} else {
						alert("Đổi mật khẩu có lỗi");
					}
			  	}
			});

		}
		
		
		function chgPIN() {
			$("#tab1").block({message: "<span>LOADING...</span>"});
			var param	=	{};

			var	curPIN	=	$("#curPIN").val();
			var newPIN	=	$("#newPIN").val();
			var retPIN	=	$("#retPIN").val();

			if(curPIN == "") {
				if ("<%= langCd %>" == "en_US") {
					alert("please input current PIN");	
				} else {
					alert("Nhập PIN hiện tại");
				}
				$("#curPIN").focus();
				$("#tab1").unblock();
				return;
			}
			
			if(newPIN != retPIN) {
				if ("<%= langCd %>" == "en_US") {
					alert("PIN is not match");	
				} else {
					alert("PIN không khớp");
				}
				$("#tab1").unblock();
				return;
			}
			param.clientID = "<%= session.getAttribute("clientID") %>";
			param.oldPin = curPIN;
			param.newPin = newPIN;
			
			$.ajax({
				url:'/accInfo/chgPIN.do',
				data:param,
				dataType: 'json',
			  	cache:false,
			  	success: function(data){
			  		//console.log("CHANGE PIN OK");
					$("#tab1").unblock();
					if(data.jsonObj.mvResult == "success") {
						if ("<%= langCd %>" == "en_US") {
							//alert("Success change PIN");
							alert(data.jsonObj.errorMessage);
						} else {
							alert(data.jsonObj.errorMessage);
							//alert("Đổi PIN thành công");
						}
					} else {
						if ("<%= langCd %>" == "en_US") {
							alert(data.jsonObj.errorMessage);
							//alert("Fail change PIN");	
						} else {
							alert(data.jsonObj.errorMessage);
							//alert("Đổi PIN thất bại");
						}
					}
					location.reload();
			  	},
			  	error : function (data) {
			  		$("#tab1").unblock();
			  		//console.log("CHANGE PIN ERROR");
			  		//console.log(data);
			  		if ("<%= langCd %>" == "en_US") {
						alert("Fail change PIN");	
					} else {
						alert("Đổi PIN có lỗi.");
					}
			  	}
			});

		}
	</script>
</head>


 <!-- Account Information -->
<div class="tab_content account">
	<div role="tabpanel" class="tab_pane" id="tab1">
		<div class="group_table">
			<table class="table no_bbt list_type_01">
				<caption><%= (langCd.equals("en_US") ? "Account Information" : "Thông tin chủ tài khoản") %></caption>
				<colgroup>
					<col width="15%" />
					<col width="19%" />
					<col width="15%" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">
							<label for="hn"><%= (langCd.equals("en_US") ? "Holder Name" : "Tên chủ tài khoản") %></label>
						</th>
						<td>
							<input type="text" id="hn" readonly/>
						</td>
						<th scope="row">
							<label for="pi"><%= (langCd.equals("en_US") ? "Personal ID" : "CMND/ĐKSH") %></label>
						</th>
						<td>
							<input type="text" id="pi"  readonly/>
						</td>
					</tr>
					<tr>
						<th scope="row">
							<label for="a1"><%= (langCd.equals("en_US") ? "Account No. 1" : "Tài khoản số 1") %></label>
						</th>
						<td>
							<input type="text" id="a1" readonly />
						</td>
						<th scope="row">
							<label for="email"><%= (langCd.equals("en_US") ? "E-mail" : "E-mail") %></label>
						</th>
						<td>
							<input type="text" id="email" readonly />
						</td>
					</tr>
					<tr>
						<th scope="row">
							<label for="a2"><%= (langCd.equals("en_US") ? "Account No. 2" : "Tài khoản số 2") %></label>
						</th>
						<td>
							<input type="text" id="a2" readonly />
						</td>
						<th scope="row">
							<label for="phone"><%= (langCd.equals("en_US") ? "Telephone" : "Số điện thoại") %></label>
						</th>
						<td>
							<input type="text" id="phone" readonly />
						</td>
					</tr>
					<tr>
						<th scope="row">
							<label for="a3"><%= (langCd.equals("en_US") ? "Account No. 3" : "Tài khoản số 3") %></label>
						</th>
						<td>
							<input type="text" id="a3" readonly />
						</td>
						<th scope="row">
							<label for="addr"><%= (langCd.equals("en_US") ? "Address" : "Địa chỉ") %></label>
						</th>
						<td>
							<input type="text" id="addr" readonly />
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="group_table">
			<table class="table no_bbt list_type_01">
				<caption><%= (langCd.equals("en_US") ? "Authorized Person Information" : "Thông tin người ủy quyền") %></caption>
				<colgroup>
					<col width="15%" />
					<col width="19%" />
					<col width="15%" />
					<col/ >
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">
							<label for="an"><%= (langCd.equals("en_US") ? "Authorized Name" : "Tên người ủy quyền") %></label>
						</th>
						<td>
							<input type="text" id="an" readonly />
						</td>
						<th scope="row">
							<label for="phone2"><%= (langCd.equals("en_US") ? "Telephone" : "Số điện thoại") %></label>
						</th>
						<td>
							<input type="text" id="phone2" readonly />
						</td>
					</tr>
					<tr>
						<th scope="row">
							<label for="idn"><%= (langCd.equals("en_US") ? "ID No" : "Số CMND/ĐKSH") %></label>
						</th>
						<td>
							<input type="text" id="idn" readonly />
						</td>
						<th scope="row">
							<label for="auth"><%= (langCd.equals("en_US") ? "Authorization" : "Uỷ quyền") %></label>
						</th>
						<td>
							<input type="text" id="auth" readonly />
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="group_table">
			<table class="table no_bbt list_type_01">
				<caption><%= (langCd.equals("en_US") ? "Change Password" : "Đổi mật khẩu") %></caption>
				<colgroup>
					<col width="15%" />
					<col width="19%" />
					<col width="15%" />
					<col width="19%" />
					<col width="15%" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">
							<label for="cpw"><%= (langCd.equals("en_US") ? "Current Password" : "Mật khẩu cũ") %></label>
						</th>
						<td>
							<input type="password" id="curPwd" maxlength="16"/>
						</td>
						<th scope="row">
							<label for="npw"><%= (langCd.equals("en_US") ? "New Password" : "Mật khẩu mới") %></label>
						</th>
						<td>
							<input type="password" id="newPwd" maxlength="16"/>
						</td>
						<th scope="row">
							<label for="rpw"><%= (langCd.equals("en_US") ? "Retype new Password" : "Nhập lại mật khẩu mới") %></label>
						</th>
						<td>
							<input type="password" id="retPwd" maxlength="16"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="mdi_bottom center">
				<input class="color" style="width: auto;min-width: 80px;" type="submit" value="<%= (langCd.equals("en_US") ? "Save" : "Thay đổi mật khẩu")%>" onclick="chgPwd();">
			</div>

		<div class="group_table">
			<table class="table no_bbt list_type_01">
				<caption><%= (langCd.equals("en_US") ? "Change PIN trading by Cell Phone" : "Thay đổi PIN giao dịch qua điện thoại") %></caption>
				<colgroup>
					<col width="15%" />
					<col width="19%" />
					<col width="15%" />
					<col width="19%" />
					<col width="15%" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">
							<label for="cpin"><%= (langCd.equals("en_US") ? "Current PIN" : "PIN cũ") %></label>
						</th>
						<td>
							<input type="password" id="curPIN" />
						</td>
						<th scope="row">
							<label for="npin"><%= (langCd.equals("en_US") ? "New PIN" : "PIN mới") %></label>
						</th>
						<td>
							<input type="password" id="newPIN" />
						</td>
						<th scope="row">
							<label for="rpin"><%= (langCd.equals("en_US") ? "Retype new PIN" : "Nhập lại PIN mới") %></label>
						</th>
						<td>
							<input type="password" id="retPIN" />
						</td>
					</tr>
				</tbody>
			</table>
			
			
		
		</div>
		<div class="mdi_bottom center">
				<input class="color" type="submit" value="<%= (langCd.equals("en_US") ? "Save" : "Thay đổi PIN")%>" onclick="chgPIN();">
			</div>

		<div class="desc">
			<p class="title"><%= (langCd.equals("en_US") ? "Warning" : "Quý khách lưu ý") %></p>
			<p><%= (langCd.equals("en_US") ? "Your password will be efficient in 90 days after the last time you change it." : "Mật khẩu của quý khách có tác dụng trong 90 ngày kể từ lần thay đổi mật khẩu cuối cùng.") %></p>
			<p><%= (langCd.equals("en_US") ? "After 90 days, you will receive a notice for changing your password" : "Sau 90 ngày, quý khách sẽ nhận được thông báo yêu cầu đổi mật khẩu từ hệ thống Giao dịch trực tuyến.") %></p>
		</div>

	</div>
	<!-- // Account Information -->
</div>
</HTML>