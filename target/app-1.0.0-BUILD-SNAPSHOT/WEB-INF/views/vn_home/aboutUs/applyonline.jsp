<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">

<script>
	var jobApplication;
	var resumes;
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Về chúng tôi";
		Captcha();
		setInterval(Captcha, 600000);
		
		/*$('#JobApplication').change( function(event) {
			jobApplication = URL.createObjectURL(event.target.files[0]);		    
		    //alert("Temporary Path(Copy it and try pasting it in browser address bar) --> <strong>["+tmppath+"]</strong>");		    
		});*/
	});
	function sendContactEmail() {
		//Check captcha
		if (!ValidCaptcha()) {
			alert("Hãy nhập chính xác các ký tự trong hình.");			
			$("#cpt").focus();
			return;
		}
		var param = {
				txtFullName              	: $("#txtFullName").val(),
				txtDateofBirth             	: $("#txtDateofBirth").val(),
				txtEmail             		: $("#txtEmail").val(),
				txtDesiredLocation			: $("#txtDesiredLocation").val(),
				slsYearsOfExperience		: $("#slsYearsOfExperience").val(),
				txtSalaryDesiredFinalWorking: $("#txtSalaryDesiredFinalWorking").val(),
				txtCompanyName			  	: $("#txtCompanyName").val(),
				txtsWork			  		: $("#txtsWork").val(),
				txtMainTasks			  	: $("#txtMainTasks").val(),
				txtOtherInformation			: $("#txtOtherInformation").val(),
				JobApplication			  	: $('#JobApplication').val(),
				Resumes			  			: $("#Resumes").val()
		};
		//console.log("PARAM");
		//console.log(param);

		$.ajax({
			type     : "POST",
			url      : "/home/aboutUs/applyonline.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				if(data.trResult != null) {
					if (data.trResult == "error") {
						alert("Có lỗi khi gởi mail.");
					} else if (data.trResult == "success") {
						alert("Chúng tôi sẽ liên lạc sớm. Cảm ơn!");
						clearInfo();
						Captcha();
					}
				}
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	function clearInfo() {
		$("#txtFullName").val("");
		$("#txtDateofBirth").val("");
		$("#txtEmail").val("");
		$("#txtDesiredLocation").val("");
		$("#slsYearsOfExperience").val("");
		$("#txtSalaryDesiredFinalWorking").val("");
		$("#txtCompanyName").val("");
		$("#txtsWork").val("");
		$("#txtMainTasks").val("");
		$("#txtOtherInformation").val("");
		$("#JobApplication").val("");
		$("#Resumes").val("");
		$("#cpt").val("");
	}
	
	function Captcha(){
	    var alpha = new Array('0','1','2','3','4','5','6','7','8','9');
	    var i;
	    for (i=0;i<6;i++){
	        var a = alpha[Math.floor(Math.random() * alpha.length)];
	        var b = alpha[Math.floor(Math.random() * alpha.length)];
	        var c = alpha[Math.floor(Math.random() * alpha.length)];
	        var d = alpha[Math.floor(Math.random() * alpha.length)];
	                     }
	        var code = a + ' ' + b + ' ' + ' ' + c + ' ' + d;
			$("#captcha").val(code);
	      }
	function ValidCaptcha(){
	    var string1 = removeSpaces($("#captcha").val());
	    var string2 = $("#cpt").val();
	    if (string1 == string2){
	           return true;
	    } else {        
	         return false;
	    }
	}
	function removeSpaces(string){
	    return string.split(' ').join('');
	}
</script>
</head>
<body>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Về chúng tôi</h2>
            <ul>
            	<li><a href="/home/aboutUs/philosophy.do">Tầm nhìn và</br>Triết lý</a></li>
            	<li><a href="/home/aboutUs/why.do">Chúng tôi làm gì</a></li>
            	<li><a href="/home/aboutUs/history.do">Lịch sử</a></li>
                <li>
                    <a href="/home/aboutUs/career.do" class="on">Nghề nghiệp</a>
                    <ul class="lnb_sub">
                        <li><a href="/home/aboutUs/vacancies.do">Vị trí tuyển dụng</a></li>
                        <li><a href="/home/aboutUs/applyonline.do" class="on">Nộp hồ sơ trực tuyến</a></li>
                    </ul>
                </li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Nộp hồ sơ trực tuyến</h3>
            <div class="form">
             	<form>
		        <table class='FormApplyOnline' cellpadding='0' cellspacing='0'>
		            <tbody>
		                <tr>
		                    <td class='name'>Họ và Tên</td>
		                    <td>
		                        <input class="txt-input" id='txtFullName' name="txtFullName" />
		                    </td>
		                </tr>
		                <tr>
		                    <td class='name'>Ngày sinh</td>
		                    <td>
		                        <input class="txt-input" id='txtDateofBirth' name="txtDateofBirth" />
		                    </td>
		                </tr>
		                <tr>
		                    <td class='name'>Email</td>
		                    <td>
		                        <input class="txt-input" id='txtEmail' name="txtEmail" />
		                    </td>
		                </tr>
		                <tr>
		                    <td class='name'>Vị trí mong muốn (Công việc/Bộ phận)</td>
		                    <td>
		                        <textarea class="txtDesiredLocation" id='txtDesiredLocation' name="txtDesiredLocation"></textarea>
		                    </td>
		                </tr>
		                <tr>
		                    <td class='name'>Kinh nghiệm làm việc</td>
		                    <td>
		                        <table cellpadding="0px" cellspacing="0px" width="100%">
		                            <tr>
		                                <td>
		                                    <div><b>Số năm kinh nghiệm</b></div>
		                                    <div>
		                                        <select id="slsYearsOfExperience" name="slsYearsOfExperience">
		                                            <option>Chọn số năm kinh nghiệm</option>
		                                            <option><1</option>
		                                            <option>1</option>
		                                            <option>2</option>
		                                            <option>3</option>
		                                            <option>4</option>
		                                            <option>5</option>
		                                            <option>>5</option>
		                                        </select></div>
		                                </td>
		                                <td>
		                                    <div><b>Mức lương năm làm việc cuối</b></div>
		                                    <div>
		                                        <input class="txt-input" id='txtSalaryDesiredFinalWorking' name="txtSalaryDesiredFinalWorking" />
		                                    </div>
		                                </td>
		                            </tr>
		                        </table>
		                    </td>
		                </tr>
		                <tr>
		                    <td>Công việc cuối cùng đã đảm nhiệm</td>
		                    <td>
		                        <table cellpadding="0px" cellspacing="0px" width="100%">
		                            <tr>
		                                <td>
		                                    <div><b>Tên công ty</b></div>
		                                    <div>
		                                        <input class="txt-input" id='txtCompanyName' name="txtCompanyName" />
		                                    </div>
		                                </td>
		                                <td>
		                                    <div><b>Công việc</b></div>
		                                    <div>
		                                        <input class="txt-input" id="txtsWork" name="txtsWork"/>
		                                    </div>
		                                </td>
		                            </tr>
		                        </table>
		                    </td>
		                </tr>
		                <tr>
		                    <td>
		                        &nbsp;
		                    </td>
		                    <td>
		                        <div><b>Công việc chính</b></div>
		                        <div>
		                            <textarea class="txtDesiredLocation" id='txtMainTasks' name="txtMainTasks"></textarea>
		                        </div>
		                    </td>
		                </tr>
		                <tr>
		                    <td class='name'>Đính kèm tài liệu</td>
		                    <td>
		                        <table cellpadding="0px" cellspacing="0px" width="100%">
		                            <tr>
		                                <td>
		                                    <div><b>Đơn xin việc</b></div>
		                                    <div>
		                                        <input style="width:250px;" id="JobApplication" name="JobApplication" type="file" />
		                                    </div>
		                                </td>
		                                <td>
		                                    <div><b>Sơ yếu lý lịch</b></div>
		                                    <div>
		                                        <input style="width:250px;" id="Resumes" name="Resumes" type="file" />
		                                    </div>
		                                </td>
		                            </tr>
		                        </table>
		                    </td>
		                </tr>
		                <tr>
		                    <td>Thông tin khác (nếu có)</td>
		                    <td>
		                        <textarea class="txtDesiredLocation" id='txtOtherInformation' name="txtOtherInformation"></textarea>
		                    </td>
		                </tr>
		                <tr>
		                    <td class='name'>
		                        &nbsp;
		                    </td>
		                    <td>
		                        <div class="btnRegister">
		                        	<input id="cpt" type="text" value="" style="color:#000; border:1px solid #e1e1e1; width:110px;">
									<input id="captcha" type="text" value="" style="background-color: grey; width:80px;" readonly>
		                            <input style="float:right;" class="btn_submit" type="button" value="Gửi" name="submit" onclick="sendContactEmail();"/>
		                            <div id='LoadingSendEmail'>
		                            </div>
		                        </div>
		                        <div class="clear">
		                        </div>
		                    </td>
		                </tr>
		            </tbody>
		        </table>		        
				</script>
		    </form>
             </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>