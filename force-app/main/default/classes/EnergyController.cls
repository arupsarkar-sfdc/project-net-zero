public class EnergyController {
    // Move this settings to custom metadata
    static String API_KEY = 'RP578ZAB4V4H76PQ4PSDN519JYW3';
    static String INTERMODAL_URL = 'https://beta3.api.climatiq.io/freight/intermodal';
    static String HOUSEHOLD_URL = 'https://beta3.api.climatiq.io/estimate';    
    static String POST_METHOD = 'POST';
    
    public static string getEnergyUse() {
        String result = '';
    	Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + API_KEY);
        req.setMethod(POST_METHOD);
        req.setEndpoint(INTERMODAL_URL);
        /*
        req.setEndpoint(HOUSEHOLD_URL);
        GHGHouseholdData data = getGHGEmissionPerHouseholdData();
        System.debug(JSON.serialize(data));
		*/
        req.setBody(getIntermodalFreightAirData());
        try{
            HttpResponse res = http.send(req);
            System.debug(LoggingLevel.DEBUG, res.getBody());
            System.debug(LoggingLevel.DEBUG, res.getStatusCode());
			System.debug(LoggingLevel.DEBUG, res.getStatus());
            
        }catch(Exception ex) {
            String error_msg = '';
            error_msg = 'Error Line Number : ' + ex.getLineNumber() + 
                		', Cause : ' + ex.getCause() + 
                		', Message : ' + ex.getMessage() +
                		', Stack Trace : ' + ex.getStackTraceString();
            System.debug(LoggingLevel.ERROR, error_msg);
        }
        
        return result;
    }
    
    private static string getIntermodalFreightRoadData() {
        String data = '{' +
            			'"route": [' +
            			'{ "location": { "query": "Hamburg" } },' +
            				'{' +
            					'"transport_mode": "road",' + 
            					'"leg_details": {' +
            						'"vehicle_type": "van",' +
            						'"vehicle_weight": "lte_3.5t"' +
            					'}' +
            				'},' +
            			'{ "location": { "query": "Paris" } }' +
            			'],' +
            			'"cargo": {' +
            					'"weight": 10,' +
            					'"weight_unit": "t"' +
            				'}' +
            		'}';
        return data;
    }
    
    private static string getIntermodalFreightAirData() {
        String data = '{' +
            			'"route": [' +
            			'{ "location": { "country": "US", "query": "John F Kennedy Intl" } },' +
            				'{' +
            					'"transport_mode": "air",' + 
            					'"leg_details": {' +
            						'"aircraft_type": "freighter",' +
            						'"methodology": "en16258"' +
            					'}' +
            				'},' +
            			'{ "location": { "country": "DE", "query": "Hamburg Airport" } }' +
            			'],' +
            			'"cargo": {' +
            					'"weight": 10,' +
            					'"weight_unit": "t"' +
            				'}' +
            		'}';
        return data;
    }    
    
    private static String getAirFreightData() {
        String data = '{' +
            '"emission_factor": {' +
            		'"activity_id": "freight_flight-route_type_domestic-distance_gt_1000km_lt_3500km-weight_gt_100t-rf_included"' +
            	'},' +
            	'"parameters": {' +
            			'"weight": 7,' +
            			'"weight_unit": "t",' +
            			'"distance": 130,' +
            			'"distance_unit": "km"' +
            	'}' +            
            
            '}';
        
        return data;
    }
    
    private static GHGHouseholdData getGHGEmissionPerHouseholdData() {
        
        String JSONdata = '{' +
            '"emission_factor": {' +
            		'"activity_id": "electricity-energy_source_grid_mix"' +
            	'},' +
            	'"parameters": {' +
            			'"energy": 4200,' +
            			'"energy_unit": "kWh"' +
            	'}' +            
            
            '}';
        GHGHouseholdData data = GHGHouseholdData.parse(JSONdata);
        return data;        
    }
    

}