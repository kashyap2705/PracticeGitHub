@isTest
private class createUniqueOCCcodeHandlerTest {
/*  Author/owner name: Ammara Alvi
    Reason of change : Commented as part of US-11171 because Related Object OCC_Code_Generator__c is going to be Deleted
    Date:  24-09-19
    @isTest static void testLabelList() {
        try
        {
            
            
            createUniqueOCCcodeHandler obj= new createUniqueOCCcodeHandler();
            obj.currDPCPval=0.0;
            obj.currPYPval=0.0;
            obj.currMYPval=0.0;
            obj.currEPval=0.0;
           // Test.startTest();
            List<IB_Programme__c> updtOCCcodesList = new List<IB_Programme__c>();
        //createUniqueOCCcodeHandler OCC_handler2 = new createUniqueOCCcodeHandler();

        OCC_Code_Generator__c occGenDPCP = new OCC_Code_Generator__c();
        occGenDPCP.Name = 'DP and CP Programmes';
        occGenDPCP.Programme_Record_Type__c = 'DP/CP';
        occGenDPCP.Starting_Sequence_Value__c = 200000;
        occGenDPCP.Current_Sequence_Value__c = 200000;
        insert occGenDPCP;

        OCC_Code_Generator__c occGenMYP = new OCC_Code_Generator__c();
        occGenMYP.Name = 'MYP Programmes';
        occGenMYP.Programme_Record_Type__c = 'MYP';
        occGenMYP.Starting_Sequence_Value__c = 40000;
        occGenMYP.Current_Sequence_Value__c = 40000;
        insert occGenMYP;

        Account acc3 = PimsTestUtil.createAccount('Test Account', '');
        acc3.IBIS_ID__c = '123654';
   //     insert acc3;

        Account acc4 = PimsTestUtil.createAccount('Test Account2', '');
        acc4.IBIS_ID__c = '200001';
   //     insert acc4;

        insert New List<Account>{acc3,acc4};
            
        Contact con1 = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc3);
        //insert con1;
        Contact con2 = PimsTestUtil.createContact('Brown', 'con2@home.com', 'con2@prof.com', Date.newInstance(1985, 07, 04), acc3);
        //insert con2;
insert new List<contact>{con1,con2};
        IB_Programme__c prog5 = PimsTestUtil.createProgrammeForAccount (acc3, 'CP');
        prog5.StageName__c = 'Decision on Authorization';
        //insert prog5;
        IB_Programme__c prog6 = PimsTestUtil.createProgrammeForAccount (acc3, 'MYP');
        prog6.StageName__c = 'Decision on Authorization';
      //  insert prog6;
        // Created so we have at least one programme that already contains an OCC Code
        IB_Programme__c prog7 = PimsTestUtil.createProgrammeForAccount (acc4, 'CP');
        prog7.StageName__c = 'Verification visit';
        prog7.OCC_Code__c = '297000';
        //insert prog7;
insert new List<IB_Programme__c>{prog5,prog6,prog7};
        IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Programme Coordinator');
 //       insert theRoleRepo1;
        IB_Role_Repository__c theRoleRepo2 = PimsTestUtil.createRoleRepo('Head of School');
 //      insert theRoleRepo2;
        Insert New List<IB_Role_Repository__c>{theRoleRepo1,theRoleRepo2};
        IB_Role__c Role1 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1.Id, acc3.Id);
  //      insert Role1;
        IB_Role__c Role2 = PimsTestUtil.createIbRole(theRoleRepo2.Id, con2.Id, acc3.Id);
 //       insert Role2;
        Insert new List<IB_Role__c>{Role1,Role2};
        Test.startTest();

            prog5.OCC_Code__c = '222999';
            prog5.OCC_Code_Duplicate_Found__c = true;
            prog5.OCC_Code_is_Valid__c = false;
            update prog5;
            updtOCCcodesList.add(prog5);

            prog6.OCC_Code__c = '123654';
            prog6.OCC_Code_Duplicate_Found__c = true;
            prog6.OCC_Code_is_Valid__c = false;
            update prog6;
            updtOCCcodesList.add(prog6);

            obj.processOCCcodeChanges (updtOCCcodesList);
            obj.processNewOCCcodes(updtOCCcodesList);
            //obj.initializeAlltestComponents();   
            Test.stopTest();
            
        }
        catch(exception x)
        {
            system.debug('exception occurred');
        }
    }*/
}