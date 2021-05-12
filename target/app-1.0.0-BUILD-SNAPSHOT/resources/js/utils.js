/*
0 노랑 same
1 보라 upper
2 하늘 lower
3 초록 up
4 빨강 down
*/


function getCurrent(val,css){
	var str = "";
	var className = "";
	
	if(css == "0"){
		className = "same";
	}else if(css == "1"){
		className = "upper";
	}else if(css == "2"){
		className = "lower";
	}else if(css == "3"){
		className = "up";
	}else if(css == "4"){
		className = "low";
	}
	
	str += "<td class='"+className+"'>"+val+"</td>";
	
	return str;
}

function getPlusAndMinus(val,css){
	var str = "";
	var className = "";
	
	if(css == "0"){
		className = "arrow same";
	}else if(css == "1"){
		className = "arrow upper";
	}else if(css == "2"){
		className = "arrow lower";
	}else if(css == "3"){
		className = "arrow up";
	}else if(css == "4"){
		className = "arrow low";
	}
	
	str += "<td class='"+className+"'>"+val+"</td>";
	
	return str;
}

function nomarChange(val,css){
	var str = "";
	var className = "";
	
	if(css == "0"){
		className = "same";
	}else if(css == "1"){
		className = "upper";
	}else if(css == "2"){
		className = "lower";
	}else if(css == "3"){
		className = "up";
	}else if(css == "4"){
		className = "low";
	}
	
	str += "<td class='"+className+"'>"+val+"</td>";
	
	return str;
}


//매뉴이동
function linkUrl(Num){
	if(Num == 1){
		location.href = "/wts/whatchlist.jsp";
	}else if(Num == 2){
		location.href = "/wts/currentstatus.jsp";
	}else{
		location.href = "/wts/whatchlist.jsp";
	}
}


function alertMsg(){
	var target = $("#noticeForm");
}

function loadingShow(){
	$("#loginBar").show();
}

function loadingHide(){
	$("#loginBar").hide();
}
jQuery.fn.center = function () {
    this.css("position","absolute");
    this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px");
    this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()) + "px");
    return this;
};

function alertMsg(text){
	$("#alertMsg").html("<p>"+text+"</p>");
	$("#alMsg").center().show();
	
}

function alertMsgClose(){
	$("#alMsg").hide();
}




