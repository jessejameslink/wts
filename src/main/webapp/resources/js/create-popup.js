/**
 * 2014년 2월 12 수요일
 * 이용탁
 * thrue486@naver.com
 * *****************************************************
 * 개선 및 버그 사항 메일로 보내주시길 바랍니다.
 * *****************************************************
 */

function dialgoAction(){}
dialgoAction.prototype.open = function(getPopupUrl, getPopupDivName, getPopupWidht, getPopupHeight, getFormId, getTitle){
	
	var str = '<div id="' +getPopupDivName+ '" style="display:none;" ></div>';
	$("body").append(str);
	
	if(getTitle == null){
		getTitle = '';
	}
	
	$.ajax({
		url : getPopupUrl,
		type : 'POST',
		data : $('#'+getFormId).serialize(),
		//async : false,
		success : function(data, textStatus, jqXHR){
			
				$("#"+getPopupDivName).append(data);
				$("#"+getPopupDivName).dialog({
					modal : true,
					width : getPopupWidht,
					height : getPopupHeight,
					closeOnEscape : false,
					resizable : false,
					title : getTitle,
					buttons: {							
						Cancel: function() {	
							$('#'+getPopupDivName).remove();
							$('#'+getFormId).remove();
							$( this ).dialog( "close" );
						}
					},
					close : function(){
						$('#'+getPopupDivName).remove();
						$('#'+getFormId).remove();
					}
				});
				
		},
		errer : function(jqXHR, textStatus, errorThrown) {
			alert(textStatus);
		},
		statusCode : {
			400: function(){
				alert("Popup 화면 생성에 실패하였습니다.");
				$('#'+getPopupDivName).remove();
				$('#'+getFormId).remove();
			},
			404: function(){
				alert("Profile정보가 존재하지 않습니다.");
				$('#'+getPopupDivName).remove();
				$('#'+getFormId).remove();
			},
			501: function(){
				alert("Profile정보 조회중 서버 오류가 발생하였습니다.");
				$('#'+getPopupDivName).remove();
				$('#'+getFormId).remove();
			}
				
		}
	});		
};
dialgoAction.prototype.close = function(getPopupDivName) {
	$("#" + getPopupDivName).dialog("close");
};


function popupCreate(){
	
	this.popupInfo = {
			popupUrl : null, //팝업불러올 url	
			popupWidht : 0, // 팝업가로사이즈
			popupHeight : 0, // 팝업 세로 사이즈
			popupTitle : null,
			arrayDataValue : new Array(), // 추가적인 데이타 값
			arrayDataKey : new Array(),	// 추가적인 데이타 키
			popupDiv : 'createPopupDiv', // 생성될 팝업 div
			formId : 'creatPopupForm' // 생성될 팝업 form						
	};	
	
	this.setPopupUrl = function(url){
		this.popupInfo.popupUrl = url;
	};
	this.setPopupWidht = function(widht){
		this.popupInfo.popupWidht = widht;
	};
	this.setPopupHeight = function(height){
		this.popupInfo.popupHeight = height;
	};
	this.setPopupTitle = function(title){
		this.popupInfo.popupTitle = title;
	};
	this.put = function(key,value){
		this.popupInfo.arrayDataKey.push(key);
		this.popupInfo.arrayDataKey.push(value);
	};	
	this.clear = function(){
		this.popupInfo.arrayDataValue = new Array();
		this.popupInfo.arrayDataKey = new Array();
		this.popupInfo.popupWidht = 0;
		this.popupInfo.popupHeight = 0;
		this.popupInfo.popupUrl = null;
	};
};

popupCreate.prototype.open = function(){
	
	var dialgos = new dialgoAction();
	var popupInfo = this.popupInfo;
	
	var errorCheck = function(){	
		var action = true;			
		if(popupInfo.popupUrl == null){
			action = false;
			aleat('popup URL - NullPointerException');
		}
		if(popupInfo.popupWidht == 0){
			action = false;
			aleat('popup widht - 0');
		}
		if(popupInfo.popupHeight == 0){
			action = false;
			aleat('popup height - 0');
		}		
		return action;
	};
	
	if(errorCheck() == true){		
		$('body').append('<form id="'+this.popupInfo.formId+'" method="post"></form>');
		for(var i =0; i < this.popupInfo.arrayDataKey.length; i++){
			for(var v =0; v < this.popupInfo.arrayDataValue.length; v++){
				if(i == v){
					$('#'+this.popupInfo.formId).append('<input type="hidden" name="'+this.popupInfo.arrayDataKey[i]+'" value="'+this.popupInfo.arrayDataValue[v]+'" />');
				}
			}
		}	
		dialgos.open(this.popupInfo.popupUrl, this.popupInfo.popupDiv,this.popupInfo.popupWidht, this.popupInfo.popupHeight, this.popupInfo.formId, this.popupInfo.popupTitle);
	};	
	
};
popupCreate.prototype.close = function(){	
	var dialgos = new dialgoAction();
	$('#'+this.popupInfo.formId).remove();
	$('#'+this.popupInfo.popupDiv).remove();
	dialgos.close(this.popupInfo.popupDiv);
};

