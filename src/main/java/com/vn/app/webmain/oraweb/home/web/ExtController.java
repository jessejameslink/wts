package com.vn.app.webmain.oraweb.home.web;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.client.HttpClient;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.vn.app.commons.VNUtil;
import com.vn.app.commons.util.DecodeFileUtil;
import com.vn.app.webmain.oranews.home.service.HomeService2;
import com.vn.app.webmain.oraweb.home.service.HomeService;
import com.vn.app.webmain.oraweb.home.service.LinkService;
import com.vn.app.webmain.oraweb.home.service.LinkVO;
import com.vn.app.webmain.oraweb.home.service.MiraeAssetNewsService;
import com.vn.app.webmain.oraweb.home.service.MiraeAssetNewsVO;
import com.vn.app.webmain.oraweb.home.service.ResearchService;
import com.vn.app.webmain.oraweb.home.service.ResearchVO;

import localhost.WsHnxUDP;
import localhost.WsHnxUDPSoap;
import m.config.SystemConfig;


/**
 * 
 * @author TEMI
 * MTS CALL Referer Controller
 *	
 */
@Controller
public class ExtController {
	
	private static final Logger logger = LoggerFactory.getLogger(ExtController.class);
	/*
	@Value("#{prop['SYSTEM.USER.AGENT']}") private String USER_AGENT;
	@Value("#{prop['SYSTEM.TTL.SERVER.IP']}") private String host;
	@Value("#{prop['SYSTEM.TTL.SERVER']}") private String server;
	*/
	private String USER_AGENT	=	SystemConfig.get("SYSTEM.USER.AGENT");
	private String host			=	SystemConfig.get("SYSTEM.TTL.SERVER.IP");
	private String server		=	SystemConfig.get("SYSTEM.TTL.SERVER");
	
	private HttpClient httpClient;
	
	@Resource(name="homeServiceImpl")
	private HomeService homeService;
	
	@Resource(name="homeServiceImpl2")
	private HomeService2 homeService2;
	
	@Resource(name="researchServiceImpl")
	private ResearchService researchService;
	
	@Resource(name="miraeAssetNewsServiceImpl")
	private MiraeAssetNewsService miraeAssetNewsService;
	
	@Resource(name="linkServiceImpl")
	private LinkService linkService;
	
	@RequestMapping(value = "/researchDown.do", method = {RequestMethod.GET, RequestMethod.POST}, produces={"application/json"})
	public ModelAndView ResearchDown(Locale locale, ModelMap model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String		ids				=	req.getParameter("ids");
		ResearchVO	researchVO		=	researchService.getResearchData(ids);
		ModelAndView mav			=	new ModelAndView();
		
		String	fileData			=	researchVO.getData();
		String	fileName			=	researchVO.getName();
		String	serverPath			=	SystemConfig.get("FILE_DOWN");
		String	downPath			=	"";
		String 	content 			= 	fileData.substring(fileData.indexOf("<Content>"), fileData.indexOf("</Content>"));
		content						=	content.replace("<Content>", "");
		content						=	content.replace("</Content>", "");
		DecodeFileUtil	deFile		=	new DecodeFileUtil();
		downPath					=	serverPath	+	fileName;
		deFile.decodeStringtoFile(content, downPath);
		//System.out.println("PDF DOWN PATH=>" + downPath);
		//mav.addObject("pdfCon", content);
		//mav.addObject("downPath", req.getLocalAddr()+"/docs/"+fileName);
		mav.addObject("downPath", SystemConfig.get("SYSTEM.LOCAL.IP")+"/docs/"+fileName);
		
		
		//System.out.println("@@@FILE DOWN PATH==>" + SystemConfig.get("SYSTEM.LOCAL.IP")+"/docs/"+fileName);
		
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/upload.do", method = {RequestMethod.GET, RequestMethod.POST}, produces={"application/json"})
	public ModelAndView upload(Locale locale, ModelMap model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String		ids				=	req.getParameter("ids");
		ResearchVO	researchVO		=	researchService.getResearchData(ids);
		ModelAndView mav			=	new ModelAndView();
		
		String	fileData			=	researchVO.getData();
		String	fileName			=	researchVO.getName();
		String	serverPath			=	SystemConfig.get("FILE_DOWN");
		String	downPath			=	"";
		String 	content 			= 	fileData.substring(fileData.indexOf("<Content>"), fileData.indexOf("</Content>"));
		content						=	content.replace("<Content>", "");
		content						=	content.replace("</Content>", "");
		DecodeFileUtil	deFile		=	new DecodeFileUtil();		
		downPath					=	serverPath	+ "research/" +	fileName;
		
		deFile.decodeStringtoFile(content, downPath);
		//System.out.println("@@@FILE SERVER DOWN PATH==>" + SystemConfig.get("SYSTEM.LOCAL.IP")+"/docs/research/"+fileName);
		
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/uploadMultimedia.do", method = {RequestMethod.GET, RequestMethod.POST}, produces={"application/json"})
	public ModelAndView uploadMultimedia(Locale locale, ModelMap model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String		ids				=	req.getParameter("ids");
		String		type				=	req.getParameter("type");
		LinkVO	linkVO		=	linkService.getLinkDetail(ids);
		ModelAndView mav			=	new ModelAndView();
		
		String	fileData			=	linkVO.getData();
		String	fileName			=	linkVO.getFileName();
		String	serverPath			=	SystemConfig.get("FILE_DOWN");
		String	downPath			=	"";
		String 	content 			= 	fileData.substring(fileData.indexOf("<Content>"), fileData.indexOf("</Content>"));
		content						=	content.replace("<Content>", "");
		content						=	content.replace("</Content>", "");
		DecodeFileUtil	deFile		=	new DecodeFileUtil();
		if (type.equals("1")) {
			downPath					=	serverPath	+ "image/" +	fileName;
			//System.out.println("@@@FILE SERVER DOWN PATH==>" + SystemConfig.get("SYSTEM.LOCAL.IP")+"/docs/image/"+fileName);
		} else {
			downPath					=	serverPath	+ "video/" +	fileName;
			//System.out.println("@@@FILE SERVER DOWN PATH==>" + SystemConfig.get("SYSTEM.LOCAL.IP")+"/docs/video/"+fileName);
		}
		deFile.decodeStringtoFile(content, downPath);
		
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/getSoapData1.do", method = RequestMethod.POST, produces={"application/json"})
	public ModelAndView GetExtSoapData1(Locale locale, ModelMap model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String		ids				=	req.getParameter("ids");
		ModelAndView mav			=	new ModelAndView();
		
		if (!"".equals(ids)) {
	      WsHnxUDP ws = new WsHnxUDP();
	      WsHnxUDPSoap client = ws.getWsHnxUDPSoap12();
	      String rtData	=	client.getHnxUDP(Long.parseLong(ids));
	      mav.addObject("rtData", rtData);
	      mav.addObject("trResult", "success");
	      mav.addObject("trMsg", "success");
	      mav.setViewName("jsonView");
	    } else {
	      mav.addObject("rtData", "");
	      mav.addObject("trResult", "error");
	      mav.addObject("trMsg", "No Seq");
	      mav.setViewName("jsonView");
	    }
		return mav;
	}
	
	@RequestMapping(value={"/getExtNewsDetail.do"}, method={org.springframework.web.bind.annotation.RequestMethod.GET, org.springframework.web.bind.annotation.RequestMethod.POST}, produces={"application/json"})
	@ResponseBody
	public ModelAndView getMiraeAssetNewsDetail(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("Mirae Asset News Detail Load...");
		
		//System.out.println("#####GET EXT MIRAE NEWS DETAIL#####");
		//System.out.println("#                                              #");
		//System.out.println("#                                              #");
		//System.out.println("TIME =>" + VNUtil.getTimeStamp());
		//System.out.println("SID =>" + req.getParameter("sid"));
		//System.out.println("Mirae Asset News Detail Load...");
		//System.out.println("#                                              #");
		//System.out.println("#                                              #");
		//System.out.println("################################################");
		
		
		logger.debug("#####GET EXT MIRAE NEWS DETAIL#####");
		logger.debug("#                                              #");
		logger.debug("#                                              #");
		logger.debug("#CALL TIME =>" + VNUtil.getTimeStamp());
		logger.debug("#SID       =>" + req.getParameter("sid")  +   "#");
		logger.debug("#                                              #");
		logger.debug("#                                              #");
		logger.debug("################################################");
	    String sid = req.getParameter("sid");
	    MiraeAssetNewsVO miraeAssetNewsVO = miraeAssetNewsService.getMiraeAssetNewsDetail(sid);
	    JSONObject jObj = new JSONObject();
	    try {
			//jObj.put("id", miraeAssetNewsVO.getId());
			//jObj.put("created", miraeAssetNewsVO.getCreated());
			//jObj.put("modified", miraeAssetNewsVO.getModified());
			//jObj.put("title", miraeAssetNewsVO.getTitle());
			jObj.put("data", miraeAssetNewsVO.getData());
	    } catch (Exception e) {
	    	e.printStackTrace();
	    }
		    ModelAndView mav = new ModelAndView();
		    mav.addObject("jsonObj", jObj);
		    mav.setViewName("jsonView");
		    return mav;
	  }
}
