



// endsWith
if (typeof String.prototype.endsWith !== 'function') {
    String.prototype.endsWith = function(suffix) {
        return this.indexOf(suffix, this.length - suffix.length) !== -1;
    };
}

//str을 왼쪽 오른쪽 바이트만큼 공백이나 0 체우기
// left padding. byte unit
String.prototype.lpadb = function(bsize, padc) {
	return this._padb(bsize, padc, 1);
};

// right padding. byte unit
String.prototype.rpadb = function(bsize, padc) {
	return this._padb(bsize, padc, 0);
};

// left padding. char unit.
String.prototype.lpad = function(size, padc) {
	return this._padb(size, padc, 1);
};

// right padding. char unit.
String.prototype.rpad = function(size, padc) {
	return this._padb(size, padc, 0);
};

// number padding.
String.prototype.npad = function(size) {
	return this._padb(size, "0", 1);
};
String.prototype._padb = function(bsize, padc, isLPAD) {
	if ( bsize <= 0 ) return "";
	if ( ! padc ) padc = " ";
	var charCnt = 0;
	var byteCnt = 0;
	for ( var n = 0, len = this.length; n < len; n++ ) {
		var charCode = this.charCodeAt(n);
		charCnt++;
		byteCnt += charCode > 0x00ff ? 2:1;
		if ( byteCnt == bsize )
			return this.substring(0, charCnt);
		else if ( byteCnt > bsize )
			return this.substring(0, charCnt-1)+" ";
	}
	var padcs = "";
	for ( var n = bsize - byteCnt; n > 0; n-- )
		padcs += padc;
	return isLPAD ? padcs + this : this + padcs;
};

//계좌번호 포멧(XXXXXXXX-XX, XXXXXXXXXX-XX)
String.prototype.actNoFormat = function() {
	
	var actNo = this.trim();
	var retActNo = actNo.substring(0, 8) + "-" + actNo.substring(8); 
	
	if(actNo.length > 10) {
		retActNo = actNo.substring(0, 10) + "-" + actNo.substring(10);
	} 
	
    return retActNo;
};

//펀드코드 포멧
String.prototype.fundFormat = function() {
	if (this == null) return "";
	if (this.length != 9) return this;

	return this.substring(0, 6)+"-"+this.substring(6, this.length);
};



//문자열에 왼쪽 오른쪽 공백 제거
String.prototype.trim = function() {
    return this.replace(/(^\s*)|(\s*$)/gi, "");
};

// 문자열 왼쪽 공백 제거
String.prototype.lTrim = function() {

	if(this == null) return "";

	for (var i = 0; i < this.length; i++) {
		if (this.charAt(i) != ' ')
			break;
	}
	return this.substring(i);
};

//문자열 오른쪽 공백 제거
String.prototype.rTrim = function() {
	if(this == null) return "";
	return rtrim(this);
};

/**
 * 문자열 왼쪽 공백 제거
 */
function ltrim(str) {
    var s = new String(str);
 
    if (s.substr(0,1) == " ") {
            return ltrim(s.substr(1));
    } else {
            return s;
    }
}
 
/**
 * 문자열 오른쪽 공백 제거
 */
function rtrim(str) {
    var s = new String(str);
    if(s.substr(s.length-1,1) == " ") {
            return rtrim(s.substring(0, s.length-1));
    } else {
            return s;
    }
}

/**
 * 문자열 HTML Tag Close 유무
 * @param close (true: Html Tag Close, false: Html Tag Open)
 * @param str 문자열
 */
function htmlTagClose(close, str) {
	var s = new String(str);
	
	for(var i = 0, len = s.length; i < len; i++) {
		
		// Html Tag Open
		if(close && s[i] == '<') {
			close = false;
		}
		
		if(!close && s[i] == '>') {
			close = true; 
		}
	}
	
	return close;
}


//문자 replaceAll 처리
String.prototype.replaceAll = function(str1,str2) {
	var tmp = eval("/\\"+str1+"/g");
	return this.replace(tmp,str2);
};

//문자열 길이 자르고 끝에 tail 넣기
//len = 문자열 길이, tail = '...'
String.prototype.cut = function(len, tail)
{
    var str = this;
    if(typeof str != "undefined" && str != null && str != ""&& str != "null"){
	    var l = 0;

	    str=str.split("<br />").join("");

	    for (var i=0; i<str.length; i++)
	    {
	        l += (str.charCodeAt(i) > 128) ? 2 : 1;
	        if (l > len) return str.substring(0,i) + tail;
	    }
    }else{
    	str = "";
    }
    return str;
};

//문자 길이 Return (한글 2Byte)
function strLen(str)
{
    var len = str.length;
    var han = 0;
    var res = 0;

    for(var i=0;i<len;i++)
    {
        var ch = str.charCodeAt(i);
        if(ch > 128)
            han++;
    }
    res = (len-han) + (han*2);

    return res;
}

//조회된 데이터 없을시 테이블에 문구 처리
function nullDataHtml(id, colnum){
	var html_text = "";
	html_text += '<tr>';
	html_text += '	<td class="btLine bdn" colspan = "'+colnum+'">조회된 내역이 없습니다.</td>';
	html_text += '</tr>';
	eval($("#"+id).html(html_text));
}


//조회된 데이터 없을시 테이블에 문구 처리(영문)
function nullDataHtml_eng(id, colnum){
	var html_text = "";
	html_text += '<tr>';
	html_text += '	<td class="btLine bdn" colspan = "'+colnum+'">No Data.</td>';
	html_text += '</tr>';
	eval($("#"+id).html(html_text));
}

//***********************************
//특수문자 html 엔티티 되돌리기
//***********************************
function unhtmlspecialchars(str)
{
	str = str.replace(/&#39;/g,"'");
	str = str.replace(/&quot;/g,"\"");
	str = str.replace(/&lt;/g,"<");
	str = str.replace(/&gt;/g,">");
	str = str.replace(/&uuml;/g,"?");
	str = str.replace(/&amp;/g,"&");
	return str;
}


//***********************************
//특수문자 엔티티 html 되돌리기
//***********************************
function htmlspecialchars(str)
{
	str = str.replaceAll("'","&#39;");
	str = str.replaceAll("\"","\"&quot;");
	str = str.replaceAll("<","&lt;");
	str = str.replaceAll(">","&gt;");
	str = str.replaceAll("?","&uuml;");
	str = str.replaceAll("&","&amp;");
	return str;
}

//***********************************
// textArea 사용시 <br /> 태그 처리
//***********************************
function textAreaBrchars(str) {

	str = unhtmlspecialchars(str);

	str = str.split("<br>").join("\r\n");
	str = str.split("<br >").join("\r\n");
	str = str.split("<br/>").join("\r\n");
	str = str.split("<br />").join("\r\n");
	str = str.split("<BR>").join("\r\n");

	return str;
}

//***********************************
// textArea 사용 <br /> 태그 처리
//***********************************
function unTextAreaBrchars(str) {
	str = str.split("\r\n").join("<br />");

	return str;
}

//********************************
//StringBuffer Object
//String 연결을 배열을 생성 하여 만드는 개체
//String을 그냥 +를 이용하여 연결하게 되면 비 효율적인 부분이 많아서
//배열로 생성 후 join으로 연결해 준다.
//********************************
var StrBuf = function()
{
	this.buffer = new Array();
};

StrBuf.prototype.add = function(str)
{
	if (str)
	{
		this.buffer[this.buffer.length] = str;
	}
};

StrBuf.prototype.get = function()
{
	return this.buffer.join ("");
};

StrBuf.prototype.get_arr = function()
{
	return this.buffer;
};

StrBuf.prototype.len = function()
{
	return this.buffer.length;
};

StrBuf.prototype.clear = function()
{
	delete this.buffer;
	this.buffer = new Array();
};

StrBuf.prototype.concat = function(objarr)
{
	var tmpbuf = this.buffer;
	delete this.buffer;
	this.buffer = new Array();
	this.buffer = tmpbuf.concat(objarr);
};

StrBuf.prototype.getval = function(key)
{
	for ( var i = 0; i < this.buffer.length; i++ )
	{
		if ( this.buffer[i].indexOf(key + "=") == 0 )
		{
			return decodeURIComponent(this.buffer[i].replace(key + "=", ""));
			break;
		}
	}

	return "";
};

StrBuf.prototype.replace = function(key, val)
{
	for ( var i = 0; i < this.buffer.length; i++ )
	{
		if ( this.buffer[i].indexOf(key + "=") == 0 )
		{
			this.buffer[i] = key + "=" + val;
			return;
		}
	}

	this.add(key + "=" + val);
};

/**
 * Array.indexOf, Array.splice 
 * ie 하위버전(ie8)에서는 않됨, ie9부터 가능
 * ie 하위버전(ie8)에서 동작하게끔 prototype 정의
 */
// check if it is IE and it's version is 8 or older
if (document.documentMode && document.documentMode < 9) {
	
	/**
	 * Array.splice
	 */
	// save original function of splice
	var originalSplice = Array.prototype.splice;
	
	// provide a new implementation
	Array.prototype.splice = function() {
		'use strict';
		
		// since we can't modify 'arguments' array, 
		// let's create a new one and copy all elements of 'arguments' into it
	    var arr = [];
	    for (var i = 0, max = arguments.length; i < max; i++){
	        arr.push(arguments[i]);
	    }
	    
	    // if this function had only one argument
	    // compute 'deleteCount' and push it into arr
	    if (arr.length == 1) {
	        arr.push(this.length - arr[0]);
	    }
	    
	    // invoke original splice() with our new arguments array
	    return originalSplice.apply(this, arr);
	};
	
	/**
	 * Array.indexOf
	 */
	if (!Array.prototype.indexOf) {
		Array.prototype.indexOf = function (searchElement /*, fromIndex */ ) {
			'use strict';
		    if (this == null) {
		    	throw new TypeError();
		    }
		    var n, k, t = Object(this),
		        len = t.length >>> 0;

		    if (len === 0) {
		    	return -1;
		    }
		    n = 0;
		    if (arguments.length > 1) {
		    	n = Number(arguments[1]);
		      	if (n != n) { // shortcut for verifying if it's NaN
		    	  	n = 0;
		      	} else if (n != 0 && n != Infinity && n != -Infinity) {
		    	  	n = (n > 0 || -1) * Math.floor(Math.abs(n));
	      		}
		    }
		    if (n >= len) {
		    	return -1;
		    }
		    for (k = n >= 0 ? n : Math.max(len - Math.abs(n), 0); k < len; k++) {
		    	if (k in t && t[k] === searchElement) {
		    		return k;
		    	}
		    }
		    return -1;
		};
	}
}

//***********************************
//문자개행
//ex)replaceStr("테스트입니다", 2) ==> 테스<br/>트입<br/>니다
//***********************************
function replaceStr(str, maxlength){

	if(str == ""){
		return "";
	}

	var strM = "";
	var strlen = str.length;

	var cnt = 1;
	for (var i =0 ; i<strlen; i++){

		i = maxlength * cnt;
		if(strlen > maxlength * cnt){
			strM += str.substring((maxlength * cnt) - maxlength, maxlength * cnt) + "<br/>";
		} else {
			strM += str.substring((maxlength * cnt) - maxlength, strlen) + "<br/>";
		}

		cnt++;

	}

	return strM.substring(0, (strM.length)-5);
}

//***********************************
//type(date, tel)에 따라 str을 delimiter로 나눠준다.
//ex)1981823 => 1981-8-23
//***********************************
function delimiterString(type, str, delimiter){
	if(str==""){
		return str;
	}
	delimiter=delimiter||"-";
	var idx=0;
	var strLength=str.length;
	var resultArr=new Array();
	var resultValue="";
	switch(type){
		case "date":
		resultArr[idx++]=str.substring(0,4);
		resultArr[idx++]=str.substring(4,(strLength-2));
		resultArr[idx++]=str.substring(strLength-2);
		break;

		case "tel":
		if(strLength==8){
			return str.substring(0,4)+delimiter+str.substring(4);
		}else if(strLength<9){
			return str;
		}

		var tempTel01=str.substring(0,2);
		var tempTel02=str.substring(0,3);
		var tel01Length=3;

		if(tempTel01=="02"){
			tel01Length=2;
		}else if(tempTel02=="050"){
			tel01Length=4;
		}

		resultArr[idx++]=str.substring(0,tel01Length);
		resultArr[idx++]=str.substring(tel01Length,(strLength-4));
		resultArr[idx++]=str.substring(strLength-4);

		break;
	}

	for(var i=0;i<resultArr.length;i++){

		resultValue+=resultArr[i];

		if(i!=resultArr.length-1){
			resultValue+=delimiter;
		}
	}

	return resultValue;
}

// 문자열에서 주어진 separator 로 쪼개어 문자배열을 생성한다 <br>


function split(str, separator)
{
	var values = str.split(separator);

    return values;
}


function PhoneNumFormat(obj, format) {
	var result = "";
	var num=obj.value.replaceAll('-','');
	result=num;
	if(num.length>=4)
	{
		if(num.substring(0, 2)=="02")
			result=num.substring(0, 2)+format+num.substring(2, num.length);
		else
			result=num.substring(0, 3)+format+num.substring(3, num.length);
	}

	if(num.length>=7)
	{
		if(num.substring(0, 1)!="0")
			result=num.substring(0, 3)+format+num.substring(3, num.length);
	}

	if(num.length>=8)
	{
		if(num.substring(0, 1)!="0")
			result=num.substring(0, 4)+format+num.substring(4, num.length);
	}

	if(num.length>=9)
	{
		if(num.substring(0, 2)=="02")
			result=num.substring(0, 2)+format+num.substring(2, 5)+format+num.substring(5, num.length);
	}

	if(num.length>=10)
	{
		if(num.substring(0, 2)=="02")
			result=num.substring(0, 2)+format+num.substring(2, 6)+format+num.substring(6, num.length);
		else
			result=num.substring(0, 3)+format+num.substring(3, 6)+format+num.substring(6, num.length);
	}

	if(num.length>=11)
	{
		if(num.substring(0, 2)=="02")
			result=num.substring(0, 2)+format+num.substring(2, 6)+format+num.substring(6, num.length);
		else if(num.substring(0, 4)=="0505")
			result=num.substring(0, 4)+format+num.substring(4, 7)+format+num.substring(7, num.length);
		else
			result=num.substring(0, 3)+format+num.substring(3, 7)+format+num.substring(7, num.length);
	}

	if(num.length>=12)
	{
		if(num.substring(0, 2)=="02")
			result=num.substring(0, 2)+format+num.substring(2, 6)+format+num.substring(6, num.length);
		else if(num.substring(0, 4)=="0505")
			result=num.substring(0, 4)+format+num.substring(4, 8)+format+num.substring(8, num.length);
		else
			result=num.substring(0, 3)+format+num.substring(3, 7)+format+num.substring(7, num.length);
	}

	obj.value=result;
}




//String 체크 함수
function isString(value) {
	return typeof value == 'string';
}


//empty 체크함수
function isNotEmpty(value) {
	return !isEmpty(value);
}

//empty 체크 함수
function isEmpty(value) {
 
 if(typeof value == 'undefined' || value == null || ( typeof value == 'string' && value.trim() == '') ){
     return true;
 }else if(value instanceof Array && value.lenth == 0){
     return true;
 }else if(value instanceof Object && $.isEmptyObject(value)){
     return true;
 }
 
 return false;
}

//lpad
function lpad(str, padString, length) {
	while (str.length < length)
     str = padString + str;
 return str;
}

//rpad
function rpad(str, padString, length) {
	while (str.length < length)
		str = str + padString ;
 return str;
}


//-.1234567890 이외의 문자일 경우 입력불가
function strip_comma(data) {
  var valid = "-+.1234567890";
  var output = '';

  for (var i=0; i<data.length; i++){
      if (valid.indexOf(data.charAt(i)) != -1) output += data.charAt(i);
  }
  return output;
}


//숫자만 입력가능
function onlyNum(obj, type, isCash) {
	var data = obj.value;
	var valid = "1234567890";
	var output = '';

	if(type != undefined && type == "futop"){
		valid = "-.1234567890";
	}

	for (var i=0; i<data.length; i++){
	    if (valid.indexOf(data.charAt(i)) != -1){
	    	if(data.charAt(i) != '-'){
	    		output += data.charAt(i);
	    	}
	    	if(i==0 && data.charAt(i) == '-'){
	    		output += data.charAt(i);
	    	}
	    }
	}

	if(output != '-' && output != ''){
		if(isCash == undefined || isCash == true){
			obj.value = to_cash(output);
		} else {
			//'정정/취소'에서 숫자만 입력 가능하지만, 콤마를 표시하지 않아야 하는 경우 등에 사용됨.
			obj.value = output;
		}
	}else{
		obj.value = output;
	}

    //var key = event.keyCode;
    //if(!((key>=48 && key<=57) || key==8 || key==13 )){
    //    logger.log(key+" 요것은 숫자가 아닙니다.");
    //    event.returnValue=false;
    //}
}

//날짜만 입력가능
function onlyDate(obj) {
	var data = obj.value;
	var valid = "1234567890";
	var output = '';

	for (var i=0; i<data.length; i++){
	    if (valid.indexOf(data.charAt(i)) != -1){
	    	output += data.charAt(i);
	    }
	    if(output.length==4 || output.length==7 )
	    	output += '/';
	}

	obj.value = output;
}

function to_cash(value){
	var isminus=(String(value).indexOf('-')==0)?true:false;
	if(isminus){
		if(String(value).indexOf('.')!=-1){
			var val=String(value).split('.');
			val[0] = (val[0] * -1);
			value=String((Number(val[0]) || 0)+'.'+$.trim(val[1]));
		}else{
			value = (value * -1);
		}
	}
	var output;
	/**
	 * 소수점처리 추가 (2014.04.08)
	 */
	if(String(value).indexOf('.')!=-1){
		var values=String(value).split('.');
		output=String((Number(values[0]) || 0)+'.'+$.trim(values[1]));
	}else{
		output=String(Number(value));
	};
	if(isminus) output='-'+output;

	var reg=/(^[+-.]?\d+)(\d{3})/;
	output+='';

	while(reg.test(output)){
		output=output.replace(reg, '$1'+','+'$2');
	};

	return output;
}

//초성가져오기 (한글 문자열을 받아 초성만 분리하여 반환한다.)
function getChosung(objectString) {
    var resultValue = "";
    var tempValue = "";
    var tempChar;
    var etcChar = "$@%#ⓚⓞ()&.Ⅱ";
    var sb = '';
    
    for (var i = 0; i < objectString.length; i++) {
        tempChar = objectString.charCodeAt(i);
        
        // 한글
        if (tempChar >= 0xAC00 && tempChar <= 0xD7A3) {
            tempValue = isolateHangul(tempChar);
            sb += tempValue;
        } else {
        	tempChar = objectString.charAt(i);
            if ("*" != tempChar) {
                if (etcChar.indexOf(tempChar) < 0) {
                    sb += tempValue;
                }
            }
        }
    }
    resultValue = sb;
    
    return resultValue;
}

//한글에서 초성을 분리한다.
function isolateHangul(objectChar) {
    var resultValue = null;

    var chosung = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ","ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"];

    var tempCode = 0;       // 한글 - 0xAC00
    var choIndex = -1;      // 초성의 Index
    var jungIndex = -1;     // 중성의 Index
    var jongIndex = -1;     // 종성의 Index

    // 한글인지 아닌지 판단한다.
    if (objectChar >= 0xAC00 && objectChar <= 0xD7A3) {
        tempCode = objectChar - 0xAC00;

        jongIndex = tempCode % 28;
        jungIndex = ((tempCode - jongIndex) / 28) % 21;
        choIndex = parseInt(((tempCode - jungIndex ) / 28 ) / 21);
    }

    if (choIndex != -1) {
        resultValue = chosung[choIndex];
    }

    return resultValue;
}

//data  : 값
//dotIndex : 자릿수
//cutting : 반올림
//ex getIndexString(1234.5554 , 2 , true); 1234.56
//ex getIndexString(1234.5554 , 2 , false);1234.55
function getIndexString(data , dotIndex , cutting)
{
    
    if(typeof cutting == 'undefined' || cutting == null) sign = false;
//    undefined 
    var result , dot , sign;
    var index = String(data).indexOf(".");
    var minus = String(data).search("-");
    if(index < 0)
    {
      result = data;
      dot    = "";
    }
    else
    {
      if (minus > -1)result = String(data).slice(1 , index);
      else result = String(data).slice(0 , index);
      dot    = String(data).slice(index+1);
      
    }
    var totLength  = Number(dot.length);
    while(totLength < dotIndex)
    {
      dot += "0";
      totLength++;
    }  
    
    if (parseInt(result) == 0 && parseInt(dot) == 0)
    {
        result  = "0";
    }
    else
    {
        sign = "";  
        if (minus > -1)
        {
            sign = "-";
        } 
        if (dot.length == 0 || dotIndex == 0)
        {
            result  =  sign + result + dot;
        }
        else
        {
            var dotResult  = String(dot).slice(0 , dotIndex);
            
            
            if(cutting && parseInt(String(dot).substr(dotIndex , 1)) >= 5)
            {
                var tempDot  = parseInt(String(dot).substr(dotIndex -1 , 1)) + 1; 
                dotResult = String(dotResult).slice(0 , dotResult.length -1);
                if(String(tempDot) == "10")dotResult  = String(parseInt(dotResult)+1) + "0";
                else dotResult  = dotResult + String(tempDot);
                if(dotResult.length == 3)
                {
                    if(Number(result) < 0)  result = String(Number(result) - 1);
                    else result = String(Number(result) + 1);
                    dotResult = dotResult.slice(1);
                }                
            }
            
            
            result  =  sign + result + "." + dotResult;
        }
    }
    return result;
}
