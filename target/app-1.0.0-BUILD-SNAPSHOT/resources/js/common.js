var stockList = [];		//전체주식
var common = {
	mvStockId:"",
	mvMarketId:"",
	securityF:"",
	securityS:"",
	ModifyId:"",
	modifyGroupid:"",
	modifyTargetId:"",
	modifyTargetGroupId:"",
	cancelTargetId:"",
	cancelTargetGroupId:"",
	genmodifyOrderStatus:{}
};
var orderInfo = {};
var copydata = {};
var stockData = {};
var ttmRespone = null;
var accountBalanceRepone = null;
var checkSessions = null;
var authconfirm = true;
var stockInfos = null;
