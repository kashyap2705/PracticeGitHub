public class AccountTriggerHandler {
    
    public static Boolean RunOnlyOnce = true;
    
    /** 
* @author Ammara Alvi
* @date 05/10/2021
* @description update Phone Field.
* @returntype Void
* @param List<Contact> contact_new,Map<id,Contact>  OldContact
*/      
    public static void updatephone(List<Account> contact_new,Map<id,Account>  OldContact){
        ID Recordtype_id = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId();
        ID Recordtype_id_inst = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IB Institute').getRecordTypeId();
        ID recordtype_id_op = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Online Provider').getRecordTypeId();
        // Below part is added by Suraj As a part of ECM00511
        ID grpOfSchooolRcdId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Groups of Schools').getRecordTypeId(); //END
        
        Map<id,Account> contact_map = new Map<id,Account>();
        for(Account cnt:contact_new){ 
            
            System.debug('Record Type: '+Recordtype_id_inst);
            System.debug('Record Type School Account: '+Recordtype_id);
            System.debug('GOS Record Type: '+grpOfSchooolRcdId);
            System.debug('Current Records type: '+cnt.RecordTypeId);
            Account cont = OldContact.get(cnt.id);
            if(Recordtype_id != null && cnt.RecordTypeId == Recordtype_id && cnt.RecordTypeID != grpOfSchooolRcdId){
                
                
                if(cnt.Dial_code__c != null && cnt.Phone_Number__c != null){
                    String []str = cnt.Dial_code__c.split('\\(');
                    String []strFinal = str[1].split('\\)');
                    String countCode = strFinal[0];
                    String FinalPh;
                    String PhoneNumber='';
                    String strPh = cnt.Phone_Number__c;
                    Boolean check=false;
                    Integer len = strPh.length();  
                    FinalPh='+';
                    if(cont != null && (cnt.Dial_code__c != cont.Dial_code__c || cnt.Phone_Number__c != cont.Phone_Number__c))
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
                            if(cont.Phone != FinalPh){
                                cnt.Phone = FinalPh;
                            }
                        }
                    else
                        cnt.addError(Label.Phone_Format_Error);
                }
                else{
                    if(cnt.Dial_code__c != null && cnt.Phone_Number__c == null  && cnt.RecordTypeID != grpOfSchooolRcdId)
                        cnt.addError('Please Enter Phone Number in the format [phone number(9-15 digits only)], with no spaces or hyphens.');
                    else if(cnt.Dial_code__c == null && cnt.Phone_Number__c != null  && cnt.RecordTypeID != grpOfSchooolRcdId)
                        cnt.addError('Please Select Country Code.');
                    
                    else if(cnt.Dial_code__c == null && cnt.Phone_Number__c == null  && cnt.RecordTypeID != grpOfSchooolRcdId){
                        if(cont.Dial_code__c != null && cont.Phone_Number__c != null && cont.Phone != null)
                            cnt.Phone = null;
                    }
                }
            }
            else if((Recordtype_id_inst != null && cnt.RecordTypeId == Recordtype_id_inst) || (recordtype_id_op != null && cnt.RecordTypeId == recordtype_id_op)){
                
                //Account cont = OldContact.get(cnt.id);
                
                
                //Phone Field
                
                if(cnt.Dial_code__c != null && cnt.Phone != null){
                    String []str = cnt.Dial_code__c.split('\\(');
                    String []strFinal = str[1].split('\\)');
                    String countCode = strFinal[0];
                    String FinalPh;
                    String PhoneNumber='';
                    String strPh='';
                    Boolean check=false;
                    FinalPh='+';
                    String phone_valid = cnt.Phone;
                    
                    
                    
                    
                    if(cont != null && (cnt.Dial_code__c != cont.Dial_code__c || cnt.Phone != cont.Phone)){
                        strPh = phone_valid.replaceAll('[^a-zA-Z0-9!@#$^&*~`+]', '');
                        
                        
                        System.debug('phone_valid '+strPh);
                        
                        
                        
                        
                        
                        
                        Integer len = strPh.length();  
                        System.debug('Length '+len);
                        System.debug('phone_valid '+strPh);
                        
                        
                        if(len<4 || len >15 || !(strph.isNumeric()))
                            
                            
                            cnt.addError('Please Enter Phone Number in the format [phone number(9-15 digits only)]');
                    }
                    else {
                        if(cnt.Dial_code__c != null && cnt.Phone == null && cnt.RecordTypeID != grpOfSchooolRcdId)
                            cnt.addError('Please Enter Phone Number in the format [phone number(9-15 digits only)]');
                        
                        else if(cnt.Dial_code__c == null && cnt.Phone != null && cnt.RecordTypeID != grpOfSchooolRcdId)
                            cnt.addError('Please Select Country Code.');
                    }
                }
                
            }
            else{
                if(cnt.Dial_code__c != null && cnt.Phone == null && cnt.RecordTypeID != grpOfSchooolRcdId)
                    
                    cnt.addError('Please Enter Phone Number in the format [phone number(9-15 digits only)]');
                else if(cnt.Dial_code__c == null && cnt.Phone != null && cnt.RecordTypeID != grpOfSchooolRcdId)
                    cnt.addError('Please Select Country Code.');
                
            }
            
            //Alternative Phone Field
            if(cnt.Dial_code2__c != null && cnt.Phone2__c != null){
                String []str = cnt.Dial_code2__c.split('\\(');
                String []strFinal = str[1].split('\\)');
                String countCode = strFinal[0];
                String FinalPh;
                String PhoneNumber='';
                String strPh = '';
                Boolean check=false; 
                FinalPh='+';
                String phone_valid = cnt.Phone2__c;
                if(cont != null && (cnt.Dial_code2__c != cont.Dial_code2__c || cnt.Phone2__c != cont.Phone2__c)){
                    
                    
                    
                    System.debug('phone_valid 2 '+cnt.Phone2__c);
                    strPh = phone_valid.replaceAll('[^a-zA-Z0-9!@#$^&*~`+]', '');
                    System.debug('phone_valid 2 '+strPh);
                    
                    
                    
                    
                    Integer len = strPh.length();  
                    System.debug('Length '+len);
                    System.debug('phone_valid '+strPh);
                    if(len<4 || len >15 || !(strph.isNumeric()))
                        
                        
                        cnt.addError('Please Enter Alternative Phone in the format [phone number(9-15 digits only)].');
                }
                else{
                    if(cnt.Dial_code2__c != null && cnt.Phone2__c == null)
                        cnt.addError('Please Enter Alternative Phone in the format [phone number(9-15 digits only)].');
                    else if(cnt.Dial_code2__c == null && cnt.Phone2__c != null)
                        cnt.addError('Please Select Alternate Phone - Country Code.');
                }
            }
            else{
                if(cnt.Dial_code2__c != null && cnt.Phone2__c == null)
                    cnt.addError('Please Enter Alternative Phone in the format [phone number(9-15 digits only)].');
                else if(cnt.Dial_code2__c == null && cnt.Phone2__c != null)
                    cnt.addError('Please Select Alternate Phone - Country Code.');
                
            }
            // Below part is added by Suraj As a part of ECM00511
            if(((Recordtype_id != null && cnt.RecordTypeId == Recordtype_id )  || (grpOfSchooolRcdId!= null && cnt.RecordTypeId == grpOfSchooolRcdId))){ 
                if(cnt.Country__c!=null && IberoAmericaCountries__c.getValues(cnt.Country__c) != null){
                    cnt.IberoAmerica__c=true;
                }else {
                    cnt.IberoAmerica__c=false;
                }
            }else{
                cnt.IberoAmerica__c=false;
            }
            // END
            
        }
        
    }
    /** 
* @author Ammara Alvi
* @date 05/10/2021
* @description Add Phone Field.
* @returntype Void
* @param List<Contact> new_contact_Info
*/      
    public static void addphone(List<Account> new_contact_Info){
        ID Recordtype_id = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId();
        ID Recordtype_id_inst = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IB Institute').getRecordTypeId();
        ID recordtype_id_op = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Online Provider').getRecordTypeId();
        ID grpOfSchooolRcdId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Groups of Schools').getRecordTypeId();
        
        for(Account cnt:new_contact_Info){
            if(Recordtype_id != null && cnt.RecordTypeId == Recordtype_id  && cnt.RecordTypeID != grpOfSchooolRcdId){
                
                
                String []str;
                String []strFinal;
                String countCode ;
                String FinalPh;
                String PhoneNumber='';
                String strPh ;
                Boolean check;
                Integer len ;  
                System.debug('Record Type: '+cnt.RecordType.Name );
                if(cnt.Dial_code__c != null && cnt.Phone_Number__c != null){
                    str = cnt.Dial_code__c.split('\\(');
                    strFinal = str[1].split('\\)');
                    countCode = strFinal[0];
                    strPh = cnt.Phone_Number__c;
                    check=false;
                    len = strPh.length();  
                    FinalPh='+';
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
                        cnt.Phone = FinalPh;
                    }
                    else
                        cnt.addError(Label.Phone_Format_Error);
                }
                else{
                    if(cnt.Dial_code__c != null && cnt.Phone_Number__c == null && cnt.RecordTypeID != grpOfSchooolRcdId)
                        cnt.addError('Please Enter Phone Number in the format [phone number(9-15 digits only)], with no spaces or hyphens.');
                    else if(cnt.Dial_code__c == null && cnt.Phone_Number__c != null && cnt.RecordTypeID != grpOfSchooolRcdId)
                        cnt.addError('Please Select Country Code.');
                    else if(cnt.Dial_code__c == null && cnt.Phone_Number__c == null && cnt.RecordTypeID != grpOfSchooolRcdId)
                        cnt.Phone = null;
                }
            }
            
            
            else if((Recordtype_id_inst != null && cnt.RecordTypeId == Recordtype_id_inst) || (recordtype_id_op != null && cnt.RecordTypeId == recordtype_id_op)){        
                
                //Phone Field
                if(cnt.Dial_code__c != null && cnt.Phone != null){
                    String []str = cnt.Dial_code__c.split('\\(');
                    String []strFinal = str[1].split('\\)');
                    String countCode = strFinal[0];
                    String FinalPh;
                    String PhoneNumber='';
                    String strPh = '';
                    Boolean check=false;
                    FinalPh='+';
                    String phone_valid = cnt.Phone;
                    System.debug('phone_valid '+cnt.Phone);
                    
                    
                    
                    strPh = phone_valid.replaceAll('[^a-zA-Z0-9!@#$^&*~`+]', '');
                    System.debug('phone_valid '+strPh);
                    
                    
                    
                    
                    Integer len = strPh.length();  
                    System.debug('Length '+len);
                    System.debug('phone_valid '+strPh);
                    if(len<4 || len >15 || !(strph.isNumeric()))
                        
                        
                        cnt.addError(Label.Phone_Format_Error);
                    else {
                        if(cnt.Dial_code__c != null && cnt.Phone == null && cnt.RecordTypeID != grpOfSchooolRcdId)
                            cnt.addError('Please Enter Phone Number in the format [phone number(9-15 digits only)], with no spaces or hyphens.');
                        else if(cnt.Dial_code__c == null && cnt.Phone != null && cnt.RecordTypeID != grpOfSchooolRcdId)
                            cnt.addError('Please Select Country Code.');
                    }
                }
                else{
                    if(cnt.Dial_code__c != null && cnt.Phone == null  && cnt.RecordTypeID != grpOfSchooolRcdId)
                        cnt.addError('Please Enter Phone Number in the format [phone number(9-15 digits only)], with no spaces or hyphens.');
                    else if(cnt.Dial_code__c == null && cnt.Phone != null  && cnt.RecordTypeID != grpOfSchooolRcdId)
                        cnt.addError('Please Select Country Code.');
                    else if(cnt.Dial_code__c == null && cnt.Phone == null)
                        cnt.Phone = null;
                }
                //Alternative Phone Field
                if(cnt.Dial_code2__c != null && cnt.Phone2__c != null){
                    String []str = cnt.Dial_code2__c.split('\\(');
                    String []strFinal = str[1].split('\\)');
                    String countCode = strFinal[0];
                    String FinalPh;
                    String PhoneNumber='';
                    String strPh = '';
                    Boolean check=false; 
                    FinalPh='+';
                    String phone_valid = cnt.Phone2__c;
                    System.debug('phone_valid '+cnt.Phone);
                    
                    
                    
                    strPh = phone_valid.replaceAll('[^a-zA-Z0-9!@#$^&*~`+]', '');
                    System.debug('phone_valid '+strPh);
                    
                    
                    Integer len = strPh.length();  
                    System.debug('Length '+len);
                    System.debug('phone_valid '+strPh);
                    
                    if(len<4 || len >15 || !(strph.isNumeric())){
                        
                        
                        cnt.addError('Please Enter Alternative Phone in the format [phone number(9-15 digits only)].');
                    }
                    else{
                        if(cnt.Dial_code2__c != null && cnt.Phone2__c == null)
                            cnt.addError('Please Enter Alternative Phone in the format [phone number(9-15 digits only)].');
                        else if(cnt.Dial_code2__c == null && cnt.Phone2__c != null)
                            cnt.addError('Please Select Alternate Phone - Country Code.');
                    }
                }
                else{
                    if(cnt.Dial_code2__c != null && cnt.Phone2__c == null)
                        cnt.addError('Please Enter Alternative Phone in the format [phone number(9-15 digits only)].');
                    else if(cnt.Dial_code2__c == null && cnt.Phone2__c != null)
                        cnt.addError('Please Select Alternate Phone - Country Code.');
                    
                }
            }
            // Below part is added by Suraj As a part of ECM00511 
            if((Recordtype_id != null && cnt.RecordTypeId == Recordtype_id )  || (grpOfSchooolRcdId!= null && cnt.RecordTypeId == grpOfSchooolRcdId)){
                if(cnt.Country__c!=null && IberoAmericaCountries__c.getValues(cnt.Country__c) != null){
                    cnt.IberoAmerica__c=true;
                }else {
                    cnt.IberoAmerica__c=false;
                }
            }
            // END
        }
        
    }
    
}