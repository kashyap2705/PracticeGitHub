/**
* <h1>Create a Mock Data</h1>
* This class is responsible for Creating a dummy response to a Http callout ,DE6212
* 
* @author  Ahmad Shakeel
* @version 1.0
* @since   10-17-2019 
*/
@isTest
global class updateLatLongMockTest implements HttpCalloutMock {
  
    
     /**
* This method is used to return a Http json formatted response.
* @param HTTPRequest.
* @return HTTPResponse.
*/
    global HTTPResponse respond(HTTPRequest req) {
      
        List<Google_maps__c> mapsData=new List<Google_maps__c>();
        try{
            mapsData=[SELECT Google_Geocoding_API_Key__c,Enable_Geocoding_API_Calls__c FROM Google_maps__c];
        }
        catch(Exception e)
        {
            System.debug('Exception'+e);
            
        }
        
        //System.assertEquals('https://maps.googleapis.com/maps/api/geocode/json?address=Behria+Town,Lahore,Pakistan&key='+mapsData[0].Google_Geocoding_API_Key__c, req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"results" : [{"address_components" : [{"long_name" : "1600","short_name" : "1600","types" : [ "street_number" ]},{"long_name" : "Amphitheatre Pkwy","short_name" : "Amphitheatre Pkwy","types" : [ "route" ]},{"long_name" : "Mountain View","short_name" : "Mountain View","types" : [ "locality", "political" ]},{"long_name" : "Santa Clara County","short_name" : "Santa Clara County","types" : [ "administrative_area_level_2", "political" ]},{"long_name" : "California","short_name" : "CA","types" : [ "administrative_area_level_1", "political" ]},{"long_name" : "United States","short_name" : "US","types" : [ "country", "political" ]},{"long_name" : "94043","short_name" : "94043","types" : [ "postal_code" ]}],"formatted_address" : "1600 Amphitheatre Parkway, Mountain View, CA 94043, USA","geometry" : {"location" : {"lat" : 37.4224764,"lng" : -122.0842499},"location_type" : "ROOFTOP","viewport" : {"northeast" : {"lat" : 37.4238253802915,"lng" : -122.0829009197085},"southwest" : {"lat" : 37.4211274197085,"lng" : -122.0855988802915}}},"place_id" : "ChIJ2eUgeAK6j4ARbn5u_wAGqWA","types" : [ "street_address" ]}]}');
        res.setStatusCode(200);
        return res;
    }
}