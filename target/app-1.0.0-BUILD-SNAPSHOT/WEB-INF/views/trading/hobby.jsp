<%-- 
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<HTML>
	<head>
	<script type="text/javascript" src="/resources/js/jquery-1.10.2.min.js"></script>
	<script type="text/javascript" src="/resources/js/chart_new/nexAjax.js"></script>
	</head>
	<script>
		function test() {
			var usid	=	$("#usid").val();
			var func	=	$("#func").val();
			var grpn	=	$("#grpn").val();
			var dscr	=	$("#dscr").val();
			var nrec	=	$("#nrec").val();
			var code	=	$("#code").val();
			
			var param = {
				/*
				usid	:	usid
				, func	:	func
				, grpn	:	grpn
				, dscr	:	dscr
				, nrec	:	nrec
				, code	:	code
				*/
				usid	:	usid
				, grpn_0	:	"1 "
				, dscr_0	:	"A0             "
				, grpn_1	:	"2 "
				, dscr_1	:	"A1             "
				, grpn_2	:	"3 "
				, dscr_2	:	"A2             "
				, grpn_3	:	"4 "
				, dscr_3	:	"A3             "
				, grpn_4	:	"5 "
				, dscr_4	:	"A4             "
				, grpn_5	:	"6 "
				, dscr_5	:	"A5             "
				, grpn_6	:	"7 "
				, dscr_6	:	"A6             "
				, grpn_7	:	"8 "
				, dscr_7	:	"A7             "
				, grpn_8	:	"9 "
				, dscr_8	:	"A8             "
				, grpn_9	:	"10 "
				, dscr_9	:	"A9             "
				, GridCount1 : "10"
			};
			
			//console.log(param);
			
			$.ajax({
				url:'/trading/data/getHobby.do',
				data:param,
			    dataType: 'json',
			    success: function(data){
				 	//console.log(data);
			    }
			});
		}
		
		
		function test2() {
			var usid	=	$("#usid").val();
			var func	=	$("#func").val();
			var grpn	=	$("#grpn").val();
			var dscr	=	$("#dscr").val();
			var nrec	=	$("#nrec").val();
			var code	=	$("#code").val();
			
			var param = {
				a	:	usid
				, func	:	func
				, grpn	:	grpn
				, dscr	:	dscr
				, nrec	:	nrec
				, code	:	code
			};
			
			//console.log(param);
			
			$.ajax({
				url:'/trading/data/getHobby.do',
				data:param,
			    dataType: 'json',
			    success: function(data){
				 	//console.log(data);
			    }
			});
		}
		
		
		function excep() {
			var param = {
				a	:	$("#exp").val()
			};
			
			//console.log(param);
			
			$.ajax({
				url:'/reqEx.do',
				data:param,
			    dataType: 'json',
			    success: function(data){
				 	//console.log(data);
			    }
			});
		}
		
		
		function item() {
			
			
		}
		
		
		function chart() {
			var url	=	"/trading/data/pibochart2.do";
			
			var param = {
				rcod		:	'HAG'
				, count		:	'000020'
				, date		:	"20170321"
				, unit		:	'1'
				, dataIndex	:	'4'					// data Index	1:일,2:주,3:월,4:분,5:틱
				, dataKind	:	' '
				, dataKey	:	' '
				, gap		:	'60'					// n분, n틱
				/* 
				, ltic		:	'3'					// last tick count, => output
				*/
			};
			
			//console.log("==>PARAM CHECK<==");
			//console.log(param);
			//console.log("+++++++++++++++++");
			
			nexAjax.send({
				url : url,
				param : param,
				dataType: 'json',
				callback: function(data){
					if(data.trResult === undefined || data.trResult > 0  || data.trResult == "error"){
						var message = data.message || "데이터 로드 실패";
						nexDialog.alert(message);
						self.SearchCheck = false;
						return;
					}

					data	=	data.list;
					var resData = []; // 최종 결과 데이터
		
					if(self.DataIndex == 5) { // 분봉일때
						var chartData = data.a4500;
						//console.log("#########CHART DATA 확인##############");
						//console.log(chartData);
						//console.log("------------------------------------");
						for (var i = 0, len = chartData.length; i < len; i++) {
						    var dateTime = nexUtils.date2Utc(chartData[i]['4646'] + chartData[i]['4034']); // 일자 + 체결시간
						    //console.log("체결시간==>" + dateTime);
						    var dataOpen = chartData[i]['4029']; // 시가
						    var dataUp = chartData[i]['4030']; // 고가
						    var dataDown = chartData[i]['4031']; // 저가
						    var dataClose = chartData[i]['4023']; // 종가
						    var dataVolume = chartData[i]['4032']; // 거래량

						    //날짜 또는 시간, 시가, 고가, 저가, 종가, 거래량
						    resData.push([Number(dateTime), Number(dataOpen), Number(dataUp), Number(dataDown), Number(dataClose), Number(dataVolume), null]);
						}
						self.CurrDate = nexUtils.date2Utc(chartData[chartData.length-1]['4646'] + chartData[chartData.length-1]['4034']);

						var empty_len = 5; // 빈 데이터
						// 일목균형 체크되어 있을시
						if ( $("#mdi"+self.ViewName).find("#indicator_cna").is(':checked') ) {
							empty_len = self.ChartValue.cna[1].value; // 기본값 26
						}

						for (var i = 1, len = empty_len; i < len; i++) {
							var dateTime = nexUtils.addDateFullTime(chartData[chartData.length-1]['4646'] + chartData[chartData.length-1]['4034'], "mi", self.Gap * i);
							dateTime = nexUtils.date2Utc(dateTime);
					        resData.push([Number(dateTime), null, null, null, null, null, 'except']);
						}
					} else { // 일주월년봉일때
						var chartData = data.a5500;
					
					
						//console.log("#########분봉  CHART DATA 확인##############");
						//console.log(data);
						//console.log("------------------------------------");
					
					
					
					
						for (var i = 1, len = chartData.length; i < len; i++) {
						    if(chartData[i]['302'] != "") {
								var dateTime = nexUtils.date2Utc(chartData[i]['302']); //일자
							    //console.log("체결일자==>" + chartData[i]['302']);
							    var dataOpen = chartData[i]['29']; //시가
							    var dataUp = chartData[i]['30']; //고가
							    var dataDown = chartData[i]['31']; //저가
							    var dataClose = chartData[i]['23']; //종가
							    var dataVolume = chartData[i]['27']; //거래량
							    //날짜 또는 시간, 시가, 고가, 저가, 종가, 거래량
							    resData.push([Number(dateTime), Number(dataOpen), Number(dataUp), Number(dataDown), Number(dataClose), Number(dataVolume), null]);
						    }
						}
						self.CurrDate = nexUtils.date2Utc(chartData[chartData.length-1]['302']);

						var empty_len = 5; // 빈 데이터
						// 일목균형 체크되어 있을시
						if ( $("#mdi"+self.ViewName).find("#indicator_cna").is(':checked') ) {
							empty_len = self.ChartValue.cna[1].value; // 기본값 26
						}

						for (var i = 1, len = empty_len; i < len; i++) {
							var dateTime = nexUtils.addDateFullTime(chartData[chartData.length-1]['302'],"dd", i);
							dateTime = nexUtils.date2Utc(dateTime);
					        resData.push([Number(dateTime), null, null, null, null, null, 'except']);
						}
					}

					var monthSect = 2;
					switch (self.DataIndex) {
			            case '1' : monthSect = 2; break; //일
			            case '2' : monthSect = 3; break; //주
			            case '3' : monthSect = 4; break; //월
			            case '4' : monthSect = 4; break; //년
			            case '5' : monthSect = 1; break; //분
					}

					var checked_main_series = $("#mdi"+self.ViewName).find("#tree0560_chart").find("input[type=radio]:checked");
					var main_series_type = checked_main_series.length != 0 ? checked_main_series[0].id.split("_")[1] : "candle";

					//console.log("##########RES DATA##############");
					//console.log(resData);
					//console.log("VIEW NAME=>" + self.ViewName);
					//console.log("monthSEch=>" + monthSect);
					//console.log("height=>" + self.ChartHeight);
					//console.log("width=>" + self.ChartWidth);
					//console.log("value=>" + self.ChartValue);
					//console.log(self.ChartValue);
					//console.log("mainType=>" + main_series_type);
					
					self.ChartHeight	=	"300";
					self.ChartWidth		=	"770";
					
					self.ChartObj = new nexChart({
			    		data		: resData, //차트 기본 데이터
			    		//renderTo	: $("#mdi"+self.ViewName).find("#chart0560_0560"), //차트가 그려질 div 위치
			    		renderTo	: $("#tab23").find($(".grid_area")), //차트가 그려질 div 위치
			    		screenNum	: self.ViewName,
			    		monthSect	: monthSect,
			    		height 		: self.ChartHeight,
			    		width		: self.ChartWidth,
			    		seriesData	: self.ChartValue,
			    		mainType	: main_series_type,
			    		valueDecimals: "0"
			        });

					var checked_series = $("#mdi"+self.ViewName).find("#tree0560_chart").find("input:checked");
					//console.log("CHART SERIES CCHECK==>" + checked_series.length);
					for(var i=0;i<checked_series.length;i++){
						var id = checked_series.eq(i)[0].id;
						var series_gubn = id.split("_")[0];
						var series_name = id.split("_")[1];
						self.addSeries(series_gubn,series_name,false);
					}
					self.ChartObj.redraw();

					// 당일 일때만, 실시간처리
					
					//if(self.Date != nexUtils.getDate()) return;
					//self.requestRTS();
					
				}
			});
		}
			
		
		function fn_test(obj) {
			alert("call");
			//console.log($(obj).html());
		}
	</script>
	
	HOBBY
	</p>
	</p>
	ID				<input type="text" id="usid" value="077C081798"></p>
	FUNCTION CODE	<input type="text" id="func" value="I"></p>
	관심그룹코드			<input type="text" id="grpn" value="1"></p>
	관심그룹명			<input type="text" id="dscr" value="test"></p>
	종목개수			<input type="text" id="nrec"></p>
	종목코드			<input type="text" id="code"></p>
	
	
	Exp			<input type="text" id="exp"></p>
	
	<I onclick="fn_test(this)">AAAA</I>
	
	<button id="test1" onclick="test();">test</button>
	<button id="test2" onclick="test2();">PIHO0003</button>
	
	<button id="test3" onclick="item();">Item</button>
	<button id="test4" onclick="chart();">Chart</button>
	
	<button id="test5" onclick="excep();">Excep</button>
</HTML>
 --%>
 
 
 
 <%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
 <%
	out.println("======================= Cookie Value =================<br>");
 	Cookie[] cookie = request.getCookies();
 	if(cookie!=null){
 		for(int i=0;i<cookie.length;i++){
 			out.println("["+cookie[i].getName()+"]==["+cookie[i].getValue()+"]<br>");
 		}
 	}

 	out.println("====================== Session Value ==================<br>");
 	
 	HttpSession ss =  request.getSession(true);
 	out.println("data=>" + ss.getId() + "<br>");
   	Enumeration<String> ee = ss.getAttributeNames();
   	while(ee.hasMoreElements()){
   		String name = ee.nextElement();
   		out.println("<br>["+name+"]==["+ss.getAttribute(name)+"]");
   	}
 %>
 