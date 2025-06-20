public class ContactInfo_AfterInsertTriggerHandler extends TriggerHandlerBase{
    public override void mainEntry(TriggerParameters tp){
        if(TriggerContextUtility.isFirstRun()){
            //TriggerContextUtility.setFirstRunFalse();
            process((Map<Id,Contact_Information__c>)tp.oldMap, (Map<Id,Contact_Information__c>)tp.newMap ,(list<Contact_Information__c>)tp.newList
                    ,(list<Contact_Information__c>)tp.oldList);
        }
    }
    
    private static void process (Map<Id,Contact_Information__c> oldmap, Map<Id,Contact_Information__c> newmap, 
                                 list<Contact_Information__c> newlist , list<Contact_Information__c> oldlist)  {
                                     addphone( newlist);                      
                                     
                                 }
    private static void addphone(List<Contact_Information__c> new_contact_Info){
        for(Contact_Information__c cnt:new_contact_Info){
            String []str;
            String []strFinal;
            String countCode ;
            String FinalPh;
            String PhoneNumber='';
            String strPh ;
            Boolean check;
            Integer len ;  
            if(cnt.Country_Code__c != null && cnt.Phone_Number__c != null){
                str = cnt.Country_Code__c.split('\\(');
                strFinal = str[1].split('\\)');
                countCode = strFinal[0];
                strPh = String.valueOf(cnt.Phone_Number__c);
                check=false;
                len = strPh.length();  
                FinalPh='+';
                
                //Phone Validation updated to 4-15 digits
                if(len<=15 && len>3  && strPh.isNumeric()){
                    for(Integer x=1;x<countCode.length();x++){
                        if((countCode.charAt(x)>=48 && countCode.charAt(x)<=57)){
                            FinalPh=FinalPh+String.valueOf((countCode.charAt(x)-48));
                        }
                    }
                    for(Integer x=0;x<strPh.length();x++){
                        if((strPh.charAt(x)>=48 && strPh.charAt(x)<=57) ){
                            PhoneNumber = PhoneNumber+String.valueOf((strPh.charAt(x)-48));
                        }
                    }
                    FinalPh = FinalPh + String.valueOf(PhoneNumber);
                    cnt.Phone__c = FinalPh;          
                }
                else
                    cnt.addError(Label.Phone_Format_Error);
            }
            else{
                System.debug('Country Code: '+cnt.Country_Code__c+' Phone: '+cnt.Phone_Number__c);
                if(cnt.Country_Code__c != null && cnt.Phone_Number__c == null)
                    cnt.addError('Please Enter Phone Number in the format [phone number(4-15 digits only)], with no spaces or hyphens.');
                else if(cnt.Country_Code__c == null && cnt.Phone_Number__c != null)
                    cnt.addError('Please Select Country Code.');
                else if(cnt.Country_Code__c == null && cnt.Phone_Number__c == null){
                    cnt.Phone__c = null;
                }
            }
        }
        //update new_contact_Info;
    }
}