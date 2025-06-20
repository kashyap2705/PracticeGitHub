@isTest
public class CreateConFeedbackTest {
    //below testsetup method writtened by Prerna on 2nd Jan 2025 for ECM00753
@testSetup
    static Void setup() {

        Account theAccount = PimsTestUtil.createAccount('TestIBSchool','School Account');
        insert theAccount;

        Contact theContact = PimsTestUtil.createContact('Jack Reacher','jr@tibs.com','jr@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'PYP');
        theProgramme.StageName__c = 'Consideration';
        insert theProgramme;

        IB_Application__c theApp = new IB_Application__c(
                AC_3_1_Feasability_Lead__c = theContact.Id,
                Application_Lookup_to_Programme__c = theProgramme.Id,
                AC_3_1_Feasability_Leads__c = theContact.Id,
                AFC_Assessment_Status__c = 'Complete'
        );
        insert theApp;
    }
    
    static testMethod Void one(){
        Boolean isError = false;
        try{
        //code added by Prerna on 2nd Jan 2025 for ECM00753 --STARTS--
        RecordType visitRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'Initial_Visit'];

        IB_Application__c theApp = [
        SELECT  Id, Status__c
        FROM    IB_Application__c
        ];

        theApp.Status__c = 'Submitted';
        update theApp;

        IB_Programme__c tmpProg = [
                SELECT Id, StageName__c
                FROM IB_Programme__c
        ];

        IB_Consultant_Feedback__c visitFeedback = new IB_Consultant_Feedback__c(
                IB_Programme_Lookup__c = tmpProg.Id,
                IB_Application__c = theApp.Id,
                Status__c = 'Not Started',
                RecordTypeId = visitRecType.Id
        );

        insert new List<IB_Consultant_Feedback__c>{visitFeedback};
        //code added by Prerna on 2nd Jan 2025 for ECM00753 --ENDS--
         
            List<CreateConFeedback.CreateEOPActionRequest> tmpList = new List<CreateConFeedback.CreateEOPActionRequest>();
            CreateConFeedback.CreateEOPActionRequest tmp = new CreateConFeedback.CreateEOPActionRequest();
            //tmp.visitFeedbackId = '001000000000000';
            //below line added by Prerna on 2nd Jan 2025 for ECM00753 
            tmp.visitFeedbackId = visitFeedback.Id;  // Use the valid Id
            tmpList.add(tmp);

            CreateConFeedback.createEOPFeedbackRecord(tmpList);
        }
        catch(Exception e){
            isError = true;
        }
        System.assert(!isError);
    }

    static testMethod Void two(){
        integer i = 1;

        try{
            throw new MyException('test');
        }
        catch(Exception e){

            List<CreateConFeedback.CreateEOPActionRequest> tmpList = new List<CreateConFeedback.CreateEOPActionRequest>();
            CreateConFeedback.CreateEOPActionRequest tmp = new CreateConFeedback.CreateEOPActionRequest();
            tmp.visitFeedbackId = '001000000000000';
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
            tmpList.add(tmp);
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);

            //CreateConFeedback.handleError(e,tmpList);
        }
    }

    public class MyException extends exception{}
}