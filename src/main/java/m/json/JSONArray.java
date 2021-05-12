package m.json;

public class JSONArray extends org.json.simple.JSONArray{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * String형의 Data return
	 * @param key
	 * @return
	 */
	public String getString(int index){
		Object obj = this.get(index);
		if(obj==null)	return new String();
		else	return (String)obj;
	}
	
	public static void arrayCopy(JSONArray target, JSONArray ori){
		try{
			for(int i=0;i<ori.size();i++){
				target.add(ori.get(i));
			}
		}catch(Exception e){
			return;
		}
	}
	
	public static JSONArray reverseArray(JSONArray target){
		JSONArray result = new JSONArray();
		try{
			for(int i=target.size()-1;i>-1;i--){
				result.add(target.get(i));
			}
		}catch(Exception e){
			e.printStackTrace();
			return result;
		}
		
		return result;
	}
}