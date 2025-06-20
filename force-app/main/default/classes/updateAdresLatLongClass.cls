/**
 * <h1>Update the Latitude and Longitude</h1>
 * This class is responsible for Updating the latitude and Longitude fields on Ib Address object,DE6212
 *
 * @author  Ahmad Shakeel
 * @version 1.0
 * @since   10-10-2019
 */

public class updateAdresLatLongClass {
    public static boolean FirstRun=true;
    /**
     * This method is used to make Google Geocoding API Calls and Update latitude and Longitude
     * fields of Ib Address Object.
     * @param Set of ids.
     * @return Void
     */
    @future (callout=true)
    Public static void  doCalloutFromFuture(Set<id> ids)
    {
        System.debug('ids passed to class: ' + ids);
        List<Google_maps__c> mapsData=new List<Google_maps__c>();
        try{
            mapsData=[SELECT Google_Geocoding_API_Key__c,Enable_Geocoding_API_Calls__c FROM Google_maps__c];
        }
        catch(Exception e)
        {
            System.debug('Exception'+e);
            
        }
        
        if(mapsData.size()> 0){
            if(mapsData[0].Enable_Geocoding_API_Calls__c==true)
            {
                boolean makeCall=false;
                List<String> Stri=new List<String>();
                List<IB_Address__c> listToUpdate=new List<IB_Address__c>();
                List<IB_Address__c> ibAd=new List<IB_Address__c>();
                try
                {
                    ibAd=[SELECT id,Address_Lines__c,Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,Address_Line_4__c, MAUTC_Offset__c,MALatitude__c,MALongitude__c,City__c,Country__c,Postal_Code__c,Province__c, Geolocation_Override__c FROM IB_Address__c WHERE id IN:ids];
                    
                }
                catch(Exception e)
                {
                    system.debug('excep'+e);
                    
                }
                Set<id> idOfCountry=new Set<id>();
                For(Integer x=0;x<ibAd.size();x++)
                {
                    idOfCountry.add(ibAd[x].Country__c);
                }
                
                
                Map<id,IB_Country_Segmentation__c> CountryNameMap=new Map<id,IB_Country_Segmentation__c>([SELECT Name,id from IB_Country_Segmentation__c WHERE Id IN:idOfCountry]);
                System.debug(ibAd);
                for(Integer i=0;i<ibAd.size();i++)
                {
                    
                    String restAPIURL;
                    String restAPIURL_timezone;
                    makeCall=false;
                    
                    //String address=ibAd[i].Address_Lines__c.replace(' ', '+');
                    String address = '';
                    If(ibAd[i].Address_Line_1__c != null){
                        address = ibAd[i].Address_Line_1__c.replace(' ', '+');
                    }
                    If(ibAd[i].Address_Line_2__c != null){
                        if(address != null){
                            address = address + ',+' + ibAd[i].Address_Line_2__c.replace(' ', '+');
                        }else{
                            address = ibAd[i].Address_Line_2__c.replace(' ', '+');
                        }
                    }
                    If(ibAd[i].Address_Line_3__c != null){
                        if(address != null){
                            address = address + ',+' + ibAd[i].Address_Line_3__c.replace(' ', '+');
                        }else{
                            address = ibAd[i].Address_Line_3__c.replace(' ', '+');
                        }
                    }
                    If(ibAd[i].Address_Line_4__c != null){
                        if(address != null){
                            address = address + ',+' + ibAd[i].Address_Line_4__c.replace(' ', '+');
                        }else{
                            address = ibAd[i].Address_Line_4__c.replace(' ', '+');
                        }
                    }
                    address = address.replace('#', '');
                    
                    IB_Country_Segmentation__c countryName=Null;
                    if(CountryNameMap.size()>0)
                    {
                        countryName=CountryNameMap.get(ibAd[i].Country__c);
                        
                    }
                    
                    
                    if(address!=Null && countryName!=Null && ibAd[i].City__c!=Null && ibAd[i].Province__c!=Null)
                    {
                        makeCall=true;
                        if(Test.isRunningTest())
                        {
                            restAPIURL ='https://maps.googleapis.com/maps/api/geocode/json?address=Behria+Town,Lahore,Pakistan&key='+mapsData[0].Google_Geocoding_API_Key__c;
                        }
                        else
                        {
                            restAPIURL ='https://maps.googleapis.com/maps/api/geocode/json?address='+address+',+'+ibAd[i].City__c.replace(' ','+')+',+'+ibAd[i].Province__c.replace(' ','+')+',+'+countryName.Name.replace(' ','+')+'&key='+mapsData[0].Google_Geocoding_API_Key__c;
                            
                        }
                    }
                    else if(address!=Null && countryName!=Null && ibAd[i].City__c!=Null)
                    {
                        makeCall=true;
                        if(Test.isRunningTest())
                        {
                            restAPIURL ='https://maps.googleapis.com/maps/api/geocode/json?address=Behria+Town,Lahore,Pakistan&key='+mapsData[0].Google_Geocoding_API_Key__c;
                        }
                        else
                        {
                            restAPIURL ='https://maps.googleapis.com/maps/api/geocode/json?address='+address+',+'+ibAd[i].City__c.replace(' ','+')+',+'+countryName.Name.replace(' ','+')+'&key='+mapsData[0].Google_Geocoding_API_Key__c;
                            
                            
                        }
                    }
                    
                    System.debug('FullString'+restAPIURL);
                    
                    if( makeCall==true)
                    {
                        
                        HttpRequest httpRequest = new HttpRequest();
                        
                        httpRequest.setMethod('GET');
                        
                        httpRequest.setEndpoint(restAPIURL);
                        
                        String response = '';
                        Boolean flag=false;
                        
                        
                        try {
                            String lat,lng;
                            Http http = new Http();
                            HttpResponse httpResponse;
                            if(!Test.isRunningTest()){
                                httpResponse = http.send(httpRequest);
                            }else{
                                Test.setMock(HttpCalloutMock.class, new updateLatLongMockTest());
                                httpResponse = http.send(httpRequest);
                            }
                            System.debug('this: '+httpResponse.getBody());
                            /***This Part is updated by Ammara-Plumlogix as part of US-12418,Staff-Aug Project(Sprint 27)*/
                            /***Add UTC Offset on IB Address
                            /***Begin***/
                            if (httpResponse.getStatusCode() == 200 ) {
                                JSONParser parser = JSON.createParser(httpResponse.getBody());
                                
                                while (parser.nextToken() != null) {
                                    
                                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                                    (parser.getText() == 'formatted_address')) {
                                        flag=true;
                                        // Get the value.
                                        
                                        
                                        parser.nextToken();
                                        System.debug('Formatted address: '+parser.getText());
                                        
                                    }
                                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                                    (parser.getText() == 'lat') && flag==true) {
                                        //Move to next token
                                        parser.nextToken();
                                        if(ibAd[i].Geolocation_Override__c == false){
                                            ibAd[i].MALatitude__c=Decimal.ValueOf(parser.getText());
                                            // Get the value.
                                        }
                                        
                                        System.debug('Lat'+parser.getText());
                                        stri.add(parser.getText());
                                        lat = parser.getText();
                                    }
                                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                                    (parser.getText() == 'lng') && flag==true) {
                                        flag=false;
                                        //Move to next token
                                        parser.nextToken();
                                        if(ibAd[i].Geolocation_Override__c == false){
                                            ibAd[i].MALongitude__c=Decimal.ValueOf(parser.getText());
                                            // Get the value.
                                        }
                                        
                                        
                                        
                                        System.debug('lng'+parser.getText());
                                        stri.add(parser.getText());
                                        lng = parser.getText();
                                    }
                                    //added by Jagan US-0002211
                                    if(lat!=null && lng!=null){
                                        break;
                                    }
                                }
                                if((lat != null && lng != null && ibAd[i].Geolocation_Override__c == false) || (ibAd[i].MALongitude__c != null && ibAd[i].MALatitude__c != null && ibAd[i].Geolocation_Override__c == true)){
                                    if(ibAd[i].Geolocation_Override__c == true){
                                        restAPIURL_timezone ='https://maps.googleapis.com/maps/api/timezone/xml?location='+ ibAd[i].MALatitude__c + ',' + ibAd[i].MALongitude__c + '&timestamp='+label.timestampForGMapsAPI+'&key='+mapsData[0].Google_Geocoding_API_Key__c;
                                    } else {
                                        restAPIURL_timezone ='https://maps.googleapis.com/maps/api/timezone/xml?location='+lat+ ',' +lng+ '&timestamp='+label.timestampForGMapsAPI+'&key='+mapsData[0].Google_Geocoding_API_Key__c;
                                    }
                                    system.debug('Full String for timezone callout: ' + restAPIURL_timezone);
                                    HttpRequest httpRequest_timezone = new HttpRequest();
                                    
                                    httpRequest_timezone.setMethod('GET');
                                    
                                    httpRequest_timezone.setEndpoint(restAPIURL_timezone);
                                    Http http_timezone = new Http();
                                    HttpResponse httpResponse_timezone ;
                                    
                                    httpResponse_timezone = http_timezone.send(httpRequest_timezone);
                                    
                                    System.debug('this time: '+httpResponse_timezone.getBody());
                                    if (httpResponse_timezone.getStatusCode() == 200 ) {
                                        
                                        JSONParser parser_timezone = JSON.createParser(httpResponse_timezone.getBody());
                                        Dom.Document doc = new Dom.Document();
                                        if(!Test.isRunningTest()){
                                            doc.load(httpResponse_timezone.getBody());
                                            Dom.XMLNode xroot = doc.getRootElement();
                                            String docstring = doc.toXmlString();
                                            //Checking if google api had results for time zone
                                            If(!docstring.contains('ZERO_RESULTS')){
                                                String TimeZone = xroot.getChildElement('raw_offset', null).getText();
                                                System.debug('Derrick: TimeZone: ' + TimeZone);
                                                ibAd[i].MAUTC_Offset__c = TimeZone;
                                            }
                                        }
                                    }
                                    
                                    
                                    
                                    
                                    
                                }
                                else{
                                    System.debug('kevin debug');
                                    ibAd[i].MALatitude__c = null;
                                    ibAd[i].MALongitude__c = null;
                                    ibAd[i].MAUTC_Offset__c = null;
                                }
                            }
                            else {
                                
                                
                                System.debug(' httpResponse ' + httpResponse.getBody() );
                                
                                throw new CalloutException( httpResponse.getBody() );
                                
                                
                            }
                            /***End***/
                            
                        }
                        catch( System.Exception e) {
                            
                            System.debug('ERROR: '+ e);
                            
                            throw e;
                            
                        }
                        
                        
                        
                        listToUpdate.add(ibAd[i]);
                    }
                }
                try
                {
                    update listToUpdate;
                    FirstRun=true;
                }
                catch(DMLException e)
                {
                    System.debug('DML exception');
                }
            }
        }
    }
    
}