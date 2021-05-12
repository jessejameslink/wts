(function(window, $, undefined) {
  var nexUtils = function() {
    this.DATEFMT_HM24 = 'yyyy-mm-dd';
    this.DATEFMT_HM24_YM = 'yyyy-mm';
    this.DATEFMT_HM24_SHRT = 'mm-dd';

    this.TIMEFMT_HM24 = '24h:mm:ss';
    this.TIMEFMT_HM24_SHRT = '24h:mm';
  };

  nexUtils.prototype = {
		  
	/**
	* desc : JSON Object형태의 파라메터를 GET스트링으로 변환
	* date : 2016.02.18
	* author : 김행선
	* ex : convParam(object) 실행하면 해당 오브젝트를 ?를 포함한 GET인자 스트링으로 값을 반환함
	* @param {object} - Json Object명
	* @return {String}
	*/
	convParam: function (object) {
		var resultsArr = [];
		for (var p in object) {
			var value = object[p];
			if (value) {
				resultsArr.push(p.toString() + '=' + value);
			}
		}
		return resultsArr.join('&');
	}, 
		  
  /////////////////////////////// [DATE TIME FORMAT START] ///////////////////////////////

    /**
     * desc : 현재 날짜를 날짜 포맷에 맞게 출력
     * date : 2015.07.27
     * author : 이상우
     * ex : getDate() -> 20150722
     *   getDate(':') -> 2015:07:22
     * @param {String} pDelimiter : 구분자
     * @return {String}
     */
    getDate: function(pDelimiter) {
      var obj_date = new Date();
      var year = obj_date.getFullYear();
      var month = obj_date.getMonth() + 1;
      var date = obj_date.getDate();

      var ch_set = '';
      if (typeof pDelimiter != 'undefined' && pDelimiter != '') {
        ch_set = pDelimiter;
      }

      var ret = year;
      if (month.toString().length == 1)
        ret += ch_set + '0' + month;
      else
        ret += ch_set + month;

      if (date.toString().length == 1)
        ret += ch_set + '0' + date;
      else
        ret += ch_set + date;

      return ret;
    },
	/**
     * desc : 현재시간 반환
     * date : 2016.03.15
     * author : 김행선
     */
	getTime: function(pDelimiter) {
		var obj_date = new Date();
		var hour = obj_date.getHours();
		var min = obj_date.getMinutes();
		var sec = obj_date.getSeconds();

		var ret='';
		if (hour.toString().length == 1) {
			ret += '0' + hour;
		} else {
			ret += '' + hour;
		}

		if (min.toString().length == 1) {
			ret += '0' + min;
		} else {
			ret += '' + min;
		}

		if (sec.toString().length == 1) {
			ret += '0' + sec;
		} else {
			ret += '' + sec;
		}
		return ret;
    },

    /**
     * desc : 현재 날짜, 시간 반환
     * date : 2015.07.27
     * author : 이상우
     * ex : getDateFullTime() -> 2015.07.22 10:30:23
     *   getDateFullTime('-') -> 2015-07-22 10:30:23
     * @param {String} chSet : 날짜 구분자 '-' or '.'
     * @return {String} ret
     */
    getDateFullTime: function(chSet) {
      //날짜형식 yyyy.MM.dd hh:mm:ss에 맞게 출력
      var obj_date = new Date();
      var year = obj_date.getFullYear();
      var month = obj_date.getMonth() + 1;
      var date = obj_date.getDate();
      var hour = obj_date.getHours();
      var min = obj_date.getMinutes();
      var sec = obj_date.getSeconds();

      if (chSet != '.')
        chSet = '-';

      var ret = year;
      if (month.toString().length == 1) {
        ret += chSet + '0' + month;
      } else {
        ret += chSet + month;
      }

      if (date.toString().length == 1) {
        ret += chSet + '0' + date;
      } else {
        ret += chSet + date;
      }

      if (hour.toString().length == 1) {
        ret += ' 0' + hour;
      } else {
        ret += ' ' + hour;
      }

      if (min.toString().length == 1) {
        ret += ':0' + min;
      } else {
        ret += ':' + min;
      }

      if (sec.toString().length == 1) {
        ret += ':0' + sec;
      } else {
        ret += ':' + sec;
      }

      return ret;
    },

    /**
     * desc : 두 날짜를 비교, 일수로 반환( X = 기준일 - 비교일 )
     * date : 2015.07.27
     * author : 이상우
     * ex : cmpDate('2014-08-25','2014-08-22') -> 3
     *   cmpDate('2014.08.26 00:00:00','2014.08.22 02:09:00') -> 4
     * @param {String} base_date: 기준일(2014-08-23 11:12:12), 구분자 '-' 또는 '.'
     * @param {String} cmp_date : 비교일(2014-08-23 11:12:12), 구분자 '-' 또는 '.'
     * @return {Number} : 두 날짜의 차이(일 수)
     */
    cmpDate: function(base_date, cmp_date) {
      base_date = base_date.substring(0, 10);
      cmp_date = cmp_date.substring(0, 10);

      base_date = base_date.replace(/-/g, '.');
      cmp_date = cmp_date.replace(/-/g, '.');

      var tmp_arr = base_date.split('.');
      var tmp_date = new Date();
      tmp_date.setFullYear(tmp_arr[0]);
      tmp_date.setMonth(tmp_arr[1] - 1);
      tmp_date.setDate(tmp_arr[2]);

      var cmp_arr = cmp_date.split('.');
      var cmp_date = new Date();
      cmp_date.setFullYear(cmp_arr[0]);
      cmp_date.setMonth(cmp_arr[1] - 1);
      cmp_date.setDate(cmp_arr[2]);

      var ret_date = tmp_date.getTime() - cmp_date.getTime();

      return Math.floor(ret_date / (1000 * 60 * 60 * 24));
    },

    /**
     * desc : 날짜의 구분자 변환 후 반환
     * date : 2015.07.27
     * author : 이상우
     *
     * ex : dateFormat('20150722', '-') -> 2015-07-22
     *   dateFormat('201507','') -> 201507
     *   dateFormat('0722', '-') -> 07-22
     *   dateFormat('201507') -> 2015undefined07 (ERROR!!)
     *
     * @param {date} date: 'yyyyMMdd' or 'yyyyMM' or 'MMdd'
     * @param {string} format : 구분자('-' or '.' or ...)
     * @return {Date} result
     */
    dateFormat: function(date, format) {
      var result = "";

      if (date.length == 8) { // yyyyMMdd
        result = date.substring(0, 4) + format + date.substring(4, 6) + format + date.substring(6);
      } else if (date.length == 6) { // yyyyMM
        result = date.substring(0, 4) + format + date.substring(4);
      } else if (date.length == 4) { // MMdd
        result = date.substring(0, 2) + format + date.substring(2);
      }

      return result;
    },

    /**
     * desc : 특정 날짜에 대해 지정한 값 만큼 가감(+-)한 날짜를 반환
     * date : 2015.07.27
     * author : 이상우
     * ex : addDate('d', 3, '2008-08-01', '-') -> 2008-08-04 (+3일 결과값)
     *   addDate('m', 8, '20080301', '') ->  20081101 (+8개월 결과값)
     * @param pInterval: 'yyyy', 'm', 'd'
     * @param pAddVal : 가감할 값, 가감 하고자 하는 값 - 정수형
     * @param pYyyymmdd : 기준일, '2015-07-22', '20150722'
     * @param pDelimiter : 구분자, '-' or '' or '.' or ...
     * @return {Date}
     */
    addDate: function(pInterval, pAddVal, pYyyymmdd, pDelimiter) {
      var yyyy, mm, dd, c_date, o_date;
      var c_year, c_month, c_day;

      if (pDelimiter != '') {
        pYyyymmdd = pYyyymmdd.replace(eval('/\\' + pDelimiter + '/g'), '');
      }

      yyyy = pYyyymmdd.substr(0, 4);
      mm = pYyyymmdd.substr(4, 2);
      dd = pYyyymmdd.substr(6, 2);

      if (pInterval == 'yyyy') {
        yyyy = (yyyy * 1) + (pAddVal * 1);
      } else if (pInterval == 'm') {
        mm = (mm * 1) + (pAddVal * 1);
      } else if (pInterval == 'd') {
        dd = (dd * 1) + (pAddVal * 1);
      }

      c_date = new Date(yyyy, mm - 1, dd); // 12월, 31일을 초과하는 입력값에 대해 자동으로 계산된 날짜가 만들어짐.

      c_year = c_date.getFullYear();
      c_month = c_date.getMonth() + 1;
      c_day = c_date.getDate();
      c_month = c_month < 10 ? '0' + c_month : c_month;
      c_day = c_day < 10 ? '0' + c_day : c_day;

      if (pDelimiter != '') {
        return c_year + pDelimiter + c_month + pDelimiter + c_day;
      } else {
        return '' + c_year + c_month + c_day;
      }
    },

    /**
     * desc : 특정 날짜에 대해 지정한 값만큼 가감(+-)한 날짜를 반환
     * date : 2015.07.27
     * author : 이상우
     * ex : addDateFullTime('20150722', 'yyyy', 1) -> 20160722
     *   addDateFullTime('20150722120511', 'mi', 5) -> 201507221210
     * @param date : 기준일, 201408231111 (yyyyMMddhhmm)
     * @param interval : yyyy: 년, quart: 분기, mm: 월, week: 주, dd: 일, hh: 시간, mi: 분, ss: 초
     * @param units : 가감할 값
     * @return {Date} : yyyyMMddhhmm
     */
    addDateFullTime: function(date, interval, units) {
      var ret = '';

      if (typeof date != 'undefined' && date != null && date != '') {
        if (date.length >= 12) { // 년월일시분
          ret = new Date(date.substring(0, 4), Number(date.substring(4, 6)) - 1, date.substring(6, 8), date.substring(8, 10), date.substring(10, 12));
        } else if (date.length >= 8) { // 년월일
          ret = new Date(date.substring(0, 4), Number(date.substring(4, 6)) - 1, date.substring(6, 8));
        }

        switch (interval.toLowerCase()) {
          case 'yyyy':
            ret.setFullYear(ret.getFullYear() + units);
            break;
          case 'quart':
            ret.setMonth(ret.getMonth() + 3 * units);
            break;
          case 'mm':
            ret.setMonth(ret.getMonth() + units);
            break;
          case 'week':
            ret.setDate(ret.getDate() + 7 * units);
            break;
          case 'dd':
            ret.setDate(ret.getDate() + units);
            break;
          case 'hh':
            ret.setTime(ret.getTime() + units * 1000 * 60 * 60);
            break;
          case 'mi':
            ret.setTime(ret.getTime() + units * 1000 * 60);
            break;
          case 'ss':
            ret.setTime(ret.getTime() + units * 1000);
            break;
          default:
            ret = '';
            break;
        }

        var c_year = ret.getFullYear(),
          c_month = ret.getMonth() + 1,
          c_day = ret.getDate(),
          c_ho = ret.getHours(),
          c_mi = ret.getMinutes();

        c_month = c_month < 10 ? '0' + c_month : c_month;
        c_day = c_day < 10 ? '0' + c_day : c_day;
        c_ho = c_ho < 10 ? '0' + c_ho : c_ho;
        c_mi = c_mi < 10 ? '0' + c_mi : c_mi;

        if (date.length >= 12) {
          ret = [c_year, c_month, c_day, c_ho, c_mi].join('');
        } else if (date.length >= 8) {
          ret = [c_year, c_month, c_day].join('');
        }
      }

      return ret;
    },

    /**
     * desc : 특정 날짜에 대해 지정한 값만큼 뺀 날짜를 지정한 시작날짜 폼에 반환
     * date : 2015.07.22
     * author : 이상우
     * ex : setDate('fromdate', 'todate', 'month:1', '2015.07.22');
     * @param {String} fdate: fdate 엘리먼트 ID
     * @param {String} edate : edate 엘리먼트 ID
     * @param {String} addDate : month:1, day:1 (가감할 개월,일)
     * @param {String} currDate : yyyy.MM.dd 형식의 날짜
     */
    setDateForm: function(fdate, edate, addDate, currDate) {
      var tmpAddDate = addDate;
      var tmpDate = currDate.split('.');
      var yy = tmpDate[0];
      var mm = tmpDate[1];
      var dd = tmpDate[2];
      var nDate = currDate;
      var d;

      if (tmpAddDate != '') {
        tmpAddDate = addDate.split(':');
        if (tmpAddDate[0] == 'month') {
          d = new Date(yy, mm - 1 - parseInt(tmpAddDate[1]), dd);
        } else { //tmpAddDate[0] = 'day'
          d = new Date(yy, mm - 1, dd - parseInt(tmpAddDate[1]));
        }

        yy = d.getFullYear();
        mm = d.getMonth() + 1;
        mm = (mm < 10) ? '0' + mm : mm;
        dd = d.getDate();
        dd = (dd < 10) ? '0' + dd : dd;

        var cDate = yy + '.' + mm + '.' + dd;

        //if(document.MKD25 != null && typeof(document.MKD25) != 'undefined')
        //document.getElementById('MKD25').SkipVerify(1);
        $('#' + fdate).val(cDate);
        $('#' + edate).val(nDate);
        //if(document.MKD25 != null && typeof(document.MKD25) != 'undefined')
        //document.getElementById('MKD25').SkipVerify(0);
      } else {
        //if(document.MKD25 != null && typeof(document.MKD25) != 'undefined')
        //document.getElementById('MKD25').SkipVerify(1);
        $('#' + fdate).val(nDate);
        $('#' + edate).val(nDate);
        //if( document.MKD25 != null && typeof(document.MKD25) != 'undefined')
        //document.getElementById('MKD25').SkipVerify(0);
      }
    },

    /**
     * desc : 특정 시간을 포맷을 변경하여 반환
     * date : 2015.07.22
     * author : 이상우
     * ex : getFmtTime(103023, '24h:mm') -> 10:30
     *    getFmtTime('103023', '24h:mm:ss') -> 10:30:23
     * @param value : 기준 시간
     * @param {String} fmtOpt : 포맷 옵션 '24h:mm:ss', '24h:mm '
     * @return {String}
     */
    timeFormat: function(value, fmtOpt) {
      if (typeof value == 'undefined' || value == null)
        value = '';

      value = String(value);

      var len = value.length;

      var timeFormatted = '';

      if (len > 0) {
        if (fmtOpt == this.TIMEFMT_HM24_SHRT) {
          timeFormatted = value.substring(0, len - 4) + ':' + value.substring(len - 4, len - 2);
        } else {
          timeFormatted = value.substring(0, len - 4) + ':' + value.substring(len - 4, len - 2) + ':' + value.substring(len - 2, len);
        }
      }

      return timeFormatted;
    },

    /**
     * desc : 두 날짜 사이의 차이를 반환
     * date : 2015.07.22
     * author : 이상우
     * ex : dateDiff('2015-07-22', '2015-07-23', '-') -> 1
     * @param {String} val1: '2015-07-22'
     * @param {String} val2 : '2015-07-23'
     * @param {String} format : '-' 구분자
     * @return {String}
     */
    dateDiff: function(val1, val2, format) {
      if (val1.length != 10 || val2.length != 10)
        return null;

      if (val1.indexOf(format) < 0 || val2.indexOf(format) < 0)
        return null;

      var start_dt = val1.split(format);
      var end_dt = val2.split(format);

      start_dt[1] = (Number(start_dt[1]) - 1) + '';
      end_dt[1] = (Number(end_dt[1]) - 1) + '';

      var from_dt = new Date(start_dt[0], start_dt[1], start_dt[2]);
      var to_dt = new Date(end_dt[0], end_dt[1], end_dt[2]);

      return (to_dt.getTime() - from_dt.getTime()) / 1000 / 60 / 60 / 24;
    },

    /**
     * desc : 특정 날짜 형태를 한글포맷 변경
     * date : 2015.07.22
     * author : 이상우
     * ex : dateFormatKR('2015-07-22', '-', 1) -> 2015년 07월 22일
     *    dateFormatKR('2015-07-22', '-', 2) -> 07월 22일
     *    dateFormatKR('2015-07-22', '-', 3) -> 22일
     * @param {String} val: 기준일
     * @param {String} format : yyyy: 년, quart: 분기, mm: 월, week: 주, dd: 일, hh: 시간, mi: 분, ss: 초
     * @param {Number} type : 포맷형식 (1 -> 2015년 07월 22일), (2-> 07월 22일), (3 -> 22일)
     * @return {String}
     */
    dateFormatKR: function(val, format, type) {
      var date_val = '';

      if (val.length != 10)
        return null;

      var val_dt = val.split(format);

      if (type == '1') {
        date_val = val_dt[0] + '년 ' + val_dt[1] + '월 ' + val_dt[2] + '일';
      } else if (type == '2') {
        date_val = val_dt[1] + '월 ' + val_dt[2] + '일';
      } else if (type == '3') {
        date_val = val_dt[2] + '일';
      }

      return date_val;
    },

    /**
     * desc : yyyyMMddhhmmss -> utc 변경
     * date : 2015.07.22
     * author : 이상우
     * ex : date2Utc('20150722103023') -> 1437561023000
     * @param {String} value : yyyyMMddhhmmss 형식의 날짜, '20150722103023'
     * @return {String} : utc 변환값
     */
    date2Utc: function(value) {
      if (value == null || value.length == 0) {
        return null;
      }

      var date_year = value.substring(0, 4) || '9999';
      var date_month = value.substring(4, 6) || '12';
      var date_day = value.substring(6, 8) || '01';
      var date_hour = value.substring(8, 10) || '00';
      var date_minute = value.substring(10, 12) || '00';
      var date_second = value.substring(12, 14) || '00';

      return Date.UTC(Number(date_year), Number(date_month) - 1, Number(date_day), Number(date_hour), Number(date_minute), Number(date_second));
    },

    /**
     * desc : utc -> fmt 변경
     * date : 2015.07.22
     * author : 이상우
     * ex : utc2Date(1437561023000) -> 2015-07-22 10:30:23
     * @param value: utc 형식 데이터
     * @param {String} fmt : %Y%m%d%H%M%S 포맷형식
     * @return {String}
     */
    utc2Date: function(value, fmt) {
      if (value == null || value.length == 0) {
        return null;
      }

      return Highcharts.dateFormat(fmt, value);
    },

    /**
     * desc : 특정 날짜에서 몇 달 전 날짜를 반환
     * date : 2015.07.22
     * author : 이상우
     * ex : getDateAgo('20150722', 3) -> 2015-04-22
     * @param s: '20150722'
     * @param i : 몇달 전 (ex - 3 : 3 개월 전)
     * @return {Date}
     */
    getDateAgo: function(s, i) {
      /* 2014-11-18, 사파리에서 에러남
      var newDt = new Date(s);
      newDt.setMonth( newDt.getMonth() - i );
      newDt.setDate(0);
      return converDateString(newDt);
      */
      return this.addDate('m', (i * -1), s, '-');
    },

    /**
     * desc : 한 자리 숫자일 경우, 01, 02과 형태로 변환
     * date : 2015.07.22
     * author : 이상우
     * ex : addZero1(1) -> '01'
     *    addZero1(10) -> 10
     *    addZero1(10000) -> 10000
     * @param {Number} n: 숫자
     * @return
     */
    addZero1: function(n) {
      return n < 10 ? '0' + n : n;
    },

    /**
     * desc : 숫자를 두 자리 수로 변경, 두 자리 초과면 버림
     * date : 2015.07.22
     * author : 이상우
     * ex : addZero2(1) -> '01'
     *   addZero2(10) -> '10'
     *   addZero2(100) -> '00'
     * @param {Number} i : 두 자리 표현하려는 숫자
     * @return {String}
     */
    addZero2: function(i) {
      var rtn = i + 100;
      return rtn.toString().substring(1, 3);
    },

    /**
     * desc : Date object -> yyyy-MM-dd 포맷 변경
     * date : 2015.07.22
     * author : 이상우
     * ex : converDateString({Date}) -> '2015-07-22'
     * @param {Date} dt: Date 객체
     * @return {String}
     */
    converDateString: function(dt) {
      return dt.getFullYear() + '-' + this.addZero2(eval(dt.getMonth() + 1)) + '-' + this.addZero2(dt.getDate());
    },

    /**
     * desc : 현재 달의 첫 일 반환
     * date : 2015.07.22
     * author : 이상우
     * ex : firstDate() -> 2015-07-01
     * @return {Date} : yyyy-MM-dd
     */
    firstDate: function() {
      var first_day = new Date(); // 현재달의 시작 일
      var last_day = new Date(first_day.getTime()); // 현재달의 마지막 일

      first_day.setDate(1);
      last_day.setMonth(last_day.getMonth() + 1);
      last_day.setDate(0);

      //달 첫일 - 2015-07-01
      var first_day_val = first_day.getFullYear() + '-' + ('0' + (first_day.getMonth() + 1)).substr(('0' + (first_day.getMonth() + 1)).length - 2, 2) + '-' + ('0' + first_day.getDate()).substr(('0' + first_day.getDate()).length - 2, 2);

      //달 마지막 - 2015-07-31
      var last_day_val = last_day.getFullYear() + '-' + ('0' + (last_day.getMonth() + 1)).substr(('0' + (last_day.getMonth() + 1)).length - 2, 2) + '-' + ('0' + last_day.getDate()).substr(('0' + last_day.getDate()).length - 2, 2);

      return first_day_val;
    },

    /////////////////////////////// [NUMBER FORMAT START] ///////////////////////////////
    /**
     * desc : 콤마(,) 모두 제거하여 반환
     * date : 2015.07.22
     * author : 이상우
     * ex : inputComma('123,456,789') -> 123456789
     * @param {String} val: 콤마가 포함된 숫자형태의 문자
     * @return {Number}
     */
    removeComma: function(val) {
      var comma_value = this.numberWithCommas(val.replace(/,/g, ''));
      if (!comma_value) {
        comma_value = '';
      }

      return comma_value;
    },

    /**
     * desc : 첫 번째 인자(val)가 null, '', undefined일 경우 두 번째 인자(defaultStr) 반환
     * date : 2015.07.22
     * author : 이상우
     * ex : nvl(val , defaultStr) -> 0 또는 val
     * @param val
     * @param {String} defaultStr : 기본값
     * @return {String}
     */
    nvl: function(val, defaultStr) {
      if (typeof defaultStr == 'undefined' || defaultStr == null || defaultStr == '') {
        defaultStr = 0;
      }

      if (typeof val == 'undefined' || val == null || val == '') {
        return defaultStr;
      }

      return val;
    },

    /**
     * desc : 한글금액과 숫자금액 자동생성
     * date : 2015.07.22
     * author : 이상우
     * ex : MoneyFormat(objectId, han_id, '원') -> ???? 원
     * @param objectId : input 오브젝트ID값
     * @param han_id : 한글숫자 보여질 영역 ID 값
     * @param text : 금액뒤에 덧붙일 글자, 기본값 : 원 (예 : 원, won, 달러, $)
     * @return {Date}
     */
    MoneyFormat: function(objectId, han_id, text) {
      var object = document.getElementById(objectId);
      object.style.textAlign = "right";
      //object.style.paddingRight="5px";

      if (typeof text == 'undefind' || text == null)
        text = '';

      if (object.setSelectionRange) {
        object.focus();
        object.setSelectionRange(object.value.length, object.value.length);
      } else if (object.createTextRange) {
        var range = object.createTextRange();
        range.collapse(true);
        range.moveEnd('character', object.value.length);
        range.moveStart('character', object.value.length);
        range.select();
      }
      var val = object.value;

      if (val != '') {
        if (val.substring(0, 1) == "0")
          object.value = "";
        else {
          //if( document.MKD25!=null && typeof(document.MKD25)!="undefined" )
          //  document.getElementById('MKD25').SkipVerify(1);

          object.value = String(parseInt(val.replace(/\,/g, ''))).commify();

          //if( document.MKD25!=null && typeof(document.MKD25)!="undefined" )
          //  document.getElementById('MKD25').SkipVerify(0);
        }
      }

      var number_length = object.value.replace(/\,/g, '').length;

      if (typeof han_id == 'undefind' || han_id == null || han_id == '')
        return;

      var obj = document.getElementById(han_id);

      if (number_length < 16) {
        var han_money = numberToHan(object.value);

        if (han_money != '')
          obj.innerHTML = han_money.replace(/(^\s*)|(\s*$)/gi, "") + ' ' + text;
        else
          obj.innerHTML = '';
      } else {
        object.value = '';
        obj.innerHTML = '';
      }
    },

    /**
     * desc : 오브젝트 숫자 값에 숫자 더하기
     * date : 2015.07.23
     * author : 이상우
     * ex : numberPlus(objectId, number, commify, allNumberName) -> 20160722
     * @param objectId : input 오브젝트ID값
     * @param number : 더하기 할 숫자
     * @param commify : true, false ( 숫자 콤마 찍기 )
     * @param allNumberName : 가져올 변수값 이름
     */
    numberPlus: function(objectId, number, commify, allNumberName) {
      var object = document.getElementById(objectId);
      if (typeof number == 'undefind' || number == null) {
        object.value = '';
        return;
      }

      if (document.MKD25 != null && typeof(document.MKD25) != "undefined")
        document.getElementById('MKD25').SkipVerify(1);

      if (object.value.trim() == '')
        object.value = '0';
      var number_value = parseInt(object.value.replace(/\,/g, ''));
      var val;

      if (typeof number != 'number') {
        if (number == 'all') {
          val = eval(allNumberName);
          if (commify) object.value = String(val).commify();
          else object.value = val;
          return;
        } else
          val = parseInt(number.replace(/\,/g, ''));
      } else
        val = number;

      if (commify)
        object.value = String(number_value + val).commify();
      else
        object.value = number_value + val;

      if (document.MKD25 != null && typeof(document.MKD25) != "undefined")
        document.getElementById('MKD25').SkipVerify(0);
    },

    /**
     * desc : 숫자를 한글로 표기 변환 함수
     * date : 2015.07.23
     * author : 이상우
     * ex : numberToHan('1000000') -> 백만
     * @param {String} val : 숫자로된 금액 (예 : '1000000' 또는 '100,000,000')
     * @return {String} han_str : 한글로 변환데이터 (예: 천백만 이천삼 )
     */
    numberToHan: function(val) {
      var num_str = val.replace(/\,/g, '');

      if (num_str.length > 15)
        return '';

      var arr_num = new Array(10);
      arr_num[0] = '';
      arr_num[1] = '일';
      arr_num[2] = '이';
      arr_num[3] = '삼';
      arr_num[4] = '사';
      arr_num[5] = '오';
      arr_num[6] = '육';
      arr_num[7] = '칠';
      arr_num[8] = '팔';
      arr_num[9] = '구';

      var arr_unit = new Array(15);
      arr_unit[0] = '';
      arr_unit[1] = '십';
      arr_unit[2] = '백';
      arr_unit[3] = '천';
      arr_unit[4] = '만 ';
      arr_unit[5] = '십만 ';
      arr_unit[6] = '백만 ';
      arr_unit[7] = '천만 ';
      arr_unit[8] = '억 ';
      arr_unit[9] = '십억 ';
      arr_unit[10] = '백억 ';
      arr_unit[11] = '천억 ';
      arr_unit[12] = '조 ';
      arr_unit[13] = '십조 ';
      arr_unit[14] = '백조 ';

      var han_str = '';
      var arr_str = new Array();
      var code = num_str.length;

      for (var i = 0; i < code; i++)
        arr_str[i] = num_str.substring(i, i + 1);

      var temp_unit;
      var a1 = 0,
        a2 = 0,
        a3 = 0,
        b1 = 0,
        b2 = 0,
        b3 = 0;

      for (var i = 0; i < num_str.length; i++) {
        code--;
        temp_unit = '';

        if (arr_num[parseInt(arr_str[i])] != '') {
          temp_unit = arr_unit[code];
          if (code > 4) {
            a1 = code / 4;
            a2 = (code - 1) / 4;
            a3 = (code - 2) / 4;
            b1 = Math.floor(a1);
            b2 = Math.floor(a2);
            b3 = Math.floor(a3);
            if ((b1 == b2 && arr_num[parseInt(arr_str[i + 1])] != '') || (b1 == b3 && arr_num[parseInt(arr_str[i + 2])] != ''))
              temp_unit = arr_unit[code].substring(0, 1);
          }
        }
        han_str = han_str + (arr_num[parseInt(arr_str[i])] + temp_unit);
      }

      return han_str;
    },
	
/**

		numberFormat : 천단위 콤마찍기, 소수점 이하 자리수 처리

		numberFormat("123456.12",3) => 123,456.120

	**/

	
	numberFormat:function(num, cipher){

		if(String(num).indexOf('.')>-1) {
			var arr_num=String(num).split('.');
			var number=String(arr_num[0]).commify()+'.'+String(arr_num[1]).rPad(cipher,'0');
			return number;
		} else {
			var number=String(num).commify()+'.'+String('').rPad(cipher,'0');
			return number;
		}

	},

    /**
     * desc : 세 자리마다 콤마 추가와 소수점자리 반환
     * date : 2015.07.23
     * author : 이상우
     * ex : remakeNumber(123456789, 3, 1) -> '12,345.6'
     * @param {Number} no : 인자값
     * @param {Number} away : 뒤에서부터 제거할 자리
     * @param {Number} small_cipher : 소수점자리
     * @return {String}
     */
    remakeNumber: function(no, away, small_cipher) {
      var minus = no.charAt(0) == '-';
      var num = minus ? no.substring(1) : no;
      if (num == null || num == "0") {
        num = 0;
      } else {
        small_cipher = small_cipher == null ? 0 : parseInt(small_cipher);
        away = away == null ? 0 : parseInt(away);
        var sp = num.substring(0, num.length - away);
        if (small_cipher > sp.length) {
          sp = lfill(sp, small_cipher + 1, '0');
        } else if (small_cipher == sp.length) {
          sp = "0" + sp;
        }
        num = sp.substring(0, sp.length - small_cipher) + "." + sp.substring(sp.length - small_cipher, sp.length);
      }
      num = minus ? "-" + num : num;

      return this.numberFormat(num, small_cipher);
    },

    /**
     * desc : 소수점 데이터를 % 형태로 반환
     * date : 2015.07.23
     * author : 이상우
     * ex : pecent(0.7869, 2) -> 78.69
     * @param {Number} data : 인자값
     * @param {Number} pow : 소수점 자리수
     * @return
     */
    pecent: function(data, pow) {
      return Math.floor(parseFloat(data * Math.pow(10, (pow + 2)))) / Math.pow(10, pow);
    },

    /**
     * desc : 소수점 데이터를 % 형태로 반환
     * date : 2015.07.23
     * author : 이상우
     * ex : cPecent(0.123, 2, 'floor') -> 12.3
     * @param data : 인자값
     * @param pow : 소수점 자리
     * @param gbn : ( 반올림 : round, 버림 : floor, 올림 : ceil ) default - round
     * @return {Date}
     */
    cPecent: function(data, pow, gbn) {
      var val = 0;

      if (data == null || data == '') {
        val = 0;
      }

      if (gbn == 'ceil') { // 올림
        val = Math.ceil(parseFloat(data * Math.pow(10, (pow + 2)))) / Math.pow(10, pow);
      } else if (gbn == 'floor') { // 버림
        val = Math.floor(parseFloat(data * Math.pow(10, (pow + 2)))) / Math.pow(10, pow);
      } else { // 반올림
        val = Math.round(parseFloat(data * Math.pow(10, (pow + 2)))) / Math.pow(10, pow);
      }

      return val;
    },

    /**
     * desc : 소수점 num 자리이하 올림
     * date : 2015.07.23
     * author : 이상우
     * ex : ceil(123456.21, 0) -> 123457
     *    ceil(123456.78, 1) -> 123456.8
     * @param {Number} retVal : 올림할 숫자
     * @param {Number} num : 소수점자리
     * @return
     */
    ceil: function(retVal, num) {
      try {
        var i = 1.0;
        for (var a = 0; a < num; a++) {
          i = i * 10.0;
        }
        retVal = parseFloat(Math.ceil(retVal * i) / i);
      } catch (e) {

      }

      return retVal;
    },

    /**
     * desc : 소수점 반올림함수
     * date : 2015.07.23
     * author : 이상우
     * ex : round(123456.21, 1) -> 123456.2
     *    round(123456.78, 1) -> 123456.8
     * @param {Number} retVal : 반올림할 숫자
     * @param {Number} num : 반올림된 수(default : 소수 2째자리)
     * @return
     */
    round: function(retVal, num) {
      try {
        var i = 1.0;
        var pos = 2;

        if (typeof num != 'undefined' && num != null && num != '') {
          pos = num;
        }

        for (var a = 0; a < pos; a++) i = i * 10.0;

        retVal = parseFloat((Math.round(retVal * i) / i));
      } catch (e) {

      }
      return retVal;
    },

    /**
     * desc : 소수점 num자리이하 버림
     * date : 2015.07.23
     * author : 이상우
     * ex : floor(123456.23, 1) -> 123456.2
        floor(123456.78, 1) -> 123456.7
     * @param retVal : 변경할 값
     * @param num : 소수점자리
     * @return
     */
    floor: function(retVal, num) {
      try {
        var i = 1.0;

        for (var a = 0; a < num; a++) i = i * 10.0;

        retVal = parseFloat(Math.floor(retVal * i) / i);
      } catch (e) {

      }

      return retVal;
    },

    /**
     * desc : double 실수 일경우 소숫점 까지해서 반환
     * date : 2015.07.23
     * author : 이상우
     * ex : getParseDouble('-000003230', 2) -> '-32.30'
     * @param sVal : 변경할 값
     * @param sosu : 소수점자리
     * @return
     */
    getParseDouble: function(sVal, sosu) {
      var d_val = 0.0;

      try {

        if (typeof sVal != "undefined" && sVal != null && sVal.trim().length > 0) {

          sVal = sVal.lTrim();
          // 부호값을 1바이트 잘라낸다.
          var sign = sVal.substring(0, 1);

          // 부호값이 아닌값이면
          if (sign != "+" && sign != "-") {
            sign = "";
          }

          d_val = parseFloat(sVal);
          var div = 1.0;

          for (var i = 0; i < sosu; i++) {
            div *= 10;
          }
          d_val = d_val / div;

          // -0이 나오지 않기 위해 사용
          if (d_val == 0) {
            d_val = 0;
          }
          sVal = this.formatDouble(d_val, sosu);

          // -인 값은 sVal에 -가 이미 붙어있음
          if (sign != "-") {
            sVal = sign + sVal;
          }

        }
      } catch (e) {

      }

      return sVal;
    },

    /**
     * desc : double value 값을 입력하여 sosu 자리수만큼 소수점을 찍는다.
     * date : 2015.07.23
     * author : 이상우
     * ex : formatDouble('122.22', 2) -> 122.22
     *    formatDouble('122.22', 3) -> 122.220
     *    formatDouble('12222', 2) -> 12,222.00
     * @param {String} amount : 변경할 값
     * @param sosu : 소수점자리
     * @return
     */
    formatDouble: function(amount, sosu) {
      var pattern = "";
      var sosu_pattern = "";
      try {
        for (var i = 0; i < sosu; i++) {
          sosu_pattern += "0";
        }
        if (sosu_pattern != "") {
          pattern = "0." + sosu_pattern;
        } else {
          pattern = "0";
        }

        amount = this.round(amount, 2);
        amount = this.numberFormat(String(amount), sosu);

      } catch (e) {

      }

      return amount;
    },

    // // pass num1.commify() is not a function
    // /**
    //  * desc : 양수(빨강), 음수(파랑) 표현
    //  * date : 2015.07.23
    //  * author : 이상우
    //  * ex : getUpDown('1000', 'true', '%', 'true')
    //  * @param val : 변경할 값
    //  * @param signGbn : true - 부호표시, false - 부호 생략
    //  * @param sign : 백분율 표시(%)등
    //  * @param moneyFormat : 금액형태로 표시
    //  * @return
    //  */
    // getUpDown: function(val, signGbn, sign, moneyFormat) {
    //     var return_val = '';

    //     if (val != null && val != '') {
    //         // 금액 형식일 경우
    //         if (val.indexOf(",") != -1) {
    //             val = val.rmcomma();
    //         }
    //         return_val = val + sign;

    //         // 금액 형식으로 표현
    //         if (moneyFormat == 'true') {
    //             return_val = val.commify() + sign;
    //         }

    //         var num1 = Number(val);

    //         if (num1 > 0) {
    //             if (signGbn == "true") {
    //                 return_val = "<font class=\"up\">" + num1 + sign + "</font>";
    //                 if (moneyFormat == 'true') {
    //                     return_val = "<font class=\"up\">" + num1.commify() + sign + "</font>";
    //                 }
    //             } else {
    //                 return_val = "<font class=\"up\">" + Math.abs(num1) + sign + "</font>";
    //                 if (moneyFormat == 'true') {
    //                     return_val = "<font class=\"up\">" + Math.abs(num1).toString().commify() + sign + "</font>";
    //                 }
    //             }
    //         } else if (num1 < 0) {
    //             if (signGbn == "true") {
    //                 return_val = "<font class=\"down\">" + num1 + sign + "</font>";
    //                 if (moneyFormat == 'true') {
    //                     return_val = "<font class=\"down\">" + num1.commify() + sign + "</font>";
    //                 }
    //             } else {
    //                 return_val = "<font class=\"down\">" + Math.abs(num1) + sign + "</font>";
    //                 if (moneyFormat == 'true') {
    //                     return_val = "<font class=\"down\">" + Math.abs(num1).toString().commify() + sign + "</font>";
    //                 }
    //             }
    //         }
    //     }

    //     return return_val;
    // },

    // // pass num1.commify() is not a function
    // *
    //  * desc : 양수(빨강), 음수(파랑) 표현
    //  * date : 2015.07.23
    //  * author : 이상우
    //  * ex : getUpDown2('1000', 'true', '%', 'true') -> 20160722
    //  * @param val : 변경할 값
    //  * @param signGbn : true - 부호표시, false - 부호 생략
    //  * @param sign : 백분율 표시(%)등
    //  * @param moneyFormat : 금액형태로 표시
    //  * @return

    // getUpDown2: function(val, signGbn, sign, moneyFormat) {
    //     var return_val = '';

    //     if (val != null && val != '') {
    //         // 금액 형식일 경우
    //         if (val.indexOf(",") != -1) {
    //             val = val.rmcomma();
    //         }

    //         return_val = val + sign;

    //         // 금액 형식으로 표현
    //         if (moneyFormat == 'true') {
    //             return_val = val.commify() + sign;
    //         }

    //         var num1 = Number(val);

    //         if (num1 > 0) {
    //             if (signGbn == "true") {
    //                 return_val = "<span class=\"revise_up fl tx_skip\">up</span><strong class=\"fr\">" + num1 + sign + "</strong>";

    //                 if (moneyFormat == 'true') {
    //                     return_val = "<span class=\"revise_up fl tx_skip\">up</span><strong class=\"fr\">" + num1.commify() + sign + "</strong>";
    //                 }
    //             } else {
    //                 return_val = "<span class=\"revise_up fl tx_skip\">up</span><strong class=\"fr\">" + Math.abs(num1) + sign + "</strong>";

    //                 if (moneyFormat == 'true') {
    //                     return_val = "<span class=\"revise_up fl tx_skip\">up</span><strong class=\"fr\">" + Math.abs(num1).toString().commify() + sign + "</strong>";
    //                 }
    //             }
    //         } else if (num1 < 0) {
    //             if (signGbn == "true") {
    //                 return_val = "<span class=\"revise_dw fl tx_skip\">down</span><strong class=\"fr\">" + num1 + sign + "</strong>";

    //                 if (moneyFormat == 'true') {
    //                     return_val = "<span class=\"revise_dw fl tx_skip\">down</span><strong class=\"fr\">" + num1.commify() + sign + "</strong>";
    //                 }
    //             } else {
    //                 return_val = "<span class=\"revise_dw fl tx_skip\">down</span><strong class=\"fr\">" + Math.abs(num1) + sign + "</strong>";

    //                 if (moneyFormat == 'true') {
    //                     return_val = "<span class=\"revise_dw fl tx_skip\">down</span><strong class=\"fr\">" + Math.abs(num1).toString().commify() + sign + "</strong>";
    //                 }
    //             }
    //         }
    //     }

    //     return return_val;
    // },

    /////////////////////////////[MONEY FORMAT]/////////////////////////////
    /**
     * desc : 100으로 나누어 퍼센테이지로 표시(소수점 2자리)
     * date : 2015.07.23
     * author : 이상우
     * ex : toPer(30) -> 0.30
     * @param {Number} val : 변경할 값
     * @return
     */
    toPer: function(val) {
      val = (val / 100).toFixed(2);
      return val;
    },

    /**
     * desc : 어제와 오늘의 차이값을 퍼센테이지로 반환(오늘데이터 - 어제데이터 / 100), 소수점 2자리
     * date : 2015.07.23
     * author : 이상우
     * ex : dayPer(30, 50) -> 66.67
     * @param {Number} yesterday : 어제 데이터
     * @param {Number} today : 오늘 데이터
     * @return {Number}
     */
    dayPer: function(yesterday, today) {
      if (yesterday == 0) {
        return null;
      }

      if (today) {
        val = ((today - yesterday) / yesterday * 100).toFixed(2);
      } else {
        val = null;
      }

      return val;
    },

    // subtype???????
    /**
     * desc : 한글금액과 숫자금액 자동생성
     * date : 2015.07.23
     * author : 이상우
     * ex : num2money('1000', false) -> 1,000
     * @param {String} val : 변경할 값
     * @param {String} subtype :
     * @return {String} val2 :
     */
    num2money: function(val, subtype) {
      if (typeof val == 'undefined' || val == '') {
        return val;
      }

      if (isNaN(val)) {
        var val2 = "";

        if (val.toString().indexOf(".") >= 0) {
          var n_val = val.split(".");
          val2 = n_val[0].toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + '.' + n_val[1];
        } else {
          val2 = val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }
        return val2;
      }

      if (subtype) {
        if (subtype != 'N') {
          valNum = val.substring(4, 5).replace(/-/gi, "");
          var n_val = valNum.split(".");
          val = parseInt(n_val[0]) + '.' + n_val[1];
        } else {
          val.replace(/-/gi, "");
          val = parseInt(val);
        }
      }

      var val2 = "";
      if (val.toString().indexOf(".") >= 0) {
        var n_val = val.split(".");
        val2 = n_val[0].toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + '.' + n_val[1];
      } else {
        val2 = val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
      }

      return val2;

      //    return val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    },

    /**
     * desc : number to string
     * date : 2015.07.23
     * author : 이상우
     * ex : num2int(150) -> '150'
     *   num2int('150') -> 150
     * @param {String} val : 변경할 값
     * @return {Number}
     */
    num2Int: function(val) {
      if (isNaN(val)) {
        return val;
      }
      return val.toString().replace(/-/g, "");
    },

    /**
     * desc : 소수점 2째자리 이하 버림
     * date : 2015.07.23
     * author : 이상우
     * ex : num2Cut('123456.7812') -> '123456.78'
     * @param {String} val : 변경할 값
     * @return {String}
     */
    num2Cut: function(val) {
      if (isNaN(val)) {
        return val;
      }
      var rslt = val.split(".");
      var result = rslt[0] + "." + rslt[1].substring(0, 2);

      return result;
    },

    /**
     * desc : 천 단위 콤마 찍기(소수점 이하 제외)
     * date : 2015.07.23
     * author : 이상우
     * ex : numberWithCommas('123456789.123') -> '123,456,789.123'
     *   numberWithCommas(123456789) -> '123,456,789'
     *   numberWithCommas('123456789') -> '123,456,789'
     * @param x : 변경할 값
     * @return {String}
     */
    numberWithCommas: function(x) {
      var parts = x.toString().split(".");
      parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
      return parts.join(".");
    },

    /////////////////////////////[STRING FORMAT]/////////////////////////////
    /**
     * desc : 문자 길이 Return (한글 2Byte)
     * date : 2015.07.23
     * author : 이상우
     * ex : strLen('자동차') -> 6
     *    strLen('abc') -> 3
     * @param str : 인자값
     * @return
     */
    strLen: function(str) {
      var len = str.length;
      var han = 0;
      var res = 0;

      for (var i = 0; i < len; i++) {
        var ch = str.charCodeAt(i);
        if (ch > 128)
          han++;
      }
      res = (len - han) + (han * 2);

      return res;
    },

    /**
     * desc : 조회된 데이터 없을시 테이블에 문구 처리
     * date : 2015.07.23
     * author : 이상우
     * ex : nullDataHtml('id', '3') -> 테이블에 '조회된 내역이 없습니다.'이라고 글자를 띄움
     * @param id : 대상 id
     * @param colnum : column 번호
     * @return
     */
    nullDataHtml: function(id, colnum) {
      var html_text = '';
      html_text += '<tr>';
      html_text += '  <td class="btLine bdn" colspan = "' + colnum + '">조회된 내역이 없습니다.</td>';
      html_text += '</tr>';
      eval($('#' + id).html(html_text));
    },

    /**
     * desc : 조회된 데이터 없을시 테이블에 문구 처리(영문)
     * date : 2015.07.23
     * author : 이상우
     * ex : nullDataHtmlEng('id', '3') -> 테이블에 'No Data.'이라고 글자를 띄움
     * @param id : 대상 id
     * @param colnum : column 번호
     * @return
     */
    nullDataHtmlEng: function(id, colnum) {
      var html_text = '';
      html_text += '<tr>';
      html_text += '  <td class="btLine bdn" colspan = "' + colnum + '">No Data.</td>';
      html_text += '</tr>';
      eval($('#' + id).html(html_text));
    },

    /**
     * desc : 특수문자 html 엔티티 되돌리기
     * date : 2015.07.23
     * author : 이상우
     * ex : unhtmlSpecialChars('&lt;test&gt;') -> '<test>'
     * @param str : html
     * @return
     */
    unhtmlSpecialChars: function(str) {
      str = str.replace(/&#39;/g, '\'');
      str = str.replace(/&quot;/g, '\"');
      str = str.replace(/&lt;/g, '<');
      str = str.replace(/&gt;/g, '>');
      str = str.replace(/&uuml;/g, '?');
      str = str.replace(/&amp;/g, '&');
      return str;
    },

    /**
     * desc : 특수문자 엔티티 html 되돌리기
     * date : 2015.07.23
     * author : 이상우
     * ex : htmlSpecialChars('<test>') -> '&lt;test&gt;'
     * @param str : html
     * @return
     */
    htmlSpecialChars: function(str) {
      str = str.replaceAll('\'', '&#39;');
      str = str.replaceAll('\"', '\"&quot;');
      str = str.replaceAll('<', '&lt;');
      str = str.replaceAll('>', '&gt;');
      str = str.replaceAll('?', '&uuml;');
      str = str.replaceAll('&', '&amp;');
      return str;
    },

    /**
     * desc : textArea 사용시 <br /> 태그 처리
     * date : 2015.07.23
     * author : 이상우
     * ex : textAreaBrchars('첫 번째 줄<br>두 번째 줄<br>세 번째 줄') -> '첫 번째 줄\r\n두 번째 줄\r\n세 번째 줄'
     * @param str : html
     * @return
     */
    textAreaBrchars: function(str) {

      str = this.unhtmlSpecialChars(str);

      str = str.split('<br>').join('\r\n');
      str = str.split('<br >').join('\r\n');
      str = str.split('<br/>').join('\r\n');
      str = str.split('<br />').join('\r\n');
      str = str.split('<BR>').join('\r\n');

      return str;
    },

    /**
     * desc : textArea 사용 <br /> 태그 처리
     * date : 2015.07.23
     * author : 이상우
     * ex : unTextAreaBrchars('첫 번째 줄\r\n두 번째 줄\r\n세 번째 줄') -> '첫 번째 줄<br />두 번째 줄<br />세 번째 줄'
     * @param str : html
     * @return
     */
    unTextAreaBrchars: function(str) {
      str = str.split('\r\n').join('<br />');
	  str = str.split('\n').join('<br />');

      return str;
    },

    /**
     * desc : 지정된 길이만큼 문자개행
     * date : 2015.07.23
     * author : 이상우
     * ex : replaceStr('테스트입니다', 2) -> 테스<br/>트입<br/>니다
     * @param str : 인자값
     * @param maxLength : 최대 길이
     * @return
     */
    replaceStr: function(str, maxLength) {

      if (str == '') {
        return '';
      }

      var strResult = '';
      var strLength = str.length;

      var cnt = 1;
      for (var i = 0; i < strLength; i++) {

        i = maxLength * cnt;
        if (strLength > maxLength * cnt) {
          strResult += str.substring((maxLength * cnt) - maxLength, maxLength * cnt) + '<br/>';
        } else {
          strResult += str.substring((maxLength * cnt) - maxLength, strLength) + '<br/>';
        }

        cnt++;

      }

      return strResult.substring(0, (strResult.length) - 5);
    },

    /**
     * desc : type(date, tel)에 따라 str을 delimiter로 나눠준다.
     * date : 2015.07.23
     * author : 이상우
     * ex : delimiterString('date', '20150723', '-') -> 2015-07-23
     *    delimiterString('tel', '01044930666', '-') -> 010-4493-0666
     * @param type : date, tel
     * @param str : 변경할 값
     * @param delimiter : 구분자
     * @return
     */
    delimiterString: function(type, str, delimiter) {
      if (str == '') {
        return str;
      }
      delimiter = delimiter || '-';
      var idx = 0;
      var str_length = str.length;
      var result_arr = new Array();
      var result_value = "";
      switch (type) {
        case 'date':
          result_arr[idx++] = str.substring(0, 4);
          result_arr[idx++] = str.substring(4, (str_length - 2));
          result_arr[idx++] = str.substring(str_length - 2);
          break;

        case 'tel':
          if (str_length == 8) {
            return str.substring(0, 4) + delimiter + str.substring(4);
          } else if (str_length < 9) {
            return str;
          }

          var temp_tel_01 = str.substring(0, 2);
          var temp_tel_02 = str.substring(0, 3);
          var tel_01_length = 3;

          if (temp_tel_01 == '02') {
            tel_01_length = 2;
          } else if (temp_tel_02 == '050') {
            tel_01_length = 4;
          }

          result_arr[idx++] = str.substring(0, tel_01_length);
          result_arr[idx++] = str.substring(tel_01_length, (str_length - 4));
          result_arr[idx++] = str.substring(str_length - 4);

          break;
      }

      for (var i = 0; i < result_arr.length; i++) {

        result_value += result_arr[i];

        if (i != result_arr.length - 1) {
          result_value += delimiter;
        }
      }

      return result_value;
    },

    /**
     * desc : 문자열에서 주어진 separator 로 쪼개어 문자배열을 생성한다
     * date : 2015.07.23
     * author : 이상우
     * ex : split('abc.def.ghi', '.') -> values[0] = 'abc', values[1] = 'def', values[2] = 'ghi'
     * @param str : 변경할 값
     * @param separator : 구분자
     * @return
     */
    split: function(str, separator) {
      var values = str.split(separator);

      return values;
    },

    /**
     * desc : 숫자를 전화번호 형태로 전환
     * date : 2015.07.23
     * author : 이상우
     * ex : phoneNumFormat({객체안에 value 값이 '0123456789'}, '-') -> 012-345-6789
     *    phoneNumFormat({객체안에 value 값이 '0123456789'}, ':') -> 012:345:6789
     * @param obj : 변경할 값
     * @param format : 구분자
     */
    phoneNumFormat: function(obj, format) {
      var result = '';
      var num = obj.value.replaceAll('-', '');
      result = num;
      if (num.length >= 4) {
        if (num.substring(0, 2) == '02')
          result = num.substring(0, 2) + format + num.substring(2, num.length);
        else
          result = num.substring(0, 3) + format + num.substring(3, num.length);
      }

      if (num.length >= 7) {
        if (num.substring(0, 1) != '0')
          result = num.substring(0, 3) + format + num.substring(3, num.length);
      }

      if (num.length >= 8) {
        if (num.substring(0, 1) != '0')
          result = num.substring(0, 4) + format + num.substring(4, num.length);
      }

      if (num.length >= 9) {
        if (num.substring(0, 2) == '02')
          result = num.substring(0, 2) + format + num.substring(2, 5) + format + num.substring(5, num.length);
      }

      if (num.length >= 10) {
        if (num.substring(0, 2) == '02')
          result = num.substring(0, 2) + format + num.substring(2, 6) + format + num.substring(6, num.length);
        else
          result = num.substring(0, 3) + format + num.substring(3, 6) + format + num.substring(6, num.length);
      }

      if (num.length >= 11) {
        if (num.substring(0, 2) == '02')
          result = num.substring(0, 2) + format + num.substring(2, 6) + format + num.substring(6, num.length);
        else if (num.substring(0, 4) == "0505")
          result = num.substring(0, 4) + format + num.substring(4, 7) + format + num.substring(7, num.length);
        else
          result = num.substring(0, 3) + format + num.substring(3, 7) + format + num.substring(7, num.length);
      }

      if (num.length >= 12) {
        if (num.substring(0, 2) == '02')
          result = num.substring(0, 2) + format + num.substring(2, 6) + format + num.substring(6, num.length);
        else if (num.substring(0, 4) == '0505')
          result = num.substring(0, 4) + format + num.substring(4, 8) + format + num.substring(8, num.length);
        else
          result = num.substring(0, 3) + format + num.substring(3, 7) + format + num.substring(7, num.length);
      }

      obj.value = result;
    },

    /**
     * desc : String 체크 함수(문자이면 true 반환, 그 이외에 숫자 같은 건 false 반환)
     * date : 2015.07.23
     * author : 이상우
     * ex : isString('abc') -> true
     *    isString(123) -> false
     * @param value : 인자값
     * @return
     */
    isString: function(value) {
      return typeof value == 'string';
    },

    /**
     * desc : 내용이 비어있으면 false, 있으면 true 반환
     * date : 2015.07.23
     * author : 이상우
     * ex : isNotEmpty('abc') -> true
     *    isNotEmpty() -> false
     * @param value : 인자값
     * @return
     */
    isNotEmpty: function(value) {
      return !this.isEmpty(value);
    },

    /**
     * desc : 내용이 비어있으면 true, 있으면 false 반환
     * date : 2015.07.23
     * author : 이상우
     * ex : isEmpty('abc') -> false
     *    isEmpty('') -> true
     * @param value : 인자값
     * @return
     */
    isEmpty: function(value) {
      if (typeof value == 'undefined' || value == null || (typeof value == 'string' && value.trim() == '')) {
        return true;
      } else if (value instanceof Array && value.lenth == 0) {
        return true;
      } else if (value instanceof Object && $.isEmptyObject(value)) {
        return true;
      }

      return false;
    },

    /**
     * desc : -.1234567890 이외의 문자일 경우 입력불가
     * date : 2015.07.23
     * author : 이상우
     * ex : strip_comma('-1a2b3c4d5e6.789') -> '-123456.789'
     * @param data : 인자값
     * @return
     */
    stripComma: function(data) {
      var valid = '-+.1234567890';
      var output = '';

      for (var i = 0; i < data.length; i++) {
        if (valid.indexOf(data.charAt(i)) != -1) output += data.charAt(i);
      }

      return output;
    },

    /**
     * desc : 숫자만 입력가능
     * date : 2015.07.23
     * author : 이상우
     * ex : onlyNum({객체안에 value 값이 '123456789'}, 'futop', true) -> {객체안에 value 값이 '123.456.789'}
     * @param obj : 인자값
     * @param type : 양수, 음수 표시 ('futop' - 표시, undefined - 표시 안함)
     * @param isCash : 천 단위 콤마 표시 여부(true - 표시, false - 표시 안함)
     */
    onlyNum: function(obj, type, isCash) {
      var data = obj.value;
      var valid = "1234567890";
      var output = '';

      if (type != undefined && type == 'futop') {
        valid = "-.1234567890";
      }

      for (var i = 0; i < data.length; i++) {
        if (valid.indexOf(data.charAt(i)) != -1) {
          if (data.charAt(i) != '-') {
            output += data.charAt(i);
          }
          if (i == 0 && data.charAt(i) == '-') {
            output += data.charAt(i);
          }
        }
      }

      if (output != '-' && output != '') {
        if (isCash == undefined || isCash == true) {
          obj.value = this._toCash(output);
        } else {
          //'정정/취소'에서 숫자만 입력 가능하지만, 콤마를 표시하지 않아야 하는 경우 등에 사용됨.
          obj.value = output;
        }
      } else {
        obj.value = output;
      }

      //var key = event.keyCode;
      //if(!((key>=48 && key<=57) || key==8 || key==13 )){
      //    logger.log(key+" 요것은 숫자가 아닙니다.");
      //    event.returnValue=false;
      //}
    },

    /**
     * desc : 날짜만 입력가능
     * date : 2015.07.23
     * author : 이상우
     * ex : onlyDate({객체안에 value 값이 '20150723'}) -> '2015/07/23'
     * @param obj : 인자값
     */
    onlyDate: function(obj) {
      var data = obj.value;
      var valid = "1234567890";
      var output = '';

      for (var i = 0; i < data.length; i++) {
        if (valid.indexOf(data.charAt(i)) != -1) {
          output += data.charAt(i);
        }
        if (output.length == 4 || output.length == 7)
          output += '/';
      }

      obj.value = output;
    },

    /**
     * desc : 천 단위 콤마 찍기
     * date : 2015.07.23
     * author : 이상우
     * ex : _toCash(321312) -> 321,312
     * @param value : 인자값
     * @return
     */
    _toCash: function(value) {
      var is_minus = (String(value).indexOf('-') == 0) ? true : false;
      if (is_minus) {
        if (String(value).indexOf('.') != -1) {
          var val = String(value).split('.');
          val[0] = (val[0] * -1);
          value = String((Number(val[0]) || 0) + '.' + $.trim(val[1]));
        } else {
          value = (value * -1);
        }
      }
      var output;
      /**
       * 소수점처리 추가 (2014.04.08)
       */
      if (String(value).indexOf('.') != -1) {
        var values = String(value).split('.');
        output = String((Number(values[0]) || 0) + '.' + $.trim(values[1]));
      } else {
        output = String(Number(value));
      }
      if (is_minus) output = '-' + output;

      var reg = /(^[+-.]?\d+)(\d{3})/;
      output += '';

      while (reg.test(output)) {
        output = output.replace(reg, '$1' + ',' + '$2');
      };

      return output;
    },

    /**
     * desc : 초성가져오기 (한글 문자열을 받아 초성만 분리하여 반환한다.)
     * date : 2015.07.23
     * author : 이상우
     * ex : getChosung('자동차') -> ㅈㄷㅊ
     * @param objectString : 인자값
     * @return
     */
    getChosung: function(objectString) {
      var result_value = "";
      var temp_value = "";
      var temp_char;
      var etc_char = "$@%#ⓚⓞ()&.Ⅱ";
      var sb = '';

      for (var i = 0; i < objectString.length; i++) {
        temp_char = objectString.charCodeAt(i);

        // 한글
        if (temp_char >= 0xAC00 && temp_char <= 0xD7A3) {
          temp_value = this._isolateHangul(temp_char);
          sb += temp_value;
        } else {
          temp_char = objectString.charAt(i);
          if ("*" != temp_char) {
            if (etc_char.indexOf(temp_char) < 0) {
              sb += temp_value;
            }
          }
        }
      }
      result_value = sb;

      return result_value;
    },

    /**
     * desc : 한글에서 초성을 분리한다. getChosung()에서 사용되는 함수
     * date : 2015.07.23
     * author : 이상우
     * ex : _isolateHangul(51088) -> 'ㅈ'
     * @param objectChar : 인자값
     * @return
     */
    _isolateHangul: function(objectChar) {
      var result_value = null;

      var chosung = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"];

      var temp_code = 0; // 한글 - 0xAC00
      var cho_index = -1; // 초성의 Index
      var jung_index = -1; // 중성의 Index
      var jong_index = -1; // 종성의 Index

      // 한글인지 아닌지 판단한다.
      if (objectChar >= 0xAC00 && objectChar <= 0xD7A3) {
        temp_code = objectChar - 0xAC00;

        jong_index = temp_code % 28;
        jung_index = ((temp_code - jong_index) / 28) % 21;
        cho_index = parseInt(((temp_code - jung_index) / 28) / 21);
      }

      if (cho_index != -1) {
        result_value = chosung[cho_index];
      }

      return result_value;
    },

    /**
     * desc : 숫자 소수 몇 번째 자리까지 반올림하여 반환
     * date : 2015.07.23
     * author : 이상우
     * ex : getIndexString(1234.5554, 2, true) -> 1234.56
     *    getIndexString(1234.5554, 2, false) -> 1234.55
     * @param data : 인자값
     * @param dotIndex : 소수 몇 번째 자리까지
     * @param cutting : 반올림 (true - 반올림, false - 반올림 안함)
     * @return
     */
    getIndexString: function(data, dotIndex, cutting) {
      if (typeof cutting == 'undefined' || cutting == null) sign = false;
      //    undefined
      var result, dot, sign;
      var index = String(data).indexOf('.');
      var minus = String(data).search('-');
      if (index < 0) {
        result = data;
        dot = "";
      } else {
        if (minus > -1) result = String(data).slice(1, index);
        else result = String(data).slice(0, index);
        dot = String(data).slice(index + 1);

      }
      var total_length = Number(dot.length);
      while (total_length < dotIndex) {
        dot += '0';
        total_length++;
      }

      if (parseInt(result) == 0 && parseInt(dot) == 0) {
        result = '0';
      } else {
        sign = '';
        if (minus > -1) {
          sign = '-';
        }
        if (dot.length == 0 || dotIndex == 0) {
          result = sign + result + dot;
        } else {
          var dotResult = String(dot).slice(0, dotIndex);

          if (cutting && parseInt(String(dot).substr(dotIndex, 1)) >= 5) {
            var tempDot = parseInt(String(dot).substr(dotIndex - 1, 1)) + 1;
            dotResult = String(dotResult).slice(0, dotResult.length - 1);

            if (String(tempDot) == '10') dotResult = String(parseInt(dotResult) + 1) + '0';
            else dotResult = dotResult + String(tempDot);

            if (dotResult.length == 3) {
              if (Number(result) < 0) result = String(Number(result) - 1);
              else result = String(Number(result) + 1);

              dotResult = dotResult.slice(1);
            }
          }

          result = sign + result + '.' + dotResult;
        }
      }
      return result;
    }
  };

  window.nexUtils = new nexUtils();

})(window, jQuery);

/////////////////////////////[MONEY FORMAT]/////////////////////////////
/**
 * desc : 숫자에 ',' 콤마 찍기
 * date : 2015.07.23
 * author : 이상우
 * ex   : '123456789123456789'.commify() -> 123,456,789,123,456,789
 * @return
 */
String.prototype.commify = function() {
  var reg = /(^[+-]?\d+)(\d{3})/;
  var num = this.replace(/\,/g, '');
  num += '';
  while (reg.test(num))
    num = num.replace(reg, '$1' + ',' + '$2');

  return num;
};

/**
 * desc : 숫자에 ',' 콤마 제거
 * date : 2015.07.23
 * author : 이상우
 * ex   : '1234,567891234,56789'.rmcomma() -> '123456789123456789'
 * @return
 */
String.prototype.rmcomma = function() {
  var no = this;
  if (no == null || no == "") {
    return "0";
  }
  no = new String(no);
  return no.replace(/,/gi, "");
};

/////////////////////////////[STRING FORMAT]/////////////////////////////
/**
 * desc : endsWith (문자열 길이에서 지정된 숫자부터 문자 찾기 있으면 위치 반환)
 * date : 2015.07.23
 * author : 이상우
 * ex   : '12'.endsWith(5) -> '00012'
 * @param suffix :
 * @return
 */
if (typeof String.prototype.endsWith !== 'function') {
  String.prototype.endsWith = function(suffix) {
    return this.indexOf(suffix, this.length - suffix.length) !== -1;
  };
}

/**
 * desc : 길이만큼 앞에 특정 문자 채우기(문자열 길이를 지정한 길이 만큼 특정 값으로 앞에 채움)
 * date : 2015.07.23
 * author : 이상우
 * ex   : '12'.lPad(5, '0') -> '12000'
 * @param size : 총 길이
 * @param padc : 채울 값
 * @return
 */
String.prototype.lPad = function(size, padc) {
  return this._padb(size, padc, 1);
};

/**
 * desc : 길이만큼 뒤에 특정 문자 채우기(문자열 길이를 지정한 길이 만큼 특정 값으로 뒤에 채움)
 * date : 2015.07.23
 * author : 이상우
 * ex   : '12'.rPad(5, '0') -> '12000'
 * @param size : 총 길이
 * @param padc : 채울 값
 * @return
 */
String.prototype.rPad = function(size, padc) {
  return this._padb(size, padc, 0);
};

/**
 * desc : 길이만큼 앞에 0채우기(문자열 길이를 지정한 길이 만큼 0 값으로 앞에 채움)
 * date : 2015.07.23
 * author : 이상우
 * ex   : '12'.nPad(5) -> '00012'
 * @param size : 총 길이
 * @return
 */
String.prototype.nPad = function(size) {
  return this._padb(size, '0', 1);
};

/**
 * desc : 빈칸 채우기(문자열 길이를 지정한 길이 만큼 특정 값으로 채움)
 * date : 2015.07.23
 * author : 이상우
 * ex   : '12'._padb(5, '0', 1) -> 00012 (길이가 5가 될 때까지 앞에 0을 넣음)
 * @param size : 총 길이
 * @param padc : 채울 값
 * @param isLPAD : 채울 곳 (1 - 앞에 채움, 0 - 뒤에 채움)
 * @return
 */
String.prototype._padb = function(size, padc, isLPAD) {
  if (size <= 0) return "";
  if (!padc) padc = " ";
  var char_cnt = 0;
  var byte_cnt = 0;
  for (var n = 0, len = this.length; n < len; n++) {
    var charCode = this.charCodeAt(n);
    char_cnt++;
    byte_cnt += charCode > 0x00ff ? 2 : 1;
    if (byte_cnt == size)
      return this.substring(0, char_cnt);
    else if (byte_cnt > size)
      return this.substring(0, char_cnt - 1) + " ";
  }
  var padcs = "";
  for (var n = size - byte_cnt; n > 0; n--)
    padcs += padc;
  return isLPAD ? padcs + this : this + padcs;
};

/**
 * desc : 문자열에 양쪽 공백 제거
 * date : 2015.07.23
 * author : 이상우
 * ex   : '   abcdefg    '.trim() -> 'abcdefg'
 * @return
 */
String.prototype.trim = function() {
  return this.replace(/(^\s*)|(\s*$)/gi, "");
};

/**
 * desc : 문자열 왼쪽 공백 제거
 * date : 2015.07.23
 * author : 이상우
 * ex   : '   abcdefg    '.ltrim() -> 'abcdefg    '
 * @return
 */
String.prototype.ltrim = function() {
  return this.replace(/^\s+/, "");
};

/**
 * desc : 문자열 오른쪽 공백 제거 (object String 반환)
 * date : 2015.07.23
 * author : 이상우
 * ex   : '   abcdefg    '.rtrim() -> '   abcdefg'
 * @return
 */
String.prototype.rtrim = function() {
  return this.replace(/\s+$/, "");
};

/**
 * desc : 문자 replaceAll 처리 (버그 있음)
 * date : 2015.07.23
 * author : 이상우
 * ex   : 'abcdeafg'.replaceAll('a', 'X') -> 'XbcdeXfg'
 *      'abcdefg'.replaceAll('ab', 'xx') -> 'xxcdefg' (X)
 *      'abcdefg'.replaceAll('b', 'a') -> 'aabcdefga' (X)
 * @param str1 : 바꾸려는 글자
 * @param str2 : 바꿀 글자
 * @return
 */
String.prototype.replaceAll = function(str1, str2) {
  var tmp = eval("/\\" + str1 + "/g");
  return this.replace(tmp, str2);
};

/**
 * desc : 문자열 길이 원하는 만큼 자르고 끝에 tail 넣기
 * date : 2015.07.23
 * author : 이상우
 * ex   : 'abcdefg'.cut(3, '*') -> abc*
 * @param len : 표현할 문자열 길이
 * @param tail : '*'
 * @return
 */
String.prototype.cut = function(len, tail) {
  var str = this;
  if (typeof str != 'undefined' && str != null && str != '' && str != 'null') {
    var l = 0;

    str = str.split('<br />').join('');

    for (var i = 0; i < str.length; i++) {
      l += (str.charCodeAt(i) > 128) ? 2 : 1;
      if (l > len) return str.substring(0, i) + tail;
    }
  } else {
    str = '';
  }
  return str;
};
