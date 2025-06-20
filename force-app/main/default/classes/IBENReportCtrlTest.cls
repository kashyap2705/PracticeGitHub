@isTest
public class IBENReportCtrlTest {
    static testmethod void success(){
      Account acct = TestsUtil.createAccount('test');
        insert acct;
        Opportunity opp = TestsUtil.createOpportunity('testing',acct.Id);
        insert opp;
        id bb;
        string ab='nothing';
        Attachment att =TestsUtil.createAttachment('nothing',opp.Id);//new Attachment(Name = 'test',ParentId = opp.Id,Body=Blob.valueOf(ab),ContentType='nothingto');
        insert att;
        Attachment att1= [select id from Attachment];
         bb=att1.id;   
         Test.setCurrentPageReference(new PageReference('Page.IBENReport'));
    System.currentPageReference().getParameters().put('file', bb); 

IBENReportCtrl obj=new IBENReportCtrl();
    }
}