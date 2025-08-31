/**
 * @description Clase clase abstracta contrato para que todas las clases parser sigan una estructura.
 * @author Bluetech
 * @group InLearning
 * @last modified on  : 23-02-2025
 * @last modified by  : Ricardo
 * Modifications Log:
 * Ver   Date         Author          		Modification
 * 1.0   13-08-2024   Ricardo Diaz     		Creación de la clase
 * 1.1   15-04-2025	  Ricardo Diaz 			Definiciones
 */
public abstract class IL_BaseParser_cls {
	public abstract Object parseRequest(Object body, IL_HttpRequest_cls request, IL_CalloutConfig__c config);
	public abstract Object parseResponse(IL_HttpResponse_cls response, IL_HttpRequest_cls request, IL_CalloutConfig__c config);
}