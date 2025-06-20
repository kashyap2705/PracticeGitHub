@isTest
private class preventAuthorizedCheckContactsTest {

    @isTest
    static void preventAuthorizedCheckContactsHandlerTestMethod()
    {
        preventAuthorizedCheckContactsHandler obj = new preventAuthorizedCheckContactsHandler();
        obj.roleId=NULL;
        obj.roleName=NULL;
        obj.roleFilledHeadOfSchool=NULL;
        obj.roleFilledProgrammeCoordinator=NULL;
        obj.LoopCounter=0;
        obj.currProg=NULL;
        obj.roleRepoMap=NULL;
        obj.roleMap=NULL;
        obj.roleMapTemp=NULL;
        obj.roleMapNested=NULL;
        obj.programmeRoles=NULL;
        
        obj.processUpdatedProgs(NULL);
       
    }
    
     static testMethod void test_method_one() {
         //try
         //{
        //Following portion is updated by Fahad-Plumlogix of US11095 on 02/10/2020
        //Start
          RECORDTYPE rt=[SELECT id,name FROM RECORDTYPE WHERE sobjecttype ='Opportunity' and name='pyp' limit 1];
          
          Account acc = PimsTestUtil.createAccount('Test Account', '');
          insert acc;

          Contact con1 = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);
         // insert con1;
//commented         
          Contact con2 = PimsTestUtil.createContact('Brown', 'con2@home.com', 'con2@prof.com', Date.newInstance(1985, 07, 04), acc);
          //insert con2; 
//          commented by plum
        
          insert new List<contact>{con1,con2};
          IB_Programme__c p = PimsTestUtil.createProgrammeForAccount (acc, 'PYP');
          p.Status__c = 'Interested';
          insert p;
          Opportunity prog1 = new Opportunity(Name='hh1',StageName='Decision on Candidacy',AccountId=acc.id,CloseDate=Date.today(),	RecordTypeId=rt.id);
         
       //   prog1.Status__c = 'Interested';
          insert prog1;
         // IB_Programme__c prog2 = PimsTestUtil.createProgrammeForAccount (acc, 'PYP');
         // prog2.Status__c = 'Interested';
          //insert prog2;

       //  insert new List<IB_Programme__c>{prog1,prog2};
          IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Programme Coordinator');
         // insert theRoleRepo1;
         // IB_Role_Repository__c theRoleRepo2 = PimsTestUtil.createRoleRepo('Head of School');
        //  insert theRoleRepo2;
          IB_Role_Repository__c theRoleRepo3 = PimsTestUtil.createRoleRepo('Billing Contact');
       //   insert theRoleRepo3;

         insert new List<IB_Role_Repository__c>{theRoleRepo1,theRoleRepo3};
         
          IB_Role__c Role1 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1.Id, acc.Id);
          Role1.IB_Programme_New__c = p.Id;
          Role1.IB_Programme__c=prog1.id;
          insert Role1;
         /* IB_Role__c Role2 = PimsTestUtil.createIbRole(theRoleRepo2.Id, con2.Id, acc.Id);
          Role2.IB_Programme_New__c = p.Id;
          Role2.IB_Programme__c=prog1.id;
          insert Role2;*/
          IB_Role__c Role3 = PimsTestUtil.createIbRole(theRoleRepo3.Id, con1.Id, acc.Id);
          Role3.IB_Programme_New__c = p.Id;
          Role3.IB_Programme__c=prog1.id;
          insert Role3;
          //IB_Role__c Role4 = PimsTestUtil.createIbRole(theRoleRepo2.Id, con2.Id, acc.Id);
         // Role4.IB_Programme_New__c = prog2.Id;
         // insert Role4;

        // insert new List<IB_Role__c>{Role1,Role2,Role3,Role4};
          

          Test.startTest();

               //prog1.Status__c = 'Candidate';
               //prog1.Date_Decision_on_Candidacy__c = Date.today();
               //prog1.Invoice_Date__c = 'Aug 1 2016';
               //updatedProgs.add(prog1);

              // prog2.Status__c = 'Authorized';
             //  prog2.Date_Decision_on_Authorization__c = Date.today();
         	 //  prog2.Invoice_Date__c = 'Aug 1 2016';
             //  updatedProgs.add(prog2);
				p.Status__c='Candidate';
               update p;
               system.debug('enddd');

          Test.stopTest();
        // }
        //End
        //Catch(Exception x)
        //{
        //    System.debug('Exception: '+x);
        //}
     }
}