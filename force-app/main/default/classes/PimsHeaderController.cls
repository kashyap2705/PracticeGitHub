public class PimsHeaderController {
    
    String acc = null;
    public Account account { get; set; }
    public List<IB_Role__c> rolesList {get;set;}
    public List<IB_Role__c> reqRoleHOS {get;set;}
    public List<IB_Role__c> reqRolePQ {get;set;}
    public List<IB_Application__c> checkIBApplication {get;set;}
    public User user {get;private set;}
    public List<Campaign> mypEvent {get;set;}
    public IB_Programme__c programme { get; set; }
    //public Boolean checkBQC {get;set;}
   
    
    public PimsHeaderController() {
        
        PimsCommunityService pimsService = new PimsCommunityService();
        pimsService.initUserData();
        
        Account account = AccountService.getAccount();
        acc = account.Id;
        reqRoleHOS = new List<IB_Role__c>();
        reqRolePQ = new List<IB_Role__c>();
    }
    //This code is added by Umair-Plumlogix of SA project on 8/5/2020 of US11987,US12120
    //Function to check whether BQC Tab shown or not
    //return true if the School has Canidate or Authorized MYP, MYP Patner Programme and login user is PC or HOS and had a related BQC Event 
    //return false if any of the condition not meet
    //Start
    public Boolean getcheckBQC()
    { 
        try {
        user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId()); 
        Account account = AccountService.getAccount();
        //acc = account.Id;
        String conId = user.ContactId;

            System.debug('-----------HOS: '+conId);
         if(account != null && conId != null){
         for(IB_Role__c role : [Select IB_Role_Name__c FROM IB_Role__c WHERE IB_Contact__c = :conId AND IB_Account__c=:account.id AND (IB_Role_Name__c IN ('Head of School', 'Programme Coordinator') AND Status__c = 'Confirmed')])
                                {
                                                          if(role.IB_Role_Name__c == 'Head of School')
                                                                        reqRoleHOS.add(role);
                                                          else if(role.IB_Role_Name__c == 'Programme Coordinator')
                                                                        reqRolePQ.add(role);                                       
         }

		System.debug('-----------HOS: '+reqRoleHOS.size());
        System.debug('----------PC: '+reqRolePQ.size());
        programme = [Select id,Name,Status__c,StageName__c from IB_Programme__c where Account__c=: account.id and (RecordType.DeveloperName='MYP' or RecordType.DeveloperName='MYP_Partner')  Limit 1];
        if(programme != null){
        System.debug('----------Programme: '+programme);
        mypEvent = [Select Name,IB_Subject__c, Status from campaign Where name like '%BQC%' AND (Status != 'Cancelled' AND Status != 'Complete') AND ParentId=null AND Related_IB_Programme__c =:programme.id Limit 1];
        System.debug('----------Event: '+mypEvent.size());
        if((reqRoleHOS.size() >0 || reqRolePQ.size() >0) && (programme.Status__c == 'Authorized' || programme.Status__c == 'Candidate') && mypEvent.size() >0)
				 
	 
        {
				  
	 

	
            return true;
        }
        else
        return false;
        }
             else
            return false;
         }
           else
            return false;
        }
        catch(Exception ex){
            System.debug('Exception: '+ex);
            return false;
        }
    }
    //End
    
    public Boolean gethasMySchoolRole()
    {
        user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId()); 
        IBPortalLandingCtrl portal=new IBPortalLandingCtrl();
        String conId = user.ContactId;
        rolesList = [SELECT Id, IB_Account__c, Role_Type__c, IB_Role_Name__c, Status__c, Account_Name__c, Programme_Selection__c, Programme_Selection_ES__c, Programme_Selection_FR__c, IB_Role__r.Display_in_MyIB__c  
                     FROM IB_Role__c 
                     WHERE IB_Contact__c = :conId 
                     AND IB_Account__c =:acc
                     AND (End_Date__c = null OR End_Date__c > TODAY)
                     AND (IB_Role_Name__c = 'Programme Coordinator' OR IB_Role_Name__c = 'Head of School' OR IB_Role_Name__c = 'Head of School (Overall)')
                     AND Status__c = 'Confirmed'];
        System.debug('Size : '+rolesList.size()+' Id is : '+user.ContactId);
        if(rolesList.size()>0)
        {
            return true;
        }
        else
            return false;
    }
    //show Covid Questionnaire in header when needed
    public Boolean getshowquestionnaire()
    {
        for( Maintenance_Banner__mdt maintenanceBanner:[SELECT Banner_Visible__c,DeveloperName FROM Maintenance_Banner__mdt Where DeveloperName='Questionnaire'])
        {
            return maintenanceBanner.Banner_Visible__c;
        }
        return false;
    }
    
    public Boolean gethasAuthorizedProg()
    {
        PimsCommunityService pimsService = new PimsCommunityService();
        account = pimsService.getCurrentAccount();
        if(account.Authorized_Programmes__c > 0)
            return true;
        else
            return false;
    }
    
    public String getSchoolName() {
        
        PimsCommunityService pimsService = new PimsCommunityService();
        pimsService.initUserData();
        
        Account account = AccountService.getAccount();
        return account.Name + ' - ' + account.IBIS_ID__c;
        
    }
    
	public Boolean gethasQuestionnaire()
    {
        List<COVID_19_Questionnaire__c> lst=new List<COVID_19_Questionnaire__c>();
        lst = [SELECT Id, Name, Account_Name__c, Is_school_closed_due_to_the_COVID_19__c, 
               Closed_Status_Leadership_administration__c, Closed_Status_Teachers__c, Closed_Status_Students__c,
               Closed_Date_Leadership_administration__c, Closed_Date_Teachers__c, Closed_Date_Students__c, 
               Resume_Date_Leadership_administration__c, Resume_Date_Teachers__c, Resume_Date_Students__c,
               Expected_return_at_diff_times_for_grades__c,Unknown_Comments__c,
               Current_year_teaching_learning_practice__c,Current_Year_Other_Comments__c,
               Next_year_teaching_learning_practice__c,Next_Year_Other_Comments__c,
               LastModifiedById, LastModifiedBy.Name , LastModifiedDate
               FROM COVID_19_Questionnaire__c
               WHERE Account_Name__c = :account.Id
               LIMIT 1];
        
        if(lst.size() > 0)
            return true;
        else
            return false;
    } 

    

    public List<IB_Programme__c> getProgrammes() {
        
        PimsCommunityService pimsService = new PimsCommunityService();
        pimsService.initUserData();
        
        Account account = AccountService.getAccount();
        ProgrammeService.setAccountId(account.Id);
        List<IB_Programme__c> listProgs = new List<IB_Programme__c>();
        if(ProgrammeService.getProgrammesByAccount() != null){
            for(IB_Programme__c progs : ProgrammeService.getProgrammesByAccount()){
                if(progs.Status__c != 'Previously Interested' && !(progs.Status__c.Contains('Terminated') || progs.Status__c.Contains('Withdrawn')) ){
                    listProgs.add(progs);
                }
            }
        }
        return listProgs;
        
    }
    
    public Map<Id,String> getUserAccounts() {

        User user = UserService.getUser();

        PimsCommunityService pimsService = new PimsCommunityService();
        pimsService.initUserData();

        RoleService.setContactId(user.ContactId);
      //  List<IB_Role__c> roles = RoleService.getRolesByContactId();
        List<IB_Role__c> roles=[SELECT IB_Role_Name__c,IB_Account__c,
                                	   IB_Account__r.Name,IB_Account__r.IBIS_ID__c 
                                  FROM IB_Role__c 
                                 WHERE IB_Contact__c=: user.ContactId 
                                   AND status__c='Confirmed' 
                                   AND IB_Role_Name__c in ('Programme Coordinator',
                                                           'Head of School', 
                                                           'Head of School (Overall)')];

        ContactService.setContactId(user.ContactId);
        Contact contact = ContactService.getContact();

        Map<Id,String> accountMap = new Map<Id,String>();
        accountMap.put(contact.AccountId, contact.Account.Name + ' - ' + contact.Account.IBIS_ID__c);

        for (IB_Role__c role : roles) {
            if (role.IB_Account__c != null) {
            	accountMap.put(role.IB_Account__c, role.IB_Account__r.Name + ' - ' + role.IB_Account__r.IBIS_ID__c);
            }
        }
        return accountMap;
    }
    
    /*Commented as feature not needed - 5/12/2020 by Plumlogix
    public Map<Id,String> getUserAccounts() {     
        User user = UserService.getUser();      
        PimsCommunityService pimsService = new PimsCommunityService();
        pimsService.initUserData();      
        ContactService.setContactId(user.ContactId);
        Contact contact = ContactService.getContact();
        List<IB_Role__c> roles=[SELECT IB_Role_Name__c,IB_Account__c,IB_Account__r.Name,IB_Account__r.IBIS_ID__c FROM IB_Role__c WHERE IB_Contact__c=:contact.Id AND status__c='Confirmed' AND (IB_Role_Name__c='Programme Coordinator' OR IB_Role_Name__c='Head of School' OR IB_Role_Name__c ='Head of School (Overall)')];
        List<Id> AccountIds=new List<Id>();
        for(IB_Role__c c:roles)
        {
            AccountIds.add(c.IB_Account__c);
        }
        List<Account> accounts1=[Select id from account where RecordType.Name='School Account' AND id IN:AccountIds];
        INTEGER count=0;
        Map<Id,String> accountMap = new Map<Id,String>();
        for(IB_Role__c role1 : roles)
        {
            for(Account account1:accounts1)
            {
                if(role1.IB_Account__c==account1.id)
                {
                    count++;
                    accountMap.put(role1.IB_Account__c, role1.IB_Account__r.Name + ' - ' + role1.IB_Account__r.IBIS_ID__c);
                    
                }
            }
        }
       return accountMap;
             
    } Commented as feature not needed */
    
    public List<SelectOption> getUserAccountsList() {
        
        Map<Id,String> accountMap = getUserAccounts();
        
        List<SelectOption> options = new List<SelectOption>();
        for (Id key : accountMap.keySet()) {
            options.add(new SelectOption(key, accountMap.get(key)));
        }
        
        return options;
        
    }
    
    
    public Integer getUserAccountsSize() {
        
        return getUserAccounts().size();
        
    }
    
    public PageReference switchAccount() {
        
        System.debug('acc: ' + acc);
        
        PimsCommunityService pimsService = new PimsCommunityService();
        pimsService.setAccountCookie(acc);
        
        return new PageReference('/pims/PimsDashboard');
        
    }
    
    public String getAcc() {
        return acc;
    }
    
    public void setAcc(String a) {
        this.acc = a;
    }
    
}