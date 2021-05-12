package m.common.tool;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
/**
 * Base64 Encoding/Decoding 관련 class.
 * @author 김대원
 */
public class Base64{
    private static final char[]    charTab    = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".toCharArray( );
    
    /**
     * Base64 encode
     * @param b
     * @return
     */
    public static String encode( byte[] b ){
        return encode( b , 0 , b.length , null ).toString( );
    }//end of encode();
    
    /**
     * Base64 encode
     * 2015.03.5 중간에 enter가 들어가는 부분 삭제
     * @param b
     * @param i0
     * @param i1
     * @param sb
     * @return
     */
    private static StringBuffer encode( byte[] b , int i0 , int i1 , StringBuffer sb ){
        if ( sb == null ){
            sb = new StringBuffer( b.length * 3 / 2 );
        }
        int i = i1 - 3;
        int j = i0;
        int k = 0;
        int m;
        while ( j <= i ){
            m = ( b[ j ] & 0xFF ) << 16 | ( b[ ( j + 1 ) ] & 0xFF ) << 8 | b[ ( j + 2 ) ] & 0xFF;
            sb.append( charTab[ ( m >> 18 & 0x3F ) ] );
            sb.append( charTab[ ( m >> 12 & 0x3F ) ] );
            sb.append( charTab[ ( m >> 6 & 0x3F ) ] );
            sb.append( charTab[ ( m & 0x3F ) ] );
            j += 3;
            if ( k++ < 14 )
            {
                continue;
            }
            k = 0;
//            sb.append( "\r\n" );
        }
        if ( j == i0 + i1 - 2 )
        {
            m = ( b[ j ] & 0xFF ) << 16 | ( b[ ( j + 1 ) ] & 0xFF ) << 8;
            sb.append( charTab[ ( m >> 18 & 0x3F ) ] );
            sb.append( charTab[ ( m >> 12 & 0x3F ) ] );
            sb.append( charTab[ ( m >> 6 & 0x3F ) ] );
            sb.append( "=" );
        }
        else if ( j == i0 + i1 - 1 )
        {
            m = ( b[ j ] & 0xFF ) << 16;
            sb.append( charTab[ ( m >> 18 & 0x3F ) ] );
            sb.append( charTab[ ( m >> 12 & 0x3F ) ] );
            sb.append( "==" );
        }
        return sb;
    }//end of encode();
    
    /**
     * Base64 decode
     * @param c
     * @return
     */
    private static int decode( char c )
    {
        if ( ( c >= 'A' ) && ( c <= 'Z' ) )
        {
            return c - 'A';
        }
        if ( ( c >= 'a' ) && ( c <= 'z' ) )
        {
            return c - 'a' + 26;
        }
        if ( ( c >= '0' ) && ( c <= '9' ) )
        {
            return c - '0' + 26 + 26;
        }
        switch ( c )
        {
            case '+' :
                return 62;
            case '/' :
                return 63;
            case '=' :
                return 0;
        }
        throw new RuntimeException( "unexpected code: " + c );
    }//end of decode();
    
    /**
     * Base64 decode
     * @param s
     * @return
     */
    public static byte[] decode( String s )
    {
        ByteArrayOutputStream baos = new ByteArrayOutputStream( );
        try
        {
            decode( s , baos );
        }
        catch ( IOException ie )
        {
            throw new RuntimeException( );
        }
        return baos.toByteArray( );
    }//end of decode();
    
    /**
     * Base64 decode
     * @param s
     * @param os
     * @throws IOException
     */
    private static void decode( String s , OutputStream os ) throws IOException
    {
        int i = 0;
        int j = s.length( );
        while ( true )
        {
            if ( ( i < j ) && ( s.charAt( i ) <= ' ' ) )
            {
                i++ ;
                continue;
            }
            if ( i == j )
            {
                break;
            }
            int k = ( decode( s.charAt( i ) ) << 18 ) + ( decode( s.charAt( i + 1 ) ) << 12 ) + ( decode( s.charAt( i + 2 ) ) << 6 ) + decode( s.charAt( i + 3 ) );
            os.write( k >> 16 & 0xFF );
            if ( s.charAt( i + 2 ) == '=' )
            {
                break;
            }
            os.write( k >> 8 & 0xFF );
            if ( s.charAt( i + 3 ) == '=' )
            {
                break;
            }
            os.write( k & 0xFF );
            i += 4;
        }
    }//end of decode();
}
