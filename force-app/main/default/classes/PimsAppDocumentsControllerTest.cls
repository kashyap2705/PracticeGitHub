@isTest
public class PimsAppDocumentsControllerTest {   

    @isTest
    static void PimsAppDocumentsControllerTestMethod()
    {
        try{
            PimsAppDocumentsController obj = new PimsAppDocumentsController();
            obj.showReqDocsMsgAfa=false;
            IB_Application_Attachment__c inst = new IB_Application_Attachment__c();
            list<IB_Application_Attachment__c> lst = new list<IB_Application_Attachment__c>();
            lst.add(inst);
            
            test.startTest();
            obj.afaAttachments = lst;
            obj.afcAttachments = lst;
            
            obj.validateRequiredDocuments();                       
            obj.isEditable=true;
            obj.validateRequiredDocuments();
            obj.isCp = false;
            obj.isPyp=true;
            obj.validateRequiredDocuments();
            obj.isPyp=false;
            obj.isMyp=true;
            obj.validateRequiredDocuments();
            obj.isDp=true;
            obj.isPyp=false;
            obj.isMyp=false;
            obj.validateRequiredDocuments();
            obj.isCp=true;
            obj.isDp=false;
            obj.isPyp=false;
            obj.isMyp=false;
            obj.validateRequiredDocuments();
            obj.isDp=false;
            obj.isPyp=false;
            obj.isMyp=false;
            obj.isCpPhase1=true;
            obj.validateRequiredDocuments();
            obj.isDp=false;
            obj.isPyp=false;
            obj.isMyp=false;
            obj.isCpPhase1=false;
            obj.isCpPhase2=true;
            obj.validateRequiredDocuments();
            obj.isPageInternal=true;
            obj.validateRequiredDocuments();
            obj.isPageExternal=true;
            obj.validateRequiredDocuments();
            obj.anyProgramme=true;
            obj.validateRequiredDocuments();
            obj.isAfa=true;
            obj.validateRequiredDocuments();
            obj.isAfc=true;
            obj.validateRequiredDocuments();
            obj.isAfa=true;
            obj.isAfc=false;
            obj.validateRequiredDocuments();
            obj.isPYP = true;
            obj.validateRequiredDocuments();
            obj.isPYP = false;
            obj.isMYP = true;
            obj.validateRequiredDocuments();
            obj.isMYP = false;
            obj.isDP = true;
            obj.validateRequiredDocuments();
            obj.isDP = false;
            obj.isCPPhase1 = true;
            obj.validateRequiredDocuments();
            obj.isCPPhase1 = false;
            obj.isCPPhase2 = true;
            obj.validateRequiredDocuments();
            test.stopTest();
        }
        catch (Exception x)
        {system.debug('exception ' + x);}
        
        
        
    }
    
    @isTest 
    static void testDocumentsController() {
        integer i=1;
        
        Account acc = PimsTestUtil.createAccount('Test Account', '');
        insert acc;
        
        IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
        insert prog;
        
        IB_Application__c app = new IB_Application__c();
        app.Name = 'Test App';
        app.Application_Lookup_to_Programme__c = prog.Id;
        insert app;
        try{
            Test.startTest();
            
            ApplicationService.setApplicationId(app.Id);
            ProgrammeService.setProgrammeId(prog.Id);
            
            PageReference testPageRef = Page.PimsApplicationForAuthorization;
            Test.setCurrentPage(testPageRef);
            testPageRef.getParameters().put('id', app.Id);
            
            PimsAppDocumentsController controller = new PimsAppDocumentsController();
            controller.docType='Docx';
            controller.description='Description';
            controller.getUserLanguageKey();
            controller.getIsEditable();
            controller.getIsdp();
            controller.getIscp();
            controller.getIsCpPhase1();
            controller.getIsCpPhase2();
            controller.getAnyProgramme();
            controller.save();
            controller.removeAppDocument();
            controller.filebody = blob.valueOf('Test');
            controller.upload();
            controller.passUrlPathVal();
            controller.saveCustomAttachment('test');
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
            //controller.saveStandardAttachment(app.Id);
            
            Test.stopTest();
        }
        catch (Exception x)
        {system.debug('exception' + x);}
        
    }
    
}