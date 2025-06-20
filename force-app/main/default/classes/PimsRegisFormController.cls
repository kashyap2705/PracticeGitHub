public without sharing class PimsRegisFormController {

   public static Id eventRequestRTId = Schema.Sobjecttype.PD_Provider_Event__c.getRecordTypeInfosByDeveloperName().get('Event_Request').getRecordTypeId();
   public static account hostAccount;
 
    
   @AuraEnabled (cacheable=true)
   public static String getUserLocale() {
 
       return UserInfo.getLocale();
   } 

    @AuraEnabled
    public static List<PD_Provider_Event__c> getPDProviderEvents() {
        hostAccount();
        system.debug('hostAccount##'+hostAccount);
        return [SELECT Id, Account_not_exist__c,Name, PD_Provider_Event_Start_Date__c,
                PD_Provider_Event_End_Date__c,toLabel(Workshop_Type__c),
                toLabel(Delivery_Mode__c),PD_Provider_Event__c,Status__c,
                Submission_Date__c
            FROM PD_Provider_Event__c
            WHERE recordtype.Id =: eventRequestRTId 
                AND host_school__c =: hostAccount.Id
            ORDER BY PD_Provider_Event__c DESC];
    }    

    @AuraEnabled //(cacheable=true)
    public static List<PD_Provider_Workshop__c> getPDProviderWorkshopList(Id eventId) {
        system.debug('entering method getPDProviderWorkshopList##');
        return [SELECT Id, Name, Event_Programme_s__c,Forecasted_PAX__c,
                Workshop_Category__c,IB_Workshop_Product__c,
                Workshop_Topic_Language__c,Workshop_Title_ENG__c,
                Product_Programme_s__c,Product_Category__c,Status__c
            FROM PD_Provider_Workshop__c
            WHERE PD_Provider_Event__c =: eventId
            ORDER BY Product_Category__c ASC];
    }

    @AuraEnabled //(cacheable=true)
    public static List<IB_Address__c> getIBAddresses(Id accountId) {
        return [SELECT Id, Address_Lines__c,Address_Line_1__c,Address_Line_2__c,
                       Address_Line_3__c,Address_Line_4__c,
                       City__c ,Country__r.Name,Country__r.Uppercase_Country__c,
                       Province__c,Postal_Code__c,
                       IB_Account__c
                FROM IB_Address__c
                WHERE IB_Account__c =: accountId
                AND Status__c = 'Active'];
    }


    @AuraEnabled  
    public static void createParticipatingSchools(Id eventId,list<Id> participatingSchoolIds) {

        list<Participant_School__c> participatingSchoolList = new list<Participant_School__c>();
        system.debug('participatingSchoolIds###'+participatingSchoolIds);
        system.debug('eventId###'+eventId);
        if(participatingSchoolIds != NULL){
            for(Id pid : participatingSchoolIds){
                Participant_School__c ps = new Participant_School__c();
                ps.PD_Provider_Event__c = eventId;
                ps.School_Name__c = pid;
                participatingSchoolList.add(ps);
            }
           if(participatingSchoolList != NULL && !participatingSchoolList.isEmpty()){
              Insert participatingSchoolList;  
           } 
        }
    }    

    @AuraEnabled  
    public static void createParticipatingSchool(Id eventId,Id participatingSchoolId) {

        list<Participant_School__c> participatingSchoolList = new list<Participant_School__c>();
        system.debug('participatingSchoolIds###'+participatingSchoolId);
        system.debug('eventId###'+eventId);
        if(participatingSchoolId != NULL){ 
                Participant_School__c ps = new Participant_School__c();
                ps.PD_Provider_Event__c = eventId;
                ps.School_Name__c = participatingSchoolId;
                participatingSchoolList.add(ps);
           if(participatingSchoolList != NULL && !participatingSchoolList.isEmpty()){
              Insert participatingSchoolList;  
           } 
        }
    } 

    @AuraEnabled  
    public static list<Participant_School__c> relatedParticipatingSchools(Id eventId) {
        return [SELECT Id, Name,
                       School_Name__c
                FROM Participant_School__c
                WHERE PD_Provider_Event__c =: eventId];
    } 
    
    @AuraEnabled
    public static list<contentversion> relatedFiles(Id eventId){
        list<id> lstConDocs = new list<id>();
        for(ContentDocumentLink cntLink : [Select Id, ContentDocumentId From ContentDocumentLink Where LinkedEntityId =:eventId]) {
            lstConDocs.add(cntLink.ContentDocumentId);
        }
        if(!lstConDocs.isEmpty()) {
            return [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :lstConDocs];
        }
        else {
            return null;
        }
    } 

    @AuraEnabled
    public static account hostAccount(){
        hostAccount = new account();
        PimsCommunityService pimsService = new PimsCommunityService();
        pimsService.initUserData();
        hostAccount = pimsService.getCurrentAccount();
        if(hostAccount != null){
            return hostAccount;
        }
        return null;
    }

    @AuraEnabled
    public static boolean doesWorkshopsExist(Id eventId) {
        integer workshopCount = [SELECT count()
                                        FROM PD_Provider_Workshop__c
                                        WHERE PD_Provider_Event__c =: eventId];
        if(workshopCount > 0){
            return true;
        }
        return false;
    }

   /* @AuraEnabled
    public static Id getProviderAccountId(String deliveryMode, String region){
 
        string nameVar='as Provider';
        String whereClause;

        if(deliveryMode == 'Online'){
            whereClause = ' WHERE Name = \'IB Online as Provider\' ';
        }else{
            whereClause = ' Where name LIKE \'%' + nameVar + '%\'' ; 
            whereClause += ' AND Region__c = '+ '\''+region +'\'';
        }

        string strQuery = 'Select Id From Account' +  whereClause;

        List<account> accountProviderList = Database.query(strQuery);   
        
        if(accountProviderList.size() > 0){
            return accountProviderList[0].Id;
        }

        return null;
    }  */ 
    
    @AuraEnabled(cacheable=true)
    public static List<account> getProviderAccounts(){

        List<account> accountProviderList = [Select Id, Name 
                                               From Account
                                               WHERE Name like '%as Provider'];   
        system.debug('accountProviderList##'+accountProviderList);
        if(accountProviderList.size() > 0){
            return accountProviderList;
        }

        return null;
    }
    
    @AuraEnabled
    public static void deleteParticipatingSchools(Id pdProviderEventId){
        try {
            System.debug('pdProviderEventId ====> '+pdProviderEventId);
            list<Participant_School__c> relPartSchools = relatedParticipatingSchools(pdProviderEventId);
            System.debug('relPartSchools ====> '+relPartSchools);
            if(!relPartSchools.isEmpty()) {
                delete relPartSchools;
            }
        }
        catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }


}