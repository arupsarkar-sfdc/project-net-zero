public with sharing class HttpCalloutFactory {
    
    public class CalloutException extends Exception {}
    
    public static IHttpCalloutService createCalloutService(String type, String endpoint, String body) {
        if (type.equalsIgnoreCase('GET')) {
            return new HttpGetCalloutService(endpoint);
        } else if (type.equalsIgnoreCase('POST')) {
            return new HttpPostCalloutService(endpoint, body);
        } else {
            throw new CalloutException('Unsupported callout type: ' + type);
        }
    }

}