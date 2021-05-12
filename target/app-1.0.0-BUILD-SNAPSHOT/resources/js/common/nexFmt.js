(function(window, $, undefined) {
	var nexFmt = function(){
	};

	nexFmt.prototype = {
		amt313:0,
		number: function(selector, key, rows, value) {
			var val = value.trim();
			val = Number(val);
			return val;
		},
		sign : function(selector, key, rows, value) {
			value=String(value).trim();
			var gbn=value.substring(0,1);
			selector.removeClass('up low');
			//selector.removeClass('low');
			if(gbn=='+') {
				value=value.substring(1);
				value=value.commify();
				selector.addClass('up');
			} else if(gbn=='-') {
				value=value.substring(1);
				value=value.commify();
				selector.addClass('low');
			} else {
				value=value.commify();
			}

			if(value=='0') {
				value='\u00A0';
			}

			return value;
		},
		hogaSign : function(selector, key, rows, value, $selector_list) {
			value=value.trim();
			var gbn=value.substring(0,1);
			selector.removeClass('up low i_box p j g s');
			//selector.removeClass('low');
			//selector.removeClass('i_box p'); //시가=고가 or 시가=저가 or 고가=저가 or 시가=고가=저가
			//selector.removeClass('i_box j'); //시가
			//selector.removeClass('i_box g'); //고가
			//selector.removeClass('i_box s'); //저가
			//selector.removeClass('sel_box'); //호가=현재가 인 경우
			if(gbn=='+') {
				value=value.substring(1);
				value=value.commify();
				selector.addClass('up');
			} else if(gbn=='-') {
				value=value.substring(1);
				value=value.commify();
				selector.addClass('low');
			} else {
				value=value.commify();
			}

			if(value=='0' || value=='') {
				value='\u00A0';
			}

			if(value!='\u00A0' && value!=''){ //'029':시가, '030':고가, '031':저가
				var real=$selector_list.real;
				var data_029=real['029'][0].selector.text();
				var data_030=real['030'][0].selector.text();
				var data_031=real['031'][0].selector.text();
				//시고저 아이콘 표시
				if(value == data_029 && data_029 == data_031) { //호가=시가=저가
					selector.addClass('i_box p');
					//value='+ '+value;
				} else if(value == data_029 && data_029 == data_030) { //호가=시가=고가
					selector.addClass('i_box p');
					//value='- '+value;
				} else if(value == data_030 && data_030 == data_031) { //호가=고가=저가
					selector.addClass('i_box p');
					//value='- '+value;
				} else if(value == data_029 && data_029 == data_030 && data_030 == data_031) { //호가=시가=고가=저가
					selector.addClass('i_box p');
					//value='- '+value;
				} else if(value == data_029) {
					selector.addClass('i_box j');
					//value='시 '+value;
				} else if(value == data_030) {
					selector.addClass('i_box g');
					//value='고 '+value;
				} else if(value == data_031) {
					selector.addClass('i_box s');
					//value='저 '+value;
				}

				//현재가(023)와 같을 경우 호가판에 빨간색 or 파란색 or 검은색 박스 표시
				//if(value==real['023'][0].selector.text()){
				//	selector.addClass('sel_box');
					value = value + '<div></div>';
				//}

			}//29,30,31

			return {type:'html', value:value};
		},
		hogaSign2 : function(selector, key, rows, value, $selector_list) { //[0142] 시간외단일가 현재가용
			value=value.trim();
			var gbn=value.substring(0,1);
			selector.removeClass('up low i_box p j g s');
			//selector.removeClass('low');
			//selector.removeClass('i_box p'); //시가=고가=저가
			//selector.removeClass('i_box j'); //시가
			//selector.removeClass('i_box g'); //고가
			//selector.removeClass('i_box s'); //저가
			//selector.removeClass('sel_box'); //호가=현재가 인 경우
			if(gbn=='+') {
				value=value.substring(1);
				value=value.commify();
				selector.addClass('up');
			} else if(gbn=='-') {
				value=value.substring(1);
				value=value.commify();
				selector.addClass('low');
			} else {
				value=value.commify();
			}

			if(value=='0') {
				value='\u00A0';
			}
			//[0142] 시간외단일가 현재가에서는 미사용
			/*
			if(value!='\u00A0'&& value!=''){
				if(value==$selector_list.real['729'][0].selector.text() && $selector_list.real['729'][0].selector.text() == $selector_list.real['731'][0].selector.text()) {
					//selector.addClass('i_box p');
					//value='+ '+value;
				} else if(value==$selector_list.real['729'][0].selector.text() && $selector_list.real['729'][0].selector.text() == $selector_list.real['730'][0].selector.text()) {
					//selector.addClass('i_box p');
					//value='- '+value;
				} else if(value==$selector_list.real['729'][0].selector.text()) {
					//selector.addClass('i_box j');
					//value='시 '+value;
				} else if(value==$selector_list.real['730'][0].selector.text()) {
					//selector.addClass('i_box g');
					//value='고 '+value;
				} else if(value==$selector_list.real['731'][0].selector.text()) {
					//selector.addClass('i_box s');
					//value='저 '+value;
				}
			}
			*/

			if(value!='\u00A0' && value!=''){
				//var real=$selector_list.real;
				//현재가(723)와 같을 경우 호가판에 빨간색 or 파란색 or 검은색 박스 표시
				//if(value==real['723'][0].selector.text()){
					//selector.addClass('sel_box');
					value = value + '<div></div>';
				//}
			}

			return {type:'html', value:value};
		},
		hogaSign3 : function(selector, key, rows, value, $selector_list) {
			value=value.trim();
			var gbn=value.substring(0,1);
			selector.removeClass('up low sel_box');
			//selector.removeClass('low');
			//selector.removeClass('sel_box'); //호가=현재가 인 경우
			if(gbn=='+') {
				value=value.substring(1);
				value=value.commify();
				selector.addClass('up');
			} else if(gbn=='-') {
				value=value.substring(1);
				value=value.commify();
				selector.addClass('low');
			} else {
				value=value.commify();
			}

			if(value=='0') {
				value='\u00A0';
			}

			if(value!='\u00A0' && value!=''){ //'029':시가, '030':고가, '031':저가

				//현재가(023)와 같을 경우 호가판에 빨간색 or 파란색 박스 표시
				if(value==$selector_list.real['023'][0].selector.text()){
					selector.addClass('sel_box');
					value = value + '<div></div>';
				}

			}//29,30,31

			return {type:'html', value:value};
		},
		hogaSign4 : function(selector, key, rows, value, $selector_list) {//시간외 단일가 주문
			value=value.trim();
			var gbn=value.substring(0,1);
			selector.removeClass('up low sel_box');
			//selector.removeClass('low');
			//selector.removeClass('sel_box'); //호가=현재가 인 경우
			if(gbn=='+') {
				value=value.substring(1);
				value=value.commify();
				selector.addClass('up');
			} else if(gbn=='-') {
				value=value.substring(1);
				value=value.commify();
				selector.addClass('low');
			} else {
				value=value.commify();
			}

			if(value=='0') {
				value='\u00A0';
			}

			if(value!='\u00A0' && value!=''){ //'029':시가, '030':고가, '031':저가
				//현재가(023)와 같을 경우 호가판에 빨간색 or 파란색 박스 표시
				if(value==$selector_list.real['723'][0].selector.text()){
					selector.addClass('sel_box');
					value = value + '<div></div>';
				}
			}//29,30,31

			return {type:'html', value:value};
		},
		hogaSign5 : function(selector, key, rows, value, $selector_list) { // [0302] 선물옵션 현재가용
			value=value.trim();
			var gbn=value.substring(0,1);
			selector.removeClass('up low i_box p j g s');
			//selector.removeClass('low');
			//selector.removeClass('i_box p'); //시가=고가 or 시가=저가 or 고가=저가 or 시가=고가=저가
			//selector.removeClass('i_box j'); //시가
			//selector.removeClass('i_box g'); //고가
			//selector.removeClass('i_box s'); //저가
			//selector.removeClass('sel_box'); //호가=현재가 인 경우
			if(gbn=='+') {
				value=value.substring(1);
				value=value.commify();
				selector.addClass('up');
			} else if(gbn=='-') {
				value=value.substring(1);
				value=value.commify();
				selector.addClass('low');
			} else {
				value=value.commify();
			}

			if(value=='0' || value=='') {
				value='\u00A0';
			}

			//현재가(023)와 같을 경우 호가판에 빨간색 or 파란색 or 검은색 박스 표시
			//if(value==real['023'][0].selector.text()){
			//	selector.addClass('sel_box');
				value = value + '<div></div>';
			//}

			return {type:'html', value:value};
		},
		//잔량 표시
		residual : function(selector, key, rows, value, $selector_list) {
			value=String(value).trim();
			var gbn=value.substring(0,1);
			selector.removeClass('up low');
			//selector.removeClass('low');
			if(gbn=='+') {
				value=value.substring(1);
				value=value.commify();
				selector.addClass('up');
			} else if(gbn=='-') {
				value=value.substring(1);
				value=value.commify();
				selector.addClass('low');
			} else {
				value=value.commify();
			}

			if(value=='0') {
				value='\u00A0';
			}

			//console.log('key : ' + key + ', selector : ' + JSON.stringify(selector));

			if(value!='\u00A0' && value!=''){
				//var real=$selector_list.real;
				/*var real=$selector_list.oop;

				//잔량(매도, 매수) 중 최대값을 구한다.
				var data_max=0;
				var key = '';
				var data_tmp='';
				for (var i=1; i<=10; i++) {
					var key = '0040' + (40 + i);
					var data_tmp=real[key][0].selector.text().replace(",","");
					console.log('key : ' + key + ', data_tmp : ' + data_tmp + ', number : ' + Number(data_tmp));
					if (Number(data_tmp) > data_max) {
						data_max = Number(data_tmp);
					}
				}
				console.log('data_max : ' + data_max);*/

				value = value + '<div id="res_' + key + '" style="width:0%;"></div>';
			}

			return {type:'html', value:value};
		},			
		sign2 : function(selector, key, rows, value) {
			value=value.trim();
			var gbn=value.substring(0,1);
			selector.removeClass('up low');
			//selector.removeClass('low');
			if(gbn=='+') {
				value=value.substring(1);
				value='+'+value.commify();
				selector.addClass('up');
			} else if(gbn=='-') {
				value=value.substring(1);
				value='-'+value.commify();
				selector.addClass('low');
			} else {
				value=value.commify();
			}

			if(value=='0') {
				value='\u00A0';
			}

			return value;
		},
		// [0101] 현재가 우측중간 외국계추정합에서 괄호 색상 표시 추가(2016년 4월 18일 정상헌 추가)
		sign2_1 : function(selector, key, rows, value) {
			value=value.trim();
			var gbn=value.substring(0,1);
			selector.removeClass('up low');
			//selector.removeClass('low');
			if(gbn=='+') {
				value=value.substring(1);
				value='(+'+value.commify()+")";
				selector.addClass('up');
			} else if(gbn=='-') {
				value=value.substring(1);
				value='(-'+value.commify()+")";
				selector.addClass('low');
			} else {
				value=value.commify();
			}

			if(value=='0') {
				value='\u00A0';
			}

			return value;
		},
		// [0302] 선물옵션 현재가에서 대비 데이터(+0)값 처리(2016년 4월 27일 정상헌 추가)
		sign2_2 : function(selector, key, rows, value) {
			value=value.trim();
			var gbn=value.substring(0,1);
			selector.removeClass('up low');
			//selector.removeClass('low');
			if(gbn=='+') {
				value=value.substring(1);
				value='+'+value.commify();
				selector.addClass('up');
			} else if(gbn=='-') {
				value=value.substring(1);
				value='-'+value.commify();
				selector.addClass('low');
			} else {
				value=value.commify();
			}

			if(value=='+0' || value=='0') {
				value='\u00A0';
			}

			return value;
		},
		// 0일 때, 빈값이 아닌 0 표시하도록
		sign2_3 : function(selector, key, rows, value) {
			value=value.trim();
			var gbn=value.substring(0,1);
			selector.removeClass('up low');
			//selector.removeClass('low');
			if(gbn=='+') {
				value=value.substring(1);
				value='+'+value.commify();
				selector.addClass('up');
			} else if(gbn=='-') {
				value=value.substring(1);
				value='-'+value.commify();
				selector.addClass('low');
			} else {
				value=value.commify();
			}
			return value;
		},
		sign3 : function(selector, key, rows, value) {
			value=value.trim();
			var gbn=value.substring(0,1);
			selector.removeClass('up low arrow');
			//selector.removeClass('low');
			//selector.removeClass('arrow');
			selector.addClass('arrow');
			if(gbn=='+') {
				value=value.substring(1);
				value=value.commify();
				if(value!='0')
					selector.addClass('up');
			} else if(gbn=='-') {
				value=value.substring(1);
				value=value.commify();
				selector.addClass('low');
			} else {
				selector.removeClass('arrow');
				value=value.commify();
			}

			return value;
		},
		sign4 : function(selector, key, rows, value) {
			selector.removeClass('up low');
			//selector.removeClass('low');
			var selector_next=selector.next();
			selector_next.removeClass('up low');
			//selector.next().removeClass('low');
			value=value.trim();
			var gbn=value.substring(0,1);
			if(gbn=='+') {
				value=value.substring(1);
				value=value.commify();
				selector.addClass('up');
				selector_next.addClass('up');
			} else if(gbn=='-') {
				value=value.substring(1);
				value=value.commify();
				selector.addClass('low');
				selector_next.addClass('low');
			} else {
				value=value.commify();
			}

			if(value=='0') {
				value='\u00A0';
			}

			return value;
		},
		sign5 : function(selector, key, rows, value) {
			var gbn=value.substring(0,1);
			value=value.trim().substring(1);
			selector.removeClass('up low upper lower arrow');
			//selector.removeClass('low');
			//selector.removeClass('upper');
			//selector.removeClass('lower');
			//selector.removeClass('arrow');
			selector.addClass('arrow');

			if(gbn=='1') {
				value=value.commify();
				selector.addClass('upper');
			} else if(gbn=='2') {
				value=value.commify();
				selector.addClass('up');
			} else if(gbn=='4') {
				value=value.commify();
				selector.addClass('lower');
			} else if(gbn=='5') {
				value=value.commify();
				selector.addClass('low');
			} else {
				value=value.commify();
				selector.removeClass('arrow');
			}

			if(value=='') {
				value='0';
			}

			return value;
		},
		// [0100] 주식종합에서 사용
		sign5_1 : function(selector, key, rows, value) {
			var gbn=value.substring(0,1);
			value=value.trim().substring(1);
			selector.removeClass('up low upper lower bg_arrow');
			//selector.removeClass('low');
			//selector.removeClass('upper');
			//selector.removeClass('lower');
			//selector.removeClass('bg_arrow');
			selector.addClass('bg_arrow');

			if(gbn=='1') {
				value=value.commify();
				selector.addClass('upper');
			} else if(gbn=='2') {
				value=value.commify();
				selector.addClass('up');
			} else if(gbn=='4') {
				value=value.commify();
				selector.addClass('lower');
			} else if(gbn=='5') {
				value=value.commify();
				selector.addClass('low');
			} else {
				value=value.commify();
				selector.removeClass('bg_arrow');
			}

			if(value=='') {
				value='0';
			}

			return value;
		},
		// 기호(+,-)로 화살표 표시(2016년 4월 27일 정상헌 추가)
		sign5_2 : function(selector, key, rows, value) {
			var gbn=value.substring(0,1);
			value=value.trim().substring(1);
			selector.removeClass('up low upper lower arrow');
			selector.addClass('arrow');

			if(gbn=='+') {
				value=value.commify();
				selector.addClass('up');
			} else if(gbn=='-') {
				value=value.commify();
				selector.addClass('low');
			} else {
				value=value.commify();
				selector.removeClass('arrow');
			}

			if(value=='') {
				value='0';
			}

			return value;
		},
		//TR과 실시간의 포맷이 다른 경우
		sign5_3 : function(selector, key, rows, value) {
			var gbn=value.substring(0,1);
			value=value.trim().substring(1);
			selector.removeClass('up low upper lower arrow');
			selector.addClass('arrow');

			if(gbn=='+') {
				value=value.commify();
				selector.addClass('up');
			} else if(gbn=='-') {
				value=value.commify();
				selector.addClass('low');
			} else if(gbn=='1') {
				value=value.commify();
				selector.addClass('upper');
			} else if(gbn=='2') {
				value=value.commify();
				selector.addClass('up');
			} else if(gbn=='4') {
				value=value.commify();
				selector.addClass('lower');
			} else if(gbn=='5') {
				value=value.commify();
				selector.addClass('low');
			} else {
				value=value.commify();
				selector.removeClass('arrow');
			}

			if(value=='') {
				value='0';
			}

			return value;
		},			
		sign6 : function(selector, key, rows, value) {
			var gbn=value.trim().substring(0,1);
			selector.removeClass('up low');
			//selector.removeClass('low');
			if(gbn=='1' || gbn=='2' || gbn=="+") {
				value=value.trim().substring(1);
				value=value.commify();
				selector.addClass('up');
			} else if(gbn=='4' || gbn=='5' || gbn=="-") {
				value=value.trim().substring(1);
				value=value.commify();
				selector.addClass('low');
			} else {
				value=value.commify();
			}

			if(value=='0') {
				value='\u00A0';
			}

			return value;
		},			
		getDate : function(date){
			var text=[];
			text[0]=date.substring(0, 4);
			text[1]=date.substring(4, 6);
			text[2]=date.substring(6, 8);
			//date = date.substring(0, 4) + '/' + date.substring(4, 6) + '/' + date.substring(6, 8);
			//date = text.join('/');

			return text.join('/');
			//return date;
		},
		//콤마사용
		signNum:function(selector, key, rows, value) {
			return nexUtils.numberWithCommas(value);
		},
		//콤마사용
		signNum1:function(selector, key, rows, value) {
			//console.log(value);
			value = Math.floor(value);
			return nexUtils.numberWithCommas(value);
		},
		//음수양수 글자색 적용, 콤마사용
		signNum2:function(selector, key, rows, value) {
			var gbn=value.trim().substring(0,1);
			var className='';
			//selector.removeClass('low').removeClass('up');
			selector.removeClass('low up');
			if(gbn=='-') {
				selector.addClass('low');
			}else if(Number(value) > 0){
				selector.addClass('up');
			}
			return nexUtils.numberWithCommas(value);
		},
		// [0300] 선물옵션 종합에서 종목탭 음수양수 글자색 적용, 콤마사용, % 추가
		signNum2_1:function(selector, key, rows, value) {
			var gbn=value.trim().substring(0,1);
			var className='';
			//selector.removeClass('low').removeClass('up');
			selector.removeClass('low up');
			if(gbn=='-') {
				selector.addClass('low');
			}else if(Number(value) > 0){
				selector.addClass('up');
			}

			value = nexUtils.numberWithCommas(value) + '%';
			return value;
		},		
		//음수양수 글자색 적용, 콤마사용, +,- 표현
		signNum2_2:function(selector, key, rows, value) {
			var gbn=value.trim().substring(0,1);
			var className='';
			//selector.removeClass('low').removeClass('up');
			selector.removeClass('low up');
			if(gbn=='-') {
				selector.addClass('low');
			}else if(Number(value) > 0){
				selector.addClass('up');
			}
			var resultVal = nexUtils.numberWithCommas(value);
			 if(Number(value) > 0){
				resultVal = '+'+resultVal;
			}
			return resultVal;
		},
		signNum3:function(selector, key, rows, value) { //음수양수 글자색 적용, 콤마사용, 숫자단위 : 2, -0허용
			var gbn=value.trim().substring(0,1);
			var className='';

			//selector.removeClass('low').removeClass('up');
			selector.removeClass('low up');
			if(gbn=='-') {
				selector.addClass('low');
			}else if(Number(value) > 0){
				selector.addClass('up');
			}

			//숫자단위 변환
			var divide = 2; //숫자단위
			value = value / Math.pow(10,divide);
			if(gbn=='-' && value == 0) {
				value = '-'+value;
			}

			//콤마사용
			var sosu = 2;
			value = nexUtils.numberFormat(value, sosu); //numberFormat:function(num, cipher) numberFormat("12345.12",3) -> 12345.120

			return value;
		},
		signNum3_2:function(selector, key, rows, value) { //콤마사용, 숫자단위 : 2,
			var gbn=value.trim().substring(0,1);
			//숫자단위 변환
			var divide = 2; //숫자단위
			value = value / Math.pow(10,divide);

			//콤마사용
			var sosu = 2;
			value = nexUtils.numberFormat(value, sosu); //numberFormat:function(num, cipher) numberFormat("12345.12",3) -> 12345.120
			return value;
		},
		signNum4:function(selector, key, rows, value) { //'0'표시안함, 콤마사용
			value = nexUtils.numberWithCommas(value);
			// '0'표시안함
			if(value=='0') {
				value='\u00A0';
			}
			return value;
		},
		signNum5:function(selector, key, rows, value) { //콤마사용, 숫자단위 : 4, '0'표시안함
			//숫자단위 변환
			var divide = 4; //숫자단위
			value = value / Math.pow(10,divide);

			// '0'표시안함
			if(value=='0') {
				value='\u00A0';
			}

			value = nexUtils.numberWithCommas(value);
			return value;
		},
		signNum5_1:function(selector, key, rows, value) { //콤마사용, 숫자단위 : 5, '0'표시안함
			//숫자단위 변환
			var divide = 5; //숫자단위
			value = value / Math.pow(10,divide);

			// '0'표시안함
			if(value=='0') {
				value='\u00A0';
			}

			value = nexUtils.numberWithCommas(value);
			return value;
		},
		signNum6:function(selector, key, rows, value) { //콤마사용, 숫자단위 : 4			
			//숫자단위 변환
			var divide = 4; //숫자단위
			value = value / Math.pow(10,divide);
			value = nexUtils.numberWithCommas(value);

			return value;
		},
		signNum7:function(selector, key, rows, value) { //콤마사용, 숫자단위:5, 자리수:5 (소수점이하 0으로 채움)		
			//숫자단위 변환
			var divide = 5; //숫자단위
			value = value / Math.pow(10,divide); 

			//콤마사용
			var sosu = 5;
			value = nexUtils.numberFormat(value, sosu); //numberFormat:function(num, cipher) numberFormat("12345.12",3) -> 12345.120			

			return value;
		},
		signDate:function(selector, key, rows, value) { //날짜 포맷 변경
			return nexUtils.dateFormat(value,"/");
		},
		signAccount:function(selector, key, rows, value) { //계좌포맷
			var text=[];
			text[0]=value.substr(0,3);
			text[1]=value.substr(3,2);
			text[2]=value.substr(5,6);

			//return value.substr(0,3)+"-"+value.substr(3,2)+"-"+value.substr(5,6);
			return text.join('-');
		},
		signAccount2:function(selector, key, rows, value) { //계좌포맷
			if(value == ""){
				return value;
			}

			var text=[];
			text[0]=value.substr(0,3);
			text[1]=value.substr(3,2);
			text[2]=value.substr(5,6);

			return text.join('-');
			//return value.substr(0,3)+"-"+value.substr(3,2)+"-"+value.substr(5,6);
		},
		chkd:function(selector, key, rows, value) {
			var gbn=value.trim().substring(0,1);
			value=value.trim().substring(1);

			if(gbn=='+') {
				value = value * 0.1;
				value = String(value) + "%";
				$(selector).find(".leftbar_area").find("em").css("width","0");
				$(selector).find(".rightbar_area").find("em").css("width",value);
			} else if(gbn=='-') {
				value = 100 - value;
				value = value >= 100 ? 100 : value;
				value = String(value) + "%";
				$(selector).find(".leftbar_area").find("em").css("width",value);
				$(selector).find(".rightbar_area").find("em").css("width","0");
			} else {
				$(selector).find(".leftbar_area").find("em").css("width","0");
				$(selector).find(".rightbar_area").find("em").css("width","0");
			}

			return;
		},
		// +,- 구분값이 없는 경우
		// 전일종가와 비교하여 컬러값 처리 (ex 상한가, 하한가)
		upperLower : function(selector, key, rows, value) {
			// 20160304 알수 없는 오류로 제거
			// up, low 하드코딩 처리
			/*var amt313 = Number(rows['002313'].trim());
			value = Number(value.trim());
			if (value > amt313) {
				selector.addClass('up');
			} else if(value < amt313) {
				selector.addClass('low');
			}*/
			return value.commify();
		},
		marketName : function(selector, key, rows, value) {
			var gbn=value.substring(0,1);
			selector.removeClass('up low');
			//selector.removeClass('low');
			if(gbn=='+') {
				value=value.trim().substring(1);
				selector.addClass('up');
			} else if(gbn=='-') {
				value=value.trim().substring(1);
				selector.addClass('low');
			}
			return value;
		},
		pSign : function(selector, key, rows, value) {
			var gbn=value.substring(0,1);
			selector.removeClass('up low');
			//selector.removeClass('low');

			if(value == "+0.00") {
				value = value.trim();
			} else if(gbn=='+') {
				value=value.trim();
				selector.addClass('up');
			} else if(gbn=='-') {
				value=value.trim();
				selector.addClass('low');
			}

			return value;
		},
		signKo : function(selector, key, rows, value) {
			var gbn=value.substring(0,1);
			selector.removeClass('up low');
			//selector.removeClass('low');

			if(value == "+없음") {
				value=value.trim().substring(1);
				selector.addClass('up');
			} else if(value=='-없음') {
				value=value.trim().substring(1);
				selector.addClass('low');
			} else if(gbn=='+') {
				value=value.trim().substring(1);
				selector.addClass('up');
			} else if(gbn=='-') {
				value=value.trim().substring(1);
				selector.addClass('low');
			}

			return value;
		},		
		decPnt2: function(selector, key, rows, value) {
			if(String(value).trim()=='0' || String(value).trim()=='' || Number(value) =='0' || Number(value) == '0.00' ){
				return '';
			}
			var gnb = value.trim().substring(0,1);
			var val = value.trim().substring(1);
			val = (val * 0.01).toFixed(2);
			val = gnb + val;
			return val;
		},
		gridTime:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData;
			var arr_data=[];
			if(value.length == 4) {
				arr_data[0]=value.substring(0, 2);
				arr_data[1]=value.substring(2, 4);
				//value = value.substring(0, 2) + ':' + value.substring(2, 4);
			} else {
				arr_data[0]=value.substring(0, 2);
				arr_data[1]=value.substring(2, 4);
				arr_data[2]=value.substring(4, 6);
				//value = value.substring(0, 2) + ':' + value.substring(2, 4) + ':' + value.substring(4, 6);
			}
			//return value;
			return arr_data.join(':');
		},
		gridDate:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData;
			if(value !="") {
				var text=[];
				text[0]=value.substring(0, 4);
				text[1]=value.substring(4, 6);
				text[2]=value.substring(6, 8);
				//value = value.substring(0, 4) + '/' + value.substring(4, 6) + '/' + value.substring(6, 8);
				value = text.join('/');
			}
			return value;
		},
		gridSign:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=String(ui.cellData).trim();
			var gbn=value.substring(0,1);
			var className='';
			if(gbn=='+') {
				className='up';
				value=value.substring(1);
				value=value.commify();
			} else if(gbn=='-') {
				className='low';
				value=value.substring(1);
				value=value.commify();
			} else {
				value=value.commify();
			}

			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
		    ui.rowData.pq_cellcls[ui.dataIndx] = className;

			return value;
		},
		gridSign2:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData.trim();
			var gbn=value.substring(0,1);
			var className='';
			if(gbn=='+') {
				className='up';
				value=value.substring(1);
				value=value.commify();
				value=gbn+value;
			} else if(gbn=='-') {
				className='low';
				value=value.substring(1);
				value=value.commify();
				value=gbn+value;
			} else {
				value=value.commify();
			}

			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
		    ui.rowData.pq_cellcls[ui.dataIndx] = className;

		    return value;
		},
		gridSign2_1:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData.trim();
			var gbn=value.substring(0,1);

			var className='';
			if(value.replace("-","")=='0' || value.replace("+","")=='0') {
				return '';
			} 

			if(gbn=='+') {
				className='up';
				value=value.substring(1);
				value=value.commify();
				value=gbn+value;
			} else if(gbn=='-') {
				className='low';
				value=value.substring(1);
				value=value.commify();
				value=gbn+value;
			} else {
				value=value.commify();
			}

			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
		    ui.rowData.pq_cellcls[ui.dataIndx] = className;

			return value;
		},
		// 구분값(+,-) 기준 글자색 변경 및 소수점 2자리 표시, 콤마
		gridSign2_2:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData.trim();
			var gbn=value.substring(0,1);

			var className='';
			if(value.replace("-","")=='0' || value.replace("+","")=='0') {
				return '';
			} 

			if(gbn=='+') {
				className='up';
				value=value.replace("+","").trim();
				value=value.commify();
			} else if(gbn=='-') {
				className='low';
				value=value.replace("-","").trim();
				value=value.commify();
			} else {
				value=value.commify();
			}

			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
		    ui.rowData.pq_cellcls[ui.dataIndx] = className;

			return value;
		},
		gridSign3:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData.trim();
			if(typeof value == 'undefined') {
				return '';
			}

			var gbn=value.substring(0,1);
			var className='';
			if(gbn=='+') {
				className='up arrow';
				value=value.substring(1);
				value=value.commify();
			} else if(gbn=='-') {
				className='low arrow';
				value=value.substring(1);
				value=value.commify();
			} else {
				value=value.commify();
			}

			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
		    ui.rowData.pq_cellcls[ui.dataIndx] = className;

			//if(className!='') {
			//	var tag='<span class="c_arrow '+className+'">\u00A0;\u00A0;\u00A0;\u00A0;\u00A0;</span>';
			//	return tag+value;
			//} else {
				return value;
			//}
		},
		// 등락률 ( "+0.00" -> class(up,low)처리 )
		gridSign4:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=String(ui.cellData).trim();
			var gbn=value.substring(0,1);
			var val=value.substring(1);
			var className='';

			if(val=='0.00') {
				value = val;
			} else if(gbn=='+') {
				className='up';
			} else if(gbn=='-') {
				className='low';
			}

			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
		    ui.rowData.pq_cellcls[ui.dataIndx] = className;

		    return value;
		},
		// 구분기호(+,-)에 따라 글자색 변경
		gridSign4_1:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData.trim();
			var gbn=value.substring(0,1);
			var className='';

			if(gbn=='-') {
				className='low';
			} else {
				className='up';
			}

			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
		    ui.rowData.pq_cellcls[ui.dataIndx] = className;

		    return value;
		},
		// output 데이터 그대로 출력 및 콤마
		gridSign4_2:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData.trim();
			value=value.commify();
			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
			return value;
		},		
		gridSign5:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			if(typeof ui.cellData == 'undefined' || ui.cellData == '0' || ui.cellData == '3') {
				ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
			    ui.rowData.pq_cellcls[ui.dataIndx] = '';
			    return '0';
			}

			var value=String(ui.cellData).trim();
			var gbn = value.substring(0,1);
			var val = value.substring(1).trim().commify();
			var className='';
			if(gbn=='1') {
				className='upper arrow';
			} else if(gbn=='2') {
				className='up arrow';
			} else if(gbn=='4') {
				className='lower arrow';
			} else if(gbn=='5') {
				className='low arrow';
			}

			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
		    ui.rowData.pq_cellcls[ui.dataIndx] = className;

			return val;
		},
		gridSign5_1:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			if(typeof ui.cellData == 'undefined' || ui.cellData == '0' || ui.cellData == '3') {
				ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
			    ui.rowData.pq_cellcls[ui.dataIndx] = '';
			    return '0';
			}

			var value=ui.cellData.trim();
			var gbn = value.substring(0,1);
			var val = value.substring(1).commify();
			var className='';
			if(gbn=='1') {
				className='upper arrow';
			} else if(gbn=='2') {
				className='up arrow';
			} else if(gbn=='4') {
				className='lower arrow';
			} else if(gbn=='5') {
				className='low arrow';
			}else if(gbn=='+') {
				className='up arrow';
			} else if(gbn=='-') {
				className='low arrow';
			}

			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
		    ui.rowData.pq_cellcls[ui.dataIndx] = className;

			return val;
		},
		//구분값(1:상한,2:상승,3:보합,4:하한,5:하락)
		gridSign6:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData.trim();
			var gbn = value.substring(0,1);
			var val = value.substring(1).commify();
			var className = '';
			if(gbn=='1'||gbn=='2') {
				className='up';
			} else if(gbn=='4'||gbn=='5') {
				className='low';
			}
			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
		    ui.rowData.pq_cellcls[ui.dataIndx] = className;

			return val;
		},
		gridSign7:function(ui){
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData.trim();
			var gbn = value.substring(0,1);
			var val = value.substring(1);
			val = (val * 0.01).toFixed(2);
			if(gbn=='-') {
				className='low';
				val = gbn + val;
			} else {
				if(val != '0.00'){
					className='up';
				}else{
					className='';
				}
			}

			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
			ui.rowData.pq_cellcls[ui.dataIndx] = className;

			return val;
		},
		gridSign7_1:function(ui){
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData.trim();
			var gbn = value.substring(0,1);
			var val = value.substring(0).commify();
			if(gbn=='-') {
				className='low';
			} else {
				if(val != '0'){
					className='up';
				}else{
					className='';
				}
			}

			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
			ui.rowData.pq_cellcls[ui.dataIndx] = className;

			return val;		
		},
		//콤마사용, '0'표시안함 , 숫자단위:3, 소수점 이하 0 표시안함, 소수점 이하 0 경우 정수만 표시
		gridSignNum:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData;

			//숫자단위 변환			
			var divide = 3; //숫자단위
			value = value / Math.pow(10,divide);	//콤마사용			
			value = nexUtils.numberWithCommas(value);

			// '0'표시안함
			if(value=='0') {
				value='\u00A0';
			}

			return value;		
		},
		//콤마사용, 숫자단위:2, 소수점 이하 0 표시안함, 소수점 이하 0 경우 정수만 표시
		gridSignNum2:function(ui) {	
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData;

			//숫자단위 변환			
			var divide = 2; //숫자단위			
			value = value / Math.pow(10,divide); 

			//콤마사용 			
			value = nexUtils.numberWithCommas(value);

			return value;		
		},
		//콤마사용, 숫자단위:2, 소수점 이하 0 표시안함, 소수점 이하 0 경우 정수만 표시, '0'표시안함
		gridSignNum2_1:function(ui) {	
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData;	//숫자단위 변환
			var divide = 2; //숫자단위
			value = value / Math.pow(10,divide); //콤마사용
			value = nexUtils.numberWithCommas(value);

			// '0'표시안함
			if(value=='0') {
				value='\u00A0';
			}

			return value;
		},
		//음수양수 글자색 적용, 숫자단위:2, '0'표시안함, 콤마사용, 소수점 이하 0 표시안함, 소수점 이하 0 경우 정수만 표시
		gridSignNum2_2:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData.trim();
			// 음수양수 글자색적용
			var gbn=value.substring(0,1);
			var className='';
			if(gbn=='-') {
				className='low';
			}else if(Number(value) > 0){
				className='up';
			}
			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
			ui.rowData.pq_cellcls[ui.dataIndx] = className;

			//숫자단위 변환
			var divide = 2; //숫자단위
			value = value / Math.pow(10,divide);	//콤마사용
			value = nexUtils.numberWithCommas(value);

			// '0'표시안함
			if(value=='0') {
				value='\u00A0';
			}

			return value;
		},
		//음수양수 글자색 적용, 숫자단위:2, 콤마사용
		gridSignNum2_3:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData.trim();

			// 음수양수 글자색적용
			var gbn=value.substring(0,1);
			var className='';
			if(gbn=='-') {
				className='low';
			}else if(Number(value) > 0){
				className='up';
			}
			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
			ui.rowData.pq_cellcls[ui.dataIndx] = className;

			//숫자단위 변환
			var divide = 2; //숫자단위
			value = value / Math.pow(10,divide);	//콤마사용
			value = nexUtils.numberWithCommas(value);

			return value;
		},
		//음수양수 글자색 적용, 숫자단위:2, 자리수:2 (소수점이하 0으로 채움), 콤마사용
		gridSignNum2_4:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData.trim();

			// 음수양수 글자색적용
			var gbn=value.substring(0,1);
			var className='';
			if(gbn=='-') {
				className='low';
			}else if(Number(value) > 0){
				className='up';
			}
			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
			ui.rowData.pq_cellcls[ui.dataIndx] = className;

			//숫자단위 변환
			var divide = 2; //숫자단위
			value = value / Math.pow(10,divide);	

			//콤마사용
			var sosu = 2;
			value = nexUtils.numberFormat(value, sosu); //numberFormat:function(num, cipher) numberFormat("12345.12",3) -> 12345.120	

			return value;
		},
		//음수양수 글자색 적용, '0'표시안함, 콤마사용, 숫자단위:2, 자리수:2 (소수점이하 0으로 채움)
		gridSignNum3:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData.trim();

			// 음수양수 글자색적용
			var gbn=value.substring(0,1);
			var className='';

			if(gbn=='-') {
				className='low';
			}else if(Number(value) > 0){
				className='up';
			}
			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
			ui.rowData.pq_cellcls[ui.dataIndx] = className;

			//숫자단위 변환
			var divide = 2; //숫자단위
			value = value / Math.pow(10,divide); 

			//콤마사용
			var sosu = 2;
			value = nexUtils.numberFormat(value, sosu); //numberFormat:function(num, cipher) numberFormat("12345.12",3) -> 12345.120			
			
			// '0'표시안함
			if(value=='0.00') {
				value='\u00A0';
			}

			return value;
		},
		// '0'표시안함, 콤마사용, 숫자단위:2, 자리수:2 (소수점이하 0으로 채움)
		gridSignNum3_2:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData;

			//숫자단위 변환
			var divide = 2; //숫자단위
			value = value / Math.pow(10,divide); 

			//콤마사용
			var sosu = 2;
			value = nexUtils.numberFormat(value, sosu); //numberFormat:function(num, cipher) numberFormat("12345.12",3) -> 12345.120

			// '0'표시안함
			if(value=='0.00') {
				value='\u00A0';
			}

			return value;
		},
		// 콤마사용, 숫자단위:2, 자리수:2 (소수점이하 0으로 채움)
		gridSignNum3_3:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';

			var value=ui.cellData;
			//숫자단위 변환
			var divide = 2; //숫자단위
			value = value / Math.pow(10,divide); 

			//콤마사용
			var sosu = 2;
			value = nexUtils.numberFormat(value, sosu); //numberFormat:function(num, cipher) numberFormat("12345.12",3) -> 12345.120

			return value;
		},
		//콤마사용
		gridSignNum4:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';

			var value=ui.cellData;

			return nexUtils.numberWithCommas(value);
		},
		//콤마사용, 숫자단위:2
		gridSignNum4_2:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData;

			//숫자단위 변환
			var divide = 2; //숫자단위
			value = value / Math.pow(10,divide);	//콤마사용
			value = nexUtils.numberWithCommas(value);

			return value;
		},
		//콤마사용, '0'표시안함
		gridSignNum4_3:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData;
			nexUtils.numberWithCommas(value);

			// '0'표시안함
			if(value=='0') {
				value='\u00A0'; 
			}
			return value;
		},
		//'0'표시안함
		gridSignNum4_4:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData;

			// '0'표시안함
			if(value=='0') { value='\u00A0';}	
			if(Number(value)==0) {	value='\u00A0';}

			return value;
		},
		//음수양수 글자색 적용, 콤마사용
		gridSignNum5:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData;

			// 음수양수 글자색적용
			var gbn=value.trim().substring(0,1);
			var className='';

			if(gbn=='-') {
				className='low';
			}else if(Number(value) > 0){
				className='up';
			}

			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
			ui.rowData.pq_cellcls[ui.dataIndx] = className;

			return nexUtils.numberWithCommas(value);
		},
		//음수양수 글자색 적용, 콤마사용, +,- 모두 표현
		gridSignNum5_2:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';

			var value=ui.cellData;

			// 음수양수 글자색적용
			var gbn=value.trim().substring(0,1);
			var className='';
			if(gbn=='-') {
				className='low';
			}else if(Number(value) > 0){
				className='up';
			}

			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
			ui.rowData.pq_cellcls[ui.dataIndx] = className;

			var reseultVal =  nexUtils.numberWithCommas(value);
			if(Number(value) > 0){
				reseultVal = '+'+reseultVal;
			}

			return reseultVal;
		},
		//음수양수 글자색 적용, 콤마사용, +,- 모두 표현, '0'표시안함
		gridSignNum5_3:function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var value=ui.cellData.trim();

			// 음수양수 글자색적용
			var gbn=value.substring(0,1);
			var className='';

			if(gbn=='-') {
				className='low';
			}else if(Number(value) > 0){
				className='up';
			}

			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
			ui.rowData.pq_cellcls[ui.dataIndx] = className;

			var reseultVal =  nexUtils.numberWithCommas(value);
			if(Number(value) > 0){
				reseultVal = '+'+reseultVal;
			}

			// '0'표시안함
			if(value=='0') {
				value='\u00A0';
			}

			return reseultVal;
		},
		gridSumData : function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var val=String(Number(ui.rowData['011023'].replace('+','').replace('-',''))-window.nexFmt.amt313);
			var gnb = val.trim().substring(0,1);
			if(gnb != '-' && gnb != '0'){
				val = '+' + val;
			}
			ui.cellData=val;
			return window.nexFmt.gridSign3(ui);
		},
		commify : function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var val = String(ui.cellData).trim();

			if(val=='') {
				val = '';
			} else {
				val = val.commify();
			}
			
			return val;
		},
		gridNumber : function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == '') return '';
			var val = ui.cellData;
			val = Number(val);
			return val;
		},
		setTime : function(selector, key, rows, value) {
			if(value !="") {
				if(value.length == 4)
					value = value.substring(0, 2) + ':' + value.substring(2, 4);
				else
					value = value.substring(0, 2) + ':' + value.substring(2, 4) + ':' + value.substring(4, 6);
			}
			return value;
		},
		//날짜 셋팅(2016년 4월 18일 정상헌 추가)
		setDate : function(selector, key, rows, value) {
			if(value !="") {
				value = value.substring(0, 4) + '/' + value.substring(4, 6) + '/' + value.substring(6, 8);
			}
			return value;
		},
		//증거금율이 100% 일 때 % 제거 및 class "up" 추가
		jgbnSign : function(selector, key, rows, value) {
			var jgbn = value.replace("%","").trim();
			selector.removeClass('up');

			if(jgbn=='100') {
				value=" "+jgbn+" ";
				selector.addClass('up');
			}

			return value;
		},
		// 주가등락률순위, 시가총액순위 그리드에서 사용
		rankGrid : function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == ''){ 
				return '';
			} else {
				ui.cellData = String(ui.cellData).split(".")[0];
				return window.nexFmt.gridSign2_2(ui);
			}
		},
		rankGrid2 : function(ui) {
			if(ui === undefined || ui.cellData === undefined || ui.cellData == null || ui.cellData == ''){ 
				return '';
			} else {
				ui.cellData = String(ui.cellData).split(".")[0];
				return window.nexFmt.gridSign5(ui);
			}
		}
	};
	window.nexFmt = new nexFmt();
})(window, jQuery)