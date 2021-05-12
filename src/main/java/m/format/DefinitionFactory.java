package m.format;

import java.io.File;

import m.action.IConstants;
import m.common.tool.tool;
import m.config.SystemConfig;
import m.data.hash;

import org.jdom2.Document;
import org.jdom2.input.SAXBuilder;

/**
 * TR.xml 관리 클래스
 * @author nhy67
 *
 */
public class DefinitionFactory implements IConstants{

	private static hash<Definition> definitions = new hash<Definition>();
	
	/**
	 * 하나의 TR에 대해서 xml 파일을 읽어서 메모리에 load시킨다.
	 * @param trName TR명
	 */
	public static void read(String trName){
		try{
			SAXBuilder builder = new SAXBuilder();
			Document doc = builder.build(new File(SystemConfig.get("ABSOLUTE_PATH")+SystemConfig.get("DEFINITIONS_PATH")+trName+".xml"));
			definitions.put(trName, new Transaction(doc));
		}catch(Exception e){
			e.printStackTrace();
		}
	}//end of read();
	
	
	/**
	 * TR명에 해당하는 TR Format을 return한다.
	 * @param trName
	 * @return Input/Output Definition 
	 */
	public static Definition getFormat(String trName){
		if(tool.isNull(trName)){
			throw new NullPointerException("Tr Name is Null!!!");
		}
		Definition definition = definitions.get(trName);
		if(definition==null){
			read(trName);
			definition = definitions.get(trName);
		}
		if(definition==null){
			throw new NullPointerException("TR Object is null!!!");
		}
		return definition;
	}//end of getFormat();
	
	/**
	 * 모든 TR에 대해서 xml 파일을 읽어서 메모리에 load시킨다.
	 */
	public static void readAllFormat(){
		try{
			File file = new File(SystemConfig.get("ABSOLUTE_PATH")+SystemConfig.get("DEFINITIONS_PATH"));
			String[] format = file.list();
			if(format!=null){
				for(int i=0;i<format.length;i++){
					File f = new File(file.getAbsolutePath(), format[i]);
					if(f.isFile()&&format[i].endsWith(".xml")){
						String[] trNames = format[i].split(".xml");
						try{
							read(trNames[0]);
						}catch(Exception ee){
							//System.out.println("DefinitionFactory.readAllFormat : ["+format[i]+"]");
							ee.printStackTrace();
						}
					}
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}//end of readFormat();

	
	static{
		readAllFormat();
	}
}//end of getInputFormat();
