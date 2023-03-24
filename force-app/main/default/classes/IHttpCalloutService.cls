/** Default HTTP Callout Service interface */
public interface IHttpCalloutService {
    HttpResponse sendRequest(Map<String, String> parameters);
}