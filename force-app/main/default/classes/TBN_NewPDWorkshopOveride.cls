public without sharing class TBN_NewPDWorkshopOveride {

    private string OBJECT_NAME = 'PD_Provider_Workshop__c'; 
    public TBN_NewPDWorkshopOveride(ApexPages.StandardController controller) {
         
    }

    /**
    @MethodName : fetchRedirectUrl
    @Param      : None
    @Description: Method to fetch the method to be redirected to
    **/
    public PageReference fetchRedirectUrl() { 
        map<String,String> mapFieldNameToFieldId = new map<String,String>();
        Map<String, String> pageParams = ApexPages.currentPage().getParameters();
        PageReference pgRef = new PageReference('/'+String.valueOf(PD_Provider_Workshop__c.sObjectType.getDescribe().getKeyPrefix())+'/e');
        pgRef.getParameters().putAll(pageParams);
        pgRef.getParameters().put('nooverride', '1');
        pgRef.getParameters().remove('save_new');
        
        for(Object_Field_IDs__c objFI : [Select Name,Field_ID__c
                                         From Object_Field_IDs__c
                                         Where Object_API_Name__c =: OBJECT_NAME]) {

                mapFieldNameToFieldId.put(objFI.Name,objFI.Field_ID__c);
        }
        
        string strlookupKey = 'CF'+mapFieldNameToFieldId.get('PD_Provider_Event__c')+'_lkid';     
        if(pageParams.containsKey(strlookupKey)) {
        
            list<PD_Provider_Event__c>lstPDEvent = [Select CurrencyIsoCode
                                                    From PD_Provider_Event__c
                                                    Where Id =: pageParams.get(strlookupKey)];
            
            if(!lstPDEvent.IsEmpty()) { 
            
                pgRef.getParameters().put(String.valueOf(mapFieldNameToFieldId.get('Currency_PD_Provider_Workshop')), String.valueOf(lstPDEvent[0].CurrencyIsoCode));
            }
        }
        
        pgRef.setRedirect(true);  
        return pgRef;
    }
}