/**
 * @description Clase fábrica de parsers para formatear el cuerpo del request y parsear la respuesta del servicio.
 * @author Bluetech
 * @group InLearning
 * @last modified on  : 15-04-2025
 * @last modified by  : Ricardo
 * Modifications Log:
 * Ver   Date         Author          		Modification
 * 1.0   13-08-2024   Ricardo Diaz    		Creación de la clase
 * 1.1   15-04-2025	  Ricardo Diaz 			Definiciones
 */
public class IL_ParserFactory_cls {
	private static Map<String, Type> mapParsers = new Map<String,Type>();

	
	/**
	 * @param static Initializer
	 * Permite que los parsers sean completamente dinámicos y configurables desde metadata, sin necesidad de modificar código.
	 */
	static{
		Type t = null;
		for(IL_CalloutConfig__c config: IL_CalloutManagerHelper_cls.mapApis.values()){
			if(config.IL_NameParser__c != null){
				t = Type.forName(config.IL_NameParser__c);
				if(t != null){
					mapParsers.put(config.IL_NameParser__c,t);
				}
			}
			
		}
	}

	public static IL_BaseParser_cls getParser(String name){
		if(mapParsers.containsKey(name)){
			return (IL_BaseParser_cls) mapParsers.get(name).newInstance();
		}else{
			throw new IL_App_cls.NotFoundException('Not found parser class '+name);
		}
	}
}