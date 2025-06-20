/*******************************************************************************************
* @Name         TestDataFactory 
* @Author       
* @Date         
* @Group        
* @Description  
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Michael Khan      04/26/2023         added code to create case records
* 1.1				Saurabh Singh 	  06/08/2023		To cover the class IbPortalFooterController.
*******************************************************************************************/
@isTest
public class TestDataFactory {
//Name__c='Support Request Title', Status='New', Priority='Low', Description='Testing Change Request', Area_of_Application__c='Cases');
    public static List<Case> createCase(Integer count, Id recordType, Boolean isInsert){
        List<Case> cases = new List<Case>();
        for(Integer i=0;i<count;i++){
            Case caseRecord = new Case(Name__c='Support Request Title'+i, Status='New', Priority='Low', Description='Testing Change Request', Area_of_Application__c='Cases', recordtypeId=recordType);
            cases.add(caseRecord);
        }
        if(isInsert)
            insert cases;
        return cases;
    }
    // created this test data for the class IbportalFooterController And IbPortalFooterControllerTest by Saurabh Singh
    public static List<User> createUserTestData(Id profileId,Integer count, Boolean isInsert) {
        List<User> users = new List<User>();
        for(Integer i=0;i<count;i++){
            User usr = new User(Alias = 'ibport'+i, Email='ibportaluser@testorg.com'+i,
                                EmailEncodingKey='UTF-8',FirstName='Test1'+i, LastName='Testing'+i, LanguageLocaleKey='en_US',
                                LocaleSidKey='en_US', ProfileId = profileId,
                                TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuser@testorg.com');
            users.add(usr);
        }
        if(isInsert && !users.isEmpty())
            insert users;
        return users;
    }
    // created this test data for the class IbportalFooterController And IbPortalFooterControllerTest by Saurabh Singh
     public static Translation__c createTranslationTestData(String value, Id customLabelRecordId, String language) {
         Translation__c trans = new Translation__c(
             Language__c = language,
             Value__c = value,
             CustomLabel__c = customLabelRecordId
             
         );
         return trans;
     }
    // created this test data for the class IbportalFooterController And IbPortalFooterControllerTest by Saurabh Singh
    public static Custom_Label_Project__c projectRecords(String label){
        Custom_Label_Project__c projectRecords = new Custom_Label_Project__c();
        projectRecords.Name = label;
        insert projectRecords;
        return projectRecords;
    }
    public static List<customlabel__c> customLabelRecords(Set<String> labels, Boolean isInsert){
        Custom_Label_Project__c clProject = projectRecords('IB Portal Template');
        List<customlabel__c> customRecordsList = new List<customlabel__c>();
        for(String label:labels){
            customlabel__c customRecord = new customlabel__c();
            customRecord.Label__c = label;
            customRecord.Group__c = 'Document';
            customRecord.Project__c = clProject.Id;
            customRecordsList.add(customRecord);
        }
        
        if(isInsert)
        	insert customRecordsList;
        return customRecordsList;
    }
     public static List<customlabel__c> customLabelRecordsForAction(Set<String> labels, Boolean isInsert){
            Custom_Label_Project__c clProject = projectRecords('IB Action Plan');
            List<customlabel__c> customRecordsList = new List<customlabel__c>();
            for(String label:labels){
                customlabel__c customRecord = new customlabel__c();
                customRecord.Label__c = label;
                customRecord.Group__c = 'Action Plan';
                customRecord.Project__c = clProject.Id;
                customRecordsList.add(customRecord);
            }
            
            if(isInsert)
                insert customRecordsList;
            return customRecordsList;
        }
    
    public static void loadGlobalTestData() {
        Programme_PYP__c pypCustomSettings = new Programme_PYP__c();
        pypCustomSettings.ReferenceId__c = 'pyp';
        pypCustomSettings.Abbreviation__c = 'Primary';
        pypCustomSettings.LongNameEN__c = 'Primary Years Programme';
        pypCustomSettings.LongNameES__c = 'Programa de la Escuela Primaria';
        pypCustomSettings.LongNameFR__c = 'Programme primaire';
        pypCustomSettings.ShortNameEN__c = 'PYP';
        pypCustomSettings.ShortNameES__c = 'PEP';
        pypCustomSettings.ShortNameFR__c = 'PP';
        insert pypCustomSettings;

 

        Programme_MYP__c mypCustomSettings = new Programme_MYP__c();
        mypCustomSettings.ReferenceId__c = 'myp';
        mypCustomSettings.Abbreviation__c = 'Middle';
        mypCustomSettings.LongNameEN__c = 'Middle Years Programme';
        mypCustomSettings.LongNameES__c = 'Programa de los Años Intermedios';
        mypCustomSettings.LongNameFR__c = 'Programme d’éducation intermédiaire';
        mypCustomSettings.ShortNameEN__c = 'MYP';
        mypCustomSettings.ShortNameES__c = 'PAI';
        mypCustomSettings.ShortNameFR__c = 'PEI';
        insert mypCustomSettings;

 

        Programme_DP__c dpCustomSettings = new Programme_DP__c();
        dpCustomSettings.ReferenceId__c = 'dp';
        dpCustomSettings.Abbreviation__c = 'Diploma';
        dpCustomSettings.LongNameEN__c = 'Diploma Programme';
        dpCustomSettings.LongNameES__c = 'Programa del Diploma';
        dpCustomSettings.LongNameFR__c = 'Programme du diplôme';
        dpCustomSettings.ShortNameEN__c = 'DP';
        dpCustomSettings.ShortNameES__c = 'PD';
        dpCustomSettings.ShortNameFR__c = 'PD';
        insert dpCustomSettings;

 

        Programme_CP__c cpCustomSettings = new Programme_CP__c();
        cpCustomSettings.ReferenceId__c = 'cp';
        cpCustomSettings.Abbreviation__c = 'Career';
        cpCustomSettings.LongNameEN__c = 'Career-related Programme';
        cpCustomSettings.LongNameES__c = 'Programa de Orientación Profesional';
        cpCustomSettings.LongNameFR__c = 'Programme à orientation professionnelle';
        cpCustomSettings.ShortNameEN__c = 'CP';
        cpCustomSettings.ShortNameES__c = 'POP';
        cpCustomSettings.ShortNameFR__c = 'POP';
        insert cpCustomSettings;

 

    }

 

}