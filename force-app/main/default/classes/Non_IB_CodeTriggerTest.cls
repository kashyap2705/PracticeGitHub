@isTest
// Class Created by Prerna for ECM00498 on 12/19/2022
// This class is to cover Non_IB_CodeBeforeInsertTriggerHandler and Non_IB_CodeBeforeUpdateTriggerHandler classes
public class Non_IB_CodeTriggerTest {
    public static Id cpRecordTypeID = [SELECT ID FROM RecordType WHERE Name= 'CP' and SobjectType = 'IB_Programme__c' Limit 1].id;
    public static Id dpRecordTypeID = [SELECT ID FROM RecordType WHERE Name= 'Diploma Programme'and  SobjectType = 'IB_Programme__c' Limit 1].id;
    public static Id pypRecordTypeID = [SELECT ID FROM RecordType WHERE Name= 'PYP'and  SobjectType = 'IB_Programme__c' Limit 1].id;
    @testSetup
    static void setup(){
        Test.startTest();
         Account account = AccountTestDataFactory.createAccount(null,null);
         account.External_PD_Provider__c = true;
            account.Language_Of_Correspondance__c = 'English';
            account.Legal_Status__c = 'Private';
            //account.Short_Name__c = name;
            account.IBIS_ID__c = '000001';
        insert account;
        IB_Address__c address = TestsUtil.createAddress(account.id);
        insert address;
        IB_Programme__c cpProgramme = new IB_Programme__c();
        cpProgramme.Account__c = account.id;
        cpProgramme.Name = 'CP Test Programme';
        cpProgramme.StageName__c = 'Evaluation';
        cpProgramme.IBCC_Implementation_Phase__c = 'Phase 1';
        cpProgramme.Close_Date__c = Date.today(); 
        cpProgramme.CurrencyIsoCode= 'EUR';
        cpProgramme.Primary_Language_Of_Instruction__c = 'English';
        cpProgramme.Status__c = 'Interested';
        cpProgramme.Programme_Legal_Name__c =  'Test';
        cpProgramme.Exam_Session__c = 'May';
        cpProgramme.Street_Address__c = address.id;
        cpProgramme = IBProgrammeTestDataFactory.createIBProgramme('CP',cpProgramme);
        insert cpProgramme;
        Non_IB_Code__c nonIBCodeCP = TestsUtil.createNonIBCodeForCP(cpProgramme.id, account.id);
        insert nonIBCodeCP;  
        IB_Programme__c dpProgramme = new IB_Programme__c();
        dpProgramme.Account__c = account.id;
        dpProgramme.Name = 'DP Test Programme';
        dpProgramme.StageName__c = 'Evaluation';
        dpProgramme.IBCC_Implementation_Phase__c = 'Phase 1';
        dpProgramme.Close_Date__c = Date.today(); 
        dpProgramme.CurrencyIsoCode= 'EUR';
        dpProgramme.Primary_Language_Of_Instruction__c = 'English';
        dpProgramme.Status__c = 'Interested';
        dpProgramme.Programme_Legal_Name__c =  'Test';
        dpProgramme.Exam_Session__c = 'May';
        dpProgramme.Street_Address__c = address.id;
        dpProgramme = IBProgrammeTestDataFactory.createIBProgramme('DP',dpProgramme);
        insert dpProgramme;
         Non_IB_Code__c nonIBCodeDP = TestsUtil.createNonIBCodeForDP(dpProgramme.id, account.id);
        insert nonIBCodeDP;
        IB_Programme__c pypProgramme = new IB_Programme__c();
        pypProgramme.Account__c = account.id;
        pypProgramme.Name = 'PYP Test Programme';
        pypProgramme.StageName__c = 'Evaluation';
        pypProgramme.IBCC_Implementation_Phase__c = 'Phase 1';
        pypProgramme.Close_Date__c = Date.today(); 
        pypProgramme.CurrencyIsoCode= 'EUR';
        pypProgramme.Primary_Language_Of_Instruction__c = 'English';
        pypProgramme.Status__c = 'Interested';
        pypProgramme.Programme_Legal_Name__c =  'Test';
        pypProgramme.Exam_Session__c = 'May';
        pypProgramme.Street_Address__c = address.id;
        pypProgramme = IBProgrammeTestDataFactory.createIBProgramme('PYP',pypProgramme);
        insert pypProgramme;
    
       
        Non_IB_Code__c nonIBCodePYP = TestsUtil.createNonIBCodeForPYP(pypProgramme.id,account.id);
        insert nonIBCodePYP;
        Test.stopTest();
    }
    @isTest static void testCPIBProgramme() {
        Test.startTest();
        Map<Id, Non_IB_Code__c> newMap = new Map<Id, Non_IB_Code__c>();
        List<Non_IB_Code__c> nonIBCodeCP= [Select id,Code_Name__c,Code_Description__c,Code__c,Related_to_IB_Programme_1__c,Related_to_IB_Programme_2__c,Related_to_IB_Programme_3__c,Related_to_IB_Programme_4__c,Related_to_IB_Account__c from Non_IB_Code__c where Code__c='1' LIMIT 1];
        Non_IB_CodeBeforeInsertTriggerHandler.process(new List<Non_IB_Code__c>{nonIBCodeCP[0]});
        //then 
        System.assertEquals(1, [SELECT Id FROM Account].size());
        System.assertEquals(1, [SELECT Id FROM IB_Address__c].size());
        System.assertEquals(3, [SELECT Id FROM IB_Programme__c].size());
        System.assertEquals(3, [SELECT Id FROM Non_IB_Code__c].size());
		
        //updating code 
        nonIBCodeCP[0].Code_Description__c = 'test';
        update nonIBCodeCP;
        
        //populating the map
        newMap.put(nonIBCodeCP[0].id, nonIBCodeCP[0]);
        
        //When
        Non_IB_CodeBeforeUpdateTriggerHandler.process(new List<Non_IB_Code__c>{nonIBCodeCP[0]},newMap);
        
        //then
        System.assertEquals(3, [SELECT Id FROM Non_IB_Code__c].size());
        Test.stopTest();
        
    }

    @isTest static void testDPIBProgramme() {
        Test.startTest();
        Map<Id, Non_IB_Code__c> newMap = new Map<Id, Non_IB_Code__c>();//when
        List<Non_IB_Code__c> nonIBCodeDP= [Select id,Code_Name__c,Code_Description__c,Code__c,Related_to_IB_Programme_1__c,Related_to_IB_Programme_2__c,Related_to_IB_Programme_3__c,Related_to_IB_Programme_4__c,Related_to_IB_Account__c from Non_IB_Code__c where Code__c='2' LIMIT 1];
        Non_IB_CodeBeforeInsertTriggerHandler.process(new List<Non_IB_Code__c>{nonIBCodeDP[0]});
        
        //then
        System.assertEquals(1, [SELECT Id FROM Account].size());
        System.assertEquals(1, [SELECT Id FROM IB_Address__c].size());
        System.assertEquals(3, [SELECT Id FROM IB_Programme__c].size());        
        System.assertEquals(3, [SELECT Id FROM Non_IB_Code__c].size());
       
       //creating new Account
        Account acc = TestsUtil.createSecondAccount('Test Public School 2');
        acc.Website='https://www.testlocal.com/';
        insert acc;
       
        IB_Address__c addr = TestsUtil.createSecondAddress(acc.id);
        insert addr;
       
        IB_Programme__c secondDPProgramme = TestsUtil.createSecondDPProgramme(acc.id, addr.id, dpRecordTypeID);
        insert secondDPProgramme;
       
        nonIBCodeDP[0].Related_to_IB_Programme_2__c = secondDPProgramme.id;
        update nonIBCodeDP;
       
        newMap.put(nonIBCodeDP[0].id, nonIBCodeDP[0]);
        Non_IB_CodeBeforeUpdateTriggerHandler.process(new List<Non_IB_Code__c>{nonIBCodeDP[0]},newMap);
        Test.stopTest();
	}
    
    @isTest static void testPYPIBProgramme() {
        Test.startTest();
        Map<Id, Non_IB_Code__c> newMap = new Map<Id, Non_IB_Code__c>();
        List<Non_IB_Code__c> nonIBCodePYP= [Select id,Code_Name__c,Code_Description__c,Code__c,Related_to_IB_Programme_1__c,Related_to_IB_Programme_4__c,Related_to_IB_Programme_2__c,Related_to_IB_Programme_3__c,Related_to_IB_Account__c from Non_IB_Code__c where Code__c='4' LIMIT 1];
        //When
        Non_IB_CodeBeforeInsertTriggerHandler.process(new List<Non_IB_Code__c>{nonIBCodePYP[0]});
        
        //Then
        System.assertEquals(1, [SELECT Id FROM Account].size());
        System.assertEquals(1, [SELECT Id FROM IB_Address__c].size());
        System.assertEquals(3, [SELECT Id FROM IB_Programme__c].size());
        System.assertEquals(3, [SELECT Id FROM Non_IB_Code__c].size());
       
       //Given
        Account acc = TestsUtil.createSecondAccount('Test Public School 2');
        acc.Website='https://www.testlocal.com/';
        insert acc; 
       
        IB_Address__c addr = TestsUtil.createSecondAddress(acc.id);
        insert addr;
       
        IB_Programme__c secondPYPProgramme = TestsUtil.createSecondPYPProgramme(acc.id, addr.id, PYPRecordTypeID);
        insert secondPYPProgramme;
       
        nonIBCodePYP[0].Related_to_IB_Programme_4__c = secondPYPProgramme.id;
        update nonIBCodePYP;
        System.assertEquals(3, [SELECT Id FROM Non_IB_Code__c].size());
       
        newMap.put(nonIBCodePYP[0].id, nonIBCodePYP[0]);
        
        //When
        Non_IB_CodeBeforeUpdateTriggerHandler.process(new List<Non_IB_Code__c>{nonIBCodePYP[0]},newMap);
        Test.stopTest();
}
}