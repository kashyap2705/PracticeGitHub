public without sharing class roleRemoveRequestCtrl {
    
    public string userId = Userinfo.getUserId();
    @TestVisible User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
    
    public List<IB_Role__c> myRoles {get;set;}
    public Integer roleCount {get;set;}
    Public User userTemp = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
    
    
    public ID ConID {get;set;}
    public String TempIDThis {get;set;}
    public   String deleteRoleId { get; set; }
    public   string redirectUrl{get;set;}
    
    public IB_Role__c docToRemoveTemp {get;set;}
    public ID TempIDSecond {get;set;}
    //Following code is added by Developer Umair-Plumlogix of SA Project of US-12079 on 11/20/2020
    //Start
    public roleRemoveRequestCtrl(){
        // IB_Role__c c = (IB_Role__c) controller.getRecord();
        TempIDThis = ApexPages.currentPage().getParameters().get('TempID');
        // TempIDThis = c.id;
        docToRemoveTemp = [SELECT Id, IB_Role_Name__c,IB_Role_Name_es__c,IB_Role_Name_fr__c, Status__c
                           FROM IB_Role__c
                           WHERE Id = :TempIDThis];
    }
       public PageReference removeRecord() 
    {
        
        try{

            System.debug('------------------------------Javalog: Start');
            IB_Role__c docToRemove = [SELECT Id,Account_Id_Formula__c,IB_Contact__c,Programme_Coordinator_First_Name__c,IB_Account__c, IB_Contact__r.User_Language__c, IB_Contact__r.Email, Name, Status__c, IB_Programme_New__c, Programme_Coordinator_Email__c
                                      FROM IB_Role__c
                                      WHERE Id = :TempIDThis];
            System.debug('-------------------------------Javalog: Role '+docToRemove );
            //Following code is added by Developer Arbaz Sharif-Plumlogix of SA Project of US-12079 (DE6341) on 05/26/2021
            //Start
            List<IB_Role__c> pcRole = new List<IB_Role__c>();
            if(docToRemove.IB_Programme_New__c != null){
                 System.debug('-------------------------------Javalog: Programme not null');
                pcRole = [SELECT Id, IB_Contact__r.User_Language__c ,IB_Contact__r.LastName, IB_Contact__r.Email,IB_Contact__r.Name, IB_Contact__r.FirstName, IB_Contact__c, Status__c, IB_Role_Name__c FROM IB_Role__c Where IB_Programme_New__c =:docToRemove.IB_Programme_New__c  and Status__c = 'Confirmed' and IB_Role_Name__c = 'Programme Coordinator' Limit 1];
                
            }
            else if(docToRemove.IB_Programme_New__c == null){
               
                string name = '%'+docToRemove.Programme_Coordinator_First_Name__c+'%';
                 System.debug('-------------------------------Javalog: Programme null');
                pcRole = [SELECT Id,Account_Id_Formula__c , IB_Contact__r.User_Language__c , IB_Contact__r.Email,IB_Contact__r.Name, IB_Contact__r.LastName, IB_Contact__r.FirstName, IB_Contact__c, Status__c, IB_Role_Name__c FROM IB_Role__c Where Account_Id_Formula__c =:docToRemove.Account_Id_Formula__c AND (IB_Contact__r.Name like :name)  and Status__c = 'Confirmed' and IB_Role_Name__c = 'Programme Coordinator' Limit 1];
               if(pcRole.size() == 0)
                pcRole = [SELECT Id,Account_Id_Formula__c , IB_Contact__r.User_Language__c , IB_Contact__r.Email,IB_Contact__r.Name, IB_Contact__r.LastName, IB_Contact__r.FirstName, IB_Contact__c, Status__c, IB_Role_Name__c FROM IB_Role__c Where Account_Id_Formula__c =:docToRemove.Account_Id_Formula__c AND (Email__c = :docToRemove.Programme_Coordinator_Email__c)  and Status__c = 'Confirmed' and IB_Role_Name__c = 'Programme Coordinator' Limit 1];
                               
            }
            Contact ib_contact_pc = new Contact();
            if(pcRole.size() > 0){
                System.debug('-------------------------------Javalog: '+pcRole[0] );
                docToRemove.Programme_Coordinator_Email__c =  pcRole[0].IB_Contact__r.Email;
                if (pcRole[0].IB_Contact__r.User_Language__c == 'es')
                docToRemove.Programme_Coordinator_First_Name__c = pcRole[0].IB_Contact__r.LastName;
                else if (pcRole[0].IB_Contact__r.User_Language__c == 'fr')
                docToRemove.Programme_Coordinator_First_Name__c = pcRole[0].IB_Contact__r.Name;
                else
                docToRemove.Programme_Coordinator_First_Name__c = pcRole[0].IB_Contact__r.FirstName;
                ib_contact_pc = [Select id,Name from Contact where id=:pcRole[0].IB_Contact__c];
                System.debug('-------------------------------Javalog: PC '+ib_contact_pc );
            }
                docToRemove.Status__c = 'Withdrawn'; 
                update docToRemove;
                Contact ib_contact_educator = new Contact();
                ib_contact_educator = [Select id,Name,User_Language__c from Contact where id=:docToRemove.IB_Contact__c];
                
                if(pcRole.size() > 0 && pcRole[0].IB_Contact__r.User_Language__c == 'en_US')
                {

                    SendingEmailToProgrammeCooridnatorEN(docToRemove, ib_contact_pc);
                }
                else if (pcRole.size() > 0 && pcRole[0].IB_Contact__r.User_Language__c == 'es')
                {


                    SendingEmailToProgrammeCooridnatorSP(docToRemove, ib_contact_pc);
                }
                else if(pcRole.size() > 0)
                {

                    SendingEmailToProgrammeCooridnatorFR(docToRemove, ib_contact_pc); 
                }
            if( ib_contact_educator != null){
                if(ib_contact_educator.User_Language__c == 'en_US')
                {
                    SendingEmailToContactEN(docToRemove, ib_contact_educator);
                }
                else if (ib_contact_educator.User_Language__c == 'es')
                {
                    SendingEmailToContactSP(docToRemove, ib_contact_educator);
                }
                else
                {
                    SendingEmailToContactFR(docToRemove, ib_contact_educator);
                }

                //END    
            Pagereference ref = new Pagereference('/ibportal/roleRemoveConfirm');
          ref.getParameters().put('TempIDSecond', deleteRoleId);
          ref.setRedirect(true);
          return ref;        
            }
            else{
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.IBENPortal_shared_Error));
                return null;
            }
        } 
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.IBENPortal_shared_Error+' '+ex));
            return null;
        }
         
    }
    
    
    /** 
* @author Arbaz
* @date 05/20/2021
* @description Send Email to Contact about the Role Removal
* @returntype Void
* @param IB_Role__c doctoRemove,Contact ib_contact 
*/      
    public void SendingEmailToContactEN(IB_Role__c doctoRemove,Contact ib_contact){
        try{
            System.debug('Inside Eng Email Method Contact ---------------------------------Javalog**'+ doctoRemove);
          System.debug('Inside Eng Email Method Contact ---------------------------------Javalog**'+ TempIDThis);
         System.debug('Inside Eng Email Method Contact ---------------------------------Javalog**'+ doctoRemove);
          System.debug('Inside Eng Email Method Contact ---------------------------------Javalog Test**'+ doctoRemove.Id);
         System.debug('Inside Eng Email Method Contact ---------------------------------Javalog Test**'+ doctoRemove.IB_Contact__r.Email);
        
            IB_Role__c RequestRole = new IB_Role__c();
            RequestRole = [SELECT Id, Name, IB_Contact__r.Email, Status__c, Programme_Coordinator_Email__c,
                           IB_Role_Name__c FROM IB_Role__c WHERE Id = :TempIDThis];
            
            List<String> recipientList = new List<String>();
            
        system.debug('doctoRemove.IB_Contact__r.Email***'+doctoRemove.IB_Contact__r.Email);
            recipientList.add(doctoRemove.IB_Contact__r.Email);
            EmailTemplate et = [SELECT Id, Subject, HtmlValue, body FROM EmailTemplate WHERE DeveloperName ='Role_Remove_Contact_Eng_New' Limit 1];
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'ibcommunities.noreply@ibo.org'];
            if ( owea.size() > 0 ) {
                email.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            //email.setSenderDisplayName('IB Communities');
            email.setToAddresses(recipientList);
            email.setTemplateId(et.Id);
            email.setTargetObjectId(ib_contact.id);
            email.setWhatId(doctoRemove.id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
            System.debug('Inside Eng Email Method Contact END ---------------------------------Javalog');
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.IBENPortal_shared_Error+' '+ex));
        }
    }
    /** 
* @author Arbaz
* @date 05/20/2021
* @description Send Email to Programme Coordinator about the Teacher Role Removal
* @returntype Void
* @param IB_Role__c doctoRemove,Contact ib_contact
*/      
    
    public void SendingEmailToProgrammeCooridnatorEN(IB_Role__c doctoRemove,Contact ib_contact){
        try {
            System.debug('Inside Eng Email Method PC ---------------------------------Javalog');
            IB_Role__c RequestRole = new IB_Role__c();
            RequestRole = [SELECT Id, Name, IB_Contact__r.Email, Status__c, Programme_Coordinator_Email__c,
                           IB_Role_Name__c FROM IB_Role__c WHERE Id = :TempIDThis];
            
            List<String> recipientList = new List<String>();
            
            recipientList.add(doctoRemove.Programme_Coordinator_Email__c);
            
            EmailTemplate et = [SELECT Id, Subject, HtmlValue, body FROM EmailTemplate WHERE DeveloperName ='Role_Remove_PC_ENG_New' limit 1];
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'ibcommunities.noreply@ibo.org'];
            if ( owea.size() > 0 ) {
                email.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            //email.setSenderDisplayName('IB Communities');
            email.setToAddresses(recipientList);
            email.setTemplateId(et.Id);
            email.setTargetObjectId(ib_contact.id);
            email.setWhatId(doctoRemove.id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
            System.debug('Inside Eng Email Method PC END ---------------------------------Javalog');
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.IBENPortal_shared_Error+' '+ex));
        }
    }
    
    //Spanish mail will be sent to contact
    public void SendingEmailToContactSP(IB_Role__c doctoRemove,Contact ib_contact){
        try{
            IB_Role__c RequestRole = new IB_Role__c();
            RequestRole = [SELECT Id, Name, IB_Contact__r.Email, Status__c, Programme_Coordinator_Email__c,
                           IB_Role_Name__c FROM IB_Role__c WHERE Id = :TempIDThis];
            
            List<String> recipientList = new List<String>();
            
            recipientList.add(doctoRemove.IB_Contact__r.Email);
            EmailTemplate et = [SELECT Id, Subject, HtmlValue, body FROM EmailTemplate WHERE DeveloperName ='Role_Remove_Contact_ES_New' limit 1];
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'ibcommunities.noreply@ibo.org'];
            if ( owea.size() > 0 ) {
                email.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            //email.setSenderDisplayName('IB Communities');
            email.setToAddresses(recipientList);
            email.setTemplateId(et.Id);
            email.setTargetObjectId(ib_contact.id);
            email.setWhatId(doctoRemove.id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.IBENPortal_shared_Error+' '+ex));
        }
    }
    
    //Spanish mail will be sent to PC
    public void SendingEmailToProgrammeCooridnatorSP(IB_Role__c doctoRemove,Contact ib_contact){
        try {
            IB_Role__c RequestRole = new IB_Role__c();
            RequestRole = [SELECT Id, Name, IB_Contact__r.Email, Status__c, Programme_Coordinator_Email__c,
                           IB_Role_Name__c FROM IB_Role__c WHERE Id = :TempIDThis];
            
            List<String> recipientList = new List<String>();
            
            recipientList.add(doctoRemove.Programme_Coordinator_Email__c);
            
            EmailTemplate et = [SELECT Id, Subject, HtmlValue, body FROM EmailTemplate WHERE DeveloperName ='Role_Remove_PC_ES_New' limit 1];
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'ibcommunities.noreply@ibo.org'];
            if ( owea.size() > 0 ) {
                email.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            //email.setSenderDisplayName('IB Communities');
            email.setToAddresses(recipientList);
            email.setTemplateId(et.Id);
            email.setTargetObjectId(ib_contact.id);
            email.setWhatId(doctoRemove.id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.IBENPortal_shared_Error+' '+ex));
        }
    }
    
    //French mail will be sent to contact
    public void SendingEmailToContactFR(IB_Role__c doctoRemove,Contact ib_contact){
        try{
            IB_Role__c RequestRole = new IB_Role__c();
            RequestRole = [SELECT Id, Name, IB_Contact__r.Email, Status__c, Programme_Coordinator_Email__c,
                           IB_Role_Name__c FROM IB_Role__c WHERE Id = :TempIDThis];
            
            List<String> recipientList = new List<String>();
            
            recipientList.add(doctoRemove.IB_Contact__r.Email);
            EmailTemplate et = [SELECT Id, Subject, HtmlValue, body FROM EmailTemplate WHERE DeveloperName ='Role_Remove_Contact_FR_New' limit 1];
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'ibcommunities.noreply@ibo.org'];
            if ( owea.size() > 0 ) {
                email.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            //email.setSenderDisplayName('IB Communities');
            email.setToAddresses(recipientList);
            email.setTemplateId(et.Id);
            email.setTargetObjectId(ib_contact.id);
            email.setWhatId(doctoRemove.id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.IBENPortal_shared_Error+' '+ex));
        }
    }
    
    //French mail will be sent to PC
    public void SendingEmailToProgrammeCooridnatorFR(IB_Role__c doctoRemove,Contact ib_contact){
        try {
            IB_Role__c RequestRole = new IB_Role__c();
            RequestRole = [SELECT Id, Name, IB_Contact__r.Email, Status__c, Programme_Coordinator_Email__c,
                           IB_Role_Name__c FROM IB_Role__c WHERE Id = :TempIDThis];
            
            List<String> recipientList = new List<String>();
            
            recipientList.add(doctoRemove.Programme_Coordinator_Email__c);
            
            EmailTemplate et = [SELECT Id, Subject, HtmlValue, body FROM EmailTemplate WHERE DeveloperName ='Role_Remove_PC_FR_New' limit 1];
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'ibcommunities.noreply@ibo.org'];
            if ( owea.size() > 0 ) {
                email.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            //email.setSenderDisplayName('IB Communities');
            email.setToAddresses(recipientList);
            email.setTemplateId(et.Id);
            email.setTargetObjectId(ib_contact.id);
            email.setWhatId(doctoRemove.id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.IBENPortal_shared_Error+' '+ex));
        }
    }
    //END
    
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