
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<HTML>
	<head>
	<script type="text/javascript" src="/resources/js/jquery-1.10.2.min.js"></script>
	</head>
	<script>
		function pibosday() {
			var symb	=	$("#symb").val();
			var param = {
				symb	:	symb
			};
			//console.log(param);
			$.ajax({
				url:'/trading/data/pibosday.do',
				data:param,
			    dataType: 'json',
			    success: function(data){
			    	//console.log("RT DATA CHECK");
				 	//console.log(data);
			    }
			});
		}
		
		function pibomati() {
			var symb	=	$("#symb").val();
			var param = {
				symb	:	symb
			};
			//console.log(param);
			$.ajax({
				url:'/trading/data/pibomati.do',
				data:param,
			    dataType: 'json',
			    success: function(data){
			    	//console.log("RT DATA CHECK");
				 	//console.log(data);
			    }
			});
		}
		
		function pibotopm() {
			var fymd	=	"15/09/2016";
			var tymd	=	"16/09/2016";
			var mark	=	"0";
			var updn	=	"0";
			
			var param = {
					fymd	:	fymd
					, tymd	:	tymd
					, mark	:	mark
					, updn	:	updn
			};
			
			$.ajax({
				url:'/trading/data/pibotopm.do',
				data:param,
			    dataType: 'json',
			    success: function(data){
			    	//console.log("RT DATA CHECK");
				 	//console.log(data);
			    }
			});
		}
		
		
		function pibomost() {
			var mark	=	"0";
			var param = {
				mark	:	mark
			};
			
			$.ajax({
				url:'/trading/data/pibomost.do',
				data:param,
			    dataType: 'json',
			    success: function(data){
			    	//console.log("RT DATA CHECK");
				 	//console.log(data);
			    }
			});
		}
		
		function pibonewh() {
			var mark	=	"0";
			var high	=	"0";
			var days	=	"0";
			var param = {
				mark	:	mark
				, high	:	high
				, days	:	days
			};
			
			$.ajax({
				url:'/trading/data/pibonewh.do',
				data:param,
			    dataType: 'json',
			    success: function(data){
			    	//console.log("RT DATA CHECK");
				 	//console.log(data);
			    }
			});
		}
		
		
		function piboaccn() {
			var usid	=	"077C080169";
			
			var param = {
				usid	:	usid
			};
			
			$.ajax({
				url:'/trading/data/piboaccn.do',
				data:param,
			    dataType: 'json',
			    success: function(data){
			    	//console.log("RT DATA CHECK");
				 	//console.log(data);
			    }
			});
		}
		
		
		function pibochart1() {
			var usid	=	"077C080169";
			var rcod	=	$("#rcod").val();
			
			var param = {
				rcod		:	rcod
				, count		:	'000010'
				, date		:	'20161013'
				, unit		:	'1'
				, dataIndex	:	'1'
				, dataKind	:	' '
				, dataKey	:	' '
			};
			
			$.ajax({
				url:'/trading/data/pibochart1.do',
				data:param,
			    dataType: 'json',
			    success: function(data){
			    	//console.log("RT pibochart1 DATA CHECK");
				 	//console.log(data);
			    }
			});
		}
		
		function piborsch() {
			var skey	=	"";
			var lang	=	"";
			
			var param = {
				skey	:	skey
				, lang	:	lang
			};
			
			$.ajax({
				url:'/trading/data/piborsch.do',
				data:param,
			    dataType: 'json',
			    success: function(data){
			    	//console.log("RT DATA CHECK");
				 	//console.log(data);
			    }
			});
		}
		
		
		function pibohidx() {
			var dumy	=	" ";
			
			var param = {
				dumy	:	dumy
			};
			
			$.ajax({
				url:'/home/homeJisu.do',
				data:param,
			    dataType: 'json',
			    success: function(data){
			    	//console.log("HINDEX~~~~");
				 	//console.log(data);
			    }
			});
		}
		
	</script>
	
	TR TEST
	</p>
	</p>
	symb				<input type="text" id="symb" value="BTP"></p>
	FUNCTION CODE	<input type="text" id="func" value="I"></p>
	관심그룹코드			<input type="text" id="grpn" value="1"></p>
	관심그룹명			<input type="text" id="dscr" value="test"></p>
	종목개수			<input type="text" id="nrec"></p>
	종목코드			<input type="text" id="code"></p>
	
	
	1301			<input type="text" id="rcod" value="BTP"></p>
	
	<button id="testH1" onclick="pibohidx();">PIBOHIDX</button>
	
	<button id="test1" onclick="pibosday();">PIBOSDAY</button>
	<button id="test2" onclick="pibomati();">PIBOMATI</button>
	<button id="test3" onclick="pibotopm();">PIBOTOPM</button>
	<button id="test4" onclick="pibomost();">PIBOMOST</button>
	<button id="test5" onclick="pibonewh();">PIBONEWH</button>
	
	<button id="test5" onclick="piboaccn();">PIBOACCN</button>
	<button id="test5" onclick="piborsch();">piborsch</button>
	
	<button id="test5" onclick="pibochart1();">pibochart1</button>
</HTML>