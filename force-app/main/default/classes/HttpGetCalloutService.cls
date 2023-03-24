/** GET Request implementation */
public with sharing class HttpGetCalloutService implements IHttpCalloutService {

    private String endpoint;
    public class HttpGetCalloutServiceException extends Exception {}    
    public HttpGetCalloutService(String endpoint) {
        this.endpoint = endpoint;
    }

    public HttpResponse sendRequest(Map<String, String> parameters) {
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        HttpRequest req = new HttpRequest();        
        try {
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            for (String key : parameters.keySet()) {
                req.setHeader(key, parameters.get(key));
            }
    
            response = http.send(req);
            return response;            
        }
        catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error in HttpGetCalloutService.sendRequest: ' + e.getMessage());
            throw new HttpGetCalloutServiceException('Error in HttpGetCalloutService.sendRequest: ' + e.getMessage());
        }
    }

}