package com.vn.app.webmain.mssqlweb.home.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.vn.app.webmain.mssqlweb.home.service.MarketNewsService;
import com.vn.app.webmain.mssqlweb.home.service.MarketNewsVO;
import com.vn.app.webmain.mssqlweb.home.service.SearchVO;
import com.vn.app.webmain.oraweb.home.service.ItemVO;
import com.vn.app.webmain.oraweb.home.service.MiraeAssetNewsVO;

@Controller
public class MarketNewsController {
	
	private static final Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Resource(name="marketNewsServiceImpl")
	private MarketNewsService marketNewsService;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/market/data/getMarketNewsList.do", method={org.springframework.web.bind.annotation.RequestMethod.GET, org.springframework.web.bind.annotation.RequestMethod.POST}, produces={"application/json"})
	@ResponseBody
	public ModelAndView getMarketNewsList(HttpServletRequest req, HttpServletResponse res) throws Exception {
		SearchVO	sch	=	new SearchVO();
		ModelAndView mav          = new ModelAndView();
		String startDate	=	req.getParameter("startDate");
		String endDate		=	req.getParameter("endDate");
		
		String page			=	req.getParameter("page");
		String searchKey 	=   req.getParameter("searchKey");
		
		sch.setStartDate(startDate);
		sch.setEndDate(endDate);
		
		if(req.getParameter("marketId") != null){
			sch.setSchMarket(req.getParameter("marketId"));
		} else {
			sch.setSchMarket("all");
		}
		
		sch.setSearchKey(searchKey);
		
		if(req.getParameter("lang") != null){
			sch.setLang(req.getParameter("lang"));
		} else {
			sch.setLang("0");
		}
		
		if(req.getParameter("page") != null){
			sch.setPage(req.getParameter("page"));
		} else {
			sch.setPage("1");
		}
		
		
		if(req.getParameter("searchKey") != null){
			sch.setSearchKey(req.getParameter("searchKey"));
		} else {
			sch.setSearchKey("");
		}
		
		if(req.getParameter("schItem") != null){
			sch.setSchItem(req.getParameter("schItem"));
		} else {
			sch.setSchItem("");
		}
		
	    List<MarketNewsVO> marketNewsList		=	marketNewsService.getMarketNewsList(sch);
	    Integer cnt								=	marketNewsService.getMarketNewsListCnt(sch);
		JSONObject jObj = new JSONObject();
		
		try{
			JSONArray jArr = new JSONArray();
			for(int i=0; i<marketNewsList.size(); i++){
				JSONObject sObj = new JSONObject();
				sObj.put("articleId", 	marketNewsList.get(i).getArticleId());
				sObj.put("channelId", 	marketNewsList.get(i).getChannelId());
				sObj.put("title", 	marketNewsList.get(i).getTitle());
				sObj.put("createDate", 	marketNewsList.get(i).getLastUpdate());
				sObj.put("name", 	marketNewsList.get(i).getName());
				sObj.put("source", 	marketNewsList.get(i).getSource());
				sObj.put("crtDate", 	marketNewsList.get(i).getCrtDate());
				sObj.put("crtTime", 	marketNewsList.get(i).getCrtTime());
				jArr.add(sObj);
				jObj.put("list", jArr);
			}
			jObj.put("listSize", cnt);
		}catch(Exception e){
			e.printStackTrace();
		}
		mav.addObject("jsonObj", jObj);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/market/data/getMarketNewsTop3List.do", method={org.springframework.web.bind.annotation.RequestMethod.GET, org.springframework.web.bind.annotation.RequestMethod.POST}, produces={"application/json"})
	@ResponseBody
	public ModelAndView getMarketNewsTop3List(HttpServletRequest req, HttpServletResponse res) throws Exception {
		SearchVO	sch	=	new SearchVO();
		ModelAndView mav          = new ModelAndView();
			
		if(req.getParameter("lang") != null){
			sch.setLang(req.getParameter("lang"));
		} else {
			sch.setLang("0");
		}
				
	    List<MarketNewsVO> marketNewsList		=	marketNewsService.getMarketNewsTop3List(sch);
		JSONObject jObj = new JSONObject();
		
		try{
			JSONArray jArr = new JSONArray();
			for(int i=0; i<marketNewsList.size(); i++){
				JSONObject sObj = new JSONObject();
				sObj.put("articleId", 	marketNewsList.get(i).getArticleId());
				sObj.put("channelId", 	marketNewsList.get(i).getChannelId());
				sObj.put("title", 	marketNewsList.get(i).getTitle());
				sObj.put("createDate", 	marketNewsList.get(i).getLastUpdate());
				sObj.put("name", 	marketNewsList.get(i).getName());
				sObj.put("source", 	marketNewsList.get(i).getSource());
				sObj.put("headImage", 	marketNewsList.get(i).getHeadImage());
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
	
	
}
