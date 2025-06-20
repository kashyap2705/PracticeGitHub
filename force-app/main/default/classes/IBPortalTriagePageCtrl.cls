/*******************************************************************************************
* @Name     IBPortalTriagePageCtrl 
* @Author       
* @Date         
* @Group        
* @Description  This Class is used to redirect to Registration form for invited contacts
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Ranjith Kondabathini      05/30/2023         Modified the logic to allow external contacts to register if there is no role added to those contacts     
*******************************************************************************************/
public with sharing class IBPortalTriagePageCtrl{
    
    public Contact contactObject {get; set;}
    public String invitationID {get;set;}
    public Contact invitationContact {get; set;}
    public List<IB_Role__c> existingRole {get; set;} // added by kashyap to display error msg if invite id /contact is deleted 
    public IB_Role__c role {get;set;}
    public String language {get;set;} // added by kashyap to pass selected langugae to login page as a part of ECM 197641-->
    
    public List<String> param{get;set;}
    public String body {get;set;}
    public List<IB_Role__c> roles{get;set;}
    public String labelBody {get;set;}
    public boolean withDrawnInviteId {get;set;} // added by kashyap to display error msg if invite id /contact is deleted  
    
    public IBPortalTriagePageCtrl(){
        
        contactObject = new Contact ();
        body = '';
        param = new List<String>();
        invitationID = apexpages.currentpage().getparameters().get('inviteid');
        if(invitationID != null && invitationID != ''){            
                invitationContact = MyContactDAO.INSTANCE.getContactbyInvitationID(invitationID);
                /** Added by kashyap as a part of ECM00503 to show withdrawal verbiage once role is withdrawn**/
                if(invitationContact != null){
                    existingRole= MyContactDAO.INSTANCE.getRolebyContactId(invitationContact.Id);
                    
                }
               /** Added by kashyap as a part of ECM00503 to show withdrawal verbiage once role is withdrawn**/             
            
        }
        
        
        // Added by kashyap as a part of ECM00503 to show withdrawal verbiage once role id deleted or withdrawn
        withDrawnInviteId = true;
        if(invitationContact != null && (existingRole==null || existingRole.isEmpty()))  {
            withDrawnInviteId = false;            
        }
        else if(invitationContact != null && existingRole!=null && !existingRole.isEmpty()){
            for(IB_Role__c ibRole: existingRole) {
                if(ibRole.Status__c == 'Invited') {
                    withDrawnInviteId = false;
                    break;
                }
            }
        }
        
        if(!withDrawnInviteId) {
            init(invitationContact);
        }
    }
    
    public PageReference closeSessions(){
        //Added by Kevin Fugate on 8-26-2022
        //Finds any active user sessions for the user opening this page and closes them. This change is made to prevent the user from being logged in when trying to create/merge users/contacts on being invited.
        List<AuthSession> sessionList = [SELECT Id, users.name FROM authsession WHERE iscurrent = true AND users.name != 'ibportal Site Guest User'];
        if(sessionList != null){
            system.debug(sessionList);
            delete sessionList;
        }
        return null;
    }
    
    public void init(Contact contact){
        
        RoleService.setAccountId(contact.accountId);
        roles = RoleService.getRolesByAccountId();
        for (IB_Role__c r : roles) {
            if(r.IB_Contact__c == contact.id){
                role = r;
                break;
            }
        }
        
        if(contact.Salutation != null){
            param.add(contact.Salutation);
        } else param.add('');
        
        param.add(contact.FirstName);
        param.add(contact.LastName);
        if(role != null) {
            param.add(role.Account_Name__c);
            param.add(role.IB_Role_Name__c);
            labelBody = Label.MyIB_TriagePage_body;
        } else {
            // param.add(contact.Account.Name);
            // param.add('');
            labelBody = Label.MyIB_TriagePage_body_v2;
        }
        //  param.add(role.Account_Name__c); 
        //  param.add(role.IB_Role_Name__c);
        body = String.format(labelBody, param);
        
    }
    
    public String getLocale() {
        LocaleSwitcherExtension lse = new LocaleSwitcherExtension();
        return lse.getLocale();
    }
}