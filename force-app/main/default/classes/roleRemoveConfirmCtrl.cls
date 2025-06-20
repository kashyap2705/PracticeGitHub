public without sharing class roleRemoveConfirmCtrl {
    
    public string userId = Userinfo.getUserId();
    @TestVisible User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());

    public List<IB_Role__c> myRoles {get;set;}
    public IB_Role__c roleTemp {get;set;}
   // public IB_Programme__c programmeTemp {get;set;}
    
    public Integer roleCount {get;set;}
    Public User userTemp = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
    

    //public ID ConID {get;set;}
    public String TempIDRole {get;set;}
    public   String deleteAppDocId { get; set; }

    //Following code is added by Developer Umair-Plumlogix of SA Project of US-12079 on 11/20/2020
	//Start
    public roleRemoveConfirmCtrl(){
        
        TempIDRole = ApexPages.currentPage().getParameters().get('TempIDSecond');
       
        System.debug('UmairConfirm'+TempIDRole);
        roleTemp = [SELECT Id, Account_Name__c,PC_Name__c, IB_Role_Name__c,IB_Role_Name_es__c,IB_Role_Name_fr__c ,Programme_Selection__c 
            FROM IB_Role__c
            WHERE Id = :TempIDRole];
        System.debug('UmairProg'+roleTemp.Programme_Selection__c);
       // IB_Programme__c programmeTemp = new IB_Programme__c();
           /* programmeTemp = [SELECT id, Programme_Coordinator_Name__c 
                                FROM IB_Programme__c
                                WHERE Programme_Selection__c =: roleTemp.Programme_Selection__c Limit 1];*/
       // if(roleTemp.PC_Name__c != Null){
        /*IB_Programme__c[] programmeTemp = [SELECT Id ,Programme_Coordinator_Name__c from IB_Programme__c 
                                           where Programme_Selection__c != Null AND Programme_Selection__c =: roleTemp.Programme_Selection__c Limit 1];*/
		if (roleTemp != null)
        {
        deleteAppDocId = roleTemp.PC_Name__c;
        }
        else
        {
            deleteAppDocId = null;
        }
        
    }

	//a0Y5r000000055hEAA
    public PageReference isLoggedIn() {
        try
        {
            if (UserInfo.getUserType() == 'Guest') {
                return new PageReference('/ibportal/IBPortalLogin');
            }
            else {
                return null;
            }       
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }



    }
    
    public String getLocale() {
        return UserInfo.getLanguage();
    }  
//End

}