<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<%
	String chkPwd = (String)session.getAttribute("chkPwd");
	String langCd 		=	(String) session.getAttribute("LanguageCookie");
%>
<html lang="vi">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">

<script>
	function validatePW() {
		if($("#oldPassword").val() == "") {
			$("#oldPassword").focus()
			if ("<%= langCd %>" == "en_US") {
				alert("Old password cannot be empty.");	
			} else {
				alert("Mật khẩu cũ không thể trống.");
			}
			return;
		}

		if($("#newPassword").val() == "") {
			$("#newPassword").focus()
			if ("<%= langCd %>" == "en_US") {
				alert("The verify cannot be empty.");	
			} else {
				alert("Xác nhận mật khẩu không thể trống.");
			}	
			return;
		}

		if($("#conPassword").val() == "") {
			$("#conPassword").focus()
			if ("<%= langCd %>" == "en_US") {
				alert("The verify cannot be empty.");	
			} else {
				alert("Xác nhận mật khẩu không thể trống.");
			}
			return;
		}

		if($("#newPassword").val().length < 6 || $("#newPassword").val().length > 30) {
			$("#newPassword").focus()
			if ("<%= langCd %>" == "en_US") {
				alert("The new Password only accept 6 to 30 characters.");	
			} else {
				alert("Mật khẩu chỉ chấp nhận từ 6 đến 30 kí tự.");
			}
			return;
		}

		if($("#newPassword").val() != $("#conPassword").val()) {
			$("#newPassword").focus()
			if ("<%= langCd %>" == "en_US") {
				alert("The new password and the verify password do not have the same value.");	
			} else {
				alert("Mật khẩu mới và xác nhận mật khẩu không giống nhau.");
			}
			return;
		}

		changePW();
	}

	function changePW() {
		var param = {
				oldPassword        : $("#oldPassword").val(),
				password           : $("#newPassword").val(),
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
			dataType  : "json",
			url       : "/accInfo/chgPwd.do",
			data      : param,
			success   : function(data) {
				if(data != null) {
					if(data.jsonObj.success == true) {						
						if ("<%= langCd %>" == "en_US") {
							alert("Your password has been changed.");	
						} else {
							alert("Mật khẩu của bạn đã được đổi.");
						}
						location.href	=	"https://wts.masvn.com";
					} else {
						if ("<%= langCd %>" == "en_US") {
							alert("Password incorrect. Please try again.");	
						} else {
							alert("Mật khẩu không đúng. Vui lòng thử lại.");
						}
					}
				}
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}

	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Đổi mật khẩu";
	});
</script>
</head>
<body>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <div id="contents" class="full_width">
            <h3 class="cont_title">Thông tin tài khoản</h3>

            <div class="form_container">
                <h4>Mật khẩu tài khoản</h4>
                <div class="inputs c_pw">
                    <form>                    
                        <div>
                            <label for="pw">Mật khẩu hiện tại</label>
                            <input type="password" id="oldPassword" name="oldPassword" value="" maxlength="16"/>
                        </div>
                        <div>
                            <label for="new_pw">Mật khẩu mới</label>
                            <input type="password" id="newPassword" name="newPassword" value="" maxlength="16"/>
                        </div>
                        <div>
                            <label for="con_pw">Xác nhận mật khẩu mới</label>
                            <input type="password" id="conPassword" name="conPassword" value="" maxlength="16"/>
                        </div>

                        <input type="button" value="Xác nhận" class="change" onclick="validatePW()"/>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>