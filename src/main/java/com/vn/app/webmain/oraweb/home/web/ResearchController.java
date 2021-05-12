package com.vn.app.webmain.oraweb.home.web;

import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.vn.app.webmain.oraweb.home.service.MiraeAssetNewsService;
import com.vn.app.webmain.oraweb.home.service.MiraeAssetNewsVO;
import com.vn.app.webmain.oraweb.home.service.ResearchService;
import com.vn.app.webmain.oraweb.home.service.ResearchVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

import m.config.SystemConfig;

@Controller
public class ResearchController {
	
	private static final Logger logger = LoggerFactory.getLogger(ResearchController.class);
	/*
	@Value("#{prop['SYSTEM.USER.AGENT']}") private String USER_AGENT;
	@Value("#{prop['SYSTEM.TTL.SERVER.IP']}") private String host;
	@Value("#{prop['SYSTEM.TTL.SERVER']}") private String server;
	*/
	private String USER_AGENT	=	SystemConfig.get("SYSTEM.USER.AGENT");
	private String host			=	SystemConfig.get("SYSTEM.TTL.SERVER.IP");
	private String server		=	SystemConfig.get("SYSTEM.TTL.SERVER");
	
	@Resource(name="researchServiceImpl")
	private ResearchService researchService;
	
	@Resource(name="miraeAssetNewsServiceImpl")
	private MiraeAssetNewsService miraeAssetNewsService;
	
	@RequestMapping(value = "/researchDown2.do", method = RequestMethod.GET)
    @ResponseBody
    public void researchDown2(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("RESEARCH FILE DOWN CALL");
		
		ResearchVO	researchVO		=	researchService.getResearchData(req.getParameter("ids"));
		String	fileData	=	researchVO.getData();
		String	fileName	=	researchVO.getName();
		String 	content 	= 	fileData.substring(fileData.indexOf("<Content>"), fileData.indexOf("</Content>"));
		content				=	content.replace("<Content>", "");
		content				=	content.replace("</Content>", "");
		String	serverPath	=	SystemConfig.get("FILE_DOWN");
		
		byte[] decoded = Base64.decodeBase64(content);
		
		res.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "");
        res.getOutputStream().write(decoded);
        res.flushBuffer();
    }
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/researchRead.do", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView researchRead(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("RESEARCH List Load...");
		//System.out.println(req.getParameter("lang"));
		
		SearchVO searchVO = new SearchVO();
		
		searchVO.setStartDate(req.getParameter("startDate"));
		searchVO.setEndDate(req.getParameter("endDate"));
		searchVO.setPage(req.getParameter("page"));
		searchVO.setType(req.getParameter("nType"));
		searchVO.setSearchKey(req.getParameter("searchKey"));
		
		if(req.getParameter("lang") != null){
			searchVO.setLang(req.getParameter("lang"));
		} else {
			searchVO.setLang("vi_VN");
		}
		
		if(req.getParameter("page") != null){
			searchVO.setPage(req.getParameter("page"));
		} else {
			searchVO.setPage("1");
		}
		
		//System.out.println("### startDate : " + searchVO.getStartDate());
		//System.out.println("### endDate  : " + searchVO.getEndDate());
		
		List<ResearchVO> researchVO		=	researchService.getResearchList(searchVO);
		List<ResearchVO> researchCntVO		=	researchService.getResearchCnt(searchVO);
		
		JSONObject jObj = new JSONObject();
		
		try{
			JSONArray jArr = new JSONArray();
			for(int i=0; i<researchVO.size(); i++){
				JSONObject sObj = new JSONObject();
				sObj.put("id", 		researchVO.get(i).getId());
				sObj.put("created",	researchVO.get(i).getCreated());
				sObj.put("modified",researchVO.get(i).getModified());
				sObj.put("code", 	researchVO.get(i).getCode());
				sObj.put("name", 	researchVO.get(i).getName());
				sObj.put("data", 	researchVO.get(i).getData());
				jArr.add(sObj);
				
				jObj.put("list", jArr);
			}
			jObj.put("listSize", researchCntVO.get(0));
		}catch(Exception e){
			e.printStackTrace();
		}
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", jObj);
		mav.setViewName("jsonView");
		return mav;
    }
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/getResearchTopList.do", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView getResearchTopList(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("RESEARCH TopList Load...");
		
		SearchVO searchVO = new SearchVO();
		searchVO.setType(req.getParameter("nType"));
		if(req.getParameter("lang") != null){
			searchVO.setLang(req.getParameter("lang"));
		} else {
			searchVO.setLang("vi_VN");
		}
		
		List<ResearchVO> researchVO		=	researchService.getResearchTopList(searchVO);
		
		JSONObject jObj = new JSONObject();
		
		try{
			JSONArray jArr = new JSONArray();
			for(int i=0; i<researchVO.size(); i++){
				JSONObject sObj = new JSONObject();
				sObj.put("id", 		researchVO.get(i).getId());
				sObj.put("created",	researchVO.get(i).getCreated());
				sObj.put("modified",researchVO.get(i).getModified());
				sObj.put("code", 	researchVO.get(i).getCode());
				sObj.put("name", 	researchVO.get(i).getName());
				sObj.put("data", 	researchVO.get(i).getData());
				jArr.add(sObj);
				
				jObj.put("list", jArr);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", jObj);
		mav.setViewName("jsonView");
		return mav;
    }
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/getAllMiraeAssetNews.do", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView getAllMiraeAssetNews(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("Mirae Asset News List Load...");
		//System.out.println(req.getParameter("lang"));
		
		SearchVO searchVO = new SearchVO();
		
		searchVO.setStartDate(req.getParameter("startDate"));
		searchVO.setEndDate(req.getParameter("endDate"));
		searchVO.setPage(req.getParameter("page"));
		searchVO.setSearchKey(req.getParameter("searchKey"));
		
		if(req.getParameter("lang") != null){
			searchVO.setLang(req.getParameter("lang"));
		} else {
			searchVO.setLang("vi_VN");
		}
		
		if(req.getParameter("page") != null){
			searchVO.setPage(req.getParameter("page"));
		} else {
			searchVO.setPage("1");
		}
		
		//System.out.println("### startDate : " + searchVO.getStartDate());
		//System.out.println("### endDate  : " + searchVO.getEndDate());
		
		List<MiraeAssetNewsVO> miraeNewsVO		=	miraeAssetNewsService.getAllMiraeAssetNews(searchVO);
		List<MiraeAssetNewsVO> miraeNewsCntVO		=	miraeAssetNewsService.getMiraeAssetNewsCnt(searchVO);
		
		JSONObject jObj = new JSONObject();
		
		try{
			JSONArray jArr = new JSONArray();
			for(int i=0; i<miraeNewsVO.size(); i++){
				JSONObject sObj = new JSONObject();
				sObj.put("id", 		miraeNewsVO.get(i).getId());
				sObj.put("created",	miraeNewsVO.get(i).getCreated());
				sObj.put("modified",miraeNewsVO.get(i).getModified());
				sObj.put("title", 	miraeNewsVO.get(i).getTitle());
				sObj.put("data", 	miraeNewsVO.get(i).getData());
				jArr.add(sObj);
				jObj.put("list", jArr);
			}
			jObj.put("listSize", miraeNewsCntVO.get(0));
		}catch(Exception e){
			e.printStackTrace();
		}
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", jObj);
		mav.setViewName("jsonView");
		return mav;
    }
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/getAllInvestmentEdu.do", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView getAllInvestmentEdu(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("Investment Edu List Load...");
		//System.out.println(req.getParameter("lang"));
		
		SearchVO searchVO = new SearchVO();
		
		searchVO.setStartDate(req.getParameter("startDate"));
		searchVO.setEndDate(req.getParameter("endDate"));
		searchVO.setPage(req.getParameter("page"));
		searchVO.setSearchKey(req.getParameter("searchKey"));
		
		if(req.getParameter("lang") != null){
			searchVO.setLang(req.getParameter("lang"));
		} else {
			searchVO.setLang("vi_VN");
		}
		
		if(req.getParameter("page") != null){
			searchVO.setPage(req.getParameter("page"));
		} else {
			searchVO.setPage("1");
		}
		
		//System.out.println("### startDate : " + searchVO.getStartDate());
		//System.out.println("### endDate  : " + searchVO.getEndDate());
		
		List<MiraeAssetNewsVO> miraeNewsVO		=	miraeAssetNewsService.getAllInvestmentEdu(searchVO);
		List<MiraeAssetNewsVO> miraeNewsCntVO		=	miraeAssetNewsService.getInvestmentEduCnt(searchVO);
		
		JSONObject jObj = new JSONObject();
		
		try{
			JSONArray jArr = new JSONArray();
			for(int i=0; i<miraeNewsVO.size(); i++){
				JSONObject sObj = new JSONObject();
				sObj.put("id", 		miraeNewsVO.get(i).getId());
				sObj.put("created",	miraeNewsVO.get(i).getCreated());
				sObj.put("modified",miraeNewsVO.get(i).getModified());
				sObj.put("title", 	miraeNewsVO.get(i).getTitle());
				sObj.put("data", 	miraeNewsVO.get(i).getData());
				jArr.add(sObj);
				jObj.put("list", jArr);
			}
			jObj.put("listSize", miraeNewsCntVO.get(0));
		}catch(Exception e){
			e.printStackTrace();
		}
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", jObj);
		mav.setViewName("jsonView");
		return mav;
    }
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/getAllQuestions.do", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView getAllQuestions(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("Questions List Load...");
		
		SearchVO searchVO = new SearchVO();
		searchVO.setStartDate(req.getParameter("startDate"));
		searchVO.setEndDate(req.getParameter("endDate"));
		searchVO.setPage(req.getParameter("page"));
		searchVO.setSearchKey(req.getParameter("searchKey"));
		
		if(req.getParameter("lang") != null){
			searchVO.setLang(req.getParameter("lang"));
		} else {
			searchVO.setLang("vi_VN");
		}
		
		if(req.getParameter("page") != null){
			searchVO.setPage(req.getParameter("page"));
		} else {
			searchVO.setPage("1");
		}
		
		List<MiraeAssetNewsVO> miraeNewsVO		=	miraeAssetNewsService.getAllQuestions(searchVO);
		List<MiraeAssetNewsVO> miraeNewsCntVO		=	miraeAssetNewsService.getQuestionsCnt(searchVO);
		
		JSONObject jObj = new JSONObject();
		
		try{
			JSONArray jArr = new JSONArray();
			for(int i=0; i<miraeNewsVO.size(); i++){
				JSONObject sObj = new JSONObject();
				sObj.put("id", 		miraeNewsVO.get(i).getId());
				sObj.put("created",	miraeNewsVO.get(i).getCreated());
				sObj.put("modified",miraeNewsVO.get(i).getModified());
				sObj.put("title", 	miraeNewsVO.get(i).getTitle());
				sObj.put("data", 	miraeNewsVO.get(i).getData());
				jArr.add(sObj);
				jObj.put("list", jArr);
			}
			jObj.put("listSize", miraeNewsCntVO.get(0));
		}catch(Exception e){
			e.printStackTrace();
		}
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", jObj);
		mav.setViewName("jsonView");
		return mav;
    }
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/getMiraeAssetNews.do", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView getMiraeAssetNews(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("Mirae News Load...");
		
		SearchVO searchVO = new SearchVO();
		if(req.getParameter("lang") != null){
			searchVO.setLang(req.getParameter("lang"));
		} else {
			searchVO.setLang("vi_VN");
		}

		List<MiraeAssetNewsVO> miraeAssetNewsVO		=	miraeAssetNewsService.getMiraeAssetNews(searchVO);
		
		JSONObject jObj = new JSONObject();
		
		try{
			JSONArray jArr = new JSONArray();
			for(int i=0; i<miraeAssetNewsVO.size(); i++){
				JSONObject sObj = new JSONObject();
				sObj.put("id", 		miraeAssetNewsVO.get(i).getId());
				sObj.put("created",	miraeAssetNewsVO.get(i).getCreated());
				sObj.put("modified",miraeAssetNewsVO.get(i).getModified());
				sObj.put("title", 	miraeAssetNewsVO.get(i).getTitle());
				sObj.put("data", 	miraeAssetNewsVO.get(i).getData());
				jArr.add(sObj);
				jObj.put("list", jArr);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", jObj);
		mav.setViewName("jsonView");
		return mav;
    }
	
	@RequestMapping(value = "/pdfViewer.do", method = RequestMethod.GET)
	public String online(Locale locale, Model model) {
		logger.info("home==========================popup>> PDFViewer");
		return "/home/popup/pdfViewer";
	}
}
