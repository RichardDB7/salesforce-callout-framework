/**
 * @description Clase Wrapper que recibe callouts HTTP y soporte para headers, encriptación del cuerpo, manejo de errores y configuración dinámica. 
 * @author Bluetech
 * @group InLearning
 * @last modified on  : 15-04-2025
 * @last modified by  : Ricardo
 * Modifications Log:
 * Ver   Date         Author          		Modification
 * 1.0   13-08-2024   Ricardo Diaz    		Creación de la clase
 * 1.1   15-04-2025	  Ricardo Diaz 			Definiciones
 */
public class IL_HttpResponse_cls {

	/**
	 * @param body String que contiene el cuerpo del response
	 * @param error Boolean que indica si fallo el callout
	 * @param mensajeError Descripción del error
	 * @param ex excepción capturada
	 * @param statusCode codigo HTTP
	 * @param data payload procesado por el parser 
	 */

	private String body;
	private Boolean error;
	private String mensajeError;
	private Exception ex;
	private Integer statusCode;
	private Object data;
	

	/**
	 * G & S
	 */

	public void setBody(String body){
		this.body = body;
	}
	public String getBody(){
		return this.body;
	}

	public void setError(Boolean error){
		this.error = error;
	}

	public Boolean isError(){
		return this.error;
	}

	public void setMensajeError(String mensajeError){
		this.mensajeError = mensajeError;
	}
   
	public String getMensajeError(){
		return this.mensajeError;
	}

	public void setException(Exception ex){
		this.ex = ex;
	}

	public Exception getException(){
		return this.ex;
	}

	public void setStatusCode(Integer statusCode){
		this.statusCode = statusCode;
	}

	public Integer getStatusCode(){
		return this.statusCode;
	}

	public void setData(Object data){
		this.data = data;
	}

	public Object getData(){
		return this.data;
	}
}