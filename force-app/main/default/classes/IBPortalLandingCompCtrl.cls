public without sharing class IBPortalLandingCompCtrl {
    
    Public User userTemp = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
    
    public  List<IB_Role__c> myRoles {get;set;}
    
    public  Integer roleCount {get;set;}
	
	public ID ConID {get;set;}
    //Following code is added by Developer Umair-Plumlogix of SA Project of US-12079 on 11/20/2020
	//Start
    public IBPortalLandingCompCtrl()
    {
    ConID = userTemp.ContactId;
		//Added Status = 'Invited' condition in following list as a part of ADASUS10 of Admin Assistant Project on 12/13/2021
        myRoles = [
            SELECT Id, Name, Account_Name__c,Role_Has_Subjects__c, End_Date__c, Programme_Selection_Es__c,
            Programme_Selection_FR__c, toLabel(Status__c), Programme_Selection__c, IB_Contact__c, Status_Value__c, 
            IB_Account__c, IB_Account__r.Name, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, 
            Programme_Type_ES__c, Programme_Type_FR__c, IB_Role__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, 
            IB_Programme_New__r.RecordType.Name, IB_Role_Programme_Combo__c,Start_Date__c
            FROM IB_Role__c
            WHERE IB_Contact__c = :ConID
           /* AND (End_Date__c = null OR End_Date__c > TODAY)*/
            AND (Status__c = 'Applicant' OR Status__c = 'Confirmed' OR Status__c = 'Invited')
            AND (IB_Role__r.Display_in_MyIB__c = true OR IB_Role__r.Display_Confirmed_in_MyIB__c = true)
            ORDER BY Start_Date__c
        ];
        
       
    	roleCount = myRoles.size();

    }
    public String getLocale() {
        return UserInfo.getLanguage();
    }
 //End

}