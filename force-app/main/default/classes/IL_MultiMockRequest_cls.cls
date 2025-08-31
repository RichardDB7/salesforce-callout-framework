public class IL_MultiMockRequest_cls implements HttpCalloutMock{
	
	public static final String ERROR_MOCK_NO_FOUND = 'HTTP callout not supported for test methods | Mock no found';
	Map<String,HttpCalloutMock> mapMocks = new Map<String,HttpCalloutMock>();

	public IL_MultiMockRequest_cls(){

	}

	public IL_MultiMockRequest_cls(Map<String,HttpCalloutMock> mapMocks){
		this.mapMocks = mapMocks;
	}

	public HttpResponse respond(HttpRequest req){
		HttpCalloutMock mock = null;

		for(String key:mapMocks.keySet()){
			HttpCalloutMock mk = mapMocks.get(key);
			if(req.getEndpoint().startsWithIgnoreCase(key)){
				mock = mapMocks.get(key);
			}
		}

		if(mock != null){
			return mock.respond(req);
		}else{
			throw new IL_App_cls.NotFoundException(ERROR_MOCK_NO_FOUND);
		}
	}

	public void addRequestMock(String url, HttpCalloutMock mock){
		mapMocks.put(url,mock);
	}

	public void addRequestMock(IL_CalloutManager_cls cm, HttpCalloutMock mock){
		String url = cm.getFullEndpoint();
		mapMocks.put(url,mock);
	}

	public integer getSize(){
		return mapMocks.size();
	}
}