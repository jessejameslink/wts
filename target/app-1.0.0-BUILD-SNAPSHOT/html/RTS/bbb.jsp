<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%><!DOCTYPE html><html lang="ko-kr">	<head>		<title>webSocket</title>		<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR" />		<meta http-equiv="Content-Style-Type" content="text/css"/>		<meta http-equiv="Cache-Control" content="no-cache" />		<meta http-equiv="Pragma" content="no-cache" />		<meta http-equiv="Expires" content="-1" />		<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />		<script language="javascript" src="jquery-1.10.2.min.js"></script>		<script type="text/javascript" src="/resources/js/function_comm.js?600"></script>				<script type="text/javascript" src="/resources/js/nexClient.js"></script>		<script type="text/javascript" src="/resources/js/socket.io.js"></script>								<script>			$(document).ready(function () {									if(!nexClient.socketConnection) {					nexClient.webSocketConnect('http://10.0.31.5:8001');				}				homeJisu();			});						function hidx() {				var vals = [];				vals.push(" ");				var gubuns = ['I'];				nexClient.rtsReg({					pName	:	'IDX',		//	실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )											GUBUNS	:	gubuns,		//	심볼 카테고리 (정의된 연결 키  A, B Q ...)					VALUES	: 	vals		//	요청 key value (주식코드,지수 등등..)				});								nexClient.pushIndxOn({					dumy	:	' ',					pName	: 'IDX',		//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )					symbols	: 	vals		//요청 심볼 필드				});											}									function realData_I(data) {				console.log("@@@@  REAL DATA I CALL");				console.log(data);			}												function homeJisu() {				$.ajax({					url      : "/home/homeJisu.do",					dataType : "json",					success  : function(data){						console.log("HOME JISU");						console.log(data);					},					error     :function(e) {						console.log(e);					}				});			}		</script>	</head>	<body>			<input type="button" id="Connectaa" value="주가지수" onclick="hidx();">	</body></html>