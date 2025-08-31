/**
 * @description Clase helper utilitaria de soporte para la clase IL_CalloutManager_cls
 * @author Bluetech
 * @group InLearning
 * @last modified on  : 15-04-2025
 * @last modified by  : Ricardo
 * Modifications Log:
 * Ver   Date         Author          		Modification
 * 1.0   13-08-2024   Ricardo Diaz    Creación de la clase
 * 1.1   15-04-2025	  Ricardo Diaz 			Definiciones
 */
public class IL_CalloutManagerHelper_cls {

	/**
	 * @param mapApis Mapa de configuraciones de callouts
	 * @param static carga de custom setting IL_CalloutConfig__c
	 */

	public static Map<String,IL_CalloutConfig__c> mapApis;

	static {
	  
		if(mapApis == null){
			System.debug('Loaded map APIS');
			mapApis = new Map<String,IL_CalloutConfig__c>();
			for(IL_CalloutConfig__c cs : IL_CalloutConfig__c.getAll().values()){
				mapApis.put(cs.Name,cs);
			}
		}
	}

	/**
	 * Retronar config específica
	 */
	public static IL_CalloutConfig__c getConfigAPI(String configId){
		if(mapApis.containsKey(configId)){
			return mapApis.get(configId); 
		}
		throw new  IL_App_cls.NotFoundException('Not found metadata with id => '+ configId);
	}

	/**
	 * Método que construye el endpoint de forma dinámica con Named Credentials
	 */
	public static String getFullEndpoint(IL_CalloutConfig__c config,Map<String,String> urlParams){

		String url = null;
		String params = '';
		String paramTmp = '';

		if(config.IL_NameCredential__c != null){
			url = 'callout:'+config.IL_NameCredential__c+config.IL_EndPoint__c;
		}
	  
		else{
			throw new IL_App_cls.NotFoundException('Not found domain, verify custom config domain => '+ config.Name);
		}
		if(urlParams != null){
			for(String key : urlParams.keySet()){
				paramTmp = urlParams.get(key);
				if(key.indexOf('{') == 0){
					url = url.replace(key,paramTmp);
				}else{
					params += (String.isEmpty(params)) ? '' : '&';
					params += key+'='+paramTmp;
				}
			}
			if(params != ''){
				params = '?'+params;
			}
		}
		return url+params;
	}

	public static Map<String,String> getFullHeaders(Map<String,String> headers, String jsonConfigHeaders, IL_CalloutConfig__c config){

		headers =  (headers == null) ? new Map<String,String>(): headers;

		if(jsonConfigHeaders != null){
			try{
				headers.putAll((Map<String,String>) JSON.deserialize(jsonConfigHeaders, Map<String,String>.class));
			}catch(Exception e){
				System.debug(LoggingLevel.ERROR,'Error deserialize additional headers '+ jsonConfigHeaders);
				System.debug(LoggingLevel.ERROR,'Error: '+ e);
			}
		}
		return headers;
	}

	
	public static void logRequest(Log__c log,CalloutManager cm){

		try{
			log.IL_EndPoint__c = cm.getRequest().getEndpoint();
			String bodyRequest = cm.getRequest().getBody();
	
			if(String.isNotBlank(bodyRequest)){
				Integer lenBodyRequest = bodyRequest.length();
				Integer maxLength = 131072;
				Integer newMax = (lenBodyRequest< maxLength) ? lenBodyRequest : maxLength;
				log.Request__c = bodyRequest.substring(0,newMax);
			}
	
			log.StartDate__c = Datetime.newInstanceGmt(System.now().date(),System.now().time());
			log.Identifier__c = cm.getConfigId();
		}catch(Exception e){
			System.debug(LoggingLevel.ERROR,'CalloutManager.logRequest =>' + e);
		}
	}
	
	public static void logResponse(Log__c log, CalloutManager cm){
		try {
			log.EndDate__c = Datetime.newInstanceGmt(System.now().date(),System.now().time());
			log.StatusCode__c = cm.getResponse().getStatusCode();
			log.ErrorMessage__c = cm.getResponse().getMensajeError();
			log.Exception__c = (cm.getResponse().getException() != null) ? cm.getResponse().getException().getStackTraceString():'--NO_EXCEPTION--';
			LOG.Response__c = cm.getResponse().getBody();
			if(!cm.getResponse().isError()){
				if(cm.getConfigAPI().SaveLogSuccess__c){
					Logger_cls.add(cm.getConfigId(),log);
				}
			}else{
				if(cm.getConfigAPI().SaveLogError__c){
					Logger_cls.add(cm.getConfigId(),log);
				}
			}
		} catch (Exception e) {
			System.debug(LoggingLevel.ERROR,'CalloutManager.logResponse =>' + e);
			
		}
	}

	public static Integer getTimeout( IL_CalloutConfig__c configApi){
		Integer timeout = 120;
		if(configApi.IL_Timeout__c != null){
			timeout = Integer.valueOf(configApi.IL_Timeout__c);
		}
		return timeout * 1000;
	}
}