<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%><!DOCTYPE html><html lang="ko-kr">	<head>		<title>webSocket</title>		<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR" />		<meta http-equiv="Content-Style-Type" content="text/css"/>		<meta http-equiv="Cache-Control" content="no-cache" />		<meta http-equiv="Pragma" content="no-cache" />		<meta http-equiv="Expires" content="-1" />		<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />		<script language="javascript" src="jquery-1.10.2.min.js"></script>		<script language="javascript" src="socket.io.js"></script>		<script language="javascript" src="nexClient_test.js"></script>				<script>			$(document).ready(function () {					if(!nexClient.socketConnection) {					nexClient.webSocketConnect('http://10.0.31.5:8001');				}			});						function rtsNews(){				var gubuns = ['B'];				var vals = [];				vals.push('N0000');				nexClient.rtsReg({					pName	: '1112',	//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )											GUBUNS: gubuns,		//심볼 카테고리 (정의된 연결 키  A, B Q ...)					VALUES: vals		//요청 key value (주식코드,지수 등등..)				});				nexClient.pushNewsOn({					pName	: '1112', 					vName	: 'x501', 					value	: "",					date	: "20160822",					dirf	: "N",					gubn	: "10111111111111",					subg	: "11111111111111111111111110000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",					vend	: "1",					seqn	: "20160822000044652",					desc	: ""				});					}			/*			function rtsNews(){				var gubuns = ['Z'];				var vals = [];				vals.push('N0000');								nexClient.rtsReg({					pName	: '1112',	//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )											GUBUNS: gubuns,		//심볼 카테고리 (정의된 연결 키  A, B Q ...)					VALUES: vals		//요청 key value (주식코드,지수 등등..)				});				nexClient.pushNewsOn({					pName	:	'1112'					, vName	:	'x501'					, symb	:	'DAC         '					, lang	:	'0'				});					}					*/						function rtsConnect(){				console.log("RTS CONNECT-------");				console.log(nexClient);				var gubuns = ['B'];				var vals = [];				vals.push('STK');				nexClient.rtsReg({					pName	: '1112',	//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )											GUBUNS	: gubuns,		//심볼 카테고리 (정의된 연결 키  A, B Q ...)					VALUES	: vals		//요청 key value (주식코드,지수 등등..)				});								nexClient.pushStokOn({					symb	:	'DAC         '					, lang	:	'0'				});												/*				var gubuns = ['B'];				var vals = [];								if($("#stockCode").val() == ''){					alert('주식코드입력해');					return;				}				//vals.push($("#stockCode").val());				vals.push("BTP");				nexClient.rtsReg({					pName	: '1111',	//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )											GUBUNS: gubuns,		//심볼 카테고리 (정의된 연결 키  A, B Q ...)					VALUES: vals		//요청 key value (주식코드,지수 등등..)				});								var symbols = ['002023', //현재가				               '002311', //상한가				               '002024', //전일대비				               '002312', //하한가				               '002033', //등락률				               '002521', //제한폭				               				               '002027', //거래량				              				               ];				nexClient.pushStokOn({					pName	: '1111',		//실시간데이터받을 타겟팅ID (상기 동일)					key		: '001301',		//심볼 카테고리 필드					value	: $("#stockCode").val(),		//요청 key value					symbols	: symbols		//요청 심볼 필드				});				*/			}									function realData_A(data) {				console.log("REALDATA A");				console.log(data);				/*				code: "DLG"				gubn: "A"				value: Object023: "55.28"024: "50.01"027: "2801460"030: "25.33"031: "55.18"032: "2000"033: "50.19"034: "173334"__proto__: Object__proto__: Object				nexClient_test.js:242 [Object]				*/							}									function realData_B(data){				console.log("#$RETURN DATA BBBB$##");				console.log(data);				$("#curr").val(data.value['023']);				$("#diff").val(data.value['027']);								$("#diff1").val(data.value['030']);				$("#diff2").val(data.value['031']);			}						function realData_n(data){				console.log("#$RETURN DATA N$##");				console.log(data);				$("newsHtml").html(JSON.toStringify(data));			}									function realData_X(data){				console.log("#$RETURN DATA XXXX$##");				console.log(data);			}						function realData_Z(data){				console.log("#$RETURN DATA ZZZZ$##");				console.log(data);			}									/*			Object			code:"DLG"			gubn:"A"			value:Object			023:"55.36"			024:"50.03"			027:"3109700"			030:"35.39"			031:"55.20"			032:"3400"			033:"50.56"			034:"151243"			*/			function pibocurrRTS_STOK_TP() {				console.log("RTS NEWS TYPE CONNECT-------");				console.log(nexClient);				var gubuns = ['A'];				var vals = [];				vals.push("DLG");								nexClient.rtsReg({					pName	:	'1111',		//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )											GUBUNS	:	gubuns,		//심볼 카테고리 (정의된 연결 키  A, B Q ...)					VALUES	: 	vals		//요청 key value (주식코드,지수 등등..)				});				nexClient.pushCurrOn({					pName	: '1111',	//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )					symb	:	'DLG         '					, lang	:	'0'				});			}												function pibocurrRTS_NEWS_TP() {				console.log("RTS NEWS TYPE CONNECT-------");				console.log(nexClient);								var gubuns = ['Z'];				var vals = [];				vals.push("HAG");								var symbols = ['002023'];								nexClient.rtsReg({					pName	:	'1111',		//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )											GUBUNS	:	gubuns,		//심볼 카테고리 (정의된 연결 키  A, B Q ...)					VALUES	:	vals		//요청 key value (주식코드,지수 등등..)				});								nexClient.pushTprcOn({					pName	: 	'1111'	//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )					//, vName	:	'TP'					, symb	:	'HAG         '					, lang	:	'0'					, xWin	:	'T'					, yWin	:	'P'					, symbols	: symbols		//요청 심볼 필드				});			}						function myStock() {				var gubuns = ['A'];				var vals = [];				vals.push("077C080169");				var symbols = ['077C080169'];				console.log("____MY STOCK____");				nexClient.rtsReg({					pName	: '1111',		//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )											GUBUNS	: gubuns,		//심볼 카테고리 (정의된 연결 키  A, B Q ...)					VALUES	: vals			//요청 key value (주식코드,지수 등등..)				});								nexClient.pushMystOn({					pName	: 	'1111'	//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )					//, vName	:	'MY'					, usid	:	'077C080169      '					, grpn	:	'1 '					, lang	:	'1'					, symbols	: symbols		//요청 심볼 필드					, receive	:	function(data) {							console.log("-----------DATA---------");							console.log(data);					}				});			}																		function regRtsStock(symb) {				var vals = [];				vals.push(symb);				var gubuns = ['A'];				nexClient.rtsReg({					pName	:	'BID',		//	실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )											GUBUNS	:	gubuns,		//	심볼 카테고리 (정의된 연결 키  A, B Q ...)					VALUES	: 	vals		//	요청 key value (주식코드,지수 등등..)				});				gubuns = ['B'];				nexClient.rtsReg({					pName	:	'BIDTP',		//	실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )											GUBUNS	:	gubuns,		//	심볼 카테고리 (정의된 연결 키  A, B Q ...)					VALUES	:	vals		//	요청 key value (주식코드,지수 등등..)				});				nexClient.pushCurrOn({					pName	: 'BID',		//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )					symb	:	symb ,					lang	:	"1",					symbols	: 	vals		//요청 심볼 필드				});				nexClient.pushTprcOn({					pName	:	'BIDTP',	//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )					symb	:	symb,					lang	:	'0',					symbols	: 	vals		//요청 심볼 필드				});			}						function rtsALL() {				console.log("CALL RTS ALL");				rcod	=	[];				rcod.push('ACB');				rcod.push('DHA');				rcod.push('DHC');				rcod.push('HAG');				rcod.push('HAH');				rcod.push('HCC');				rcod.push('VCA');				rcod.push('ROS');				rcod.push('GEX');				rcod.push('FLC');				rcod.push('ITA');				rcod.push('VNM');				rcod.push('DTA');				rcod.push('EMC');				rcod.push('CVT');				rcod.push('KHA');				rcod.push('TIX');								console.log(rcod.size);				console.log(rcod.length);				for(var i = 0; i < rcod.length; i++) {					console.log("CODE==>"  + rcod[i]);					regRtsStock(rcod[i]);				}			}								</script>	</head>	<body>		현재가 <input type="text" id="curr"><br>	거래량 <input type="text" id="diff"><br>	상한가 <input type="text" id="diff1"><br>	하한가 <input type="text" id="diff2"><br>			뉴스 <input type="text" id="newsHtml"><br>		<input type="button" id="Connectaa" value="관심종목" onclick="myStock();">		<input type="button" id="Connect" value="Connect" onclick="rtsConnect();">	<input type="button" id="disconect" value="disconnect">	<input type="button" id="news" value="news">			<input type="button" id="Connect2" value="STOK_TP" onclick="pibocurrRTS_STOK_TP();">	<input type="button" id="Connect3" value="TPRC" onclick="pibocurrRTS_NEWS_TP();">					<input type="button" id="Connect3" value="ALL" onclick="rtsALL();">	주식코드 : <input type="text" id="stockCode" value="037620">	<!-- 현재 타겟팅 : <div id="nowTargeting"></div> -->	</body></html>