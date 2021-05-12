package m.format;

import m.common.tool.tool;

public class GraphHeader{

    public static final String SIGN = "2";
    public static final String UNSIGN = "0";
    private byte header_buf[];

    public GraphHeader(){
        header_buf = new byte[152];
        int i = 0;
        i = setData("", i, 4);
        i = setData("", i, 4);
        i = setData("", i, 4);
        i = setData("", i, 4);
        i = setData("360", i, 6);
        i = setData("", i, 6);
        i = setData("", i, 1);
        i = setData("", i, 1);
        i = setData(tool.getToday(), i, 8);
        i = setData("", i, 1);
        i = setData("1", i, 1);
        i = setData("", i, 4);
        i = setData("", i, 4);
        i = setData("", i, 1);
        i = setData("", i, 1);
        i = setData("", i, 16);
        i = setData("", i, 1);
        i = setData("", i, 1);
        i = setData("", i, 4);
        i = setData("", i, 80);
    }

    public int setData(String s, int i, int j, char c, int k){
        if(s == null)			s = "";
        byte abyte0[] = tool.fillbyte(s.getBytes(), j, (byte)c, k);
        for(int l = 0; l < j; l++){
        	header_buf[l + i] = abyte0[l];
        }
        return i + j;
    }//end of setData();

    public int setData(String s, int i, int j){
        return setData(s, i, j, ' ', 2);
    }//end of setData();

    public void setNrec(String s){
        if(s == null)		s = "360";
        setData(s, 0, 6);
    }//end of setNrec();

    public void setDumy(String s){
        if(s == null)		s = "      ";
        setData(s, 6, 6);
    }//end of setDumy();

    public void setDate(String s){
        s = tool.removeWord(s, "/");
        s = tool.removeWord(s, "-");
        if(s == null)		s = tool.getToday();
        s = tool.fillChar(s, 8, ' ', 2);
        setData(s, 14, 8);
    }//end of setDate();

    public byte[] getHeader(){
        return header_buf;
    }//end of getHeader();
}//end of GraphHeader
