(function(window, $, undefined) {
	var nexBind = function() {
		/**
		 * DecoCell
		 */
		
		this.upDownCls = "";		//+-에 대한 색상
		this.upDownTxt = "보합";	//[상한,상승,보합,하락,하한] 텍스트

		this.upDownArwCls = "";		//상한/하한 화살표 클래스
		this.upDownArwBCls = "";


		/**
		 * up_arr 상승(위삼각형), upper_arr 상한(위화살표), up_txt 빨간색
		 * low_arr 하락(아래삼각형), lower_arr 하한(아래 화살표), low_txt 파란색
		 */
		this.removeCls = 'up_arr upper_arr up_txt low_arr lower_arr low_txt';
		this.removeBCls = 'up_b_arr upper_b_arr up_txt low_b_arr lower_b_arr low_txt';

		this.buySellColored = "black";

		this.$_selector;
	};
	
	nexBind.prototype = {
		/**
		 * desc : 
		 * date : 2015.07.23
		 * author : 이상우
		 * ex : viText(data, viewType) ->  
		 * @param data : V1. VI발동
		 *				 V2. VI해제
		 *				 R1. 시초동시    임의종료지정   RE발동
		 *				 R2. 시초동시    임의종료해제   RE해제
		 *				 R3. 마감동시    임의종료지정   RE발동
		 *				 R4. 마감동시    임의종료해제   RE해제
		 *				 R5. 시간외단일가임의종료지정   RE발동
		 *				 R6. 시간외단일가임의종료해제   RE해제
		 * @param viewType : ALL = 전체, TEXT = 발동/해제, TIME = 시간
		 * @return
		 */
		viText: function(data, viewType) {
			if(viewType == undefined || viewType == null || viewType == '') {
				viewType = 'ALL';
			}
			
			var viText = [];
			
			if(data != undefined && data != null) {
				
				if(viewType == 'ALL') {
					switch(data[2979]) {
						case 'V1': viText.push('VI발동'); break;
						case 'V2': viText.push('VI해제'); break;
						
						case 'R1': 
						case 'R3': 
						case 'R5': viText.push('RE발동'); break;
						
						case 'R2': 
						case 'R4': 
						case 'R6': viText.push('RE해제'); break;
					}
					
					if(viText.length > 0) {
						viText.push(' '); viText.push(timeFormat(data[2980].npad(6), ":"));
					}
				} else {
					viText.push(timeFormat(data[2980].npad(6), ":"));
				}
			}
			
			return viText.join('');
		},
		
		/**
		 * desc : 계좌번호(XXXXXXXX-XX)
		 *		  계좌번호(XXXXXXXXXX-XX)
		 * date : 2015.07.23
		 * author : 이상우
		 * ex : acctNoFormat(val) -> 
		 * @param val : 
		 * @return
		 */
		acctNoFormat: function(val) {
			var value;
			if(val.rowData && !$.util.isEmpty(val.dataIndx)) {
				value = val.rowData[val.dataIndx];
			} else {
				value = val;
			}
			
			if($.trim(value) == '') {
				return '';
			}

			return value.actNoFormat();
		},
		
		/**
		 * desc : 날짜
		 * date : 2015.07.23
		 * author : 이상우
		 * ex : dateFormat(val, 'yyyymmdd', '/') -> 
		 * @param val : 그리드 데이터(8자리 데이터, yyyymmdd)
		 * @param viewType : 날짜표현 형태(yyyymmdd: 20140707, yyyymm: 201407, mmdd: 0707), default: yyyymmdd
		 * @param pDelimiter : 구분자, default: '/'
		 * @return
		 */
		dateFormat: function(val, viewType, pDelimiter) {

			if(viewType == undefined) viewType = '';
			if(pDelimiter == undefined) pDelimiter = '/';

			var value;
			if(val.rowData && !$.util.isEmpty(val.dataIndx)) {
				value = val.rowData[val.dataIndx];
			} else {
				value = val;
			}
			
			if($.trim(value) == '') {
				return '';
			}

			var inpVal = value;
			
			// 날짜에 - 값이 들어올 경우에는 그대로 리턴한다.
			if (inpVal == '-') {
				return inpVal;
			}		

			if(viewType == 'yyyymm') {
				inpVal = value.substring(0, 6);
			} else if(viewType == 'mmdd') {
				inpVal = value.substring(4);
			}

			return dateFormat(inpVal, pDelimiter);
		},
		
		/**
		 * desc : 날짜
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : dateFormatAddClass(ui, 'yyyymmdd', '/', baseValue, className) -> 
		 * @param ui : 그리드 데이터(8자리 데이터, yyyymmdd)
		 * @param viewType : 날짜표현 형태(yyyymmdd: 20140707, yyyymm: 201407, mmdd: 0707), default: yyyymmdd
		 * @param pDelimiter : 구분자, default: '/'
		 * @param baseValue: 비교값
		 * @param className: 비교값과 일치하는 경우에 추가할 className
		 * @return
		 */
		dateFormatAddClass: function(ui, viewType, pDelimiter, baseValue, className) {

			if(viewType == undefined) viewType = '';
			if(pDelimiter == undefined) pDelimiter = '/';

			var value;
			if(ui.rowData && ui.dataIndx) {
				value = ui.rowData[ui.dataIndx];
			} else {
				value = ui;
			}

			var inpVal = value;

			if (inpVal == baseValue) {
				ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
				ui.rowData.pq_cellcls[ui.dataIndx] = className;
			}

			if(viewType == 'yyyymm') {
				inpVal = value.substring(0, 6);
			} else if(viewType == 'mmdd') {
				inpVal = value.substring(4);
			}

			return dateFormat(inpVal, pDelimiter);
		},
		
		/**
		 * desc : 시간
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : timeFormat(hhmmss, 'hhmmss', ':') -> 10:16:23
		 * @param val : 그리드 데이터(6자리 데이터, hhmmss)
		 * @param viewType : 날짜표현 형태(hhmmss: 182020, hhmm: 1820, mmss: 2020), default: hhmmss
		 * @param pDelimiter : 구분자, default: ':'
		 * @return
		 */
		timeFormat: function(val, viewType, pDelimiter) {

			if(viewType == undefined) viewType = '';
			if(pDelimiter == undefined) pDelimiter = ':';

			var value;
			if(val.rowData && val.dataIndx) {
				value = String(val.rowData[val.dataIndx]).trim();
			} else {
				value = val;
			}

			var inpVal = value;

			if (inpVal == '9991') {
				return "장종료";
			}else if (inpVal == '9999') {
				return "시간외";
			}
			
			// 시간에 - 값이 들어올 경우에는 그대로 리턴한다.
			if (inpVal == '-') {
				return inpVal;
			}

			//오전 9시의 데이터는 5자리 값을 가지고 있음.
			if (inpVal.length < 6) {
				inpVal = '0' + inpVal;
			}

			if(viewType == 'hhmm') {
				inpVal = value.substring(0, 4);
			} else if(viewType == 'mmss') {
				inpVal = value.substring(2);
			}

			return timeFormat(inpVal, pDelimiter);
		},
		
		/**
		 * 콤마를 붙인 숫자타입
		 * default : 소수점 0자리
		 */
		/**
		 * desc : 콤마를 붙인 숫자타입
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : numberFormat(ui) -> 
		 * @param ui : 
		 * @return
		 */
		numberFormat: function(ui) {
			if (arguments.length < 2) {
				return $.util.numberFormat( ui.rowData[ui.dataIndx], 0);
			} else {
				return $.util.numberFormat( ui.rowData[ui.dataIndx], arguments[1]);
			}
		},
		
		/**
		 * desc : 콤마를 붙인 소수점 2자리의 숫자타입
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : numberFormat2(ui) -> 
		 * @param ui : 
		 * @return
		 */
		numberFormat2: function(ui) {
			return self.numberFormat(ui, 2);
		},
		
		/**
		 * desc : 콤마를 붙인 숫자타입(양수/음수 기준으로 색상지정)
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : numberFormatUpDownCss(ui) -> 
		 * @param ui : 
		 * @return
		 */
		numberFormatUpDownCss: function(ui) {
			var className = '';
			var value     = ui.rowData[ui.dataIndx];
			if ( $.util.toFloat(value) < 0 ) {
				className = 'low_txt';
			} else if ( $.util.toFloat(value) > 0 ) {
				className = 'up_txt';

			}
			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
			ui.rowData.pq_cellcls[ui.dataIndx] = className;

			if (arguments.length < 2) {
				return self.numberFormat(ui, 0);
			} else {
				return self.numberFormat(ui, arguments[1]);
			}
		},
		
		/**
		 * desc : 콤마를 붙인 소수점 2자리의 숫자타입(양수/음수 기준으로 색상지정)
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : numberFormatUpDownCss2(ui) -> 
		 * @param ui : 
		 * @return
		 */
		numberFormatUpDownCss2: function(ui) {
			return self.numberFormatUpDownCss(ui, 2);
		},
		
		/**
		 * desc : 콤마를 붙인 숫자타입(양수/음수 기준으로 색상지정, 등락 삼각형 추가)
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : numberFormatUpDownArrCss(ui) -> 
		 * @param ui : 
		 * @return
		 */
		numberFormatUpDownArrCss: function(ui) {
			var className = '';
			var value     = ui.rowData[ui.dataIndx];
			if ( $.util.toFloat(value) < 0 ) {
				className = 'low_txt low_arr';
			} else if ( $.util.toFloat(value) > 0 ) {
				className = 'up_txt up_arr';
				
			}
			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
			ui.rowData.pq_cellcls[ui.dataIndx] = className;
			
			if (arguments.length < 2) {
				return self.numberFormat(ui, 0);
			} else {
				return self.numberFormat(ui, arguments[1]);
			}
		},
		
		/**
		 * desc : 콤마를 붙인 숫자타입(양수/음수 기준으로 색상지정, 퍼센트(%) 추가)
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : numberFormatUpDownPercentCss(ui) -> 
		 * @param ui : 
		 * @return
		 */
		numberFormatUpDownPercentCss: function(ui) {
			return self.numberFormatUpDownCss(ui) + '%';
		},
		
		/**
		 * desc : 콤마를 붙인 소수점 2자리의 숫자타입(양수/음수 기준으로 색상지정, 퍼센트(%) 추가)
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : numberFormatUpDownArrCss2(ui) -> 
		 * @param ui : 
		 * @return
		 */
		numberFormatUpDownArrCss2: function(ui) {
			return self.numberFormatUpDownCss(ui, 2) + '%';
		},
		
		/**
		 * desc : 앞에 '0'제거
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : toNum(ui) -> 
		 * @param ui : 
		 * @return
		 */
		toNum: function(ui) {
			return String(Number(ui.rowData[ui.dataIndx]));
		},
		
		/**
		 * desc : 매매구분(매수, 매도)에 색상지정
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : sectNameCss(ui) -> 
		 * @param ui : 
		 * @return
		 */
		sectNameCss: function(ui) {
			var className = '';
			var value     = ui.rowData[ui.dataIndx];
			if (value.indexOf("매도")>-1 ) {
				className = 'low_txt';
			} else if (value.indexOf("매수")>-1){
				className = 'up_txt';
			}
			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
			ui.rowData.pq_cellcls[ui.dataIndx] = className;

			return value;
		},
		
		/**
		 * desc : 금액형태로 표시(3자리마다 ',' 처리)
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : commify(val) -> 
		 * @param val : 
		 * @return
		 */
		commify: function(val) {
			var value;
			if(val.rowData && val.dataIndx) {
				value = val.rowData[val.dataIndx];
			} else {
				value = val;
			}
			
			//빈 값으로 넘어올 경우에 0을 return 하지 않도록 처리한다.
			if (value == '') {
				return '';
			} else {
				return String(Number(value)).commify();
			}
		},
		
		/**
		 * desc : %, 억 등 추가
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : addUnit(val, '%', true) -> 123,456% 
		 * @param val : 데이터 그리드 or 값
		 * @param unit : %, 억 등
		 * @param money : true: 3자리마다 ',', false: 컴마 X 
		 * @return
		 */
		addUnit: function(val, unit, money) {

			if(money == undefined || money == null) money = false;
					
			var value;
			if(val.rowData && val.dataIndx) {
				value = val.rowData[val.dataIndx];
			} else {
				value = val;
			}

			if(money) {
				value = String(value).commify();
			}
			
			if(value == '') {
				unit = '';
			}
			
			return value + unit;
		},
		
		/**
		 * desc : 대비값(전일대비부호) 기준으로 스타일 적용하는 function
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : addUnitPoint(ui, '%', false, true, false, 2) -> 
		 * @param ui : 그리드 데이터
		 * @param unit : 부호(ex. % 등)
		 * @param sign : +, - 표시 여부(true: 표시, false: 미표시)
		 * @param money : 금액형태(true: ',' 표시, false: 미표시)
		 * @param zeroShow : 0일 경우 표시 유무(true: 0 표시, false: 미표시)
		 * @param fixedNum : 소수점 처리
		 * @return
		 */
		addUnitPoint: function(ui, unit, sign, money, zeroShow, fixedNum) {
			var value = ui.rowData[ui.dataIndx];
			
			// *4로 값을 가져올 경우에 +,- 기호가 없는 경우는 공백 문자가 있음. 
			value = Number(value);
			
			if(sign == undefined || sign == null) sign = false;
			if(money == undefined || money == null) money = true;
			if(zeroShow == undefined || zeroShow == null) zeroShow = true;
			if(unit == undefined || unit == null) unit = '';		
			if(fixedNum != undefined && fixedNum != null) value = value.toFixed(fixedNum);
			
			var className = '';

			if(typeof(value) == 'number') {
				value = String(value);
			} else if(typeof(value) == 'NaN') {
				value = String(0);
			}
			
			if(!zeroShow && Number(value) == 0) {
				return '';
			}
			
			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
			ui.rowData.pq_cellcls[ui.dataIndx] = className;

			if(!sign) {
				value = value.replace(/[+-]/g,'');
			}
			
			if(money) {
				value = value.commify();
			}
			
			//값이 없고 unit이 있을 경우에는 unit을 표시하지 않는다.
			if(value == '') unit = '';
			
			var return_str=[];
			return_str.push(value);
			return_str.push(unit);

			return return_str.join('');
		},
		
		/**
		 * desc : 대비값(전일대비부호) 기준으로 스타일 적용하는 function
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : edailyUtilsUpDownCss(_selector, val, edaily, gubun, sign, money, arrYn, unit, fixedNum) -> 
		 * @param _selector : 
		 * @param val : 값
		 * @param edaily : edaily 등락구분 사용(true: 사용, false: 기존 등락구분 사용)
		 * @param gubun : 등락구분
		 * @param sign : +, - 표시 여부(true: 표시, false: 미표시)
		 * @param money : 금액형태(true: ',' 표시, false: 미표시)
		 * @param arrYn : 등락부호 유무 (Y:있음, N:없음)
		 * @param unit : 부호(ex. % 등)
		 * @param fixedNum : 소수점 처리
		 * @return
		 */
		edailyUtilsUpDownCss: function(_selector, val, edaily, gubun, sign, money, arrYn, unit, fixedNum) {
			
			if(edaily == undefined || edaily == null) edaily = false;
			if(sign == undefined || sign == null) sign = false;
			if(money == undefined || money == null) money = true;
			if(arrYn == undefined || arrYn == null) arrYn = 'N';
			if(unit == undefined || unit == null) unit = '';		
			
			var return_str=[];
			
			var className = '';
			var span = '';
			
			var value = Number(val);
			
			if(fixedNum != undefined && fixedNum != null) value = value.toFixed(fixedNum);

			// edaily 부호
			if(edaily) {
				if(gubun == '3') {
					arrYn == 'Y' ? className = 'upper_txt upper_arr':className = 'upper_txt';
					arrYn == 'Y' ? span = '<span class="screen_out">상한</span>' : span = '';
				} else if(gubun == '1') {
					arrYn == 'Y' ? className = 'up_txt up_arr':className = 'up_txt';
					arrYn == 'Y' ? span = '<span class="screen_out">상승</span>' : span = '';
				} else if(gubun == '2') {
					arrYn == 'Y' ? className = 'low_txt low_arr':className = 'low_txt';
					arrYn == 'Y' ? span = '<span class="screen_out">하락</span>' : span = '';
				} else if(gubun == '4') {
					arrYn == 'Y' ? className = 'lower_txt lower_arr':className = 'lower_txt';
					arrYn == 'Y' ? span = '<span class="screen_out">하한</span>' : span = '';
				}
			} else {
				if(gubun == '7') {
					arrYn == 'Y' ? className = 'upper_txt upper_arr':className = 'upper_txt';
					arrYn == 'Y' ? span = '<span class="screen_out">상한</span>' : span = '';
				} else if(gubun == '6') {
					arrYn == 'Y' ? className = 'up_txt up_arr':className = 'up_txt';
					arrYn == 'Y' ? span = '<span class="screen_out">상승</span>' : span = '';
				} else if(gubun == '4') {
					arrYn == 'Y' ? className = 'low_txt low_arr':className = 'low_txt';
					arrYn == 'Y' ? span = '<span class="screen_out">하락</span>' : span = '';
				} else if(gubun == '3') {
					arrYn == 'Y' ? className = 'lower_txt lower_arr':className = 'lower_txt';
					arrYn == 'Y' ? span = '<span class="screen_out">하한</span>' : span = '';
				}
			}
			
			if(typeof(value) == 'number') {
				value = String(value);
			} else if(typeof(value) == 'NaN') {
				value = String(0);
			}
			
			if(!sign) {
				value = value.replace(/[+-]/g,'');
			}
			
			if(money) {
				value = value.commify();
			}
			
			//값이 없고 unit이 있을 경우에는 unit을 표시하지 않는다.
			if(value == '') unit = '';
			
			return_str.push(span);
			return_str.push(value);
			return_str.push(unit);
				
			if(_selector.rowData != undefined && _selector.dataIndx != undefined) {
				_selector.rowData.pq_cellcls = _selector.rowData.pq_cellcls || {};
				_selector.rowData.pq_cellcls[_selector.dataIndx] = className;
				
				return return_str.join('');
			} else {
				$(_selector).html(return_str.join('')).removeClass(this.removeCls).addClass(className);	
			}
		},
		
		/**
		 * desc : 대비값(전일대비부호) 기준으로 스타일 적용하는 function
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : upDownArrCss(ui, arrYn, unit, sign, money, zeroShow, gubunVal, fixedNum) -> 
		 * @param ui : 그리드 데이터
		 * @param arrYn : 등락부호 유무 (Y:있음, N:없음)
		 * @param unit : 부호(ex. % 등)
		 * @param sign : +, - 표시 여부(true: 표시, false: 미표시)
		 * @param money : 금액형태(true: ',' 표시, false: 미표시)
		 * @param zeroShow : 0일 경우 표시 유무(true: 0 표시, false: 미표시)
		 * @param gubunVal : 등락부호가 복수로 존재 할 경우 (ui.rowData[gubunVal]) 2014.08.04 TD0334 김영철
		 * @param fixedNum : 소수점 자리
		 * @return
		 */
		upDownArrCss: function(ui, arrYn, unit, sign, money, zeroShow, gubunVal, fixedNum) {
			var gubun = ui.rowData['5'];				// fid5 등락부호
			var value = ui.rowData[ui.dataIndx];
			
			// *4로 값을 가져올 경우에 +,- 기호가 없는 경우는 공백 문자가 있음. 
			value = Number(value);
			
			if(sign == undefined || sign == null) sign = false;
			if(money == undefined || money == null) money = true;
			if(zeroShow == undefined || zeroShow == null) zeroShow = true;
			if(unit == undefined || unit == null) unit = '';		
			if(gubunVal != undefined && gubunVal != null) gubun = ui.rowData[gubunVal];
			if(fixedNum != undefined && fixedNum != null) value = value.toFixed(fixedNum);
			
			var className = '';
			var span = '';

			switch(gubun) {
				case '6':
					arrYn == 'Y' ? className = 'up_txt up_arr':className = 'up_txt';
					arrYn == 'Y' ? span = '<span class="screen_out">상승</span>' : span = '';
					break;
					
				case '4':
					arrYn == 'Y' ? className = 'low_txt low_arr':className = 'low_txt';
					arrYn == 'Y' ? span = '<span class="screen_out">하락</span>' : span = '';
					break;
					
				case '7':
					arrYn == 'Y' ? className = 'upper_txt upper_arr':className = 'upper_txt';
					arrYn == 'Y' ? span = '<span class="screen_out">상한</span>' : span = '';
					break;
					
				case '3':
					arrYn == 'Y' ? className = 'lower_txt lower_arr':className = 'lower_txt';
					arrYn == 'Y' ? span = '<span class="screen_out">하한</span>' : span = '';
					break;
			}

			// 차후 보합 처리 할것!!!
			if(typeof(value) == 'number') {
				value = String(value);
			} else if(typeof(value) == 'NaN') {
				value = String(0);
			}
			
			if(!zeroShow && Number(value) == 0) {
				return '';
			}
			
			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
			ui.rowData.pq_cellcls[ui.dataIndx] = className;

			if(!sign) {
				value = value.replace(/[+-]/g,'');
			}
			
			if(money) {
				value = value.commify();
			}
			
			if(ui.dataIndx == '4') {
				if(masterCode.stockInfo[ui.rowData['3']] != undefined) {
					var macketGubun = masterCode.stockInfo[ui.rowData['3']].split("||")[1];
					switch(macketGubun) {
						case "F":
						case "S":
						case "v":
						case "O":
						case "t":
							value = getIndexString(value , 2 , false);
							break;
					}
				}
			}

			//값이 없고 unit이 있을 경우에는 unit을 표시하지 않는다.
			if(value == '') unit = '';
			
			var return_str=[];
			return_str.push(span);
			return_str.push(value);
			return_str.push(unit);

			return return_str.join('');
		},
		
		/**
		 * desc : 입력값 기준으로 양수, 음수를 판단해서 스타일을 변환하는 FUNCTION
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : upDownCss(val, '%', true, true, _selector, 2) -> 
		 * @param val : 그리드 데이터
		 * @param unit : 부호(ex. % 등)
		 * @param sign : +, - 표시 여부(true: 표시, false: 미표시)
		 * @param money : 금액형태(true: ',' 표시, false: 미표시)
		 * @param _selector : 셀렉터
		 * @param point : toFixed(point)
		 * @return
		 */
		upDownCss: function(val, unit, sign, money, _selector, point) {

			var returnVal = '';
			var value;
			if(val.rowData && val.dataIndx) {
				value = val.rowData[val.dataIndx];
			} else {
				value = val;
			}
			
			value = Number(value);

			if(sign == undefined || sign == null) sign = false;
			if(money == undefined || money == null) money = true;
			if(unit == undefined || unit == null) unit = '';
			if(point == undefined || point == null) point = null;
			
			if(point != null) {
				value = value.toFixed(point);
			}
			
			var className = '';

			if(value > 0) {
				className   =   'up_txt';
			} else if(value < 0) {
				className   =   'low_txt';
			} else {
				className   =   '';
			}

			if(typeof(value) == 'number') {
				value   = String(value);
			} else if(typeof(value) == 'NaN') {
				value   =   String(0);
			}
			
			if(!sign) {
				value = value.replace(/[+-]/g,'');
			}

			if(money) {
				value = value.commify();
			}
			
			if(val.rowData && val.dataIndx) {
				val.rowData.pq_cellcls = val.rowData.pq_cellcls || {};
				val.rowData.pq_cellcls[val.dataIndx] = className;
				
				var return_str=[];
				return_str.push(value);
				return_str.push(unit);
				//returnVal = value + unit;
				returnVal = return_str.join('');
				
			} else {
				
				if(_selector != undefined && _selector != null && _selector != '') {
					
					$(_selector).html(value + unit).removeClass(this.removeCls).addClass(className);
					return false;
				} else {
					var return_str=[];
					return_str.push('<div class="');
					return_str.push(className);
					return_str.push('">');
					return_str.push(value);
					return_str.push(unit);
					return_str.push('</div>');
					//returnVal = '<div class="' + className + '">' + value + unit + '</div>';
					returnVal=return_str.join('');
				}
			}

			return returnVal;
		},
		
		/**
		 * desc : 기준값 대상으로 스타일을 씌워야 하는경우 사용되는 FUNCTION
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : compareCss(ui, basicVal, '%', true, true, calbasicVal) ->  
		 * @param ui : 그리드 데이터
		 * @param basicVal : 기준값
		 * @param unit : 부호(ex. % 등)
		 * @param sign : +, - 표시 여부(true: 표시, false: 미표시)
		 * @param money : 금액형태(true: ',' 표시, false: 미표시)
		 * @param calbasicVal : 계산된 기준가
		 * @return
		 */
		compareCss: function(ui, basicVal, unit, sign, money, calbasicVal) {

			var value = ui.rowData[ui.dataIndx];

			if(basicVal == undefined || basicVal == null || basicVal == '') basicVal = 0;
			if(sign == undefined || sign == null) sign = false;
			if(money == undefined || money == null) money = true;
			if(unit == undefined || unit == null) unit = '';

			var val         =   value - basicVal;
			var className   =   '';
			
			if(calbasicVal != undefined || calbasicVal != null) val = calbasicVal;

			if(Number(val) > 0) {
				className   =   'up_txt';
			} else if(Number(val) < 0) {
				className   =   'low_txt';
			}

			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
			ui.rowData.pq_cellcls[ui.dataIndx] = className;

			if(!sign) {
				value = value.replace(/[+-]/g,'');
			}

			if(money) {
				value = value.commify();
			}

			var return_str=[];
			return_str.push(value);
			return_str.push(unit);
			//return value + unit;
			return return_str.join('');
		},
		
		/**
		 * desc : 입력값 기준에 +, - 기호 값을 판단하여 스타일을 변환하는 FUNCTION
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : upDownSignCss(ui, '%', true, true) -> 
		 * @param ui : 그리드 데이터
		 * @param unit : 부호(ex. % 등)
		 * @param sign : +, - 표시 여부(true: 표시, false: 미표시)
		 * @param money : 금액형태(true: ',' 표시, false: 미표시)
		 * @return
		 */
		upDownSignCss: function(ui, unit, sign, money) {

			var value = ui.rowData[ui.dataIndx];

			if(typeof sign == undefined || sign == null) sign = false;
			if(typeof money == undefined || money == null) money = true;
			if(typeof unit == undefined || unit == null) unit = '';

			var className = '';

			if(value.indexOf('+') >= 0) {
				className   =   'up_txt';
			} else if(value.indexOf('-') >= 0) {
				className   =   'low_txt';
			} else {
				className   =   '';
			}

			ui.rowData.pq_cellcls = ui.rowData.pq_cellcls || {};
			ui.rowData.pq_cellcls[ui.dataIndx] = className;

			if(!sign) {
				value = value.replace(/[+-]/g,'');
			}
			value = value.replace(/^\s+|\s+$/g, '');

			if(money) {
				value = value.commify();
			}

			var return_str=[];
			return_str.push(value);
			return_str.push(unit);
			//return value + unit;
			return return_str.join('');
		},
		
		///////////////////////////////////////////////////////////////////////////////////////////////
		/**
		 * desc : 셀렉터 set
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : setSelector($_selector) -> 
		 * @param $_selector : 
		 * @return
		 */
		setSelector: function($_selector) {
			this.$_selector = $($_selector);
		},
		
		/**
		 * desc : 셀렉터로 가공후 다시 리턴받고 싶을때
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : getSelector() -> 
		 * @return 
		 */
		getSelector: function() {
			return this.$_selector;
		},
		
		/**
		 * desc : fid5를 입력하지 않는경우 value에 따른 색상을 결정한다.
		 * author : 이상우
		 * ex : getColorBySign(value, base) -> 
		 * @param value : 
		 * @param base : 
		 * @return 
		 */
		getColorBySign: function(value, base) {

			var cls = "";

			if(isNaN(value)) {
				return cls;
			}

			if(Object.prototype.toString.call(value) == '[object String]'){
				value = Number(value);
			}

			if(base && Object.prototype.toString.call(base) == '[object String]'){
				base = Number(base);
			}

			if(base){
				value = value - base;
			}

			if(value > 0) {
				cls = "up_txt";
			} else if(value < 0){
				cls = "low_txt";
			}

			return cls;
		},
		
		/**
		 * desc : 시간
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : time(fid, value, format) -> 
		 * @param fid : 
		 * @param value : 
		 * @param format : 
		 * @return 
		 */
		time: function(fid, value, format) {
			if(fid = this.chkFid(fid, value)) {
				this.$_selector.find(fid).text(getFmtTime(value));
			}
		},
		
		/**
		 * desc : 통화(수량)
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : mny(fid, option, value, base) ->  
		 * @param fid : 
		 * @param option : 
		 * @param value : 
		 * @param base : 
		 * @return 
		 */
		mny: function(fid, option, value, base) {
			if(fid = this.chkFid(fid, value)){
				if(typeof value == 'number'){
					value.toString();
				}

				var colorCls = '';

				if(value == 0 || value == 0.0000) {
					value = (option.zero == 0) ? '': value;  //기본값은 ''
				} else {
					colorCls = (option.color == 0) ? '': this.getColorBySign(value, base);
					value = (option.sign == 1) ? value : value.replace(/^[+-]/, '');  // 기본값은 사인없음
					value = num2money(value); // 기본값은 색넣음
				}
				value = (isNotEmpty(value) && option.unit) ? value + ' ' + option.unit : value;  //기본값은 단위없음
				if(option.color == 0) {	// 색상을 지우는게 아니라 아무짓도 않하는거.
					this.$_selector.find(fid).text(value);
				} else {
					this.$_selector.find(fid).text(value).removeClass(this.removeCls).addClass(colorCls);
				}

			}
		},
		
		/**
		 * desc : 
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : targetpricesise(fid, value, price, gbn, mode) -> 
		 * @param fid : 
		 * @param value : 
		 * @param price : 
		 * @param gbn : 
		 * @param mode : 
		 * @return 
		 */
		targetpricesise: function (fid, value, price, gbn, mode){
    	
			if(price != null && price != undefined && price != '') {
				if(price == '1') {
					if(gbn == 'up') {
						this.$_selector.find('.fid' + fid).text(value.commify()).removeClass(this.removeCls).addClass('up_txt');
					} else {
						this.$_selector.find('.fid' + fid).text(value.commify()).removeClass(this.removeCls).addClass('low_txt');
					}
				} else if(price == '2') {
					
					if(mode == 'hoga') {
						if(gbn == 'up') {
							this.$_selector.find('.fid' + fid).text(value.commify()).removeClass(this.removeCls).addClass('up_txt');
						} else {
							this.$_selector.find('.fid' + fid).text(value.commify()).removeClass(this.removeCls).addClass('low_txt');
						}
					} else {
						this.$_selector.find('.fid' + fid).removeClass(this.removeCls).text('적용해제');
					}
									
				} else if(price == '9') {
					this.$_selector.find('.fid' + fid).removeClass(this.removeCls).text('없음');    			
				} else {
					this.$_selector.find('.fid' + fid).text('');
				}
			}    	
			
		},
		
		/**
		 * desc : 
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : targetpricehoga(fid, value) -> 
		 * @param fid : 
		 * @param value : 
		 * @return 
		 */
		targetpricehoga: function (fid,value){
			var textval = '';    	
			
			if(value != null && value != undefined && value != ''){
				if(value == '1'){
					textval = '대상';
				}else if(value == '2'){
					textval = '해제';    			
				}else if(value == '9'){
					textval = '없음';    			
				} 
			}   
			
			this.$_selector.find('.fid' + fid).text(textval);        
		},
		
		/**
		 * desc : 일반통화(수량)표시
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : money(fid, value, option) -> 
		 * @param fid : 
		 * @param value : 
		 * @param option :
		 * @return 
		 */
		money: function(fid, value, option) {
			option = $.extend({color:0, sign:1}, option);

			return this.mny(fid, option, value);
		},
		
		/**
		 * desc : 일반통화(수량)표시+색상 표시(부호)  signType 부호(+-)표시 ON/OFF
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : moneyColor(fid, value, base, option) -> 
		 * @param fid : 
		 * @param value : 가격 (*필수)
		 * @param base : 기준가(전일종가) (*필수)
		 * @param option : 
		 * @return 
		 */
		moneyColor: function(fid, value, base, option) {
			option = $.extend({color:1}, option);
			return this.mny(fid, option, value, base);
		},
		
		/**
		 * desc : 일통화+색상+부호 표시
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : moneyColorSign(fid, signValue, option) -> 
		 * @param fid : 
		 * @param signValue : 부호포함 숫자(필요시 가공해서 사용)
		 * @param option : 
		 * @return 
		 */
		moneyColorSign: function(fid, signValue, option) {
			option = $.extend({sign:1}, option);
			return this.mny(fid, option, signValue);
		},
		
		/**
		 * desc : 일반통화(수량)+색상 표시   signType 부호(+-)표시 ON/OFF
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : moneyColorBySign(fid, signValue, option) -> 
		 * @param fid : 
		 * @param signValue : 부호포함한 값 (*필수)
		 * @param option : 
		 * @return 
		 */
		moneyColorBySign: function(fid, signValue, option) {
			option = $.extend({color:1}, option);
			return this.mny(fid, option, signValue);
		},
		
		 /**
		 * desc : 일반통화(수량)+색상+기세부호 표시(pricePicker에서 사용)
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : moneyArrow(fid, value, base) -> 
		 * @param fid : 
		 * @param value : 가격 (*필수)
		 * @param base : 기준가(전일종가) (*필수)
		 * @return 
		 */
		moneyArrow: function(fid, value, base) {
			var option = {color:1, arrow:0};
			return this.mny(fid, option, value, base);
		},
		
		/**
		 * desc : 저가
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : percent(fid, value) -> 
		 * @param fid : 
		 * @param value : 
		 * @return 
		 */
		percent: function (fid, value){
			if(fid = this.chkFid(fid, value)){

				value = (value == '0.00') ? '0' : value;

				this.$_selector.find(fid).text(value.replace(/^[+-]/,'') +'%');
			}
		},
		
		/**
		 * desc : 저가
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : percentBySign(fid, value, option) -> 
		 * @param fid : 
		 * @param value : 
		 * @param option : 
		 * @return 
		 */
		percentBySign: function (fid, value, option){
			if(fid = this.chkFid(fid, value)){

				value = (value == '0.00') ? 0:value;

				var colorCls = this.getColorBySign(value) ;

				value = (option.sign == 1) ? value : Math.abs(value);  //기본값은 사인없음
				this.$_selector.find(fid).text(value + '%').removeClass(this.removeCls).addClass(colorCls);
			}
		},
		
		/**
		 * desc : wrapper함수.
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : moneyMono(fid, value, option) -> 
		 * @param fid : 
		 * @param value : 
		 * @param option : 
		 * @return 
		 */
		moneyMono: function(fid, value, option) {
			return this.money(fid, value,option);
		},
		
		/**
		 * desc : 
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : getText(fid) -> 
		 * @param fid : 
		 * @return 
		 */
		getText: function (fid) {
			return this.$_selector.find(fid).text();
		},
		
		/**
		 * desc : 입력값 기준에 +, - 기호 값을 판단하여 스타일을 변환하는 FUNCTION
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : upDownCss2(fid, value, '&', true, true) ->  
		 * @param fid : 셀렉터
		 * @param value : 데이터
		 * @param unit : 부호(ex. % 등)
		 * @param sign : +, - 표시 여부(true: 표시, false: 미표시)
		 * @param money : 금액형태(true: ',' 표시, false: 미표시)
		 * @return 
		 */
		upDownCss2: function(fid, value, unit, sign, money) {
			
			if(fid = this.chkFid(fid, value)){
			
				if(typeof sign == undefined || sign == null) sign = false;
				if(typeof money == undefined || money == null) money = true;
				if(typeof unit == undefined || unit == null) unit = '';
				
				var className = '';
				
				// 상승
				if(Number(value) > 0) {
					className = 'up_txt';
				// 하락
				} else if(Number(value) < 0) {
					className = 'low_txt';
				}
				
				if(!sign) {
					value = value.replace(/[+-]/g,'');
				}
				value = value.replace(/^\s+|\s+$/g, '');
		
				if(money) {
					value = value.commify();
				}
				
				this.$_selector.find(fid).text(value + unit).removeClass(this.removeCls).addClass(className);
			}
		},
		
		////////////////////////////////////////////////////////////////////////////////////
		/**
		 * Deco Cell => grid
		 */
		
		/**
		 * desc : 종목명등 문자
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : grid_text(value, optionColor) -> 
		 * @param value : 
		 * @param optionColor : 
		 * @return 
		 */
		grid_text: function(value, optionColor) {

			if(value) {
				var str=[];
				str.push('<div class="');
				str.push(optionColor);
				str.push('">');
				str.push(value);
				str.push('</div>');
				return str.join('');
				//return '<div class="' + optionColor + '">' + value + '</div>';
			}
		},
		
		/**
		 * desc : 일자(Y-m-d h:i:s)
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : grid_date(value, format) -> 
		 * @param value : 
		 * @param format : 
		 * @return 
		 */
		grid_date: function(value, format) {
			
			if(!format || format == '') {
				return getFmtDate(value, DATEFMT_HM24);
			}else{
				return getFmtDate(value, format);
			}
		},
		
		/**
		 * desc : 시간
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : grid_time(value, format) -> 
		 * @param value : 
		 * @param format : 
		 * @return 
		 */
		grid_time: function(value, format) {
			
			return getFmtTime(value);
		},
		
		/**
		 * desc : 통화(수량)
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : grid_mny(option, value, base) -> 
		 * @param option : 
		 * @param value : 
		 * @param base : 
		 * @return 
		 */
		grid_mny: function(option, value, base) {
			
			if(typeof value == 'number') {
				value.toString();
			}

			var colorCls = '';

			if(value == 0 || value == 0.0000) {
				value = (option.zero == 0) ? '' : value;  //기본값은 ''
			} else {
				colorCls = (option.color == 0) ? '' : this.getColorBySign(value, base);
				value = (option.sign == 1) ? value : value.replace(/^[+-]/, '');  // 기본값은 사인없음
				value = nexUtils.num2money(value); // 기본값은 색넣음
			}
			value = (isNotEmpty(value) && option.unit) ? value + ' ' + option.unit : value;  //기본값은 단위없음
			if(option.color == 0) {	// 색상을 지우는게 아니라 아무짓도 않하는거.
				return value;
			} else {
				var str=[];
				str.push('<div class="');
				str.push(colorCls);
				str.push('">');
				str.push(value);
				str.push('</div>');
				
				return str.join('');
				//return '<div class="' + colorCls + '">' + value + '</div>';
			}
		},
		
		/**
		 * desc : 일반통화(수량)표시
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : grid_money(value, option) -> 
		 * @param value : 
		 * @param option : 
		 * @return 
		 */
		grid_money: function(value, option) {
			
			option = $.extend({color:0, sign:1}, option);

			return this.grid_mny(option, value);
		},
		
		/**
		 * desc : 일반통화(수량)표시+색상 표시(부호)     signType 부호(+-)표시 ON/OFF
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : grid_moneyColor(value, base, option) -> 
		 * @param value : 가격 (*필수)
		 * @param base : 기준가(전일종가) (*필수)
		 * @param option : 
		 * @return 
		 */
		grid_moneyColor: function(value, base, option) {
			
			option = $.extend({color:1}, option);
			
			return this.grid_mny(option, value, base);
		},
		
		/**
		 * desc : 통화+색상+부호 표시
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : grid_moneyColorSign(signValue, option) -> 
		 * @param signValue : 부호포함 숫자(필요시 가공해서 사용)
		 * @param option : 
		 * @return 
		 */
		grid_moneyColorSign: function(signValue, option) {
			
			option = $.extend({sign:1}, option);
			
			return this.grid_mny(option, signValue);
		},
		
		/**
		 * desc : 일반통화(수량)+색상 표시       signType 부호(+-)표시 ON/OFF
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : grid_moneyColorBySign(signValue, option) -> 
		 * @param signValue : 부호포함한 값 (*필수)
		 * @param option : 
		 * @return 
		 */
		grid_moneyColorBySign: function(signValue, option) {
			
			option = $.extend({color:1}, option);
			
			return this.grid_mny(option, signValue);
		},
		
		/**
		 * desc : 일반통화(수량)+색상+기세부호 표시(pricePicker에서 사용)
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : grid_moneyArrow(value, base) -> 
		 * @param value : 가격 (*필수)
		 * @param base : 기준가(전일종가) (*필수)
		 * @return 
		 */
		grid_moneyArrow: function(value, base) {
			
			var option = {color:1, arrow:0};
			
			return this.grid_mny(option, value, base);
		},
		
		/**
		 * desc : 저가
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : grid_percent(value) -> 
		 * @param value : 
		 * @return 
		 */
		grid_percent: function (value){
			
			value = (value == '0.00') ? '0' : value;

			return value.replace(/^[+-]/, '') + '%';
		},
		
		/**
		 * desc : 
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : grid_percentBySign(value, option) -> 
		 * @param value : 
		 * @param option :
		 * @return 
		 */
		grid_percentBySign: function (value, option){
        
			value = (value == '0.00') ? 0 : value;

			var colorCls = this.getColorBySign(value);

			value = (option.sign == 1) ? value : Math.abs(value);  //기본값은 사인없음
			
			var str=[];
			str.push('<div class="');
			str.push(colorCls);
			str.push('">');
			str.push(value);
			str.push('%</div>');
			
			return str.join('');
			//return '<div class="' + colorCls + '">' + value + '%</div>'; 
		},
		
		/**
		 * desc : wrapper함수.
		 * date : 2015.07.24
		 * author : 이상우
		 * ex : grid_moneyMono(value, option) -> 
		 * @param value : 
		 * @param option :
		 * @return 
		 */
		grid_moneyMono: function(value, option) {
			return this.grid_money(value, option);
		}
	}
	
	window.nexBind = new nexBind();
})(window, jQuery)