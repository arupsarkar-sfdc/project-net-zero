/** POST Request implementation */
public with sharing class HttpPostCalloutService implements IHttpCalloutService {
    private String endpoint;
    private String body;
    public class HttpPostCalloutServiceException extends Exception {}    
    public HttpPostCalloutService(String endpoint, String body) {
        this.endpoint = endpoint;
        this.body = body;
    }

    public HttpResponse sendRequest(Map<String, String> parameters) {
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        HttpResponse response = new HttpResponse();
        try{
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setBody(body);

            for (String key : parameters.keySet()) {
                request.setHeader(key, parameters.get(key));
            }
            response = http.send(request);
        }catch(Exception e){
            System.debug('Exception: ' + e.getMessage());
            throw new HttpPostCalloutServiceException(' HttpPostCalloutService : ' + e.getMessage());
        }


        return response;
    }
}