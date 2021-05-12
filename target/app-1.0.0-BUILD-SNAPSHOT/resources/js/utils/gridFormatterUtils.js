/**
 * grid Formatter
 * @returns
 */

function Formatter() {
    var self = this;
	
    /**
	  	V1. VI발동
	    V2. VI해제     
	    R1. 시초동시    임의종료지정   RE발동
	    R2. 시초동시    임의종료해제   RE해제
	    R3. 마감동시    임의종료지정   RE발동
	    R4. 마감동시    임의종료해제   RE해제
	    R5. 시간외단일가임의종료지정   RE발동
	    R6. 시간외단일가임의종료해제   RE해제
	    viewType: ALL = 전체, TEXT = 발동/해제, TIME = 시간
	*/
    this.viText = function(data, viewType) {
    	
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
    };
    
    /**
     * 계좌번호(XXXXXXXX-XX)
     * 계좌번호(XXXXXXXXXX-XX) 
     */
    this.acctNoFormat = function(val) {

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
	};
    
    /**
	 * 날짜
	 * ui: 그리드 데이터(8자리 데이터, yyyymmdd)
	 * viewType: 날짜표현 형태(yyyymmdd: 20140707, yyyymm: 201407, mmdd: 0707), default: yyyymmdd
	 * pDelimiter: 구분자, default: '/'
	 */
	this.dateFormat = function(val, viewType, pDelimiter) {

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
	};

	/**
	 * 날짜
	 * ui: 그리드 데이터(8자리 데이터, yyyymmdd)
	 * viewType: 날짜표현 형태(yyyymmdd: 20140707, yyyymm: 201407, mmdd: 0707), default: yyyymmdd
	 * pDelimiter: 구분자, default: '/'
	 * baseValue: 비교값
	 * className: 비교값과 일치하는 경우에 추가할 className
	 */
	this.dateFormatAddClass = function(ui, viewType, pDelimiter, baseValue, className) {

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
	};

	/**
	 * 시간
	 * ui: 그리드 데이터(6자리 데이터, hhmmss)
	 * viewType: 날짜표현 형태(hhmmss: 182020, hhmm: 1820, mmss: 2020), default: hhmmss
	 * pDelimiter: 구분자, default: ':'
	 */
	this.timeFormat = function(val, viewType, pDelimiter) {

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
	};

    /**
     * 콤마를 붙인 숫자타입
     * default : 소수점 0자리
     */
    this.numberFormat = function(ui) {
        if (arguments.length < 2) {
            return $.util.numberFormat( ui.rowData[ui.dataIndx], 0);
        } else {
            return $.util.numberFormat( ui.rowData[ui.dataIndx], arguments[1]);
        }
    };

    /**
     * 콤마를 붙인 소수점 2자리의 숫자타입
     */
    this.numberFormat2 = function(ui) {
        return self.numberFormat(ui, 2);
    };

    /**
     * 콤마를 붙인 숫자타입
     * 양수/음수 기준으로 색상지정
     */
    this.numberFormatUpDownCss = function(ui) {
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
    };

    /**
     * 콤마를 붙인 소수점 2자리의 숫자타입
     * 양수/음수 기준으로 색상지정
     */
    this.numberFormatUpDownCss2 = function(ui) {
        return self.numberFormatUpDownCss(ui, 2);
    };

	/**
     * 콤마를 붙인 숫자타입
     * 양수/음수 기준으로 색상지정, 등락 삼각형 추가
     */
    this.numberFormatUpDownArrCss = function(ui) {
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
    };

    /**
     * 콤마를 붙인 숫자타입
     * 양수/음수 기준으로 색상지정, 퍼센트(%) 추가
     */
    this.numberFormatUpDownPercentCss = function(ui) {
        return self.numberFormatUpDownCss(ui) + '%';
    };
    
    /**
     * 콤마를 붙인 소수점 2자리의 숫자타입
     * 양수/음수 기준으로 색상지정, 퍼센트(%) 추가
     */
    this.numberFormatUpDownArrCss2 = function(ui) {
        return self.numberFormatUpDownCss(ui, 2) + '%';
    };

	/**
	 * 앞에 '0'제거
	 */
	this.toNum = function(ui) {
		return String(Number(ui.rowData[ui.dataIndx]));
	};

	/**
     * 매매구분(매수, 매도)에 색상지정
     */
    this.sectNameCss = function(ui) {
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
    };

	/**
	 * 금액형태로 표시(3자리마다 ',' 처리)
	 */
	this.commify = function(val) {

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
	};


	/**
	 * %, 억 등 추가
	 * val: 데이터 그리드 or 값
	 * unit: %, 억 등
	 * money: true: 3자리마다 ',', false: 컴마 X 
	 */
	this.addUnit = function(val, unit, money) {

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
	};
	
	/**
	 * 대비값(전일대비부호) 기준으로 스타일 적용하는 function
	 * ui : 그리드 데이터
	 * unit : 부호(ex. % 등)
	 * sign : +, - 표시 여부(true: 표시, false: 미표시)
	 * money : 금액형태(true: ',' 표시, false: 미표시)
	 * zeroShow : 0일 경우 표시 유무(true: 0 표시, false: 미표시)
	 * fixedNum : 소수점 처리
	 */
	this.addUnitPoint = function(ui, unit, sign, money, zeroShow, fixedNum) {
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
	};

	/**
	 * 대비값(전일대비부호) 기준으로 스타일 적용하는 function
	 * val : 값
	 * edaily : edaily 등락구분 사용(true: 사용, false: 기존 등락구분 사용)
	 * gubun : 등락구분
	 * sign : +, - 표시 여부(true: 표시, false: 미표시)
	 * money : 금액형태(true: ',' 표시, false: 미표시)
	 * arrYn : 등락부호 유무 (Y:있음, N:없음)
	 * unit : 부호(ex. % 등)
	 * fixedNum : 소수점 처리
	 */
	this.edailyUtilsUpDownCss = function(_selector, val, edaily, gubun, sign, money, arrYn, unit, fixedNum) {
		
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
	};
	
	
	/**
	 * 대비값(전일대비부호) 기준으로 스타일 적용하는 function
	 * ui : 그리드 데이터
	 * arrYn : 등락부호 유무 (Y:있음, N:없음)
	 * unit : 부호(ex. % 등)
	 * sign : +, - 표시 여부(true: 표시, false: 미표시)
	 * money : 금액형태(true: ',' 표시, false: 미표시)
	 * zeroShow : 0일 경우 표시 유무(true: 0 표시, false: 미표시)
	 * gubunVal : 등락부호가 복수로 존재 할 경우 (ui.rowData[gubunVal]) 2014.08.04 TD0334 김영철
	 */
	this.upDownArrCss = function(ui, arrYn, unit, sign, money, zeroShow, gubunVal, fixedNum) {
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
	};

	/**
	 * 입력값 기준으로 양수, 음수를 판단해서 스타일을 변환하는 FUNCTION
	 * val : 그리드 데이터
	 * unit : 부호(ex. % 등)
	 * sign : +, - 표시 여부(true: 표시, false: 미표시)
	 * money : 금액형태(true: ',' 표시, false: 미표시)
	 * _selector : 셀렉터
	 * point : toFixed(point) 
	 */
	this.upDownCss = function(val, unit, sign, money, _selector, point) {

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
	};

	/**
	 * 기준값 대상으로 스타일을 씌워야 하는경우 사용되는 FUNCTION
	 * ui : 그리드 데이터
	 * basicVal : 기준값
	 * unit : 부호(ex. % 등)
	 * sign : +, - 표시 여부(true: 표시, false: 미표시)
	 * money : 금액형태(true: ',' 표시, false: 미표시)
	 * calbasicVal : 계산된 기준가
	 */
	this.compareCss = function(ui, basicVal, unit, sign, money,calbasicVal) {

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
	};

	/**
	 * 입력값 기준에 +, - 기호 값을 판단하여 스타일을 변환하는 FUNCTION
	 * ui : 그리드 데이터
	 * unit : 부호(ex. % 등)
	 * sign : +, - 표시 여부(true: 표시, false: 미표시)
	 * money : 금액형태(true: ',' 표시, false: 미표시)
	 */
	this.upDownSignCss = function(ui, unit, sign, money) {

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
	};

///////////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * DecoCell
	 */

	this.fid5 = null;   //상승하락설정    (시세50에서 사용)
    this.fid60 = null;  //기준가          (시세50에서 사용)

    this.upDownCls = ""; //+-에 대한 색상
    this.upDownTxt = "보합";  //[상한,상승,보합,하락,하한] 텍스트

    this.upDownArwCls = "";  //상한/하한 화살표 클래스
    this.upDownArwBCls= "";


    /**
     * up_arr 상승(위삼각형), upper_arr 상한(위화살표), up_txt 빨간색
     * low_arr 하락(아래삼각형), lower_arr 하한(아래 화살표), low_txt 파란색
     */
    this.removeCls = 'up_arr upper_arr up_txt low_arr lower_arr low_txt';
    this.removeBCls = 'up_b_arr upper_b_arr up_txt low_b_arr lower_b_arr low_txt';

    this.buySellColored ="black";

    this.$_selector;

	// 셀렉터 set
	this.setSelector = function($_selector) {
		this.$_selector = $($_selector);
	};

	// 셀렉터로 가공후 다시 리턴받고 싶을때
    this.getSelector = function() {
        return this.$_selector;
    };

    // 종목명등 문자
    this.text = function(fid, value, optionColor) {
    	
    	if(optionColor == undefined || optionColor == null) {
    		optionColor = '';
    	}
    	
        // if(value) {
            fid = isString(fid) ? fid:'.fid' + fid;
            // $(fid, this.$_selector).html(value).removeClass("up_txt low_txt").addClass(optionColor);
            this.$_selector.find(fid).html(value).removeClass("up_txt low_txt").addClass(optionColor);
        // }
    };

    //fid5를 입력하지 않는경우 value에 따른 색상을 결정한다.
    this.getColorBySign = function(value, base) {

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
    };

    this.chkFid = function(fid, value) {
        if(value != undefined) {
            fid = isString(fid) ? fid : '.fid' + fid;
            // if($(fid, this.$_selector).length == 0) { 
            if(this.$_selector.find(fid).length == 0) {
            	return false;
            }
            return fid;
        } else {
            return false;
        }
    };

    // base값을 결정한다.
    this.getBasePrice = function(base) {
        var baseValue;
        if(base){
            baseValue = base;
        } else {
            baseValue = this.fid60;
        }
        return baseValue;
    };

    // 전일대비부호
	this.setFid5 = function(fid5) {

        if(fid5 == undefined){
            return;
        }

        this.fid5 = fid5;

        switch (fid5) {
	        case '7':
	            this.upDownTxt = "상한", this.upDownCls ="up_txt", this.upDownArwCls =" upper_arr up_txt",this.upDownArwBCls ="upper_b_arr up_txt";break;
	        case '6':
	            this.upDownTxt = "상승", this.upDownCls ="up_txt", this.upDownArwCls ="up_arr up_txt",this.upDownArwBCls ="up_b_arr up_txt";break;
	        case '5':
	            this.upDownTxt = "보합", this.upDownCls ="",       this.upDownArwCls ="",this.upDownArwBCls ="";break;
	        case '4':
	            this.upDownTxt = "하락", this.upDownCls ="low_txt",this.upDownArwCls ="low_arr low_txt",this.upDownArwBCls ="low_b_arr low_txt";break;
	        case '3':
	            this.upDownTxt = "하한", this.upDownCls ="low_txt",this.upDownArwCls ="lower_arr low_txt",this.upDownArwBCls ="lower_b_arr low_txt";break;
	        case '0':
	            this.upDownTxt = "", this.upDownCls ="",this.upDownArwCls ="",this.upDownArwBCls ="";break;
	        default:
	            this.upDownCls ="";
	            this.upDownArwCls ="";
	            break;
        }
    };

    // 체결강도
    this.setFid10 = function(fid10) {
        if(isNaN(fid10)){
            return;
        }

        if(Object.prototype.toString.call(fid10) == '[object String]') {
            fid10 = Number(fid10);
        }

        this.fid10 = fid10;
    };

    this.setFid60 = function(fid60) {
        if(isNaN(fid60)) {
            return;
        }

        if(Object.prototype.toString.call(fid60) == '[object String]') {
            fid60 = Number(fid60);
        }
        this.fid60 = fid60;
    };

    this.setFid60B = function(fid60) {
        if(isNaN(fid60)) {
            return;
        }
        this.fid60 = fid60;
    };

    /**
     * 시세에 기준가가없을경우 계산해서 리턴시킴
     * TODO TD0334-김영철
     */
    this.setFid60Calt = function(fid4, fid6) {
        if(isNaN(fid4)){
            return;
        }
        if(isNaN(fid6)){
            return;
        }

        var T = Number('1e' + 1);
        var fid60 = Math.round( (fid4 - fid6 ) * T ) / T ;

        this.fid60 = fid60;
    };


    this.fid4 = function (fid, value, option, sign){
    	
    	if(sign == undefined || sign == null) sign = false;
    	if(option == null || option == undefined) option = {sign:0};
    	if(option.sign == null || option.sign==undefined) option = $.extend({sign:0}, option);
    	
    	if(fid = this.chkFid(fid, value)){
    		
    		var $select_obj = this.$_selector.find(fid);
    		
    		if(!this.fid5){
                $select_obj.removeClass(this.removeCls).text(num2money(value.replace(/^[+-]/,'')));
                return;
            }
            
    		// 부호없지만 fid5값이 하락일때
    		if(this.fid5 < 5 && value > 0 && sign) {
                value = '-' + value;
    		}

    		if(!sign && option.sign != 1) {
    	    	value = value.replace(/[+-]/g,'');
    	    }
    		
            $select_obj.removeClass(this.removeCls).addClass(this.upDownCls).text(value.commify());            
        }
    };

    // 대비(화살표+색상+부호제거)fid5가 반드시 필요
    this.fid6 = function (fid, value){
        if(fid = this.chkFid(fid, value)){
            if(this.fid5 == null){
                return;
            }
            var $select_obj = this.$_selector.find(fid);
            
            var str = [];
            str.push('<span class="screen_out">');
            str.push(this.upDownTxt);
            str.push('</span>');
            str.push(num2money(value.replace(/^[+-]/,'')));

            $select_obj.html('').removeClass(this.removeCls).addClass(this.upDownArwCls +' '+ this.upDownCls).append(str.join(''));
        }
    };

    // 대비(화살표+색상+부호제거)fid5가 반드시 필요
    this.fid6B = function (fid, value){
        if(fid = this.chkFid(fid, value)){
            if(!this.fid5){
                return;
            }
            
            var $select_obj = this.$_selector.find(fid);
            
            var class_str = [];
            class_str.push(this.upDownArwBCls);
            class_str.push(this.upDownCls);
            
            $select_obj.html('').removeClass(this.removeBCls).addClass(class_str.join('')).append(num2money(value.replace(/^[+-]/,'')));
        }
    };

    /**
     * 등락비율 +-00.00 %
     * option color:색상ON/OFF
     * option sign:+-부호ON/OFF
     * option unit:%(혹은 단위) 부호ON/OFF
     */
    this.fid7 = function (fid, value, option){
        option = $.extend({color:0}, option);

        return this.f7(fid, option, value);
    };

    this.f7 = function (fid, option, value, basePrice) {

    	if(fid = this.chkFid(fid, value)){
            var perValue = basePrice ? dayPer(basePrice, value) : value;
            var colorCls = '';

            if(option.color == 0) {
            	colorCls = '';
            } else if(option.color == 2) {
            	var tempVal = perValue;
                tempVal = (typeof tempVal == "string") ? parseFloat(tempVal) : '';

                if(tempVal > 0) {
                    colorCls = 'up_txt';
                } else if(tempVal < 0) {
                	colorCls = 'low_txt';
                }
            } else {
                colorCls = this.getColorBySign(perValue);  //기본값은 사인없음
            }
            
            if(perValue != null) {
                perValue = (option.sign == 1) ? perValue : perValue.replace(/^[+-]/,'');  //기본값은 사인없음.Math.abs사용금지 자리수가 변경됨
                perValue = num2money(perValue);//기본값은 색넣음
                perValue = (option.unit == 0) ? perValue : perValue + ' %';
            }

            var $select_obj = this.$_selector.find(fid);
            $select_obj.html('').removeClass(this.removeCls).addClass(colorCls).append(perValue);
        }
    };

    /**등락비율,색표시 없음 +-00.00 %
     * value:가격, basePrice:기준가(전일종가)
     * signType 부호(+-)표시 ON/OFF
     */
    this.fid7Mono = function (fid, value, basePrice, option){
        option = $.extend({color:0}, option);

        return this.f7(fid, option, value, basePrice);
    };

    /**등락비율,색상 +-00.00 %
     * value:가격, basePrice:기준가(전일종가)
     * signType 부호(+-)표시 ON/OFF
     */
    this.fid7Color = function (fid, value, basePrice, option){
        option = $.extend({color:1}, option);

        return this.f7(fid, option, value, basePrice);
    };

    /** 체결강도,색상
     * value:가격, basePrice:기준가(전일종가)
     * signType 부호(+-)표시 ON/OFF
     */
    this.fid407 = function (fid, value, option){
        if(fid = this.chkFid(fid, value)){

        	if(this.fid10 == null){
                return;
            }

            option = $.extend({color:1}, option);

            value = Number(value);

            if(this.fid10 == 2){
                return this.moneyColorBySign(fid, value, option);
            } else if(this.fid10 == 4){
                value = -1 * value;
                return this.moneyColorBySign(fid, value, option);
            } else {
                return this.moneyMono(fid, value, option);
            }
        }
    };

    /**
     * 등락비율,색상 +-00.00 %
     * signValue 부호포함한 값만 입력
     * signType 부호(+-)표시 ON/OFF
     */
    this.fid7ColorBySign = function (fid, signValue, option) {
        option = $.extend({color:1}, option);
        return this.f7(fid, option, signValue);
    };

    // fid1에 상세보기 이벤트를 추가.
    this.fid1nDetail = function (selector, fid1, fid3, popupid){
        return this.fid1Clicker(selector, fid1, fid3, 'stock', popupid);
    };

    //fid1에 상세보기 이벤트를 추가. 미사용, 차후 확인후 삭제 필요.
    this.fid1Clicker = function (selector, fid1, fid3, market, popupid){

    	if(selector = this.chkFid(selector, fid1)){

    		var $select_obj = this.$_selector.find(selector);
            // 2014-07-12 변만복, 수정 필요 getCtr변경 필요
    		var str=[];
    		str.push('getWin(this).clickCode("');
    		str.push(fid3);
    		str.push('","');
    		str.push(market);
    		str.push('")');

    		$select_obj.html().attr({'title': fid3, 'onclick': str.join('')}).append(fid1.replace(/^[+-]/,''));
        }
    };

    //종목명.(종목명+종목번호 title로 표시)
    this.fid1 = function (selector, fid1, fid3, popupid){
        if(selector = this.chkFid(selector, fid1)){

            this.$_selector.find(selector).text(fid1.replace(/^[+-]/,'')).attr('title', fid3);
        }
    };

    // 일자(Y-m-d h:i:s)
    this.date = function(fid, value, format) {
        if(fid = this.chkFid(fid, value)) {
            if(!format || format == '') {
                this.$_selector.find(fid).text(getFmtDate(value, DATEFMT_HM24));
            } else {
                this.$_selector.find(fid).text(getFmtDate(value, format));
            }
        }
    };

    /**
     * 이론가
     * 기초자산*(1+금리/100*잔존일수/365.0)-미래가치
     * */
    this.fid112 = function(fid, deCaount, cdE, Eday, fuVal, format) {
        if(deCaount != undefined || cdE != undefined || Eday != undefined || fuVal != undefined) {
            fid = isString(fid) ? fid : '.fid' + fid;
            var result = deCaount * (1 + cdE / 100 * Eday / 365.0) - fuVal;
            this.moneyColorByfid60B(fid, result.toFixed(2));
        }
    };

    // 시간
    this.time = function(fid, value, format) {
        if(fid = this.chkFid(fid, value)) {
            this.$_selector.find(fid).text(getFmtTime(value));
        }
    };

    //통화(수량)
    this.mny = function(fid, option, value, base) {
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
    };
    
    this.targetpricesise = function (fid,value,price,gbn, mode){
    	
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
    	
    };
    
    this.targetpricehoga = function (fid,value){
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
    };

    //사용안함. 오류
    this.moneyByfid5Color = function(fid, value, option) {

    	// 예상가등에서 사용
        return this.fid4(fid, value, option);
    };

    /**통화(수량)표시.기준가로 색상표시
     * signType 부호(+-)표시 ON/OFF
     */
    this.moneyColorByfid60 = function(fid, value, option) {

    	if (this.fid60 != 0 && (this.fid60 == null || this.fid60 == undefined || this.fid60 =='')){
    		return;
        }

        option = $.extend({color:1}, option);

        return this.mny(fid, option, value, this.fid60);
    };

    /**통화(수량)표시.기준가로 색상표시
     * 소수점일 경우에만 사용
     * signType 부호(+-)표시 ON/OFF
     */
    this.moneyColorByfid60B = function(fid, value, option) {
        option = $.extend({color:1}, option);

        return this.mny(fid, option, value, this.fid60);
    };

    /**일반통화(수량)표시
     */
    this.money = function(fid, value, option) {
        option = $.extend({color:0, sign:1}, option);

        return this.mny(fid, option, value);
    };

    /**
     * 일반통화(수량)표시+색상 표시(부호)
     * 필수:value:가격, base:기준가(전일종가)
     * signType 부호(+-)표시 ON/OFF
     */
    this.moneyColor = function(fid, value, base, option) {
        option = $.extend({color:1}, option);
        return this.mny(fid, option, value, base);
    };

    /**
     * 통화+색상+부호 표시
     * fid
     * signValue 부호포함 숫자(필요시 가공해서 사용)
     */
    this.moneyColorSign = function(fid, signValue, option) {
        option = $.extend({sign:1}, option);
        return this.mny(fid, option, signValue);
    };

    /**일반통화(수량)+색상 표시
     * 필수:signValue 부호포함한 값
     * signType 부호(+-)표시 ON/OFF
     */
    this.moneyColorBySign = function(fid, signValue, option) {
        option = $.extend({color:1}, option);
        return this.mny(fid, option, signValue);
    };

    /**일반통화(수량)+색상+기세부호 표시(pricePicker에서 사용)
     * 필수:value:가격, base:기준가(전일종가)
     */
    this.moneyArrow = function(fid, value, base) {
        var option = {color:1, arrow:0};
        return this.mny(fid, option, value, base);
    };

    //저가
    this.percent = function (fid, value){
        if(fid = this.chkFid(fid, value)){

        	value = (value == '0.00') ? '0' : value;

            this.$_selector.find(fid).text(value.replace(/^[+-]/,'') +'%');
        }
    };

    this.percentBySign = function (fid, value, option){
        if(fid = this.chkFid(fid, value)){

        	value = (value == '0.00') ? 0:value;

            var colorCls = this.getColorBySign(value) ;

            value = (option.sign == 1) ? value : Math.abs(value);  //기본값은 사인없음
            this.$_selector.find(fid).text(value + '%').removeClass(this.removeCls).addClass(colorCls);
        }
    };

  	// 2807 시장조치명
    this.fid2807 = function (fid, value){
        if(fid = this.chkFid(fid, value)){
        	var $sel = this.$_selector.find(fid); 
        	$sel.removeClass("g1 g2 g3 g4 g5 g6 g7 g8 g9 g10 g11 g12 g13 g15");

        	switch(value) {
        		case '11': $sel.text("증").addClass("g8").attr("title","증거금률100%"); break;
        		case '12': $sel.text("증").addClass("g1").attr("title","증거금률40%"); break;
        		case '13': $sel.text("증").addClass("g9").attr("title","증거금률30%"); break;
        		case '2': $sel.text("관").addClass("g3").attr("title","관리종목"); break;
        		case '5': $sel.text("주").addClass("g6").attr("title","투자주의"); break;
        		case '1': $sel.text("정").addClass("g15").attr("title","거래정지"); break;
        		case '14': $sel.text("정").addClass("g11").attr("title","정리매매"); break;
        		case '4': $sel.text("경").addClass("g5").attr("title","투자경고"); break;
        		case '8': $sel.text("신").addClass("g10").attr("title","신용보증금률50%"); break;
        		case '9': $sel.text("신").addClass("g2").attr("title","신용보증금률45%"); break;
        		case '15': $sel.text("불").addClass("g4").attr("title","불성실공시"); break;
        		case '17': $sel.text("환").addClass("g7").attr("title","투자주의환기"); break;
        		case '18': $sel.text("과").addClass("g13").attr("title","단기과열"); break;
        		case '3': $sel.text("위").addClass("g12").attr("title","투자위험"); break;
        		default:
        			$sel.text(""); break;
        	}
            // 예: 투자위험예고 g14
        }
    };

    //250 증거금
    this.fid250 = function (fid, value, gubun){
        if(fid = this.chkFid(fid, value)) {
        	
        	var $sel = this.$_selector.find(fid);
        	
            if(gubun == "1") {
            	$sel.removeClass("d1 d2").text(value).addClass("d1");
            } else if(gubun == "2") {
            	$sel.removeClass("d1 d2").text(value).addClass("d2");
            } else {
            	$sel.removeClass("d1 d2").text(value);
            }
        }
    };

    this.fid000 = function(fid, value) {
        return this.fid2807(fid, value);
    };

    this.fid500 = function(fid, value, format) {
        return this.date(fid, value, format);
    };

    this.fid300 = function(value, format) {
        return this.time(300, value, format);
    };

    // wrapper함수.
    this.moneyMono = function(fid, value,option) {
        return this.money(fid, value,option);
    };

    this.getText = function (fid) {
    	return this.$_selector.find(fid).text();
    };

    /**
	 * 입력값 기준에 +, - 기호 값을 판단하여 스타일을 변환하는 FUNCTION
	 * fid : 셀렉터
	 * value : 데이터
	 * unit : 부호(ex. % 등)
	 * sign : +, - 표시 여부(true: 표시, false: 미표시)
	 * money : 금액형태(true: ',' 표시, false: 미표시)
	 */
    this.upDownCss2 = function(fid, value, unit, sign, money) {
    	
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
    };
    
////////////////////////////////////////////////////////////////////////////////////
    
    /**
     * Deco Cell => grid
     */
    
    // 종목명등 문자
    this.grid_text = function(value, optionColor) {

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
    };


    /**
     * unit : '%' 등 단위
     */
    this.grid_fid4 = function (fid5, value, unit) {
        
    	if(unit == undefined || unit == null) {
    		unit = '';
    	}
    	
    	this.setFid5(fid5);
    	
        if(!this.fid5) {
            return value;
        }
        // 부호없지만 fid5값이 하락일때
        if(this.fid5 < 5 && value > 0) {
        	var value_str=[];
        	value_str.push('-');
        	value_str.push(value);
        	value = value_str.join('');
        }
        
        var str=[];
        str.push('<div class="');
        str.push(this.upDownCls);
        str.push('">');
        str.push(num2money(String(value).replace(/^[+-]/,'')));
        str.push(unit);
        str.push('</div>');
        return str.join('');
        //return '<div class="' + this.upDownCls + '">' + num2money(String(value).replace(/^[+-]/,'')) + unit + '</div>';
    };

    // 대비(화살표+색상+부호제거)fid5가 반드시 필요
    this.grid_fid6 = function (fid5, value, style) {
        
    	if(style == undefined || style == null) {
    		style = true;
    	}
    	
    	this.setFid5(fid5);
    	
        if(!this.fid5) {
            return value;
        }
        
        var str=[];
        str.push('<div class="');        
        str.push(this.upDownArwCls);
        str.push(' ');
        str.push(this.upDownCls);
        
        if(style) {
        	str.push('" style="width:100%; height:20px; line-height:20px"');
        }
        str.push('>');
        str.push(num2money(String(value).replace(/^[+-]/,'')));
        str.push('</div>');
        
        return str.join('');        
        //return '<div class="' + this.upDownArwCls +' '+ this.upDownCls + '" style="width:100%; height:20px; line-height:20px">' + num2money(String(value).replace(/^[+-]/,'')) + '</div>';
    };

    // 대비(화살표+색상+부호제거)fid5가 반드시 필요
    this.grid_fid6B = function (fid5, value) {
    	
    	this.setFid5(fid5);
    	
        if(!this.fid5) {
            return value;
        }
        var str=[];
        str.push('<div class="');        
        str.push(this.upDownArwBCls);
        str.push(' ');
        str.push(this.upDownCls);
        str.push('">');
        str.push(num2money(String(value).replace(/^[+-]/,'')));
        str.push('</div>');
        
        return str.join('');
        //return '<div class="' + this.upDownArwBCls +' '+ this.upDownCls + '">' + num2money(String(value).replace(/^[+-]/,'')) + '</div>';
    };

    /**
     * 등락비율 +-00.00 %
     * option color:색상ON/OFF
     * option sign:+-부호ON/OFF
     * option unit:%(혹은 단위) 부호ON/OFF
     */
    this.grid_fid7 = function (value, option) {
        
    	option = $.extend({color:0}, option);

        return this.grid_f7(option, value);
    };

    this.grid_f7 = function (option, value, basePrice) {
    	
        var perValue = basePrice ? dayPer(basePrice ,value) : value;
        var colorCls = '';

        if(option.color == 0) {
        	colorCls = '';
        } else if(option.color == 2 ) {

        	var tempVal = perValue;
            tempVal = (typeof tempVal == "string") ? parseFloat(tempVal) : '';

            if(tempVal > 0){
                colorCls = 'up_txt';
            }else if(tempVal < 0){
                colorCls = 'low_txt';
            }
        } else {
            colorCls = this.getColorBySign(perValue) ;  // 기본값은 사인없음
        }

        if(perValue != null) {
            perValue = (option.sign == 1) ? perValue : String(perValue).replace(/^[+-]/, '');  // 기본값은 사인없음.Math.abs사용금지 자리수가 변경됨
            perValue = num2money(perValue); // 기본값은 색넣음
            perValue = (option.unit == 0) ? perValue : perValue + ' %';
        }

        var str=[];
        str.push('<div class="');        
        str.push(colorCls);
        str.push('">');
        str.push(perValue);
        str.push('</div>');
        
        return str.join('');
        //return '<div class="' + colorCls + '">' + perValue + '</div>';
    };

    /**등락비율,색표시 없음 +-00.00 %
     * value:가격, basePrice:기준가(전일종가)
     * signType 부호(+-)표시 ON/OFF
     */
    this.grid_fid7Mono = function (value, basePrice, option) {
        option = $.extend({color:0}, option);

        return this.grid_f7(option, value, basePrice);
    };

    /**등락비율,색상 +-00.00 %
     * value:가격, basePrice:기준가(전일종가)
     * signType 부호(+-)표시 ON/OFF
     */
    this.grid_fid7Color = function (value, basePrice, option) {
        option = $.extend({color:1}, option);

        return this.grid_f7(option, value, basePrice);
    };

    /** 체결강도,색상
     * value:가격, basePrice:기준가(전일종가)
     * signType 부호(+-)표시 ON/OFF
     */
    this.grid_fid407 = function (fid10, value, option) {
        
    	this.setFid10(fid10);

    	if(!this.fid10) {
            return;
        }

        option = $.extend({color:1}, option);

        value = Number(value);

        if(this.fid10 == 2) {
            
        	return this.grid_moneyColorBySign(value, option);
        
        } else if(this.fid10 == 4) {
            
        	value = -1 * value;
            return this.grid_moneyColorBySign(value, option);
        
        } else {
            return this.grid_moneyMono(value, option);
        }
    };

    /**
     * 등락비율,색상 +-00.00 %
     * signValue 부호포함한 값만 입력
     * signType 부호(+-)표시 ON/OFF
     */
    this.grid_fid7ColorBySign = function (signValue, option) {
        
    	option = $.extend({color:1}, option);
        
    	return this.grid_f7(option, signValue);
    };

    /**
     * fid1에 상세보기 이벤트를 추가.
     * ctrl : 컨트롤 번호 "" 포함해서 넘기기
     */
    this.grid_fid1nDetail = function (fid1, fid3, popupid, ctrl) {
        return this.grid_fid1Clicker(fid1, fid3, 'stock', popupid, ctrl);
    };


    /**
     * fid1에 상세보기 이벤트를 추가.
     * ctrl : 컨트롤 번호 "" 포함해서 넘기기
     */
    this.grid_fid1Clicker = function (fid1, fid3, market, popupid, ctrl) {
        //this.fid1(selector, fid1, fid3, {detail:popupid});
    	
    	// " -> ' 로 변환 처리
    	if(ctrl != undefined && ctrl != null && ctrl != '') {
    		if(ctrl.indexOf('"') != -1) {
    			ctrl = ctrl.replace(/\"/g, "'").trim();
    		} 
    		
    		if(ctrl.indexOf("'") == -1) {
    			var ctrl_str=[];
    			ctrl_str.push("'");
    			ctrl_str.push(ctrl.trim());
    			ctrl_str.push("'");
    			
    			ctrl=ctrl_str.join('');
    			//ctrl = "'" + ctrl.trim() + "'";
    		}
    	}
    	
    	var str=[];
    	str.push("<div title=\"");
    	str.push(fid3);
    	str.push("\" onclick=\"getCtrl(");
    	str.push(ctrl);
    	str.push(").clickCode('");
    	str.push(fid3);
    	str.push("', '");
    	str.push(market);
    	str.push("');\">");
    	str.push(num2money(fid1.replace(/^[+-]/, '')));
    	str.push("</div>");
    	
    	return str.join('');
    	//return "<div title=\"" + fid3 + "\" onclick=\"getCtrl(" + ctrl + ").clickCode('" + fid3 + "', '" + market + "');\">" + num2money(fid1.replace(/^[+-]/, '')) + "</div>";
                
    };

    //종목명.(종목명+종목번호 title로 표시)
    this.grid_fid1 = function (fid1, fid3) {

    	var str=[];
    	str.push('<div title="');
    	str.push(fid3);
    	str.push('">');
    	//str.push(num2money(fid1.replace(/^[+-]/,'')));
    	str.push(fid1);
    	str.push('</div>');
    	
    	return str.join('');
    };

    // 일자(Y-m-d h:i:s)
    this.grid_date = function(value, format) {
        
        if(!format || format == '') {
            return getFmtDate(value, DATEFMT_HM24);
        }else{
            return getFmtDate(value, format);
        }
    };

    /**
     * 이론가
     * 기초자산*(1+금리/100*잔존일수/365.0)-미래가치
     * */
    this.grid_fid112 = function(deCaount, cdE, Eday, fuVal, format) {
    	
        if(deCaount != undefined || cdE != undefined || Eday != undefined || fuVal != undefined) {
            
        	var result = deCaount * (1 + cdE / 100 * Eday / 365.0) - fuVal;
            
        	return this.grid_moneyColorByfid60B(result.toFixed(2));
        }
    };

    // 시간
    this.grid_time = function(value, format) {
        
        return getFmtTime(value);
    };

    //통화(수량)
    this.grid_mny = function(option, value, base) {
        
        if(typeof value == 'number') {
            value.toString();
        }

        var colorCls = '';

        if(value == 0 || value == 0.0000) {
            value = (option.zero == 0) ? '' : value;  //기본값은 ''
        } else {
            colorCls = (option.color == 0) ? '' : this.getColorBySign(value, base);
            value = (option.sign == 1) ? value : value.replace(/^[+-]/, '');  // 기본값은 사인없음
            value = num2money(value); // 기본값은 색넣음
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
    };

    //사용안함. 오류
    this.grid_moneyByfid5Color = function(fid5, value, unit) {

    	// 예상가등에서 사용
        return this.grid_fid4(fid5, value, unit);
    };

    /**통화(수량)표시.기준가로 색상표시
     * signType 부호(+-)표시 ON/OFF
     */
    this.grid_moneyColorByfid60 = function(fid60, value, option) {

    	this.setFid60(fid60);
    	
    	option = $.extend({color:1}, option);

        return this.grid_mny(option, value, this.fid60);
    };

    /**통화(수량)표시.기준가로 색상표시
     * 소수점일 경우에만 사용
     * signType 부호(+-)표시 ON/OFF
     */
    this.grid_moneyColorByfid60B = function(fid60, value, option) {
    	
        option = $.extend({color:1}, option);

        this.setFid60(fid60);
        
        return this.grid_mny(option, value, this.fid60);
    };

    /**일반통화(수량)표시
     */
    this.grid_money = function(value, option) {
        
    	option = $.extend({color:0, sign:1}, option);

        return this.grid_mny(option, value);
    };

    /**
     * 일반통화(수량)표시+색상 표시(부호)
     * 필수:value:가격, base:기준가(전일종가)
     * signType 부호(+-)표시 ON/OFF
     */
    this.grid_moneyColor = function(value, base, option) {
        
    	option = $.extend({color:1}, option);
        
    	return this.grid_mny(option, value, base);
    };

    /**
     * 통화+색상+부호 표시
     * fid
     * signValue 부호포함 숫자(필요시 가공해서 사용)
     */
    this.grid_moneyColorSign = function(signValue, option) {
        
    	option = $.extend({sign:1}, option);
        
    	return this.grid_mny(option, signValue);
    };

    /**일반통화(수량)+색상 표시
     * 필수:signValue 부호포함한 값
     * signType 부호(+-)표시 ON/OFF
     */
    this.grid_moneyColorBySign = function(signValue, option) {
        
    	option = $.extend({color:1}, option);
        
    	return this.grid_mny(option, signValue);
    };

    /**일반통화(수량)+색상+기세부호 표시(pricePicker에서 사용)
     * 필수:value:가격, base:기준가(전일종가)
     */
    this.grid_moneyArrow = function(value, base) {
        
    	var option = {color:1, arrow:0};
        
    	return this.grid_mny(option, value, base);
    };

    //저가
    this.grid_percent = function (value){
        
    	value = (value == '0.00') ? '0' : value;

        return value.replace(/^[+-]/, '') + '%';
    };

    this.grid_percentBySign = function (value, option){
        
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
    };

    this.grid_fid2807 = function (value){
        	
    	var html = ''; 
    	switch(value) {
    		case '11': html = '<div class="gubun g8" title="증거금률100%">증</div>'; break;
    		case '12': html = '<div class="gubun g1" title="증거금률40%">증</div>'; break;
    		case '13': html = '<div class="gubun g9" title="증거금률30%">증</div>'; break;
    		case '2': html = '<div class="gubun g3" title="관리종목">관</div>'; break;
    		case '5': html = '<div class="gubun g6" title="투자주의">주</div>'; break;
    		case '1': html = '<div class="gubun g15" title="거래정지">정</div>'; break;
    		case '14': html = '<div class="gubun g11" title="정리매매">정</div>'; break;
    		case '4': html = '<div class="gubun g5" title="투자경고">경</div>'; break;
    		case '8': html = '<div class="gubun g10" title="신용보증금률50%">신</div>'; break;
    		case '9': html = '<div class="gubun g2" title="신용보증금률45%">신</div>'; break;
    		case '15': html = '<div class="gubun g4" title="불성실공시">불</div>'; break;
    		case '17': html = '<div class="gubun g7" title="투자주의환기">환</div>'; break;
    		case '18': html = '<div class="gubun g13" title="단기과열">과</div>'; break;
    		case '3': html = '<div class="gubun g12" title="투자위험">위</div>'; break;
    	}
        // 예: 투자위험예고 g14
    	return html;
    };
    
    //250 증거금
    this.grid_fid250 = function (value, gubun) {

        if(gubun == "1") {
            var str=[];
            str.push('<div class="d1">');
            str.push(value);
            str.push('</div>');
            return str.join('');
        	//return '<div class="d1">' + value + '</div>';
        } else if(gubun == "2") {
            var str=[];
            str.push('<div class="d2">');
            str.push(value);
            str.push('</div>');
            // this.$_selector.find(fid).text(value).addClass("d2");
            return str.join('');
            //return '<div class="d2">' + value + '</div>';
        } else {
            return value;
        }
    };

    this.grid_fid000 = function (value) {
        return this.grid_fid2807(value);
    };

    this.grid_fid500 = function(value, format) {
        return this.grid_date(value, format);
    };

    this.grid_fid300 = function(value, format) {
        return this.grid_time(value, format);
    };

    // wrapper함수.
    this.grid_moneyMono = function(value, option) {
        return this.grid_money(value, option);
    };
}

