@isTest
public class roleRemoveConfirmCtrlTest {  
    
    @isTest (seeAllData=true)
    static void roleRemoveRequestCtrlTestMethod()
    {
       
        ID bb;
        Test.setCurrentPageReference(new PageReference('Page.roleRemoveConfirm'));
        IB_Role__c[] abc = [Select id , Status__c from IB_Role__c Limit 1];
       
    bb=abc[0].id;
        /*IB_Role__c[] role=[SELECT Id, Account_Name__c, IB_Role_Name__c,IB_Role_Name_es__c,IB_Role_Name_fr__c ,Programme_Selection__c 
            FROM IB_Role__c
            WHERE Id = :bb Limit 1];*/
    System.currentPageReference().getParameters().put('TempIDSecond', bb); 

         
        String aa;
        roleRemoveConfirmCtrl obj = new roleRemoveConfirmCtrl();
        obj.TempIDRole=abc[0].id;
        obj.userId=NULL;
        obj.user = NULL;
        obj.myRoles = NULL;
        obj.roleCount = NULL;
       // obj.roleTemp = NULL;
        obj.userTemp = NULL;
         obj.roleTemp = [SELECT Id, Account_Name__c, IB_Role_Name__c,IB_Role_Name_es__c,IB_Role_Name_fr__c ,Programme_Selection__c 
            FROM IB_Role__c
            WHERE Id = :bb];
       // obj.ConID = NULL;
        aa=abc[0].id;
       // obj.TempIDThis = abc[0].id;
      //  obj.deleteRoleId = NULL;
       // obj.redirectUrl = NULL;
       // obj.docToRemoveTemp = [SELECT Id, IB_Role_Name__c,IB_Role_Name_es__c,IB_Role_Name_fr__c, Status__c
          //  FROM IB_Role__c
           // WHERE id =: aa Limit 1];
      //  obj.TempIDSecond = NULL;
       
        abc[0].status__c = 'Withdrawn';
     
        obj.isLoggedIn();
        obj.getLocale();
    }

}