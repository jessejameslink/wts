package m.json;

import java.io.IOException;
import java.io.Reader;
import m.json.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class JSONValue extends org.json.simple.JSONValue {

	public static Object parseWithException(Reader paramReader) throws IOException, ParseException {
		JSONParser localJSONParser = new JSONParser();
		return localJSONParser.parse(paramReader);
	}

	public static Object parseWithException(String paramString) throws ParseException {
		JSONParser localJSONParser = new JSONParser();
		return localJSONParser.parse(paramString);
	}
}