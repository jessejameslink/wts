package com.vn.app.webmain.oraweb.home.web;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;
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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.vn.app.webmain.mssqlweb.home.service.SearchVO;
import com.vn.app.webmain.oraweb.home.service.ItemService;
import com.vn.app.webmain.oraweb.home.service.ItemVO;

import m.config.SystemConfig;

@Controller
public class InitController {
	
	private static final Logger logger = LoggerFactory.getLogger(InitController.class);
	
	@Resource(name="itemServiceImpl")
	private ItemService itemService;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/setUpdateRcod.do", method = RequestMethod.GET)
    @ResponseBody
    public void setUpdateRcod(HttpServletRequest req, HttpServletResponse res) throws Exception {
		SearchVO searchVO = new SearchVO();
		List<ItemVO> itemVO		=	itemService.getItemAllList();
		JSONObject jObj = new JSONObject();
		
		//System.out.println("**************UPDATE FILE PATH CHECK******************");
		//System.out.println(this.getClass().getResource("/").getPath()+"vn/conf/vncode.cod");
		
		BufferedWriter bw	=	new BufferedWriter(new FileWriter(new File(this.getClass().getResource("/").getPath() + "vn/conf/vncode.cod").toString(), false));					//	true : append, flase : new file
		PrintWriter pw		=	new PrintWriter(bw, true);
		
		try{
			JSONArray jArr = new JSONArray();
			for(int i = 0;i < itemVO.size();i++) {
				String	cont	=	"";
				if("null".equals(itemVO.get(i).getSynm()) || itemVO.get(i).getSynm() == null) {
					cont	+=	"";
				} else {
					cont	+=	itemVO.get(i).getSynm();
				}
				cont		+=	"\t";
				if("null".equals(itemVO.get(i).getMarketId()) || itemVO.get(i).getMarketId() == null) {
					cont	+=	"";
				} else {
					cont	+=	itemVO.get(i).getMarketId();
				}
				cont		+=	"\t";
				if("null".equals(itemVO.get(i).getSnum()) || itemVO.get(i).getSnum() == null) {
					cont	+=	"";
				} else {
					cont	+=	itemVO.get(i).getSnum();
				}
				cont		+=	"\t";
				if("null".equals(itemVO.get(i).getSecNm_en()) || itemVO.get(i).getSecNm_en() == null) {
					cont	+=	"";
				} else {
					cont	+=	itemVO.get(i).getSecNm_en();
				}
				cont		+=	"\t";
				if("null".equals(itemVO.get(i).getSecNm_vn()) || itemVO.get(i).getSecNm_vn() == null) {
					cont	+=	"";
				} else {
					cont	+=	itemVO.get(i).getSecNm_vn();
				}
				cont	+=	"\n";
				//System.out.println(cont);
				pw.write(cont);
				
				
				/*
				pw.write(itemVO.get(i).getSynm() 
						+ "\t" + itemVO.get(i).getMarketId() 
						+ "\t" + itemVO.get(i).getSnum() 
						+ "\t" + itemVO.get(i).getSecNm_en() 
						+ "\t" + itemVO.get(i).getSecNm_vn() + "\n");
				*/
			}
		} catch(Exception e){
			pw.flush();
			pw.close();
			e.printStackTrace();
		} finally {
			//System.out.println("=========연결해제================");
			//System.out.println("+++++++++++++++++++++++++++++++");
			//System.out.println("+++++++++++++++++++++++++++++++");
			pw.flush();
			pw.close();
		}
	}
	
	@RequestMapping(value = "/setUpdateMadw.do", method = RequestMethod.GET)
    @ResponseBody
    public void setUpdateMadw(HttpServletRequest req, HttpServletResponse res) throws Exception {
		logger.info("Schedule setUpdateMadw Call");
		BufferedInputStream bis = null;
		BufferedOutputStream bos = null;
    
		URL url = new URL("https://www.miraeassetdaewoo.com/hts/piww0503.jsp?gubn1=003&gubn2=186");
        URLConnection conn = url.openConnection();
        
        URL url1 = new URL("https://www.miraeassetdaewoo.com/hts/piww0503.jsp?gubn1=002&gubn2=185");
        URLConnection conn1 = url1.openConnection();
        
        URL url2 = new URL("https://www.miraeassetdaewoo.com/hts/piww0503.jsp?gubn1=002&gubn2=183");
        URLConnection conn2 = url2.openConnection();
        
        URL url3 = new URL("https://www.miraeassetdaewoo.com/hts/piww0503.jsp?gubn1=001&gubn2=100");
        URLConnection conn3 = url3.openConnection();
        
        URL url4 = new URL("https://www.miraeassetdaewoo.com/hts/piww0503.jsp?gubn1=002&gubn2=184");
        URLConnection conn4 = url4.openConnection();
        
        URL url5 = new URL("https://www.miraeassetdaewoo.com/hts/piww0503.jsp?gubn1=486&gubn2=101");
        URLConnection conn5 = url5.openConnection();
        
		try{
          conn.setDoOutput(true);
          bis = new BufferedInputStream(conn.getInputStream());
          bos = new BufferedOutputStream(new FileOutputStream(new File(SystemConfig.get("DOWNMADW_FILE"))));
          byte[] buffer = new byte[4096];
          int len = -1;
          while((len=bis.read(buffer))>-1){
             bos.write(buffer, 0, len);
          }
          
          conn1.setDoOutput(true);
          bis = new BufferedInputStream(conn1.getInputStream());
          buffer = new byte[4096];
          len = -1;
          while((len=bis.read(buffer))>-1){
             bos.write(buffer, 0, len);
          }

          conn2.setDoOutput(true);
          bis = new BufferedInputStream(conn2.getInputStream());
          buffer = new byte[4096];
          len = -1;
          while((len=bis.read(buffer))>-1){
             bos.write(buffer, 0, len);
          }
          
          conn3.setDoOutput(true);
          bis = new BufferedInputStream(conn3.getInputStream());
          buffer = new byte[4096];
          len = -1;
          while((len=bis.read(buffer))>-1){
             bos.write(buffer, 0, len);
          }
          
          conn4.setDoOutput(true);
          bis = new BufferedInputStream(conn4.getInputStream());
          buffer = new byte[4096];
          len = -1;
          while((len=bis.read(buffer))>-1){
             bos.write(buffer, 0, len);
          }
          
          conn5.setDoOutput(true);
          bis = new BufferedInputStream(conn5.getInputStream());
          buffer = new byte[4096];
          len = -1;
          while((len=bis.read(buffer))>-1){
             bos.write(buffer, 0, len);
          }
          
       } catch(IOException e) {
          e.printStackTrace();
          //System.out.println("Unable to Open remote file");
          bis.close();
          bos.flush();
          bos.close();
       } catch(Exception e) {
          e.printStackTrace();
          //System.out.println("Unable to Open remote file");
          bis.close();
          bos.flush();
          bos.close();
       } finally {
    	   bis.close();
    	   bos.flush();
    	   bos.close();
       }		
	}
	
	
	
	/*	MAKE TEMI
	// TODO Auto-generated method stub
		OutputStreamWriter wr = null;
		BufferedReader rd = null;
		File file = new File("C:/Util/MADW") ;
    FileWriter fw = null ;
    
    String	content	=	"";
    
		try {
			URL url = new URL("https://www.miraeassetdaewoo.com/qway/j82oi85g.jsp");
      		URLConnection conn = url.openConnection();
			conn.setDoOutput(true);
			wr = new OutputStreamWriter(conn.getOutputStream());
			//wr.write(data);
			wr.flush();
			// Get the response
			rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "EUC-KR"));
			String line;
			while ((line = rd.readLine()) != null) {
				System.out.println(line);
				content	+=	line;
				content += "\r\n";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		try {
        // open file.
        fw = new FileWriter(file) ;
        // write file.
        fw.write(content) ;

    } catch (Exception e) {
        e.printStackTrace() ;
    }

    // close file.
    if (fw != null) {
			// catch Exception here or throw.
			try {
				fw.close() ;
			} catch (Exception e) {
				e.printStackTrace();
			}
    }
 
	 */
	
}
