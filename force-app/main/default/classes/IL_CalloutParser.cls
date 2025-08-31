/**
 * @description Clase parser base - SAE & DOCENTES 
 * @author Bluetech
 * @group InLearning
 * @last modified on  : 15-04-2025
 * @last modified by  : Ricardo
 * Modifications Log:
 * Ver   Date         Author          		Modification
 * 1.0   13-08-2024   Jhon Erling Dávila    Creación de la clase
 * 1.1   15-04-2025	  Ricardo Diaz 			Definiciones
 */
public class IL_CalloutParser extends IL_BaseParser_cls  {


	public override Object parseRequest(Object body, IL_HttpRequest_cls request,IL_CalloutConfig__c config){
		return body;
	}

	public override Object parseResponse(IL_HttpResponse_cls response, IL_HttpRequest_cls request,IL_CalloutConfig__c config){
		return JSON.deserialize(response.getBody(),ResponseCallout.class);
	}

	public class ResponseCallout{
		public Boolean success;
	}

}