public without sharing class TBN_NewPDEventOveride {

    private string OBJECT_NAME = 'PD_Provider_Event__c'; 
    public TBN_NewPDEventOveride(ApexPages.StandardController controller) {
         
    }

    /**
    @MethodName : fetchRedirectUrl
    @Param      : None
    @Description: Method to fetch the method to be redirected to
    **/
    public PageReference fetchRedirectUrl()
    { 
        map<String,String> mapFieldNameToFieldId = new map<String,String>();
        Map<String, String> pageParams = ApexPages.currentPage().getParameters();
        PageReference pgRef = new PageReference('/'+String.valueOf(PD_Provider_Event__c.sObjectType.getDescribe().getKeyPrefix())+'/e');
        pgRef.getParameters().putAll(pageParams);
        pgRef.getParameters().put('nooverride', '1');
        pgRef.getParameters().remove('save_new');
        
        list<User> lstUser = [Select Contact.Account.Region__c,Contact.Account.Sub_region__c,Contact.Account.CurrencyIsoCode
                              From User
                              Where Id =: UserInfo.getUserId()
                              AND ContactId != Null
                              And Profile.Name = 'External PD Provider'];

        if(!lstUser.IsEmpty()) { 
            
            for(Object_Field_IDs__c objFI : [Select Name,Field_ID__c
                                              From Object_Field_IDs__c
                                              Where Object_API_Name__c =: OBJECT_NAME])

                mapFieldNameToFieldId.put(objFI.Name,objFI.Field_ID__c);

            pgRef.getParameters().put(String.valueOf(mapFieldNameToFieldId.get('Currency_PD_Provider_Event')), String.valueOf(lstUser[0].Contact.Account.CurrencyIsoCode));
            pgRef.getParameters().put(String.valueOf(mapFieldNameToFieldId.get('Event_Sub_Region__c')), String.valueOf(lstUser[0].Contact.Account.Sub_region__c));    
            pgRef.getParameters().put(String.valueOf(mapFieldNameToFieldId.get('Event_Region__c')), String.valueOf(lstUser[0].Contact.Account.Region__c));    

       }

       pgRef.setRedirect(true);  
       return pgRef; 
    }
}