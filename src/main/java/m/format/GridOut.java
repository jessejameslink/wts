package m.format;

public class GridOut {

    public String getFlag(){
        return OUTPUT[0];
    }

    public String getSDir(){
        return OUTPUT[1];
    }

    public String getScol(){
        return OUTPUT[2];
    }

    public String getXPos(){
        return OUTPUT[3];
    }

    public String getPage(){
        return OUTPUT[4];
    }

    public String getSave(){
        return OUTPUT[5];
    }

    public void setHeader(byte abyte0[]){
        OUTPUT[0] = new String(abyte0,  0,  1).trim();
        OUTPUT[1] = new String(abyte0,  1,  1).trim();
        OUTPUT[2] = new String(abyte0,  2, 16).trim();
        OUTPUT[3] = new String(abyte0, 18,  1).trim();
        OUTPUT[4] = new String(abyte0, 19,  4).trim();
        OUTPUT[5] = new String(abyte0, 23, 80).trim();
    }

    public byte[] getHeader(){
        StringBuffer s = new StringBuffer();
        for(int i = 0; i < OUTPUT.length; i++)	s.append(new StringBuffer()).append(OUTPUT[i]);
        rec_header_buf = s.toString().getBytes();
        return rec_header_buf;
    }

    private final void _mththis(){
        rec_header_buf = new byte[103];
        OUTPUT = new String[6];
    }

    public GridOut(){
        _mththis();
        OUTPUT[0] = " ";							//flag
        OUTPUT[1] = " ";							//sdir
        OUTPUT[2] = "                ";				//scol
        OUTPUT[3] = " ";							//xpos
        OUTPUT[4] = "    ";							//page
        OUTPUT[5] = "                                                                                ";		//save
    }

    public static final int HEADER_OUT = 103;
    byte rec_header_buf[];
    String OUTPUT[];
}
