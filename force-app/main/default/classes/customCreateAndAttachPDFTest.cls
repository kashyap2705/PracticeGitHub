@isTest// (seeAllData = true)
public class customCreateAndAttachPDFTest {

    @isTest static void testOne()
    {
        
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;
        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;
        
        
        
        
        
        IB_Address__c tmpAdd = new IB_Address__c(
            Name = 'STRUNK',
            IB_Account__c = theAccount.Id,
            Address_Line_1__c = 'Test',
            City__c = 'Test city',
            Postal_Code__c = '12345'
        );
        insert tmpAdd;
        
        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
        
        
            
           theProgramme.Date_Decision_on_Candidacy__c = Date.today();
            
           theProgramme.StageName__c = 'Consultation process'; 
           theProgramme.Status__c = 'Candidate' ;
           theProgramme.Sub_Stage__c = 'Candidacy Approved' ;
            
            
           theProgramme.Exam_Session__c = 'May';
           theProgramme.Primary_Language_of_Instruction__c = 'English';
           theProgramme.Street_Address__c = tmpAdd.id;
           theProgramme.Account__c = theAccount.Id ;
		
        
        test.startTest();
        insert theProgramme;
        
       // customCreateAndAttachPDF.ibProgramWLPDF(theProgramme.id);
        //customCreateAndAttachPDF.ibProgramWLPDF('a1R0D000000AH1Q');
        WelcomeLetterTemplateCtlr cd = new WelcomeLetterTemplateCtlr();
        test.stopTest();
            
    }
    
}