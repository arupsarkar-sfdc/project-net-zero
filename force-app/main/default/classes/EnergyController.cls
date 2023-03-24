public with sharing class EnergyController {
    // Move this settings to custom metadata
    //static final String API_KEY = 'RP578ZAB4V4H76PQ4PSDN519JYW3';
	static final String[] CLIMATEIQ_PARAMS = getClimateIQParams();
	static final String API_KEY = CLIMATEIQ_PARAMS[0];
    static final String INTERMODAL_URL = CLIMATEIQ_PARAMS[1];
    static final String HOUSEHOLD_URL = CLIMATEIQ_PARAMS[2];    
    static final String POST_METHOD = 'POST';

	public EnergyController(String data) {
		String body;
		if(data.equals('getIntermodalFreightAirData')) {
			body = getIntermodalFreightAirData();
			getEnergyUse(body);
		}else if(data.equals('getIntermodalFreightRoadData')) {
			body = getIntermodalFreightRoadData();
			getEnergyUse(body);
		}else if(data.equals('getAirFreightData')) {
			body = getAirFreightData();
			getEnergyUse(body);
		}
	}
    
    private static string getEnergyUse(String payload) {

		String method = POST_METHOD;
		//String body = getIntermodalFreightAirData();
		String body = payload;
		String endpoint = INTERMODAL_URL;
		Map<String, String> headers = new Map<String, String>();
		headers.put('Content-Type', 'application/json');    
		headers.put('Accept', 'application/json');
		headers.put('Authorization', 'Bearer ' + API_KEY);
        String result = '';
        try{
			HttpCalloutController.method = method;
			HttpCalloutController.body = body;
			HttpCalloutController.endpoint = endpoint;
			HttpCalloutController.headers = headers;
			result = HttpCalloutController.executeCallout();
            
        }catch(Exception ex) {
            String error = '';
            error = 'Error Line Number : ' + ex.getLineNumber() + 
                		', Cause : ' + ex.getCause() + 
                		', Message : ' + ex.getMessage() +
                		', Stack Trace : ' + ex.getStackTraceString();
            System.debug(LoggingLevel.ERROR, error);
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

	private static String[] getClimateIQParams() {
		String[] params = new String[3];
        // Get the custom metadata object's schema descriptor
        Schema.SObjectType mdtType = Climate_IQ_Setting__mdt.getSObjectType();
		// Check if the current user has read permission for the custom metadata type
		DescribeSObjectResult mdtTypeDesc = mdtType.getDescribe();
		Boolean isAccessible = mdtTypeDesc.isAccessible();
        // Check if the current user has read permission for the custom metadata type
		if (isAccessible) {
			List<Climate_IQ_Setting__mdt> metadataRecords = [
				SELECT MasterLabel, DeveloperName, api_key__c, intermodal_url__c, household_url__c
				FROM Climate_IQ_Setting__mdt
				WITH SECURITY_ENFORCED
				LIMIT 1
				
			];		
			params[0] = metadataRecords[0].api_key__c;
			params[1] = metadataRecords[0].intermodal_url__c;
			params[2] = metadataRecords[0].household_url__c;			
		}

		return params;
	}
    

}