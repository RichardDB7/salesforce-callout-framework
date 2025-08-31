/**
 * @description Clase Wrapper que realiza callouts HTTP y soporte para headers, encriptación del cuerpo, manejo de errores y configuración dinámica.
 * @author Bluetech
 * @group InLearning
 * @last modified on  : 15-04-2025
 * @last modified by  : Ricardo
 * Modifications Log:
 * Ver   Date         Author          		Modification
 * 1.0   13-08-2024   Ricardo Diaz    		Creación de la clase
 * 1.1   15-04-2025	  Ricardo Diaz 			Definiciones
 */
public class IL_HttpRequest_cls {
	
	/**
 	* @param bodyEncrypted Boolean que indica si el cuerpo del request debe ser encriptado
	* @param http Http del request
	* @param request HttpRequest del request
	* @param response HttpResponse del request
	* @param headers Mapa de headers del request
	* @param endpoint Endpoint del servicio a consumir
	* @param timeout Timeout del request
	* @param method Metodo del request
	* @param namedCredential NamedCredential del request	
	* @param internalKey Key para encriptar el cuerpo del request con su propia clave interna
	* @param body Cuerpo del request
 	*/
	
	private Boolean bodyEncrypted = true;
	private Http http = null;
	private HttpRequest request = null;
	private HttpResponse response = null;
	private Map<String,String> headers;
	private String endpoint;
	private Integer timeout;
	private String method;
	private String namedCredential = '';
	private Blob internalKey;
	private Blob body;


	/**
	 * Constructor que instancia los objetos necesarios para realizar el callout
	 * @param bodyEncrypted Boolean que indica si el cuerpo del request debe ser encriptado
	 * @param internalKey Key para encriptar el cuerpo del request con su propia clave interna
	 */
	public IL_HttpRequest_cls(){
		http = new http();
		request = new HttpRequest();
		this.internalKey = Crypto.generateAesKey(256);
	}

	/**
	 * Metodo send arma request
	 * @param res traduce el resultado a IL_HttpResponse_cls
	 * Si hay error se encapsula en el objeto de respuesta
	 * @return IL_HttpResponse_cls
	 * 
	 */

	public IL_HttpResponse_cls send(){

		IL_HttpResponse_cls res = new IL_HttpResponse_cls();

		try{
			request = getBaseRequest();
			response = http.send(request);
			res = getResponseFromHttpResponse(response);
		}catch(Exception e){
			res.setError(true);
			res.setMensajeError(e.getMessage());
			res.setException(e);
		}
		return res;
	}

	/**
	 * Metodo getBaseRequest arma request
	 * @return HttpRequest
	 *
	 */
	public HttpRequest getBaseRequest(){

		request.setEndpoint(getEndpoint());
		request.setMethod(getMethod());

		if(this.bodyEncrypted == true){
			if(getBody() != null){
				request.setBody(getBody());
			}
		}else{
			if(getNonEncryptedBody() != null){
				request.setBody(getNonEncryptedBody());
			}
		}


		if(getHeaders() != null){
			for(String key : getHeaders().keySet()){
				String strHeader = getHeaders().get(key);
				if(strHeader != null){
					request.setHeader(key,strHeader);
				}
			}
		}

		if(getTimeout() != null){
			request.setTimeout(getTimeout());
		}

		return request;
	}

	/**
	 * Transforma HttpResponse a IL_HttpResponse_cls
	 * @param response HttpResponse
	 * @return IL_HttpResponse_cls
	 */
	public IL_HttpResponse_cls getResponseFromHttpResponse(HttpResponse response){
		IL_HttpResponse_cls res = new IL_HttpResponse_cls();

		try{
			res.setStatusCode(response.getStatusCode());
			res.setBody(response.getBody());
			res.setError(false);
			validateStatusCode(response.getStatusCode());
		}catch(Exception e){
			res.setError(true);
			res.setMensajeError(e.getMessage());
			res.setException(e);
		}
		return res;
	}

	private Boolean validateStatusCode(Integer statusCode){
		if(statusCode >= 200 && statusCode < 300){
			return true;
		}
		throw new IL_App_cls.WebServiceException('Error executed webservice, response failed ' + statusCode);

	}

	public Map<String,String> getHeaders(){
		return this.headers;
	}

	public void setHeaders(Map<String,String> headers){
		this.headers = headers;
	} 

	public String getEndpoint(){
		return this.endpoint;
	}

	public void setEndpoint(String endpoint){
		this.endpoint = endpoint;
	}

	public String getMethod(){
		return this.method;
	}

	public void setMethod(String method){
		this.method = method;
	}

	public String getBody(){        
		return this.body != null ? Crypto.decryptWithManagedIV('AES256',internalKey,this.body).toString() : null;
	}

	public void setBody(String body){     
		this.body = body != null ? Crypto.encryptWithManagedIV('AES256', internalKey, Blob.valueOf(body)) : null;
	}

	public String getNonEncryptedBody(){
		return this.body != null ? this.body.toString() : null;
	}

	public void setNonEncryptedBody(String body){
		this.body = body != null ? Blob.valueOf(body) : null;
	}

	public Integer getTimeout(){
		return this.timeout;
	}

	public void setTimeout(Integer timeout){
		this.timeout = timeout;
	}

	public void setBodyEncrypted(Boolean param){
		this.bodyEncrypted = param;
	}
}