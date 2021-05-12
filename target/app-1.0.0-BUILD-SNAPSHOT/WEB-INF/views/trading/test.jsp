
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<HTML>
	<head>
	<script type="text/javascript" src="/resources/js/jquery-1.10.2.min.js"></script>
	</head>
	
	
	<script>
	$(document).ready(function() {
		//homeIdx();
		homeNews();
	});
	</script>
	
	<script>
		function homeIdx() {
	 		var param = {
				
	 		};
	 		param.dumy	=	"8"
			$.ajax({
				dataType  : "json",
				url       : "/home/homeJisu.do",
				asyc      : true,
				data      : param,
				success   : function(data) {
					if(data != null) {
						//console.log("HOME JISU 변경");
						//console.log(data);
					}
				},
				error     :function(e) {
					console.log(e);
				}
			});
	 	}
		
		function homeNews() {
	 		var param = {
				
	 		};
	 		param.dumy	=	"8"
			$.ajax({
				dataType  : "json",
				url       : "/home/homeNews.do",
				asyc      : true,
				data      : param,
				success   : function(data) {
					if(data != null) {
						//console.log("HOME JISU 변경");
						//console.log(data);
					}
				},
				error     :function(e) {
					console.log(e);
				}
			});
	 	}
		
		
	</script>
	
	TEST
	</p>
	</p>
	ID				<input type="text" id="usid" value="077C081798"></p>
	FUNCTION CODE	<input type="text" id="func" value="I"></p>
	관심그룹코드			<input type="text" id="grpn" value="1"></p>
	관심그룹명			<input type="text" id="dscr" value="test"></p>
	종목개수			<input type="text" id="nrec"></p>
	종목코드			<input type="text" id="code"></p>
	
	
	
	<button id="test1" onclick="test();">test</button>
	<button id="test2" onclick="test2();">PIHO0003</button>
	
	<button id="test3" onclick="item();">Item</button>
</HTML>