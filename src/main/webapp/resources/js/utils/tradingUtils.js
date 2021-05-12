///////////////////////////////////// 주문관련 공통 ///////////////////////////////
/**
 * 주식주문> 주문유형에 따른 처리
 * @author 민자영TD0222
 * @param formObj
 * @param val1 증거금율
 * @param val2 보증금율
 */
function chkOrdType(formObj, val1, val2, chkType, chkBox, drawType, drawArea, drawLength){
	
	// 체크유형 (checked, selected)
	if(typeof chkType == 'undefined' || chkType == null || chkType == '') {
		chkType = 'checked';
	}
	
	// 체크
	if(typeof chkBox == 'undefined' || chkBox == null || chkBox == '') {
		chkBox = 'input[name=ordType]';
	}
	
	// 표시 타입(val, text)
	if(typeof drawType == 'undefined' || drawType == null || drawType == '') {
		drawType = 'val';
	}
	
	// 표시
	if(typeof drawArea == 'undefined' || drawArea == null || drawArea == '') {
		drawArea = 'input[name=ratioLabel]';
	}
	
	// 표시길이(long, short)
	if(typeof drawLength == 'undefined' || drawLength == null || drawLength == '') {
		drawLength = 'long';
	}
	
    if ( eval( "$(formObj).find('" + chkBox + "')[0]." + chkType ) ) {

    	// 현금
    	if(drawLength == 'long') {
    		eval( "$(formObj).find('" + drawArea + "')." + drawType + "('증거금 " + val1 + "%');" );
    	} else {
    		eval( "$(formObj).find('" + drawArea + "')." + drawType + "('증 " + val1 + "%');" );
    	}
    
    } else {
        // 신용
        if (val2 == "100") {
            eval( "$(formObj).find('" + drawArea + "')." + drawType + "('신용불가');" );
        } else {
        	
        	if(drawLength == 'long') {
        		eval( "$(formObj).find('" + drawArea + "')." + drawType + "('보증금 " + val2 + "%');" );
        	} else {
        		eval( "$(formObj).find('" + drawArea + "')." + drawType + "('보 " + val2 + "%');" );
        	}
        }

        //신용약정계좌인지 체크
        /*var acc_no=$('#'+this._parentid +' select[name=accno_choice]').val();
        var jsonRslt = getFID("/wtsStockOrder.do", {cmd:'mbi0041p',
            A_DMND_CONT:'1',      //요청건수
            ACNT_NO:acc_no        //계좌번호, CHAR(20)
            });

        //신용미약정계좌일때 처리
        if(jsonRslt['errorMsg'].length >0){
            this.msgWarn(jsonRslt['errorMsg']);
            return;
        }*/
    }
}

/**
 * 주식주문> 주문구분 선택에 따른 처리
 * @author 민자영TD0222
 * @param formObj
 */
function changeOrdrCode(formObj){
    var ordr_code =  formObj.ordr_code.value.substring(0,2);

    if(ordr_code == "00" || ordr_code == "05" || ordr_code == "81"){
        $(formObj).find('input[name=ordr_pric]').attr("disabled",false);
        if(formObj.marketCheckBox) formObj.marketCheckBox.checked = false;
        if($(formObj).find('.ordrPricBtn')) $(formObj).find('.ordrPricBtn').prop('disabled', false);
    }else if(ordr_code == "03"){
        $(formObj).find('input[name=ordr_pric]').val('0');
        $(formObj).find('input[name=ordr_pric]').attr("disabled",true);
        if(formObj.marketCheckBox) formObj.marketCheckBox.checked = true;
        if($(formObj).find('.ordrPricBtn'))    $(formObj).find('.ordrPricBtn').prop('disabled', true);
        if(formObj.pricAutoCheckBox) formObj.pricAutoCheckBox.checked = false;
        if(formObj.pric_auto) {
            formObj.pric_auto.value = "";
            formObj.pric_auto.disabled = true;
        }
    }else {
        $(formObj).find('input[name=ordr_pric]').val('0');
        $(formObj).find('input[name=ordr_pric]').attr("disabled",true);
        if(formObj.marketCheckBox) formObj.marketCheckBox.checked = false;
        if($(formObj).find('.ordrPricBtn'))    $(formObj).find('.ordrPricBtn').prop('disabled', true);
        if(formObj.pricAutoCheckBox) formObj.pricAutoCheckBox.checked = false;
        if(formObj.pric_auto) {
            formObj.pric_auto.value = "";
            formObj.pric_auto.disabled = true;
        }
    }
}

/**
 * 주식주문> 정정/취소> 잔량전부 체크에 따른 처리
 * @author 민자영TD0222
 * @param formObj
 */
function partwhlClick(formObj){
    if(formObj.part_whl.checked){
        formObj.ordr_qnty.value = '0';
        formObj.ordr_qnty.disabled = true;
        // formObj.qntyBtn.disabled = true;

        $(formObj).find('.qntyBtn').prop('disabled', true);
        
    }else{
        formObj.ordr_qnty.disabled = false;
        // formObj.qntyBtn.disabled = false;
        $(formObj).find('.qntyBtn').prop('disabled', false);
        // formObj.ordr_qnty.focus();
        formObj.ordr_qnty.value = formObj.orgl_ordr_qnty.value;
    }
}

/**
 * 주식주문> 시장가 체크에 따른 처리
 * @author 민자영TD0222
 * @param formObj
 */
function marketCheckBoxClick(formObj){
    
	if(formObj.ordr_code){
        if(formObj.marketCheckBox.checked){
            formObj.ordr_code.value = "0300";
        }else{
            formObj.ordr_code.value = "0000";
        }
        changeOrdrCode(formObj);
    }else{
    	
        if(formObj.marketCheckBox.checked){
            formObj.ordr_pric.value = '0';
            formObj.ordr_pric.disabled = true;
            // formObj.ordrPricBtn.disabled = true;
            $(formObj).find('.ordrPricBtn').prop('disabled', true);
            
            try{
	            formObj.pricAutoCheckBox.checked = false;
	            formObj.pric_auto.value = "";
	            formObj.pric_auto.disabled = true;
            }catch(e){}
            
        }else{
            formObj.ordr_pric.disabled = false;
            // formObj.ordrPricBtn.disabled = false;
            $(formObj).find('.ordrPricBtn').prop('disabled', false);
        }
    }
}


/**
 * 선물옵션 > 시장가 체크에 따른 처리
 * @author 변만복 TD0667
 * @param formObj
 */
function ftopMarketCheckBoxClick(formObj){
    	
    if(formObj.marketCheckBox.checked){
    	formObj.presentCheckBox.checked = false;
    	formObj.ORDR_TYPE_CODE.value = '4';
    	formObj.ordr_pric.value = '0';
    } else {
    	formObj.ORDR_TYPE_CODE.value = '1';
    }
    
    ftopChangeOrdrTypeCode(formObj);
}


/**
 * 선물옵션 > 주문구분 선택에 따른 처리
 * @author 변만복 TD0667
 * @param formObj
 */
function ftopChangeOrdrTypeCode(formObj){
    
	var ORDR_TYPE_CODE = formObj.ORDR_TYPE_CODE.value;

	if(ORDR_TYPE_CODE != '4' && ORDR_TYPE_CODE != '5' && ORDR_TYPE_CODE != '6') {
		formObj.marketCheckBox.checked = false;
	} else {
		formObj.marketCheckBox.checked = true;
	}

	switch(ORDR_TYPE_CODE) {
	case "4":
	case "5":
	case "6":
	case "8":
	case "9":
	case "A":
		formObj.ordr_pric.value = '0';
		formObj.ordr_pric.readonly = true;
		formObj.ordr_pric.disabled = true;
		
		$(formObj).find('.ordrPricBtn').prop('disabled', true);
		
		formObj.presentCheckBox.checked = false;
		formObj.presentCheckBox.disabled = true;
		break;
	default:
		formObj.ordr_pric.readonly = false;
		formObj.ordr_pric.disabled = false;
		$(formObj).find('.ordrPricBtn').prop('disabled', false);
		formObj.presentCheckBox.disabled = false;
		break;
	}
//	
//	var ordr_code =  formObj.ordr_code.value.substring(0,2);
//
//    if(ordr_code == "00" || ordr_code == "05" || ordr_code == "81"){
//        $(formObj).find('input[name=ordr_pric]').attr("disabled",false);
//        if(formObj.marketCheckBox) formObj.marketCheckBox.checked = false;
//        if(formObj.ordrPricBtn) formObj.ordrPricBtn.disabled = false;
//    }else if(ordr_code == "03"){
//        $(formObj).find('input[name=ordr_pric]').val('0');
//        $(formObj).find('input[name=ordr_pric]').attr("disabled",true);
//        if(formObj.marketCheckBox) formObj.marketCheckBox.checked = true;
//        if(formObj.ordrPricBtn)    formObj.ordrPricBtn.disabled = true;
//        if(formObj.pricAutoCheckBox) formObj.pricAutoCheckBox.checked = false;
//        if(formObj.pric_auto) {
//            formObj.pric_auto.value = "";
//            formObj.pric_auto.disabled = true;
//        }
//    }else {
//        $(formObj).find('input[name=ordr_pric]').val('0');
//        $(formObj).find('input[name=ordr_pric]').attr("disabled",true);
//        if(formObj.marketCheckBox) formObj.marketCheckBox.checked = false;
//        if(formObj.ordrPricBtn)    formObj.ordrPricBtn.disabled = true;
//        if(formObj.pricAutoCheckBox) formObj.pricAutoCheckBox.checked = false;
//        if(formObj.pric_auto) {
//            formObj.pric_auto.value = "";
//            formObj.pric_auto.disabled = true;
//        }
//    }
}


/**
 * 주식주문> 단가자동입력 선택에 따른 처리
 * @author 민자영TD0222
 * @param formObj
 */
function changePricAuto(formObj, data){
    var auto_code = formObj.pric_auto.value;

    if(formObj.pricAutoCheckBox.checked && auto_code != ''){
        formObj.ordr_pric.value = data['fid1000'][auto_code];
    }
}

/**
 * 주식주문> 자동설정 체크에 따른 처리
 * @author 민자영TD0222
 * @param formObj
 */
function pricAutoCheckBoxClick(formObj){
    if(formObj.pricAutoCheckBox.checked){
        formObj.pric_auto.disabled = false;
        if(formObj.ordr_pric.disabled){
            if(formObj.ordr_code){
                formObj.ordr_code.value ='0000';
                changeOrdrCode(formObj);
            }else{
                formObj.ordr_pric.disabled = false;
                formObj.marketCheckBox.checked = false;
            }
        }
    }else{
        formObj.pric_auto.value = "";
        formObj.pric_auto.disabled = true;
    }
}

/**
 * 예상체결 데이터 표시
 * @author 김정숙TD0359
 * @param json:종목데이터, $selector
 */
function yesang(json , $selector){
    if(!json)
        throw Error('데이터 없음. 입력된 json 데이터를 확인하세요');

    if($selector.length == 0)
        throw Error('selector 위치가 존재하지 않습니다.');

    formatter.setSelector($selector);
    if (json[48] != "") {
    	formatter.setFid5(json[48]);
    	formatter.fid4(47, json[47]);              //예상가
    	formatter.fid6(49, json[49]);              //예상체결 등락폭
    	formatter.f7(50, '', json[50]);            //예상체결 등락률
    	formatter.mny(51, {color:0}, json[51]);    //예상체결 거래량
    }
}

/**
 * 외인, 기관 투자동향 데이터 표시
 * @author 김정숙TD0359
 * @param json:종목데이터, $selector
 */
function fo_summary(json , $selector){
    if(!json)
        throw Error('데이터 없음. 입력된 json 데이터를 확인하세요');

    if($selector.length == 0)
        throw Error('selector 위치가 존재하지 않습니다.');

    formatter.setSelector($selector);
    // fid911로 처리할 경우에 이상현상 발생
    formatter.mny('.fid911_d0', {color:1, sign:1}, json[0][911], 0);        // 외국계추정
    formatter.mny(913, {color:1, sign:1}, json[0][913], 0);                 // 기관추정
    if(typeof json[1] != 'undefined' && json[1] != null) {
	    formatter.mny('.fid911_d1', {color:1, sign:1}, json[1][911], 0);        // 외국계추정 전일
	    formatter.mny('.fid913_d1', {color:1, sign:1}, json[1][913], 0);        // 기관추정 전일
    }
}

///////////////////////// Chart ////////////////////////////////////////


/**
 * toChart의 공통 처리 부분
 * @author 김정숙TD0359
 * @param tmpid: this._tmpid (화면ID)
 */
function toChart_order(tmpid, fid1000, fid1008, fid1004) {
	
	var rtnChart = [];
	
	// 분 차트
    $selector = $(tmpid +' .chart_area .chartForm');
    rtnChart.push(chartMinute($selector, fid1008, fid1000[60]));

	// 10호가 차트
    $selector = $(tmpid +' .chart_10hoga .chartForm');
    rtnChart.push(chart10Hoga($selector, fid1004));
    
    return rtnChart;
}

/**
 * toChart의 실시간 처리 공통 부분
 */
function toChart_realOrder(chartList, json_data) {
	try{
		chartMReal(chartList[0], json_data);
	}catch(e){}
	try{
		chart10Real(chartList[1], json_data);
	}catch(e){}
}

/**
 * 분차트 실시간 처리
 */
var chartM_lastUpdated = '';
function chartMReal(chartList, json_data) {
//////////////chart 분차트 ////////////////////////////////////////
	var currPrc = json_data['4'];						// 현재가
	var dateTime = json_data[300];
    var pushedTime = getFmtTime(json_data[300], TIMEFMT_HM24_SHRT);			// 실시간 시세 UPD, INP 처리 구분 시간
    
    var plotLineVal = Number(json_data[4]) - Number(json_data[6]);
    
    if(dateTime == '9991') {
        dateTime = '153000';
    } else {
        dateTime = lpad(dateTime,'0',6);
    }
    
    if(Number(dateTime) > 153000) {
    	return false;
    }
    
    if(typeof chartList != 'undefined' && chartList != null) {
	    var chartMinute = chartList.chart;
	    dateTime = chartList.currDate + dateTime;
	    
	    var dateTimeUtc = Number(getDateToUtc(dateTime));
	    
	    // UPD
	    if(chartM_lastUpdated == pushedTime) {
	    	var len_chartM = chartMinute.get('stock').data.length;
	    	chartMinute.get('stock').data[len_chartM-1].update([dateTimeUtc, Number(currPrc)], false);
	    	
	    // INS
	    } else {
	    	chartMinute.get('stock').addPoint([dateTimeUtc, Number(currPrc)], false);
	    }
	    
	    var currPlotValue = chartMinute.yAxis[0].options.plotLines[0].value;
	    
	    if(currPlotValue == null || currPlotValue.length == 0 || currPlotValue != plotLineVal) {
	        chartMinute.yAxis[0].removePlotLine('plotline');
	        chartMinute.yAxis[0].addPlotLine ({              //차트에 라인형식으로 하나 그린다.
	            id: 'plotline',
	            value: plotLineVal,      //라인이 그려질 y값 설정
	            color: 'red',
	            dashStyle: 'solid',
	            width: 1,
	            label: {
	            	text: '<span style="font-weight:bold;color:red;">' + String(plotLineVal).commify() + '</span>'
	            }
	        });
	    }
	
	    chartMinute.redraw();
    }
    
    chartM_lastUpdated = pushedTime;
}

/**
 * 10호가 실시간 처리
 */
function chart10Real(chartList, json_data) {
//////////////chart 10 호가 ////////////////////////////////////////
	var openPrc = json_data['22'];						// 시가
    var highPrc = json_data['23'];						// 고가
    var lowPrc = json_data['24'];						// 저가
    var currPrc = json_data['4'];						// 현재가
    var concQty = json_data['8'];						// 누적체결수량
    
    var chart10_data1 = [];								// candle
    var chart10_data2 = [];								// volume
    
    var chart10_data5 = [];								// 5 이평
    var chart10_data20 = [];							// 20 이평
    
    if(typeof chartList != 'undefined' && chartList != null) {
	    var chart10hoga = chartList.chart;
	    var lastLen = chartList.chartData.length -1;
	    
	    if(json_data != null) {
	        
	    	chartList.chartData[lastLen] = [
				Number(chartList.currDate),					// 날짜
				Number(openPrc),							// 시가
				Number(highPrc),							// 고가
				Number(lowPrc),								// 저가
				Number(currPrc),							// 현재가
				Number(concQty)								// 거래량
	    	];
	    	
	    	chart10_data1.push(
	                Number(chartList.currDate),					// 날짜
	                Number(openPrc),							// 시가
	                Number(highPrc),							// 고가
	                Number(lowPrc),								// 저가
	                Number(currPrc)								// 현재가
	        );
	        
	    	chart10_data2.push(
	    			Number(chartList.currDate),
	    			Number(concQty)
	        );
	    	
	        // 5이평
		    if(lastLen + 1 >= 5) {
    		    var dataSum5 = 0;
    		    for (var i = 0; i < 5; i++) {
                    dataSum5 += chartList.chartData[lastLen - i][4];
                }
    		    
    		    chart10_data5.push(
    		    		Number(chartList.currDate),										// 날짜
    		    		Number((dataSum5 / 5).toFixed(2))								// 5이평
	            );
		    } else {
		    	
		    	chart10_data5.push(
		    			Number(chartList.currDate),										// 날짜
    		    		null															// 5이평
	            );
		    }
		    
		    // 20이평
		    if(lastLen + 1 >= 20) {
		    	var dataSum20 = 0;
		        for (var i = 0; i < 20; i++) {
                    dataSum20 += chartList.chartData[lastLen - i][4];
                }
		        
		        chart10_data20.push(
		        		Number(chartList.currDate),										// 날짜
    		    		Number((dataSum20 / 20).toFixed(2))								// 20이평
	            );
		    } else {
		    	chart10_data20.push(
		    			Number(chartList.currDate),										// 날짜
    		    		null															// 20이평
	            );
		    }
	        
	        if(chart10_data1 != null && chart10_data1.length > 0) {
	        	
	        	var len_chart10 = chart10hoga.get('stock').data.length;
	        	var lastDataTimeUtc = chart10hoga.get('stock').data[len_chart10-1].x;
	            	
	            if( lastDataTimeUtc == chart10_data1[0] && len_chart10 > 0) {
	
	            	//기존포인트를 업데이트
	            	chart10hoga.get('stock').data[len_chart10-1].update(chart10_data1.slice(), false, false, false);
	            	chart10hoga.get('volume').data[chart10hoga.get('volume').data.length - 1].update(chart10_data2.slice(), false, false, false);
	            	chart10hoga.get('bDay5').data[chart10hoga.get('bDay5').data.length - 1].update(chart10_data5.slice(), false, false, false);
	            	chart10hoga.get('bDay20').data[chart10hoga.get('bDay20').data.length - 1].update(chart10_data20.slice(), false, false, false);
	            	chart10hoga.redraw();
	            }
	        }
	    }
    }
}

/**
 * 10호가 차트
 * @author 김정숙TD0359
 * @param $selector, json:데이터
 */
function chart10Hoga($selector, json, width, height) {
    
	var rtnChart = {};
	
	var ohlc = [],
    volume = [],
    bDay5 = [],
    bDay20 = [];
	
	rtnChart['chartData'] = [];
	
    var chartWidth = 108;
    var chartHeight = 184;
    
    if(typeof width != 'undefined' && width != null && width != '') {
    	chartWidth = width;
	}
	
	if(typeof height != 'undefined' && height != null && height != '') {
		chartHeight = height;
	}
    
    for (var i = 0; i < json.length; i++) {
        var dateCut = getFmtDate(json[i][500]).split("-");
        dayCut = Date.UTC(Number(dateCut[0]), Number(dateCut[1])-1, Number(dateCut[2]));

        if(i == 0) {
        	rtnChart['currDate'] = dayCut;
        }
        
        rtnChart['chartData'].unshift([
           Number(dayCut),        // the date
           Number(json[i][22]),   // open
           Number(json[i][23]),   // high
           Number(json[i][24]),   // low
           Number(json[i][4]),    // close
           Number(json[i][8])     // volume
        ]);
        
        if(i <= 9) {
	        //캔들차트
	        ohlc.unshift([
	            Number(dayCut),        // the date
	            Number(json[i][22]),   // open
	            Number(json[i][23]),   // high
	            Number(json[i][24]),   // low
	            Number(json[i][4])     // close
	        ]);
	
	        //막대차트
	        var col = "";
	        if (Number(json[i][22]) > Number(json[i][4])){             //종가하락
	            col = "blue";
	        } else if (Number(json[i][22]) == Number(json[i][4])){    //변동없음
	            col = "black";
	        } else {
	            col = "red";                         //종가상승
	        }
	
	        volume.unshift({
	            x:Number(dayCut),
	            y:Number(json[i][8]),
	            color: col
	        });
	
	        var dateSum5 = new Number();
	        var dateSum20 = new Number();
	
	        // 5일전 종가 평균
	        if ((i+5) < json.length) {
	            for (var c = 0; c < 5; c++) {
	                dateSum5 += Number(json[i+c][4]);
	            }
	            bDayVal = dateSum5 / 5;
	            bDay5.unshift([Number(dayCut),Number(dateSum5 / 5)]);
	        } else {
	            bDay5.unshift([Number(dayCut),null]);
	        }
	
	        // 20일전 종가 평균
	        if ((i+20) < json.length) {
	            for(var c = 0; c < 20; c++) {
	                dateSum20 += Number(json[i+c][4]);
	            }
	            bDayVal = dateSum20 / 20;
	            bDay20.unshift([Number(dayCut),Number(dateSum20 / 20)]);
	        } else {
	            bDay20.unshift([Number(dayCut),null]);
	        }
        }
        
        if(i==19) break;
    }

	// width가 100으로 설정되어 있을 경우에는 색상이 바뀌는 현상이 있음.
    // create the chart
    rtnChart['chart'] = new Highcharts.StockChart({ 
        chart:{
        	renderTo: $selector[0],
            borderWidth: 0,
			width: chartWidth,
            height: chartHeight,
            spacingTop: 5,
            spacingRight: 5,
            spacingBottom: 5,
            spacingLeft: 5,
            zoomType:null,
            panning: false
        },
        navigator:{
            enabled: false
        },
        scrollbar:{
            enabled: false
        },
        rangeSelector: {
            enabled: false
        },
        credits: {
            enabled: false
        },
        plotOptions: {                  //series 옵션의 글로벌 선언부(여기 있는 모든 옵션값은 series에 개별 정의가능)
            series: {
                states: {
                    hover: {
                        lineWidth: 1    //라인에 마우스 올렸을때 크기
                    }
                },
                dataGrouping: {
                    dateTimeLabelFormats: {
                        day: ['Date: %Y/%m/%d']
                    },
                    enabled: false      //데이터 그룹핑 여부 [default(line:avg, colum:sum ...)
                }
            }
        },
        legend: {
            enabled: true,
            padding: 0,
            margin: 0,
            y: 5,
            x: 10,
            symbolWidth: 5,
            itemDistance: 5
        },
        xAxis: {
            lineWidth: 0,
            tickWidth: 0,
            gridLineWidth: 0,           //그리드 라인 크기
            labels: {
                enabled: false
            },
            minorTickLength: 0,          //보여지는 라벨과 라벨사이의 틱의 갯수
            tickPixelInterval: 20
        },
        yAxis: [{
            lineWidth: 0,
            tickWidth: 0,
            gridLineWidth: 0,
            minorTickLength: 0,
            minorTickWidth: 0,
            labels: {
                enabled: false
            },
            top: 20,
            height: 120
        }, {
            offset: 0,
            lineWidth: 0,
            tickWidth: 0,
            gridLineWidth: 1,
            minorTickLength: 0,
            minorTickWidth: 0,
            labels: {
                enabled: false
            },
            top: 140,
            height: 40
        }],
        series: [{
        	id: 'stock',
            type: 'candlestick',
            name: '주가',                 //캔들
            showInLegend: false,
            data: ohlc,
            yAxis : 0
        }, {
        	id: 'bDay5',
            type: 'line',
            lineWidth : 1,
            name: '5',                      //5일전 종가평균
            color: '#E4635E',
            showInLegend: true,
            data: bDay5,
            yAxis : 0,
            tooltip: {
                valueDecimals: 2
            }
        }, {
        	id: 'bDay20',
            type: 'line',
            lineWidth : 1,
            name: '20',                     //20일전 종가평균
            color: '#CB65D2',
            showInLegend: true,
            data: bDay20,
            yAxis : 0,
            tooltip: {
                valueDecimals: 2
            }
        }, {
        	id: 'volume',
            type: 'column',
            name: '거래량',                     //거래량
            showInLegend: false,
            data: volume,
            yAxis : 1
        }]
    });
    
    return rtnChart;
};

/**
 * 분 차트
 * @author 김정숙TD0359
 * @param $selector, json:데이터
 */
function chartMinute($selector, json, fid60, width, height) {
    
	var rtnChart = {};
	
    var chartMinuteData = [];
    var chartWidth = 143;
    var chartHeight = 144;
	
    if(typeof width != 'undefined' && width != null && width != '') {
    	chartWidth = width;
	}
	
	if(typeof height != 'undefined' && height != null && height != '') {
		chartHeight = height;
	}

    var currDay = getToday();
    rtnChart['currDate'] = currDay;
    
    for(var idx = 0, len = json.length; idx < len; idx++){
        
    	var dateTime  = json[idx][300];
	    
        if(dateTime == '9991') {
            dateTime = '153000';
        } else {
            dateTime = rpad(dateTime,'0',6);
        }

	    var dateUtcTime = getDateToUtc(currDay + dateTime);
    	
	    chartMinuteData.unshift([ Number(dateUtcTime), Number(json[idx][4]) ]);
        // dataA[1].unshift(Number(json[json.length - 1][4]));
        // dataJ.unshift(Number(json[idx][4]));
    }
    
    rtnChart['chart'] = new Highcharts.StockChart({ 
        chart:{
       	 renderTo: $selector[0],
       	 zoomType: '',       //zoom 설정(x,y,xy)
            panning: false,     //zoom 설정과 연계되는 움직임 설정(zoom을 하지 않을경우 이것두 false로 설정해야 움직임이 없어진다)
            width: chartWidth,
            height: chartHeight,
            borderWidth: 0
       },
       navigator:{
           enabled : false
       },
       scrollbar:{
           enabled : false
       },
       rangeSelector: {
           enabled: false
       },
       tooltip: {
           // positioner: null
       },
       xAxis: {
       	lineWidth: 0,
           tickWidth: 0,
           gridLineWidth: 0,           //그리드 라인 크기
           labels: {
               enabled: false
           },
           minorTickLength: 0,          //보여지는 라벨과 라벨사이의 틱의 갯수
           tickPixelInterval: 20
           //step: 50
       },
       yAxis: [{
       	   lineWidth: 0,
       	   tickWidth: 0,
           gridLineWidth: 0,
           minorTickLength: 0,
           minorTickWidth: 0,
           tickPixelInterval: 20,
           labels: {
               enabled: false
           },
           top: 20,
           plotLines: [{              //차트에 라인형식으로 하나 그린다.
               id: 'plotline',
               value: Number(fid60),      //라인이 그려질 y값 설정
               color: 'red',
               dashStyle: 'solid',
               width: 1,
               label: {
                   text: '<span style="font-weight:bold;color:red;">' + String(fid60).commify() + '</span>'
               }
           }]
       }],
       plotOptions: {
       	series: {
               lineWidth: 1,
               states: {
                   hover: {
                       lineWidth: 1
                   }
               },
               dataGrouping: {
                   dateTimeLabelFormats: {
                       minute: ['시간: %H:%M']
                   },
                   enabled: false      //데이터 그룹핑 여부 [default(line:avg, colum:sum ...)
               },
               marker: {
                   enabled: false
               }
           }
       },
       series: [{
       	id: 'stock',
           type: 'line',
           lineWidth : 1,
           name: '주가',
           data: chartMinuteData,
           color: 'black'
       }] 
   });
    
    return rtnChart;
};

/**
 * 자동주문 이용동의 팝업 처리
 * @author 민자영TD0222
 */
function autoOrderAgreeChk(){
	if(agreeForm.customAgree.checked){
		agreeForm.agree.disabled = false;
	}else {
		agreeForm.agree.disabled = true;
	}
}
function autoOrderAgreePro(agree){
	if(agree == 'Y'){
		use_agree_2427 = 'Y';
		openWTS('2427');
	}
	dialogClose('dia24270');
};

/**
 * 자동주문 설정 > 기준가 대비가격 계산
 * @author 민자영TD0222
 */
function calculationPric(aimUpNDnType, aimStdPrc, aimUpNDnRt, aimUpNDn){
    var val = 0;

    if(aimUpNDnType == "1"){ // %
        if(aimUpNDn == "up")
            val = aimStdPrc + (aimStdPrc * parseFloat(aimUpNDnRt)/100);
        else //down
            val = aimStdPrc - (aimStdPrc * parseFloat(aimUpNDnRt)/100);
    }else{ // 원
        if(aimUpNDn == "up")
            val = aimStdPrc + parseInt(aimUpNDnRt);
        else //down
            val = aimStdPrc - parseInt(aimUpNDnRt);
    }

    return Math.round(val);
}
