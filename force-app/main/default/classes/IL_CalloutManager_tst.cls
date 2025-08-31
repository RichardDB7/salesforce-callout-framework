/**
 * @description Clase test para IL_CalloutManager_cls 
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
public class IL_CalloutManager_tst {
   
	@TestSetup
	static void testSetup(){
		List<SObject> lst = new List<SObject>();
		lst.add(new IL_CalloutConfig__c(Name='Test',IL_EndPoint__c='/test',IL_NameCredential__c='ContratosHighQ',IL_Method__c='POST',IL_OAuthName__c=null,IL_OAuthApi__c=false,IL_NameParser__c='IL_CalloutParser',IL_Timeout__c=120,IL_AdditionalHeaders__c='{"test":"test"}'));
		lst.add(new IL_CalloutConfig__c(Name='TestUrlParams',IL_EndPoint__c='/testUrlParams/{param1}/example',IL_NameCredential__c='ContratosHighQ',IL_Method__c='POST',IL_OAuthName__c=null,IL_OAuthApi__c=false,IL_NameParser__c='IL_CalloutParser',IL_Timeout__c=120,IL_AdditionalHeaders__c='{"test":"test"}'));
		lst.add(new IL_CalloutConfig__c(Name='TestErrorJSONHeader',IL_EndPoint__c='/test',IL_NameCredential__c='ContratosHighQ',IL_Method__c='POST',IL_OAuthName__c=null,IL_OAuthApi__c=false,IL_NameParser__c='IL_CalloutParser',IL_Timeout__c=120,IL_AdditionalHeaders__c='{"test":"wrong formatjson}'));
		lst.add(new IL_CalloutConfig__c(Name='NoNameCredential',IL_EndPoint__c='/test',IL_NameCredential__c=null,IL_Method__c='POST',IL_OAuthName__c=null,IL_OAuthApi__c=false,IL_NameParser__c='IL_CalloutParser'));
		lst.add(new IL_CalloutConfig__c(Name='NoParserFound',IL_EndPoint__c='/test',IL_NameCredential__c=null,IL_Method__c='POST',IL_OAuthName__c=null,IL_OAuthApi__c=false,IL_NameParser__c=null));
		insert lst;
	}


	@isTest
	static void testDoCalloutErrorNoParser(){
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new IL_CalloutManagerMock_tst(400));
		IL_CalloutManager_cls cm;
		IL_HttpResponse_cls res;
		String exMsg;
		try {
			cm = new IL_CalloutManager_cls('NoParserFound');
			res = cm.doCallout();
		} catch (Exception e) {
			exMsg = e.getMessage();
		}
		Test.stopTest();
		Assert.areEqual('Not found parser class null',exMsg);
	}

	@isTest
	static void testDoCalloutErrorNoFoundConfigId(){
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new IL_CalloutManagerMock_tst(200));
		IL_CalloutManager_cls cm;
		IL_HttpResponse_cls res;
		String exMsg;
		try {
			cm = new IL_CalloutManager_cls('NoFoundConfigId');
			res = cm.doCallout();
		} catch (Exception e) {
			exMsg = e.getMessage();
		}
		Test.stopTest();
		Assert.areEqual('Not found metadata with id => NoFoundConfigId',exMsg);
	}

	
	@isTest
	static void testDoCalloutErrorNoNameCredential(){
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new IL_CalloutManagerMock_tst(400));
		IL_CalloutManager_cls cm = new IL_CalloutManager_cls('NoNameCredential');
		IL_HttpResponse_cls res = cm.doCallout();
		Test.stopTest();
		Assert.areEqual('Not found domain, verify custom config domain => NoNameCredential',cm.getResponse().getMensajeError());
		Assert.areEqual(true,cm.getResponse().isError());
	}

	@isTest
	static void testDoCalloutErrorResponse(){
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new IL_CalloutManagerMock_tst(400));
		IL_CalloutManager_cls cm = new IL_CalloutManager_cls('Test');
		IL_HttpResponse_cls res = cm.doCallout();
		IL_HttpResponse_cls response = cm.getResponse();
		Test.stopTest();
		Assert.areEqual(true,res.isError());
		Assert.areEqual(400,response.getStatusCode());
	}

	
	@isTest
	static void testDoCalloutErrorResponseNoEncrytedBody(){
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new IL_CalloutManagerMock_tst(400));
		IL_CalloutManager_cls cm = new IL_CalloutManager_cls('Test');
		cm.setBodyEncrypted(false);
		IL_HttpResponse_cls res = cm.doCallout();
		Test.stopTest();
		Assert.areEqual(true,res.isError());
		Assert.areEqual(400,res.getStatusCode());
	}

	

	@isTest
	static void testDoCalloutErrorJsonWrongFormat(){
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new IL_CalloutManagerMock_tst(200));
		IL_CalloutManager_cls cm = new IL_CalloutManager_cls('TestErrorJSONHeader');
		Map<String,String> urlParams = new Map<String,String>();
		urlParams.put('test','test');
		cm.setUrlParams(urlParams);
		IL_HttpResponse_cls res = cm.doCallout();
		Test.stopTest();
		IL_CalloutParser.ResponseCallout data = (IL_CalloutParser.ResponseCallout) res.getData();
		Assert.areEqual(true,data.success);
		Assert.areEqual(false,res.isError());
		Assert.areEqual(200,res.getStatusCode());
	}

	@isTest
	static void testDoCalloutSuccessResponse(){
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new IL_CalloutManagerMock_tst(200));
		IL_CalloutManager_cls cm = new IL_CalloutManager_cls('Test');
		Map<String,String> urlParams = new Map<String,String>();
		urlParams.put('test','test');
		cm.setUrlParams(urlParams);
		cm.setBody('data');
		IL_HttpResponse_cls res = cm.doCallout();
		Test.stopTest();
		IL_HttpRequest_cls request = cm.getRequest();
		IL_HttpResponse_cls response = cm.getResponse();
		IL_CalloutParser.ResponseCallout data = (IL_CalloutParser.ResponseCallout) res.getData();
		Assert.areEqual(true,data.success);
		Assert.areEqual(false,res.isError());
		Assert.areEqual(200,res.getStatusCode());
	}


	@isTest
	static void testDoCalloutSuccessNoEncrytedBody(){
		Test.setMock(HttpCalloutMock.class, new IL_CalloutManagerMock_tst(200));
		IL_CalloutManager_cls cm = new IL_CalloutManager_cls('Test');
		Map<String,String> urlParams = new Map<String,String>();
		urlParams.put('test','test');
		cm.setUrlParams(urlParams);
		cm.setBody('data');
		cm.setBodyEncrypted(false);

		Test.startTest();
		IL_HttpResponse_cls res = cm.doCallout();
		Test.stopTest();
		IL_CalloutParser.ResponseCallout data = (IL_CalloutParser.ResponseCallout) res.getData();
		
		Assert.areEqual(false,res.isError());
		Assert.areEqual(200,res.getStatusCode());
		Assert.areEqual(true,data.success);
	}

	@isTest
	static void testUtilCallout(){
		IL_CalloutManager_cls cm = new IL_CalloutManager_cls('Test');
		Map<String,String> urlParams = new Map<String,String>();
		urlParams.put('test','test');
		cm.getConfigId();
		cm.setUrlParams(urlParams);
		cm.setBody('data');
		cm.setBodyEncrypted(false);
		IL_CalloutConfig__c configApi = cm.getConfigApi();
		Map<String,String> headers = new Map<String,String>();
		headers.put('Content-Type','application/json');
		cm.setHeaders(headers);

		Assert.areEqual(false,cm.getBodyEncrypted());
		Assert.areEqual(configApi.Name,'Test');
	}

	@isTest
	static void testMultiMockWithMap(){
		Test.setMock(HttpCalloutMock.class, new IL_CalloutManagerMock_tst(200));
		IL_CalloutManager_cls cm = new IL_CalloutManager_cls('Test');
		Map<String,String> urlParams = new Map<String,String>();
		urlParams.put('test','test');
		cm.setUrlParams(urlParams);
		cm.setBody('data');
		cm.setBodyEncrypted(false);
		Map<String,HttpCalloutMock> mapMocks = new Map<String,HttpCalloutMock>();
		mapMocks.put(cm.getFullEndpoint(), new IL_CalloutManagerMock_tst(200));
		IL_MultiMockRequest_cls multimock = new IL_MultiMockRequest_cls(mapMocks);
		
		Test.setMock(HttpCalloutMock.class, multimock);
		Test.startTest();
		IL_HttpResponse_cls res = cm.doCallout();
		Test.stopTest();
		
		IL_CalloutParser.ResponseCallout data = (IL_CalloutParser.ResponseCallout) res.getData();
		Assert.areEqual(1,multimock.getSize());
		Assert.areEqual(false,res.isError());
		Assert.areEqual(200,res.getStatusCode());
		Assert.areEqual(true,data.success);

	}


	
	@isTest
	static void testMultiMockWithCmMethod(){
		IL_MultiMockRequest_cls multimock = new IL_MultiMockRequest_cls();
		Test.setMock(HttpCalloutMock.class, new IL_CalloutManagerMock_tst(200));
		IL_CalloutManager_cls cm = new IL_CalloutManager_cls('Test');
		Map<String,String> urlParams = new Map<String,String>();
		urlParams.put('test','test');
		cm.setUrlParams(urlParams);
		cm.setBody('data');
		cm.setBodyEncrypted(false);
		multimock.addRequestMock(cm,new IL_CalloutManagerMock_tst(200));

		Test.setMock(HttpCalloutMock.class, multimock);
		Test.startTest();
		IL_HttpResponse_cls res = cm.doCallout();
		Test.stopTest();
		
		IL_CalloutParser.ResponseCallout data = (IL_CalloutParser.ResponseCallout) res.getData();
		Assert.areEqual(1,multimock.getSize());
		Assert.areEqual(false,res.isError());
		Assert.areEqual(200,res.getStatusCode());
		Assert.areEqual(true,data.success);
	}

		
	@isTest
	static void testMultiMockWithAddFullEndpointMethod(){
		
		IL_MultiMockRequest_cls multimock = new IL_MultiMockRequest_cls();

		Test.setMock(HttpCalloutMock.class, new IL_CalloutManagerMock_tst(200));
		IL_CalloutManager_cls cm = new IL_CalloutManager_cls('Test');
		Map<String,String> urlParams = new Map<String,String>();
		urlParams.put('test','test');
		cm.setUrlParams(urlParams);
		cm.setBody('data');
		cm.setBodyEncrypted(false);
		multimock.addRequestMock(cm.getFullEndpoint(),new IL_CalloutManagerMock_tst(200));

		Test.setMock(HttpCalloutMock.class, multimock);
		Test.startTest();
		IL_HttpResponse_cls res = cm.doCallout();
		Test.stopTest();
		
		IL_CalloutParser.ResponseCallout data = (IL_CalloutParser.ResponseCallout) res.getData();
		Assert.areEqual(1,multimock.getSize());
		Assert.areEqual(false,res.isError());
		Assert.areEqual(200,res.getStatusCode());
		Assert.areEqual(true,data.success);
	}


	@isTest
	static void testMultiMockErrorNoFound(){
		IL_MultiMockRequest_cls multimock = new IL_MultiMockRequest_cls();
		Test.setMock(HttpCalloutMock.class, new IL_CalloutManagerMock_tst(200));
		IL_CalloutManager_cls cm = new IL_CalloutManager_cls('TestUrlParams');
		Map<String,String> urlParams = new Map<String,String>();
		urlParams.put('{param1}','test');
		cm.setUrlParams(urlParams);
		cm.setBody('data');
		cm.setBodyEncrypted(false);
		Test.setMock(HttpCalloutMock.class, multimock);
		Test.startTest();
		IL_HttpResponse_cls res = cm.doCallout();
		Test.stopTest();
		
		IL_CalloutParser.ResponseCallout data = (IL_CalloutParser.ResponseCallout) res.getData();
		IL_HttpResponse_cls response = cm.getResponse();
		Exception ex = response.getException();
		
		Assert.areEqual(IL_MultiMockRequest_cls.ERROR_MOCK_NO_FOUND,ex.getMessage());
		Assert.areEqual(0,multimock.getSize());
		Assert.areEqual(true,res.isError());
	}

}