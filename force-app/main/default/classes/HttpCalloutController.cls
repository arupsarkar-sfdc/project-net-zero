public with sharing class HttpCalloutController {

    public static String method{get; set;}
    public static String endpoint{get; set;}    
    public static String body{get; set;}
    public static Map<String, String> headers{get; set;}


    public static String executeCallout() {
        String result = '';
        // Create an instance of IHttpCalloutService using the factory
        IHttpCalloutService httpCalloutService = HttpCalloutFactory.createCalloutService(method, endpoint, body);
        // Execute the callout and handle the response
        HttpResponse response = httpCalloutService.sendRequest(headers);
        System.debug(LoggingLevel.INFO, 'Response: ' + response.getBody());
        if(response.getStatusCode() == 200) {
            result = response.getBody();
        } else {
            result = 'Error: ' + response.getStatusCode() + ' ' + response.getStatus();
        }
        return result;

    }
}