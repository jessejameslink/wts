package com.config;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.http.Header;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

@SuppressWarnings("deprecation")
public class TTLLogin {

	public String JSESSIONID = "";
	private final String USER_AGENT = "Mozilla/5.0";
	private final String host = "10.0.31.4";
	private final String server = "http://10.0.31.4/";
	private HttpClient httpClient;

	public String getSession(){
		return this.JSESSIONID;
	}

	public void setSession(String JSESSIONID){
		this.JSESSIONID = JSESSIONID;
	}

	public void setplusSession(String JSESSIONID){
		this.JSESSIONID += JSESSIONID;
	}

	public JSONObject login(HttpServletRequest request) throws Exception {
		String loginUrl = server + "dologin.action";

		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvClientID", request.getParameter("mvClientID")));
		paramList.add(new BasicNameValuePair("mvPassword", request.getParameter("mvPassword")));
		paramList.add(new BasicNameValuePair("securitycode", request.getParameter("securitycode")));

		HttpSession session = request.getSession();
		JSONObject arr = sendPostlogin(loginUrl, paramList);

		if((Boolean) arr.get("success")){
			//System.out.println(">>>>>>>>>>>>>>>>>>>>>>> Session OK <<<<<<<<<<<<<<<<<<<<<<"+arr.get("success"));
			session.setAttribute("ClientV", request.getParameter("mvClientID"));
			session.setAttribute("ttlJsession", getSession());
		} else {
			//System.out.println(">>>>>>>>>>>>>>>>>>>>>>> Session fail <<<<<<<<<<<<<<<<<<<<<<"+arr.get("success"));
			session.setAttribute("ClientV", "");
			session.setAttribute("ttlJsession", "");
		}

		return arr;
	}

	public JSONObject checkSession(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
	    long tt = nTime.getTime();
		String url = server + "checkSession.action";

		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvTimelyUpdate", "N"));
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		return sendPost(url, paramList, request);
	}

	//보유수량 parameter
	//_dc=1462087754261&key=1462087754259&mvEnableGetStockInfo=N&mvAction=SB
	//선택된 주식status parameter
	//mvInstrument=HNG&mvMarketId=HO&mvBS=B&key=1462087639345&mvEnableGetStockInfo=N&mvAction=OI,CBP
	public JSONObject stockInfo(HttpServletRequest request) throws Exception {
		String url = server + "stockInfo.action";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();

		Date nTime = new Date();
	    long tt = nTime.getTime();

	    if("stockInfoList".equals(request.getParameter("chk"))){
	    	Date nTimea = new Date();
		    long ttt = nTimea.getTime();
	    	paramList.add(new BasicNameValuePair("_dc", String.valueOf(tt)));
			paramList.add(new BasicNameValuePair("key", String.valueOf(ttt)));
			paramList.add(new BasicNameValuePair("mvEnableGetStockInfo", "N"));
			paramList.add(new BasicNameValuePair("mvAction", request.getParameter("mvAction")));
	    } else {
	    	paramList.add(new BasicNameValuePair("mvInstrument", request.getParameter("mvInstrument")));
			paramList.add(new BasicNameValuePair("mvMarketId", request.getParameter("mvMarketId")));
			paramList.add(new BasicNameValuePair("mvBS", request.getParameter("mvBS")));
			paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
			paramList.add(new BasicNameValuePair("mvEnableGetStockInfo", request.getParameter("mvEnableGetStockInfo")));
			paramList.add(new BasicNameValuePair("mvAction", request.getParameter("mvAction")));
	    }

		return sendPost(url, paramList, request);
	}

	public JSONObject callEnquiryOrder(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
	    long tt  = nTime.getTime();
		String url = server + "enquiryorder.action";

		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvLastAction", "ACCOUNT"));
		paramList.add(new BasicNameValuePair("mvChildLastAction", "ORDERENQUIRY"));
		
		if(request.getParameter("mvStatus") != null) {
			paramList.add(new BasicNameValuePair("mvStatus", request.getParameter("mvStatus"))); 
		}
		if(request.getParameter("mvOrderType") != null) {
			paramList.add(new BasicNameValuePair("mvOrderType", request.getParameter("mvOrderType"))); 
		}
		if(request.getParameter("mvOrderBS") != null) {
			paramList.add(new BasicNameValuePair("mvOrderBS", request.getParameter("mvOrderBS")));
		}
		if(request.getParameter("mvStockID") != null) {
			paramList.add(new BasicNameValuePair("mvStockID", request.getParameter("mvStockID")));
		}
		
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		paramList.add(new BasicNameValuePair("_dc", String.valueOf(tt)));
		paramList.add(new BasicNameValuePair("page", "1"));
		paramList.add(new BasicNameValuePair("start", "0"));
		paramList.add(new BasicNameValuePair("limit", "100"));
		return sendPost(url, paramList, request);
	}

	public JSONObject queryMarketStatusInfo(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
	    long tt = nTime.getTime();
		String url = server + "queryMarketStatusInfo.action";

		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvMarketID", request.getParameter("mvMarketID")));
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));

		return sendPost(url, paramList, request);
	}

	public JSONObject enquiryportfolio(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
	    long tt = nTime.getTime();
		String url = server + "enquiryportfolio.action";

		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvLastAction", request.getParameter("mvLastAction")));
		paramList.add(new BasicNameValuePair("mvChildLastAction", request.getParameter("mvChildLastAction")));
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));

		return sendPost(url, paramList, request);
	}

	public JSONObject enterorderfail(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
	    long tt = nTime.getTime();
		String url = server + "enterorderfail.action";

		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		return sendPost(url, paramList, request);
	}

	public JSONObject authCardMatrix(HttpServletRequest request) throws Exception {
		String url = server + "authCardMatrix.action";

		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("wordMatrixKey01", request.getParameter("wordMatrixKey01")));
		paramList.add(new BasicNameValuePair("wordMatrixValue01", request.getParameter("wordMatrixValue01")));
		paramList.add(new BasicNameValuePair("wordMatrixKey02", request.getParameter("wordMatrixKey02")));
		paramList.add(new BasicNameValuePair("wordMatrixValue02", request.getParameter("wordMatrixValue02")));
		paramList.add(new BasicNameValuePair("serialnumber", request.getParameter("wordMatrixValue02")));
		paramList.add(new BasicNameValuePair("mvSaveAuthenticate", request.getParameter("mvSaveAuthenticate")));
		return sendPost(url, paramList, request);
	}

	public JSONObject stockSearch(HttpServletRequest request) throws Exception {
		String url = server + "stockSearch.action";

		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("type", "bycode"));
		paramList.add(new BasicNameValuePair("value", "all"));
		return sendPost(url, paramList, request);
	}

	public JSONObject getMarketData(HttpServletRequest request) throws Exception {


		Date nTime = new Date();
	    long tt = nTime.getTime();
		String url = server + "getMarketData.action";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvCategory", "1"));
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		return sendPost(url, paramList, request);
	}

	public JSONObject enterOrder(HttpServletRequest request) throws Exception {
		String url = server + "enterorder.action";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvBS", request.getParameter("mvBS")));							//BUY :B, SELL:S
		paramList.add(new BasicNameValuePair("mvStockCode", request.getParameter("mvStockCode")));				//StockCode
		//paramList.add(new BasicNameValuePair("mvLending", request.getParameter("mvLending")));
		//paramList.add(new BasicNameValuePair("mvBuyingPower", request.getParameter("mvBuyingPower")));
		paramList.add(new BasicNameValuePair("mvOrderTypeValue", request.getParameter("mvOrderTypeValue")));
		paramList.add(new BasicNameValuePair("mvQuantity", request.getParameter("mvQuantity")));				//valume
		paramList.add(new BasicNameValuePair("mvPrice", request.getParameter("mvPrice")));						//price
		//paramList.add(new BasicNameValuePair("mvGrossAmt", request.getParameter("mvGrossAmt")));
		//paramList.add(new BasicNameValuePair("mvNetFee", request.getParameter("mvNetFee")));
		paramList.add(new BasicNameValuePair("mvMarketID", request.getParameter("mvMarketID")));				//market Kind of?
		paramList.add(new BasicNameValuePair("refId", request.getParameter("refId")));							//what the...
		paramList.add(new BasicNameValuePair("mvWaitOrder", request.getParameter("mvWaitOrder")));
		paramList.add(new BasicNameValuePair("mvGoodTillDate", request.getParameter("mvGoodTillDate")));
		paramList.add(new BasicNameValuePair("mvAfterServerVerification", request.getParameter("mvAfterServerVerification")));
		//paramList.add(new BasicNameValuePair("ext-gen1372", request.getParameter("extgen1372")));
		//paramList.add(new BasicNameValuePair("ext-gen1373", request.getParameter("extgen1373")));
		//paramList.add(new BasicNameValuePair("ext-gen1374", request.getParameter("extgen1374")));
		paramList.add(new BasicNameValuePair("ext-gen1375", request.getParameter("extgen1375")));
		paramList.add(new BasicNameValuePair("ext-gen1376", request.getParameter("extgen1376")));
		paramList.add(new BasicNameValuePair("mvBankID", request.getParameter("mvBankID")));
		paramList.add(new BasicNameValuePair("mvBankACID", request.getParameter("mvBankACID")));
		return sendPost(url, paramList, request);
	}

	public JSONObject cancelOrder(HttpServletRequest request) throws Exception {
		String url = server + "hksCancelOrder.action";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("AfterServerVerification", "Y"));
		paramList.add(new BasicNameValuePair("BuySell", request.getParameter("BuySell")));
		paramList.add(new BasicNameValuePair("ORDERID", request.getParameter("ORDERID")));
		paramList.add(new BasicNameValuePair("ORDERGROUPID", request.getParameter("ORDERGROUPID")));
		paramList.add(new BasicNameValuePair("StockCode", request.getParameter("StockCode")));
		paramList.add(new BasicNameValuePair("MarketID", request.getParameter("MarketID")));
		paramList.add(new BasicNameValuePair("Quantity", request.getParameter("Quantity")));
		paramList.add(new BasicNameValuePair("Price", request.getParameter("Price")));
		paramList.add(new BasicNameValuePair("OSQty", request.getParameter("OSQty")));
		paramList.add(new BasicNameValuePair("FILLEDQTY", request.getParameter("FILLEDQTY")));
		paramList.add(new BasicNameValuePair("OrderTypeValue", request.getParameter("OrderTypeValue")));
		paramList.add(new BasicNameValuePair("GOODTILLDATE", request.getParameter("GOODTILLDATE")));
		paramList.add(new BasicNameValuePair("StopTypeValue", request.getParameter("StopTypeValue")));
		paramList.add(new BasicNameValuePair("StopPrice", request.getParameter("StopPrice")));
		paramList.add(new BasicNameValuePair("SavePass", request.getParameter("SavePass")));
		paramList.add(new BasicNameValuePair("PasswordConfirmation", request.getParameter("PasswordConfirmation")));
		paramList.add(new BasicNameValuePair("mvAllorNothing", request.getParameter("mvAllorNothing")));
		paramList.add(new BasicNameValuePair("mvOrderId", request.getParameter("mvOrderId")));
		paramList.add(new BasicNameValuePair("mvMarketId", request.getParameter("mvMarketId")));
		paramList.add(new BasicNameValuePair("mvStockId", request.getParameter("mvStockId")));
		paramList.add(new BasicNameValuePair("mvInstrumentName", request.getParameter("mvInstrumentName")));
		paramList.add(new BasicNameValuePair("mvPric", request.getParameter("mvPric")));
		paramList.add(new BasicNameValuePair("mvQutityFormat", request.getParameter("mvQutityFormat")));
		paramList.add(new BasicNameValuePair("mvFilledQty", request.getParameter("mvFilledQty")));
		paramList.add(new BasicNameValuePair("mvOSQty", request.getParameter("mvOSQty")));
		paramList.add(new BasicNameValuePair("mvOrderType", request.getParameter("mvOrderType")));
		paramList.add(new BasicNameValuePair("password", request.getParameter("password")));
		paramList.add(new BasicNameValuePair("mvSecurityCode", request.getParameter("mvSecurityCode")));
		paramList.add(new BasicNameValuePair("mvSeriNo", request.getParameter("mvSeriNo")));
		paramList.add(new BasicNameValuePair("mvAnswer", request.getParameter("mvAnswer")));
		paramList.add(new BasicNameValuePair("mvSaveAuthenticate", request.getParameter("mvSaveAuthenticate")));
		paramList.add(new BasicNameValuePair("mvInputTime", request.getParameter("mvInputTime")));
		paramList.add(new BasicNameValuePair("mvStatus", request.getParameter("mvStatus")));
		paramList.add(new BasicNameValuePair("mvGoodTillDate", request.getParameter("mvGoodTillDate")));

		return sendPost(url, paramList, request);
	}

	public JSONObject genmodifyOrder(HttpServletRequest request) throws Exception {
		String url = server + "genmodifyorder.action?";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvOrderId", request.getParameter("mvOrderId")));							//BUY :B, SELL:S
		paramList.add(new BasicNameValuePair("mvBSValue", request.getParameter("mvBSValue")));							//BUY :B, SELL:S
		paramList.add(new BasicNameValuePair("mvStockId", request.getParameter("mvStockId")));							//StockCode
		paramList.add(new BasicNameValuePair("mvMarketId", request.getParameter("mvMarketId")));
		paramList.add(new BasicNameValuePair("mvPriceValue", request.getParameter("mvPriceValue")));
		paramList.add(new BasicNameValuePair("mvQtyValue", request.getParameter("mvQtyValue")));
		paramList.add(new BasicNameValuePair("mvCancelQtyValue", request.getParameter("mvCancelQtyValue")));			//valume
		paramList.add(new BasicNameValuePair("mvInputTime", request.getParameter("mvInputTime")));						//price
		paramList.add(new BasicNameValuePair("mvStopTypeValue", request.getParameter("mvStopTypeValue")));
		paramList.add(new BasicNameValuePair("mvStopPriceValue", request.getParameter("mvStopPriceValue")));
		paramList.add(new BasicNameValuePair("mvStopOrderExpiryDate", request.getParameter("mvStopOrderExpiryDate")));	//market Kind of?
		paramList.add(new BasicNameValuePair("mvOrderTypeValue", request.getParameter("mvOrderTypeValue")));			//what the...
		paramList.add(new BasicNameValuePair("mvAllOrNothing", request.getParameter("mvAllOrNothing")));
		paramList.add(new BasicNameValuePair("mvValidityDate", request.getParameter("mvValidityDate")));
		paramList.add(new BasicNameValuePair("mvActivationDate", request.getParameter("mvActivationDate")));
		paramList.add(new BasicNameValuePair("mvGoodTillDate", request.getParameter("mvGoodTillDate")));
		paramList.add(new BasicNameValuePair("mvRemark", request.getParameter("mvRemark")));
		paramList.add(new BasicNameValuePair("mvContactPhone", request.getParameter("mvContactPhone")));
		paramList.add(new BasicNameValuePair("mvGrossAmt", request.getParameter("mvGrossAmt")));
		paramList.add(new BasicNameValuePair("mvNetAmtValue", request.getParameter("mvNetAmtValue")));
		paramList.add(new BasicNameValuePair("mvSCRIP", request.getParameter("mvSCRIP")));
		paramList.add(new BasicNameValuePair("mvlotSize", request.getParameter("mvlotSize")));
		paramList.add(new BasicNameValuePair("mvOrderGroupId", request.getParameter("mvOrderGroupId")));
		paramList.add(new BasicNameValuePair("mvBaseNetAmtValue", request.getParameter("mvBaseNetAmtValue")));
		paramList.add(new BasicNameValuePair("mvAvgPriceValue", request.getParameter("mvAvgPriceValue")));
		paramList.add(new BasicNameValuePair("mvFilledQty", request.getParameter("mvFilledQty")));
		paramList.add(new BasicNameValuePair("mvStatus", request.getParameter("mvStatus")));

		return sendPost(url, paramList, request);
	}


	public JSONObject ModifyOrder(HttpServletRequest request) throws Exception {
		String url = server + "hksModifyOrder.action";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvCurrencyId", request.getParameter("mvCurrencyId")));								//BUY :B, SELL:S
		paramList.add(new BasicNameValuePair("mvMaxLotPerOrder", request.getParameter("mvMaxLotPerOrder")));								//BUY :B, SELL:S
		paramList.add(new BasicNameValuePair("mvOrigPrice", request.getParameter("mvOrigPrice")));					//StockCode
		paramList.add(new BasicNameValuePair("mvOrigQty", request.getParameter("mvOrigQty")));
		paramList.add(new BasicNameValuePair("mvOrigStopPrice", request.getParameter("mvOrigStopPrice")));
		paramList.add(new BasicNameValuePair("mvStopPrice", request.getParameter("mvStopPrice")));
		paramList.add(new BasicNameValuePair("mvOrigPriceValue", request.getParameter("mvOrigPriceValue")));						//valume
		paramList.add(new BasicNameValuePair("mvOrigQtyValue", request.getParameter("mvOrigQtyValue")));						//price
		paramList.add(new BasicNameValuePair("mvCancelQtyValue", request.getParameter("mvCancelQtyValue")));
		paramList.add(new BasicNameValuePair("mvAveragePrice", request.getParameter("mvAveragePrice")));
		paramList.add(new BasicNameValuePair("mvAllOrNothing", request.getParameter("mvAllOrNothing")));						//market Kind of?
		paramList.add(new BasicNameValuePair("mvStopOrderType", request.getParameter("mvStopOrderType")));							//what the...
		paramList.add(new BasicNameValuePair("mvValidityDate", request.getParameter("mvValidityDate")));
		paramList.add(new BasicNameValuePair("mvActivationDate", request.getParameter("mvActivationDate")));
		paramList.add(new BasicNameValuePair("mvAllowOddLot", request.getParameter("mvAllowOddLot")));
		paramList.add(new BasicNameValuePair("mvRemark", request.getParameter("mvRemark")));
		paramList.add(new BasicNameValuePair("mvContactPhone", request.getParameter("mvContactPhone")));
		paramList.add(new BasicNameValuePair("mvGrossAmtValue", request.getParameter("mvGrossAmtValue")));
		paramList.add(new BasicNameValuePair("mvNetAmtValue", request.getParameter("mvNetAmtValue")));
		paramList.add(new BasicNameValuePair("mvSCRIP", request.getParameter("mvSCRIP")));
		paramList.add(new BasicNameValuePair("mvIsPasswordSaved", request.getParameter("mvIsPasswordSaved")));
		paramList.add(new BasicNameValuePair("mvStopTypeValue", request.getParameter("mvStopTypeValue")));
		paramList.add(new BasicNameValuePair("mvPasswordConfirmation", request.getParameter("mvPasswordConfirmation")));
		paramList.add(new BasicNameValuePair("mvOrderId", request.getParameter("mvOrderId")));
		paramList.add(new BasicNameValuePair("mvGoodTillDate", request.getParameter("mvGoodTillDate")));
		paramList.add(new BasicNameValuePair("mvBS", request.getParameter("mvBS")));
		paramList.add(new BasicNameValuePair("mvOrderGroupId", request.getParameter("mvOrderGroupId")));
		paramList.add(new BasicNameValuePair("mvOrderType", request.getParameter("mvOrderType")));
		paramList.add(new BasicNameValuePair("mvFormIndexpage", request.getParameter("mvFormIndexpage")));
		paramList.add(new BasicNameValuePair("mvStopValue", request.getParameter("mvStopValue")));
		paramList.add(new BasicNameValuePair("mvFilledQty", request.getParameter("mvFilledQty")));
		paramList.add(new BasicNameValuePair("mvLotSizeValue", request.getParameter("mvLotSizeValue")));

		paramList.add(new BasicNameValuePair("mvStopOrderExpiryDate", request.getParameter("mvStopOrderExpiryDate")));
		paramList.add(new BasicNameValuePair("OrderId", request.getParameter("OrderId")));
		paramList.add(new BasicNameValuePair("mvMarketId", request.getParameter("mvMarketId")));
		paramList.add(new BasicNameValuePair("mvStockId", request.getParameter("mvStockId")));
		paramList.add(new BasicNameValuePair("mvStockName", request.getParameter("mvStockName")));
		paramList.add(new BasicNameValuePair("mvPrice", request.getParameter("mvPrice")));
		paramList.add(new BasicNameValuePair("mvNewPrice", request.getParameter("mvNewPrice")));
		paramList.add(new BasicNameValuePair("mvQty", request.getParameter("mvQty")));
		paramList.add(new BasicNameValuePair("mvNewQty", request.getParameter("mvNewQty")));
		paramList.add(new BasicNameValuePair("OrderType", request.getParameter("OrderType")));
		paramList.add(new BasicNameValuePair("GoodTillDate", request.getParameter("GoodTillDate")));
		paramList.add(new BasicNameValuePair("mvGrossAmt", request.getParameter("mvGrossAmt")));

		paramList.add(new BasicNameValuePair("Password", request.getParameter("Password")));
		paramList.add(new BasicNameValuePair("mvSecurityCode", request.getParameter("mvSecurityCode")));
		paramList.add(new BasicNameValuePair("mvStatus", request.getParameter("mvStatus")));
		paramList.add(new BasicNameValuePair("mvSeriNo", request.getParameter("mvSeriNo")));
		paramList.add(new BasicNameValuePair("mvAnswer", request.getParameter("mvAnswer")));
		paramList.add(new BasicNameValuePair("mvSaveAuthenticate", request.getParameter("mvSaveAuthenticate")));

		return sendPost(url, paramList, request);
	}

	public JSONObject ttlcomet(HttpServletRequest request) throws Exception {
		String url = server + "ttlcomet/comet.ttl";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();

		Date nTime = new Date();
	    long tt = nTime.getTime();

		if("ordercheck".equals(request.getParameter("chk"))){
			paramList.add(new BasicNameValuePair("action", "register"));
			paramList.add(new BasicNameValuePair("xtype", "dynOrderList"));
		} else if("ttlInit".equals(request.getParameter("chk"))){
			paramList.add(new BasicNameValuePair("action", "init"));
			paramList.add(new BasicNameValuePair("_dc",  String.valueOf(tt)));
		} else if("nowPricecheck".equals(request.getParameter("chk"))){
			paramList.add(new BasicNameValuePair("action", request.getParameter("action")));
			paramList.add(new BasicNameValuePair("symbol", request.getParameter("symbol")));
			paramList.add(new BasicNameValuePair("marketId", request.getParameter("marketId")));
			paramList.add(new BasicNameValuePair("stockWatchID", request.getParameter("stockWatchID")+"-1234"));
			paramList.add(new BasicNameValuePair("xtype", request.getParameter("xtype")));
			paramList.add(new BasicNameValuePair("_dc",  String.valueOf(tt)));
		} else if("orderlistUpdate".equals(request.getParameter("chk"))){
			paramList.add(new BasicNameValuePair("action", "register"));
			paramList.add(new BasicNameValuePair("xtype", "dynOrderList"));
			paramList.add(new BasicNameValuePair("_dc",  String.valueOf(tt)));
		} else if("unregister".equals(request.getParameter("chk"))){
			paramList.add(new BasicNameValuePair("action", "register"));
			paramList.add(new BasicNameValuePair("xtype", "dynOrderList"));
			paramList.add(new BasicNameValuePair("stockWatchID", request.getParameter("stockWatchID")));
			paramList.add(new BasicNameValuePair("_dc",  String.valueOf(tt)));
		} else {
			paramList.add(new BasicNameValuePair("action", "update"));
			paramList.add(new BasicNameValuePair("_dc",  String.valueOf(tt)));
		}

		return sendPost(url, paramList, request);
	}

	public JSONObject changelanguage(HttpServletRequest request) throws Exception {
		String loginUrl = server + "changelanguage.action";

		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvCurrentLanguage", request.getParameter("mvCurrentLanguage")));
		paramList.add(new BasicNameValuePair("request_locale", request.getParameter("request_locale")));

		return sendPost(loginUrl, paramList, request);
	}

	public JSONObject accountbalance(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
	    long tt = nTime.getTime();
		String url = server + "accountbalance.action";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		
		if(request.getParameter("bankId") != null){
			paramList.add(new BasicNameValuePair("bankId", request.getParameter("bankId")));
		}
		
		if(request.getParameter("bankAcId") != null){
			paramList.add(new BasicNameValuePair("bankAcId", request.getParameter("bankAcId")));
		}
		
		if(request.getParameter("loadBank") != null){
			paramList.add(new BasicNameValuePair("loadBank", request.getParameter("loadBank")));
		}
		return sendPost(url, paramList, request);
	}
	
	public JSONObject overduedebt(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
		long tt = nTime.getTime();
		String url = server + "overduedebt.action";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		return sendPost(url, paramList, request);
	}
	
	public JSONObject upcomingdebt(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
		long tt = nTime.getTime();
		String url = server + "upcomingdebt.action";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		paramList.add(new BasicNameValuePair("_dc", String.valueOf(tt)));
		return sendPost(url, paramList, request);
	}

	public JSONObject verifyOrder(HttpServletRequest request) throws Exception {
		String url = server + "verifyOrder.action";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvBS", request.getParameter("mvBS")));								//BUY :B, SELL:S
		paramList.add(new BasicNameValuePair("mvStockCode", request.getParameter("mvStockCode")));					//StockCode
		paramList.add(new BasicNameValuePair("mvMarketID", request.getParameter("mvMarketID")));
		paramList.add(new BasicNameValuePair("mvPrice", request.getParameter("mvPrice")));
		paramList.add(new BasicNameValuePair("mvQuantity", request.getParameter("mvQuantity")));						//valume
		paramList.add(new BasicNameValuePair("mvOrderTypeValue", request.getParameter("mvOrderTypeValue")));
		paramList.add(new BasicNameValuePair("mvGoodTillDate", request.getParameter("mvGoodTillDate")));
		paramList.add(new BasicNameValuePair("mvBankID", request.getParameter("mvBankID")));
		paramList.add(new BasicNameValuePair("mvBankACID", request.getParameter("mvBankACID")));
		paramList.add(new BasicNameValuePair("mvGrossAmt", request.getParameter("mvGrossAmt")));

		return sendPost(url, paramList, request);
	}

	private JSONObject sendPost(String url, List<NameValuePair> postParams,HttpServletRequest request) throws Exception {
		httpClient = new DefaultHttpClient();
		HttpPost post = new HttpPost(url);

		HttpSession session = request.getSession();

		// add header
		post.setHeader("Host", host);
		post.setHeader("User-Agent", USER_AGENT);
		post.setHeader("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
		post.setHeader("Accept-Language", "en-US,en;q=0.5");
		post.setHeader("Cookie", session.getAttribute("ttlJsession").toString());
		post.setHeader("Connection", "keep-alive");
		post.setHeader("Content-Type", "application/x-www-form-urlencoded");
		post.setEntity(new UrlEncodedFormEntity(postParams));

		HttpResponse response = httpClient.execute(post);

		int responseCode = response.getStatusLine().getStatusCode();

		//System.out.println("\nSending 'POST' request to URL : " + url);
		//System.out.println("Post parameters : " + postParams);
		//System.out.println("Response Code : " + responseCode);
		//System.out.println("JSESSIONID : "+session.getAttribute("ttlJsession").toString());

		BufferedReader rd = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));

		StringBuffer result = new StringBuffer();
		String line = "";
		while ((line = rd.readLine()) != null) {
			result.append(line);
		}

		rd.close();
		//System.out.println(result.toString().replaceAll( "<!--", "" ));
		JSONObject jsonObject = (JSONObject) JSONValue.parse(result.toString());
		//return result.toString().replaceAll( "<!--", "" ) ;

		return jsonObject;
	}

	private JSONObject sendPostlogin(String url, List<NameValuePair> postParams) throws Exception {
		httpClient = new DefaultHttpClient();

		HttpPost post = new HttpPost(url);

		// add header
		post.setHeader("Host", host);
		post.setHeader("User-Agent", USER_AGENT);
		post.setHeader("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
		post.setHeader("Accept-Language", "en-US,en;q=0.5");
		post.setHeader("Connection", "keep-alive");
		post.setHeader("Content-Type", "application/x-www-form-urlencoded");
		post.setEntity(new UrlEncodedFormEntity(postParams));

		HttpResponse response = httpClient.execute(post);

		int responseCode = response.getStatusLine().getStatusCode();

		for (Header header : response.getAllHeaders()) {
			if("Set-Cookie".equals(header.getName())){
				setplusSession(header.getValue());
			}
		}

		//System.out.println("\nSending 'POST' request to URL : " + url);
		//System.out.println("Post parameters : " + postParams);
		//System.out.println("Response Code : " + responseCode);
		//System.out.println("setHeaders : " + getSession());

		BufferedReader rd = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));

		StringBuffer result = new StringBuffer();
		String line = "";
		while ((line = rd.readLine()) != null) {
			result.append(line);
		}

		rd.close();
		//System.out.println(result.toString().replaceAll( "<!--", "" ));
		JSONObject jsonObject = (JSONObject) JSONValue.parse(result.toString());
		//return result.toString().replaceAll( "<!--", "" ) ;

		return jsonObject;
	}

	// gmlee. - 2016.08.19
	public JSONObject querySoldOrders(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
	    long tt = nTime.getTime();
		String url = server + "querySoldOrders.action";

		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvLastAction", request.getParameter("mvLastAction")));
		paramList.add(new BasicNameValuePair("mvChildLastAction", request.getParameter("mvChildLastAction")));
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		paramList.add(new BasicNameValuePair("_dc", request.getParameter("_dc")));
		paramList.add(new BasicNameValuePair("start", request.getParameter("start")));
		paramList.add(new BasicNameValuePair("limit", request.getParameter("limit")));
		paramList.add(new BasicNameValuePair("page", request.getParameter("page")));

		return sendPost(url, paramList, request);
	}

	// gmlee. - 2016.08.19
	public JSONObject getCashAdvanceHistory(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
	    long tt = nTime.getTime();
		String url = server + "getCashAdvanceHistory.action";

		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvLastAction", request.getParameter("mvLastAction")));
		paramList.add(new BasicNameValuePair("mvChildLastAction", request.getParameter("mvChildLastAction")));
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		paramList.add(new BasicNameValuePair("_dc", request.getParameter("_dc")));
		paramList.add(new BasicNameValuePair("start", request.getParameter("start")));
		paramList.add(new BasicNameValuePair("limit", request.getParameter("limit")));
		paramList.add(new BasicNameValuePair("page", request.getParameter("page")));

		return sendPost(url, paramList, request);
	}

	// gmlee. - 2016.08.19
	public JSONObject getLocalAdvanceCreation(HttpServletRequest request) throws Exception {
		String url = server + "getLocalAdvanceCreation.action";

		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvLastAction", request.getParameter("mvLastAction")));
		paramList.add(new BasicNameValuePair("mvChildLastAction", request.getParameter("mvChildLastAction")));

		return sendPost(url, paramList, request);
	}

	// jdchoi. - 2016.08.19
	public JSONObject getGenenterorder(HttpServletRequest request) throws Exception {
		String url = server + "genenterorder.action";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();

		return sendPost(url, paramList, request);
	}
	
	// gmlee. - 2016.08.19
	public JSONObject submitAdvancePaymentCreation(HttpServletRequest request) throws Exception {		
		Date nTime = new Date();
		long tt = nTime.getTime();
		String url = server + "submitAdvancePaymentCreation.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();	
		paramList.add(new BasicNameValuePair("lvAdvAvaiable", request.getParameter("lvAdvAvaiable")));
		paramList.add(new BasicNameValuePair("lvAdvRequest", request.getParameter("lvAdvRequest")));
		paramList.add(new BasicNameValuePair("lvAmount", request.getParameter("lvAmount")));
		paramList.add(new BasicNameValuePair("mvSeriNo", request.getParameter("mvSeriNo")));
		paramList.add(new BasicNameValuePair("mvAnswer", request.getParameter("mvAnswer")));
		paramList.add(new BasicNameValuePair("mvSaveAuthenticate:true", request.getParameter("mvSaveAuthenticate")));
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		
		return sendPost(url, paramList,request);
	}
	
	// gmlee. - 2016.08.23
	public JSONObject checkAdvancePaymentTime(HttpServletRequest request) throws Exception {
		String url = server + "checkAdvancePaymentTime.action";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();

		return sendPost(url, paramList, request);
	}
	
	// gmlee. - 2016.09.12
	public JSONObject enquiryOddLot(HttpServletRequest request) throws Exception {
		String url = server + "enquiryOddLot.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvLastAction", request.getParameter("mvLastAction")));
		paramList.add(new BasicNameValuePair("mvChildLastAction", request.getParameter("mvChildLastAction")));
		
		return sendPost(url, paramList, request);
	}
		
	// gmlee. - 2016.09.12
	public JSONObject oddLotHistoryEnquiry(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
		long   tt  = nTime.getTime();
		String url = server + "oddLotHistoryEnquiry.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvLastAction", request.getParameter("mvLastAction")));
		paramList.add(new BasicNameValuePair("mvChildLastAction", request.getParameter("mvChildLastAction")));
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		paramList.add(new BasicNameValuePair("_dc", String.valueOf(tt)));
		paramList.add(new BasicNameValuePair("start", "0"));

		if(request.getParameter("limit") != null){
			paramList.add(new BasicNameValuePair("limit", request.getParameter("limit")));
		} else {
			paramList.add(new BasicNameValuePair("limit", "100"));
		}
	
		if(request.getParameter("page") != null){
			paramList.add(new BasicNameValuePair("page", request.getParameter("page")));
		} else {
			paramList.add(new BasicNameValuePair("page", "1"));
		}
		
		return sendPost(url, paramList, request);
	}
	
	// jdchoi. - 2016.09.19
	public JSONObject genfundtransfer(HttpServletRequest request) throws Exception {
		String url = server + "genfundtransfer.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvLastAction", "OTHERSERVICES"));
		paramList.add(new BasicNameValuePair("mvChildLastAction", "FUNDTRANSFER"));
		
		return sendPost(url, paramList, request);
	}
	
	// jdchoi. - 2016.09.19
	public JSONObject hksCashTransactionHistory(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
	    long   tt  = nTime.getTime();
		String url = server + "hksCashTransactionHistory.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvLastAction", "OTHERSERVICES"));
		paramList.add(new BasicNameValuePair("mvChildLastAction", "FUNDTRANSFER"));
		paramList.add(new BasicNameValuePair("tradeType", "FUND"));
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		paramList.add(new BasicNameValuePair("_dc", String.valueOf(tt)));
		
		if(request.getParameter("start") != null){
			paramList.add(new BasicNameValuePair("start", request.getParameter("start")));
		} else {
			paramList.add(new BasicNameValuePair("start", "0"));
		}
	
		if(request.getParameter("limit") != null){
			paramList.add(new BasicNameValuePair("limit", request.getParameter("limit")));
		} else {
			paramList.add(new BasicNameValuePair("limit", "15"));
		}
	
		if(request.getParameter("page") != null){
			paramList.add(new BasicNameValuePair("page", request.getParameter("page")));
		} else {
			paramList.add(new BasicNameValuePair("page", "1"));
		}
		
		return sendPost(url, paramList, request);
	}
	
	// jdchoi. - 2016.09.19
	public JSONObject dofundtransfer(HttpServletRequest request) throws Exception {
		String url = server + "dofundtransfer.action";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvBankId", request.getParameter("mvBankId")));
		paramList.add(new BasicNameValuePair("mvDestClientID", request.getParameter("mvDestClientID")));
		paramList.add(new BasicNameValuePair("mvDestBankID", request.getParameter("mvDestBankID")));
		paramList.add(new BasicNameValuePair("inputBankName", request.getParameter("inputBankName")));
		paramList.add(new BasicNameValuePair("inputBankBranch", request.getParameter("inputBankBranch")));
		paramList.add(new BasicNameValuePair("mvDestAccountName", request.getParameter("mvDestAccountName")));
		paramList.add(new BasicNameValuePair("mvAmount", request.getParameter("mvAmount")));
		paramList.add(new BasicNameValuePair("mvTransferType", request.getParameter("mvTransferType")));
		paramList.add(new BasicNameValuePair("mvRemark", request.getParameter("mvRemark")));
		paramList.add(new BasicNameValuePair("mvSeriNo", request.getParameter("mvSeriNo")));
		paramList.add(new BasicNameValuePair("mvAnswer", request.getParameter("mvAnswer")));
		paramList.add(new BasicNameValuePair("mvSaveAuthenticate", request.getParameter("mvSaveAuthenticate")));
		paramList.add(new BasicNameValuePair("mvPersonCharged", request.getParameter("mvPersonCharged")));
		paramList.add(new BasicNameValuePair("mvWithdrawAmt", request.getParameter("mvWithdrawAmt")));
		paramList.add(new BasicNameValuePair("mvAvaiableAmt", request.getParameter("mvAvaiableAmt")));
		paramList.add(new BasicNameValuePair("mvTransferFee", request.getParameter("mvTransferFee")));
		
		return sendPost(url, paramList, request);
	}
	
	// jdchoi. - 2016.09.19
	public JSONObject cancelFundTransfer(HttpServletRequest request) throws Exception {
		String url = server + "cancelFundTransfer.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvTranID", request.getParameter("mvTranID")));
		paramList.add(new BasicNameValuePair("mvStatus", request.getParameter("mvStatus")));
		
		return sendPost(url, paramList, request);
	}
	
	// jdchoi. - 2016.09.20
	public JSONObject checkFundTransferTime(HttpServletRequest request) throws Exception {
		String url = server + "checkFundTransferTime.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		
		return sendPost(url, paramList, request);
	}
	
	// jdchoi. - 2016.09.21
	public JSONObject queryCashTranHistory(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
	    long   tt  = nTime.getTime();
		String url = server + "queryCashTranHistory.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvLastAction", "CASHTRANSACTIONHISTORY"));
		paramList.add(new BasicNameValuePair("tradeType", request.getParameter("tradeType")));
		paramList.add(new BasicNameValuePair("mvStartDate", request.getParameter("mvStartDate")));
		paramList.add(new BasicNameValuePair("mvEndDate", request.getParameter("mvEndDate")));
		paramList.add(new BasicNameValuePair("_dc", String.valueOf(tt)));
		
		if(request.getParameter("start") != null){
			paramList.add(new BasicNameValuePair("start", request.getParameter("start")));
		} else {
			paramList.add(new BasicNameValuePair("start", "0"));
		}
	
		if(request.getParameter("limit") != null){
			paramList.add(new BasicNameValuePair("limit", request.getParameter("limit")));
		} else {
			paramList.add(new BasicNameValuePair("limit", "15"));
		}
	
		if(request.getParameter("page") != null){
			paramList.add(new BasicNameValuePair("page", request.getParameter("page")));
		} else {
			paramList.add(new BasicNameValuePair("page", "1"));
		}
		
		return sendPost(url, paramList, request);
	}
	
	// jdchoi. - 2016.09.21
	public JSONObject queryCashTranHisReport(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
		long   tt  = nTime.getTime();
		String url = server + "queryCashTranHisReport.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvLastAction", "CASHTRANSACTIONHISTORYREPORT"));
		paramList.add(new BasicNameValuePair("timePeriod", "Customize"));
		paramList.add(new BasicNameValuePair("mvStartDate", request.getParameter("mvStartDate")));
		paramList.add(new BasicNameValuePair("mvEndDate", request.getParameter("mvEndDate")));
		paramList.add(new BasicNameValuePair("_dc", String.valueOf(tt)));
		
		if(request.getParameter("start") != null){
			paramList.add(new BasicNameValuePair("start", request.getParameter("start")));
		} else {
			paramList.add(new BasicNameValuePair("start", "0"));
		}
		
		if(request.getParameter("limit") != null){
			paramList.add(new BasicNameValuePair("limit", request.getParameter("limit")));
		} else {
			paramList.add(new BasicNameValuePair("limit", "15"));
		}
		
		if(request.getParameter("page") != null){
			paramList.add(new BasicNameValuePair("page", request.getParameter("page")));
		} else {
			paramList.add(new BasicNameValuePair("page", "1"));
		}
		
		return sendPost(url, paramList, request);
	}
	
	// jdchoi. - 2016.09.21
	public JSONObject hksStockTransactionHistory(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
		long   tt  = nTime.getTime();
		String url = server + "hksStockTransactionHistory.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvLastAction", "ACCOUNT"));
		paramList.add(new BasicNameValuePair("mvChildLastAction", "TRANSACTIONHISTORY"));
		paramList.add(new BasicNameValuePair("timePeriod", "Customize"));
		paramList.add(new BasicNameValuePair("mvStartDate", request.getParameter("mvStartDate")));
		paramList.add(new BasicNameValuePair("mvEndDate", request.getParameter("mvEndDate")));
		paramList.add(new BasicNameValuePair("_dc", String.valueOf(tt)));
		
		if(request.getParameter("start") != null){
			paramList.add(new BasicNameValuePair("start", request.getParameter("start")));
		} else {
			paramList.add(new BasicNameValuePair("start", "0"));
		}
		
		if(request.getParameter("limit") != null){
			paramList.add(new BasicNameValuePair("limit", request.getParameter("limit")));
		} else {
			paramList.add(new BasicNameValuePair("limit", "15"));
		}
		
		if(request.getParameter("page") != null){
			paramList.add(new BasicNameValuePair("page", request.getParameter("page")));
		} else {
			paramList.add(new BasicNameValuePair("page", "1"));
		}
		
		return sendPost(url, paramList, request);
	}
	
	// gunmin. - 2016.09.21
	public JSONObject marginLoan(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
		long   tt  = nTime.getTime();
		String url = server + "marginLoan.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvLastAction", request.getParameter("mvLastAction")));
		paramList.add(new BasicNameValuePair("mvChildLastAction", request.getParameter("mvChildLastAction")));
		paramList.add(new BasicNameValuePair("timePeriod", request.getParameter("timePeriod")));
		paramList.add(new BasicNameValuePair("mvStartDate", request.getParameter("mvStartDate")));
		paramList.add(new BasicNameValuePair("mvEndDate", request.getParameter("mvEndDate")));
		paramList.add(new BasicNameValuePair("_dc", String.valueOf(tt)));
		
		if(request.getParameter("start") != null){
			paramList.add(new BasicNameValuePair("start", request.getParameter("start")));
		} else {
			paramList.add(new BasicNameValuePair("start", "0"));
		}
		
		if(request.getParameter("limit") != null){
			paramList.add(new BasicNameValuePair("limit", request.getParameter("limit")));
		} else {
			paramList.add(new BasicNameValuePair("limit", "15"));
		}
		
		if(request.getParameter("page") != null){
			paramList.add(new BasicNameValuePair("page", request.getParameter("page")));
		} else {
			paramList.add(new BasicNameValuePair("page", "1"));
		}
		
		return sendPost(url, paramList, request);
	}
	
	// gunmin. - 2016.09.23
	//getEntitlementStockList
	public JSONObject getEntitlementStockList(HttpServletRequest request) throws Exception {
		String url = server + "getEntitlementStockList.action";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		
		paramList.add(new BasicNameValuePair("mvLastAction", request.getParameter("mvLastAction")));
		paramList.add(new BasicNameValuePair("mvChildLastAction", request.getParameter("mvChildLastAction")));
		
		return sendPost(url, paramList, request);
	}
	
	// gunmin. - 2016.09.23
	//getAllRightList
	public JSONObject getAllRightList(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
		long   tt  = nTime.getTime();
		String url = server + "getAllRightList.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();

		paramList.add(new BasicNameValuePair("mvActionType", request.getParameter("mvActionType")));
		paramList.add(new BasicNameValuePair("mvStockId", request.getParameter("mvStockId")));
		paramList.add(new BasicNameValuePair("mvStartDate", request.getParameter("mvStartDate")));
		paramList.add(new BasicNameValuePair("mvEndDate", request.getParameter("mvEndDate")));
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		paramList.add(new BasicNameValuePair("_dc", String.valueOf(tt)));
		
		if(request.getParameter("start") != null){
			paramList.add(new BasicNameValuePair("start", request.getParameter("start")));
		} else {
			paramList.add(new BasicNameValuePair("start", "0"));
		}
		
		if(request.getParameter("limit") != null){
			paramList.add(new BasicNameValuePair("limit", request.getParameter("limit")));
		} else {
			paramList.add(new BasicNameValuePair("limit", "15"));
		}
		
		if(request.getParameter("page") != null){
			paramList.add(new BasicNameValuePair("page", request.getParameter("page")));
		} else {
			paramList.add(new BasicNameValuePair("page", "1"));
		}
		
		return sendPost(url, paramList, request);
	}
	
	// gunmin. - 2016.09.23
	//getAdditionIssueShareInfo 
	public JSONObject getAdditionIssueShareInfo(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
		long   tt  = nTime.getTime();
		String url = server + "getAdditionIssueShareInfo.action";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		
		paramList.add(new BasicNameValuePair("mvLastAction", request.getParameter("mvLastAction")));
		paramList.add(new BasicNameValuePair("mvChildLastAction", request.getParameter("mvChildLastAction")));
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		paramList.add(new BasicNameValuePair("_dc", String.valueOf(tt)));

		if(request.getParameter("start") != null){
			paramList.add(new BasicNameValuePair("start", request.getParameter("start")));
		} else {
			paramList.add(new BasicNameValuePair("start", "0"));
		}
		
		if(request.getParameter("limit") != null){
			paramList.add(new BasicNameValuePair("limit", request.getParameter("limit")));
		} else {
			paramList.add(new BasicNameValuePair("limit", "15"));
		}
		
		if(request.getParameter("page") != null){
			paramList.add(new BasicNameValuePair("page", request.getParameter("page")));
		} else {
			paramList.add(new BasicNameValuePair("page", "1"));
		}
		
		return sendPost(url, paramList, request);
	}
	
	// gunmin. - 2016.09.23
	//getEntitlementHistory
	public JSONObject getEntitlementHistory(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
		long   tt  = nTime.getTime();
		String url = server + "getEntitlementHistory.action";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		
		paramList.add(new BasicNameValuePair("mvLastAction", request.getParameter("mvLastAction")));
		paramList.add(new BasicNameValuePair("mvChildLastAction", request.getParameter("mvChildLastAction")));
		paramList.add(new BasicNameValuePair("mvStockId", request.getParameter("mvStockId")));
		paramList.add(new BasicNameValuePair("mvStartDate", request.getParameter("mvStartDate")));
		paramList.add(new BasicNameValuePair("mvEndDate", request.getParameter("mvEndDate")));		
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		paramList.add(new BasicNameValuePair("_dc", String.valueOf(tt)));

		if(request.getParameter("start") != null){
			paramList.add(new BasicNameValuePair("start", request.getParameter("start")));
		} else {
			paramList.add(new BasicNameValuePair("start", "0"));
		}
		
		if(request.getParameter("limit") != null){
			paramList.add(new BasicNameValuePair("limit", request.getParameter("limit")));
		} else {
			paramList.add(new BasicNameValuePair("limit", "15"));
		}
		
		if(request.getParameter("page") != null){
			paramList.add(new BasicNameValuePair("page", request.getParameter("page")));
		} else {
			paramList.add(new BasicNameValuePair("page", "1"));
		}

		return sendPost(url, paramList, request);
	}
	
	// jdchoi. - 2016.09.23
	public JSONObject avaiablemarginlist(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
		long   tt  = nTime.getTime();
		String url = server + "avaiablemarginlist.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvLastAction", "AVAIABLEMARGINLIST"));
		paramList.add(new BasicNameValuePair("mvInstrumentID", request.getParameter("mvInstrumentID")));
		paramList.add(new BasicNameValuePair("mvMarketID", request.getParameter("mvMarketID")));
		paramList.add(new BasicNameValuePair("mvLending", request.getParameter("mvLending")));
		paramList.add(new BasicNameValuePair("_dc", String.valueOf(tt)));
		
		if(request.getParameter("start") != null){
			paramList.add(new BasicNameValuePair("start", request.getParameter("start")));
		} else {
			paramList.add(new BasicNameValuePair("start", "0"));
		}
		
		if(request.getParameter("limit") != null){
			paramList.add(new BasicNameValuePair("limit", request.getParameter("limit")));
		} else {
			paramList.add(new BasicNameValuePair("limit", "15"));
		}
		
		if(request.getParameter("page") != null){
			paramList.add(new BasicNameValuePair("page", request.getParameter("page")));
		} else {
			paramList.add(new BasicNameValuePair("page", "1"));
		}
		
		return sendPost(url, paramList, request);
	}
	
	// gunmin. - 2016.09.23
	public JSONObject queryBankInfo(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
		long   tt  = nTime.getTime();
		String url = server + "queryBankInfo.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();

		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		
		return sendPost(url, paramList, request);
	}
	
	//getAnnouncement
	// gunmin. - 2016.09.28
	public JSONObject getAnnouncement(HttpServletRequest request) throws Exception {
		String url = server + "getAnnouncement.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		
		return sendPost(url, paramList, request);
	}
	
	// gunmin. - 2016.09.28
	public JSONObject getLocalLoanRefundCreation(HttpServletRequest request) throws Exception {
		String url = server + "getLocalLoanRefundCreation.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		
		paramList.add(new BasicNameValuePair("mvLastAction", "OTHERSERVICES"));
		paramList.add(new BasicNameValuePair("mvChildLastAction", "LOANREFUND"));
		
		return sendPost(url, paramList, request);
	}
	
	// gunmin. - 2016.09.28
	public JSONObject getLoanRefundData(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
		long   tt  = nTime.getTime();
		String url = server + "getLoanRefundData.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		
		paramList.add(new BasicNameValuePair("mvLastAction", request.getParameter("mvLastAction")));
		paramList.add(new BasicNameValuePair("mvChildLastAction", request.getParameter("mvChildLastAction")));
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		paramList.add(new BasicNameValuePair("_dc", String.valueOf(tt)));
		
		if(request.getParameter("start") != null){
			paramList.add(new BasicNameValuePair("start", request.getParameter("start")));
		} else {
			paramList.add(new BasicNameValuePair("start", "0"));
		}
		
		if(request.getParameter("limit") != null){
			paramList.add(new BasicNameValuePair("limit", request.getParameter("limit")));
		} else {
			paramList.add(new BasicNameValuePair("limit", "15"));
		}
		
		if(request.getParameter("page") != null){
			paramList.add(new BasicNameValuePair("page", request.getParameter("page")));
		} else {
			paramList.add(new BasicNameValuePair("page", "1"));
		}
		
		return sendPost(url, paramList, request);
	}
	
	// gunmin. - 2016.09.28
	public JSONObject getLoanRefundHistory(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
		long   tt  = nTime.getTime();
		String url = server + "getLoanRefundHistory.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		
		paramList.add(new BasicNameValuePair("mvStartDate", request.getParameter("mvStartDate")));
		paramList.add(new BasicNameValuePair("mvEndDate", request.getParameter("mvEndDate")));
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		paramList.add(new BasicNameValuePair("_dc", String.valueOf(tt)));
		
		if(request.getParameter("start") != null){
			paramList.add(new BasicNameValuePair("start", request.getParameter("start")));
		} else {
			paramList.add(new BasicNameValuePair("start", "0"));
		}
		
		if(request.getParameter("limit") != null){
			paramList.add(new BasicNameValuePair("limit", request.getParameter("limit")));
		} else {
			paramList.add(new BasicNameValuePair("limit", "15"));
		}
		
		if(request.getParameter("page") != null){
			paramList.add(new BasicNameValuePair("page", request.getParameter("page")));
		} else {
			paramList.add(new BasicNameValuePair("page", "1"));
		}
		
		return sendPost(url, paramList, request);
	}
	
	//checkLoanRefundTime
	// gunmin. - 2016.09.30
	public JSONObject checkLoanRefundTime(HttpServletRequest request) throws Exception {
		String url = server + "checkLoanRefundTime.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		
		return sendPost(url, paramList, request);
	}
	
	
	//submitLoanRefundCreation
	// gunmin. - 2016.09.30
	public JSONObject submitLoanRefundCreation(HttpServletRequest request) throws Exception {
		Date nTime = new Date();
		long   tt  = nTime.getTime();
		String url = server + "submitLoanRefundCreation.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		
		paramList.add(new BasicNameValuePair("lvLoanRem", request.getParameter("lvLoanRem")));
		paramList.add(new BasicNameValuePair("lvLoanCur", request.getParameter("lvLoanCur")));
		paramList.add(new BasicNameValuePair("lvLoanPay", request.getParameter("lvLoanPay")));
		paramList.add(new BasicNameValuePair("lvAmount",  request.getParameter("lvAmount")));
		paramList.add(new BasicNameValuePair("lvRemark", request.getParameter("lvRemark")));
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		
		return sendPost(url, paramList, request);
	}
	
	// jdchoi. - 2016.10.05
	public JSONObject changepassword(HttpServletRequest request) throws Exception {
		String url = server + "changepassword.action";
		
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("oldPassword", request.getParameter("oldPassword")));
		paramList.add(new BasicNameValuePair("password", request.getParameter("password")));
		paramList.add(new BasicNameValuePair("mvSeriNo", request.getParameter("mvSeriNo")));
		paramList.add(new BasicNameValuePair("mvAnswer",  request.getParameter("mvAnswer")));
		paramList.add(new BasicNameValuePair("mvSaveAuthenticate", request.getParameter("mvSaveAuthenticate")));
		
		return sendPost(url, paramList, request);
	}
}
