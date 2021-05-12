package com.vn.app.commons;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Locale;
import java.util.Random;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 공통 유틸 모음
 * kr.go.mps.milpen.app.common.VNUtil.java
 * @author [VN] 임수석
 * @since : 2016. 07. 05.
 * @version : 1.0
 * <pre>
 * << 개정이력 >>
 * 2016. 07. 05. [VN] 임수석 - 최초생성
 * </pre>
 */
public class VNUtil {
	
	private static final Logger LOG = LoggerFactory.getLogger(VNUtil.class);
	
	/**
	 * VO 캐스팅이 불가능한경우나 VO 멤버변수 값을 복사할때 사용
	 * @param cls	복사 대상 클래스
	 * @param obj	복사할 VO 
	 * @return	복사된 VO Object 로 반환함 받아서 캐스팅 해야함.
	 * <pre>
	 * 2016. 07. 05. [VN] 임수석 - 최초작성
	 * </pre>
	 */
	@SuppressWarnings("rawtypes")
	public static Object getCopyVO(Class cls, Object obj){
		return getCopyVO(cls, obj, null, null);
	}
	
	/**
	 * VO 캐스팅이 불가능한경우나 VO 멤버변수 값을 복사할때 사용
	 * @param cls	복사 대상 클래스
	 * @param obj	복사할 VO
	 * @param setFNms 복사대상 setter 와 복사할 getter 필드명이 다를경우
	 * @param getFNms 복사할 getter 와 복사대상 setter 필드명이 다를경우
	 * @return
	 * <pre>
	 * 2016. 07. 05. [VN] 임수석 - 최초작성
	 * </pre>
	 */
	@SuppressWarnings({"unchecked","rawtypes"})
	public static Object getCopyVO(Class cls, Object obj, List<String> setFNms, List<String> getFNms){
		Method[] methods = null;
		Object returnObj;
		try {
			returnObj = cls.newInstance();
			if(obj==null){
				return returnObj;
			}
			methods = obj.getClass().getMethods();
		} catch (InstantiationException e1) {
			LOG.error("InstantiationException");
			return null;
		} catch (IllegalAccessException e1) {
			LOG.error("IllegalAccessException");
			return null;
		}
		for(Method m : methods){
			String fieldNm = m.getName().substring(3);
			if(m.getName().startsWith("get") && !m.getReturnType().getName().equals("java.lang.Class")){
				Method m2 = null;
				try {
					Object obj2 = m.invoke(obj);
					if(obj2 != null){
						if(getFNms != null){
							for(int i=0; i<getFNms.size(); i++){
								String getFNm = getFNms.get(i);
								if(StringUtils.capitalize(getFNm).equals(fieldNm)){
									fieldNm = StringUtils.capitalize(setFNms.get(i));
								}
							}
						}
						for(Method temp : cls.getMethods()){
							if(temp.getName().equals("set"+fieldNm)){
								m2 = cls.getMethod("set"+fieldNm, m.getReturnType());
								m2.invoke(returnObj, obj2);
								break;
							}
						}
					}
				} catch (NoSuchMethodException e) {
					LOG.debug("NoSuchMethod : "+fieldNm+" agu" +m.getReturnType());
				} catch (SecurityException e) {
					LOG.debug("SecurityException");
				} catch (IllegalAccessException e) {
					LOG.debug("IllegalAccessException");
				} catch (IllegalArgumentException e) {
					LOG.debug("IllegalArgumentException");
				} catch (InvocationTargetException e) {
					LOG.debug("InvocationTargetException");
				}
			}
		}
		return returnObj;
	}
	
	/**
	 * yyyy년MM월dd 형태의 날짜 출력
	 * @return
	 * <pre>
	 * 2016. 07. 05. [VN] 임수석 - 최초작성
	 * </pre>
	 */
	public static String getDate(){		
		Date d = new Date();		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");		
		return sdf.format(d);		
	}
	
	/**
	 * yyyy년MM월dd 형태의 날짜 출력
	 * @return
	 * <pre>
	 * 2016. 07. 05. [VN] 임수석 - 최초작성
	 * </pre>
	 */
	public static String getKoDate(){		
		Date d = new Date();		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월 dd일");		
		return sdf.format(d);		
	}
	
	/**
	 * 현재년도
	 * @return
	 * <pre>
	 * 2016. 07. 05. [VN] 임수석 - 최초작성
	 * </pre>
	 */
    public static int getCurrentYearAsInt() {

        Calendar cd = new GregorianCalendar(Locale.KOREA);

        return cd.get(Calendar.YEAR);
    }
	
	/**
	 * 생년일
	 * @param regNo
	 * @return
	 * <pre>
	 * 2016. 07. 05. [VN] 임수석 - 최초작성
	 * </pre>
	 */
	public static String birthDate(String regNo){
		String iaoRsdtNo = regNo == null ? "" : regNo;
		if(!iaoRsdtNo.equals("") && iaoRsdtNo.length() > 6){			
			iaoRsdtNo = regNo.substring(0,2)+"년"+regNo.substring(2,4)+"월"+regNo.substring(4,6)+"일";
			iaoRsdtNo = regNo.substring(6,7).equals("1") || regNo.substring(6,7).equals("2") ? "19"+iaoRsdtNo : "20"+iaoRsdtNo;
		}
		return iaoRsdtNo;
	}
	
	/**
	 * 년을 월로 변경
	 * @param String yy 년
	 * @return
	 * <pre>
	 * 2016. 07. 05. [VN] 임수석 - 최초작성
	 * </pre>
	 */
	public static int getYyToMm(String yy){
		if(StringUtils.isEmpty(yy))
			return 0;
		return getYyToMm(Integer.parseInt(yy));
	}
	
	/**
	 * 년을 월로 변경
	 * @param int yy 년
	 * @return
	 * <pre>
	 * 2016. 07. 05. [VN] 임수석 - 최초작성
	 * </pre>
	 */
	public static int getYyToMm(int yy){
		if(yy <= 0)
			return 0;
		return yy*12;
	}
	
	/**
	 * 년월을 입력받아 월로 변경
	 * @param int yy 년
	 * @param int mm 월
	 * @return
	 * <pre>
	 * 2016. 07. 05. [VN] 임수석 - 최초작성
	 * </pre>
	 */
	public static int getYymmToMm(int yy,int mm){
		return yy+mm;
	}
	
	/**
	 * 년월을 입력받아 월로 변경
	 * @param String yy 년
	 * @param String mm 월
	 * @return
	 * <pre>
	 * 2016. 07. 05. [VN] 임수석 - 최초작성
	 * </pre>
	 */
	public static int getYymmToMm(String yy,String mm){
		return getYyToMm(yy)+Integer.parseInt(mm);
	}
	
	/**
	 * double to int
	 * @param db
	 * @return
	 * <pre>
	 * 2016. 07. 05. [VN] 임수석 - 최초작성
	 * </pre>
	 */
	public static int getDoubleToInteger(double db){
		return Integer.parseInt(String.valueOf(Math.round(db))); 
	}
	
	/**
	 * UUID를 가져오기 위한 함수
	 * @return
	 * <pre>
	 * 2016. 07. 05. [VN] 임수석 - 최초작성
	 * </pre>
	 */
	public static String getTimeStamp() {

		String rtnStr = null;

		// 문자열로 변환하기 위한 패턴 설정(년도-월-일 시:분:초:초(자정이후 초))
		String pattern = "yyyyMMddhhmmssSSS";

		SimpleDateFormat sdfCurrent = new SimpleDateFormat(pattern, Locale.KOREA);
		Timestamp ts = new Timestamp(System.currentTimeMillis());

		rtnStr = sdfCurrent.format(ts.getTime());

		return rtnStr;
	}
	
	/**
	 * 난수 스트링 생성
	 * @param length 	반환 문자열 길이
	 * @param mix		영문숫자 혼합여부
	 * @return
	 * <pre>
	 * 2016. 07. 05. [VN] 임수석 - 최초작성
	 * </pre>
	 */
	public static String getRandomStr(int length, boolean mix){
		return getRandomStr(length,mix, "");
	}
	
	/**
	 * 난수 스트링 생성
	 * @param length	반환 문자열 길이
	 * @param mix		영문숫자 혼합여부
	 * @param rdmStr	반환 문자열
	 * @return
	 * <pre>
	 * 2016. 07. 05. [VN] 임수석 - 최초작성
	 * </pre>
	 */
	public static String getRandomStr(int length, boolean mix, String rdmStr){
		if(length<0){
			return rdmStr;
		}
		Random r = new Random();
		r.setSeed(length+System.currentTimeMillis());
		if(mix){
			int t = r.nextInt(1000)%2;
			if(length==0){
				if(!rdmStr.matches(".*[A-Z].*")) t = 1;
				if(!rdmStr.matches(".*[0-9].*")) t = 0;
			}
			if(t>0){
				rdmStr += (char)(r.nextInt(26)+65);
			}else{
				rdmStr += r.nextInt(10);
			}
		}else{
			rdmStr += r.nextInt(10);
		}
		return getRandomStr(length-1,mix, rdmStr);
	}
	
	
	
	
	
	
	
	
	
	/**
	 * dd/MM/yyyy the same type as
	 * @return
	 * <pre>
	 * 2016. 09. 19. [VN] TEMI	-	Init
	 * </pre>
	 */
	public static String getCalDate(){		
		Date d = new Date();		
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");		
		return sdf.format(d);		
	}
	
	
	
}