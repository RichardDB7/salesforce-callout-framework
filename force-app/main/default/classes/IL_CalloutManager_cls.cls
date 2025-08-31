/**
 * @description Clase gestora centralizada para realizar callouts HTTP.
 * @author Bluetech
 * @group InLearning
 * @last modified on  : 15-04-2025
 * @last modified by  : Ricardo
 * Modifications Log:
 * Ver   Date         Author          		Modification
 * 1.0   13-08-2024   Ricardo Diaz    		Creación de la clase
 * 1.1   15-04-2025	  Ricardo Diaz 			Definiciones
 */
public  class IL_CalloutManager_cls {
     
	/**
	 * @param bodyEncrypted Boolean que indica si el cuerpo del request debe ser encriptado
	 * @param headers Mapa de headers del request
	 * @param urlParams Mapa para urls dinámicas
	 * @param configId Id de configuración
	 * @param callbackMethod reservado para manjeo de respuestas
	 * @param body cuerpo del request
	 */

	private Boolean bodyEncrypted = true;
	private Map<String, String> headers;
	private Map<String, String> urlParams;
	private String configId;
	private String callbackMethod;
	private Object body;

	/**
	 * @param configApi configuracion de la api
	 * @param parser parser de la api
	 * @param request request de la api
	 * @param response response de la api
	 */

	private IL_CalloutConfig__c configApi;
	private IL_BaseParser_cls parser;
	private IL_HttpRequest_cls request;
	private IL_HttpResponse_cls response;


	public IL_CalloutManager_cls(String configId){
		initialize(configId,true);
	}

	public void initialize(String configId, Boolean flag){
		this.configId = configId;
		this.configApi = IL_CalloutManagerHelper_cls.getConfigAPI(this.configId);
		if(flag){
			this.parser = IL_ParserFactory_cls.getParser(this.configApi.IL_NameParser__c);
		}
	}

	public IL_HttpResponse_cls doCallout(){

		try {
			initRequest();

			IL_CalloutManagerHelper_cls.logRequest(log,this);
			this.request.setNonEncryptedBody(this.bodyEncrypted);
			this.response = request.send();

			IL_CalloutManagerHelper_cls.logResponse(log,this);
			if(!response.isError()){
				response.setData(this.parser.parseResponse(this.response, request, this.configApi));
			}
			
		} catch (Exception ex) {
			if(this.response == null){
				this.response = new IL_HttpResponse_cls();
			}
			response.setError(true);
			response.setMensajeError(ex.getMessage());
			response.setException(ex);
		}
		return response;
	}

	
	private void initRequest(){
		this.request = new IL_HttpRequest_cls();
		String payload = (String) this.parser.parseRequest(getBody(),this.request,this.configApi);


		this.request.setBodyEncrypted(this.bodyEncrypted);
		if(this.bodyEncrypted){
			this.request.setBody(payload);
		}else{
			this.request.setNonEncryptedBody(payload);
		}
	
		this.request.setEndpoint(IL_CalloutManagerHelper_cls.getFullEndpoint(this.configApi, getUrlParams()));
		this.request.setMethod(this.configApi.IL_Method__c);

		this.request.setHeaders(IL_CalloutManagerHelper_cls.getFullHeaders(getHeaders(), this.configApi.IL_AdditionalHeaders__c,this.configApi));
		this.request.setTimeout(IL_CalloutManagerHelper_cls.getTimeout(this.configApi));
	}

	public Map<String,String>  getHeaders(){
		return this.headers;
	}

	public void  setHeaders(Map<String,String> headers){
		this.headers = headers;
	}


	public Map<String,String> getUrlParams(){
		return this.urlParams;
	}


	public Object getBody(){
		return this.body;
	}


	public void setUrlParams(Map<String,String> urlParams){
		this.urlParams = urlParams;
	}

	public void setBody(Object body){
		this.body = body;
	}

	
	public void setBodyEncrypted(Boolean param){
		this.bodyEncrypted = param;
	}

	public Boolean getBodyEncrypted(){
		return this.bodyEncrypted;
	}


	public IL_CalloutConfig__c getConfigApi(){
		return this.configApi;
	}

	public String getConfigId(){
		return this.configId;
	}

	public IL_HttpRequest_cls getRequest(){
		return this.request;
	}

	public IL_HttpResponse_cls getResponse(){
		return this.response;
	}

	public String getFullEndpoint(){
		return IL_CalloutManagerHelper_cls.getFullEndpoint(this.getConfigApi(), this.getUrlParams());
	}
}