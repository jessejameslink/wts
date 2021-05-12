package com.vn.app.webmain.oraweb.home.web;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.binary.Base64;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.vn.app.commons.VNSend;
import com.vn.app.commons.util.ItemCode;
import com.vn.app.webmain.oranews.home.service.HomeService2;
import com.vn.app.webmain.oraweb.home.service.HomeService;
import com.vn.app.webmain.oraweb.home.service.ItemService;
import com.vn.app.webmain.oraweb.home.service.ItemVO;
import com.vn.app.webmain.oraweb.home.service.MiraeAssetNewsService;
import com.vn.app.webmain.oraweb.home.service.MiraeAssetNewsVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

import m.action.TRExecuter;
import m.common.tool.tool;
import m.config.SystemConfig;
import m.web.common.WebInterface;
import m.web.common.WebParam;
//import net.sf.json.JSONObject;

@Controller
public class TradingController {
	
	private static final Logger logger = LoggerFactory.getLogger(TradingController.class);
	/*
	@Value("#{prop['SYSTEM.USER.AGENT']}") private String USER_AGENT;
	@Value("#{prop['SYSTEM.TTL.SERVER.IP']}") private String host;
	@Value("#{prop['SYSTEM.TTL.SERVER']}") private String server;
	@Value("#{prop['SYSTEM.RTS.SERVER.IP']}") private String rtsServer;
	*/
	private String USER_AGENT	=	SystemConfig.get("SYSTEM.USER.AGENT");
	private String host			=	SystemConfig.get("SYSTEM.TTL.SERVER.IP");
	private String server		=	SystemConfig.get("SYSTEM.TTL.SERVER");
	private String rtsServer	=	SystemConfig.get("SYSTEM.RTS.SERVER.IP");
	//private String rtsServer2	=	SystemConfig.get("SYSTEM.RTS.SERVER.IP2");
	
	@Resource(name="homeServiceImpl")
	private HomeService homeService;
	
	@Resource(name="homeServiceImpl2")
	private HomeService2 homeService2;
	
	@Resource(name="miraeAssetNewsServiceImpl")
	private MiraeAssetNewsService miraeAssetNewsService;
	
	@Resource(name="itemServiceImpl")
	private ItemService itemService;
	
	
	public String JSESSIONID = "";
//	private HttpClient httpClient;
	
	public String getSession(){
		return this.JSESSIONID;
	}
	
	public void setSession(String JSESSIONID){
		this.JSESSIONID = JSESSIONID;
	}
	
	public void setplusSession(String JSESSIONID){
		this.JSESSIONID += JSESSIONID;
	}
	
	private static final String[] IP_HEADER_CANDIDATES = { 
		    "X-Forwarded-For",
		    "Proxy-Client-IP",
		    "WL-Proxy-Client-IP",
		    "HTTP_X_FORWARDED_FOR",
		    "HTTP_X_FORWARDED",
		    "HTTP_X_CLUSTER_CLIENT_IP",
		    "HTTP_CLIENT_IP",
		    "HTTP_FORWARDED_FOR",
		    "HTTP_FORWARDED",
		    "HTTP_VIA",
		    "REMOTE_ADDR" };
	
	public String getClientIpAddr(HttpServletRequest request) {  
		for (String header : IP_HEADER_CANDIDATES) {
	        String ip = request.getHeader(header);
	        if (ip != null && ip.length() != 0 && !"unknown".equalsIgnoreCase(ip)) {
	            return ip;
	        }
	    }
	    return request.getRemoteAddr();  
	}
	
	@RequestMapping(value = "/trading/tradingMain.do", method = RequestMethod.GET)
	public String Trading(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		return "Trading";
	}
	//sdfwefwef
	@RequestMapping(value = "/tr/trCall.do", method = RequestMethod.GET)
	public String TrCall(Locale locale, Model model) {
		logger.info("TrCall Debug Code {}.", locale);
		return "/trCall";
	}
	
	/*
	 * @Description : 
	 * @Create By 	: Temi
	 * @Create Date : 2016/08/22
	 */
	@RequestMapping(value = "/wts/view/trading.do", method = RequestMethod.GET)
	public String TradingView(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		//SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat sdf = new SimpleDateFormat("ddMMyyyy");
		Calendar c1 = Calendar.getInstance();
		String strToday = sdf.format(c1.getTime());
		model.addAttribute("chkDate", strToday);
		model.addAttribute("rtsServer", rtsServer);
		//model.addAttribute("rtsServer2", rtsServer2);
		model.addAttribute("TAB_INFO", "TRD_TAB" );
		return "/trading/trading";
	}
	
	@RequestMapping(value = "/trading/view/watchlst.do", method = RequestMethod.GET)
	public String WatchList(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/watchlst";
	}
	
	@RequestMapping(value = "/trading/popup/watchListGroup.do", method = RequestMethod.POST)
	public ModelAndView WatchListGroupPop(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		Map<String, String> map = new HashMap<String, String>();
		map.put("watUsid", req.getParameter("watUsid"));
		map.put("divId", req.getParameter("divId"));
		map.put("grpId", req.getParameter("grpId"));
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("formData", map);
		mav.setViewName("/popup/watchListGroup");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/view/sector.do", method = RequestMethod.GET)
	public String Sector(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/sector";
	}
	
	@RequestMapping(value = "/trading/view/ranking.do", method = RequestMethod.GET)
	public String Ranking(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/ranking";
	}
	
	@RequestMapping(value = "/trading/view/highlow.do", method = RequestMethod.GET)
	public String Highlow(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/highlow";
	}
	
	@RequestMapping(value = "/trading/view/recommendlist.do", method = RequestMethod.GET)
	public String Recommendlist(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/recommendlist";
	}
	
	@RequestMapping(value = "/trading/view/foreignerbuysell.do", method = RequestMethod.GET)
	public String Foreignerbuysell(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/foreignerbuysell";
	}
	
	@RequestMapping(value = "/trading/view/newlisted.do", method = RequestMethod.GET)
	public String Newlisted(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/newlisted";
	}
	
	@RequestMapping(value = "/trading/view/sectorlist.do", method = RequestMethod.GET)
	public String Sectorlist(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/sectorlist";
	}
	
	/*
	 * @Description : Trading Tab BID(Current Stock Price) View
	 * @Create By 	: Temi
	 * @Create Date : 2016/08/19
	 */
	@RequestMapping(value = "/trading/view/bid.do", method = RequestMethod.GET)
	public String Bid(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/bid";
	}
	
	@RequestMapping(value = "/trading/view/info.do", method = RequestMethod.GET)
	public String info(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/info";
	}
	
	@RequestMapping(value = "/trading/view/enterorder.do", method = RequestMethod.GET)
	public String EnterOrder(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/enterorder";
	}
	
	@RequestMapping(value = "/trading/view/entersell.do", method = RequestMethod.GET)
	public String EnterSell(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/entersell";
	}
	
	@RequestMapping(value = "/trading/popup/orderConfirmPL.do", method = RequestMethod.POST)
	public ModelAndView OrderConfirmPL(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		logger.info("refId==========================" + req.getParameter("refIdPL"));
		Map<String, String> map = new HashMap<String, String>();
		map.put("mvInstrument", req.getParameter("mvInstrumentPL"));
		map.put("mvStockName", req.getParameter("mvStockNamePL"));
		map.put("mvMarketId", req.getParameter("mvMarketIdPL"));
		map.put("mvMarketIdList", req.getParameter("mvMarketIdListPL"));
		map.put("mvEnableGetStockInfo", req.getParameter("mvEnableGetStockInfoPL"));
		map.put("mvAction", req.getParameter("mvActionPL"));
		map.put("mvTemporaryFee", req.getParameter("mvTemporaryFeePL"));
		map.put("maxMargin", req.getParameter("maxMarginPL"));
		map.put("lending", req.getParameter("lendingPL"));
		map.put("value", req.getParameter("valuePL"));
		map.put("netFee", req.getParameter("netFeePL"));
		map.put("mvBankID", req.getParameter("mvBankIDPL"));
		map.put("mvBankACID", req.getParameter("mvBankACIDPL"));
		map.put("stock", req.getParameter("stockPL"));
		map.put("orderType", req.getParameter("orderTypePL"));
		map.put("orderTypeNm", req.getParameter("orderTypeNmPL"));
		map.put("buySell", req.getParameter("buySellPL"));
		map.put("volume", req.getParameter("volumePL"));
		map.put("volumeView", req.getParameter("volumeViewPL"));
		map.put("price", req.getParameter("pricePL"));
		map.put("buyingPower", req.getParameter("buyingPowerPL"));
		map.put("chkExpiry", (req.getParameter("chkExpiryPL") == null ? "off" : req.getParameter("chkExpiryPL")));
		map.put("expiryDate", req.getParameter("expiryDtPL"));
		map.put("chkAdvanced", req.getParameter("chkAdvanced"));
		map.put("advancedDate", req.getParameter("advancedDtPL"));
		map.put("refId", req.getParameter("refIdPL"));
		map.put("divId", req.getParameter("divIdPL"));
		
		map.put("mvStop", req.getParameter("mvStopPL"));
		map.put("mvStopType", req.getParameter("mvStopTypePL"));
		map.put("mvStopPrice", req.getParameter("mvStopPricePL"));
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("formData", map);
		mav.addObject("buySell", ("B".equals(req.getParameter("buySellPL")) ? "buy" : "sell"));
		mav.setViewName("/popup/orderConfirm");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/popup/orderConfirmP.do", method = RequestMethod.POST)
	public ModelAndView OrderConfirmP(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		logger.info("refId==========================" + req.getParameter("refId"));
		Map<String, String> map = new HashMap<String, String>();
		map.put("mvInstrument", req.getParameter("mvInstrument"));
		map.put("mvStockName", req.getParameter("mvStockName"));
		map.put("mvMarketId", req.getParameter("mvMarketId"));
		map.put("mvMarketIdList", req.getParameter("mvMarketIdList"));
		map.put("mvEnableGetStockInfo", req.getParameter("mvEnableGetStockInfo"));
		map.put("mvAction", req.getParameter("mvAction"));
		map.put("mvTemporaryFee", req.getParameter("mvTemporaryFee"));
		map.put("maxMargin", req.getParameter("maxMargin"));
		map.put("lending", req.getParameter("lending"));
		map.put("value", req.getParameter("value"));
		map.put("netFee", req.getParameter("netFee"));
		map.put("mvBankID", req.getParameter("mvBankID"));
		map.put("mvBankACID", req.getParameter("mvBankACID"));
		map.put("stock", req.getParameter("stock"));
		map.put("orderType", req.getParameter("orderType"));
		map.put("orderTypeNm", req.getParameter("orderTypeNm"));
		map.put("buySell", req.getParameter("buySell"));
		map.put("volume", req.getParameter("volume"));
		map.put("volumeView", req.getParameter("volumeView"));
		map.put("price", req.getParameter("price"));
		map.put("buyingPower", req.getParameter("buyingPower"));
		map.put("chkExpiry", (req.getParameter("chkExpiry") == null ? "off" : req.getParameter("chkExpiry")));
		map.put("expiryDate", req.getParameter("expiryDt"));
		map.put("chkAdvanced", req.getParameter("chkAdvanced"));
		map.put("advancedDate", req.getParameter("advancedDt"));
		map.put("refId", req.getParameter("refId"));
		map.put("divId", req.getParameter("divId"));
		
		map.put("mvStop", req.getParameter("mvStop"));
		map.put("mvStopType", req.getParameter("mvStopType"));
		map.put("mvStopPrice", req.getParameter("mvStopPrice"));
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("formData", map);
		mav.addObject("buySell", ("B".equals(req.getParameter("buySell")) ? "buy" : "sell"));
		mav.setViewName("/popup/orderConfirm");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/popup/orderConfirm.do", method = RequestMethod.POST)
	public ModelAndView OrderConfirm(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		logger.info("refId==========================" + req.getParameter("refIdB"));
		Map<String, String> map = new HashMap<String, String>();
		map.put("mvInstrument", req.getParameter("mvInstrumentB"));
		map.put("mvStockName", req.getParameter("mvStockNameB"));
		map.put("mvMarketId", req.getParameter("mvMarketIdB"));
		map.put("mvMarketIdList", req.getParameter("mvMarketIdListB"));
		map.put("mvEnableGetStockInfo", req.getParameter("mvEnableGetStockInfoB"));
		map.put("mvAction", req.getParameter("mvActionB"));
		map.put("mvTemporaryFee", req.getParameter("mvTemporaryFeeB"));
		map.put("maxMargin", req.getParameter("maxMarginB"));
		map.put("lending", req.getParameter("lendingB"));
		map.put("value", req.getParameter("valueB"));
		map.put("netFee", req.getParameter("netFeeB"));
		map.put("mvBankID", req.getParameter("mvBankIDB"));
		map.put("mvBankACID", req.getParameter("mvBankACIDB"));
		map.put("stock", req.getParameter("stockB"));
		map.put("orderType", req.getParameter("orderTypeB"));
		map.put("orderTypeNm", req.getParameter("orderTypeNmB"));
		map.put("buySell", req.getParameter("buySellB"));
		map.put("volume", req.getParameter("volumeB"));
		map.put("volumeView", req.getParameter("volumeViewB"));
		map.put("price", req.getParameter("priceB"));
		map.put("buyingPower", req.getParameter("buyingPowerB"));
		map.put("chkExpiry", (req.getParameter("chkExpiryB") == null ? "off" : req.getParameter("chkExpiryB")));
		map.put("expiryDate", req.getParameter("expiryDtB"));
		map.put("chkAdvanced", req.getParameter("chkAdvanced"));
		map.put("advancedDate", req.getParameter("advancedDtB"));
		map.put("refId", req.getParameter("refIdB"));
		map.put("divId", req.getParameter("divIdB"));
		
		map.put("mvStop", req.getParameter("mvStopB"));
		map.put("mvStopType", req.getParameter("mvStopTypeB"));
		map.put("mvStopPrice", req.getParameter("mvStopPriceB"));
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("formData", map);
		mav.addObject("buySell", ("B".equals(req.getParameter("buySellB")) ? "buy" : "sell"));
		mav.setViewName("/popup/orderConfirm");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/popup/sellConfirm.do", method = RequestMethod.POST)
	public ModelAndView SellConfirm(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		logger.info("refId==========================" + req.getParameter("refIdS"));
		Map<String, String> map = new HashMap<String, String>();
		map.put("mvInstrument", req.getParameter("mvInstrumentS"));
		map.put("mvStockName", req.getParameter("mvStockNameS"));
		map.put("mvMarketId", req.getParameter("mvMarketIdS"));
		map.put("mvMarketIdList", req.getParameter("mvMarketIdListS"));
		map.put("mvEnableGetStockInfo", req.getParameter("mvEnableGetStockInfoS"));
		map.put("mvAction", req.getParameter("mvActionS"));
		map.put("mvTemporaryFee", req.getParameter("mvTemporaryFeeS"));
		map.put("maxMargin", req.getParameter("maxMarginS"));
		map.put("lending", req.getParameter("lendingS"));
		map.put("value", req.getParameter("valueS"));
		map.put("netFee", req.getParameter("netFeeS"));
		map.put("mvBankID", req.getParameter("mvBankIDS"));
		map.put("mvBankACID", req.getParameter("mvBankACIDS"));
		map.put("stock", req.getParameter("stockS"));
		map.put("orderType", req.getParameter("orderTypeS"));
		map.put("orderTypeNm", req.getParameter("orderTypeNmS"));
		map.put("buySell", req.getParameter("buySellS"));
		map.put("volume", req.getParameter("volumeS"));
		map.put("volumeView", req.getParameter("volumeViewS"));
		map.put("price", req.getParameter("priceS"));
		map.put("buyingPower", req.getParameter("buyingPowerS"));
		map.put("chkExpiry", (req.getParameter("chkExpiryS") == null ? "off" : req.getParameter("chkExpiryS")));
		map.put("expiryDate", req.getParameter("expiryDtS"));
		map.put("chkAdvanced", req.getParameter("chkAdvanced"));
		map.put("advancedDate", req.getParameter("advancedDtS"));
		map.put("refId", req.getParameter("refIdS"));
		map.put("divId", req.getParameter("divIdS"));
		
		map.put("mvStop", req.getParameter("mvStopS"));
		map.put("mvStopType", req.getParameter("mvStopTypeS"));
		map.put("mvStopPrice", req.getParameter("mvStopPriceS"));
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("formData", map);
		mav.addObject("buySell", ("B".equals(req.getParameter("buySellS")) ? "buy" : "sell"));
		mav.setViewName("/popup/sellConfirm");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/popup/forgetPassword.do", method = RequestMethod.POST)
	public ModelAndView ForgetPassword(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		ModelAndView mav = new ModelAndView();
		mav.addObject("newsDivId", req.getParameter("divId"));
		mav.setViewName("/popup/forgetPassword");		
		return mav;
	}
	
	@RequestMapping(value = "/trading/view/orderjournal.do", method = RequestMethod.GET)
	public String OrderJournal(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/orderjournal";
	}
	
	@RequestMapping(value = "/trading/popup/cancelModifyConfirm.do", method = RequestMethod.POST)
	public String CancelModifyConfirm(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/popup/cancelModifyConfirm";
	}
	
	@RequestMapping(value = "/trading/popup/multiCancelConfirm.do", method = RequestMethod.POST)
	public String MultiCancelConfirm(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/popup/multiCancelConfirm";
	}
	
	@RequestMapping(value = "/trading/popup/accountSummary.do", method = RequestMethod.POST)
	public String AccountSummary(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/popup/accountSummary";
	}
	
	@RequestMapping(value = "/trading/view/balance.do", method = RequestMethod.GET)
	public String Balance(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/balance";
	}
	
	@RequestMapping(value = "/trading/view/chart.do", method = RequestMethod.GET)
	public ModelAndView Chart(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		ModelAndView mav = new ModelAndView();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		Calendar c1 = Calendar.getInstance();
		String strToday = sdf.format(c1.getTime());
		mav.addObject("curDate", strToday);
		mav.setViewName("/trading/chart");
		return mav;
	}
	
	@RequestMapping(value = "/trading/view/daily.do", method = RequestMethod.GET)
	public String Daily(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/daily";
	}
	
	@RequestMapping(value = "/trading/view/timely.do", method = RequestMethod.GET)
	public String Timely(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/timely";
	}
	
	@RequestMapping(value = "/trading/view/stocknews.do", method = RequestMethod.GET)
	public String StockNews(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/stocknews";
	}
	
	@RequestMapping(value = "/trading/popup/newsDetail.do", method = RequestMethod.POST)
	public ModelAndView newsDetailPop(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		ModelAndView mav = new ModelAndView();
		mav.addObject("newsSeqn", req.getParameter("seqn"));
		mav.addObject("newsDivId", req.getParameter("divId"));
		mav.setViewName("/popup/newsDetail");
		
		return mav;
	}
	
	/* @Start
	 * @Description : Add Market Index
	 * @Create By 	: SinhNH
	 * @Create Date : 2017/07/26
	 */
	@RequestMapping(value = "/trading/popup/marketIndex.do", method = RequestMethod.POST)
	public ModelAndView marketIndexPop(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		ModelAndView mav = new ModelAndView();
		mav.addObject("marketIndexDivId", req.getParameter("divId"));
		mav.setViewName("/popup/marketIndex");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getVnIndex.do", method = RequestMethod.GET)
	public ModelAndView getVnIndex(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "piboidmk").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("vnIndexList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getForIndex.do", method = RequestMethod.GET)
	public ModelAndView getForIndex(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibofidm").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("forIndexList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getVnDaily.do", method = RequestMethod.GET)
	public ModelAndView getVnDaily(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "piboiday").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("vnDailyList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getForDaily.do", method = RequestMethod.GET)
	public ModelAndView getForDaily(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibofday").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("forDailyList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	/* @End */
	
	/*
	 * @Description : Get Current Data
	 * @Create By 	: Temi
	 * @Create Date : 2016/08/19
	 */
	@RequestMapping(value = "/trading/data/getBid.do", method = RequestMethod.GET)
	public ModelAndView CurrentStock(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		res.setCharacterEncoding("utf-8");
		res.setHeader("Content-Type", "text/html; charset=utf-8");
		WebInterface webInterface	=	new WebParam(req, res);
		JSONObject outputResult1		=	new JSONObject();
		JSONObject outputResult2		=	new JSONObject();
		JSONObject outputResult3		=	new JSONObject();
		
		
		ModelAndView mav = new ModelAndView();
		try {
			outputResult1	=	 new TRExecuter(webInterface, "pibotprc").execute();
			outputResult2	=	 new TRExecuter(webInterface, "pibocurr").execute();
			outputResult3	=	 new TRExecuter(webInterface, "pibodvdt").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		//System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
		
		//System.out.println(outputResult2);
		//System.out.println("#############################################");
		
		//System.out.println("##############CHK THE NAME###############");
		//System.out.print(outputResult2.toJSONString().getBytes("utf-8"));
		//System.out.print(outputResult2.toJSONString().getBytes("utf-8").toString());
		//String strJson = new String(outputResult2.toJSONString().getBytes("UTF-8"));
		//System.out.println(strJson);
		//System.out.println(outputResult2.get("snam"));
				
		//String	snam	=	new String(outputResult2.get("snam").toString().getBytes("ISO-8859-1"), "utf-8");		
		//System.out.println("#########################################");
		
		
		mav.addObject("tprc", outputResult1);
		mav.addObject("curr", outputResult2);
		mav.addObject("dvdt", outputResult3);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		return mav;
	}
	
	/*
	 * @Description : Get Current Data
	 * @Create By 	: Temi
	 * @Create Date : 2016/08/19
	 */
	@RequestMapping(value = "/trading/data/getBid10.do", method = RequestMethod.GET)
	public ModelAndView GetBid10(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		res.setCharacterEncoding("utf-8");
		res.setHeader("Content-Type", "text/html; charset=utf-8");
		WebInterface webInterface	=	new WebParam(req, res);
		JSONObject outputResult1		=	new JSONObject();
		JSONObject outputResult2		=	new JSONObject();
		JSONObject outputResult3		=	new JSONObject();
		
		
		ModelAndView mav = new ModelAndView();
		try {
			outputResult1	=	 new TRExecuter(webInterface, "pibotpup").execute();
			outputResult2	=	 new TRExecuter(webInterface, "pibocurr").execute();
			outputResult3	=	 new TRExecuter(webInterface, "pibodvdt").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		mav.addObject("tprc", outputResult1);
		mav.addObject("curr", outputResult2);
		mav.addObject("dvdt", outputResult3);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		return mav;
	}
	
	/*
	 * @Description : Get Current Data
	 * @Create By 	: Temi
	 * @Create Date : 2016/08/19
	 */
	@RequestMapping(value = "/trading/data/getEstimatePrice.do", method = RequestMethod.GET)
	public ModelAndView getEstimatePrice(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		res.setCharacterEncoding("utf-8");
		res.setHeader("Content-Type", "text/html; charset=utf-8");
		WebInterface webInterface	=	new WebParam(req, res);
		JSONObject outputResult		=	new JSONObject();
		
		
		ModelAndView mav = new ModelAndView();
		try {
			outputResult	=	 new TRExecuter(webInterface, "pibocurr").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		mav.addObject("curr", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/trading/view/hobby.do", method = RequestMethod.GET)
	public String Hobby(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/hobby";
	}
	
	/*
	 * @Description : Get hobby Data
	 * @Create By 	: Temi
	 * @Create Date : 2016/08/29
	 */
	@RequestMapping(value = "/trading/data/getHobby.do", method = RequestMethod.GET)
	public ModelAndView HobbyStock(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface	=	new WebParam(req, res);
		JSONObject outputResult1		=	new JSONObject();
		ModelAndView mav = new ModelAndView();
		try {
			outputResult1	=	 new TRExecuter(webInterface, "piho1001").execute();
		} catch(Throwable e) {
			logger.info("~~~~~~~~~~~#ERROR getHobby#~~~~~~~~~~");
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult1.toJSONString());
		
		mav.addObject("tprc", outputResult1);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
	    return mav;
	}
	
	@RequestMapping(value = "/trading/data/getGrpList.do", method = RequestMethod.GET)
	public ModelAndView getGrpList(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			//System.out.println("ê´€ì‹¬ì¢…ëª© ê·¸ë£¹ ë¦¬ìŠ¤íŠ¸ í™•ì�¸1");
			outputResult = new TRExecuter(webInterface, "piho1001").execute();
			//System.out.println("ê´€ì‹¬ì¢…ëª© ê·¸ë£¹ ë¦¬ìŠ¤íŠ¸ í™•ì�¸2");
		} catch(Throwable e) {
			logger.info("~~~~~~~~~~~#ERROR getGrpList#~~~~~~~~~~");
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		
		mav.addObject("grpList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = {"/trading/data/sendNotifycation.do"}, method = {RequestMethod.GET})
	public ModelAndView getNodeJ(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res)
			throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		req.setAttribute("clientId", req.getParameter("mvClientID"));
		req.setAttribute("data", req.getParameter("data"));
		Instant instant = Instant.now();
		long timeStampSeconds = instant.getEpochSecond();
		
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibonmos").execute();
			logger.info("~~~~~~~~~~~#pibonmos#~~~~~~~~~~" + outputResult.toJSONString());
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getNodeJS.do", method = RequestMethod.GET)
	public ModelAndView getNodeJS(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		//logger.info("~~~~~~~~~~~#1 getNodeJS#~~~~~~~~~~" + rtsServer);
		try {
			outputResult = new TRExecuter(webInterface, "pibonode").execute();
			//logger.info("~~~~~~~~~~~#outputResult getNodeJS#~~~~~~~~~~" + outputResult.toJSONString());
			
		} catch(Throwable e) {
			//logger.info("~~~~~~~~~~~#ERROR getNodeJS#~~~~~~~~~~");
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		mav.addObject("nodeJS", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		//logger.info("~~~~~~~~~~~#1 getNodeJS start#~~~~~~~~~~" + rtsServer);
		//logger.info("~~~~~~~~~~~#outputResult getNodeJS#~~~~~~~~~~" + outputResult.get("noden").toString());
		rtsServer = outputResult.get("noden").toString();
		//logger.info("~~~~~~~~~~~#1 getNodeJS end#~~~~~~~~~~" + rtsServer);
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/chamCheck.do", method = RequestMethod.GET)
	public ModelAndView chamCheck(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		req.setAttribute("clientid", req.getParameter("mvClientID"));
		
		Instant instant = Instant.now();
		long timeStampSeconds = instant.getEpochSecond();
		
		String infoCham = "";
		String IDCus = req.getParameter("mvClientID");
		String publickey = "WV37rvI3sEr+gAIOMKZ/jXSQfDbwHNOwYexRXoO7LXcnN7DEY48zZNTCkDewnpvFT82TCqu/7/Nzke9nGmFHgzb3DuyzXHoMA5gce2huRnEsOFZBtzRxcg/4Cy939Rc6vuJ96nHFqs2Yasf9FZIHonEK7ITKKnJwH5ZCzP1q+TuLNl7R7l7EmHwSdRanbsCMUz6jlUh0H4ss4CsuV0OGd0DBXB2QoSA2oZgkeH3p1yvWb9+04p/oxTWezFO4BTMcQgJke5pOONnJG/Sfpz1PbnBeglhh9MVJHXFX6ewTbtgeBe0WEStNIJrT55S2j5IV+SvL8J1R84RncZDzXHAvvg==";
		

		infoCham = infoCham + getMD5(timeStampSeconds + "++" + IDCus);
		infoCham = infoCham + "|" + IDCus + "|" + timeStampSeconds + "|" + publickey;
		
		byte[] encodedBytes = Base64.encodeBase64(infoCham.getBytes());
		infoCham = "" + new String(encodedBytes);
		
		
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "chamchec").execute();
			
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		outputResult.put("infoCham", infoCham);
		
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
		
	}
	
	@RequestMapping(value = "/trading/data/getWatchList.do", method = RequestMethod.GET)
	public ModelAndView getWatchList(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "piho1005").execute();
		} catch(Throwable e) {
			logger.info("~~~~~~~~~~~#ERROR getWatchList#~~~~~~~~~~");
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		
		mav.addObject("watchList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/groupNameSave.do", method = RequestMethod.GET)
	public ModelAndView groupNameSave(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "piho1003").execute();
		} catch(Throwable e) {
			logger.info("~~~~~~~~~~~#ERROR groupNameSave#~~~~~~~~~~");
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		
		mav.addObject("watchList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getMarketStockList.do", method = RequestMethod.GET)
	public ModelAndView getMarketStockList(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		ItemCode itemCode      = new ItemCode();
		JSONArray outputResult = new JSONArray();
		ModelAndView mav       = new ModelAndView();
		String marketId = req.getParameter("marketId");
		String stockCd  = req.getParameter("stockCd").toUpperCase();
		
		try {
			outputResult = itemCode.getMarketItemCode(marketId, stockCd);
		} catch(Throwable e) {
			logger.info("~~~~~~~~~~~#ERROR getMarketStockList#~~~~~~~~~~");
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		
		mav.addObject("stockList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getDailyList.do", method =  {RequestMethod.GET, RequestMethod.POST}, produces={"application/json"})
	@ResponseBody
	public ModelAndView getDailyList(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		//System.out.println("============GET DAILY LIST");
		//System.out.println("###################################################");
		try {
			outputResult = new TRExecuter(webInterface, "pibosday").execute();
			//System.out.println(outputResult);
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("dailyList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getTimelyList.do", method =  {RequestMethod.GET, RequestMethod.POST}, produces={"application/json"})
	@ResponseBody
	public ModelAndView getTimelyList(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibomati").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("timelyList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getStockNewsList.do", method =  {RequestMethod.GET, RequestMethod.POST}, produces={"application/json"})
	@ResponseBody
	public ModelAndView getStockNewsList(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibonews").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("stockNewsList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getNewsDetail.do", method =  {RequestMethod.GET, RequestMethod.POST}, produces={"application/json"})
	@ResponseBody
	public ModelAndView getNewsDetail(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibobody").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("newsDetail", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/getMiraeAssetNewsDetail.do", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView getMiraeAssetNewsDetail(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("Mirae Asset News Detail Load...");
		
		String sid = req.getParameter("sid");
		
		MiraeAssetNewsVO miraeAssetNewsVO		=	miraeAssetNewsService.getMiraeAssetNewsDetail(sid);
		
		JSONObject jObj = new JSONObject();
		
		try{
			JSONArray jArr = new JSONArray();
			JSONObject sObj = new JSONObject();
			sObj.put("id", 		miraeAssetNewsVO.getId());
			sObj.put("created",	miraeAssetNewsVO.getCreated());
			sObj.put("title", 	miraeAssetNewsVO.getTitle());
			sObj.put("data", 	miraeAssetNewsVO.getData());
			jArr.add(sObj);				
			jObj.put("list", jArr);
		}catch(Exception e){
			e.printStackTrace();
		}
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", jObj);
		mav.setViewName("jsonView");
		return mav;
    }
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/getQuestionsDetail.do", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView getQuestionsDetail(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("Questions Detail Load...");
		
		String sid = req.getParameter("sid");
		
		MiraeAssetNewsVO miraeAssetNewsVO		=	miraeAssetNewsService.getQuestionsDetail(sid);
		
		JSONObject jObj = new JSONObject();
		
		try{
			JSONArray jArr = new JSONArray();
			JSONObject sObj = new JSONObject();
			sObj.put("id", 		miraeAssetNewsVO.getId());
			sObj.put("created",	miraeAssetNewsVO.getCreated());
			sObj.put("title", 	miraeAssetNewsVO.getTitle());
			sObj.put("data", 	miraeAssetNewsVO.getData());
			jArr.add(sObj);				
			jObj.put("list", jArr);
		}catch(Exception e){
			e.printStackTrace();
		}
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", jObj);
		mav.setViewName("jsonView");
		return mav;
    }
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/getInvestmentEduDetail.do", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView getInvestmentEduDetail(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("Investment Edu Detail Load...");
		
		String sid = req.getParameter("sid");
		
		MiraeAssetNewsVO miraeAssetNewsVO		=	miraeAssetNewsService.getInvestmentEduDetail(sid);
		
		JSONObject jObj = new JSONObject();
		
		try{
			JSONArray jArr = new JSONArray();
			JSONObject sObj = new JSONObject();
			sObj.put("id", 		miraeAssetNewsVO.getId());
			sObj.put("created",	miraeAssetNewsVO.getCreated());
			sObj.put("title", 	miraeAssetNewsVO.getTitle());
			sObj.put("data", 	miraeAssetNewsVO.getData());
			jArr.add(sObj);				
			jObj.put("list", jArr);
		}catch(Exception e){
			e.printStackTrace();
		}
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", jObj);
		mav.setViewName("jsonView");
		return mav;
    }
	
	@RequestMapping(value = "/trading/data/getRankingList.do", method = RequestMethod.GET)
	public ModelAndView getRankingList(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibotopm").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("rankingList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getSectorList.do", method = RequestMethod.GET)
	public ModelAndView getSectorList(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibomost").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("sectorList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	//Add new 2017/06/14: Start
	@RequestMapping(value = "/trading/data/getHighLowList.do", method = RequestMethod.GET)
	public ModelAndView getHighLowList(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibonewh").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("highlowList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getForeignerList.do", method = RequestMethod.GET)
	public ModelAndView getForeignerList(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibofore").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("foreignerList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getForeignerBuySellIndex.do", method = RequestMethod.GET)
	public ModelAndView getForeignerBuySellIndex(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibosidx").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("foreignerBuySellIndex", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getNewListedList.do", method = RequestMethod.GET)
	public ModelAndView getNewListedList(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibolist").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("newlistedList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	//Add new 2017/06/14: End
	
	@RequestMapping(value = "/trading/popup/stockInfo.do", method = RequestMethod.POST)
	public ModelAndView stockInfoPop(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		//mav.addObject("newsSeqn", req.getParameter("seqn"));
		//mav.addObject("newsDivId", req.getParameter("divId"));
		mav.setViewName("/popup/stockInfo");
		
		return mav;
	}
	
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/stockInfo.do", method = RequestMethod.GET)
	public ModelAndView stockInfo(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/stockInfo";
		
		JSONObject outputResult       = new JSONObject();
		
		JSONObject jsonData = new JSONObject();
		jsonData.put("mvInstrument", req.getParameter("mvInstrument"));
		jsonData.put("mvMarketID", req.getParameter("mvMarketID"));
		
		jsonData.put("mvBS", req.getParameter("mvBS"));
		jsonData.put("subAccountID", req.getParameter("mvSubAccountID"));
		jsonData.put("mvAction", req.getParameter("mvAction"));
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, req);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/stockInfoList.do", method = RequestMethod.GET)
	public ModelAndView stockInfoList(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String url = server + "stockInfo.action";
		Date nTime = new Date();
		long tt    = nTime.getTime();
		JSONObject outputResult       = new JSONObject();
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		
		paramList.add(new BasicNameValuePair("_dc", String.valueOf(tt)));
		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		paramList.add(new BasicNameValuePair("mvEnableGetStockInfo", req.getParameter("mvEnableGetStockInfo")));
		paramList.add(new BasicNameValuePair("mvAction", req.getParameter("mvAction")));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPost(url, paramList, req);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/enquiryorder.do", method = RequestMethod.GET)
	public ModelAndView enquiryorder(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/enquiryorder";
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		if(req.getParameter("mvStatus") != null) {
			jsonData.put("mvStatus", req.getParameter("mvStatus"));
		}
		if(req.getParameter("mvOrderType") != null) {
			jsonData.put("mvOrderType", req.getParameter("mvOrderType"));
		}
		if(req.getParameter("mvOrderBS") != null) {
			jsonData.put("mvOrderBS", req.getParameter("mvOrderBS"));
		}
		if(req.getParameter("mvStockID") != null) {
			jsonData.put("mvStockID", req.getParameter("mvStockID"));
		}
		
		jsonData.put("subAccountID", req.getParameter("mvSubAccountID"));
		jsonData.put("start", 0);
		jsonData.put("limit", 1000);
		jsonData.put("timePeriod", "");
		
		System.out.print(jsonData);
		
		VNSend   vn      = new VNSend();
		logger.info(System.currentTimeMillis() + "*** Execute Function request enquiryorder: " + req.getQueryString());
		outputResult     = vn.SendPostNew(url, jsonData, req);
		logger.info(System.currentTimeMillis() + "*** Execute Function respone enquiryorder: " + outputResult.toJSONString());
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/enterOrder.do", method = RequestMethod.GET)
	public ModelAndView enterOrder(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		//String filepath = "/opt/apache-tomcat-8.0.38/webapps/docs/orderdata/orderdata.txt";
		
		String filepath = SystemConfig.get("ODERDATA_PATH");
		//System.out.println("ODERDATA_PATH ENTERORDER");
		//System.out.println(filepath);
				
		File theDir = new File(filepath);

		// if the directory does not exist, create it
		if (!theDir.exists()) {
			//System.out.println("creating directory: " + theDir.getName());
			boolean result = false;

			try{
				theDir.mkdir();
				result = true;
			} 
			catch(SecurityException se){
				//handle it
			}        
			if(result) {    
				//System.out.println("DIR created");  
			}
		}
				
		String filepathlocal = "D:/orderdata.txt";		
	
		String url = server + "services/eqt/enterorder";
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", req.getParameter("mvSubAccountID"));
		jsonData.put("mvBS", req.getParameter("mvBS"));
		jsonData.put("mvStockCode", req.getParameter("mvStockCode"));
		jsonData.put("mvGoodTillDate", req.getParameter("mvGoodTillDate"));
		jsonData.put("mvGrossAmt", req.getParameter("mvGrossAmt"));
		jsonData.put("mvMarketID", req.getParameter("mvMarketID"));
		jsonData.put("mvOrderTypeValue", req.getParameter("mvOrderTypeValue"));
		jsonData.put("mvPrice", req.getParameter("mvPrice"));
		jsonData.put("mvQuantity", req.getParameter("mvQuantity"));
		jsonData.put("mvStop", req.getParameter("mvStop"));
		jsonData.put("mvStopPrice", req.getParameter("mvStopPrice"));
		jsonData.put("mvStopType", req.getParameter("mvStopType"));
		jsonData.put("mvBankID", req.getParameter("mvBankID"));
		jsonData.put("mvBankACID", req.getParameter("mvBankACID"));
		jsonData.put("mvBankPIN", req.getParameter("mvBankPIN"));
		
		
		//add mvRemark
		String remarks = "";
		HttpSession session = req.getSession();
		String jSes = (String)session.getAttribute("ttlJsession");
		int idx = jSes.indexOf(';');
		String ss = jSes.substring(0, idx);
		remarks += getClientIpAddr(req) + " *** " + ss;
		String sAuth = (String)session.getAttribute("saveAuth");
		String tk1 = (String)session.getAttribute("txtKey1");
		String tk2 = (String)session.getAttribute("txtKey2");
		String vk1 = (String)session.getAttribute("valKey1");
		String vk2 = (String)session.getAttribute("valKey2");
		
		//add OTP
		String datamvUserID = (String)session.getAttribute("datamvUserID");
		String dataauthenTime = (String)session.getAttribute("dataauthenTime");
		String dataSaveOTP = (String)session.getAttribute("dataSaveOTP");
		String datadvid = (String)session.getAttribute("datadvid");
		String datauszCustomerNo = (String)session.getAttribute("datauszCustomerNo");
		String datauszOTP = (String)session.getAttribute("datauszOTP");
		
		
		String authenMethod = (String)session.getAttribute("authenMethod");
		
		if (authenMethod == "matrix") {
			remarks += " *** Verify method: Matrix, " + sAuth + ",[" + tk1 + "]:" + vk1 + ",[" + tk2 + "]:" + vk2;
			jsonData.put("mvRemark", getClientIpAddr(req) + " *** Verify method: Matrix");
		} else {
			remarks += " *** Verify method: " + authenMethod + ",datamvUserID " + datamvUserID + ",dataauthenTime " + dataauthenTime + ",dataSaveOTP " + dataSaveOTP + ",datadvid " + datadvid + ",datauszCustomerNo " + datauszCustomerNo + ",datauszOTP " + datauszOTP;
			jsonData.put("mvRemark", getClientIpAddr(req) + " *** Verify method: " + authenMethod);
		}
		//jsonData.put("mvRemark", getClientIpAddr(req));
		//System.out.println(jsonData);
		//jsonData.put("mvRemark", req.getParameter("mvRemark"));
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, req);
		
		//write order log
		String str = "\r\n";	    
		
		BufferedWriter writer;
	    try {
	    	writer = new BufferedWriter(new FileWriter(filepath + "orderdata.txt", true));
	    } catch (Exception e) {
	    	writer = new BufferedWriter(new FileWriter(filepathlocal, true));
	    }
	    writer.append("[IN] " + tool.getCurrentFormatedTime() + " ");
	    writer.append(req.getSession().getAttribute("ClientV") + " IP Address: " + remarks + "|" + req.getParameter("mvBS") + "|" + req.getParameter("mvStockCode") + "|" + req.getParameter("mvQuantity") + "|" + req.getParameter("mvPrice"));
	    writer.append(str);
	    writer.append("[OUT] " + tool.getCurrentFormatedTime() + " " + req.getSession().getAttribute("ClientV") + " " + outputResult);	    
	    writer.append(str);
	    writer.close();
	    
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/verifyOrder.do", method = RequestMethod.GET)
	public ModelAndView verifyOrder(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String url = server + "verifyOrder.action";
		JSONObject outputResult       = new JSONObject();
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		
		paramList.add(new BasicNameValuePair("mvBS", req.getParameter("mvBS")));								//BUY :B, SELL:S
		paramList.add(new BasicNameValuePair("mvStockCode", req.getParameter("mvStockCode")));					//StockCode
		paramList.add(new BasicNameValuePair("mvMarketID", req.getParameter("mvMarketID")));
		paramList.add(new BasicNameValuePair("mvPrice", req.getParameter("mvPrice")));
		paramList.add(new BasicNameValuePair("mvQuantity", req.getParameter("mvQuantity")));						//valume
		paramList.add(new BasicNameValuePair("mvOrderTypeValue", req.getParameter("mvOrderTypeValue")));
		paramList.add(new BasicNameValuePair("mvGoodTillDate", req.getParameter("mvGoodTillDate")));
		paramList.add(new BasicNameValuePair("mvBankID", req.getParameter("mvBankID")));
		paramList.add(new BasicNameValuePair("mvBankACID", req.getParameter("mvBankACID")));
		paramList.add(new BasicNameValuePair("mvGrossAmt", req.getParameter("mvGrossAmt")));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPost(url, paramList, req);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/hksCancelOrder.do", method = RequestMethod.GET)
	public ModelAndView hksCancelOrder(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		//String filepath = "/opt/apache-tomcat-8.0.38/webapps/docs/orderdata/orderdata.txt";
	    String filepath = SystemConfig.get("ODERDATA_PATH");
		//System.out.println("ODERDATA_PATH CANCELORDER");
		//System.out.println(filepath);
		
		File theDir = new File(filepath);

		// if the directory does not exist, create it
		if (!theDir.exists()) {
		    //System.out.println("creating directory: " + theDir.getName());
		    boolean result = false;

		    try{
		        theDir.mkdir();
		        result = true;
		    } 
		    catch(SecurityException se){
		        //handle it
		    }        
		    if(result) {    
		        //System.out.printlnd");  
		    }
		}
		
		String filepathlocal = "D:/orderdata.txt";
		
		
		String url = server + "hksCancelOrder.action";
		JSONObject outputResult       = new JSONObject();
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		
		paramList.add(new BasicNameValuePair("AfterServerVerification", "Y"));
		paramList.add(new BasicNameValuePair("BuySell", req.getParameter("BuySell")));
		paramList.add(new BasicNameValuePair("ORDERID", req.getParameter("ORDERID")));
		paramList.add(new BasicNameValuePair("ORDERGROUPID", req.getParameter("ORDERGROUPID")));
		paramList.add(new BasicNameValuePair("StockCode", req.getParameter("StockCode")));
		paramList.add(new BasicNameValuePair("MarketID", req.getParameter("MarketID")));
		paramList.add(new BasicNameValuePair("Quantity", req.getParameter("Quantity")));
		paramList.add(new BasicNameValuePair("Price", req.getParameter("Price")));
		paramList.add(new BasicNameValuePair("OSQty", req.getParameter("OSQty")));
		paramList.add(new BasicNameValuePair("FILLEDQTY", req.getParameter("FILLEDQTY")));
		paramList.add(new BasicNameValuePair("OrderTypeValue", req.getParameter("OrderTypeValue")));
		paramList.add(new BasicNameValuePair("GOODTILLDATE", req.getParameter("GOODTILLDATE")));
		paramList.add(new BasicNameValuePair("StopTypeValue", req.getParameter("StopTypeValue")));
		paramList.add(new BasicNameValuePair("StopPrice", req.getParameter("StopPrice")));
		paramList.add(new BasicNameValuePair("SavePass", req.getParameter("SavePass")));
		paramList.add(new BasicNameValuePair("PasswordConfirmation", req.getParameter("PasswordConfirmation")));
		paramList.add(new BasicNameValuePair("mvAllorNothing", req.getParameter("mvAllorNothing")));
		paramList.add(new BasicNameValuePair("mvOrderId", req.getParameter("mvOrderId")));
		paramList.add(new BasicNameValuePair("mvMarketId", req.getParameter("mvMarketId")));
		paramList.add(new BasicNameValuePair("mvStockId", req.getParameter("mvStockId")));
		paramList.add(new BasicNameValuePair("mvInstrumentName", req.getParameter("mvInstrumentName")));
		paramList.add(new BasicNameValuePair("mvPric", req.getParameter("mvPric")));
		paramList.add(new BasicNameValuePair("mvQutityFormat", req.getParameter("mvQutityFormat")));
		paramList.add(new BasicNameValuePair("mvFilledQty", req.getParameter("mvFilledQty")));
		paramList.add(new BasicNameValuePair("mvOSQty", req.getParameter("mvOSQty")));
		paramList.add(new BasicNameValuePair("mvOrderType", req.getParameter("mvOrderType")));
		paramList.add(new BasicNameValuePair("password", req.getParameter("password")));
		paramList.add(new BasicNameValuePair("mvSecurityCode", req.getParameter("mvSecurityCode")));
		paramList.add(new BasicNameValuePair("mvSeriNo", req.getParameter("mvSeriNo")));
		paramList.add(new BasicNameValuePair("mvAnswer", req.getParameter("mvAnswer")));
		paramList.add(new BasicNameValuePair("mvSaveAuthenticate", req.getParameter("mvSaveAuthenticate")));
		paramList.add(new BasicNameValuePair("mvInputTime", req.getParameter("mvInputTime")));
		paramList.add(new BasicNameValuePair("mvStatus", req.getParameter("mvStatus")));
		paramList.add(new BasicNameValuePair("mvGoodTillDate", req.getParameter("mvGoodTillDate")));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPost(url, paramList, req);
		
		String remarks = "";
		HttpSession session = req.getSession();
		String jSes = (String)session.getAttribute("ttlJsession");
		int idx = jSes.indexOf(';');
		String ss = jSes.substring(0, idx);
		remarks += getClientIpAddr(req) + " *** " + ss;
		String sAuth = (String)session.getAttribute("saveAuth");
		String tk1 = (String)session.getAttribute("txtKey1");
		String tk2 = (String)session.getAttribute("txtKey2");
		String vk1 = (String)session.getAttribute("valKey1");
		String vk2 = (String)session.getAttribute("valKey2");
		//add OTP
		String datamvUserID = (String)session.getAttribute("datamvUserID");
		String dataauthenTime = (String)session.getAttribute("dataauthenTime");
		String datadvid = (String)session.getAttribute("datadvid");
		String datauszCustomerNo = (String)session.getAttribute("datauszCustomerNo");
		String datauszOTP = (String)session.getAttribute("datauszOTP");
				
				
		String authenMethod = (String)session.getAttribute("authenMethod");
		if (authenMethod == "matrix") {
			remarks += " *** Verify method: Matrix, " + sAuth + ",[" + tk1 + "]:" + vk1 + ",[" + tk2 + "]:" + vk2;
		} else {
			remarks += " *** Verify method: " + authenMethod + "," + datamvUserID + "," + "," + dataauthenTime + "," + datadvid + "," + datauszCustomerNo + "," + datauszOTP;
		}		
		
		//write cancel order log
		String str = "\r\n";	    
	    
		BufferedWriter writer;
	    try {
	    	writer = new BufferedWriter(new FileWriter(filepath + "orderdata.txt", true));
	    } catch (Exception e) {
	    	writer = new BufferedWriter(new FileWriter(filepathlocal, true));
	    }
	    writer.append("[IN] " + tool.getCurrentFormatedTime() + " ");
	    writer.append(req.getSession().getAttribute("ClientV") + " IP Address: " + remarks + "|Cancel Order" +  "|" + req.getParameter("BuySell") + "|" + req.getParameter("StockCode") + "|" + req.getParameter("Quantity") + "|" + req.getParameter("Price"));
	    writer.append(str);
	    writer.append("[OUT] " + tool.getCurrentFormatedTime() + " " + req.getSession().getAttribute("ClientV") + " " + outputResult);	    
	    writer.append(str);
	    writer.close();
			    
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
		
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/cancelOrder.do", method = RequestMethod.GET)
	public ModelAndView CancelOrder(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		// String filepath = "/opt/apache-tomcat-8.0.38/webapps/docs/orderdata/orderdata.txt";
	    String filepath = SystemConfig.get("ODERDATA_PATH");
		//System.out.println("ODERDATA_PATH cancelOrder");
		//System.out.println(filepath);
		
		File theDir = new File(filepath);

		// if the directory does not exist, create it
		if (!theDir.exists()) {
		    //System.out.println("creating directory: " + theDir.getName());
		    boolean result = false;

		    try{
		        theDir.mkdir();
		        result = true;
		    } 
		    catch(SecurityException se){
		        //handle it
		    }        
		    if(result) {    
		        //System.out.println("DIR created");  
		    }
		}
		
		String filepathlocal = "D:/orderdata.txt";
		
		
		String url = server + "services/eqt/cancelOrder";
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", req.getParameter("mvSubAccountID"));
		JSONParser parser = new JSONParser();
		Object obj = parser.parse(req.getParameter("mvOrder"));
		jsonData.put("order",obj);
		
		//System.out.println(jsonData);
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, req);
		
		String remarks = "";
		HttpSession session = req.getSession();
		String jSes = (String)session.getAttribute("ttlJsession");
		int idx = jSes.indexOf(';');
		String ss = jSes.substring(0, idx);
		remarks += getClientIpAddr(req) + " *** " + ss;
		String sAuth = (String)session.getAttribute("saveAuth");
		String tk1 = (String)session.getAttribute("txtKey1");
		String tk2 = (String)session.getAttribute("txtKey2");
		String vk1 = (String)session.getAttribute("valKey1");
		String vk2 = (String)session.getAttribute("valKey2");
		//add OTP
		String datamvUserID = (String)session.getAttribute("datamvUserID");
		String dataauthenTime = (String)session.getAttribute("dataauthenTime");
		String dataSaveOTP = (String)session.getAttribute("dataSaveOTP");
		String datadvid = (String)session.getAttribute("datadvid");
		String datauszCustomerNo = (String)session.getAttribute("datauszCustomerNo");
		String datauszOTP = (String)session.getAttribute("datauszOTP");
				
				
		String authenMethod = (String)session.getAttribute("authenMethod");
		if (authenMethod == "matrix") {
			remarks += " *** Verify method: Matrix, " + sAuth + ",[" + tk1 + "]:" + vk1 + ",[" + tk2 + "]:" + vk2;
		} else {
			remarks += " *** Verify method: " + authenMethod + ",datamvUserID " + datamvUserID + ",dataauthenTime " + dataauthenTime + ",dataSaveOTP " + dataSaveOTP + ",datadvid " + datadvid + ",datauszCustomerNo " + datauszCustomerNo + ",datauszOTP " + datauszOTP;
		}
		//write cancel order log
		String str = "\r\n";	    
	   
		BufferedWriter writer;
	    try {
	    	writer = new BufferedWriter(new FileWriter(filepath + "orderdata.txt", true));
	    } catch (Exception e) {
	    	writer = new BufferedWriter(new FileWriter(filepathlocal, true));
	    }
	    writer.append("[IN] " + tool.getCurrentFormatedTime() + " ");
	    writer.append(req.getSession().getAttribute("ClientV") + " IP Address: " + remarks + "|Cancel Order" +  "|" + req.getParameter("mvOrder"));
	    writer.append(str);
	    writer.append("[OUT] " + tool.getCurrentFormatedTime() + " " + req.getSession().getAttribute("ClientV") + " " + outputResult);	    
	    writer.append(str);
	    writer.close();
			    
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/hksModifyOrder.do", method = RequestMethod.GET)
	public ModelAndView hksModifyOrder(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		//String filepath = "/opt/apache-tomcat-8.0.38/webapps/docs/orderdata/orderdata.txt";
	    String filepath = SystemConfig.get("ODERDATA_PATH");
		//System.out.println("ODERDATA_PATH hksModifyOrder");
		//System.out.println(filepath);
		
		File theDir = new File(filepath);

		// if the directory does not exist, create it
		if (!theDir.exists()) {
		    //System.out.println("creating directory: " + theDir.getName());
		    boolean result = false;

		    try{
		        theDir.mkdir();
		        result = true;
		    } 
		    catch(SecurityException se){
		        //handle it
		    }        
		    if(result) {    
		        //System.out.println("DIR created");  
		    }
		}
		
		String filepathlocal = "D:/orderdata.txt";
		
		String url = server + "hksModifyOrder.action";
		JSONObject outputResult       = new JSONObject();
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();

		paramList.add(new BasicNameValuePair("mvCurrencyId", req.getParameter("mvCurrencyId")));								//BUY :B, SELL:S
		paramList.add(new BasicNameValuePair("mvMaxLotPerOrder", req.getParameter("mvMaxLotPerOrder")));								//BUY :B, SELL:S
		paramList.add(new BasicNameValuePair("mvOrigPrice", req.getParameter("mvOrigPrice")));					//StockCode
		paramList.add(new BasicNameValuePair("mvOrigQty", req.getParameter("mvOrigQty")));
		paramList.add(new BasicNameValuePair("mvOrigStopPrice", req.getParameter("mvOrigStopPrice")));
		paramList.add(new BasicNameValuePair("mvStopPrice", req.getParameter("mvStopPrice")));
		paramList.add(new BasicNameValuePair("mvOrigPriceValue", req.getParameter("mvOrigPriceValue")));						//valume
		paramList.add(new BasicNameValuePair("mvOrigQtyValue", req.getParameter("mvOrigQtyValue")));						//price
		paramList.add(new BasicNameValuePair("mvCancelQtyValue", req.getParameter("mvCancelQtyValue")));
		paramList.add(new BasicNameValuePair("mvAveragePrice", req.getParameter("mvAveragePrice")));
		paramList.add(new BasicNameValuePair("mvAllOrNothing", req.getParameter("mvAllOrNothing")));						//market Kind of?
		paramList.add(new BasicNameValuePair("mvStopOrderType", req.getParameter("mvStopOrderType")));							//what the...
		paramList.add(new BasicNameValuePair("mvValidityDate", req.getParameter("mvValidityDate")));
		paramList.add(new BasicNameValuePair("mvActivationDate", req.getParameter("mvActivationDate")));
		paramList.add(new BasicNameValuePair("mvAllowOddLot", req.getParameter("mvAllowOddLot")));
		paramList.add(new BasicNameValuePair("mvRemark", req.getParameter("mvRemark")));
		paramList.add(new BasicNameValuePair("mvContactPhone", req.getParameter("mvContactPhone")));
		paramList.add(new BasicNameValuePair("mvGrossAmtValue", req.getParameter("mvGrossAmtValue")));
		paramList.add(new BasicNameValuePair("mvNetAmtValue", req.getParameter("mvNetAmtValue")));
		paramList.add(new BasicNameValuePair("mvSCRIP", req.getParameter("mvSCRIP")));
		paramList.add(new BasicNameValuePair("mvIsPasswordSaved", req.getParameter("mvIsPasswordSaved")));
		paramList.add(new BasicNameValuePair("mvStopTypeValue", req.getParameter("mvStopTypeValue")));
		paramList.add(new BasicNameValuePair("mvPasswordConfirmation", req.getParameter("mvPasswordConfirmation")));
		paramList.add(new BasicNameValuePair("mvOrderId", req.getParameter("mvOrderId")));
		paramList.add(new BasicNameValuePair("mvGoodTillDate", req.getParameter("mvGoodTillDate")));
		paramList.add(new BasicNameValuePair("mvBS", req.getParameter("mvBS")));
		paramList.add(new BasicNameValuePair("mvOrderGroupId", req.getParameter("mvOrderGroupId")));
		paramList.add(new BasicNameValuePair("mvOrderType", req.getParameter("mvOrderType")));
		paramList.add(new BasicNameValuePair("mvFormIndexpage", req.getParameter("mvFormIndexpage")));
		paramList.add(new BasicNameValuePair("mvStopValue", req.getParameter("mvStopValue")));
		paramList.add(new BasicNameValuePair("mvFilledQty", req.getParameter("mvFilledQty")));
		paramList.add(new BasicNameValuePair("mvLotSizeValue", req.getParameter("mvLotSizeValue")));

		paramList.add(new BasicNameValuePair("mvStopOrderExpiryDate", req.getParameter("mvStopOrderExpiryDate")));
		paramList.add(new BasicNameValuePair("OrderId", req.getParameter("OrderId")));
		paramList.add(new BasicNameValuePair("mvMarketId", req.getParameter("mvMarketId")));
		paramList.add(new BasicNameValuePair("mvStockId", req.getParameter("mvStockId")));
		paramList.add(new BasicNameValuePair("mvStockName", req.getParameter("mvStockName")));
		paramList.add(new BasicNameValuePair("mvPrice", req.getParameter("mvPrice")));
		paramList.add(new BasicNameValuePair("mvNewPrice", req.getParameter("mvNewPrice")));
		paramList.add(new BasicNameValuePair("mvQty", req.getParameter("mvQty")));
		paramList.add(new BasicNameValuePair("mvNewQty", req.getParameter("mvNewQty")));
		paramList.add(new BasicNameValuePair("OrderType", req.getParameter("OrderType")));
		paramList.add(new BasicNameValuePair("GoodTillDate", req.getParameter("GoodTillDate")));
		paramList.add(new BasicNameValuePair("mvGrossAmt", req.getParameter("mvGrossAmt")));

		paramList.add(new BasicNameValuePair("Password", req.getParameter("Password")));
		paramList.add(new BasicNameValuePair("mvSecurityCode", req.getParameter("mvSecurityCode")));
		paramList.add(new BasicNameValuePair("mvStatus", req.getParameter("mvStatus")));
		paramList.add(new BasicNameValuePair("mvSeriNo", req.getParameter("mvSeriNo")));
		paramList.add(new BasicNameValuePair("mvAnswer", req.getParameter("mvAnswer")));
		paramList.add(new BasicNameValuePair("mvSaveAuthenticate", req.getParameter("mvSaveAuthenticate")));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPost(url, paramList, req);
		
		String remarks = "";
		HttpSession session = req.getSession();
		String jSes = (String)session.getAttribute("ttlJsession");
		int idx = jSes.indexOf(';');
		String ss = jSes.substring(0, idx);
		remarks += getClientIpAddr(req) + " *** " + ss;
		String sAuth = (String)session.getAttribute("saveAuth");
		String tk1 = (String)session.getAttribute("txtKey1");
		String tk2 = (String)session.getAttribute("txtKey2");
		String vk1 = (String)session.getAttribute("valKey1");
		String vk2 = (String)session.getAttribute("valKey2");
		//add OTP
		String datamvUserID = (String)session.getAttribute("datamvUserID");
		String dataauthenTime = (String)session.getAttribute("dataauthenTime");
		String dataSaveOTP = (String)session.getAttribute("dataSaveOTP");
		String datadvid = (String)session.getAttribute("datadvid");
		String datauszCustomerNo = (String)session.getAttribute("datauszCustomerNo");
		String datauszOTP = (String)session.getAttribute("datauszOTP");
				
				
		String authenMethod = (String)session.getAttribute("authenMethod");
		if (authenMethod == "matrix") {
			remarks += " *** Verify method: Matrix, " + sAuth + ",[" + tk1 + "]:" + vk1 + ",[" + tk2 + "]:" + vk2;
		} else {
			remarks += " *** Verify method: " + authenMethod + ",datamvUserID " + datamvUserID + ",dataauthenTime " + dataauthenTime + ",dataSaveOTP " + dataSaveOTP + ",datadvid " + datadvid + ",datauszCustomerNo " + datauszCustomerNo + ",datauszOTP " + datauszOTP;
		}
				
		//write modify order log
		String str = "\r\n";	    
	    
		BufferedWriter writer;
	    try {
	    	writer = new BufferedWriter(new FileWriter(filepath + "orderdata.txt", true));
	    } catch (Exception e) {
	    	writer = new BufferedWriter(new FileWriter(filepathlocal, true));
	    }	    
	    writer.append("[IN] " + tool.getCurrentFormatedTime() + " ");
	    writer.append(req.getSession().getAttribute("ClientV") + " IP Address: " + remarks + "|Modify Order" +  "|" + req.getParameter("mvBS") + "|" + req.getParameter("mvStockId") + "|" + req.getParameter("mvOrigQty") + "|" + req.getParameter("mvOrigPrice") + "|" + req.getParameter("mvNewQty") + "|" + req.getParameter("mvNewPrice"));
	    writer.append(str);
	    writer.append("[OUT] " + tool.getCurrentFormatedTime() + " " + req.getSession().getAttribute("ClientV") + " " + outputResult);	    
	    writer.append(str);
	    writer.close();
			    
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/modifyOrder.do", method = RequestMethod.GET)
	public ModelAndView ModifyOrder(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		//String filepath = "/opt/apache-tomcat-8.0.38/webapps/docs/orderdata/orderdata.txt";
	    String filepath = SystemConfig.get("ODERDATA_PATH");
		//System.out.println("ODERDATA_PATH modify");
		//System.out.println(filepath);
		
		File theDir = new File(filepath);

		// if the directory does not exist, create it
		if (!theDir.exists()) {
		    //System.out.println("creating directory: " + theDir.getName());
		    boolean result = false;

		    try{
		        theDir.mkdir();
		        result = true;
		    } 
		    catch(SecurityException se){
		        //handle it
		    }        
		    if(result) {    
		        //System.out.println("DIR created");  
		    }
		}
		
		String filepathlocal = "D:/orderdata.txt";
		
		String url = server + "services/eqt/modifyOrder";
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", req.getParameter("mvSubAccountID"));
		jsonData.put("mvOrderId", req.getParameter("mvOrderId"));
		jsonData.put("mvOrderGroupId", req.getParameter("mvOrderGroupId"));
		jsonData.put("mvNewPrice", req.getParameter("mvNewPrice"));
		jsonData.put("mvNewQty", req.getParameter("mvNewQty"));
		jsonData.put("mvStockId", req.getParameter("mvStockId"));
		jsonData.put("mvMarketId", req.getParameter("mvMarketId"));
		jsonData.put("mvOrigQty", req.getParameter("mvOrigQty"));
		jsonData.put("mvStopOrderType", req.getParameter("mvStopOrderType"));
		jsonData.put("mvStopPrice", req.getParameter("mvStopPrice"));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, req);
		
		String remarks = "";
		HttpSession session = req.getSession();
		String jSes = (String)session.getAttribute("ttlJsession");
		int idx = jSes.indexOf(';');
		String ss = jSes.substring(0, idx);
		remarks += getClientIpAddr(req) + " *** " + ss;
		String sAuth = (String)session.getAttribute("saveAuth");
		String tk1 = (String)session.getAttribute("txtKey1");
		String tk2 = (String)session.getAttribute("txtKey2");
		String vk1 = (String)session.getAttribute("valKey1");
		String vk2 = (String)session.getAttribute("valKey2");
		//add OTP
		String datamvUserID = (String)session.getAttribute("datamvUserID");
		String dataauthenTime = (String)session.getAttribute("dataauthenTime");
		String dataSaveOTP = (String)session.getAttribute("dataSaveOTP");
		String datadvid = (String)session.getAttribute("datadvid");
		String datauszCustomerNo = (String)session.getAttribute("datauszCustomerNo");
		String datauszOTP = (String)session.getAttribute("datauszOTP");
				
				
		String authenMethod = (String)session.getAttribute("authenMethod");
		if (authenMethod == "matrix") {
			remarks += " *** Verify method: Matrix, " + sAuth + ",[" + tk1 + "]:" + vk1 + ",[" + tk2 + "]:" + vk2;
		} else {
			remarks += " *** Verify method: " + authenMethod + ",datamvUserID " + datamvUserID + ",dataauthenTime " + dataauthenTime + ",dataSaveOTP " + dataSaveOTP + ",datadvid " + datadvid + ",datauszCustomerNo " + datauszCustomerNo + ",datauszOTP " + datauszOTP;
		}
		//write modify order log
		String str = "\r\n";	    
	    
		BufferedWriter writer;
	    try {
	    	writer = new BufferedWriter(new FileWriter(filepath + "orderdata.txt", true));
	    } catch (Exception e) {
	    	writer = new BufferedWriter(new FileWriter(filepathlocal, true));
	    }
	    writer.append("[IN] " + tool.getCurrentFormatedTime() + " ");
	    writer.append(req.getSession().getAttribute("ClientV") + " IP Address: " + remarks + "|Modify Order" +  "|" + req.getParameter("mvStockId") + "|" + req.getParameter("mvOrigQty") + "|" + req.getParameter("mvNewQty") + "|" + req.getParameter("mvNewPrice"));
	    writer.append(str);
	    writer.append("[OUT] " + tool.getCurrentFormatedTime() + " " + req.getSession().getAttribute("ClientV") + " " + outputResult);	    
	    writer.append(str);
	    writer.close();
			    
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/genmodifyorder.do", method = RequestMethod.GET)
	public ModelAndView genmodifyorder(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String url = server + "genmodifyorder.action";
		JSONObject outputResult       = new JSONObject();
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();

		paramList.add(new BasicNameValuePair("mvOrderId", req.getParameter("mvOrderId")));							//BUY :B, SELL:S
		paramList.add(new BasicNameValuePair("mvBSValue", req.getParameter("mvBSValue")));							//BUY :B, SELL:S
		paramList.add(new BasicNameValuePair("mvStockId", req.getParameter("mvStockId")));							//StockCode
		paramList.add(new BasicNameValuePair("mvMarketId", req.getParameter("mvMarketId")));
		paramList.add(new BasicNameValuePair("mvPriceValue", req.getParameter("mvPriceValue")));
		paramList.add(new BasicNameValuePair("mvQtyValue", req.getParameter("mvQtyValue")));
		paramList.add(new BasicNameValuePair("mvCancelQtyValue", req.getParameter("mvCancelQtyValue")));			//valume
		paramList.add(new BasicNameValuePair("mvInputTime", req.getParameter("mvInputTime")));						//price
		paramList.add(new BasicNameValuePair("mvStopTypeValue", req.getParameter("mvStopTypeValue")));
		paramList.add(new BasicNameValuePair("mvStopPriceValue", req.getParameter("mvStopPriceValue")));
		paramList.add(new BasicNameValuePair("mvStopOrderExpiryDate", req.getParameter("mvStopOrderExpiryDate")));	//market Kind of?
		paramList.add(new BasicNameValuePair("mvOrderTypeValue", req.getParameter("mvOrderTypeValue")));			//what the...
		paramList.add(new BasicNameValuePair("mvAllOrNothing", req.getParameter("mvAllOrNothing")));
		paramList.add(new BasicNameValuePair("mvValidityDate", req.getParameter("mvValidityDate")));
		paramList.add(new BasicNameValuePair("mvActivationDate", req.getParameter("mvActivationDate")));
		paramList.add(new BasicNameValuePair("mvGoodTillDate", req.getParameter("mvGoodTillDate")));
		paramList.add(new BasicNameValuePair("mvRemark", req.getParameter("mvRemark")));
		paramList.add(new BasicNameValuePair("mvContactPhone", req.getParameter("mvContactPhone")));
		paramList.add(new BasicNameValuePair("mvGrossAmt", req.getParameter("mvGrossAmt")));
		paramList.add(new BasicNameValuePair("mvNetAmtValue", req.getParameter("mvNetAmtValue")));
		paramList.add(new BasicNameValuePair("mvSCRIP", req.getParameter("mvSCRIP")));
		paramList.add(new BasicNameValuePair("mvlotSize", req.getParameter("mvlotSize")));
		paramList.add(new BasicNameValuePair("mvOrderGroupId", req.getParameter("mvOrderGroupId")));
		paramList.add(new BasicNameValuePair("mvBaseNetAmtValue", req.getParameter("mvBaseNetAmtValue")));
		paramList.add(new BasicNameValuePair("mvAvgPriceValue", req.getParameter("mvAvgPriceValue")));
		paramList.add(new BasicNameValuePair("mvFilledQty", req.getParameter("mvFilledQty")));
		paramList.add(new BasicNameValuePair("mvStatus", req.getParameter("mvStatus")));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPost(url, paramList, req);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/enterorderfail.do", method = RequestMethod.GET)
	public ModelAndView enterorderfail(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String url = server + "enterorderfail.action";
		Date nTime = new Date();
		long tt    = nTime.getTime();
		JSONObject outputResult       = new JSONObject();
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();

		paramList.add(new BasicNameValuePair("key", String.valueOf(tt)));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPost(url, paramList, req);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/enquiryportfolio.do", method = RequestMethod.GET)
	public ModelAndView enquiryportfolio(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/enquiryportfolio";
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", req.getParameter("mvSubAccountID"));
		
		VNSend   vn      = new VNSend();
		logger.info(System.currentTimeMillis() + "*** Execute Function request enquiryportfolio: " + req.getQueryString());
		outputResult     = vn.SendPostNew(url, jsonData, req);
		logger.info(System.currentTimeMillis() + "*** Execute Function respone enquiryportfolio: " + outputResult.toJSONString());
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/genenterorder.do", method = RequestMethod.GET)
	public ModelAndView genenterorder(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/genenterorder";
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", req.getParameter("mvSubAccountID"));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, req);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/authCardMatrix.do", method = RequestMethod.GET)
	public ModelAndView authCardMatrix(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		JSONObject outputResult       = new JSONObject();

		String url = server + "services/eqt/authCardMatrix";

		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("wordMatrixKey01", request.getParameter("wordMatrixKey01"));
		jsonData.put("wordMatrixValue01", request.getParameter("wordMatrixValue01"));
		jsonData.put("wordMatrixKey02", request.getParameter("wordMatrixKey02"));
		jsonData.put("wordMatrixValue02", request.getParameter("wordMatrixValue02"));
		jsonData.put("serialnumber", request.getParameter("wordMatrixValue02"));
		jsonData.put("mvSaveAuthenticate", request.getParameter("mvSaveAuthenticate"));
		
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		HttpSession session = request.getSession();
		String mvS = (String)outputResult.get("mvSuccess");
		if (mvS.equals("SUCCESS")) {
			if((String)request.getParameter("wordMatrixKey01") != "") {
				session.setAttribute("txtKey1", (String)request.getParameter("wordMatrixKey01"));
				session.setAttribute("txtKey2", (String)request.getParameter("wordMatrixKey02"));
				session.setAttribute("valKey1", (String)request.getParameter("wordMatrixValue01"));
				session.setAttribute("valKey2", (String)request.getParameter("wordMatrixValue02"));
				session.setAttribute("saveAuth", (String)request.getParameter("mvSaveAuthenticate"));
			}
		}
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/validateClientInfo.do", method = RequestMethod.GET)
	public ModelAndView ValidateClientInfo(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		JSONObject outputResult       = new JSONObject();

		String url = server + "auth/validateClientInfo";
		//System.out.println("server URL===" + url);

		JSONObject jsonData = new JSONObject();
		jsonData.put("mvClientId", request.getParameter("mvClientId"));
		jsonData.put("mvEmail", request.getParameter("mvEmail"));
		jsonData.put("mvWordMatrixKey01", request.getParameter("mvWordMatrixKey01"));
		jsonData.put("mvWordMatrixValue01", request.getParameter("mvWordMatrixValue01"));
		jsonData.put("mvWordMatrixKey02", request.getParameter("mvWordMatrixKey02"));
		jsonData.put("mvWordMatrixValue02", request.getParameter("mvWordMatrixValue02"));
		jsonData.put("service", request.getParameter("mvService"));
		jsonData.put("serialnumber", request.getParameter("mvSerialnumber"));
		jsonData.put("mvSaveAuthenticate", Boolean.parseBoolean(request.getParameter("mvSaveAuthenticate")));
		jsonData.put("language", request.getParameter("mvLanguage"));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/resetPassword.do", method = RequestMethod.GET)
	public ModelAndView ResetPassword(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		JSONObject outputResult       = new JSONObject();

		String url = server + "auth/resetPassword";
		//System.out.println("server URL===" + url);

		JSONObject jsonData = new JSONObject();
		jsonData.put("mvClientId", request.getParameter("mvClientId"));
		jsonData.put("mvEmail", request.getParameter("mvEmail"));
		jsonData.put("mvWordMatrixKey01", request.getParameter("mvWordMatrixKey01"));
		jsonData.put("mvWordMatrixValue01", request.getParameter("mvWordMatrixValue01"));
		jsonData.put("mvWordMatrixKey02", request.getParameter("mvWordMatrixKey02"));
		jsonData.put("mvWordMatrixValue02", request.getParameter("mvWordMatrixValue02"));
		jsonData.put("service", request.getParameter("mvService"));
		jsonData.put("serialnumber", request.getParameter("mvSerialnumber"));
		jsonData.put("mvSaveAuthenticate", Boolean.parseBoolean(request.getParameter("mvSaveAuthenticate")));
		jsonData.put("mvNewPassword", request.getParameter("mvNewPassword"));
		jsonData.put("mvNewPasswordConfirm", request.getParameter("mvNewPasswordConfirm"));
		jsonData.put("language", request.getParameter("mvLanguage"));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/validateClientInfoOTP.do", method = RequestMethod.GET)
	public ModelAndView ValidateClientInfoOTP(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		JSONObject outputResult       = new JSONObject();

		String url = server + "reset/forgotpassword";
		//System.out.println("server URL validateClientInfoOTP=== " + url + " mvClientId " + request.getParameter("mvClientId") + " mvNumPhone " + request.getParameter("mvNumPhone") + " mvLanguage " + request.getParameter("mvLanguage"));

		JSONObject jsonData = new JSONObject();
		jsonData.put("loginID", request.getParameter("mvClientId"));
		jsonData.put("dest", request.getParameter("mvNumPhone"));
		jsonData.put("language", request.getParameter("mvLanguage"));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/resetPasswordOTP.do", method = RequestMethod.GET)
	public ModelAndView ResetPasswordOTP(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		JSONObject outputResult       = new JSONObject();

		String url = server + "reset/confirmresetpassword";
		//System.out.println("server URL resetPasswordOTP===" + url);

		JSONObject jsonData = new JSONObject();
		jsonData.put("loginID", request.getParameter("mvClientId"));
		//jsonData.put("mvEmail", request.getParameter("mvEmail"));
		jsonData.put("otp", request.getParameter("mvOTP"));
		jsonData.put("secret", request.getParameter("mvSecret"));
		jsonData.put("dest", request.getParameter("mvNumPhone"));
		jsonData.put("newPassword", request.getParameter("mvNewPassword"));
		jsonData.put("newPasswordCfm", request.getParameter("mvNewPasswordConfirm"));
		jsonData.put("language", request.getParameter("mvLanguage"));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getItemList.do", method =  {RequestMethod.GET, RequestMethod.POST}, produces={"application/json"})
	@ResponseBody
	public ModelAndView getItemList(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		SearchVO sch			  = new SearchVO();
		String rcod = req.getParameter("rcod");
		sch.setSearchKey(rcod);
	    
	    List<ItemVO> itemVO		=	itemService.getItemList(sch);
		JSONObject jObj = new JSONObject();
		
		try{
			JSONArray jArr = new JSONArray();
			for(int i=0; i<itemVO.size(); i++){
				JSONObject sObj = new JSONObject();
				sObj.put("synm", 	itemVO.get(i).getSynm());
				sObj.put("market",	itemVO.get(i).getMarketId());
				sObj.put("secNmEn",	itemVO.get(i).getSecNm_en());
				sObj.put("secNmVn", itemVO.get(i).getSecNm_vn());
				sObj.put("ratio", 	itemVO.get(i).getRatio());
				jArr.add(sObj);
				jObj.put("list", jArr);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		
		mav.addObject("jsonObj", jObj);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/showCardMatrixPopUp.do", method = RequestMethod.GET)
	public ModelAndView showCardMatrixPopUp(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String url = server + "showCardMatrixPopUp.action";
		JSONObject outputResult       = new JSONObject();
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPost(url, paramList, req);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	/**
	 * Add profile page
	 */
	@RequestMapping(value = "/trading/view/profile.do", method = RequestMethod.GET)
	public String Profile(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/profile";
	}
	
	/**
	 * Add Industry page
	 */
	@RequestMapping(value = "/trading/view/industry.do", method = RequestMethod.GET)
	public String Industry(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/industry";
	}
	
	/**
	 * Add financials page
	 */
	@RequestMapping(value = "/trading/view/financials.do", method = RequestMethod.GET)
	public String Financials(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/financials";
	}
	
	/**
	 * Add Events page
	 */
	@RequestMapping(value = "/trading/view/stockevents.do", method = RequestMethod.GET)
	public String Stockevents(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trading/stockevents";
	}
	
	@RequestMapping(value = "/trading/data/getBasic.do", method = RequestMethod.GET)
	public ModelAndView getBasic(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibopfbs").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("basicList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getSectorInfo.do", method = RequestMethod.GET)
	public ModelAndView getSectorInfo(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibopfst").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("sectorInfoList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getListingInfo.do", method = RequestMethod.GET)
	public ModelAndView getListingInfo(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibopflt").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("listingInfoList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getPriceChg.do", method = RequestMethod.GET)
	public ModelAndView getPriceChg(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibopfpc").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("priceChgList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getOwnerStc.do", method = RequestMethod.GET)
	public ModelAndView getOwnerStc(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibopfow").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("ownerStcList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getMajorShare.do", method = RequestMethod.GET)
	public ModelAndView getMajorShare(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibopfmj").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("majorShareList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getMainSectorList.do", method = RequestMethod.GET)
	public ModelAndView getMainSectorList(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibostls").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("mainSectorList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getSectorFilter.do", method = RequestMethod.GET)
	public ModelAndView getSectorFilter(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibostfs").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("sectorFilterList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getRecommendList.do", method = RequestMethod.GET)
	public ModelAndView getRecommendList(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "piboreco").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		mav.addObject("recommendList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getIndustryPeersCount.do", method = RequestMethod.GET)
	public ModelAndView getIndustryPeersCount(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "piboinco").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("industryPeersCount", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getIndustryPeersList.do", method = RequestMethod.GET)
	public ModelAndView getIndustryPeersList(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {			
			outputResult = new TRExecuter(webInterface, "piboindu").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("industryPeersList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getStockEvents.do", method = RequestMethod.GET)
	public ModelAndView getStockEvents(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {			
			outputResult = new TRExecuter(webInterface, "piboevts").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("evtList", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getFinancialsHeader.do", method = RequestMethod.GET)
	public ModelAndView getFinancialsHeader(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {			
			outputResult = new TRExecuter(webInterface, "pibofihe").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("financialsHeader", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/getFinancialsData.do", method = RequestMethod.GET)
	public ModelAndView getFinancialsData(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {			
			outputResult = new TRExecuter(webInterface, "pibofida").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("financialsData", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/ordertimelog.do", method = RequestMethod.GET)
	public ModelAndView orderTimeLog(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		String str = "\r\n";	    
	    String filepath = "D:/orderdata.txt";
	    String bs = req.getParameter("buysell");
	    String stock = req.getParameter("stockcode");
	    String mode = req.getParameter("mode");
	    BufferedWriter writer = new BufferedWriter(new FileWriter(filepath, true));
	    writer.append(mode + " WTS client === " + new Date().getTime() + " " + bs + " " + stock);
	    writer.append(str);	     
	    writer.close();
	    		
		JSONObject outputResult       = new JSONObject();		
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/getAccountSummary.do", method = RequestMethod.GET)
	public ModelAndView GetAccountSummary(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/accountsummaryenquiry";
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", req.getParameter("mvSubAccountID"));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, req);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/saveRecommend.do", method = RequestMethod.GET)
	public ModelAndView saveRecommend(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		ModelAndView mav       = new ModelAndView();		
		//Save Recommend
		HttpSession session 		=	request.getSession();
		session.setAttribute("recom", "");
		mav.addObject("trResult", true);
		mav.setViewName("jsonView");		
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/getSubAccount.do", method = RequestMethod.GET)
	public ModelAndView getSubAccount(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/getsubaccount";
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("clientID", req.getParameter("mvClientID"));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, req);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/changeSubAccount.do", method = RequestMethod.GET)
	public ModelAndView changeSubAccount(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav       = new ModelAndView();		
		//Save Recommend
		HttpSession session 		=	req.getSession();
		session.setAttribute("subAccountID", req.getParameter("mvSubAccountID"));
		session.setAttribute("tradingAccSeq", req.getParameter("mvTradingAccSeq"));
		session.setAttribute("defaultSubAccount", req.getParameter("mvTradingAccSeq"));
		session.setAttribute("popupversion6", req.getParameter("subAccountID"));
		mav.addObject("trResult", true);
		mav.setViewName("jsonView");		
		return mav;
	}
	
	@RequestMapping(value = "/trading/popup/viewOrderDetail.do", method = RequestMethod.POST)
	public ModelAndView viewOrderDetail(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {		
		ModelAndView mav = new ModelAndView();
		mav.addObject("groupOrderID", req.getParameter("mvGroupOrderID"));
		mav.setViewName("/popup/viewOrderDetail");		
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/getOrderDetail.do", method = RequestMethod.GET)
	public ModelAndView getOrderDetail(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/orderDetail";
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", req.getParameter("mvSubAccountID"));
		jsonData.put("orderGroupID", req.getParameter("mvOrderGroupID"));
		jsonData.put("isHistory", Boolean.parseBoolean(req.getParameter("mvIsHistory")));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, req);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/genBuyAll.do", method = RequestMethod.GET)
	public ModelAndView genBuyAll(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/genbuyall";
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", req.getParameter("mvSubAccountID"));
		jsonData.put("mvInstrument", req.getParameter("mvInstrument"));
		jsonData.put("mvMarketID", req.getParameter("mvMarketID"));
		jsonData.put("price", req.getParameter("mvPrice"));
		//jsonData.put("BS", req.getParameter("mvBS"));
		jsonData.put("buyingPower", req.getParameter("mvBuyingPower"));
		
		VNSend   vn      = new VNSend();
		logger.info(System.currentTimeMillis() + "*** Execute Function request genBuyAll: " + req.getQueryString());
		outputResult     = vn.SendPostNew(url, jsonData, req);
		logger.info(System.currentTimeMillis() + "*** Execute Function respone genBuyAll: " + outputResult.toJSONString());
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/trading/data/bsActiveTab.do", method = RequestMethod.GET)
	public ModelAndView bsActiveTab(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav       = new ModelAndView();		
		//Save Recommend
		HttpSession session 		=	req.getSession();
		session.setAttribute("TAB_IDX4", req.getParameter("mvTab"));
		mav.addObject("trResult", true);
		mav.setViewName("jsonView");		
		return mav;
	}
	
	//Mirae Tech OTP
	@RequestMapping(value = "/trading/data/mVerifyOTP.do", method = RequestMethod.GET)
	public ModelAndView mVerifyOTP(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		
		//Save Recommend
		//HttpSession session 		=	req.getSession();
		//session.setAttribute("datauszCustomerNo", req.getParameter("uszCustomerNo"));
		//session.setAttribute("datauszOTP", req.getParameter("uszOTP"));
		
		
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {			
			outputResult = new TRExecuter(webInterface, "pibobotp").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		//System.out.println("Stringget uszReternCode mVerifyOTP");
		//System.out.println(outputResult);
		//data.otpResponse.uszReternCode == "0000"
		HttpSession session = req.getSession();	
		if ((boolean)outputResult.get("uszReternCode").equals("0000")) {
			//if((String)req.getParameter("mvValue01") != "") {
				session.setAttribute("datauszCustomerNo", req.getParameter("uszCustomerNo"));
				session.setAttribute("datauszOTP", req.getParameter("uszOTP"));
			//}
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("otpResponse", outputResult);
		mav.addObject("trResult", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/mSaveOTP.do", method = RequestMethod.GET)
	public ModelAndView mSaveOTP(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");		
		req.setAttribute("usid", req.getParameter("mvUserID"));
		req.setAttribute("authenTime", req.getParameter("mvSaveTime"));
		req.setAttribute("dvid", getMacAddress(req));
		
		//Save Recommend
		//HttpSession session 		=	req.getSession();
		//session.setAttribute("datamvUserID", req.getParameter("mvUserID"));
		//session.setAttribute("dataauthenTime", req.getParameter("mvSaveTime"));
		//session.setAttribute("datadvid", getMacAddress(req));
		
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {			
			outputResult = new TRExecuter(webInterface, "pibosaud").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		//data.otpResponse.uszReternCode == "0000"
		//System.out.println("Stringget uszReternCode mSaveOTP");
		//System.out.println(outputResult);
		
		HttpSession session = req.getSession();	
		if ((boolean)outputResult.get("returnCode").equals("0")) {
			//if((String)req.getParameter("mvSaveTime") != "") {
				session.setAttribute("datamvUserID", req.getParameter("mvUserID"));
				session.setAttribute("dataauthenTime", req.getParameter("mvSaveTime"));
				session.setAttribute("datadvid", getMacAddress(req));
			//}
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("otpResponseSave", outputResult);
		mav.addObject("trResult", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}	
	
	@RequestMapping(value = "/trading/data/mCheckOTP.do", method = RequestMethod.GET)
	public ModelAndView mCheckOTP(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		req.setAttribute("usid", req.getParameter("mvUserID"));
		req.setAttribute("dvid", getMacAddress(req));
		
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {			
			outputResult = new TRExecuter(webInterface, "pibocaud").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			return mav;
		}
		
		//System.out.println("Stringget uszReternCode mCheckOTP");
		//System.out.println(outputResult);
		
		//data.otpResponse.uszReternCode == "0000"
		HttpSession session = req.getSession();	
		if ((boolean)outputResult.get("returnCode").equals("0")) {
			//if((String)req.getParameter("mvSaveTime") != "") {
				session.setAttribute("datamvUserID", req.getParameter("mvUserID"));
				session.setAttribute("dataSaveOTP", outputResult.get("result"));
				session.setAttribute("datadvid", getMacAddress(req));
			//}
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("otpResponseCheck", outputResult);
		mav.addObject("trResult", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/checkSignContracts.do", method = RequestMethod.GET)
	public ModelAndView checkSignContracts(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		req.setAttribute("userID", req.getParameter("mvUserID"));
		
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {			
			outputResult = new TRExecuter(webInterface, "piboctra").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("signResponseCheck", outputResult);
		mav.addObject("trResult", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	public String getMacAddress(HttpServletRequest req) {
		String browser = "";
		//String ip = "";
		//ip = getClientIpAddr(req);
		
		String  browserDetails  =   req.getHeader("User-Agent");
	    String  userAgent       =   browserDetails;
	    String  user            =   userAgent.toLowerCase();
         //===============Browser===========================
        if (user.contains("msie"))
        {
            String substring=userAgent.substring(userAgent.indexOf("MSIE")).split(";")[0];
            browser=substring.split(" ")[0].replace("MSIE", "IE")+"-"+substring.split(" ")[1];
        } else if (user.contains("safari") && user.contains("version"))
        {
            browser=(userAgent.substring(userAgent.indexOf("Safari")).split(" ")[0]).split("/")[0]+"-"+(userAgent.substring(userAgent.indexOf("Version")).split(" ")[0]).split("/")[1];
        } else if ( user.contains("opr") || user.contains("opera"))
        {
            if(user.contains("opera"))
                browser=(userAgent.substring(userAgent.indexOf("Opera")).split(" ")[0]).split("/")[0]+"-"+(userAgent.substring(userAgent.indexOf("Version")).split(" ")[0]).split("/")[1];
            else if(user.contains("opr"))
                browser=((userAgent.substring(userAgent.indexOf("OPR")).split(" ")[0]).replace("/", "-")).replace("OPR", "Opera");
        } else if (user.contains("chrome"))
        {
            browser=(userAgent.substring(userAgent.indexOf("Chrome")).split(" ")[0]).replace("/", "-");
        } else if ((user.indexOf("mozilla/7.0") > -1) || (user.indexOf("netscape6") != -1)  || (user.indexOf("mozilla/4.7") != -1) || (user.indexOf("mozilla/4.78") != -1) || (user.indexOf("mozilla/4.08") != -1) || (user.indexOf("mozilla/3") != -1) )
        {
            browser = "Netscape-?";

        } else if (user.contains("firefox"))
        {
            browser=(userAgent.substring(userAgent.indexOf("Firefox")).split(" ")[0]).replace("/", "-");
        } else if(user.contains("rv"))
        {
            browser="IE-" + user.substring(user.indexOf("rv") + 3, user.indexOf(")"));
        } else
        {
            browser = "UnKnown, More-Info: "+userAgent;
        }
        HttpSession session = req.getSession();	
		return (String)session.getAttribute("ClientV") + "." + browser;
	}
	
	public String getMD5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(input.getBytes());
          
            return convertByteToHex(messageDigest);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
	
	public String convertByteToHex(byte[] data) {
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < data.length; i++) {
            sb.append(Integer.toString((data[i] & 0xff) + 0x100, 16).substring(1));
        }
        return sb.toString();
    }
}
