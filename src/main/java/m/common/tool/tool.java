package m.common.tool;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;
import java.util.SimpleTimeZone;
import java.util.StringTokenizer;
import java.util.TimeZone;
import java.util.Vector;
import m.action.IConstants;

/**
 * @author poemlife
 *         poemlife package에서 사용되는 common method, common variable을 정의한다.
 */
public class tool implements IConstants{
	public static final int CENTER	= 0;				//가운데정렬
	public static final int LEFT 	= 1;				//왼쪽정렬
	public static final int RIGHT 	= 2;				//오른쪽 정렬

	
	/**
	 * 주어진 String이 null인지 check한다.
	 *
	 * @param ori
	 * @return
	 */
	public static final boolean isNull(String ori) {
		if (ori == null)
			return true;
		ori = ori.trim();
		if (ori.length() < 1)
			return true;
		if ("null".equals(ori))
			return true;
		return false;
	}// end of isNull();
	
	/**
	 * 주어진 String의 length를 return한다.
	 * @param str
	 * @return
	 */
	public static final int getLength(String str){
		if(str==null)		return 0;
		else				return str.trim().length();
	}//end of getLength();

	/**
	 * 주어진 byte array를 주어진 length로 만든다. 만일 ori.length가 length보다 길면 앞에서부터 잘라서 해당
	 * length로 만들고, 짧으면 lr 부분을 살펴서 lr이 LEFT이면 왼쪽에 filler를 채우고, lr이 RIGHT이면 오른쪽에
	 * filler를 채워서 주어진 length로 만든다.
	 *
	 * @param ori
	 * @param length
	 * @param filler
	 * @param lr
	 * @return
	 */
	public static final byte[] fillbyte(byte[] ori, int length, byte filler, int lr) {
		byte[] result = new byte[length];
		if (ori == null)
			ori = "".getBytes();
		int olen = ori.length;
		int slen = Math.min(olen, length);
		int i = 0;
		if (lr == LEFT) {
			int bet = length - slen;
			for (; i < bet; result[i] = filler, i++)
				;
			for (int s = 0; i < length; result[i] = ori[s++], i++)
				;
		} else {
			for (; i < slen; result[i] = ori[i], i++)
				;
			for (; i < length; result[i] = filler, i++)
				;
		}
		return result;
	}// end of fillbyte();

	/**
	 * 주어진 byte array를 주어진 length로 만든다. 만일 ori.length가 length보다 길면 앞에서부터 잘라서 해당
	 * length로 만들고, 짧으면 lr 부분을 살펴서 lr이 LEFT이면 왼쪽에 filler를 채우고, lr이 RIGHT이면 오른쪽에
	 * filler를 채워서 주어진 length로 만든다. 그 결과를 String type으로 return한다.
	 *
	 * @param ori
	 * @param length
	 * @param filler
	 * @param lr
	 * @return
	 */
	public static final String fillChar(byte[] ori, int length, char filler, int lr) {
		return new String(fillbyte(ori, length, (byte) filler, lr));
	}// end of fillChar();

	/**
	 * 주어진 String을 주어진 length로 만든다. String을 byte array로 만든 다음 fillbyte 과정을 그대로
	 * 반복한다. 만일 ori.length가 length보다 길면 앞에서부터 잘라서 해당 length로 만들고, 짧으면 lr 부분을 살펴서
	 * lr이 LEFT이면 왼쪽에 filler를 채우고, lr이 RIGHT이면 오른쪽에 filler를 채워서 주어진 length로 만든다.
	 * 그 결과를 String type으로 return한다.
	 *
	 * @param ori
	 * @param length
	 * @param filler
	 * @param lr
	 * @return
	 */
	public static final String fillChar(String ori, int length, byte filler,
			int lr) {
		byte[] obyte = null;
		if (ori == null)
			obyte = "".getBytes();
		else
			obyte = ori.getBytes();
		return new String(fillbyte(obyte, length, filler, lr));
	}// end of fillChar();

	/**
	 * 주어진 String을 주어진 length로 만든다. String을 byte array로 만든 다음 fillbyte 과정을 그대로
	 * 반복한다. 만일 ori.length가 length보다 길면 앞에서부터 잘라서 해당 length로 만들고, 짧으면 lr 부분을 살펴서
	 * lr이 LEFT이면 왼쪽에 filler를 채우고, lr이 RIGHT이면 오른쪽에 filler를 채워서 주어진 length로 만든다.
	 * 그 결과를 String type으로 return한다.
	 *
	 * @param ori
	 * @param length
	 * @param filler
	 * @param lr
	 * @return
	 */
	public static final String fillChar(String ori, int length, char filler,
			int lr) {
		byte[] obyte = null;
		if (ori == null)
			obyte = "".getBytes();
		else
			obyte = ori.getBytes();
		return new String(fillbyte(obyte, length, (byte) filler, lr));
	}// end of fillChar();

	/**
	 * 주어진 byte array를 주어진 length로 만든다. 만일 ori.length가 length보다 길면 앞에서부터 잘라서 해당
	 * length로 만들고, 짧으면 lr 부분을 살펴서 lr이 LEFT이면 왼쪽에 filler를 채우고, lr이 RIGHT이면 오른쪽에
	 * filler를 채워서 주어진 length로 만든다. 그 결과를 String type으로 return한다.
	 *
	 * @param ori
	 * @param length
	 * @param filler
	 * @param lr
	 * @return
	 */
	public static final byte[] fillbyte(byte[] ori, int length, byte[] filler,
			int lr) {
		byte[] result = new byte[length];
		if (ori == null)
			ori = "".getBytes();
		int olen = ori.length;
		int i = 0;
		int flen = filler.length;
		int slen = Math.min(olen, length);
		if (lr == LEFT) {
			int bet = length - slen;
			for (int fidx = 0; i < bet; result[i] = filler[fidx++ % flen], i++)
				;
			for (int s = 0; i < length; result[i] = ori[s++], i++)
				;
		} else {
			for (; i < slen; result[i] = ori[i], i++)
				;
			for (int fidx = 0; i < length; result[i] = filler[fidx++ % flen], i++)
				;
		}
		return result;
	}// end of fillbyte();

	/**
	 * 주어진 String을 주어진 length로 만든다. String을 byte array로 만든 다음 fillbyte 과정을 그대로
	 * 반복한다. 만일 ori.length가 length보다 길면 앞에서부터 잘라서 해당 length로 만들고, 짧으면 lr 부분을 살펴서
	 * lr이 LEFT이면 왼쪽에 filler를 채우고, lr이 RIGHT이면 오른쪽에 filler를 채워서 주어진 length로 만든다.
	 * 그 결과를 String type으로 return한다.
	 *
	 * @param ori
	 * @param length
	 * @param filler
	 * @param lr
	 * @return
	 */
	public static final String fillStr(String ori, int length, String filler,
			int lr) {
		if (isNull(ori))
			ori = "";
		if (isNull(filler))
			filler = "";
		return new String(fillbyte(ori.getBytes(), length, filler.getBytes(),
				lr));
	}// end of fillStr();

	/**
	 * 주어진 String의 Encoding Type을 origin에서 result로 바꾼다.
	 *
	 * @param str
	 * @param OriginalEncodingType
	 *            original encoding type
	 * @param ResultEncodingType
	 *            result encoding type
	 * @return result string. Exception이 발생하면 ""을 return한다.
	 */
	public static final String changeEncode(String str,
			String OriginalEncodingType, String ResultEncodingType)
			throws Exception {
		if (isNull(str))
			return "";
		if (isNull(OriginalEncodingType))
			return str;
		if (isNull(ResultEncodingType))
			return str;
		try {
			return new String(str.getBytes(OriginalEncodingType),
					ResultEncodingType);
		} catch (Exception e) {
			throw e;
		}
	}// end of changeEncoding();

	/**
	 * 주어진 String의 encoding type을 KSC5601로 바꾼다.
	 *
	 * @param str
	 * @return
	 */
	public static final String toHangul(String str) {
		try {
			return changeEncode(str, "ISO8859_1", "KSC5601");
		} catch (Exception e) {
			return str;
		}
	}// end of toHangul();

	/**
	 * 주어진 String의 encoding type을 ISO8859_1로 바꾼다.
	 *
	 * @param str
	 * @return
	 */
	public static final String toUnicode(String str) {
		try {
			return changeEncode(str, "KSC5601", "ISO8859_1");
		} catch (Exception e) {
			return str;
		}
	}// end of toUnicode();

	/**
	 * 주어진 String의 byte size를 구한다.
	 *
	 * @param str
	 * @return
	 */
	public static final int getSize(String str) {
		if (isNull(str))
			return 0;
		return str.getBytes().length;
	}// end of getSize();

	/**
	 * 주어진 String이 size보다 크면 size만큼만 자르고, 작으면 그대로 return한다.
	 */
	public static String cut(String str, int size) {
		if (isNull(str))
			return "";
		if (str.length() > size)
			return str.substring(0, size);
		else
			return str;
	}// end of cut();

	/**
	 * 주어진 byte array data의 length를 size로 만든다.
	 *
	 * @param ori
	 * @param size
	 * @param filler
	 * @param af
	 *            origin data의 length가 size보다 작을때, 앞쪽에 filler를 채울 것인지, 뒤쪽에
	 *            filler를 채울 것인지 여부
	 * @return
	 */
	public static final byte[] makeLength(byte[] ori, int size, byte filler,
			int af) {
		if (ori == null)
			ori = "".getBytes();
		if (size < 1)
			return "".getBytes();
		if (ori.length == size)
			return ori;
		if (ori.length < size)
			return fillbyte(ori, size, filler, af);
		byte[] result = new byte[size];
		System.arraycopy(ori, 0, result, 0, size);
		return result;
	}// end of makeLength();

	/**
	 * 주어진 String data의 length를 size로 만든다.
	 *
	 * @param ori
	 * @param size
	 * @param filler
	 * @param af
	 *            origin data의 length가 size보다 작을때, 앞쪽에 filler를 채울 것인지, 뒤쪽에
	 *            filler를 채울 것인지 여부
	 * @return
	 */
	public static final String makeLength(String ori, int size, char filler,
			int af) {
		if (ori == null)
			ori = "";
		return new String(makeLength(ori.getBytes(), size, (byte) filler, af));
	}// end of makeLength();

	/**
	 * 주어진 값을 int type으로 변환한다. 변환할 수 없는 값인 경우, 0를 return한다.
	 *
	 * @param val
	 * @param defValue
	 *            default Value
	 * @return
	 */
	public static final int toInt(String val, int defValue) {
		if (isNull(val))
			return defValue;
		try {
			return Integer.parseInt(val);
		} catch (Exception e) {
			return defValue;
		}
	}// end of toInt();

	/**
	 * 주어진 값을 int type으로 변환한다. 변환할 수 없는 값인 경우, 0를 return한다.
	 *
	 * @param val
	 * @return
	 */
	public static final int toInt(String val) {
		return toInt(val, 0);
	}// end of toInt();

	/**
	 * 주어진 origin String에서 word에 해당하는 단어를 삭제한다.
	 *
	 * @param ori
	 * @param word
	 * @return
	 */
	public static final String removeWord(String ori, String word) {
		StringTokenizer stringtokenizer = new StringTokenizer(ori, word);
		StringBuffer stringbuffer = new StringBuffer();
		for (; stringtokenizer.hasMoreTokens(); stringbuffer.append(stringtokenizer.nextToken()));
		return stringbuffer.toString();
	}// end of removeWord();


	/**
	 * 오늘 날짜를 YYYYMMDD 형태로 구한다.
	 *
	 * @return
	 */
	public static final String getToday() {
		return (new java.text.SimpleDateFormat("yyyyMMdd")).format(new java.util.Date());
	}// end of getToday();

	/**
	 * 오늘 날짜를 YYYYMMDD 형태로 구한다.
	 *
	 * @return
	 */
	public static final String getCurrentTime() {
		return (new java.text.SimpleDateFormat("yyyyMMddHHmmss")).format(new java.util.Date());
	}// end of getCurrentTime();

	/**
	 * 오늘 날짜를 YYYYMMDD 형태로 구한다.
	 *
	 * @return
	 */
	public static final String getCurrentFormatedTime() {
		return (new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss")).format(new java.util.Date());
	}// end of getCurrentTime();

	
	public static final String getToday(char sep) {
		return (new java.text.SimpleDateFormat("yyyy" + sep + "MM" + sep + "dd")).format(new java.util.Date());
	}// end of getToday();

	public static final String getToday(String sep) {
		return (new java.text.SimpleDateFormat("yyyy" + sep + "MM" + sep + "dd")).format(new java.util.Date());
	}// end of getToday();

	/**
	 * 오늘 날짜를 YYYYMMDD 형태로 구한다.
	 *
	 * @return
	 */
	public static final String getCurrentDate() {
		return (new java.text.SimpleDateFormat("yyyyMMdd"))
				.format(new java.util.Date());
	}// end of getCurrentDate();

	/**
	 * 주어진 original date로부터 move만큼 지난 날의 날짜를 구한다.
	 *
	 * @param ori
	 * @param move
	 *            이동한 날짜. 전이면 마이너스로 입력.
	 * @param sep
	 *            년월일 사이에 들어갈 구분자.
	 * @return
	 */
	public static final String getNextDate(String ori, int move, String sep) {
		if (ori.length() < 8)
			return ori;
		String odate = removeWord(ori, sep);
		Calendar cal = Calendar.getInstance();
		String syear = odate.substring(0, 4);
		String smon = odate.substring(4, 6);
		String sdate = odate.substring(6, 8);
		int iyear = 0, imon = 0, idate = 0;
		try {
			iyear = Integer.parseInt(syear);
			imon = Integer.parseInt(smon);
			idate = Integer.parseInt(sdate);
		} catch (Exception e) {
			return ori;
		}
		cal.set(iyear, imon - 1, idate + move);
		int yy = cal.get(Calendar.YEAR);
		int mm = cal.get(Calendar.MONTH) + 1;
		int dd = cal.get(Calendar.DATE);
		StringBuffer result = new StringBuffer().append(yy).append(sep);
		if (mm < 10)
			result.append(0).append(mm).append(sep);
		else
			result.append(mm).append(sep);
		if (dd < 10)
			result.append(0).append(dd);
		else
			result.append(dd);
		return result.toString();
	}// end of getNextDate();

	/**
	 * 주어진 original date로부터 move만큼 지난 날의 날짜를 구한다.
	 *
	 * @param ori
	 * @param move
	 *            이동한 날짜. 전이면 마이너스로 입력.
	 * @return
	 */
	public static final String getNextDate(String ori, int move) {
		return getNextDate(ori, move, "");
	}// end of getNextDate();

	/**
	 * 주어진 original date로부터 move개월만큼 지난 날의 날짜를 구한다.
	 *
	 * @param ori
	 * @param move
	 *            이동한 개월 수. 전이면 마이너스로 입력.
	 * @param sep
	 *            년월일 사이에 들어갈 구분자.
	 * @return
	 */
	public static final String getNextMonth(String ori, int move, String sep) {
		if (ori.length() < 8)
			return ori;
		String odate = removeWord(ori, sep);
		Calendar cal = Calendar.getInstance();
		String syear = odate.substring(0, 4);
		String smon = odate.substring(4, 6);
		String sdate = odate.substring(6, 8);
		int iyear = 0, imon = 0, idate = 0;
		try {
			iyear = Integer.parseInt(syear);
			imon = Integer.parseInt(smon);
			idate = Integer.parseInt(sdate);
		} catch (Exception e) {
			return ori;
		}
		cal.set(iyear, imon - 1 + move, idate);
		int yy = cal.get(Calendar.YEAR);
		int mm = cal.get(Calendar.MONTH) + 1;
		int dd = cal.get(Calendar.DATE);
		StringBuffer result = new StringBuffer().append(yy).append(sep);
		if (mm < 10)
			result.append(0).append(mm).append(sep);
		else
			result.append(mm).append(sep);
		if (dd < 10)
			result.append(0).append(dd);
		else
			result.append(dd);
		return result.toString();
	}// end of getNextMonth();

	/**
	 * 주어진 original date로부터 move개월만큼 지난 날의 날짜를 구한다.
	 *
	 * @param ori
	 * @param move
	 *            이동한 개월 수. 전이면 마이너스로 입력.
	 * @param sep
	 *            년월일 사이에 들어갈 구분자.
	 * @return
	 */
	public static final String getNextMonth(String ori, int move) {
		return getNextMonth(ori, move, "");
	}// end of getNextMonth();

	/**
	 * 주어진 String을 날짜 format으로 만들어 return한다.
	 *
	 * @param str
	 * @param sep
	 *            date format으로 만들때 사용할 구분
	 * @return
	 */
	public static final String getDateFormat(String str, char sep) {
		if (isNull(str))
			return str;
		str = removeWord(str, "/");
		str = removeWord(str, "-");
		str = str.trim();
		int len = str.length();
		if (len < 5)
			return str;
		if (len < 7)
			return str.substring(0, 4) + sep + str.substring(4, 6);
		if (len < 9)
			return str.substring(0, 4) + sep + str.substring(4, 6) + sep
					+ str.substring(6, 8);
		return str;
	}// end of getDateFormat();

	/**
	 * 주어진 String을 날짜 format으로 만들어 return한다.
	 *
	 * @param str
	 * @param sep
	 *            date format으로 만들때 사용할 구분
	 * @return
	 */
	public static final String getTimeFormat(String str, char sep) {
		if (isNull(str))
			return str;
		str = removeWord(str, "/");
		str = removeWord(str, "-");
		str = str.trim();
		int len = str.length();
		if (len < 5)
			return str;
		if (len < 7)
			return str.substring(0, 4) + sep + str.substring(4, 6);
		if (len < 9)
			return str.substring(0, 4) + sep + str.substring(4, 6) + sep
					+ str.substring(6, 8);
		if (len > 13)
			return str.substring(0, 4) + sep + str.substring(4, 6) + sep
					+ str.substring(6, 8) + " " + str.substring(8, 10) + ":"
					+ str.substring(10, 12) + ":" + str.substring(12, 14);
		return str;
	}// end of getDateFormat();

	/**
	 * 주어진 cfg 파일을 읽어서 설정들을 가져온다.
	 *
	 * @param cfg
	 * @return
	 */
	public static final Properties readProperties(String cfg) {
		Properties userProperties = new Properties();
		try {
			userProperties.load(new FileInputStream(new File(cfg)));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return userProperties;
	}// end of userProperties();

	/**
	 * cfg 파일을 기록한다.
	 *
	 * @param cfg
	 *            : 파일경로, attribtue :설정이름, value : 설정값, header : cfg주석(설명)
	 * @return
	 */

	public static final Properties writeProperties(String cfg,
			String attribute, String value, String header) {
		Properties userProperties = new Properties();
		try {
			userProperties.setProperty(attribute, value);
			FileOutputStream out = new FileOutputStream(cfg);
			userProperties.store(out, header);
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return userProperties;
	}// end of userProperties();

	/**
	 * 파일을 기록합니다.
	 *
	 * @param write
	 * @addwrite true : add, false: new
	 */
	public static final void writeFile(String filePath, String file,
			boolean addwrite) {
		try {
			FileWriter fos = new FileWriter(filePath, addwrite);
			fos.write(file);
			fos.write("\n");
			fos.close();
		} catch (IOException e) {
			System.err.println(e);
			System.exit(1);
		}
	}// end of writeFile();

	/**
	 * 주어진 String에 주어진 term마다 char를 insert시킨다.
	 *
	 * @param str
	 * @param term
	 * @param chr
	 *            채울 Char
	 * @param lr
	 *            앞에서부터 채울 것인지, 뒤에서부터 채울 것인지여부.
	 * @return
	 */
	public static final String repeatChar(String str, int term, char chr, int lr) {
		StringBuffer sb = new StringBuffer();
		if (str == null)
			return "";
		if (term < 1)
			return str;
		if (str.length() < term)
			return str;
		if (lr == LEFT) { // 왼쪽부터 term마다 채우기.
			int i = 0;
			int size = str.length() - term;
			for (; i < size; i += term) {
				sb.append(str.substring(i, i + term)).append(chr);
			}
			sb.append(str.substring(i));
		} else { // 오른쪽부터 term마다 채우기
			int size = str.length() - term;
			int j = size % term;
			if (j != 0)
				sb.append(str.substring(0, j)).append(chr);
			int i = j;
			for (; i < size; i += term) {
				sb.append(str.substring(i, i + term)).append(chr);
			}
			sb.append(str.substring(i));
		}
		return sb.toString();
	}// end of repeatChar();

	/**
	 * 주어진 String을 금액 포맷으로 바꾼다. ('-' 이면서 3자리일때 '-,'로 찍히는 버그 수정 : 2006. 11. 24
	 * 박성우) 단, 소숫점 이하는 제외한다.
	 *
	 * @param str
	 * @return
	 */
	public static final String formatComma(String str) {
		int index = str.indexOf(".");
		if (index > -1) {
			return repeatChar(String.valueOf(Long.parseLong(removeWord(str
					.substring(0, index), ","))), 3, ',', RIGHT)
					+ str.substring(index);
		} else {
			return repeatChar(String.valueOf(Long
					.parseLong(removeWord(str, ","))), 3, ',', RIGHT);
		}
	}// end of formatComma();

	/**
	 * 주어진 String을 금액 포맷으로 바꾼다. 단, 소숫점 이하는 제외한다.
	 *
	 * @param str
	 * @param point
	 * @return
	 */
	public static final String formatComma(String str, int point) {
		if (isNull(str))
			return str;
		int index = str.length() - point;
		if (index > 0) {
			return repeatChar(String.valueOf(Long.parseLong(removeWord(str
					.substring(0, index), ","))), 3, ',', RIGHT)
					+ "." + str.substring(index);
		} else {
			return repeatChar(String.valueOf(Long
					.parseLong(removeWord(str, ","))), 3, ',', RIGHT);
		}
	}// end of formatComma();

	/**
	 * 날짜 포맷으로 바꿔서 return한다.
	 */
	public static final String changeDateFormat(String date) {
		return getDateFormat(date, '/');
	}// end of changeDateFormat();

	/**
	 * 두 byte array를 합친다.
	 *
	 * @param ori
	 *            original byte array
	 * @param arr
	 *            합칠 byte array
	 * @param sidx
	 *            합칠때 arr의 start index
	 * @param len
	 *            arr중에서 실제 합칠 length
	 */
	public static final byte[] append(byte[] ori, byte[] arr, int sidx, int len) {
		if (ori == null) {
			if (arr == null) {
				return new byte[len];
			} else {
				byte[] result = new byte[len];
				if (arr.length < sidx) {
					return result;
				} else if (arr.length - sidx < len) {
					System.arraycopy(arr, sidx, result, 0, arr.length - sidx);
					return result;
				} else {
					System.arraycopy(arr, sidx, result, 0, len);
					return result;
				}
			}
		} else {
			if (arr == null) {
				return ori;
			} else {
				byte[] result = new byte[ori.length + len];
				System.arraycopy(ori, 0, result, 0, ori.length);
				if (arr.length < sidx) {
					return result;
				} else if (arr.length - sidx < len) {
					System.arraycopy(arr, sidx, result, ori.length, arr.length
							- sidx);
					return result;
				} else {
					System.arraycopy(arr, sidx, result, ori.length, len);
					return result;
				}
			}
		}
	}// end of append();

	/**
	 * 두 byte array를 합친다.
	 *
	 * @param ori
	 *            original byte array
	 * @param arr
	 *            합칠 byte array
	 */
	public static final byte[] append(byte[] ori, byte[] arr) {
		if (arr == null) {
			return ori;
		} else {
			return append(ori, arr, 0, arr.length);
		}
	}// end of append();

	/**
	 * 두 byte array를 합친다.
	 *
	 * @param ori
	 *            original byte array
	 * @param arr
	 *            합칠 byte
	 */
	public static final byte[] append(byte[] ori, byte arr) {
		return append(ori, new byte[] { arr });
	}// end of append();

	/**
	 * 주어진 String에서 소수점 이상의 자리에 대해서만 comma를 찍는다.
	 */
	public static final String makeDot(String str) {
		if (isNull(str))
			return "0";
		str = removeWord(str.trim(), ",");
		int idx = str.indexOf(".");
		if (str.length() < 1)
			return "0";
		char buho = str.charAt(0);
		String num = "0123456789";
		boolean isNum = num.indexOf(buho) > -1;
		if (idx < 0) {
			if (isNum)
				return formatComma(str);
			else
				return buho + formatComma(str.substring(1));
		} else if (idx == 0) {
			return "0" + str;
		} else {
			String dot = str.substring(idx + 1);
			if (isNum) {
				if (idx == 0)
					return "0." + dot;
				else
					return formatComma(str.substring(0, idx)) + "." + dot;
			} else {
				if (idx == 0 || idx == 1)
					return buho + "0." + dot;
				else
					return buho + formatComma(str.substring(1, idx)) + "."
							+ dot;
			}
		}
	}// end of makeDot();

	/**
	 * 주어진 String에서 소수점 이하 자리수를 맞춘다.
	 */
	public static final String makeDot(String str, int size) {
		if (isNull(str))
			return fillChar("0.", size + 2, '0', RIGHT);
		str = removeWord(str.trim(), ",");
		int idx = str.indexOf(".");
		if (idx < 0) {
			String dot = "0";
			return formatComma(str) + "." + fillChar(dot, size, '0', RIGHT);
		} else {
			String dot = str.substring(idx + 1);
			return formatComma(str.substring(0, idx)) + "."
					+ fillChar(dot, size, '0', RIGHT);
		}
	}// end of makeDot();

	/**
	 * 주어진 String에서 소수점 이하 자리수를 맞춘다. origin number가 소숫점이 없으면 해당 size만큼을 확보하여
	 * 소숫점을 만든다.
	 *
	 * @param str
	 *            origin number
	 * @param size
	 *            소수점 이하 자리수
	 */
	public static final String makeDot2(String str, int size) {
		if (isNull(str))
			return fillChar("0.", size + 2, '0', RIGHT);
		str = removeWord(str.trim(), ",");
		int idx = str.indexOf(".");
		if (idx < 0) {
			if (str.length() > size) {
				return formatComma(str.substring(0, str.length() - size))
						+ "."
						+ fillChar(str.substring(str.length() - size), size,
								'0', RIGHT);
			} else {
				return "0." + fillChar(str, size, '0', RIGHT);
			}

		} else {
			String dot = str.substring(idx + 1);
			return formatComma(str.substring(0, idx)) + "."
					+ fillChar(dot, size, '0', RIGHT);
		}
	}// end of makeDot2();

	
	/**
	 * 주어진 String에서 소수점 이하 자리수를 맞춘다. origin number가 소숫점이 없으면 해당 size만큼을 확보하여
	 * 소숫점을 만든다. 단 자리수와 0의 숫자가 같다면 표시하지 않는다.
	 *
	 * @param str
	 *            origin number
	 * @param size
	 *            소수점 이하 자리수
	 */
	public static final String makeDot3(String str, int size) {
		String temp = "";
		
		if (isNull(str))
			return fillChar("0.", size + 2, '0', RIGHT);
		str = removeWord(str.trim(), ",");
		int idx = str.indexOf(".");
		if (idx < 0) {
			if (str.length() > size) {
				temp = "."+fillChar(str.substring(str.length() - size), size, '0', RIGHT);
				if( ".00000".equals(temp) || ".0000".equals(temp) || ".000".equals(temp) || ".00".equals(temp) ){
					temp = "";
				}
				return formatComma(str.substring(0, str.length() - size))+temp;
			} else {
				temp = "."+fillChar(str, size, '0', RIGHT);
				if( ".00000".equals(temp) || ".0000".equals(temp) || ".000".equals(temp) || ".00".equals(temp) ){
					temp = "";
				}
				return "0" + temp;
			}

		} else {
			String dot = str.substring(idx + 1);
			temp = "." + fillChar(dot, size, '0', RIGHT);
			if( ".00000".equals(temp) || ".0000".equals(temp) || ".000".equals(temp) || ".00".equals(temp) ){
				temp = "";
			}
			return formatComma(str.substring(0, idx)) + temp;
		}
	}

	// price가 들어오면 - 이면 font color 를 blue로, + 이면 red로 바꿔줍니다.
	// decimalformat 형식
	public static final String getFontColor(String inNum, String form) {
		java.text.DecimalFormat df = new java.text.DecimalFormat(form);
		if (inNum != null) {
			if (inNum.trim().substring(0, 1).equals("-")) {
				inNum = String.valueOf(df.format(Double.parseDouble(inNum
						.substring(1))));
				inNum = "<font color=blue> -" + inNum + "</font>";
			} else if (inNum.trim().substring(0, 1).equals("+")) {
				inNum = inNum.substring(1);
				inNum = String.valueOf(df.format(Double.parseDouble(inNum
						.substring(1))));
				inNum = "<font color=red> +" + inNum + "</font>";
			} else {
				inNum = String.valueOf(df.format(Double.parseDouble(inNum
						.substring(0))));
				inNum = "<font color=black> +" + inNum + "</font>";
			}
			return inNum;
		} else {
			return "";
		}
	}

	
	/**
	* ���� ����� ������ ó���Ѵ�.
	*
	* @param deabi ���
	* @return ���ϴ�񿡼� ������ �����Ѵ�.
	*/
	public static String getColor(String bit)	{
		String color = "";
		
		if( bit.equals("1"))	{
			color = "red";
		}
		else if( bit.equals("2"))	{
			color = "red";
		}
		else if( bit.equals("4") )	{
			color = "blue";
		}
		else if( bit.equals("5") )	{
			color = "blue";
		}
		else{
			color = "black";
		}
		return color;
	}
	/**
	* ���� ����� ������ ó���Ѵ�.
	*
	* @param deabi ���
	* @return ���ϴ�񿡼� ������ �����Ѵ�.
	*/
	public static String getColor2(String bit)	{
		String color = "";
		if( bit.equals("+"))	{
			color = "red";
		}
		else if( bit.equals("-") )	{
			color = "blue";
		}
		else{
			color = "black";
		}
		return color;
	}

	
	/**
	* ���� ����� ������ ó���Ѵ�.
	*
	* @param deabi ���
	* @return ���ϴ�񿡼� ������ �����Ѵ�.
	*/
	public static String getGiho(String bit)	{
		String color = "";
		
		if( bit.equals("1"))	{
			color = "<img src='/images/icon/up.jpg' alt='��' />";
		}
		else if( bit.equals("2"))	{
			color = "<img src='/images/icon/up.jpg' alt='��' />";
		}
		else if( bit.equals("4") )	{
			color = "<img src='/images/icon/down.jpg' alt='��' />";
		}
		else if( bit.equals("5") )	{
			color = "<img src='/images/icon/down.jpg' alt='��' />";
		}
		else{
			color = "";
		}
		return color;
	}	
	
	/**
	 * 주어진 original date로부터 move만큼 지난 날의 날짜를 구한다.
	 *
	 * @param ori
	 * @param move
	 *            이동한 날짜. 전이면 마이너스로 입력.
	 * @param sep
	 *            년월일 사이에 들어갈 구분자.
	 * @return
	 */
	public static final String getNextMinute(String ori, int move) {
		if (ori.length() < 14)
			return ori;
		String odate = removeWord(ori, "/");
		odate = removeWord(ori, "-");
		odate = removeWord(ori, ":");
		odate = removeWord(ori, " ");

		Calendar cal = Calendar.getInstance();
		String syear = odate.substring(0, 4);
		String smon = odate.substring(4, 6);
		String sdate = odate.substring(6, 8);
		String shour = odate.substring(8, 10);
		String smin = odate.substring(10, 12);
		String ssec = odate.substring(12, 14);
		int iyear = 0, imon = 0, idate = 0, ihour = 0, imin = 0, isec = 0;
		try {
			iyear = Integer.parseInt(syear);
			imon = Integer.parseInt(smon);
			idate = Integer.parseInt(sdate);
			ihour = Integer.parseInt(shour);
			imin = Integer.parseInt(smin);
			isec = Integer.parseInt(ssec);
		} catch (Exception e) {
			return ori;
		}
		cal.set(iyear, imon - 1, idate, ihour, imin + 1, isec);
		int yy = cal.get(Calendar.YEAR);
		int mm = cal.get(Calendar.MONTH) + 1;
		int dd = cal.get(Calendar.DATE);
		int hh = cal.get(Calendar.HOUR_OF_DAY);
		int MM = cal.get(Calendar.MINUTE);
		int ss = cal.get(Calendar.SECOND);
		StringBuffer result = new StringBuffer().append(yy);
		if (mm < 10)
			result.append(0).append(mm);
		else
			result.append(mm);
		if (dd < 10)
			result.append(0).append(dd);
		else
			result.append(dd);
		if (hh < 10)
			result.append(0).append(hh);
		else
			result.append(hh);
		if (MM < 10)
			result.append(0).append(MM);
		else
			result.append(MM);
		if (ss < 10)
			result.append(0).append(ss);
		else
			result.append(ss);
		return result.toString();
	}// end of getNextMinute();

	/**
	 * 주어진 날짜로 Setting된 Calendar Object를 return한다.
	 *
	 * @param date
	 *            날짜. yyyymmdd 형태로 주어야 함.
	 * @return Calendar yyyyMMdd 가 Setting된 Calendar Object
	 */
	public static Calendar getCalendar(String date) {
		if (tool.isNull(date) || date.trim().length() < 8)
			return null;
		Calendar cal = Calendar.getInstance();
		try {
			cal.set(Integer.parseInt(date.substring(0, 4)), Integer
					.parseInt(date.substring(4, 6)) - 1, Integer.parseInt(date
					.substring(6, 8)));
			return cal;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}// end of getCalendar();

	/**
	 * 두 날짜가 몇일 사이인지를 계산한다. 이때, 같은 날짜라면 1이 return된다.
	 *
	 * @param from
	 *            yyyyMMdd 형태의 String
	 * @param to
	 *            yyyyMMdd 형태의 String
	 * @return 두 날짜 사이의 간격. 같은 날짜라면 1을 return한다. 만약 20070101과 20070103이면 3을
	 *         return한다.(from, to가 포함된 날짜를 return한다.)
	 */
	public static int getDateCount(String from, String to) {
		Calendar fcal = getCalendar(from);
		Calendar tcal = getCalendar(to);
		if (fcal == null || tcal == null)
			return 0;
		if (fcal.before(tcal)) {
			int i = 0;
			for (; true; i++) {
				if (fcal.equals(tcal))
					return i;
				fcal.add(Calendar.DATE, 1);
			}
		} else {
			int i = 0;
			for (; true; i--) {
				if (fcal.equals(tcal))
					return i;
				fcal.add(Calendar.DATE, -1);
			}
		}
	}// end of getDateCount();

	/**
	 * 주어진 Calendar 객체의 시간을 String으로 변환한다.
	 *
	 * @param cal
	 *            Calendar Object
	 * @param sep
	 *            구분자(/, -)
	 * @return yyyy/MM/dd 형태의 날짜 String. sep에 따라 2007/01/01, 2007-01-01,
	 *         20070101 형태로 return할 수 있다.
	 */
	public static String getDateString(Calendar cal, String sep) {
		if (cal == null)
			return "";
		int yy = cal.get(Calendar.YEAR);
		int mm = cal.get(Calendar.MONTH) + 1;
		int dd = cal.get(Calendar.DATE);
		StringBuffer result = new StringBuffer().append(yy).append(sep);
		if (mm < 10)
			result.append(0).append(mm).append(sep);
		else
			result.append(mm).append(sep);
		if (dd < 10)
			result.append(0).append(dd);
		else
			result.append(dd);
		return result.toString();
	}// end of getDateString();

	/**
	 * 주어진 Calendar 객체의 시간을 String으로 변환한다.
	 *
	 * @param cal
	 *            Calendar Object
	 * @return yyyyMMdd 형태의 날짜 String
	 */
	public static String getDateString(Calendar cal) {
		return getDateString(cal, "");
	}// end of getDateString();

	/**
	 * 주어진 두 날짜가 몇일 차이인지 구한다. 만약 동일한 날짜라면 날짜 차이가 없기 때문에 0이 된다.
	 *
	 * @param from
	 *            yyyyMMdd 형태의 String
	 * @param to
	 *            yyyyMMdd 형태의 String
	 */
	public static int countDates(String from, String to) throws Exception {
		int count = 0;
		Calendar fcal = getCalendar(from);
		Calendar tcal = getCalendar(to);
		if (fcal == null) {
			throw new Exception(
					"Invalid Date Format!!! From Date is not valid[" + from
							+ "]");
		}
		if (tcal == null) {
			throw new Exception("Invalid Date Format!!! To Date is not valid["
					+ to + "]");
		}
		if (fcal.before(tcal)) {
			for (; true; count++) {
				if (fcal.equals(tcal)) {
					break;
				}
				fcal.add(Calendar.DATE, 1);
			}
		} else {
			for (; true; count++) {
				if (fcal.equals(tcal)) {
					break;
				}
				tcal.add(Calendar.DATE, 1);
			}
		}
		return count;
	}// end of countDates();

	/**
	 * 주어진 두 날짜 사이에 있는 날짜들을 구한다.
	 *
	 * @param from
	 *            yyyyMMdd 형태의 String
	 * @param to
	 *            yyyyMMdd 형태의 String
	 */
	public static Vector<String> betweenDates(String from, String to) {
		Vector<String> dates = new Vector<String>();
		Calendar fcal = getCalendar(from);
		Calendar tcal = getCalendar(to);
		if (fcal == null || tcal == null)
			return dates;
		if (fcal.before(tcal)) {
			int i = 0;
			for (; true; i++) {
				dates.addElement(getDateString(fcal));
				if (fcal.equals(tcal)) {
					break;
				}
				fcal.add(Calendar.DATE, 1);
			}
		} else {
			int i = 0;
			for (; true; i++) {
				dates.addElement(getDateString(tcal));
				if (fcal.equals(tcal)) {
					break;
				}
				tcal.add(Calendar.DATE, 1);
			}
		}
		return dates;
	}// end of betweenDates();

	/**
	 * 두 날짜 사이에 큰 날짜를 구한다.
	 *
	 * @param date1
	 *            날짜1. yyyyMMdd type
	 * @param date2
	 *            날짜1. yyyyMMdd type
	 */
	public static String getMaxDate(String date1, String date2) {
		if (tool.isNull(date1))
			date1 = "";
		if (tool.isNull(date2))
			date2 = "";
		if (date1.compareTo(date2) < 0) {
			return date2;
		} else {
			return date1;
		}
	}// end of getMaxDate();

	/**
	 * 두 날짜 사이에 작은 날짜를 구한다.
	 *
	 * @param date1
	 *            날짜1. yyyyMMdd type
	 * @param date2
	 *            날짜1. yyyyMMdd type
	 */
	public static String getMinDate(String date1, String date2) {
		if (tool.isNull(date1))
			date1 = "";
		if (tool.isNull(date2))
			date2 = "";
		if (date1.length() < 8) {
			if (date2.length() < 8)
				return "";
			else
				return date2;
		} else {
			if (date2.length() < 8)
				return date1;
		}
		if (date1.compareTo(date2) < 0) {
			return date1;
		} else {
			return date2;
		}
	}// end of getMinDate();

	/**
	 * 오늘을 기준으로 이전달의 마지막 날짜를 구한다.
	 */
	public static String getLastMonthDay() {
		String lastDay = "";
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.MONTH, -1);
		lastDay = cal.get(Calendar.YEAR)
				+ dateToString(cal.get(Calendar.MONTH) + 1)
				+ cal.getActualMaximum(Calendar.DAY_OF_MONTH);
		return lastDay;
	}

	/**
	 * 날짜폼 입력시 일의 숫자가 10일보다 작으면 0을 붙여준다.
	 */
	public static String dateToString(int day) {
		if (day > 9) {
			return "" + day;
		} else {
			return "0" + day;
		}
	}

	/**
	 * 주어진 범위 내의 Random int value를 구한다.
	 *
	 * @param st
	 *            범위 시작
	 * @param ed
	 *            범위 끝
	 * @return
	 */
	public static int getRandomNumber(int st, int ed) {
		int result = (int) Math.floor(Math.random() * ed) + st;
		if (result > ed)
			result = ed;
		return result;
	}// end of Random();

	/**
	 * http://localhost:8080/admin/index.jsp -> index.jsp : 없음
	 *
	 * @param url
	 * @return
	 */
	public static String getURL(StringBuffer url) {
		return getURL(url.toString());
	}// end of getURL();

	/**
	 * http://localhost:8080/admin/index.jsp -> index.jsp : 없음
	 *
	 * @param url
	 * @return
	 */
	public static String getURL(String url) {
		if (url.lastIndexOf('/') > 0)
			return url.substring(url.lastIndexOf("/") + 1);
		return "";
	}// end of getURL();

	/**
	 * http://localhost:8080/admin/index.jsp -> /admin/index.jsp : 없음
	 *
	 * @param url
	 * @return
	 */
	public static String getPathURL(StringBuffer url) {
		return getPathURL(url.toString());
	}// end of getPathURL();

	/**
	 * http://localhost:8080/admin/index.jsp -> /admin/index.jsp
	 *
	 * @param url
	 * @return
	 */
	public static String getPathURL(String url) {
		if (url.indexOf('/') > 8)
			return url.substring(url.indexOf("/", 8));
		return "";
	}// end of getPathURL();

	/**
	 * Null String Convert : 없음
	 */
	public String NVL(String str1) {
		return NVL(str1, "");
	}// end of NVL();

	/**
	 * Null String Convert
	 *
	 * @param str1
	 * @param str2
	 * @return
	 */
	public String NVL(String str1, String str2) {
		String result = str1;
		if (str1 == null) {
			result = str2;
		}
		return result;
	}

	public static boolean makeDateDir(String path) {
		String today = getToday();
		return makeDir(path, today.substring(0, 4), today.substring(4, 6),
				today.substring(6, 8));
	}

	/**
	 * 특정 directory 아래에 년/월/일로 된 subdirectory를 생성한다.
	 *
	 * @param path
	 *            년/월/일 subdirectory를 생성할 directory 위치.
	 * @param year
	 *            년
	 * @param month
	 *            월
	 * @param date
	 *            일
	 * @return directory 생성이 성공하면 true, 실패하면 false를 return한다.
	 */
	public static boolean makeDir(String path, String year, String month, String date) {
		if (tool.isNull(path))			return false;
		try {
			boolean success = makeDir(path);
			success = success && makeDir(path + '/' + year);
			success = success && makeDir(path + '/' + year + '/' + month);
			success = success
					&& makeDir(path + '/' + year + '/' + month + "/" + date);
			return success;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}// end of makeDir();

	/**
	 * 주어진 path의 directory를 생성한다. 단, 절대경로가 /actus/web/docroot/ 아래만 가능하다.
	 *
	 * @param path
	 *            년/월/일 subdirectory를 생성할 directory 위치.
	 * @param year
	 * @return directory 생성이 성공하면 true, 실패하면 false를 return한다.
	 */
	public static boolean makeDir(String path) {
		if (tool.isNull(path))			return false;
		try {
			File file = new File(path);
			if (file.exists()) 			return true;
			else 						return file.mkdir();
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}// end of makeDir();

	/**
	 *
	 * @param num
	 * @param index
	 * @param startPoint
	 * @return
	 */
	public static String getNumberFormat(String num, int index,
			boolean startPoint) {
		if (isNull(num))
			return "";
		if (num.length() < index)
			return num;
		if (startPoint)
			return tool.makeDot(num.substring(0, num.length() - index));
		else
			return tool.makeDot(num.substring(0, num.length() - index)) + "."
					+ num.substring(num.length() - index);
	}

	public static String getNumberFormat2(String num, int index) {
		String zeroIn = "";
		for (int i = 0; i < index; i++) {
			zeroIn = zeroIn + "0";
		}
		if (isNull(num))
			return "";
		if (num.length() < index)
			return num;
		String numIndex = num.substring(num.length() - index);
		if (numIndex.equals(zeroIn))
			return tool.makeDot(num.substring(0, num.length() - index));
		else
			return tool.makeDot(num.substring(0, num.length() - index)) + "."
					+ num.substring(num.length() - index);
	}

	/**
	 * 계좌번호가 연달아 들어올때 00133111111 이런 식이면 폼에 맞게 001-33-111111 변환하여 돌려준다. 미래에셋 계좌만
	 * 해당된다.
	 *
	 * @param path
	 * @param year
	 * @return directory
	 */
	public static String accForm(String AccountNo) {
		if (isNull(AccountNo)) {
			return AccountNo;
		} else if (AccountNo.length() < 11) {
			return AccountNo;
		}
		return AccountNo.substring(0, 3) + "-" + AccountNo.substring(3, 5)
				+ "-" + AccountNo.substring(5, 11);
	}

	/**
	 * 두개의 배열을 하나로 합쳐준다.
	 *
	 * @param array1
	 *            첫번째 배열
	 * @param array2
	 *            두번째 배열
	 * @return 두개의 배열을 합한 새로운 배열
	 */
	public static byte[] concat(byte[] array1, byte[] array2) {
		if (array1 == null)
			return array2;
		if (array2 == null)
			return array1;
		byte[] result = new byte[array1.length + array2.length];
		System.arraycopy(array1, 0, result, 0, array1.length);
		System.arraycopy(array2, 0, result, array1.length, array2.length);
		return result;
	}// end of concat();

	public static final byte byteValue(String val, byte defValue) {
		if (tool.isNull(val)) {
			return defValue;
		}
		val = val.toLowerCase();
		if (val.startsWith("0x")) { // hexa String인 경우
			if (val.length() < 4) {
				return defValue;
			} else {
				char a = val.charAt(2);
				int i = 0;
				switch (a) {
				case 'a':
					i = 10;
					break;
				case 'b':
					i = 11;
					break;
				case 'c':
					i = 12;
					break;
				case 'd':
					i = 13;
					break;
				case 'e':
					i = 14;
					break;
				case 'f':
					i = 15;
					break;
				default:
					i = Integer.parseInt(String.valueOf(a));
				}
				i *= 16;
				char b = val.charAt(3);
				switch (b) {
				case 'a':
					i += 10;
					break;
				case 'b':
					i += 11;
					break;
				case 'c':
					i += 12;
					break;
				case 'd':
					i += 13;
					break;
				case 'e':
					i += 14;
					break;
				case 'f':
					i += 15;
					break;
				default:
					i += Integer.parseInt(String.valueOf(b));
				}
				return (byte) i;
			}
		} else {
			try {
				int i = Integer.parseInt(val);
				return (byte) i;
			} catch (Exception e) {
				return defValue;
			}
		}
	}// end of byteValue();

	public static final byte byteValue(String val) {
		return byteValue(val, (byte) 0x20);
	}// end of byteValue();
	
	/**
	 * 현재날짜를 지정된 포맷으로 만들어 리턴
	 * @param format
	 */
	public static String nowDateFormat(String format) {
		String date=null;

		try	{
			TimeZone tz = new SimpleTimeZone( 9 * 60 * 60 * 1000, "KST" );
			TimeZone.setDefault(tz);
			Date d = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat(format);
			date = sdf.format(d);

		} catch(Exception kkkk) { }
		return date;
	}
	
	/**
	 * SPACE로 채워진 byte array 를 return
	 * @param size
	 * @return
	 */
	public static byte[] makeFullSpaceBtyeArray(int size){
		byte[] result = new byte[size];
		for(int i = 0; i < size; i++){
			result[i] = SPACE;
		}
		return result;
	}
	
	/**
	 * accss name return
	 * @param data
	 * @return
	 */
	public static String accessName(String data)
	{
		String returnValue = "";		
		if (data.equals("F"))
			returnValue = "FOX";
		else if (data.equals("W"))
			returnValue = "WEB";
		else if (data.equals("R"))
			returnValue = "ARS";
		else if (data.equals("V"))	
			returnValue = "VM";
		else if (data.equals("P"))
			returnValue = "PDA";
		else
			returnValue = "UNKNOWN TYPE";
		return returnValue;			
	}
	
	/**
	 * yyyy/mm/dd 
	 * @param data
	 * @return
	 */
	public static String timeToMiraeTime(String data)
	{
		String returnValue = "";
		//System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>�ð�"+ data);
		if(data.length() >= 15)
		{
			StringBuilder temp = new StringBuilder();
			temp.append(data.substring(0, 4));
			temp.append("/");
			
			temp.append(data.substring(4, 6));
			temp.append("/");
			temp.append(data.substring(6, 8));
			temp.append(" ");
			
			temp.append(data.substring(9, 11));
			temp.append(":");
			temp.append(data.substring(11, 13));
			temp.append(":");
			temp.append(data.substring(13, 15));
			
			returnValue = temp.toString();
			
		}
		return returnValue;
	}
	
	public static byte[] makeFullSizeByteArray(byte[] value, int size){
		byte[] result = new byte[size];
		
		if(value.length == size){
			return value;	
		}else if(value.length > size){
			System.arraycopy(value, 0, result, 0, size);
			return result;
		}else{
			System.arraycopy(value, 0, result, 0, value.length);
			return result;
		}
	}
}// end of tool
