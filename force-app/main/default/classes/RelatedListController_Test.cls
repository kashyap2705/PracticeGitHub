@IsTest
public class RelatedListController_Test {
    public static testmethod void ControllerTest_FirstPage() {
        RelatedListController cont = new RelatedListController();
        
        account acc = new account();
        acc.Name = 'United Oil & Gas, Singapore';
        insert acc; 
        
        System.assertEquals('United Oil & Gas, Singapore', acc.Name);
        
        e_eat__Audit_Tracking_sObject__c EATObject = new e_eat__Audit_Tracking_sObject__c();
        EATObject.Name = 'Account';
        EATObject.e_eat__API_Name__c = 'Account';
        EATObject.e_eat__Archival_Time_in_Months__c = 12;
        insert EATObject;
        
        System.assertEquals('Account', EATObject.Name);
        System.assertEquals('Account', EATObject.e_eat__API_Name__c);
        
        e_eat__Audit_Tracking_Field__c EATField = new e_eat__Audit_Tracking_Field__c();
        EATField.Name = 'Account Name';
        EATField.e_eat__Audit_Tracking_sObject__c = EATObject.Id;
        EATField.e_eat__Field_API_Name__c = 'Name';
        insert EATField;
        
        System.assertEquals('Account Name', EATField.Name);
        System.assertEquals('Name', EATField.e_eat__Field_API_Name__c);
        System.assertEquals(EATObject.Id, EATField.e_eat__Audit_Tracking_sObject__c);
        
        list<e_eat__Audit_Tracking_History__c> EATList = new list<e_eat__Audit_Tracking_History__c>();
        for(Integer i=0;i<50;i++)
        {
            e_eat__Audit_Tracking_History__c EAT = new e_eat__Audit_Tracking_History__c();
            EAT.e_eat__Audit_Tracking_Field__c = EATField.Id;
            EAT.e_eat__New_Value__c = 'United Oil & Gas, Singapore'+i;
            EAT.e_eat__Original_Value__c = 'United Oil & Gas, Singapore';
            EAT.e_eat__Related_Record_ID__c = acc.id;
            EATList.add(EAT);
        }
        insert EATList;
        System.assertEquals(50, EATList.size());
        test.startTest();
        RelatedListController.fetchHistoryTrackingData(acc.id,'account',false,false,false,10,0);
        RelatedListController.getIconName('account');
        test.stopTest();
        
    }
    public static testmethod void ControllerTest_SecondPage() {
        RelatedListController cont = new RelatedListController();
        
        account acc = new account();
        acc.Name = 'United Oil & Gas, Singapore';
        insert acc; 
        
        System.assertEquals('United Oil & Gas, Singapore', acc.Name);
        
        e_eat__Audit_Tracking_sObject__c EATObject = new e_eat__Audit_Tracking_sObject__c();
        EATObject.Name = 'Account';
        EATObject.e_eat__API_Name__c = 'Account';
        EATObject.e_eat__Archival_Time_in_Months__c = 12;
        insert EATObject;
        
        System.assertEquals('Account', EATObject.Name);
        System.assertEquals('Account', EATObject.e_eat__API_Name__c);
        
        e_eat__Audit_Tracking_Field__c EATField = new e_eat__Audit_Tracking_Field__c();
        EATField.Name = 'Account Name';
        EATField.e_eat__Audit_Tracking_sObject__c = EATObject.Id;
        EATField.e_eat__Field_API_Name__c = 'Name';
        insert EATField;
        
        System.assertEquals('Account Name', EATField.Name);
        System.assertEquals('Name', EATField.e_eat__Field_API_Name__c);
        System.assertEquals(EATObject.Id, EATField.e_eat__Audit_Tracking_sObject__c);
        
        list<e_eat__Audit_Tracking_History__c> EATList = new list<e_eat__Audit_Tracking_History__c>();
        for(Integer i=0;i<50;i++)
        {
            e_eat__Audit_Tracking_History__c EAT = new e_eat__Audit_Tracking_History__c();
            EAT.e_eat__Audit_Tracking_Field__c = EATField.Id;
            EAT.e_eat__New_Value__c = 'United Oil & Gas, Singapore'+i;
            EAT.e_eat__Original_Value__c = 'United Oil & Gas, Singapore';
            EAT.e_eat__Related_Record_ID__c = acc.id;
            EATList.add(EAT);
        }
        insert EATList;
        
        test.startTest();
        RelatedListController.fetchHistoryTrackingData(acc.id,'account',true,true,true,10,0);
        ApexPages.CurrentPage().getparameters().put('id',acc.Id);
        EnhancedAuditTrackingCont eaNew = new EnhancedAuditTrackingCont();
        RelatedListController.getIconName('account');
        System.assertEquals(50, EATList.size());
        test.stopTest();
        
    }
}