public class IBENServicesAPIHelper {
    
    //Added by Shahrukh for ECM00207 Phase 1 on 05/05/2024
    public static Set<String> countriesWithStates = new Set<String> {'United States', 'Canada', 'Australia'};
    
    /**		
* This Method is responsible to - Return Role.
* @author: Parridhi O Bindall 
* @since 09/23/2021
* @param SF Role ID		
* @return Role		checkValidEmailAddress
*/ 
    public static IB_Role__c getIdRole( Id roleId){
        List<IB_Role__c> rolesList = [Select id, IB_Contact__c, IBIS_contact_ID__c, Active__c from IB_Role__c where Id = :roleId LIMIT 1];
        if(rolesList.size()>0)
            return rolesList[0];
        else
            return null;
    }
    
    /**		
* This Method is responsible to - Return flag to signify if role exists with passed params.
* @author: Parridhi O Bindall 
* @since 09/23/2021
* @param RoleName, Active, SF ContactID		
* @return Boolean		
*/ 
    public static Boolean checkContactRole(String roleName, boolean isActive, Id conId){
        List<IB_Role__c> rolesList = [Select Id from IB_Role__c where IB_Role_Name__c = :roleName
                                      AND Active__c = :isActive
                                      AND IB_Contact__c = :conId];        
        if(rolesList.size()>0)
            return true;
        else
            return false;
    }
    
    
    /* This Method is responsible to - Return flag to signify if role exists with passed params.
* @author: Parridhi O Bindall 
* @since 09/23/2021
* @param RoleName, Active, SF ContactID		
* @return Boolean		
*/ 
    public static Boolean checkExisitngIBENApiRequests(String conFirstName,String conLastName,String conLegalFirstName,String conLegalLastName,String conBirthdate,String conEmail,String conBirthCountry,String programme, String roleName){
        
        List<IBENApiRequest__c> IBENApiRequestList = [Select Id from IBENApiRequest__c where 
                                                      FirstName__c = :conFirstName
                                                      AND LastName__c = :conLastName
                                                      AND Legal_first_name__c = :conLegalFirstName
                                                      AND Legal_Last_Name__c = :conLegalLastName
                                                      AND Birthdate__c = :Date.valueOf(conBirthdate)
                                                      AND Email__c = :conEmail
                                                      AND Country_of_Birth__c = :conBirthCountry
                                                      AND Role_Name__c = :roleName
                                                      //   AND Request_Processed__c = false
                                                     ];   
        
        if(IBENApiRequestList.size()>0)
            return true;
        else
            return false;
    }
    
    /* This Method is responsible to - Return flag to signify if Contact already exists with passed params.
* @author: Bharat 
* @since 06/06/2022
* @param RoleName, Active, SF ContactID		
* @return Boolean		
 
    public Static list<Contact> checkExisitngContact(String conFirstName,String conLastName,String conLegalFirstName,String conLegalLastName,String conBirthdate,String conEmail,String conBirthCountry,String conPlaceofbirth, String programme, String roleName){
        string conLName = conLastName;
        string fiName = conFirstName.substring(0, 1);
        string liName = conLegalFirstName.substring(0, 1);
        
        
        List<Contact> existingContactList = new List<Contact>();
        List<Contact> contactEmailList = [Select Id, FirstName, LastName, Legal_first_name__c, IBIS_contact_ID__c, Email, Alternative_Email__c  from Contact where 
                                          (Email = :conEmail OR 
                                           Alternative_Email__c = :conEmail)];
        if(contactEmailList.size()>0)
            existingContactList.addall(contactEmailList);
        
        List<Contact> contactNameList = [Select Id, FirstName, LastName, Legal_first_name__c, IBIS_contact_ID__c, Birthdate, Country_of_Birth__c, Birth_Locale__c from Contact where 
                                         (
                                             Birthdate = :Date.valueOf(conBirthdate) AND 
                                             Country_of_Birth__c = :conBirthCountry AND 
                                             Birth_Locale__c = :conPlaceofbirth
                                         )];  
        for(Contact c: contactNameList){
            String alphaFirst = c.FirstName.substring(0, 1);
            String alphaLegal = c.Legal_first_name__c.substring(0, 1);
            if((alphaFirst.equals(fiName) && c.LastName == conLName ) || (alphaLegal.equals(liName) && c.LastName == conLName)){
                existingContactList.add(c);
            }
        }
        
        if(existingContactList.size()>0)
            return existingContactList;
        else
            return null;
    }
   */ 
    
    /**		
* This Method is responsible to - Return flag to signify if role is a valid IBEN Examiner Role.
* @author: Parridhi O Bindall 
* @since 09/23/2021
* @param RoleName
* @return Boolean		
*/ 
    public static Boolean validIBENExaminerRole(String roleName){
        List<String> validRoles = new List<String>{'Examiner','Chief Examiner','Examiner Responsible', 'Deputy Examiner Responsible', 'Principal Examiner', 'Exam Team Leader'};
            if(validRoles.contains(roleName))
            return true;
        else
            return false;
    }
    
    /**		
* This Method is responsible to - Return flag to signify if the passed string contains only alphabets and hyphens.
* @author: Parridhi O Bindall 
* @since 09/23/2021
* @param String
* @return Boolean		
*/ 
    public static Boolean checkValidAlphaHyphenString(String lastName){
        String emailRegex = '[a-zA-Z\\s\\p{Punct}]+';
        Pattern myPattern = Pattern.compile(emailRegex);
        Matcher myMatcher = myPattern.matcher(lastName);
        if(myMatcher.matches()){
            return true;
        }else{
            return false;
        }
    }
    /**		
* This Method is responsible to - Return flag to signify if the passed string value is valid Date or not.
* @author: Parridhi O Bindall 
* @since 09/23/2021
* @param String
* @return Boolean		
*/ 
    public static Boolean checkValidDate(String dateValue){
        
        try{
            System.debug('Date is: '+ Date.valueOf(dateValue));
            return true;
        }catch(Exception e)
        {
            System.debug('Exception:' + e);
            return false;
        }
    }
    
    /**		
* This Method is responsible to - Return flag to signify if the passed string is in correct email format.
* @author: Parridhi O Bindall 
* @since 09/23/2021
* @param String
* @return Boolean		
*/ 
    public static Boolean checkValidEmailAddress(String emailAddress){
        //INC0193535 - Updated regex to allow for email domains longer than 3 characters
        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,8}|[0-9]{1,8})';
        Pattern myPattern = Pattern.compile(emailRegex);
        Matcher myMatcher = myPattern.matcher(emailAddress);
        
        if(myMatcher.matches()){
            return true;
        }else{
            return false;
        }
    }
    /**		
* This Method is responsible to - Return flag to signify if the passed country value exists as active picklist value on the field.
* @author: Parridhi O Bindall 
* @since 09/28/2021
* @param String
* @return Boolean		
*/ 
    public static Boolean validCountryList(String countryValue){
        
        String objectName = 'Contact';
        String fieldName ='Country_of_Birth__c';
        
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            if(pickListVal.getLabel() == countryValue){
                System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
                return true;
            }            
        }    
        return false;
    }
    
/**		
* This Method is responsible to - Return flag to signify if the passed country value exists as active picklist value on the field.
* @author: Shahrukh Anwar
* @since 04/30/2024
* @param String
* @return Boolean		
*/ 
    public static Boolean validCountryCheck(String country, String objectName, String fieldName){
        
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            if(pickListVal.getLabel() == country){
                System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
                return true;
            }            
        }    
        return false;
    }
    
    /**		
* This Method is responsible to - Return flag to signify if the passed state/province value exists as active picklist value on the field.
* @author: Shahrukh Anwar
* @since 04/30/2024
* @param String
* @return Boolean		
*/ 
    public static Boolean validStateProvinceCheck(String country, String stateProvince, String objectName, String fieldName){
        
        if(!String.isBlank(stateProvince) && countriesWithStates.contains(country)) {
            Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
            Schema.DescribeSObjectResult r = s.getDescribe() ;
            Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
            Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                if(pickListVal.getLabel() == stateProvince){
                    System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
                    return true;
                }            
            }
        } else if(!countriesWithStates.contains(country)) {
            return true;
        }
        return false;
    }
    
}