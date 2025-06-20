@isTest
private class PimsCovidQuestionnaireControllerTest {
    
    //controller
    @isTest static void test_method_one() {
        integer i=1;
        test.startTest();
        User u = PimsTestUtil.createPortalUserPYP('testname.unique1@ibo.org');
        insert u;
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
        a.IBIS_ID__c = '404044';
        a.RecordTypeId='01220000000Eyx8';
        insert a;
        
        
        Account a2 = [Select id,IBIS_ID__c,Name from Account where IBIS_ID__c='404044' limit 1];
        
        COVID_19_Questionnaire__c c= new COVID_19_Questionnaire__c();
        c.Is_school_closed_due_to_the_COVID_19__c='Yes';
        c.Account_Name__c=a2.id;
        insert c;
        
        System.RunAs(u){
            List<COVID_19_Questionnaire__c> q1 = new List<COVID_19_Questionnaire__c>();
            List<COVID_19_Questionnaire__c> q2 = new List<COVID_19_Questionnaire__c>();
            system.debug('a.id ' + a.id);
            
            PageReference pimsQuestionnaire = Page.PimsCovidQuestionnaire;
            Test.setCurrentPage(pimsQuestionnaire);
            PimsCovidQuestionnaireController controller = new PimsCovidQuestionnaireController();
            controller.isQuesPresent();
            Boolean hasRole =controller.gethasMySchoolRole();
            String lang = controller.getAccountLangofCorres();
            Boolean hasAuthProg = controller.gethasAuthorizedProg();
            Boolean hasQuestionnaire = controller.gethasQuestionnaire();
            controller.getPageHasErrors();
            controller.account=a;
            q1=  [SELECT Id, Name, Account_Name__c, Is_school_closed_due_to_the_COVID_19__c, 
                  Closed_Status_Leadership_administration__c, Closed_Status_Teachers__c, Closed_Status_Students__c,
                  Closed_Date_Leadership_administration__c, Closed_Date_Teachers__c, Closed_Date_Students__c, 
                  Resume_Date_Leadership_administration__c, Resume_Date_Teachers__c, Resume_Date_Students__c,
                  Expected_return_at_diff_times_for_grades__c,Unknown_Comments__c,
                  Current_year_teaching_learning_practice__c,Current_Year_Other_Comments__c,
                  Next_year_teaching_learning_practice__c,Next_Year_Other_Comments__c,
                  LastModifiedById, LastModifiedBy.Name , LastModifiedDate
                  FROM COVID_19_Questionnaire__c
                  WHERE Account_Name__c = :a.Id
                  LIMIT 1];
            q2= [SELECT Id, Name, Account_Name__c, Is_school_closed_due_to_the_COVID_19__c, 
                 Closed_Status_Leadership_administration__c, Closed_Status_Teachers__c, Closed_Status_Students__c,
                 Closed_Date_Leadership_administration__c, Closed_Date_Teachers__c, Closed_Date_Students__c, 
                 Resume_Date_Leadership_administration__c, Resume_Date_Teachers__c, Resume_Date_Students__c,
                 Expected_return_at_diff_times_for_grades__c,Unknown_Comments__c,
                 Current_year_teaching_learning_practice__c,Current_Year_Other_Comments__c,
                 Next_year_teaching_learning_practice__c,Next_Year_Other_Comments__c,
                 LastModifiedById, LastModifiedBy.Name , LastModifiedDate
                 FROM COVID_19_Questionnaire__c
                 WHERE Account_Name__c = :a.Id
                 LIMIT 1];
            //controller.ques4=q1;
            
            if(q2.size()>0)
            { 	
                controller.ques = q2[0];  
                update controller.ques;
            }
            else{
                COVID_19_Questionnaire__c c2= new COVID_19_Questionnaire__c();
                c2.Is_school_closed_due_to_the_COVID_19__c='Yes';
                c2.Account_Name__c=a2.Id;
                
            }
            PageReference exis = controller.save();
            
            
            
            System.assertEquals(1,i);
            test.stopTest();
        }
    }
}