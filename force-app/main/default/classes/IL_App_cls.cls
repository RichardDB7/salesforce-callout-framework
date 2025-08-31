/**
 * @description Clase contenedora de los custom exception.
 * @author Bluetech
 * @group InLearning
 * @last modified on  : 15-04-2025
 * @last modified by  : Ricardo
 * Modifications Log:
 * Ver   Date         Author          		Modification
 * 1.0   13-08-2024   Ricardo Diaz    		Creación de la clase
 * 1.1   15-04-2025	  Ricardo Diaz 			Definiciones
 */
public class IL_App_cls {
	public class NotFoundException extends Exception {}
	public class BadConfigurationException extends Exception {}
	public class WebServiceException extends Exception {}
	public class ServiceException extends Exception {}
	public class IllegalArgumentException extends Exception {}
}