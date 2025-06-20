public with sharing class ChainedContinuationController {
    
    // Unique label for the initial callout request
    public String requestLabel1;
    // Unique label for the chained callout request
    public String requestLabel2;
    // Result of initial callout
    public String result1 {get;set;}
    // Result of chained callout
    public String result2 {get;set;}
    // Endpoint of long-running service
    private static final String LONG_RUNNING_SERVICE_URL1 = 'https://long-running.herokuapp.com/products' ; //'https://www.zipcodeapi.com/rest/XUdRusqAL97aO28KYyMzfhZmkBLzSl7Qs853mWwzTSlxLRktAmrNTfQ2kr9bd8BE/info.json/95051/degrees';
    private static  String LONG_RUNNING_SERVICE_URL2 ='https://long-running.herokuapp.com/products' ;  //'http://openweathermap.org/data/2.5/weather?q=santa%20clara&appid=b6907d289e10d714a6e88b30761fae22';
    
    // Action method
    public Object invokeInitialRequest() {
        // Create continuation with a timeout
        Continuation con = new Continuation(10);
        // Set callback method
        con.continuationMethod='processInitialResponse';
        
        // Create first callout request
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        //req.setEndpoint(LONG_RUNNING_SERVICE_URL1);
        req.setEndpoint('https://long-running.herokuapp.com/products');
        // Add initial callout request to continuation
        this.requestLabel1 = con.addHttpRequest(req);              
        
        // Return the continuation
        return con;  
    }
    
    // Callback method for initial request
    public Object processInitialResponse() {   
        // Get the response by using the unique label
        HttpResponse response = Continuation.getResponse(this.requestLabel1);
        // Set the result variable that is displayed on the Visualforce page
        this.result1 = response.getBody();
        system.debug('this.result1*****'+this.result1);
        
        ZipParser parser =  (ZipParser) System.JSON.deserialize(response.getBody(), ZipParser.class);
        System.debug('parser'+parser);
        
        Continuation chainedContinuation = null;
        // Chain continuation if some condition is met
        if (parser.city!=null) {
            // Create a second continuation 
            chainedContinuation = new Continuation(10);
            // Set callback method
            chainedContinuation.continuationMethod='processChainedResponse';
            
            // Create callout request
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            
            // LONG_RUNNING_SERVICE_URL2 ='http://openweathermap.org/data/2.5/weather?q='+parser.city+',usa'+'&appid=b6907d289e10d714a6e88b30761fae22';
            req.setEndpoint(LONG_RUNNING_SERVICE_URL2);
            
            // Add callout request to continuation
            this.requestLabel2 = chainedContinuation.addHttpRequest(req); 
        }
        
        // Start another continuation 
        return chainedContinuation;  
    }    
    
    // Callback method for chained request
    public Object processChainedResponse() {   
        // Get the response for the chained request
        HttpResponse response = Continuation.getResponse(this.requestLabel2);
        // Set the result variable that is displayed on the Visualforce page
        this.result2 = response.getBody();
        System.debug('result2result2'+result2);
        // Return null to re-render the original Visualforce page
        return null;
    }
    
    
    public class ZipParser{
        public String zip_code;	//95051
        public Double lat;	//37.348656
        public Double lng;	//-121.984433
        public String city{get;set;}	//Santa Clara
        public String state{get;set;}	//CA
        public cls_timezone timezone;
        public cls_acceptable_city_names[] acceptable_city_names;
    }
    public class cls_timezone {
        public String timezone_identifier;	//America/Los_Angeles
        public String timezone_abbr;	//PST
        public Integer utc_offset_sec;	//-28800
        public String is_dst;	//F
    }
    public  class cls_acceptable_city_names {
    }
    
    
    
    
    
    
}