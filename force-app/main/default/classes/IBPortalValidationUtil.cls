//needs to be without sharing to lookup data on the entire database.

public without sharing class IBPortalValidationUtil {
    
    // Added By Kashyap as a part of ECM00476
    public static Boolean markContactDuplicateBasedOnBirth ( String lastName, Date dob, String countryOfBirth, String birthLocale) {
        List<Contact> contacts = [SELECT Id 
                                  FROM Contact 
                                  WHERE LastName = :lastName  
                                  AND BirthDate = :dob  
                                  AND Country_of_Birth__c = :countryOfBirth 
                                  AND Birth_Locale__c = :birthLocale];
        for(Contact c:contacts){
            c.Possible_Duplicate__c = true;
        }
        if(contacts.size() > 0){
            update contacts;
            return true;
        } else
        {
            return false;
        }
    }
    // End of Addition By Kashyap as a part of ECM00476
    
    
    public static void throwExceptionVerbiageInSelectedLanguage(String userLang, String label)
    {
        if(userLang!=null){
                String result = System.Label.get('',label,userLang);
			    throw new IBPortalValidationUtilException (result);
            }
    }
    
    ///////////////////////////////////////////////////////////US10935 #Start
    public static void checkContactWithActiveUser (String userLang, String Fname, String Lname,String Email, String alternateEmail, Date DOB, String POB ) {
        String fnameInitial = Fname.mid(0,1) + '%';
        List<Contact> con = new List<contact>();             
        if([SELECT Id FROM Contact WHERE ID IN ( Select contactID from user where  isActive = TRUE AND User.Profile.UserLicense.Name != 'Gold Partner' ) AND  
            ( FirstName like :fnameInitial AND LastName =: Lname ) AND 
            ( ( Email =: email OR Alternative_Email__c =: email ) OR 
             ( ( Email =: alternateEmail OR Alternative_Email__c =: alternateEmail ) AND Alternative_Email__c != null ) OR 
             ( BirthDate =: DOB AND Birth_Locale__c  =: POB ) ) LIMIT 1 ].size()  >0 )
        {
            
            if(userLang!='en_US'){
                throwExceptionVerbiageInSelectedLanguage(userLang,'MyIB_Existing_Contact_Active_User');
             }else{
            	throw new IBPortalValidationUtilException (Label.MyIB_Existing_Contact_Active_User);
            }
        }
    } 
    
    public static void checkExistingActiveUserRecord (String userLang, String Email ) {
        
        if ([SELECT Id FROM User WHERE isActive=True AND ( Email = :email OR Username = :email ) LIMIT 1].size() > 0) {
            if(userLang!='en_US'){
                throwExceptionVerbiageInSelectedLanguage(userLang,'MyIB_Duplicate_User_Error');
            }else{
            	throw new IBPortalValidationUtilException (Label.MyIB_Duplicate_User_Error);
            }
        } 
        
    } 
    
    public static void checkContactEmailForExistingUser (String userLang,String email) {
        if ([SELECT Id FROM Contact WHERE (Email = :email OR Alternative_Email__c = :email) AND Id in (SELECT ContactId FROM User where isActive= true and ContactId!='') LIMIT 1].size() > 0) 
           //throw new IBPortalValidationUtilException (Label.MyIB_Existing_User);
            if(userLang!='en_US'){
                throwExceptionVerbiageInSelectedLanguage(userLang,'MyIB_Duplicate_User_Error');
            }else{
            	throw new IBPortalValidationUtilException (Label.MyIB_Duplicate_User_Error);
            } 
    }
    
    public static void checkContactForDuplicateRegistration (String userLang,String firstName, String lastName, Date dob, String countryOfBirth, String birthLocale) {
        String fnameInitial = firstName.mid(0,1) + '%';
        if ([SELECT Id FROM Contact WHERE FirstName like :fnameInitial 
             AND LastName = :lastName 
             AND BirthDate = :dob  
             AND Country_of_Birth__c = :countryOfBirth 
             AND Birth_Locale__c = :birthLocale and Id in (SELECT ContactId FROM User where isActive= true and ContactId!='') LIMIT 1].size() > 0) 
        {
              if(userLang!='en_US'){
                throwExceptionVerbiageInSelectedLanguage(userLang,'MyIB_Existing_Contact_Active_User');
            }else{
            	throw new IBPortalValidationUtilException (Label.MyIB_Existing_Contact_Active_User);
            }
        }
    }
    
     @future
    Public Static void updatePortalContact(String userLang, Boolean duplicateCheck, ID contactID, String invitationID ,String Salutation ,String Title, String FirstName, String LastName, String Email, String AlternativeEmail, Date Birthdate, String countryOfBirth, String BirthLocale)
    {
        try{
            Contact portalContact = MyContactDAO.INSTANCE.getContactbyId(contactID);
            if(portalContact.Contact_Type__c == null){
                portalContact.Contact_Type__c = 'New Registrant';
            }
            
            if( invitationID != null && invitationID != '' )    
            {
                portalContact.Salutation = Salutation;
                portalContact.Title = Title;            
                portalContact.FirstName = FirstName;
                portalContact.LastName = LastName;
                portalContact.Email = Email;
                portalContact.Alternative_Email__c = AlternativeEmail;
                portalContact.Birthdate = Birthdate;  
                RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName = 'Standard_Contact'];
                portalContact.RecordTypeId = RecType.Id;
                portalContact.Invitation_ID__c = null;   
                portalContact.Birth_Locale__c = BirthLocale;
                portalContact.Country_of_Birth__c = countryOfBirth;
            }
            else
            {
                if( portalContact.Email != Email )
                    portalContact.Email = Email;
                if( portalContact.Alternative_Email__c != AlternativeEmail && AlternativeEmail != NULL )
                    portalContact.Alternative_Email__c = AlternativeEmail;  
                
                if(portalContact.Salutation == null) 
                    portalContact.Salutation = Salutation;
                if(portalContact.Title == null) portalContact.Title = Title;
                if(portalContact.FirstName == null) 
                    portalContact.FirstName = FirstName;
                
                if(portalContact.LastName == null) 
                    portalContact.LastName = LastName;
                if(portalContact.Email == null) portalContact.Email = Email;
                if(portalContact.Alternative_Email__c == null) portalContact.Alternative_Email__c = AlternativeEmail;
                
                if(portalContact.Birthdate == null)
                    portalContact.Birthdate = Birthdate;
                if(portalContact.Country_of_Birth__c == null) 
                    portalContact.Country_of_Birth__c = countryOfBirth;
                if(portalContact.Birth_Locale__c == null)
                    portalContact.Birth_Locale__c = BirthLocale;
            }
            system.debug('Future contact Method' + portalContact);
            if(duplicateCheck == true){
                portalContact.Possible_Duplicate__c = true;
            }
            update portalContact;
        }catch(Exception e)
        {
             if(userLang !='en_US'){
             throwExceptionVerbiageInSelectedLanguage(userLang,'MyIB_Existing_Contact_Active_User');
            }else{
            	throw new IBPortalValidationUtilException (Label.MyIB_Existing_Contact_Active_User);
            }
        }
    }
    
    
    public static void updateTheUser(ID userID, String Email )
    {
        ID jobID = System.enqueueJob(new UpdateInactiveUserDuringRegistration(userID,Email));
        System.debug('jobID'+jobID);
    }
    
    public static String findContactWithInActiveUser(String firstName, String lastName,String Email, String alternativeEmail, Date dob, String birthLocale) {
        String firstInitial = firstName.mid(0,1) + '%';
        User  isPortalUser ;
        List<contact> dupContact = new List<Contact>();
        dupContact = [Select ID,Birthdate, Alternative_Email__c, Salutation,Country__c,FirstName,LastName,  User__c, Job_title__C,Invitation_ID__c from contact where ID IN
                      (Select contactID from user where  isActive = FALSE  ) AND 
                      ( Deceased__c = FALSE   AND (  
                          (Alternative_Email__c != NULL AND (email = :alternativeEmail OR Alternative_Email__c = :alternativeEmail) )
                          OR
                          (email = :Email  OR Alternative_Email__c = :Email )
                      ) 
                      ) AND
                      ( ( FirstName like :firstInitial  AND LastName = :lastName  ) OR (Birthdate = : dob AND  Birth_Locale__c = :birthLocale ) ) 
                      order by createdDate  asc];
        
        if(  dupContact.isEmpty() )
        {
            dupContact = [ Select ID, Birthdate, Alternative_Email__c, Salutation, Country__c, FirstName, LastName, User__c, Job_title__C,Invitation_ID__c from contact where   ID 
                          IN (Select contactID from user where  isActive = FALSE ) AND  
                          ( Deceased__c = FALSE)  AND 
                          ( FirstName like :firstInitial  AND LastName = :lastName  AND Birthdate = : dob AND Birth_Locale__c = :birthLocale ) 
                          order by createdDate  asc ];
            
        }
        
        
        if( !dupContact.isEmpty() )           
        {
            isPortalUser =  [ SELECT isActive,ID ,Email,User.Profile.UserLicense.Name, isPortalEnabled from user where ContactID = : dupContact[0].ID   LIMIT 1 ];
            if( isPortalUser != NULL ){
                updateTheUser( isPortalUser.ID, Email );
            }
            
        }                        
        if( !dupContact.isEmpty() )  {
            return isPortalUser.ID;
        }
        return null;
    }
    
    
    
    public static contact findOrphanContact(String firstName, String lastName,String Email, String alternativeEmail, Date dob, String birthLocale) {
        String firstInitial = firstName.mid(0,1) + '%';
        List<contact> dupContact = new List<Contact>();
        dupContact = [ Select ID,Birthdate, Alternative_Email__c, Salutation,Country__c,FirstName,LastName,  User__c, Job_title__C from contact where  
                      (User__c = NULL AND Deceased__c = FALSE ) AND 
                      (	(Alternative_Email__c != NULL AND  (email = :alternativeEmail OR Alternative_Email__c = :alternativeEmail ) )  
                       OR  
                       (email = :Email  OR Alternative_Email__c = :Email )
                      ) AND 
                      ( ( FirstName like :firstInitial  AND LastName = :lastName  ) OR (Birthdate = : dob AND  Birth_Locale__c = :birthLocale ) ) 
                      
                      order by createdDate  asc
                     ]; 
        
        if(  dupContact.isEmpty() )
        {
            dupContact = [ Select ID, Birthdate, Alternative_Email__c, Salutation, Country__c, FirstName, LastName, User__c, Job_title__C from contact where 
                          (User__c = NULL AND Deceased__c = FALSE )  AND 
                          ( FirstName like :firstInitial  AND LastName = :lastName  AND Birthdate = : dob AND Birth_Locale__c = :birthLocale ) 
                          order by createdDate  asc ];
        }if( !dupContact.isEmpty() )
        {
            system.debug('dupContact[0]***'+dupContact[0]);
            return dupContact[0];
        }else
        {
            system.debug('returning new contact***'+new Contact());
            return new Contact();
        }
        
    }
    
       
    public class IBPortalValidationUtilException extends Exception {}
    public class IBPortalValidationUtilPossibleAccountException extends Exception {}
    public class IBPortalValidationUtilDuplicateSchoolEmailException extends Exception {}
}