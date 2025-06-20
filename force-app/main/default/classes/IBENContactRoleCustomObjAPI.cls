@RestResource(urlMapping='/IBENContactRoleCustomObjAPI/*')
global with sharing class IBENContactRoleCustomObjAPI{
    
    //Added by Shahrukh for ECM00207 Phase 1 on 05/05/2024
    public static Set<String> countriesWithStates = new Set<String> {'United States', 'Canada', 'Australia'};
    
    @HttpPost
    global static void doPost(){        
        IB_Role__c newrole = new IB_Role__c();
        Contact newContact = new Contact();
        IBENApiRequest__c Apirequest = new IBENApiRequest__c();
        
        Id OrgId = UserInfo.getOrganizationId();
        Id ContactRecordTypeId = Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId();
        Id RoleRecordTypeId = Schema.getGlobalDescribe().get('IB_Role__c').getDescribe().getRecordTypeInfosByName().get('Confirmed').getRecordTypeId();
        
        RequestWrapper reqWrapper = (RequestWrapper) JSON.deserialize(RestContext.request.requestBody.toString(),RequestWrapper.class);
        system.debug('SandeepCOR' +reqWrapper);
        String conFirstName = reqWrapper.PreferredFirstName;
        String conLastName = reqWrapper.PreferredLastName;           
        String conLegalFirstName = reqWrapper.LegalFirstName;
        String conLegalLastName = reqWrapper.LegalLastName;
        String conBirthdate = reqWrapper.DateOfBirth;
        String conEmail = reqWrapper.Email;
        String conAlternativeEmail = reqWrapper.AlternativeEmail;
        String conBirthCountry = reqWrapper.CountryOfBirth; 
        String conPlaceofbirth = reqWrapper.PlaceOfBirth;
        String roleName = reqWrapper.RoleName; 
        String programme = reqWrapper.Programme; 
        String referenceId = reqWrapper.referenceId;
        //String CountryOfResidence = reqWrapper.country;
        
        String OtherStreet = reqWrapper.Street;
        String ResidentialCity = reqWrapper.City;
        String ResidentialZipPostalCode = reqWrapper.PostalZipCode;
        String ResidentialCountry = reqWrapper.Country;
        String Nationality = reqWrapper.Nationality;
        String StateProvince = reqWrapper.StateProvince;
        
        /*Boolean firstNameCheck = IBENServicesAPIHelper.checkValidAlphaHyphenString(conFirstName);
        Boolean lastNameCheck = IBENServicesAPIHelper.checkValidAlphaHyphenString(conLastName);
        Boolean legalFirstNameCheck = IBENServicesAPIHelper.checkValidAlphaHyphenString(conLegalFirstName);
        Boolean legalLastNameCheck = IBENServicesAPIHelper.checkValidAlphaHyphenString(conLegalLastName);*/
        Boolean emailCheck = IBENServicesAPIHelper.checkValidEmailAddress(conEmail);
        //Boolean altEmailCheck = IBENServicesAPIHelper.checkValidEmailAddress(conAlternativeEmail);
        Boolean roleCheck = IBENServicesAPIHelper.validIBENExaminerRole(roleName);
        Boolean countryCheck = IBENServicesAPIHelper.validCountryCheck(conBirthCountry, 'Contact', 'Country_of_Birth__c');		//Modified by Shahrukh for ECM00207 on 05/05/2024
        Boolean dateCheck = IBENServicesAPIHelper.checkValidDate(conBirthdate);
        
        //Added by Shahrukh for ECM00207 on 30/04/2024 -- START --
        Boolean residentialCountryCheck = IBENServicesAPIHelper.validCountryCheck(ResidentialCountry, 'Contact', 'OtherCountryCode');
        Boolean stateProvinceCheck = IBENServicesAPIHelper.validStateProvinceCheck(ResidentialCountry, StateProvince, 'Contact', 'OtherStateCode');
        //Added by Shahrukh for ECM00207 on 30/04/2024 -- END --
        
        // Optimized the code by Shahrukh for ECM00207 Phase 1 on 30/04/2024
        if(/*!firstNameCheck || !lastNameCheck || !legalFirstNameCheck || !legalLastNameCheck || */!emailCheck || !roleCheck || !dateCheck 
           || !countryCheck || !residentialCountryCheck || !stateProvinceCheck){
            String title, msgType, detail;
            /*if(!firstNameCheck){
                msgType = 'Incorrect input';
                title = 'Incorrect input format for contact\'s first name.';
                detail = 'PreferredFirstName can contain only alphabets Or Special Charecters and not numbers';
            }
            
            if(!lastNameCheck){
                msgType = 'Incorrect input';
                title = 'Incorrect input format for contact\'s last name.';
                detail = 'PreferredLastName can contain only alphabets Or Special Charecters and not numbers';
            }
            
            if(!legalFirstNameCheck){
                msgType = 'Incorrect input';
                title = 'Incorrect input format for contact\'s legal first name.';
                detail = 'LegalFirstName can contain only alphabets Or Special Charecters and not numbers';
            }
            
            if(!legalLastNameCheck){
                msgType = 'Incorrect input';
                title = 'Incorrect input format for contact\'s legal last name.';
                detail = 'LegalLastName can contain only alphabets and hyphens Or Special Charecters and not numbers';
            }*/
            
            if(!emailCheck){
                msgType = 'Incorrect input';
                title = 'Incorrect input format for contact\'s email address.';
                detail = 'Email should be in the email format (test@test.com).';
            }
            
            else if(!roleCheck){
                msgType = 'Incorrect input';
                title = 'Incorrect input for Role name.';
                detail = 'RoleName can take only defined IBEN Examiner roles.';
            }
            else if(!dateCheck){
                msgType = 'Incorrect input';
                title = 'Incorrect input for contact\'s date of birth.';
                detail = 'DateOfBirth should be in \'YYYY-MM-DD\' format.';
            }
            else if(!countryCheck){
                msgType = 'Incorrect input';
                title = 'Incorrect input for contact\'s country of birth.';
                detail = 'CountryOfBirth should be from the defined set of countries.';
            }
               
            //Added by Shahrukh for ECM00207 Phase 1 on 30/04/2024 -- START --
            else if(!residentialCountryCheck){
                msgType = 'Incorrect input';
                title = 'Incorrect input for contact\'s Residential Country.';
                detail = 'ResidentialCountry should be from the defined set of countries.';
            }
            else if(!stateProvinceCheck){
                msgType = 'Incorrect input';
                title = 'Incorrect input for contact\'s State/Province.';
                detail = 'StateProvince should be from the defined set of States/Provinces.';
            }
            //Added by Shahrukh for ECM00207 Phase 1 on 30/04/2024 -- END --
               
            RestResponse res = RestContext.response;
            res.statusCode = 400;
            res.addHeader('Content-Type', 'application/json');
            Map<String,Object> resMap = new Map<String,Object>();
            resMap.put('Type', msgType);
            resMap.put('Title', title);
            resMap.put('StatusCode', 400);
            resMap.put('Details', detail);
            resMap.put('Instance', OrgId);
            //  resMap.put('Instance', null);
            res.responsebody = Blob.valueOf(JSON.serialize(resMap));
            
        }
        else if(/*firstNameCheck && lastNameCheck && legalFirstNameCheck && legalLastNameCheck && */emailCheck && roleCheck && countryCheck){
            List<IB_Role_Repository__c> roleIDList;
            Id roleID;
            roleIDList = [Select Id from IB_Role_Repository__c Where Role_Name__c =:roleName LIMIT 1];
            roleID = roleIDList[0].Id;
            
            List<Account> accountList = new List<Account>([Select Id from Account where Name ='IBEN Global' LIMIT 1 FOR UPDATE]);
            ID accountId;
            accountId = accountList[0].id;
            
            
            string conLName = conLastName;
            string fiName = conFirstName.substring(0, 1);
            string liName = conLegalFirstName.substring(0, 1);
            
            List<Contact> existingContactList = new List<Contact>();
            /*List<Contact> contactEmailList = [Select Id, FirstName, LastName, Legal_first_name__c, IBIS_contact_ID__c, Email, Alternative_Email__c  from Contact where 
(Email = :conEmail OR 
Alternative_Email__c = :conEmail)];
if(contactEmailList.size()>0)
existingContactList.addall(contactEmailList);*/
            List<Contact> DuplicateList = new List<Contact>();
            if(conAlternativeEmail != ''  && conAlternativeEmail != null){
                system.debug('conAlternativeEmail = ' + conAlternativeEmail);
                DuplicateList = [Select Id, FirstName, LastName, Legal_first_name__c, IBIS_contact_ID__c, Email, Alternative_Email__c from Contact where 
                                           (Email = :conEmail OR 
                                            Alternative_Email__c =:conEmail OR Email = :conAlternativeEmail OR 
                                            Alternative_Email__c =:conAlternativeEmail) OR (FirstName = :conFirstName and LastName = :conLastName and  Birthdate = :Date.valueOf(conBirthdate) AND 
                                                                                 Country_of_Birth__c = :conBirthCountry AND 
                                                                                 Birth_Locale__c = :conPlaceofbirth) OR (Legal_first_name__c  = :conLegalFirstName and Legal_Last_name__c  = :conLegalLastName  and Birthdate = :Date.valueOf(conBirthdate) AND 
                                                                                                                         Country_of_Birth__c = :conBirthCountry AND 
                                                                                                                         Birth_Locale__c = :conPlaceofbirth)];
            }else{
                DuplicateList = [Select Id, FirstName, LastName, Legal_first_name__c, IBIS_contact_ID__c, Email, Alternative_Email__c from Contact where 
                                           (Email = :conEmail OR 
                                            Alternative_Email__c =:conEmail) OR (FirstName = :conFirstName and LastName = :conLastName and  Birthdate = :Date.valueOf(conBirthdate) AND 
                                                                                 Country_of_Birth__c = :conBirthCountry AND 
                                                                                 Birth_Locale__c = :conPlaceofbirth) OR (Legal_first_name__c  = :conLegalFirstName and Legal_Last_name__c  = :conLegalLastName  and Birthdate = :Date.valueOf(conBirthdate) AND 
                                                                                                                         Country_of_Birth__c = :conBirthCountry AND 
                                                                                                                         Birth_Locale__c = :conPlaceofbirth)];
            }
            system.debug('Duplicate Found check');
            if(DuplicateList.size()>0)
                system.debug('Duplicate Found');
            existingContactList.addall(DuplicateList);
            /* List<Contact> contactNameList = [Select Id, FirstName, LastName, Legal_first_name__c, IBIS_contact_ID__c, Birthdate, Country_of_Birth__c, Birth_Locale__c from Contact where 
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
}*/
            Boolean doesIBENApirequestExist = IBENServicesAPIHelper.checkExisitngIBENApiRequests(conFirstName, conLastName, conLegalFirstName, conLegalLastName, conBirthdate, conEmail, conBirthCountry, programme, roleName);
            
            if(doesIBENApirequestExist){ 
                Boolean doesActiveRoleExist = IBENServicesAPIHelper.checkContactRole(roleName, true, existingContactList[0].Id);
                
                if(doesActiveRoleExist){           
                    Map<String,Object> jsonResponseMap = new Map<String,Object>();
                    jsonResponseMap.put('Instance',OrgId);
                    jsonResponseMap.put('ContactId',existingContactList[0].Id);
                    jsonResponseMap.put('PersonCode',existingContactList[0].IBIS_contact_ID__c);
                    jsonResponseMap.put('IsActive',True);
                    jsonResponseMap.put('Description','Conflicting request');
                    
                    RestResponse res = RestContext.response;
                    res.addHeader('Content-Type', 'application/json');
                    res.statusCode = 409;
                    res.responseBody = Blob.valueOf(JSON.serialize(jsonResponseMap));   
                }
                
                else{
                    Boolean doesInactiveRoleExist = IBENServicesAPIHelper.checkContactRole(roleName, false, existingContactList[0].Id);
                    system.debug('Check Role Already Exist'+doesInactiveRoleExist);
                    Apirequest.FirstName__c = conFirstName;
                    Apirequest.LastName__c = conLastName;
                    Apirequest.Legal_first_name__c = conLegalFirstName;
                    Apirequest.Legal_Last_name__c = conLegalLastName;
                    Apirequest.Birthdate__c = Date.valueOf(conBirthdate);
                    Apirequest.Email__c = conEmail;
                    Apirequest.Alternative_Email__c = conAlternativeEmail;
                    Apirequest.Country_of_Birth__c = conBirthCountry;
                    Apirequest.Place_of_Birth__c = conPlaceofbirth;
                    Apirequest.Role_Name__c = roleName;
                    Apirequest.Programme__c = programme ;
                    Apirequest.Status__c = 'Contact found with No Existing role' ;
                    Apirequest.Contact_ID__c = existingContactList[0].Id;
                    Apirequest.referenceId__c = referenceId;
                    Apirequest.IB_Role__c = roleID;
                    Apirequest.Residential_Country__c = ResidentialCountry;
                    Apirequest.OtherStreet__c = OtherStreet;
                    Apirequest.Residential_City__c = ResidentialCity;
                    Apirequest.Residential_ZIP_Postal_Code__c = ResidentialZipPostalCode;
                    Apirequest.Nationality__c = Nationality;
                    //Added by Shahrukh for ECM00207 on 31/05/24 -- START --
                    if(countriesWithStates.contains(ResidentialCountry)) {
                        Apirequest.Other_State_Province__c = StateProvince;
                    }
                    else {
                        Apirequest.Other_State_Province_Optional__c = StateProvince;
                    }
                    //Added by Shahrukh for ECM00207 on 31/05/24 -- END --
                    insert Apirequest;
                    
                    Map<String,Object> jsonResponseMap = new Map<String,Object>();
                    jsonResponseMap.put('Instance',OrgId);
                    jsonResponseMap.put('ContactId',existingContactList[0].Id);
                    system.debug('Contact ID is'+existingContactList[0].Id);
                    jsonResponseMap.put('PersonCode',existingContactList[0].IBIS_contact_ID__c);
                    system.debug('Person Code is'+existingContactList[0].IBIS_contact_ID__c);
                    //jsonResponseMap.put('IsActive',false);
                    jsonResponseMap.put('WasPreviouslyInactive',doesInactiveRoleExist);
                    
                    RestResponse res = RestContext.response;
                    res.addHeader('Content-Type', 'application/json');
                    res.statusCode = 201;
                    res.responseBody = Blob.valueOf(JSON.serialize(jsonResponseMap)); 
                }
            }
            
            else if(existingContactList.size()>0){
                Boolean doesActiveRoleExist = IBENServicesAPIHelper.checkContactRole(roleName, true, existingContactList[0].Id);
                
                if(doesActiveRoleExist){           
                    Map<String,Object> jsonResponseMap = new Map<String,Object>();
                    jsonResponseMap.put('Instance',OrgId);
                    jsonResponseMap.put('ContactId',existingContactList[0].Id);
                    jsonResponseMap.put('PersonCode',existingContactList[0].IBIS_contact_ID__c);
                    jsonResponseMap.put('IsActive',True);
                    jsonResponseMap.put('Description','Conflicting request');
                    
                    RestResponse res = RestContext.response;
                    res.addHeader('Content-Type', 'application/json');
                    res.statusCode = 409;
                    res.responseBody = Blob.valueOf(JSON.serialize(jsonResponseMap));   
                }
                else{
                    Boolean doesInactiveRoleExist = IBENServicesAPIHelper.checkContactRole(roleName, false, existingContactList[0].Id);
                    Apirequest.FirstName__c = conFirstName;
                    Apirequest.LastName__c = conLastName;
                    Apirequest.Legal_first_name__c = conLegalFirstName;
                    Apirequest.Legal_Last_name__c = conLegalLastName;
                    Apirequest.Birthdate__c = Date.valueOf(conBirthdate);
                    Apirequest.Email__c = conEmail;
                    Apirequest.Alternative_Email__c = conAlternativeEmail;
                    Apirequest.Country_of_Birth__c = conBirthCountry;
                    Apirequest.Place_of_Birth__c = conPlaceofbirth;
                    Apirequest.Role_Name__c = roleName;
                    Apirequest.Programme__c = programme ;
                    Apirequest.Status__c = 'Contact found with No Existing role' ;
                    Apirequest.Contact_ID__c = existingContactList[0].Id;
                    Apirequest.referenceId__c = referenceId;
                    Apirequest.IB_Role__c = roleID;
                    Apirequest.Residential_Country__c = ResidentialCountry;
                    Apirequest.OtherStreet__c = OtherStreet;
                    Apirequest.Residential_City__c = ResidentialCity;
                    Apirequest.Residential_ZIP_Postal_Code__c = ResidentialZipPostalCode;
                    Apirequest.Nationality__c = Nationality;
                    //Added by Shahrukh for ECM00207 on 31/05/24 -- START --
                    if(countriesWithStates.contains(ResidentialCountry)) {
                        Apirequest.Other_State_Province__c = StateProvince;
                    }
                    else {
                        Apirequest.Other_State_Province_Optional__c = StateProvince;
                    }
                    //Added by Shahrukh for ECM00207 on 31/05/24 -- END --
                    insert Apirequest;
                    
                    Map<String,Object> jsonResponseMap = new Map<String,Object>();
                    jsonResponseMap.put('Instance',OrgId);
                    jsonResponseMap.put('ContactId',existingContactList[0].Id);
                    jsonResponseMap.put('PersonCode',existingContactList[0].IBIS_contact_ID__c);
                    //jsonResponseMap.put('IsActive',false);
                    jsonResponseMap.put('WasPreviouslyInactive',doesInactiveRoleExist);
                    
                    RestResponse res = RestContext.response;
                    res.addHeader('Content-Type', 'application/json');
                    res.statusCode = 201;
                    res.responseBody = Blob.valueOf(JSON.serialize(jsonResponseMap)); 
                }
            }
            else{
                Apirequest.FirstName__c = conFirstName;
                Apirequest.LastName__c = conLastName;
                Apirequest.Legal_first_name__c = conLegalFirstName;
                Apirequest.Legal_Last_name__c = conLegalLastName;
                Apirequest.Birthdate__c = Date.valueOf(conBirthdate);
                Apirequest.Email__c = conEmail;
                Apirequest.Alternative_Email__c = conAlternativeEmail;
                Apirequest.Country_of_Birth__c = conBirthCountry;
                Apirequest.Place_of_Birth__c = conPlaceofbirth;
                Apirequest.Role_Name__c = roleName;
                Apirequest.Programme__c = programme ;
                Apirequest.Status__c = 'No Contact Found';
                Apirequest.referenceId__c = referenceId;
                Apirequest.IB_Role__c = roleID;
                Apirequest.Residential_Country__c = ResidentialCountry;
                Apirequest.OtherStreet__c = OtherStreet;
                Apirequest.Residential_City__c = ResidentialCity;
                Apirequest.Residential_ZIP_Postal_Code__c = ResidentialZipPostalCode;
                Apirequest.Nationality__c = Nationality;
                //Added by Shahrukh for ECM00207 on 31/05/24 -- START --
                if(countriesWithStates.contains(ResidentialCountry)) {
                    Apirequest.Other_State_Province__c = StateProvince;
                }
                else {
                    Apirequest.Other_State_Province_Optional__c = StateProvince;
                }
                //Added by Shahrukh for ECM00207 on 31/05/24 -- END --
                insert Apirequest;
                
                Map<String,Object> jsonResponseMap = new Map<String,Object>();
                jsonResponseMap.put('Instance',OrgId);
                jsonResponseMap.put('ContactId','No Contact Found');
                jsonResponseMap.put('PersonCode','No Contact Found');
                //jsonResponseMap.put('IsActive',false);
                jsonResponseMap.put('WasPreviouslyInactive',false);
                
                RestResponse res = RestContext.response;
                res.addHeader('Content-Type', 'application/json');
                res.statusCode = 201;
                res.responseBody = Blob.valueOf(JSON.serialize(jsonResponseMap)); 
            }
            
        }
    }
    
    /*  global static Id createContactRole(){

}*/
    
    public class RequestWrapper {
        public String PreferredFirstName {get;set;}
        public String PreferredLastName {get;set;}
        public String LegalFirstName {get;set;}
        public String LegalLastName {get;set;}
        public String DateOfBirth {get;set;}
        public String Email {get;set;}
        public String AlternativeEmail {get;set;}
        public String CountryOfBirth {get;set;}
        public String PlaceOfBirth {get;set;}
        public String RoleName {get;set;}
        public String Programme {get;set;}
        public String referenceId {get;set;}
        public String Country {get;set;}
        public String Street {get;set;}
        public String City {get;set;}
        public String PostalZipCode {get;set;}
        public String Nationality {get;set;}
        public String StateProvince {get;set;}
    }
}