<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<%--
<%@ include file = "<c:url value='/include/header.jsp'/>" %>
 --%>
<html>
<head>
<title>CHART SERVICE</title>
<link href="/resources/css/common.css" rel="stylesheet">

<!-- 
<script type="text/javascript" src="/resources/js/chart_lib/lib/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/lib/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/lib/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/lib/jquery/jquery.treeview.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/lib/jquery/jquery.placeholder.js"></script>
 -->
 
<script type="text/javascript" src="/resources/js/chart_lib/lib/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/lib/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/lib/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/lib/jquery/jquery.treeview.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/lib/jquery/jquery.placeholder.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/lib/angular/angular.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/lib/mdi/nexMdiLib.js"></script>
<!-- 
<script type="text/javascript" src="/resources/js/chart_lib/nexMdiRegister.js"></script>
 -->
<script type="text/javascript" src="/resources/js/chart_lib/common/nexMdi.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/common/nexDialog.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/common/nexAjax.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/common/nexClient.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/lib/pqgrid/pqgrid.dev.inlab.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/lib/pqgrid/touch-punch/touch-punch.min.js"></script>
<!-- 
<script type="text/javascript" src="/resources/js/chart_lib/renewal/js/caorder.js"></script>
 -->
<script type="text/javascript" src="/resources/js/chart_lib/lib/jquery/plugin.all.min.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/lib/highcharts_new/highstock.src.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/lib/highcharts_new/highcharts-more.src.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/common/nexChart.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/utils/nexChartUtils.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/utils/commonUtils.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/utils/nexUtils.js"></script>
<script type="text/javascript" src="/resources/js/chart_lib/common/nexFmt.js"></script>

<script>
	this.Type;
	this.Value;
	this.$Scope;
	
	this.ViewName;
	this.RefCode;
	this.SearchCheck = false;
	
	this.GridObj;
	this.ChartObj;
	this.StockTreeObj;
	this.ChartTreeObj; 
	this.ChartWidth = '709';
	this.ChartHeight = '518';
	this.ChartValueDefault = {
	   	'candle'	: null,
	   	'volume'	: null,
	   	'sma'		: [{name:'MA1',value:5,lineColor:'#76B448',lineWidth:'1'},{name:'MA2',value:20,lineColor:'#E03433',lineWidth:'1'},{name:'MA3',value:60,color:'#337FE5',lineWidth:'1'},{name:'MA4',value:120,lineColor:'#FF59AC',lineWidth:'1'},{name:'MA5',value:200,lineColor:'#0059AC',lineWidth:'1'}],
	   	'cna'		: [{name:'전환선',value:9},{name:'기준,후,선',value:26},{name:'선행스팬',value:52}],
	   	'bollinger'	: [{name:'기간',value:20}],
	   	'parabolic'	: [{name:'AF최대값',value:0.02}],
	   	'envelope'	: [{name:'기간',value:20},{name:'가감값',value:5}],
	   	'maribbon'	: [{name:'시작이평',value:5},{name:'증가',value:2},{name:'갯수',value:10}],
	   	'macd'		: [{name:'단기이평',value:12},{name:'장기이평',value:26},{name:'Signal',value:9}],
	   	'slowStc'	: [{name:'기간',value:5},{name:'Slow&K',value:5},{name:'Slow%D',value:3}],
	   	'cci'		: [{name:'기간',value:14}], 
	   	'mental'	: [{name:'기간',value:10}],
	   	'adx'		: [{name:'기간',value:14}],
	   	'obv'		: [{name:'OBV',value:9}],
	   	'sonar'		: [{name:'이평기간',value:12},{name:'비교기간',value:26},{name:'Signal',value:9}],
	   	'vr'		: [{name:'기간',value:20}],
	   	'trix'		: [{name:'기간',value:12},{name:'Signal',value:9}],
	   	'roc'		: [{name:'기간',value:12}],
	   	'williams'	: [{name:'williams %R',value:14},{name:'%D',value:3}],
	   	'rsi'		: [{name:'기간',value:10},{name:'Signal',value:5}],
	   	'dis'		: [{name:'이격1',value:5},{name:'이격2',value:10},{name:'이격3',value:20},{name:'이격4',value:40}]
	};
	
	this.ChartValue = $.extend(true,{},this.ChartValueDefault); // deep copy
	
	//this.InterestGroupData = InterestData;
	//this.AccountNumberData = AccountData;
	
	
	this.CurrDate 	= ''; 
		
	// CHART INPUT DATA
	this.Gubn 		= 'D';
	this.Count		= "300"; 		// 조회기간
	//this.Date		= nexUtils.getDate();	// 일자
	this.Unit		= "1";			// 1:종목, 2:업종, 3:선물 ...등등
	this.DataIndex	= "1";			// 1:일봉, 2:주봉, 3:월봉, 4:분봉, 5:틱
	this.Gap		= "1";	
	this.DataKind	= " "; 			// 1:당일	
	
	var self=this;

/* 
$.getJSON("/resources/js/chart_lib/data/chartData.json", function(data){
	console.log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	console.log(data);
});
 */
</script>


<script>

self.ChartTreeObj=$("#mdi"+self.ViewName).find("#tree0560_chart").treeview({
	persist: "location",
	collapsed: false,
	unique: false
});

$("#mdi"+self.ViewName).find("#tree0560_chart").on('change','input',function(){
	var tree_id = this.id;
	var tree_ids = tree_id.split("_");
	var gubn = tree_ids[0];
	var chart_name = tree_ids[1];
	
	if(gubn == "type") {
		self.search(); // 타입변경시, 차트를 다시그려야한다.
		return;
	}
	
	var indi_chk_cnt = $(this).parent().parent().find("input[id*="+gubn+"]:checked").length;
	var assi_chk_cnt = $(this).parent().parent().find("input[id*="+gubn+"]:checked").legnth;

	if(indi_chk_cnt !== undefined && indi_chk_cnt > 3) {
		if($(this).is(":checked")){
			$(this).prop("checked","");
			nexDialog.alert("채널지표는 3개까지 선택할 수 있습니다");
			return;
		} 
	}
	
	if(assi_chk_cnt !== undefined && assi_chk_cnt > 3) {
		if($(this).is(":checked")){
			$(this).prop("checked","");
			nexDialog.alert("보조차트는 3개까지 선택할 수 있습니다");
			return;
		} 
	}
	
	if(chart_name == "cna") {
		self.search(); // 일목균형 선택시, 차트를 다시그려야한다.
		return;
	}
	
	if( $(this).is(":checked") ){
		self.addSeries(gubn,chart_name,true);
	} else {
		self.removeSeries(gubn,chart_name,true);
	}
});

self.ChartTreeObj.on('treeSelect', function(e, data) {
	$("#mdi"+self.ViewName).find("#"+data.treeId).click();
});









/****************************************************************
 * 차트
 ****************************************************************/
this.initChart = function() {
	
	alert("INIT CHARTK");
	/*
	var url = '/tr/wtschart.jsp';
	var param = {
		gubn 		: self.Gubn,
		code 		: self.RefCode,		// 종목코드
		count		: self.Count, 		// 조회기간
		date		: self.Date, 		// 일자
		unit		: self.Unit,		// 1:종목, 2:업종, 3:선물 ...등등
		dataIndex	: self.DataIndex,	// 1:일봉, 2:주봉, 3:월봉, 4:년봉, 5:분봉
		gap			: self.Gap,			// n분, n틱
		dataKind	: self.DataKind		// 1:당일
	};
	*/
	var url = '/trading/data/pibochart1.do';
	var param = {
		rcod		:	"HAH"
		, count		:	'000040'
		, date		:	'20161121'
		, unit		:	'1'
		, dataIndex	:	'1'
		, dataKind	:	' '
		, dataKey	:	' '
	};

	nexAjax.send({
		url : url,
		param : param,
		dataType: 'json',
		callback: function(data){
			//console.log("CALL BACK===>");
			//console.log(data);
			//에러 팝업 처리
			//if(data.returnCode === undefined || data.returnCode > 0  || data.result == "error"){
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

				for (var i = 0, len = chartData.length; i < len; i++) {
				    var dateTime = nexUtils.date2Utc(chartData[i]['4646'] + chartData[i]['4034']); // 일자 + 체결시간
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
			//console.log("일주우러년분");
			//console.log(chartData);
				for (var i = 1, len = chartData.length; i < len; i++) {
				    var dateTime = nexUtils.date2Utc(chartData[i]['302']); //일자
				    var dataOpen = chartData[i]['29']; //시가
				    var dataUp = chartData[i]['30']; //고가
				    var dataDown = chartData[i]['31']; //저가
				    var dataClose = chartData[i]['23']; //종가
				    var dataVolume = chartData[i]['27']; //거래량
				    //날짜 또는 시간, 시가, 고가, 저가, 종가, 거래량
				    resData.push([Number(dateTime), Number(dataOpen), Number(dataUp), Number(dataDown), Number(dataClose), Number(dataVolume), null]);
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
			
			self.ChartObj = new nexChart({
	    		data		: resData, //차트 기본 데이터
	    		renderTo	: $("#mdi"+self.ViewName).find("#chart0560_0560"), //차트가 그려질 div 위치
	    		screenNum	: self.ViewName,
	    		monthSect	: monthSect,
	    		height 		: self.ChartHeight,
	    		width		: self.ChartWidth,
	    		seriesData	: self.ChartValue,
	    		mainType	: main_series_type,
	    		valueDecimals: "0"
	        });
			
			var checked_series = $("#mdi"+self.ViewName).find("#tree0560_chart").find("input:checked");
			for(var i=0;i<checked_series.length;i++){
				var id = checked_series.eq(i)[0].id;
				var series_gubn = id.split("_")[0];
				var series_name = id.split("_")[1];
				self.addSeries(series_gubn,series_name,false);
			}
			self.ChartObj.redraw();
			
			
			// 당일 일때만, 실시간처리
			if(self.Date != nexUtils.getDate()) return;
			self.requestRTS();
		}
	});
};





this.initChart();
























































//self.initTree();

//트리 데이터 초기화
this.initTree = function() {
	/*
	var treeData = TreeGroupData.slice(0);
	
	for(var i=0;i<treeData.length;i++){
		if(treeData[i].id == "ELW" || treeData[i].id == "GOLD" || treeData[i].id == "LSI"
			|| treeData[i].id == "ETN" || treeData[i].id == "KONEX" || treeData[i].id == "K-OTC") {
			treeData.splice(i,1);
		}
	}
	
	treeData.push({"id":"all", "name":"전종목", "value":{market:["STOCK"], ITM_DV:["00","10","30","40"]}, "child":[]});
	//treeData.push({"id":"subc", "name":"계열사", "value":{market:["STOCK"], ITM_DV:["00","10","30","40"]}, "child":[]});
	
	self.StockTreeObj.treeAllDel();
	self.StockTreeObj.treeDataLoad(treeData);
	
	// 관심그룹 추가
	if(self.InterestGroupData !== undefined && self.InterestGroupData != '') {
		var group_index = 0; // 그룹ID는 1부터
		for(var i=0;i<self.InterestGroupData.length;i++) {
			if(typeof self.InterestGroupData[i].ConcernGroup != "undefined" && self.InterestGroupData[i].ConcernGroup != "") {
				group_index = i+1;
				self.StockTreeObj.treeAdd('iStock', {"id":"iStock_"+group_index, "name":self.InterestGroupData[i].ConcernGroup, "value":null, "child":[]});
			}
		}
	} else {
		self.StockTreeObj.treeAdd('iStock', {"id":"iStock_default", "name":"기본그룹", "value":null, "child":[]});
	}
	
	// 보유종목 추가
	if(self.AccountNumberData !== undefined && self.AccountNumberData != '') {
		for(var i=0;i<self.AccountNumberData.length;i++) {
			var account_nm = self.AccountNumberData[i].AccountNo.substring(0,3)+"-"+self.AccountNumberData[i].AccountNo.substring(3,5)+"-"+self.AccountNumberData[i].AccountNo.substring(5,11)+" ["+self.AccountNumberData[i].g_ac_nm+"]"; 
			self.StockTreeObj.treeAdd('hStock', {"id":"hStock_"+self.AccountNumberData[i].AccountNo, "name":account_nm, "value":null, "child":[]});
		}
	}
	  
	self.StockTreeObj.treeRefresh();
	self.StockTreeObj.treeSelect("all");
	*/
	$.getJSON("/resources/js/chart_lib/data/chartData.json", function(data){
		//console.log("-----CHART DATA LOAD---------");
		//console.log(data);
		self.ChartTreeObj.treeAllDel();
		//self.ChartTreeObj.treeDataLoad(data);
		self.ChartTreeObj.treeRefresh();
		
		// 설정탭 selectmenu option 추가
		// 채널지표
		for(var i=0;i<data[1].child.length;i++){
			var series_id = data[1].child[i].id.split("_")[1];
			var series_name = data[1].child[i].name;
			$("#mdi0560").find("#series_list").append("<option value='"+series_id+"'>"+series_name+"</option>");
		}
		// 보조차트
		for(var i=0;i<data[2].child.length;i++){
			var series_id = data[2].child[i].id.split("_")[1];
			var series_name = data[2].child[i].name;
			if(series_id != "volume"){ // 거래량 제외
				$("#mdi0560").find("#series_list").append("<option value='"+series_id+"'>"+series_name+"</option>");
			}
		}
		
////		$("#mdi0560").find("#series_list").selectmenu("refresh");
////		self.drawSetTab(data[1].child[0].id.split("_")[1]); //첫번째 항목선택
	});
	
};



$(document).ready(function(){
	//$(".depth1").treeview();
	$('.tree_list button').on('click', function(e) {
		var self = $(this);
		if(self.hasClass('on')) {
			self.removeClass('on');
			self.parent().find('ul').slideUp(150);
			self.parent().find('button').removeClass('on');
		} else {
			self.addClass('on');
			self.next('ul').slideDown(150);
		}
		e.preventDefault();
	});
	
	self.ViewName	=	"0560"
	initTree();
});
</script>

</head>
<body class="mdi">
	<div class="wrapper" id="mdi0560">
		<!-- header -->
		<!-- //header -->

		<!-- ííë¦¿ ì¬ì©ë¶ë¶ -->
		<div class="mdi_container">
			<div class="chart">
				<div class="chart_search">
					<div class="input_search">
						<input id="SectorInp" type="text">
						<button type="button" class="btn_recent"><span class="screen_out">recent search</span></button>
						<!-- layer_newest -->
						<div class="layer_newest" style="display:none;">
							<ol>
								<li>value1</li>
								<li>value2</li>
								<li>value3</li>
							</ol>
						</div>
						<!-- //layer_newest -->
						<button type="button">Search</button>
					</div>

					<div class="button_set">
						<input type="radio" id="datetime1" name="datetime" checked="checked"><label for="datetime1"><%= (langCd.equals("en_US") ? "Daily" : "Theo ngày") %></label>
						<input type="radio" id="datetime2" name="datetime"><label for="datetime2"><%= (langCd.equals("en_US") ? "Weekly" : "Theo tuần") %></label>
						<input type="radio" id="datetime3" name="datetime"><label for="datetime3"><%= (langCd.equals("en_US") ? "Monthly" : "Theo tháng") %></label>
						<input type="radio" id="datetime4" name="datetime"><label for="datetime4"><%= (langCd.equals("en_US") ? "Tick" : "Tick") %></label>
					</div>

					<select>
						<option>select</option>
					</select>

					<input type="text" class="datepicker" placeholder="13/05/2016">

					<span class="radio_area">
						<input type="checkbox" id="today" name="today" checked="checked"><label for="today"><%= (langCd.equals("en_US") ? "Today" : "Hôm nay") %></label>
					</span>
					<a href="" class="btn_rescan"><%= (langCd.equals("en_US") ? "Rescan" : "Rescan") %></a>
				</div>
				<!-- LEFT -->
				<div class="wrap_left">
					<!-- tree_menu -->
					<div class="tree_menu">
						<ul class="tree_list">
							<li>
								<button type="button"><%= (langCd.equals("en_US") ? "All stock" : "Tất cả") %></button>
								<ul>
									<li>
										<button type="button">Watch list</button>
										<ul>
											<li>
												<button type="button">Watch list group</button>
												<ul>
													<li>
														<button type="button">Group Item</button>
														<ul>
															<li><a href="#" class="on">HNXIndex</a></li>
															<li><a href="#"> HNX30</a></li>
														</ul>
													</li>
													<li>
														<button type="button">Group Item</button>
														<ul>
															<li><a href="#" class="on">HNXIndex</a></li>
															<li><a href="#"> HNX30</a></li>
														</ul>
													</li>
												</ul>
											</li>
											<li>
												<button type="button">Watch list group</button>
												<ul>
													<li>
														<button type="button">Group Item</button>
														<ul>
															<li><a href="#" class="on">HNXIndex</a></li>
															<li><a href="#"> HNX30</a></li>
														</ul>
													</li>
												</ul>
											</li>
										</ul>
									</li>
									<li>
										<a href="#">My stock</a>
									</li>
									<li>
										<a href="#">Stock exchange</a>
									</li>
								</ul>
							</li>
						</ul>
						<!-- Sector -->
					<div class="sector">
						<h2><%= (langCd.equals("en_US") ? "Sector" : "Danh sách Công ty") %></h2>
						<ul>
						 	<li><span>AAA</span> Anphat Plastic</li>
						 	<li><span>AAA</span> Anphat Plastic</li>
						 	<li><span>AAA</span> Anphat Plastic</li>
						 	<li><span>AAA</span> Anphat Plastic</li>
						 	<li><span>AAA</span> Anphat Plastic</li>
						</ul>
					</div>
					<!-- //Sector -->
					</div>
					<!-- //tree_menu -->
				</div>
				<!-- //LEFT -->
				<!-- RIGHT -->
				<div class="wrap_right">
					<div class="summary">
						<p class="price">49,000</p>
						<p class="state">
							<span class="arrow low">1,400</span>
						</p>
						<p class="val">
							<span class="up">+0.37%</span>
						</p>
						<p class="vol">
							<span class="label">Volume</span>
							411,851
						</p>
						<p class="detail">
							<span class="low">
								<span class="label">Open</span>
								22,950
							</span>
							<span class="up">
								<span class="label">High</span>
								23,445
							</span>
							<span class="low">
								<span class="label">Low</span>
								22,500
							</span>
						</p>
					</div>
					<div class="chart">
						<div style="height:100%; background:#a9a9a9; line-height:700px; font-size:20px; color:#fff; text-align:center; font-weight:700;">chart</div>
					</div>
					
					
					<!-- BUTTON CHK START-->
					<div>
					<span>############################ </span></br>
					<span>#DIV 확인  3                                           # </span></br>
					<span>############################ </span></br>
					
					<!-- 설정 -->
					<div class="chart_set" style="display:block;">
						<div>
							 <select id="series_list"></select>
						</div>
						<ul id="ul_values" class="chart_index_set first"></ul>
						<ul id="ul_colors" class="chart_index_set"></ul>
						<div class="mdi_bottom">
							<button id="btn_set_default" type="button">기본값</button>
							<button id="btn_set_apply" type="button">적용</button>
						</div>
					</div>
					<!-- //설정 -->
					<!-- 선택 -->
					<div class="group_list_box" style="overflow:auto">
						<ul class="treeview" id="tree0560_chart">
							<li>a</li>
							<li>b</li>
							<li>c</li>
						</ul>
					</div>
					<!-- //선택 -->
		
					
					
					
					
					
					
					
					
					
					
					
					
					</div>
					<!-- BUTTON CHK END  -->
					
					
					
					
					
					
					
					
					
					
				</div>
				<!-- //RIGHT -->
			</div>
		</div>
		<!-- //ííë¦¿ ì¬ì©ë¶ë¶ -->
	</div>

<script src="/resources/js/jquery.min.js"></script>
<script src="/resources/js/jquery-ui.min.js"></script>
<script>
(function(){
	function setInitEvt() {
		$('.group_table').each(function() {
			var table = $(this).find('table'),
				tbody = table.find('tbody');

			if(!tbody.find('th').length) {
				tbody.find('tr:odd').addClass('even');
			}

			if(table.height() >= $(this).parent().height()) {
				table.addClass('no_bbt');
			}
		});
		$('div[name=tabs]').tabs();
		$('.datepicker').datepicker({
			showOn:"button",
			changeYear:true,
			changeMonth:true
		});
	}
	window.showFullLoading = function() {
		$('.loading_cover').show();
	}
	window.hideFullLoading = function() {
		$('.loading_cover').hide();
	}

	setInitEvt();
	$(document).ajaxComplete(function() {
		setInitEvt();
	});
}());

//$(".depth2").treeview();

</script>
  </body>
</html>