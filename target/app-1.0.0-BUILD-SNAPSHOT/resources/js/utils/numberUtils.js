/**
 * 주식 주문가격 Step
 * 단가자동입력 팝업 - 기준가별로 step지정
 * 유가증권(코스피, market: J) 및 프리보드, 상장수익증권, 신주인수권증권, 신주인수권증서, ELW(market: L)
 * 1,000 미만: 1원
 * 5,000 미만: 5원
 * 5,000 ~ 10,000: 10원
 * 10,000 ~ 50,000: 50원
 * 50,000 ~ 100,000: 100원
 * 100,000 ~ 500,000: 500원
 * 500,000 ~ : 1,000원
 * 
 * 코스닥(market: Q)
 * 1,000 미만: 1원
 * 5,000 미만: 5원 
 * 5,000 ~ 10,000: 10원
 * 10,000 ~ 50,000: 50원
 * 50,000 ~ 100,000: 100원
 * 100,000 ~ 500,000: 100원
 * 500,000 ~ : 1,000원
 * 
 * 선물옵션
 * 
 * 코스피 선물, 선물스프레드: 0.05
 * 
 * 코스피 옵션
 * 3.0미만: 0.01
 * 3.0이상: 0.05
 * 
 * 스타 선물: 0.5
 * 
 * 주식선물
 * 10,000 미만: 10원
 * 10,000 ~ 50,000: 50원
 * 50,000 ~ 100,000: 100원
 * 100,000 ~ 500,000: 500원
 * 500,000 ~ : 1000원
 * 
 * 주식옵션
 * 1,000 미만: 10원
 * 1,000 ~ 2,000: 20원
 * 2,000 ~ 5,000: 50원
 * 5,000 ~ 10,000: 100원
 * 10,000 ~ : 200원
 * 
 * @param price
 * @returns
 */
function priceStep(price, market, code, codeName, subCode){
	
	// 마켓
	if(typeof market == 'undefined' || market == null || market == '') {
		if(typeof code != 'undefined' && code != null && code != '') {
			market = getMarketKubun(code);
		}
	}
	
	if(typeof codeName == 'undefined' || codeName == null) {
		codeName = '';
	}
	
	if(typeof subCode == 'undefined' || subCode == null) {
		subCode = '';
	}
	
	// ETF market 처리
	if(market == "J" && masterCode.stockInfo[code+"etf"] != undefined) {
		market = 'etf';
	}
	if(market == "M"){
		market = 'etn';
	}
	
	/**
     * market F: 선물, S: 스타, G: 주식선물, O: 콜옵션, Z: 주식옵션
     */
	
	// 코스피 선물
	if(market == 'F' || market == 'v') {
		step = 0.05;
		
	// 코스피 옵션
	} else if(market == 'O') {
		
		price = Math.abs(parseFloat(price));
		if(price < 3) {
			step = 0.01;
		} else {
			step = 0.05;
		}
		
	// 스타지수
	} else if(market == 'S' || market == 't') {
		step = 0.5;
	
	// 주식선물
	} else if(market == 'G') {
		
		// 주식 선물 스프레드: 선물 결제월 기준 낮은가격 호가 단위 적용
		if(codeName.indexOf('스프') != -1 || codeName.indexOf('SP') != -1) {
			
			var paramsVo = [];
			var paramsVoCnt = 0;
			
			for ( var idx=0, len = masterCode.sfuture.length; idx < len; idx++ ) {
	            if (subCode == masterCode.sfuture[idx]['subcode']) {
	            	var futCode = masterCode.sfuture[idx]['code']; 
	                
	                // 선물
		        	if (futCode.length == 5) {
		        		
		        		var fid1000ReqVo = new FidReqVo();
		                fid1000ReqVo.setGid('1000');
		                fid1000ReqVo.setIdx('fid1000_' + paramsVoCnt);
		                fid1000ReqVo.setIsList('0');
		                fid1000ReqVo.setFidCodeBean('3', futCode);
		                fid1000ReqVo.setFidCodeBean('9104', getMarketKubun(futCode));
		                fid1000ReqVo.setOutFid('1,3,4,5,28,29,60,2986,2987,2988'); //출력FID
		                
		                paramsVo[paramsVoCnt++] = fid1000ReqVo;
		        	}
	            }
	        }
			
			// ajax 동기화로 처리
            $.ajaxSend({url:"/wts/fidBuilder.do", param: paramsVo, gbn:'vo', async: false, callback: 
            	function(resultData) {
            			
            		var min = 999999999999;
            		
        			for(var i=0; i < paramsVoCnt; i++) {
        				if(typeof resultData['fid1000_' + i] != 'undefined' && resultData['fid1000_' + i] != null) {
        					
        					// 최소 호가 찾기
        					if(min > Number(resultData['fid1000_' + i].data[0]['4'])) {
        						min = Number(resultData['fid1000_' + i].data[0]['4']);
        					}
        				}
        			}
            		
            		// 최대 6개 중 가장 낮은 가격 호가 찾고 주식 선물 옵션 타면 됨
            		price = Math.abs(parseInt(min));
        			
        			if(price < 10000) {
        				step = 10;
        			} else if(price < 50000) {
        				step = 50;
        			} else if(price < 100000) {
        				step = 100;
        			} else if(price < 500000) {
        				step = 500;
        			} else {
        				step = 1000;
        			}
            	}
            });
			
		} else {
			price = Math.abs(parseInt(price));
			
			if(price < 10000) {
				step = 10;
			} else if(price < 50000) {
				step = 50;
			} else if(price < 100000) {
				step = 100;
			} else if(price < 500000) {
				step = 500;
			} else {
				step = 1000;
			}
		}
	// 주식 옵션
	} else if(market == 'Z') {
		price = Math.abs(parseInt(price));
		
		if(price < 1000) {
			step = 10;
		} else if(price < 2000) {
			step = 20;
		} else if(price < 5000) {
			step = 50;
		} else if(price < 10000) {
			step = 100;
		} else {
			step = 200;
		}
	
	// ETF
	} else if(market == 'etf' || market == 'elw'|| market == 'etn') {
		step = 5;
	// 주식
	} else {
		
		price = Math.abs(parseInt(price));
		
	    if(price < 1000) {
	    	step = 1;
	    } else if(price < 5000) {
	        step = 5;
	    } else if(price < 10000) {
	        step = 10;
	    } else if(price < 50000) {
	        step = 50;
	    } else if(price < 100000) {
	        step = 100;
	    } else if(price < 500000) {
	    	step = 500;
	        if(market == 'Q') {
	        	step = 100;	
	        }
	    } else {
	        step = 1000;
	    }
	}
	
    return step;
}

function inputComma(val) {
    var commaValue = comma(val.replace(/,/g, ""));
    if ( ! commaValue ) commaValue = "";
    return commaValue;
}

/**
 * 선물옵션 주문가격 Step 2014-08-28 변만복, 사용않함. 확인 후 삭제 할것.
 * @author 김경은
 **/
function futopPriceStep(price, marketGubun, refnm){
    price = Math.abs(price/100);
    if(marketGubun == "F"){                    // 코스피지수>선물/선물스프레드('F')
//        step = 0.05;
        step = 5;
    } else if(marketGubun == "O"){                // 코스피지수> CALL/PUT('O')
        if(price < 3){
//            step = 0.01;
            step = 1;
        } else{
//            step = 0.05;
            step = 5;
        }
    } else if(marketGubun == "S"){             // 스타지수('S')
//        step = 0.5;
        step = 50;
    } else if(marketGubun == "Z"){                // 주식선물풋/콜옵션('Z')
        if(price < 1000){
//            step = 10.0;
            step = 1000;
        } else if(price < 2000){
//            step = 20.0;
            step = 2000;
        } else if(price < 5000){
//            step = 50.0;
            step = 5000;
        } else if(price < 10000){
//            step = 100.0;
            step = 10000;
        } else if(price < 100000){
//            step = 200.0;
            step = 20000;
        } else if(price < 200000){
//            step = 20.0;
            step = 2000;
        } else if(price < 500000){
//            step = 50.0;
            step = 5000;
        } else if(price < 1000000){
//            step = 100.0;
            step = 10000;
        } else if(price > 1000000){
//            step = 200.0;
            step = 20000;
        }
    } else if(marketGubun == "G"){                // 주식선물옵션>선물/선물스프레드('G')
        if(refnm.indexOf("스프") == -1 && refnm.indexOf("SP") == -1){
            if(price < 50000){
    //            step = 25.0;
                step = 2500;
            } else if(price < 100000){
    //            step = 50.0;
                step = 5000;
            } else if(price < 500000){
    //            step = 250.0;
                step = 25000;
            } else if(price < 1000000){
    //            step = 500.0;
                step = 50000;
            } else if(price > 1000000){
    //            step = 500.0;
                step = 50000;
            }
        }else{
            if(price <= 5000){
                step = 2500;
            } else if(price <= 50000){
                step = 5000;
            }else {
                step = 50000;
            }
        }

    } else{
        if(price < 300){
            step = 0.01;
            step = 1;
        } else if(price < 50000){
//            step = 0.05;
            step = 5;
        } else if(price < 100000){
//            step = 10.0;
            step = 1000;
        } else if(price < 200000){
//            step = 20.0;
            step = 2000;
        } else if(price < 500000){
//            step = 50.0;
            step = 5000;
        } else if(price < 1000000){
//            step = 100.0;
            step = 10000;
        } else if(price > 1000000){
//            step = 200.0;
            step = 20000;
        }
    }

    /*
    if(marketGubun == 'S'){             // 스타지수('S')
        step = 50;
    } else if(marketGubun == 'F' ){        // 코스피지수>선물스프레드('F')
        step = 5;
    }  else if(marketGubun == 'Z' ){    // 주식선물옵션('Z')
        if(price <= 1000){
            //step = 10;
            step = 1000;
        } else if(price <= 2000){
    //        step = 20;
            step = 2000;
        } else if(price <= 5000){
    //        step = 50;
            step = 5000;
        } else if(price <= 10000){
    //        step = 100;
            step = 10000;
        } else if(price > 10000){
    //        step = 200;
            step = 20000;
        }
    } else if(marketGubun == 'G' ){    // 주식선물옵션('G')
        step = 5000;
    } else if(marketGubun == 'O' ){    //코스피지수 CALL/PUT('O')
        if(price < 3){
    //        step = 0.01;
            step = 1;
        } else{
    //        step = 0.05;
            step = 5;
        }
    }else{
        if(price < 3){
    //        step = 0.01;
            step = 1;
        } else if(price <= 500){
    //        step = 0.05;
            step = 5;
        } else if(price <= 1000){
            //step = 10;
            step = 1000;
        } else if(price <= 2000){
    //        step = 20;
            step = 2000;
        } else if(price <= 5000){
    //        step = 50;
            step = 5000;
        } else if(price <= 10000){
    //        step = 100;
            step = 10000;
        } else if(price > 10000){
    //        step = 200;
            step = 20000;
        }
    }
    */
    return step;
}

function nvl(val, defaultStr) {
	
	if(typeof defaultStr == 'undefined' || defaultStr == null || defaultStr == '') {
		defaultStr = 0;
	}
	
	if(typeof val == 'undefined' || val == null || val == '') {
		return defaultStr;
	}
	
	return val;
}


function formatNumber(val,sosu)
{
	if(String(val)=='' || String(val)==null)
		val='0';

	var rtn_val='';

	if(sosu==0)
	{
		rtn_val=String(round(Number(val),sosu)).commify();
	}
	else if(sosu>0)
	{
		rtn_val=String(formatDouble(Number(val),sosu)).commify();
	}

	return rtn_val;
}

/**

 * 함수 설명 : 한글금액과 숫자금액 자동생성
 * 작성자 : 천창환
 * @param object = input 오브젝트ID값
 * @param han_id = 한글숫자 보여질 영역 ID 값
 * @param text = 금액뒤에 덧붙일 글자, 기본값 : 원 (예 : 원, won, 달러, $)
 */
function MoneyFormat(objectId, han_id, text) {

	var object = document.getElementById(objectId);
	object.style.textAlign="right";
	//object.style.paddingRight="5px";

	if(typeof text =='undefind' || text==null)
		text='';

    if(object.setSelectionRange) {
    	object.focus();
    	object.setSelectionRange(object.value.length, object.value.length);
    } else if(object.createTextRange) {
        var range = object.createTextRange();
        range.collapse(true);
        range.moveEnd('character', object.value.length);
        range.moveStart('character', object.value.length);
        range.select();
    }
    var val=object.value;

    if(val!='')
    {
    	if(val.substring(0, 1)=="0")
    		object.value="";
    	else
    	{
    		//if( document.MKD25!=null && typeof(document.MKD25)!="undefined" )
    		//	document.getElementById('MKD25').SkipVerify(1);

    		object.value=String(parseInt(val.replace(/\,/g,''))).commify();

    		//if( document.MKD25!=null && typeof(document.MKD25)!="undefined" )
    		//	document.getElementById('MKD25').SkipVerify(0);
    	}
    }

    var number_length=object.value.replace(/\,/g,'').length;

    if(typeof han_id =='undefind' || han_id==null || han_id=='')
    	return;

    var obj = document.getElementById(han_id);

    if(number_length < 16)
    {
	    var han_money=NumberToHan(object.value);

	    if(han_money!='')
	    	obj.innerHTML=han_money.replace(/(^\s*)|(\s*$)/gi, "")+' '+text;
	    else
	    	obj.innerHTML='';
    }
    else
    {
    	object.value='';
    	obj.innerHTML='';
    }

}

/**
 * 함수 설명 : 정수에 소수점 넣기
 * 작성일자 : 2010.12.02
 * ex1) makePoint(1234567, 3, 2) 1234567 -> 1234.56
 * ex2) makePoint(0, 0, 2) 0 -> 0.00
 * @param n(숫자)
 * @param index(소수점 위치 (뒤로기준))
 * @param cipher(출력할 소수점이하 자릿수)
 * @return
 */
function makePoint(n, index, chiper) {
	var isMinus = false;
	var totZero = "";
	var beforeZero = "";
	var transIndex = "";	// 변환시킨 index값

	if(n.indexOf("-") != -1) {
		n = n.replaceAll("-", "");
		isMinus = true;
	}

	transIndex = n.length - index;	// 소수점 위치잡기 index값 설정

	// index 값이 0으로 들어올때,
	if(index == 0) {
		for(var i=0; i < chiper; i++) {
			totZero += "0";
		}
		if(isMinus) {
			return "-" + n + "." + totZero;
		} else {
			return n + "." + totZero;
		}
	}

	// 0값일때,
	if(n == "0") {
		if(chiper > 0) {
			for(var i=0; i < chiper; i++) {
				totZero += "0";
			}
			return "0." + totZero;
		} else {
			return "0";
		}
	}

	// 자릿수에 맞게 0을 앞에 채움
	if(n.length < index) {
		for(var i=0; i < index - n.length; i++) {
			beforeZero += "0";
		}
	}

	if(index < chiper) {
		for(var i=0; i < (chiper-index); i++) {
			totZero += "0";
		}
	} else {
		totZero = "";
	}

	// 음수값일때 ,
	if(isMinus) {
		result = "-" + n.substring(0, transIndex) + "." + beforeZero + n.substring(transIndex, n.length) + totZero;
	} else {
		result = n.substring(0, transIndex) + "." + beforeZero + n.substring(transIndex, n.length) + totZero;
	}

	// 제일 앞에 소수점이 올 때(ex: -.1234) 0을 붙이기위함(Minus일때)
	if(isMinus) {
		if(result.indexOf(".") == 1) {
			result = "-0" + result.substring(1, result.indexOf(".") + (chiper + 1));
		}
	}

	// 제일 앞에 소수점이 올 때(ex: .1234) 0을 붙이기위함
	if(result.indexOf(".") == 0) {
		result = "0" + result.substring(0, result.indexOf(".") + (chiper + 1));
	} else {
		result = result.substring(0, result.indexOf(".") + (chiper + 1));	// 소수점이 껴있어서 (+1) 해준다.
	}

	return result;
}

/**
 * 함수 설명 : 숫자에 ',' 콤마 찍기
 * 작성자 : 천창환
 * 작성일자 : 2010.11.30
 * @return String (예: 10,000 )
 */
String.prototype.commify = function()
{
	var reg=/(^[+-]?\d+)(\d{3})/;
	var num=this.replace(/\,/g,'');
	num+='';
	while(reg.test(num))
		num=num.replace(reg,'$1'+','+'$2');

	return num;
};

/**
 * 함수 설명 : 숫자에 ',' 제거
 * @return
 */
String.prototype.rmcomma = function() {
	var no = this;
	if(no == null || no == "") {
		return "0";
	}
	no = new String(no);
	return no.replace(/,/gi,"");
};

/**
 * 함수 설명 : 오브젝트 숫자 값에 숫자 더하기
 * 작성자 : 천창환
 * @param objectId = input 오브젝트ID값
 * @param number = 더하기 할 숫자
 * @param commify = true, false ( 숫자 콤마 찍기 )
 * @param allNumberName = 가져올 변수값 이름
 */
function NumberPlus(objectId, number, commify, allNumberName)
{
	var object = document.getElementById(objectId);
	if(typeof number=='undefind' || number==null)
	{
		object.value='';
		return;
	}

	if( document.MKD25!=null && typeof(document.MKD25)!="undefined" )
		document.getElementById('MKD25').SkipVerify(1);

	if(object.value.trim()=='')
		object.value='0';
	var number_value=parseInt(object.value.replace(/\,/g,''));
	var val;

	if(typeof number !='number')
	{
		if(number=='all')
		{
			val = eval(allNumberName);
			if(commify)	object.value=String(val).commify();
			else object.value=val;
			return;
		}
		else
			val = parseInt(number.replace(/\,/g,''));
	}
	else
		val = number;

	if(commify)
		object.value=String(number_value+val).commify();
	else
		object.value=number_value+val;

	if( document.MKD25!=null && typeof(document.MKD25)!="undefined" )
		document.getElementById('MKD25').SkipVerify(0);
}

/**
 * 함수 설명 : 숫자를 한글로 표기 변환 함수
 * 작성자 : 천창환
 * @param val = 숫자로된 금액 (예 : 1000000 또는 100,000,000)
 * @return 한글로 변환데이터 (예: 천백만 이천삼 )
 */
function NumberToHan(val)
{
	var numStr=val.replace(/\,/g,'');

	if(numStr.length > 15)
		return '';

	var arrNum=new Array(10);
	arrNum[0]='';
	arrNum[1]='일';
	arrNum[2]='이';
	arrNum[3]='삼';
	arrNum[4]='사';
	arrNum[5]='오';
	arrNum[6]='육';
	arrNum[7]='칠';
	arrNum[8]='팔';
	arrNum[9]='구';

	var arrUnit=new Array(15);
	arrUnit[0]='';
	arrUnit[1]='십';
	arrUnit[2]='백';
	arrUnit[3]='천';
	arrUnit[4]='만 ';
	arrUnit[5]='십만 ';
	arrUnit[6]='백만 ';
	arrUnit[7]='천만 ';
	arrUnit[8]='억 ';
	arrUnit[9]='십억 ';
	arrUnit[10]='백억 ';
	arrUnit[11]='천억 ';
	arrUnit[12]='조 ';
	arrUnit[13]='십조 ';
	arrUnit[14]='백조 ';

	var hanStr='';
	var arrStr=new Array();
	var code = numStr.length;

	for(var i=0; i < code; i++)
		arrStr[i]=numStr.substring(i,i+1);

	var tempUnit;
	var a1 = 0, a2 = 0, a3 = 0, b1 = 0, b2 = 0, b3 = 0;

	for(var i=0; i <  numStr.length; i++)
	{
		code--;
		tempUnit='';

		if(arrNum[parseInt(arrStr[i])]!='')
		{
			tempUnit = arrUnit[code];
			if(code > 4)
			{
				a1 = code / 4;
				a2 = (code - 1) / 4;
				a3 = (code - 2) / 4;
				b1 = Math.floor(a1);
				b2 = Math.floor(a2);
				b3 = Math.floor(a3);
				if((b1 == b2 && arrNum[parseInt(arrStr[i+1])] !='') || (b1 == b3 && arrNum[parseInt(arrStr[i+2])] !=''))
					tempUnit=arrUnit[code].substring(0,1);
			}
		}
		hanStr = hanStr + (arrNum[parseInt(arrStr[i])] + tempUnit);
	}

	return hanStr;
}

function remake_Number(no,away,small_cipher){
	var minus=no.charAt(0)=='-';
	var num=minus?no.substring(1):no;
	if(num==null||num=="0"){
		num=0;
	}else{
		small_cipher=small_cipher==null?0:parseInt(small_cipher);
		away=away==null?0:parseInt(away);
		var sp=num.substring(0,num.length-away);
		if(small_cipher > sp.length){
			sp=lfill(sp,small_cipher+1,'0');
		}else if(small_cipher == sp.length){
			sp="0"+sp;
		}
		num=sp.substring(0,sp.length-small_cipher)+"."+sp.substring(sp.length-small_cipher,sp.length);
	}
	num=minus?"-"+num:num;
	return number_format(num,small_cipher);
}

function number_format(no,small_cipher){
	no = no.trim();
	if(no==null){
		no=0;
	}
	small_cipher=small_cipher==null?0:parseInt(small_cipher);
	var sp=new String(no).split(".");
	var number="";
	var small_number="";
	var formatted="";
	number=sp.length>0?sp[0]:"0";
	small_number=sp.length==2?sp[1]:"";
	var signed=number.charAt(0)=='-' || number.charAt(0)=='+';
	var sign =signed?number.substring(0,1):"";
	number=signed?number.substring(1):number;
//	var minus=number.charAt(0)=='-';
//	number=minus?number.substr(1):number;
	var cnt=0;
	for(var i=number.length-1;i>=0;i--){
		var c=number.charAt(i);
		if(cnt!=0&&cnt%3==0){
			formatted=','+formatted;
		}
		formatted=c+formatted;
		cnt++;
	}
	if(small_cipher>0){
		small_number=small_number.substring(0,small_cipher);
			if(small_number!=null){
			for(var i=small_number.length;i<small_cipher;i++){
				small_number=small_number+'0';
			}
			formatted=formatted+"."+small_number;
		}
	}else if(small_cipher < 0){
		if(small_number!=null && small_number!=""){
			formatted=formatted+"."+small_number;
		}
	}
	formatted=sign+formatted;
	return formatted;
}


/**
 * 소수점 데이터를 % 형태로 반환
 * ex) 0.123 -> 12.3
 * @param data
 * @param pow
 * @return
 */
function pecent(data, pow) {

	return Math.floor(parseFloat(data * Math.pow(10, (pow+2)))) / Math.pow(10, pow);
}


/**
 * 소수점 데이터를 % 형태로 반환
 * ex) 0.123 -> 12.3
 * @param data
 * @param pow
 * @param gbn ( 반올림 : round, 버림 : floor, 올림 : ceil ) default - round
 * @return
 */
function cPecent(data, pow, gbn) {

	var val = 0;

	if(data==null || data == ''){
		val = 0;
	}

	// 올림
	if(gbn == 'ceil') {
		val = Math.ceil(parseFloat(data * Math.pow(10, (pow+2)))) / Math.pow(10, pow);

	// 버림
	} else if(gbn == 'floor') {

		val = Math.floor(parseFloat(data * Math.pow(10, (pow+2)))) / Math.pow(10, pow);

	// 반올림
	} else {

		val = Math.round(parseFloat(data * Math.pow(10, (pow+2)))) / Math.pow(10, pow);
	}

	return val;

}

/**
 * <PRE>
 * Desc : value 값을 divide로 나눠서 sosu자리에서 반올림후 format형식으로 리턴한다.
 *	예시: 금액을 억단위로 표시 일 경우 사용
 * 		getMoneyFloatFormat("1,000,000,000", "100000000", 3, "#,###.###")
 * 		getMoneyFloatFormat("1000000000", "100000000", 3, "#,###.###")
 * @Method : getMoneyFloatFormat
 * @param value
 * @param divide
 * @param sosu
 * @param format
 * @return
 * @auther : 천창환
 * </PRE>
 */
function getMoneyFloatFormat(value, divide, sosu, format) {

	var dbl = 0.0;
	var dbl2 = 0.0;
	var temp = 0.0;

	// 문자열 처리
	value = value + '';

	try {

		dbl = parseFloat(value.rmcomma());
		dbl2 = parseFloat(divide);

		if(dbl != 0 && dbl2 != 0) {
			temp = round((dbl / dbl2), sosu);
		} else {
			temp = dbl;
		}

		value = getDecimalFormat(temp, format);

	} catch (e) {

	}
	return value;
}

/**
 * <PRE>
 * Desc : value 값을 divide로 나눠서 sosu자리에서 반올림후 format형식으로 리턴한다.
 *	예시: 금액을 억단위로 표시 일 경우 사용
 * 		getMoneyFloatFormatZeroEmpty("1,000,000,000", "100000000", 3, "#,###.###")
 * 		getMoneyFloatFormatZeroEmpty("1000000000", "100000000", 3, "#,###.###")
 *     0일경우 빈값 리턴
 * @Method : getMoneyFloatFormatZeroEmpty
 * @param value
 * @param divide
 * @param sosu
 * @param format
 * @return
 * @auther : 천창환
 * </PRE>
 */
function getMoneyFloatFormatZeroEmpty(value, divide, sosu, format) {

	var dbl = 0.0;
	var dbl2 = 0.0;
	var temp = 0.0;

	// 문자열 처리
	value = value + '';

	try {

		dbl = parseFloat(value.rmcomma());
		dbl2 = parseFloat(divide);

		if(dbl != 0 && dbl2 != 0) {
			temp = round((dbl / dbl2), sosu);
		} else {
			temp = dbl;
		}

		value = getDecimalFormat(temp, format);

		if(value == 0)
			value = "";


	} catch (e) {

	}
	return value;
}


function getDecimalFormat(val, format) {
	var df = new DecimalFormat(format);

	if(typeof val == 'undefined' || val == null) //  || val == ''
		return "";

	return df.format(val);
}


/** <PRE>
 * 소수점 num 자리이하 올림
 *
 * 메소드 : ceil
 * 작성자 : 천창환
 *
 * @param retVal
 * @param num
 * @return
 * </PRE> */
function ceil(retVal, num) {
	try{
		var i = 1.0;

		for(var a=0; a< num; a++)	i = i*10.0;

		retVal = parseFloat(Math.ceil(retVal * i) / i);
	} catch(e) {

    }

	return retVal;
}

/** <PRE>
 * 소수점 반올림함수
 *
 * 메소드 : round
 * 작성자 : 천창환
 *
 * @param retVal	반올림할 숫자
 * @param num		반올림된 수(default : 소수 2째자리)
 * @return
 * @throws Exception
 * </PRE> */
function round(retVal, num) {
	try{
		var i = 1.0;
		var pos = 2;
		
		if(typeof num != 'undefined' && num != null && num != '') {
			pos = num;
		}
		
		for(var a=0; a < pos; a++)	i = i*10.0;

		retVal = parseFloat((Math.round(retVal * i) / i));
	} catch(e) {

    }
	return retVal;
}


/** <PRE>
 * 소수점 num자리이하 버림
 *
 * 메소드 : floor
 * 작성자 : 천창환
 *
 * @param retVal
 * @param num
 * @return
 * </PRE> */
function floor(retVal, num) {
	try{
		var i = 1.0;

		for(var a=0; a< num; a++)	i = i*10.0;

		retVal = parseFloat(Math.floor(retVal * i) / i);
	} catch(e) {

    }

	return retVal;
}


/** <PRE>
 * double 실수 일경우 소숫점 까지해서 반환
 * getParseDouble("-000003230",2) => "-32.30"
 *
 * 메소드 : getParseDouble
 * 작성자 : 천창환
 *
 * @param sVal
 * @param sosu
 * @return
 * </PRE> */
function getParseDouble(sVal, sosu) {
	var dVal = 0.0;

	try {

		if(typeof sVal != "undefined" && sVal != null && sVal.trim().length > 0) {

			sVal = sVal.lTrim();
			// 부호값을 1바이트 잘라낸다.
			var sign = sVal.substring(0, 1);

			// 부호값이 아닌값이면
			if(sign != "+" && sign != "-") {
				sign = "";
			}


			dVal = parseFloat(sVal);
			var div = 1.0;

			for(var i=0; i<sosu; i++) {
				div *= 10;
			}
			dVal = dVal / div;

			// -0이 나오지 않기 위해 사용
			if(dVal == 0) {
				dVal = 0;
			}
			sVal = formatDouble(dVal, sosu);

			// -인 값은 sVal에 -가 이미 붙어있음
			if(sign != "-") {
				sVal = sign + sVal;
			}

		}
	} catch(e) {

	}

	return sVal;
}

/** <PRE>
 * double value 값을 입력하여 sosu 자리수만큼 소수점을 찍는다.
 * 반드시 double 밸류값에 소수점이 찍혀있어야함
 * 예) formatDouble("122.22", "2");   => 122.22 (o)
 *     formatDouble("12222", "2");    => 12222  (x)
 *
 * 메소드 : formatDouble
 * 작성자 : 천창환
 *		getDecimalFormat(temp, format);
 * @param amount
 * @param sosu
 * @return
 * </PRE> */
function formatDouble(amount, sosu) {
	var pattern = "";
	var sosuPattern = "";
	try {
		for(var i=0; i<sosu;i++) {
			sosuPattern += "0";
		}
		if(sosuPattern != "") {
			pattern = "0." + sosuPattern;
		} else {
			pattern = "0";
		}

		amount=round(amount,2);
		amount = number_format(String(amount), sosu);

	} catch(e) {

	}

	return amount;
}

/**
 * <PRE>
 * Desc : 양수(빨강), 음수(파랑) 표현
 * @Method : getUpDown
 * @param val
 * @param signGbn : true - 부호표시, false - 부호 생략
 * @param sign : 백분율 표시(%)등
 * @param moneyFormat : 금액형태로 표시
 * @return
 * @auther : 변만복
 * </PRE>
 */
function getUpDown(val, signGbn, sign, moneyFormat) {

	var returnVal = '';

	if(val != null && val != '') {

		// 금액 형식일 경우
		if(val.indexOf(",") != -1) {
			val = val.rmcomma();
		}

		returnVal = val + sign;

		// 금액 형식으로 표현
		if(moneyFormat == 'true') {
			returnVal = val.commify() + sign;
		}

		var num1 = Number(val);

		if(num1 > 0) {

			if(signGbn == "true") {
				returnVal = "<font class=\"up\">" + num1 + sign + "</font>";

				if(moneyFormat == 'true') {
					returnVal = "<font class=\"up\">" + num1.commify() + sign + "</font>";
				}
			} else {
				returnVal = "<font class=\"up\">" + Math.abs(num1) + sign + "</font>";

				if(moneyFormat == 'true') {
					returnVal = "<font class=\"up\">" + Math.abs(num1).toString().commify() + sign + "</font>";
				}
			}

		} else if(num1 < 0) {

			if(signGbn == "true") {
				returnVal = "<font class=\"down\">" + num1 + sign + "</font>";

				if(moneyFormat == 'true') {
					returnVal = "<font class=\"down\">" + num1.commify() + sign + "</font>";
				}
			} else {
				returnVal = "<font class=\"down\">" + Math.abs(num1) + sign + "</font>";

				if(moneyFormat == 'true') {
					returnVal = "<font class=\"down\">" + Math.abs(num1).toString().commify() + sign + "</font>";
				}
			}
		}
	}
	return returnVal;
}

/**
 * <PRE>
 * Desc : 양수(빨강), 음수(파랑) 표현
 * @Method : getUpDown
 * @param val
 * @param signGbn : true - 부호표시, false - 부호 생략
 * @param sign : 백분율 표시(%)등
 * @param moneyFormat : 금액형태로 표시
 * @return
 * @auther : 변만복
 * </PRE>
 */
function getUpDown2(val, signGbn, sign, moneyFormat) {

	var returnVal = '';

	if(val != null && val != '') {

		// 금액 형식일 경우
		if(val.indexOf(",") != -1) {
			val = val.rmcomma();
		}

		returnVal = val + sign;

		// 금액 형식으로 표현
		if(moneyFormat == 'true') {
			returnVal = val.commify() + sign;
		}

		var num1 = Number(val);

		if(num1 > 0) {

			if(signGbn == "true") {
				returnVal = "<span class=\"revise_up fl tx_skip\">up</span><strong class=\"fr\">" + num1 + sign + "</strong>";

				if(moneyFormat == 'true') {
					returnVal = "<span class=\"revise_up fl tx_skip\">up</span><strong class=\"fr\">" + num1.commify() + sign + "</strong>";
				}
			} else {
				returnVal = "<span class=\"revise_up fl tx_skip\">up</span><strong class=\"fr\">" + Math.abs(num1) + sign + "</strong>";

				if(moneyFormat == 'true') {
					returnVal = "<span class=\"revise_up fl tx_skip\">up</span><strong class=\"fr\">" + Math.abs(num1).toString().commify() + sign + "</strong>";
				}
			}

		} else if(num1 < 0) {

			if(signGbn == "true") {
				returnVal = "<span class=\"revise_dw fl tx_skip\">down</span><strong class=\"fr\">" + num1 + sign + "</strong>";

				if(moneyFormat == 'true') {
					returnVal = "<span class=\"revise_dw fl tx_skip\">down</span><strong class=\"fr\">" + num1.commify() + sign + "</strong>";
				}
			} else {
				returnVal = "<span class=\"revise_dw fl tx_skip\">down</span><strong class=\"fr\">" + Math.abs(num1) + sign + "</strong>";

				if(moneyFormat == 'true') {
					returnVal = "<span class=\"revise_dw fl tx_skip\">down</span><strong class=\"fr\">" + Math.abs(num1).toString().commify() + sign + "</strong>";
				}
			}
		}
	}
	return returnVal;
}




















/////////////////////////////[MONEY FORMAT]/////////////////////////////
/**
 * 100으로 나누어 퍼센테이지로 표시
 */
function toPer(val) {
    val = (val/100).toFixed(2);
    return val;
};

/**
 * 100으로 나누어 퍼센테이지로 표시
 */
function dayPer(yesterday, today) {
    if(yesterday == 0){
        return null;
    }

    if(today) {
        val = ((today-yesterday)/yesterday * 100).toFixed(2);
    } else {
        val = null;
    }

    return val;
};

function num2money(val,subtype) {
    if(typeof val == 'undefined' || val == ''){
        return val;
    }

    if(isNaN(val)) {
        var val2 = "";

        if (val.toString().indexOf(".") >= 0) {
            var Nval = val.split(".");
            val2 = Nval[0].toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") +'.'+Nval[1];
        } else {
            val2 = val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }
        return val2;
    }

    if(subtype){
        if(subtype != 'N'){
            valNum = val.substring(4,5).replace(/-/gi,"");
            var Nval = valNum.split(".");
            val = parseInt(Nval[0])+'.'+Nval[1];
        }else{
            val.replace(/-/gi,"");
            val = parseInt(val);
        }
    }

    var val2 = "";
    if (val.toString().indexOf(".") >= 0) {
        var Nval = val.split(".");
        val2 = Nval[0].toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") +'.'+Nval[1];
    } else {
        val2 = val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    return val2;

//    return val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
};

function num2int(val) {
    if(isNaN(val)) {
        return val;
    };
    return val.toString().replace(/-/g, "");
};

function num2Cut(val) {
    if(isNaN(val)) {
        return val;
    };
    var rslt = val.split(".");
    var result =rslt[0]+"."+rslt[1].substring(0,2);

    return result;
};

function comma(s) {
    var number;
    switch ( typeof s ) {
        case "string":    number = Number(s);    break;
        case "number":    number = s;    break;
        default: return "";
    }

    if ( isNaN(number) ) return s;// number == NaN 으로는 체크 불가

    var isMinus = number < 0;
    var numStr = String(Math.abs(number));
    var dotPos = numStr.indexOf(".");
    var result;
    var sPos;
    if ( dotPos < 0 ) {
        result = "";
        sPos = numStr.length - 1;
    } else {
        result = numStr.substring(dotPos);
        sPos = dotPos - 1;
    }

    var cnt = 1;
    var chkPos = sPos;
    while ( chkPos >= 0 ) {
        var numChar = numStr.charAt(chkPos);
        result = (cnt % 3 == 1 && chkPos != sPos ? (numChar + ","):numChar) + result;
        chkPos--;
        cnt++;
    }
    return isMinus ? "-"+result:result;
}


function numberWithCommas(x) {
    var parts = x.toString().split(".");
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return parts.join(".");
};

///////////////////////////////[MONEY FORMAT]/////////////////////////////