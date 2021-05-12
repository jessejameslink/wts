<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%><!DOCTYPE html><html lang="ko-kr">	<head>		<title>webSocket</title>		<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR" />		<meta http-equiv="Content-Style-Type" content="text/css"/>		<meta http-equiv="Cache-Control" content="no-cache" />		<meta http-equiv="Pragma" content="no-cache" />		<meta http-equiv="Expires" content="-1" />		<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />		<script language="javascript" src="jquery-1.10.2.min.js"></script>		<script language="javascript" src="socket.io.js"></script>		<script language="javascript" src="nexClient_test.js"></script>		<script>			var MasterCode=null;			$(document).ready(function () {												//소캣연결				nexClient.webSocketConnect();								//주식연결				$("#Connect").click(function(){					rtsConnect();				});								//시황연결				$("#news").click(function(){					rtsNews();				});								//연결중지				$("#disconect").click(function(){					nexClient.pushViewOff('1111','MAS');				});							});						function rtsNews(){								var gubuns = ['n'];				var vals = [];				vals.push('N0000');								nexClient.rtsReg({					pName	: '1112',	//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )											GUBUNS: gubuns,		//심볼 카테고리 (정의된 연결 키  A, B Q ...)					VALUES: vals		//요청 key value (주식코드,지수 등등..)				});								nexClient.pushNewsOn({					pName	: '1112', 					vName	: 'x501', 					value	: "",					date	: "20160822",					dirf	: "N",					gubn	: "10111111111111",					subg	: "11111111111111111111111110000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",					vend	: "1",					seqn	: "20160822000044652",					desc	: ""				});									}											function rtsConnect(){				var gubuns = ['B'];				var vals = [];								if($("#stockCode").val() == ''){					alert('주식코드입력해');					return;				}				vals.push($("#stockCode").val());								nexClient.rtsReg({					pName	: '1111',	//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )											GUBUNS: gubuns,		//심볼 카테고리 (정의된 연결 키  A, B Q ...)					VALUES: vals		//요청 key value (주식코드,지수 등등..)				});								var symbols = ['002023', //현재가				               '002311', //상한가				               '002024', //전일대비				               '002312', //하한가				               '002033', //등락률				               '002521', //제한폭				               				               '002027', //거래량				              				               ];				nexClient.pushStokOn({					pName	: '1111',		//실시간데이터받을 타겟팅ID (상기 동일)					key		: '001301',		//심볼 카테고리 필드					value	: $("#stockCode").val(),		//요청 key value					symbols	: symbols		//요청 심볼 필드				});						}									function realData_B(data){				console.log("REAL DATA B");				console.log(data);				$("#curr").val(data.value['023']);				$("#diff").val(data.value['027']);								$("#diff1").val(data.value['030']);				$("#diff2").val(data.value['031']);			}						function realData_n(data){				console.log("REAL DATA N");				console.log(data);				$("newsHtml").html(JSON.toStringify(data));			}		</script>	</head>	<body>		현재가 <input type="text" id="curr"><br>	거래량 <input type="text" id="diff"><br>	상한가 <input type="text" id="diff1"><br>	하한가 <input type="text" id="diff2"><br>			뉴스 <input type="text" id="newsHtml"><br>		<input type="button" id="Connect" value="Connect">	<input type="button" id="disconect" value="disconnect">	<input type="button" id="news" value="news">	주식코드 : <input type="text" id="stockCode" value="037620">	<!-- 현재 타겟팅 : <div id="nowTargeting"></div> -->	<div id="mdi0560" class="wrap_mdi mdi_body" style="width:880px;">	<div class="state_area" id="stateBar_0560"></div>  	<div class="mdi_container">		<!-- 조회 -->		<div class="mdi_search">			<form action="#" method="" role="form">				<fieldset>					<legend class="screen_out"></legend>					<div class="search_box">						<button id="treehandle" class="handle" type="button">접기</button>						<div class="search_area">							<label for="search_num" class="screen_out" >화면번호 검색</label>							<input type="text" name="refCode" class="search_num" value="" id="search_num">							<button type="button" class="btn_recent"><span class="screen_out">최근조회 목록 보기</span></button>							<button type="button" class="btn_search" name="refcode_search"><span class="screen_out">검색하기</span></button>							<button type="button" class="btn_info" name="corpo_info"><span class="screen_out">기업정보</span></button>							<input name="refName" class="search_input" type="text" value="" title="종목" readonly><!-- 2016-3-21 추가 -->						</div>													<div id="dateTimeDiv" name="radioset" class="radio_area type2">							<input type="radio" id="0560dateTime1" name="0560datetime" checked="checked">							<label for="0560dateTime1">일</label>														<input type="radio" id="0560dateTime2" name="0560datetime" >							<label for="0560dateTime2">주</label>														<input type="radio" id="0560dateTime3" name="0560datetime" >							<label for="0560dateTime3">월</label>														<input type="radio" id="0560dateTime4" name="0560datetime" >							<label for="0560dateTime4">분</label>							<input type="radio" id="0560dateTime5" name="0560datetime" >							<label for="0560dateTime5">년</label>						</div>						<div id="dateMinDiv" name="radioset" class="radio_area type2 ">							<input type="radio" id="0560dateMin5" name="0560dateMin" checked="checked">							<label for="0560dateMin5">1</label>														<input type="radio" id="0560dateMin6" name="0560dateMin">							<label for="0560dateMin6">3</label>														<input type="radio" id="0560dateMin7" name="0560dateMin">							<label for="0560dateMin7">5</label>														<input type="radio" id="0560dateMin8" name="0560dateMin">							<label for="0560dateMin8">10</label>							<input type="radio" id="0560dateMin9" name="0560dateMin">							<label for="0560dateMin9">30</label>							<input type="radio" id="0560dateMin10" name="0560dateMin">							<label for="0560dateMin10">60</label>						</div>						<!-- <div class="num_updown">							<input class="text" type="text" value="0" title="단가입력">							<div class="btn">								<input type="button" title="올림">								<input type="button" title="내림">							</div>						</div> -->						<div class="pull_left text_date">							<div class="datepicker_area">								<label for="datepicker_0560" class="screen_out">날짜선택</label>								<input type="text" class="datepicker" id="datepicker_0560" readonly="readonly">							</div>						</div>						<div class="radio_area margin_front">							<label><input type="checkbox" id="todaychk" name="todaychk">당일</label>						</div>					</div>					<div class="pull_right">						<button type="button" class="btn_search" onclick="nexMdi.getCtl('0560').search();">조회</button>					</div>				</fieldset>			</form>		</div>		<!-- //조회 -->				<!-- 기업정보 테이블 -->		<div class="group_table row">			<table class="table">				<caption></caption>				<colgroup>					<col width="155" />					<col />					<col width="4%" />					<col width="8%" />					<col width="4%" />					<col width="8%" />					<col width="4%" />					<col width="8%" />					<col width="8%" />					<col width="8%" />				</colgroup>				<tbody>					<tr>						<th><span fid="F,,001022,022"></span> <button type="button" onclick="nexMdi.open({viewName:'0512'});">기업정보</button></th>						<td class="group_list">							<span fid="F,,001023,023" func="nexFmt.sign"></span>							<span fid="F,,001024,024" func="nexFmt.sign5_1"></span>							<span fid="F,,001033,033" func="nexFmt.pSign"></span>							<span class="last-list" fid="F,,001027,027" fmt="number"></span>						</td>						<th>시</th>						<td><span fid="F,,001029,029" func="nexFmt.sign"></span></td>						<th>고</th>						<td><span fid="F,,001030,030" func="nexFmt.sign"></span></td>						<th>저</th>						<td><span fid="F,,001031,031" func="nexFmt.sign"></span></td>						<th>체결강도</th>						<td><span fid="F,,001387,387" func="nexFmt.sign"></span></td>					</tr>				</tbody>			</table>		</div>		<!-- //기업정보 테이블 -->				<div class="cont_area">			<div class="aside">				<div name="tabs">					<ul class="nav nav_tabs" role="tablist">						<li role="tab" class="active"><a href="#tab1" aria-controls="tab1" role="tab" data-toggle="tab">종목</a></li>						<li role="tab"><a href="#tab2" aria-controls="tab2" role="tab" data-toggle="tab">지표</a></li>					</ul>					<div class="tab_content">						<div role="tabpanel" class="" id="tab1">							<!-- 종목 -->							<h5 class="screen_out">종목선택</h5>							<div class="group_tree_box" style="overflow:auto">								<ul id="tree0560_stock"></ul>							</div>							<h5 class="screen_out">종목선택</h5>							<div class="grid_area group_tree_box">								<div id="grid0560_0560"></div>							</div>							<!-- //종목 -->						</div>						<div role="tabpanel" class="" id="tab2">							<!-- 지표 -->							<div class="btn_group">								<ul>									<li id="tab2_tab1" class="active"><button type="button">선택</button></li>									<li id="tab2_tab2" ><button type="button">설정</button></li>								</ul>							</div>							<div class="sub_tab">								<!-- 선택 -->								<div class="group_list_box" style="overflow:auto">									<ul class="treeview" id="tree0560_chart">									</ul>								</div>								<!-- //선택 -->																<!-- 설정 -->								<div class="chart_set" style="display:none;">									<div>										 <select id="series_list"></select>									</div>									<ul id="ul_values" class="chart_index_set first"></ul>									<ul id="ul_colors" class="chart_index_set"></ul>									<div class="mdi_bottom">										<button id="btn_set_default" type="button">기본값</button>										<button id="btn_set_apply" type="button">적용</button>									</div>								</div>								<!-- //설정 -->							</div>							<!-- //지표 -->						</div>					</div>				</div>			</div>			<div class="cont_chart" id="chart0560_0560" style="overflow:hidden;margin-left:159px">			</div>		</div>	</div></div>	</body></html>