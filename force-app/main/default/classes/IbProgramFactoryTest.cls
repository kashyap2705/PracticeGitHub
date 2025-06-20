@isTest
public class IbProgramFactoryTest {
    public static IB_Programme__c associateAddressWithProgramme(IB_Programme__c p, IB_Address__c a, String type){
        
        if(type == 'postal'){
            p.Postal_Address__c = a.Id;
        } else if(type == 'street') {
            p.Street_Address__c = a.Id;
        } else if (type == 'billing'){
            p.Billing_Address__c = a.Id;
        }
        
        return p;
    }
    
    public static IB_Programme__c createProgrammeForAccount (Account acc, String programme){
        Id RecType = null;
        try {
            RecType = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByName().get(programme).getRecordTypeId();
        }
        catch (Exception ex) {
            System.debug(ex);
        }
        
        IB_Address__c add = new IB_Address__c();
        add.Name = 'STRUNK';
        add.IB_Account__c = acc.Id;
        add.Address_Line_1__c = 'Test';
        add.City__c = 'Test city';
        add.Postal_Code__c = '12345';
        insert add;
        
        IB_Programme__c ib = new IB_Programme__c();
        ib.RecordTypeId = RecType;
        ib.Account__c = acc.Id;
        ib.Exam_Session__c = 'May';
        ib.Status__c = 'Test';
        ib.Street_Address__c =add.id;
        ib.IBCC_Implementation_Phase__c = 'Phase 1';
        ib.Primary_Language_of_Instruction__c = 'English';
        
        return ib;
    }
}