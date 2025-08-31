/**
 * @description Clase test Mock para Llamadas HTTP. 
 * @author Bluetech
 * @group InLearning
 * @last modified on  : 15-04-2025
 * @last modified by  : Ricardo
 * Modifications Log:
 * Ver   Date         Author          		Modification
 * 1.0   13-08-2024   Ricardo Diaz     		Creación de la clase
 * 1.1   15-04-2025	  Ricardo Diaz 			Definiciones
 */
@isTest
global class IL_CalloutManagerMock_tst implements HttpCalloutMock {
    
	protected Integer code = 201;
	public String bodyAsString;
	public static Boolean isError = false;
    public static String responseBody = '{"data":"Simulated Data"}';
    
   
	global HttpResponse respond(HttpRequest req){
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type','application/json');
		res.setBody(bodyAsString);
		res.setStatusCode(code);
		res.setStatus('OK');
		return res;
	}
   
	public IL_CalloutManagerMock_tst(Integer code){
		this.code = code;
		this.bodyAsString = code == 200 ? jsonResp : jsonError; 
	}

    global static String getSuccessResponse() {
        return '{"results": [ { "division": "Division1", "producto": "Producto1", "periodo": "Periodo1", "datosHorario": [ { "curso": "Matemáticas", "modalidad": "Presencial", "ambiente": "Aula 101", "docente": "Profesor X", "dia": 1, "diaNombre": "Lunes", "horaInicio": "08:00", "horaFin": "10:00" } ] } ] }';
    }
    global static String getErrorResponse() {
        return '{"error": "Some error occurred"}';
    }
    
	global static String jsonResp = '{' +
    '"results": [' +
    '  {' +
    '    "division": "División 1",' +
    '    "periodo": "2025",' +
    '    "datosPago": [' +
    '      {' +
    '        "nombre": "Pago 1",' +
    '        "monto": 100.0,' +
    '        "fechaSolicitud": "2025-01-01",' +
    '        "fechaEmision": "2025-01-02",' +
    '        "fechaVencimiento": "2025-01-03",' +
    '        "fechaPago": "2025-01-04",' +
    '        "estado": "Pagado",' +
    '        "montoPagado": 100.0,' +
    '        "descuento": 0.0,' +
    '        "descuentoDetalle": "Sin descuento"' +
    '      }' +
    '    ]' +
    '  }' +
    ']' +
    '}';	
	global static String jsonError = '{"success":false}';
}