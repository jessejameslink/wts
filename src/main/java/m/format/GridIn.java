package m.format;

import m.common.tool.*;

public class GridIn {

    public void setVRow(String s){
        s = tool.fillChar(s, 2, ' ', tool.RIGHT);
        INPUT[0] = s;
    }

    public void setNRow(String s){
        s = tool.fillChar(s, 4, ' ', tool.RIGHT);
        INPUT[1] = s;
    }

    public void setVFlg(String s){
        s = tool.fillChar(s, 1, ' ', tool.RIGHT);
        INPUT[2] = s;
    }

    public void setGDir(String s){
        s = tool.fillChar(s, 1, ' ', tool.RIGHT);
        INPUT[3] = s;
    }

    public void setSDir(String s){
        s = tool.fillChar(s, 1, ' ', tool.RIGHT);
        INPUT[4] = s;
    }

    public void setSCol(String s){
        s = tool.fillChar(s, 16, ' ', tool.RIGHT);
        INPUT[5] = s;
    }

    public void setIKey(String s){
        s = tool.fillChar(s, 1, ' ', tool.RIGHT);
        INPUT[6] = s;
    }

    public void setPage(String s){
        s = tool.fillChar(s, 4, ' ', tool.RIGHT);
        INPUT[7] = s;
    }

    public void setSave(String s){
        s = tool.fillChar(s, 80, ' ', tool.RIGHT);
        INPUT[8] = s;
    }

    public void setHeader(byte abyte0[]){
        snd_header_buf = abyte0;
    }

    public byte[] getHeader(){
        makeHeader();
        return snd_header_buf;
    }

    public void makeHeader(){
        StringBuffer s = new StringBuffer();
        for(int i = 0; i < INPUT.length; i++)	s.append(new StringBuffer()).append(INPUT[i]);
        setHeader(s.toString().getBytes());
    }

    private final void _mththis(){
        snd_header_buf = new byte[110];
        INPUT = new String[9];
    }

    public GridIn(){
        _mththis();
        INPUT[0] = "15";				//vrow
        INPUT[1] = "0015";				//nrow
        INPUT[2] = "0";					//vflag
        INPUT[3] = "1";					//gdir
        INPUT[4] = "0";					//sdir
        INPUT[5] = "                ";	//scol
        INPUT[6] = "0";					//ikey
        INPUT[7] = "    ";				//page
        INPUT[8] = "                                                                                ";		//save
    }

    public static final int HEADER_IN = 110;
    byte snd_header_buf[];
    String INPUT[];
}
