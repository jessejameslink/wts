<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">

<script>
var sFileContent;
var sFileName;
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Open Account Online";
		
		$('#txtCMNDAtt').on('change', function( e ) {
			sFileName = e.target.files[0].name;			
			var input = document.getElementById("txtCMNDAtt");
			var fReader = new FileReader();
			fReader.readAsDataURL(input.files[0]);
			fReader.onloadend = function(event){
			    sFileContent = event.target.result;
			}
		})
		
		var d = new Date();
		$(".datepicker").datepicker({
			showOn      : "button",
			dateFormat  : "dd/mm/yy",
			changeYear  : true,
			changeMonth : true
		});
		$("#txtDateofBirth").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
		$("#txtDateIssue").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
		
		$("#isWebTrading").on('change', function(e) {
			$("#notWebTrading").prop("checked", false);
		});
		
		$("#notWebTrading").on('change', function(e) {
			$("#isWebTrading").prop("checked", false);
		});
		
		$("#isPhoneTrading").on('change', function(e) {
			$("#notPhoneTrading").prop("checked", false);
			$("#txtPassword").prop("disabled", false);
		});
		$("#notPhoneTrading").on('change', function(e) {
			$("#isPhoneTrading").prop("checked", false);
			$("#txtPassword").prop("disabled", true);
		});
		
		$("#isAdvance").on('change', function(e) {
			$("#notAdvance").prop("checked", false);
		});
		$("#notAdvance").on('change', function(e) {
			$("#isAdvance").prop("checked", false);
		});
		Captcha();
		setInterval(Captcha, 600000);
	});
	
	function sendContactEmail() {
		//Check input value
		if ($("#txtFullName").val() == "") {
			alert("Please input name.");			
			$("#txtFullName").focus();
			return;
		}
		if ($("#txtPlaceofBirth").val() == "") {
			alert("Please input place of birth.");			
			$("#txtPlaceofBirth").focus();
			return;
		}
		if ($("#txtCMND").val() == "") {
			alert("Please input Identification number / Passport number.");			
			$("#txtCMND").focus();
			return;
		}
		
		if ($("#txtPlaceIssue").val() == "") {
			alert("Please input Place of issue.");			
			$("#txtPlaceIssue").focus();
			return;
		}
		
		if ($("#txtPermanentAddress").val() == "") {
			alert("Please input Permanent address.");			
			$("#txtPermanentAddress").focus();
			return;
		}
		
		if ($("#txtCorrespondenceAddress").val() == "") {
			alert("Please input Correspondence address.");			
			$("#txtCorrespondenceAddress").focus();
			return;
		}
		
		if ($("#txtTelephone").val() == "") {
			alert("Please input Telephone.");			
			$("#txtTelephone").focus();
			return;
		}
		
		if ($("#txtEmail").val() == "") {
			alert("Please input email.");			
			$("#txtEmail").focus();
			return;
		}
		
		if (!$("#isWebTrading").is(':checked') && !$("#notWebTrading").is(':checked')) {
			alert("Please select Web trading.");						
			return;
		}
		
		if ($("#txtEmailR").val() == "") {
			alert("Please input email to Register channel to receive userID and password (compulsory).");			
			$("#txtEmailR").focus();
			return;
		}
		if ($("#txtPhoneR").val() == "") {
			alert("Please input phone number to Register channel to receive userID and password (compulsory).");			
			$("#txtPhoneR").focus();
			return;
		}
		
		/*if (!$("#isPhoneTrading").is(':checked') && !$("#notPhoneTrading").is(':checked')) {
			alert("Please select Telephone trading.");						
			return;
		}
		
		if ($("#txtPassword").val() == "") {
			alert("Please input password.");			
			$("#txtPassword").focus();
			return;
		}*/
		
		if ($("#isPhoneTrading").is(':checked')) {
			if ($("#txtPassword").val() == "") {
				alert("Please input password.");			
				$("#txtPassword").focus();
				return;
			}
		}
		
		if ($("#txtPhoneOrder").val() == "") {
			alert("Please input phone number to Receive matched results through SMS.");			
			$("#txtPhoneOrder").focus();
			return;
		}
		
		if (!$("#isAdvance").is(':checked') && !$("#notAdvance").is(':checked')) {
			alert("Please select Automatic cash advance from sale of securities.");						
			return;
		}
		
		if ($("#txtCMNDAtt").val() == "") {
			alert("Please select Identification number / Passport number attachment.");
			return;
		}
		
		//Check captcha
		if (!ValidCaptcha()) {
			alert("Let's input right character same the picture.");			
			$("#cpt").focus();
			return;
		}
		var isweb = "Có";
		var isphone = "Có";
		var isadvance = "Có";
		if ($("#isWebTrading").is(':checked')) {
			isweb = "Có";
		} else {
			isweb = "Không";
		}
		
		if ($("#isPhoneTrading").is(':checked')) {
			isphone = "Có";
		} else {
			isphone = "Không";
		}
		
		if ($("#isAdvance").is(':checked')) {
			isadvance = "Có";
		} else {
			isadvance = "Không";
		}
		var param = {
				txtFullName              	: $("#txtFullName").val(),
				txtDateofBirth             	: $("#txtDateofBirth").val(),
				txtPlaceofBirth             : $("#txtPlaceofBirth").val(),
				txtCMND             		: $("#txtCMND").val(),
				txtDateIssue             	: $("#txtDateIssue").val(),
				txtPlaceIssue             	: $("#txtPlaceIssue").val(),
				txtPermanentAddress         : $("#txtPermanentAddress").val(),
				txtCorrespondenceAddress    : $("#txtCorrespondenceAddress").val(),
				txtTelephone    			: $("#txtTelephone").val(),				
				txtEmail             		: $("#txtEmail").val(),
				isWebTrading             	: isweb,
				txtEmailR             		: $("#txtEmailR").val(),
				txtPhoneR             		: $("#txtPhoneR").val(),
				isPhoneTrading             	: isphone,
				txtPassword             	: $("#txtPassword").val(),
				txtPhoneOrder             	: $("#txtPhoneOrder").val(),
				isAdvance             		: isadvance,
				txtBank1Number             	: $("#txtBank1Number").val(),
				txtBank1Name             	: $("#txtBank1Name").val(),
				txtBank1Branch             	: $("#txtBank1Branch").val(),
				txtBank2Number             	: $("#txtBank2Number").val(),
				txtBank2Name             	: $("#txtBank2Name").val(),
				txtBank2Branch             	: $("#txtBank2Branch").val(),
				txtBank3Number             	: $("#txtBank3Number").val(),
				txtBank3Name             	: $("#txtBank3Name").val(),
				txtBank3Branch             	: $("#txtBank3Branch").val(),
				txtCMNDAtt			  		: sFileName,
				txtFileContent			  	: sFileContent
		};
		
		//console.log("PARAM");
		//console.log(param);

		$.ajax({
			type     : "POST",
			url      : "/home/aboutUs/openaccountonlinepost.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				if(data.trResult != null) {
					if (data.trResult == "error") {
						alert("Error in Sending Email!");
					} else if (data.trResult == "success") {
						alert("We will be in touch soon. Thank you!");
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
		$("#txtPlaceofBirth").val("");
		$("#txtCMND").val("");
		$("#txtDateIssue").val("");
		$("#txtPlaceIssue").val("");
		$("#txtPermanentAddress").val("");
		$("#txtCorrespondenceAddress").val("");
		$("#txtTelephone").val("");
		$("#txtEmail").val("");		
		$("#txtEmailR").val("");
		$("#txtPhoneR").val("");		
		$("#txtPassword").val("");
		$("#txtPhoneOrder").val("");		
		$("#txtBank1Number").val("");		
		$("#txtBank1Name").val("");
		$("#txtBank1Branch").val("");		
		$("#txtBank2Number").val("");		
		$("#txtBank2Name").val("");
		$("#txtBank2Branch").val("");
		$("#txtBank3Number").val("");		
		$("#txtBank3Name").val("");
		$("#txtBank3Branch").val("");
		$("#txtCMNDAtt").val("");
		
		$("#isWebTrading").prop("checked", false);
		$("#notWebTrading").prop("checked", false);
		
		$("#isPhoneTrading").prop("checked", false);
		$("#notPhoneTrading").prop("checked", false);
		
		$("#isAdvance").prop("checked", false);
		$("#notAdvance").prop("checked", false);
		
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
	        var e = alpha[Math.floor(Math.random() * alpha.length)];
	        var f = alpha[Math.floor(Math.random() * alpha.length)];
	                     }
	        var code = a + ' ' + b + ' ' + ' ' + c + ' ' + d + ' ' + e + ' ' + f;
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
	
	function selectFile() {		
		$.ajax({
			type     : "POST",
			url      : "/home/aboutUs/selectFileUpload.do",
			dataType : "json",
			success  : function(data){
				//console.log("DATA");
				//console.log(data);
				if (data.trPath != "nullnull") {
					$("#txtCMNDAtt").html(data.trPath);
					$("#txtCMNDAtt").val(data.trPath);
				}
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
</script>
</head>
<body>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <div id="contents" class="full_width" style="padding-top:20px;padding-left:20px;padding-right:20px;">
            <h3 class="cont_title">Open Account Online</h3>
            <div class="form">
             	<form>
		        <table class='FormApplyOnline' cellpadding='0' cellspacing='0'>
		            <tbody>
		            	<tr>
			                <td style="font-weight:bold;font-size:19px;">BASIC INFORMATION <span style="color:red;">(*)</span></td>
		                </tr>
		                <tr>
		                    <td class='name'>Name</td>
		                    <td>
		                        <input class="txt-input" id='txtFullName' name="txtFullName" />
		                    </td>
		                </tr>
		                <tr>
		                    <td class='name'>Date of birth</td>
		                    <td>
		                        <span class="date_box_open_online">
	                                <input id="txtDateofBirth" name="txtDateofBirth" type="text" title="" class="datepicker" />
	                                <button type="button">Open Calendar</button>
	                            </span>
		                    </td>
		                </tr>
		                <tr>
		                    <td class='name'>Place of birth</td>
		                    <td>
		                        <input class="txt-input" id='txtPlaceofBirth' name="txtPlaceofBirth" />
		                    </td>
		                </tr>
		                <tr>
		                    <td class='name'>Identification number / Passport number</td>
		                    <td>
		                        <input class="txt-input" id='txtCMND' name="txtCMND" />
		                    </td>
		                </tr>
		                <tr>
		                    <td class='name'>Date of issue</td>
		                    <td>
		                        <span class="date_box_open_online">
	                                <input id="txtDateIssue" name="txtDateIssue" type="text" title="" class="datepicker" />
	                                <button type="button">Open Calendar</button>
	                            </span>
		                    </td>
		                </tr>
		                <tr>
		                    <td class='name'>Place of issue</td>
		                    <td>
		                        <input class="txt-input" id='txtPlaceIssue' name="txtPlaceIssue" />
		                    </td>
		                </tr>
		                <tr>
		                    <td class='name'>Permanent address</td>
		                    <td>
		                        <textarea style="height:50px;" class="txtDesiredLocation" id='txtPermanentAddress' name="txtPermanentAddress"></textarea>
		                    </td>
		                </tr>
		                <tr>
		                    <td class='name'>Correspondence address</td>
		                    <td>
		                        <textarea style="height:50px;" class="txtDesiredLocation" id='txtCorrespondenceAddress' name="txtCorrespondenceAddress"></textarea>
		                    </td>
		                </tr>
		                <tr>
		                    <td class='name'>Telephone</td>
		                    <td>
		                        <input class="txt-input" id='txtTelephone' name="txtTelephone" />
		                    </td>
		                </tr>
		                <tr>
		                    <td class='name'>Email</td>
		                    <td>
		                        <input class="txt-input" id='txtEmail' name="txtEmail" />
		                    </td>
		                </tr>
		                
		                <tr>			                
			                <td style="font-weight:bold;font-size:19px;">SERVICE REGISTRATION <span style="color:red;">(*)</span></td>			              
		                </tr>
		                <tr>
		                    <td class='name' style="font-weight:bold;">1. Web trading</td>
		                    <td>
		                        <input style="margin-top:6px;" type="radio" id="isWebTrading"/>
		                        <label for="isWebTrading">Yes</label>
		                    </td>		                    
		                </tr>
		                <tr>
		                    <td class='name'>&nbsp;</td>
		                    <td>
		                        <input style="margin-top:6px;" type="radio" id="notWebTrading"/>
		                        <label for="notWebTrading">No</label>
		                    </td>		                    
		                </tr>
		                <tr>
		                    <td class='name'>Register channel to receive userID and password (compulsory)</td>
		                </tr>
		                <tr>
		                    <td class='name'>Email</td>
		                    <td>
		                        <input class="txt-input" id='txtEmailR' name="txtEmailR" />
		                    </td>
		                </tr>
		                <tr>
		                    <td class='name'>SMS</td>
		                    <td>
		                        <input class="txt-input" id='txtPhoneR' name="txtPhoneR" />
		                    </td>
		                </tr>
		                <tr>
		                    <td class='name' style="font-weight:bold;">2. Telephone trading</td>
		                    <td>
		                        <input style="margin-top:6px;" type="radio" id="isPhoneTrading"/>
		                        <label for="isPhoneTrading">Yes</label>
		                    </td>		                    
		                </tr>
		                <tr>
		                    <td class='name'>&nbsp;</td>
		                    <td>
		                        <input style="margin-top:6px;" type="radio" id="notPhoneTrading"/>
		                        <label for="notPhoneTrading">No</label>
		                    </td>		                    
		                </tr>
		                <tr>
		                    <td class='name'>Password (4 numbers, not consecutive numbers, provided by Customer)</td>
		                    <td>
		                        <input class="txt-input" id='txtPassword' name="txtPassword" />
		                    </td>
		                </tr>
		                <tr>
		                    <td class='name' style="font-weight:bold;">3. Receive matched results through SMS</td>                    
		                </tr>
		                <tr>
		                    <td class='name'>Registered phone number</td>
		                    <td>
		                        <input class="txt-input" id='txtPhoneOrder' name="txtPhoneOrder" />
		                    </td>
		                </tr>
		                <tr>
		                    <td class='name' style="font-weight:bold;">4. Automatic cash advance from sale of securities</td>
		                    <td>
		                        <input style="margin-top:6px;" type="radio" id="isAdvance"/>
		                        <label for="isAdvance">Yes</label>
		                    </td>		                    
		                </tr>
		                <tr>
		                    <td class='name'>&nbsp;</td>
		                    <td>
		                        <input style="margin-top:6px;" type="radio" id="notAdvance"/>
		                        <label for="notAdvance">No</label>
		                    </td>		                    
		                </tr>
		                <tr>			                
			                <td style="font-weight:bold;font-size:19px;">REGISTER BANK ACCOUNT FOR CASH TRANSFER</td>			              
		                </tr>
		                <tr>
		                    <td class='name'>You can register maximum 3 banks or don't need to register</td>		                                   
		                </tr>
		                <tr>
		                    <td class='name' style="font-weight:bold;">1. Bank No.1</td>		                                   
		                </tr>
		                <tr>
		                    <td class='name'>Bank Account No</td>
		                    <td>
		                        <input class="txt-input" id='txtBank1Number' name="txtBank1Number" />
		                    </td>                    
		                </tr>
		                <tr>
		                    <td class='name'>Account Name</td>
		                    <td>
		                        <input class="txt-input" id='txtBank1Name' name="txtBank1Name" />
		                    </td>                    
		                </tr>
		                <tr>
		                    <td class='name'>At Bank</td>
		                    <td>
		                        <input class="txt-input" id='txtBank1Branch' name="txtBank1Branch" />
		                    </td>                    
		                </tr>
		                <tr>
		                    <td class='name' style="font-weight:bold;">2. Bank No.2</td>		                                   
		                </tr>
		                <tr>
		                    <td class='name'>Bank Account No</td>
		                    <td>
		                        <input class="txt-input" id='txtBank2Number' name="txtBank2Number" />
		                    </td>                    
		                </tr>
		                <tr>
		                    <td class='name'>Account Name</td>
		                    <td>
		                        <input class="txt-input" id='txtBank2Name' name="txtBank2Name" />
		                    </td>                    
		                </tr>
		                <tr>
		                    <td class='name'>At Bank</td>
		                    <td>
		                        <input class="txt-input" id='txtBank2Branch' name="txtBank2Branch" />
		                    </td>                    
		                </tr>
		                <tr>
		                    <td class='name' style="font-weight:bold;">3. Bank No.3</td>
		                </tr>
		                <tr>
		                    <td class='name'>Account Name</td>
		                    <td>
		                        <input class="txt-input" id='txtBank3Number' name="txtBank3Number" />
		                    </td>                    
		                </tr>
		                <tr>
		                    <td class='name'>Bank Account No</td>
		                    <td>
		                        <input class="txt-input" id='txtBank3Name' name="txtBank3Name" />
		                    </td>                    
		                </tr>
		                <tr>
		                    <td class='name'>At Bank</td>
		                    <td>
		                        <input class="txt-input" id='txtBank3Branch' name="txtBank3Branch" />
		                    </td>                    
		                </tr>
		                
		                <tr>			                
			                <td style="font-weight:bold;font-size:19px;">IDENTIFICATION NUMBER / PASSPORT NUMBER <span style="color:red;">(*)</span></td>			              
		                </tr>
		                <tr>
		                    <td class='name'>Identification number / Passport number attachment</td>
		                    <td>
		                        <table cellpadding="0px" cellspacing="0px" width="100%">
		                            <tr>
		                                <td>
					                        <div>
		                                        <input style="width:250px;" id="txtCMNDAtt" name="txtCMNDAtt" type="file" />
		                                    </div>
					                    </td>		                                
		                            </tr>
		                        </table>
		                    </td>
		                </tr>
		                
		                <tr>
		                    <td class='name'>
		                        &nbsp;
		                    </td>
		                    <td>
		                        <div class="btnRegister">
		                        	<input id="cpt" type="text" value="" style="color:#000; border:1px solid #e1e1e1; width:110px;">
									<input id="captcha" type="text" value="" style="background-color: grey; width:90px;" readonly>
		                            <input style="float:right;" class="btn_submit" type="button" value="Send" name="submit" onclick="sendContactEmail();"/>
		                            <div id='LoadingSendEmail'>
		                            </div>
		                        </div>
		                        <div class="clear">
		                        </div>
		                    </td>
		                </tr>
		                
		                <tr>			                
			                <td style="font-style:italic;"><span style="color:red;">(*) </span> Fill all information in this area (compulsory)</td>			              
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