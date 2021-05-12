// **********************************// 날짜형 반환// **********************************function getDateYYMMDD(){	//날짜형식 yyyy.mm.dd 에 맞게 출력	var obj_date = new Date();	var year = obj_date.getFullYear();	var month = obj_date.getMonth() + 1;	var date = obj_date.getDate();
	var	ch_set = '.';	var ret = year;	if(month.toString().length == 1)		ret += ch_set + "0" + month;	else		ret += ch_set + month;
	if(date.toString().length == 1)		ret += ch_set + "0" + date;	else		ret += ch_set + date;
	return ret;}
/** * 오늘 날짜를 날짜 포맷에 맞게 출력 * @param pDelimiter * @return */function getToday(pDelimiter) {	var obj_date = new Date();	var year = obj_date.getFullYear();	var month = obj_date.getMonth() + 1;	var date = obj_date.getDate();
	var	ch_set = '';	if(typeof pDelimiter != 'undefined' && pDelimiter != '') {		ch_set = pDelimiter;	}
	var ret = year;	if(month.toString().length == 1)		ret += ch_set + "0" + month;	else		ret += ch_set + month;
	if(date.toString().length == 1)		ret += ch_set + "0" + date;	else		ret += ch_set + date;
	return ret;}
// **********************************// 날짜/시간 반환// **********************************	function getDateFullTime(ch_set)	{		//날짜형식 YYYY.mm.dd HH:MM:SS에 맞게 출력		var obj_date = new Date();		var year = obj_date.getFullYear();		var month = obj_date.getMonth() + 1;		var date = obj_date.getDate();		var hour = obj_date.getHours();		var min = obj_date.getMinutes();		var sec = obj_date.getSeconds();
		if (ch_set != ".")			ch_set = '-';
		var ret = year;		if(month.toString().length == 1)			ret += ch_set + "0" + month;		else			ret += ch_set + month;
		if(date.toString().length == 1)			ret += ch_set + "0" + date;		else			ret += ch_set + date;
		if(hour.toString().length == 1)			ret += " 0" + hour;		else			ret += " " + hour;
		if(min.toString().length == 1)			ret += ":0" + min;		else			ret += ":" + min;
		if(sec.toString().length == 1)			ret += ":0" + sec;		else			ret += ":" + sec;
		return ret;	}
// **********************************// 날짜 비교// **********************************function CmpDate(base_date, cmp_date){	//날짜비교하여 base_date가 cmp_date보다 며칠이 많은지 리턴	base_date	= base_date.substring(0, 10);	cmp_date	= cmp_date.substring(0, 10);
	base_date	= base_date.replace(/-/g, '.');	cmp_date	= cmp_date.replace(/-/g, '.');
    var tmp_arr    = base_date.split('.');    var tmp_date = new Date();    tmp_date.setFullYear(tmp_arr[0]);    tmp_date.setMonth(tmp_arr[1] - 1);    tmp_date.setDate(tmp_arr[2]);
    var cmp_arr  = cmp_date.split('.');    var cmp_date = new Date();    cmp_date.setFullYear(cmp_arr[0]);    cmp_date.setMonth(cmp_arr[1] - 1);    cmp_date.setDate(cmp_arr[2]);
    var ret_date = tmp_date.getTime() - cmp_date.getTime();    return Math.floor(ret_date / (1000 * 60 * 60 * 24));}
// **********************************// 원하는 날짜/시간 반환// **********************************function SetAddDate(base_date, amonth, aday){	//날짜형식 YYYY.mm.dd형식으로 출력	var year = base_date.split('.')[0];	var month = base_date.split('.')[1];
	if (base_date.length == 10) {		var day = base_date.split('.')[2];	}
	if (base_date.length == 7) {		day = 1;	}
	month = (month - 0)  + (amonth - 0) ;	day = (day - 0)  + (aday - 0) ;
	/*	tmp_date.setFullYear(year);	tmp_date.setMonth(month - 1);	tmp_date.setDate(day);	*/	var tmp_date = new Date(month + " " + day + ", " + year);
	var t_year = tmp_date.getFullYear();	var t_month = tmp_date.getMonth() + 1;	var t_date = tmp_date.getDate();
	var ret = t_year;
	if (t_month.toString().length == 1)		ret += ".0" + t_month;	else		ret += "." + t_month;
	if (t_date.toString().length == 1)		ret += ".0" + t_date;	else		ret += "." + t_date;
	return ret;}
/* 원하는 날짜 형식으로 반환  * ex1) 8자리 입력시 (년, 월, 일) * 		dateFormat('20101201', '-') * 		result : 20101201 -> 2010-12-01 * ex2) 6자리 입력시(년, 월) * 		dateFormat('201012', '-') * 		result : 201012 -> 2010-12 * ex3) 4자리 입력시(월, 일) * 		dateFormat('1223', '-') * 		result : 1223 -> 12-23 **/  function dateFormat(date, format) {	var result = "";
	// yyyymmdd	if(date.length == 8) {		result = date.substring(0, 4) + format + date.substring(4, 6) + format + date.substring(6);		// yyyymm	} else if(date.length == 6) {		result = date.substring(0, 4) + format + date.substring(4);
	// mmdd	} else if(date.length == 4) {		result = date.substring(0, 2) + format + date.substring(2);	}	return result;}
function dateFormat2(obj, format) {	var date=obj.value.replaceAll('.','');
	if(date.length > 8)		date=date.substring(0,8);		if(date.length == 8) {		if( document.MKD25!=null && typeof(document.MKD25)!="undefined" )			document.getElementById('MKD25').SkipVerify(1);
		obj.value = date.substring(0, 4) + format + date.substring(4, 6) + format + date.substring(6, 8);
		if( document.MKD25!=null && typeof(document.MKD25)!="undefined" )			document.getElementById('MKD25').SkipVerify(0);	} else if(obj.value.length == 6) {
		if( document.MKD25!=null && typeof(document.MKD25)!="undefined" )			document.getElementById('MKD25').SkipVerify(1);
		obj.value = date.substring(0, 4) + format + date.substring(4, 6);
		if( document.MKD25!=null && typeof(document.MKD25)!="undefined" )			document.getElementById('MKD25').SkipVerify(0);	}}
/* ---------------------------------------------------------------------------- * 특정 날짜에 대해 지정한 값만큼 가감(+-)한 날짜를 반환 *  * 입력 파라미터 ----- * pInterval : "yyyy" 는 연도 가감, "m" 은 월 가감, "d" 는 일 가감 * pAddVal  : 가감 하고자 하는 값 (정수형) * pYyyymmdd : 가감의 기준이 되는 날짜 * pDelimiter : pYyyymmdd 값에 사용된 구분자를 설정 (없으면 "" 입력) *  * 반환값 ---- * yyyymmdd 또는 함수 입력시 지정된 구분자를 가지는 yyyy?mm?dd 값 * * 사용예 --- * 2008-01-01 에 3 일 더하기 ==> addDate("d", 3, "2008-08-01", "-"); * 20080301 에 8 개월 더하기 ==> addDate("m", 8, "20080301", ""); --------------------------------------------------------------------------- */function addDate(pInterval, pAddVal, pYyyymmdd, pDelimiter){	var yyyy;	var mm;	var dd;	var cDate;	var oDate;	var cYear, cMonth, cDay;
	if (pDelimiter != "") {		pYyyymmdd = pYyyymmdd.replace(eval("/\\" + pDelimiter + "/g"), "");	}
	yyyy = pYyyymmdd.substr(0, 4);	mm  = pYyyymmdd.substr(4, 2);	dd  = pYyyymmdd.substr(6, 2);	if (pInterval == "yyyy") {		yyyy = (yyyy * 1) + (pAddVal * 1); 	} else if (pInterval == "m") {		mm  = (mm * 1) + (pAddVal * 1);	} else if (pInterval == "d") {		dd  = (dd * 1) + (pAddVal * 1);	}
	cDate = new Date(yyyy, mm - 1, dd); // 12월, 31일을 초과하는 입력값에 대해 자동으로 계산된 날짜가 만들어짐.
	cYear = cDate.getFullYear();	cMonth = cDate.getMonth() + 1;	cDay = cDate.getDate();	cMonth = cMonth < 10 ? "0" + cMonth : cMonth;	cDay = cDay < 10 ? "0" + cDay : cDay;
	if (pDelimiter != "") {		return cYear + pDelimiter + cMonth + pDelimiter + cDay;	} else {		return "" + cYear + cMonth + cDay;	}}
/** * desc : 특정 날짜에 대해 지정한 값만큼 가감(+-)한 날짜를 반환 * date : 2015.07.11 * author : 이상우 * ex : dateAdd('20150722','yyyy', 1) -> 20160722  * @param date: 기준일 ex)201408231111 * @param interval : yyyy: 년, quart: 분기, mm: 월, week: 주, dd: 일, hh: 시간, mi: 분, ss: 초 * @param units : 증감 * @return {Date} */function dateAdd(date, interval, units) {	var ret = '';
	if(typeof date != 'undefined' && date != null && date != '') {
		// 년월일시분		if(date.length >= 12) {			ret = new Date(date.substring(0, 4), Number(date.substring(4, 6)) -1, date.substring(6, 8), date.substring(8, 10), date.substring(10, 12));		// 년월일		} else if(date.length >= 8) {			ret = new Date(date.substring(0, 4), Number(date.substring(4, 6)) -1, date.substring(6, 8));		}
		switch(interval.toLowerCase()) {	    	case 'yyyy' :  ret.setFullYear(ret.getFullYear() + units);  break;			case 'quart': ret.setMonth(ret.getMonth() + 3 * units);  break;			case 'mm' :  ret.setMonth(ret.getMonth() + units);  break;			case 'week' :  ret.setDate(ret.getDate() + 7 * units);  break;			case 'dd' :  ret.setDate(ret.getDate() + units);  break;			case 'hh' :  ret.setTime(ret.getTime() + units * 1000 * 60 * 60);  break;			case 'mi' :  ret.setTime(ret.getTime() + units * 1000 * 60);  break;			case 'ss' :  ret.setTime(ret.getTime() + units * 1000);  break;		    default : ret = '';  break;		}
		var cYear = ret.getFullYear();		var cMonth = ret.getMonth() + 1;		var cDay = ret.getDate();		var cHo = ret.getHours();		var cMi = ret.getMinutes();
		cMonth = cMonth < 10 ? "0" + cMonth : cMonth;		cDay = cDay < 10 ? "0" + cDay : cDay;		cHo = cHo < 10 ? "0" + cHo : cHo;		cMi = cMi < 10 ? "0" + cMi : cMi;
		if(date.length >= 12) {			ret = [cYear, cMonth, cDay, cHo, cMi].join(''); 		} else if(date.length >= 8) {			ret = [cYear, cMonth, cDay].join('');		}	}
	return ret;}
/* ---------------------------------------------------------------------------- * 특정 날짜에 대해 지정한 값만큼 뺀 날짜를 지정한  시작날짜 폼에 반환,  * 2011.04.05 ('','','','서버날짜')인자값 추가. * 20080301 에 1 개월 더하기 ==> setDate("fromdate", "todate", "month:1", "서버날짜"); // --------------------------------------------------------------------------- */function setDate(fdate, edate, addDate, currDate){	var tmpAddDate = addDate;	var tmpDate =  currDate.split(".");	var yy = tmpDate[0]; 	var mm = tmpDate[1];	var dd = tmpDate[2];	var nDate = currDate;
    if(tmpAddDate != ""){		tmpAddDate = addDate.split(":");		if(tmpAddDate[0] == "month"){			d  = new Date( yy, mm-1 - parseInt(tmpAddDate[1]), dd );     	    }else{ //tmpAddDate[0] = "day"	    	d  = new Date( yy, mm-1, dd - parseInt(tmpAddDate[1]) );     	    }
	    yy = d.getFullYear();	    mm = d.getMonth()+1;  mm = (mm<10) ? '0'+mm : mm;	    dd = d.getDate();     dd = (dd<10) ? '0'+dd : dd;
	    var cDate = yy+"."+mm+"."+dd;		if( document.MKD25!=null && typeof(document.MKD25)!="undefined" )			document.getElementById('MKD25').SkipVerify(1);	    $("#"+fdate).val(cDate);		$("#"+edate).val(nDate);		if( document.MKD25!=null && typeof(document.MKD25)!="undefined" )			document.getElementById('MKD25').SkipVerify(0);	}else{		if( document.MKD25!=null && typeof(document.MKD25)!="undefined" )			document.getElementById('MKD25').SkipVerify(1);		$("#"+fdate).val(nDate); 		$("#"+edate).val(nDate); 		if( document.MKD25!=null && typeof(document.MKD25)!="undefined" )			document.getElementById('MKD25').SkipVerify(0);	}}
/* 원하는 시간 형식으로 반환  * ex1) 6자리 입력시 (시간, 분, 초) * 		timeFormat('093020', ':') * 		result : 093020 -> 09:30:20 * ex2) 4자리 입력시 (시간, 분) * 		timeFormat('0930', ':') * 		result : 0930 -> 09:30 **/  function timeFormat(time, format) {	var result = "";	if(time.length == 6) {		result = time.substring(0, 2) + format + time.substring(2, 4) + format + time.substring(4);	} else if(time.length == 4) {		result = time.substring(0, 2) + format + time.substring(2);	}	return result;}
function dateReplace(obj){	if( document.MKD25!=null && typeof(document.MKD25)!="undefined" )		document.getElementById('MKD25').SkipVerify(1);
	obj.value=obj.value.replaceAll('.','');
	if( document.MKD25!=null && typeof(document.MKD25)!="undefined" )		document.getElementById('MKD25').SkipVerify(0);}
// 날짜비교하여 비교일수를 가져온다function calDateRange(val1, val2, FORMAT){    if (val1.length != 10 || val2.length != 10)        return null;
    if (val1.indexOf(FORMAT) < 0 || val2.indexOf(FORMAT) < 0)        return null;
    var start_dt = val1.split(FORMAT);    var end_dt = val2.split(FORMAT);
    start_dt[1] = (Number(start_dt[1]) - 1) + "";    end_dt[1] = (Number(end_dt[1]) - 1) + "";
    var from_dt = new Date(start_dt[0], start_dt[1], start_dt[2]);    var to_dt = new Date(end_dt[0], end_dt[1], end_dt[2]);
    return (to_dt.getTime() - from_dt.getTime()) / 1000 / 60 / 60 / 24;}
// 날짜텍스트, 포멧팅, 타입(1:년월일,2:월일,3:일) // 리턴 : 타입(1:년월일,2:월일,3:일)function calDateText(val, format, type){	var dateVal = "";
    if (val.length != 10)        return null;
    var val_dt = val.split(format);
    if(type == '1'){    	dateVal = val_dt[0] + "년 " + val_dt[1] + "월 " + val_dt[2] + "일";    }    else if(type == '2'){    	dateVal = val_dt[1] + "월 " + val_dt[2] + "일";    }    else if(type == '3'){    	dateVal = val_dt[2] + "일";    }    
    return dateVal;}
///////////////////////////////[TIME FORMAT]/////////////////////////////var TIMEFMT_HM24 = "24h:mm:ss";var TIMEFMT_HM24_SHRT = "24h:mm";function getFmtTime(value, fmtOpt) {	if(typeof value == 'undefined' || value==null)		value='';    	value = String(value);    if(value =='9991'){        return '장종료';    }
    var len = value.length;    var timeFormatted='';
    if(len>0)    {        if(fmtOpt == TIMEFMT_HM24_SHRT ) {            timeFormatted = value.substring(0,len-4)+":"+value.substring(len-4,len-2);        }else {            timeFormatted = value.substring(0,len-4)+":"+value.substring(len-4,len-2)+":"+value.substring(len-2,len);        }    }    return timeFormatted;};
//date 형식을 utc로 반환//value : YYYYMMDDhhmmssfunction getDateToUtc(value) {
    if(value == null || value.length == 0) {        return null;    }
    var dateYear = value.substring(0,4)||'9999';    var dateMonth = value.substring(4,6)||'12';    var dateDay = value.substring(6,8)||'01';    var dateHour = value.substring(8,10)||'00';    var dateMinute = value.substring(10,12)||'00';    var dateSecond = value.substring(12,14)||'00';
    return Date.UTC(Number(dateYear), Number(dateMonth)-1, Number(dateDay), Number(dateHour), Number(dateMinute), Number(dateSecond));}
//utc 데이터를 fmt 형시으로 변환하여 반환//value: utc 형식 데이터//fmt: 포맷형식(%Y%m%d%H%M%S)function getUtcToDate(value, fmt) {
    if(value == null || value.length == 0) {        return null;    }
    return Highcharts.dateFormat(fmt, value);}
///////////////////////////////[DATE FORMAT]/////////////////////////////var DATEFMT_HM24 = "yyyy-mm-dd";var DATEFMT_HM24_YM = "yyyy-mm";var DATEFMT_HM24_SHRT = "mm-dd";function getFmtDate(value, fmtOpt) {	if(typeof value == 'undefined' || value==null)		value='';    value = String(value);    var len = value.length;    var timeFormatted='';
    if(len>0)    {        if(fmtOpt == DATEFMT_HM24_SHRT ) {            timeFormatted = value.substring(len-4,len-2)+"-"+value.substring(len-2,len);        }else {            timeFormatted = value.substring(0,len-4)+"-"+value.substring(len-4,len-2)+"-"+value.substring(len-2,len);        }    }    //타당성체크    //dateutil.parse(value);    //dateutil.format( new Date(), 'Y-m-d' );    return timeFormatted;}
//몇달전function getDt7(s, i){	/* 2014-11-18, 사파리에서 에러남	var newDt = new Date(s);    newDt.setMonth( newDt.getMonth() - i );    newDt.setDate(0);    return converDateString(newDt);    */
	return addDate("m", (i * -1), s, "-");}
function addzero(n) {    return n < 10 ? "0"+n:n;}
//TODO : getDt가 월말 데이터를 가져와서 신규로 생성함(당일기준의  몇달전)function getBeforMon(date, i){    /*    var selectDate = date.split("-");    var changeDate = new Date();    changeDate.setFullYear(selectDate[0], selectDate[1]-i);
    var y = changeDate.getFullYear();    var m = changeDate.getMonth();    var d = changeDate.getDate();    if(m < 10)    { m = "0" + m; }    if(d < 10)    { d = "0" + d;}    var resultDate = y + "-" + m + "-" + d;    return resultDate;    */    var start = new Date(Date.parse(date)-0*1000*60*60*24);    if(i < 10) {        start.setMonth(start.getMonth()-i);    }    var yyyy = start.getFullYear();    var mm   = start.getMonth()+1;    var dd   = start.getDate();
    ////logger.og("==date 확인==");    //console.log(start.getMonth());    //console.log(mm);
    return yyyy+'-'+addzero(mm)+'-'+addzero(dd);}
//몇일 전function getDt9(s, i){	/* 2014-11-18, 사파리에서 에러남    var newDt = new Date(s);    newDt.setDate( newDt.getDate() - i );    return converDateString(newDt);    */
	return addDate("d", (i * -1), s, "-");}
function converDateString(dt){    return dt.getFullYear()+"-" + addZero(eval(dt.getMonth()+1)) + "-" + addZero(dt.getDate());}
function addZero(i){    var rtn = i + 100;    return rtn.toString().substring(1,3);}
///////현재 달의 첫일function firstDate() {     var firstDay = new Date();  // 현재달의 시작 일     var lastDay = new Date(firstDay.getTime());  // 현재달의 마지막 일
     firstDay.setDate(1);     lastDay.setMonth(lastDay.getMonth()+1);     lastDay.setDate(0);
     //달 첫일     var firstDayVal = firstDay.getFullYear()+"-"+("0"+(firstDay.getMonth()+1)).substr(("0"+(firstDay.getMonth()+1)).          length-2,2)+"-"+("0"+firstDay.getDate()).substr(("0"+firstDay.getDate()).length-2, 2);     //달 마지막     var lastDayVal = lastDay.getFullYear()+"-"+("0"+(lastDay.getMonth()+1)).substr(("0"+(lastDay.getMonth()+1)).          length-2, 2)+"-"+("0"+lastDay.getDate()).substr(("0"+lastDay.getDate()).length-2, 2);
     return firstDayVal;}
/** * 날짜취득 * @param sDate 스트링포맷형태의 날짜 2014-01-05 or 20140101, 2014-035 등 다 된다. * @returns */function getDate(sDate){    var rslt;    if(sDate && dateutil.parse(sDate)!='Invalid Date'){        rslt = dateutil.parse(sDate);    }else{        rslt = new Date();    }    return rslt;}