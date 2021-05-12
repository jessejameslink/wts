<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="/resources/js/jquery.min.js"/></script>
<script type="text/javascript" src="/resources/js/jquery-ui.min.js"/></script>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">


<script>
function setCookie(cname,cvalue,exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires=" + d.toGMTString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getCookie(cname) {
    var name = cname + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');
    for(var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}

function checkCookie() {
    var lang = getCookie("LanguageCookie");
    if (lang != "") {
    } else {
    	lang = "vi_VN";               
    }
    setCookie("LanguageCookie", lang, 30);
    
    var param = {
    		mvCurrentLanguage	:	lang
    	};
    
    //console.log(param);

   	$.ajax({
   		dataType  : "json",
   		url       : "/login/setLanguageDefault.do",
   		data      : param,
   		cache	  : false,
   		success   : function(data) {
   			//console.log(data);
   			location.reload();
   		},
   		error     :function(e) {
   			console.log(e);
   		}
   	});   	
}

	
</script>
</style>
</head>
  <body onload="checkCookie()"> 
  </body>
</html>