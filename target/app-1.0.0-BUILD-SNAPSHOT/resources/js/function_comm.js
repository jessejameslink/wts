
	/*
	 * Remove unicode
	 *
	 */
	function xoa_dau(str) {
		str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, "a");
		str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, "e");
		str = str.replace(/ì|í|ị|ỉ|ĩ/g, "i");
		str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, "o");
		str = str.replace(/ù|ú|ụ|ủ|ũ|ư/g, "u");
		str = str.replace(/ư|ừ|ứ|ự|ử|ữ/g, "w");
		str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, "y");
		str = str.replace(/đ/g, "d");
		str = str.replace(/À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ/g, "A");
		str = str.replace(/È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ/g, "E");
		str = str.replace(/Ì|Í|Ị|Ỉ|Ĩ/g, "I");
		str = str.replace(/Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ/g, "O");
		str = str.replace(/Ù|Ú|Ụ|Ủ|Ũ/g, "U");
		str = str.replace(/Ư|Ừ|Ứ|Ự|Ử|Ữ/g, "W");
		str = str.replace(/Ỳ|Ý|Ỵ|Ỷ|Ỹ/g, "Y");
		str = str.replace(/Đ/g, "D");
		return str;
	}

/*
 * Time Convert Function
 * 000000 => 00:00:00
 */

function v_time(tme) {
	//console.log("~~~~~~~~~~~~~~~~~");
	//console.log(tme);
	if(tme != undefined) {
		if(tme.indexOf(":") > -1) {
			return tme;
		} else {
			return tme.substring(0,2)+":"+tme.substring(2,4)+":"+tme.substring(4,6);
		}
	}
}

function isEmpty(v) {
	v = String(v);
	if(v == null || v == undefined || v == "null" || v == "undefined" || v == "") {
		return true;
	} else {
		return false;
	}
}

function numIntFormat(v){
    if (isNaN(v) || isEmpty(v)) {
        v = '0';
    }
    
    v = String(v);
    var r = /(\d+)(\d{3})/;
    while (r.test(v)) {
        v = v.replace(r, '$1' + ',' + '$2');
    }
    
    if (v.charAt(0) == '-') {
        return '-' + v.substr(1);
    }
    return v;
}

function numZeroReplaceFormat(v){
    if (isNaN(v) || isEmpty(v) || v == 0) {
        v = '';
    }
    
    v = String(v);
    var r = /(\d+)(\d{3})/;
    while (r.test(v)) {
        v = v.replace(r, '$1' + ',' + '$2');
    }
    
    if (v.charAt(0) == '-') {
        return '-' + v.substr(1);
    }
    return v;
}

/*
 * number X 1000 dot view
 */
function numFormat(v, s){
    if (!s) {
        s = '';
    }
    
    if (isNaN(v)) {
        v = '0';
    }
    
    v = (Math.round((v - 0) * 1000)) / 1000;
    v = (v == Math.floor(v)) ? v + ".000" : ((v * 10 == Math.floor(v * 10)) ? v + "0" : v);
    v = String(v);
    var ps = v.split('.');
    var whole = ps[0];
    var sub = ps[1] ? '.' + ps[1] : '.000';
    var r = /(\d+)(\d{3})/;
    while (r.test(whole)) {
        whole = whole.replace(r, '$1' + ',' + '$2');
    }
    v = whole + sub;
    if (v.charAt(0) == '-') {
        return '-' + v.substr(1) + s;
    }
    return v + s;
};

function numDotCommaFormat(v){
	if(v == null) {
		v = 0;
	}
	var T = Number('1e'+3);
	return numIntFormat(Math.round((v)*T));
}

function numDotComma(v){
	if(v == null) {
		v = "0";
	}
	return parseInt(v.replace(/[,.]/g, ""));
}
/*
function upDownNumList(v, f) {
	if(v.indexOf("+") > -1) {
		if(f == undefined) {
			v = v.split("+").join("");
		}
	} else if(v.indexOf("-") > -1) {
		if(f == undefined) {
			v = v.split("-").join("");
		}
	}
	return numZeroReplaceFormat(v);
}
*/
function upDownNumZeroList(v, f) {
	if(v.indexOf("+") > -1) {
		if(f == undefined) {
			v = v.split("+").join("");
		}
	} else if(v.indexOf("-") > -1) {
		if(f == undefined) {
			v = v.split("-").join("");
		}
	}
	return numFormat(v);
}

/*
 * Up Down Color Convert Value( X 1000 dot show Function)
 * v : value
 * o : target Field
 * f : +, - show or hide
 */

function upDownNumDot(v, o, f) {
	o.removeClass("up").removeClass("low");
	if(v.indexOf("+") > -1) {
		o.addClass("up");
		if(f == undefined) {
			v = v.split("+").join("");
		}
	} else if(v.indexOf("-") > -1) {
		o.addClass("low");
		if(f == undefined) {
			v = v.split("-").join("");
		}
	}
	
	return numFormat(v);
}

/*
 * Up Down Color Convert Value
 * v : value
 * o : target Field
 * f : +, - show or hide
 */

function upDownNum(v, o, f) {
	o.removeClass("up").removeClass("low");
	if(v.indexOf("+") > -1) {
		o.addClass("up");
		if(f == undefined) {
			v = v.split("+").join("");
		}
	} else if(v.indexOf("-") > -1) {
		o.addClass("low");
		if(f == undefined) {
			v = v.split("-").join("");
		}
	}
	/*
	if(v == '0') {
		return '';
	}
	*/
	return numIntFormat(v);
}

/*
 * Up Down Color Convert Value
 * v : value
 * o : target Field
 * f : +, - show or hide
 */

function zeroUpDownNum(v, o, f) {
	o.removeClass("up").removeClass("low");
	if(v.indexOf("+") > -1) {
		o.addClass("up");
		if(f == undefined) {
			v = v.split("+").join("");
		}
	} else if(v.indexOf("-") > -1) {
		o.addClass("low");
		if(f == undefined) {
			v = v.split("-").join("");
		}
	}
	if(v == '0') {
		return '';
	}
	return numIntFormat(v);
}


function diffNum(v, o) {
	if(o != undefined) {
		o.removeClass("up").removeClass("upper").removeClass("low").removeClass("lower").removeClass("same");
		var diff	=	"";
		if (isNaN(v) && v != 'ATC' && v != 'ATO') {
	        //v = '0';
			v	=	''
	        return v;
	    }
		
		if(Number(v) == 0) {
			//return v;
			return '';
		} else if(v == 'ATC' || v == 'ATO' ) {
			return v;
		} else {
			diff = v.substring(0,1);
			//	'1': 상한, '2': 상승, '3': 보합, '4': 하한, '5': 하락
			switch(diff) {
				case '1' : o.addClass("upper"); break;
				case '2' : o.addClass("up"); break;
				case '3' : o.addClass("same"); break;
				case '4' : o.addClass("lower"); break;
				case '5' : o.addClass("low"); break;
			}
		}
	}
	v	 = v.substring(1, v.length);
//	return v;
	return numIntFormat(v);
}

function diffNumFOS(v, o) {
	if(o != undefined) {
		o.removeClass("up").removeClass("upper").removeClass("low").removeClass("lowerf").removeClass("samef");
		var diff	=	"";
		if (isNaN(v) && v != 'ATC' && v != 'ATO') {
	        //v = '0';
			v	=	''
	        return v;
	    }
		
		if(Number(v) == 0) {
			//return v;
			return '';
		} else if(v == 'ATC' || v == 'ATO' ) {
			return v;
		} else {
			diff = v.substring(0,1);
			//	'1': 상한, '2': 상승, '3': 보합, '4': 하한, '5': 하락
			switch(diff) {
				case '1' : o.addClass("upper"); break;
				case '2' : o.addClass("up"); break;
				case '3' : o.addClass("samef"); break;
				case '4' : o.addClass("lowerf"); break;
				case '5' : o.addClass("low"); break;
			}
		}
	}
	v	 = v.substring(1, v.length);
	if (v == '0') {
		v = '';
		return v;
	}
//	return v;
	return numIntFormat(v);
}

function diffNumWatch(v, o) {
	if (v == 'ATC' || v == 'ATO') {
		return v;
	}
	if(v == '0' || v == 0) {
		return "";
	}
	
	var value = v.substring(1, v.length);	
	if (Number(value) == 0) {
		return '';
	}
	
	if(o != undefined) {
		o.removeClass("up1").removeClass("upper").removeClass("low1").removeClass("lower").removeClass("same1");
		var diff	=	"";
		if (isNaN(v)) {
	        //v = '0';
			v	=	''
	        return v;
	    }
		if(Number(v) == 0) {
			//return v;
			return '';
		} else {
			diff = v.substring(0,1);
			//	'1': 상한, '2': 상승, '3': 보합, '4': 하한, '5': 하락
			switch(diff) {
				case '1' : o.addClass("upper"); break;
				case '2' : o.addClass("up1"); break;
				case '3' : o.addClass("same1"); break;
				case '4' : o.addClass("lower"); break;
				case '5' : o.addClass("low1"); break;
			}
		}
	}
	v	 = v.substring(1, v.length);
//	return v;
	return numIntFormat(v);
}



/*
 * Up Down Color Convert Value
 * v : value
 * f : +, - show or hide
 */
function upDownNumList(v, f) {
	if(v == null) {
		v = 0;
		return numIntFormat(v);
	}
	if(v.indexOf("+") > -1) {
		if(f == undefined) {
			v = v.split("+").join("");
		}
	} else if(v.indexOf("-") > -1) {
		if(f == undefined) {
			v = v.split("-").join("");
		}
	}
	
	//return numZeroReplaceFormat(v);
	return numIntFormat(v);
}

/*
 * Up Down Color Convert Value
 * v : value
 * f : +, - show or hide
 */
function zeroUpDownNumList(v, f) {
	if(v == null) {
		v = 0;
		//return numIntFormat(v);
	}
	if(v == 0 || v == '0') {
		return '';
	}
	
	if(v.indexOf("+") > -1) {
		if(f == undefined) {
			v = v.split("+").join("");
		}
	} else if(v.indexOf("-") > -1) {
		if(f == undefined) {
			v = v.split("-").join("");
		}
	}
	
	//return numZeroReplaceFormat(v);
	return numIntFormat(v);
}

/*
 * Up Down Color Convert Value
 * v : value
 */
function upDownColor(v) {
	var rtnCss = "";
	if(v.indexOf("+") > -1) {
		rtnCss = "up";
	} else if(v.indexOf("-") > -1) {
		rtnCss = "low";
	} else {
		rtnCss = "same";
	}
	return rtnCss;
}

/*
 * Up Down Color Convert Value
 * v : value
 */
function upDownColorIndex(v) {
	var rtnCss = "";
	if(v.indexOf("+") > -1) {
		rtnCss = "upIndex";
	} else if(v.indexOf("-") > -1) {
		rtnCss = "lowIndex";
	} else {
		rtnCss = "sameIndex";
	}
	return rtnCss;
}

/*
 * a : value (1: 상한  2: 상승   3: 보합 4: 하한  5: 하락)
 */
function displayColor(a) {
	switch (a) {
		case "1":
			return "upper";
		case "2":
			return "up";
		case "3":
			return "same";
		case "4":
			return "lower"
		case "5":
			return "low"
		default :
			return ""
	}
}

/*
 * a : value (1: 상한  2: 상승   3: 보합 4: 하한  5: 하락)
 */
function displayColorFOS(a) {
	switch (a) {
		case "1":
			return "upper";
		case "2":
			return "up";
		case "3":
			return "samef";
		case "4":
			return "lowerf"
		case "5":
			return "low"
		default :
			return ""
	}
}

/*
 * a : value (1: 상한  2: 상승   3: 보합 4: 하한  5: 하락)
 */
function displayColorWatch(a) {
	switch (a) {
		case "1":
			return "upper";
		case "2":
			return "up1";
		case "3":
			return "same1";
		case "4":
			return "lower"
		case "5":
			return "low1"
		default :
			return ""
	}
}

/*
 * a : value (1: 상한  2: 상승   3: 보합 4: 하한  5: 하락)
 */
function displayArrow(a) {
	switch (a) {
	case "1":
		return "arrow upper ";
	case "2":
		return "arrow up ";
	case "3":
		//return "arrow same ";
		return "same ";
	case "4":
		return "arrow lower "
	case "5":
		return "arrow low "
	default :
		return ""
	}
}

/*
 * a : value (1: 상한  2: 상승   3: 보합 4: 하한  5: 하락)
 */
function displayArrowFOS(a) {
	switch (a) {
	case "1":
		return "arrow upper ";
	case "2":
		return "arrow up ";
	case "3":
		//return "arrow same ";
		return "samef ";
	case "4":
		return "arrow lowerf "
	case "5":
		return "arrow low "
	default :
		return ""
	}
}

/*
 * a : value (1: 상한  2: 상승   3: 보합 4: 하한  5: 하락)
 */
function displayArrowWatch(a) {
	switch (a) {
	case "1":
		return "arrow upper ";
	case "2":
		return "arrow up1 ";
	case "3":
		return "arrow same1 ";
	case "4":
		return "arrow lower "
	case "5":
		return "arrow low1 "
	default :
		return ""
	}
}

function displayMarketID(a) {
	if (a && a.length) {
		switch (a) {
			case "HOSE":
				return "HO";
			case "HNX":
				return "HA";
			case "UPCOM":
				return "OTC";
			case "VN":
				return "VN"
			case "HSX":
				return "HSX"
			case "CW":
				return "HO"
		}
	}
}

function displayMarketCode(a) {
	if (a && a.length) {
		switch (a) {
		case "HO":
			return "HOSE";
		case "CW":
			return "HOSE";
		case "HA":
			return "HNX";
		case "OTC":
			return "UPCOM";
		case "VN":
			return "VN"
		case "HSX":
			return "HSX"
		}
	}
}

function lpadStr(pstr, padLength, padString){
	var s = pstr;
	while(s.length < padLength)
		s = padString + s;
	return s;
}

function rpadStr(pstr, padLength, padString){
	var s = pstr;
	while(s.length < padLength)
		s += padString;
	return s;
}

function trim(str){
	str = str.replace(/(^\s*)|(\s*$)/gi, "");
	return str;
};

function ltrim(str){
	str = str.replace(/^\s+/, "");
	return str;
};

function rtrim(str){
	str = str.replace(/\s+$/, "");
	return str;
};


function PageUtil() // 페이지 처리 함수
{
	var totalCnt; // 총 건수
	var pageRows; // 한 페이지에 출력될 항목 갯수
	var curPage; // 현재 페이지
	var disPagepCnt;// 화면출력 페이지수
	var totalPage;
	
	this.setTotalPage = function() {
		this.totalPage = parseInt((this.totalCnt/this.pageRows)) + (this.totalCnt%this.pageRows>0 ? 1:0);
	}

	this.getPrev = function() {
		var prev    = 0;
		if(this.curPage > 1)
			prev    = this.curPage - 1;
		else
			prev    = 1;
		return prev;
	}

	this.getNext = function()
	{
		var next    = 0;
		if(this.curPage < this.totalPage)
			next = this.curPage + 1;
		else
			next = this.totalPage;
		return next;
	}

	this.getPrevPage = function()
	{
		var prevPage    = 0;
		var curPos      = (parseInt((this.curPage/this.disPagepCnt))+(this.curPage%this.disPagepCnt>0 ? 1:0));
		if(curPos>1)
		{
			prevPage    = parseInt((curPos-1))*this.disPagepCnt;
		}
		return prevPage;
	}

	this.getNextPage = function()
	{
		var nextPage    = 0;
		var curPos  = parseInt((parseInt((this.curPage/this.disPagepCnt))+(this.curPage%this.disPagepCnt >0 ? 1:0)));
		if((curPos*this.disPagepCnt+1) <= this.totalPage)
		{
			nextPage    = curPos*this.disPagepCnt+1;
		}
		if( this.totalPage >= nextPage )
			return nextPage;
		else
			return this.totalPage;
	}

	this.Drow = function()
	{
		var sb = '';
		var start   = ((parseInt((this.curPage/this.disPagepCnt))+(this.curPage%this.disPagepCnt>0 ? 1:0)) * this.disPagepCnt - (this.disPagepCnt-1));
		var end     = ((parseInt((this.curPage/this.disPagepCnt))+(this.curPage%this.disPagepCnt>0 ? 1:0)) * this.disPagepCnt);
		if(end > this.totalPage)
			end = this.totalPage;
		
		if(this.curPage > this.disPagepCnt)
		{
			//sb += "&nbsp;&nbsp;<a href='javascript:prev_page();'>◀◀</a>&nbsp;&nbsp;";
		}

		if(this.getPrev() < this.curPage)
		{
			//sb += "&nbsp;&nbsp;<a href='javascript:prev();'>◀</a>&nbsp;&nbsp;";
			sb	+=	"<a href='javascript:prev();' class='prev'>prev</a>";
		}

		for(var i=start; i<=end; i++)
		{
			if(i==this.curPage)
			{
				//sb += "&nbsp;&nbsp;<b>"+i+"</b>&nbsp;&nbsp;";
				sb	+=	"<a href='' class='current'>"+i+"</a>";
			}
			else
			{
				//sb += "&nbsp;&nbsp;<a href='javascript:goPage("+i+");'>"+i+"</a>&nbsp;&nbsp;";
				sb	+=	"<a href='javascript:goPage("+i+");'>"+i+"</a>";
			}
		}
		
		if(this.curPage < this.getNext())
		{
			//sb += "&nbsp;&nbsp;<a href='javascript:next();'>▶</a>&nbsp;&nbsp;";
			sb	+=	"<a href='javascript:next();' class='next'>next</a>";
		}

		if(this.totalPage > this.getNextPage() && this.getNextPage() != 0 )
		{
			//sb += "&nbsp;&nbsp;<a href='javascript:next_page();'>▶▶</a>&nbsp;&nbsp;";
		}
		return sb;
	}
}

/*
 * Scroll move Data Add
 * 
 */
function scrollDataMore(func, obj) {
	obj.scroll(function() {
		var scrollPosition	=	obj.height();
		var scrollHeight	=	obj.prop("scrollHeight");
		var scrollTop		=	obj.scrollTop();
		
		var movScroll	=	(scrollPosition + scrollTop);
		if(scrollHeight == movScroll) {
			eval(func);
		}
	});
}

function getTime(str) {
	return str.substring(0, 2) + ":" + str.substring(2, 4) + ":" + str.substring(4, 6);
}
