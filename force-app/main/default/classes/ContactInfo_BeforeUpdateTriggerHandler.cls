public class ContactInfo_BeforeUpdateTriggerHandler extends TriggerHandlerBase{
    public override void mainEntry(TriggerParameters tp){
        if(TriggerContextUtility.isFirstRun()){
            TriggerContextUtility.setFirstRunFalse();
            process((Map<Id,Contact_Information__c>)tp.oldMap, (List<Contact_Information__c>)tp.newList);
        }
    }
    
    void process (Map<Id,Contact_Information__c> old_contact_Info, List<Contact_Information__c> new_contact_Info) {
        update_phone(new_contact_Info,old_contact_Info);
    }
    /** 
* @author Ammara Alvi
* @date 05/10/2021
* @description update Phone Field.
* @returntype Void
* @param List<Contact> contact_new,Map<id,Contact>  OldContact
*/		
    public static void update_phone(List<Contact_Information__c> contact_new,Map<id,Contact_Information__c>  OldContact){
        Map<id,Contact_Information__c> contact_map = new Map<id,Contact_Information__c>();
        for(Contact_Information__c cnt:contact_new){
            Contact_Information__c cont = OldContact.get(cnt.id);
            if(cnt.Country_Code__c != null && cnt.Phone_Number__c != null){
                String []str = cnt.Country_Code__c.split('\\(');
                String []strFinal = str[1].split('\\)');
                String countCode = strFinal[0];
                String FinalPh;
                String PhoneNumber='';
                String strPh = cnt.Phone_Number__c;
                Boolean check=false;
                Integer len = strPh.length();  
                FinalPh='+';
                if(cont != null && (cnt.Country_Code__c != cont.Country_Code__c || cnt.Phone_Number__c != cont.Phone_Number__c))
                    
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
                                check = false;
                            }
                        }
                        FinalPh = FinalPh + PhoneNumber;
                        if(cont.Phone__c != FinalPh){
                            cnt.Phone__c = FinalPh;
                            cnt.Name = FinalPh;
                        }
                    }
                else
                    cnt.addError(Label.Phone_Format_Error);
            }
            else{
                if(cnt.Country_Code__c != null && cnt.Phone_Number__c == null)
                    cnt.addError('Please Enter Phone Number in the format [phone number(4-15 digits only)], with no spaces or hyphens.');
                else if(cnt.Country_Code__c == null && cnt.Phone_Number__c != null)
                    cnt.addError('Please Select Country Code.');
                else if(cnt.Country_Code__c == null && cnt.Phone_Number__c == null){
                    cnt.Phone__c = null;
                }
            }
        }
    }
}