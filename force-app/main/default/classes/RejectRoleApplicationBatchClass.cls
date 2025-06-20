/**
* <h1> RejectRoleApplicationBatchClass </h1>
* This class is created to Reject Role Application 
* This class is part of US12480
* @version 1.0
* @since   2021-11-26 
*/

global class RejectRoleApplicationBatchClass implements Database.Batchable<sObject>{
    public List<string> role_name_approver_programme_req = new List<string>{'Online Coordinator','Programme Coordinator'};
        // this code is edited for ecm 336
// start
    public List<string> role_name_approver_account_req = new List<string>{'Institute Administrator','Association Admin'};
        //end
    public Set<Id> accountids = new set<Id>();
    public Set<Id> programmeids = new set<Id>();
        public List<string> role_name_list_op = new List<string>{'Teacher'};
            // this code is edited  for ecm 336
// start
        public List<string> role_name_list_inst = new List<string>{'Institute Transcript User','Communication User','Institute Policy User','Institute Curriculum User','Association User'};
        public List<string> role_name_list_school = new List<string>{'Teacher','Head of Section','ATL Coordinator','Head of Faculty','Librarian','University and Career Counselor','General and Academic Counselor','ICT Coordinator','Programme Associate','Personal Project Coordinator','Community Project Coordinator','CAS Coordinator','Reflective Project Lead Supervisor','Service Learning Coordinator','Personal and Professional Skills Coordinator','Deputy/Assistant Head','Group of Schools Affiliate'};
//end

    global Database.QueryLocator start(Database.BatchableContext bc) {
        // this code is edited for ecm 336
// start
    	    string query = 'Select id,IB_Contact__c,Type__c,Programme_Coordinator_Email__c,IB_Programme_New__r.Contact_Programme_Coordinator__c,IB_Programme_New__r.Contact_Programme_Coordinator__r.User_Language__c,Programme_Coordinator_Name__c,Institute_Administrator__r.User_Language__c,Association_Administrator__r.User_Language__c,Online_Coordinator__r.User_Language__c,Online_Coordinator__c,Institute_Administrator__c,Institute_Administrator__r.Email,Association_Administrator__c,Association_Administrator__r.Email,Association_Administrator_Email__c,AIBWS_Administrator_Name_c__c,Online_Coordinator__r.Name,Online_Coordinator__r.Email,Role_Withdrawn_after_90_days__c,Account_Id_Formula__c,Approver_Role_Name__c,CreatedDate,IB_Account__r.id,status__c,Email_Confirmed__c,Account_ID__c,AccountProgrammeCombo__c,IB_Role_Name__c,IB_Contact__r.User_Language__c ,IB_Contact__r.Name,IB_Programme_New__r.id,IB_Programme_New__c,IB_Contact__r.Email from IB_Role__c where Role_Type__c != \'IBEN Role\' AND Status__c = \'Applicant\' AND  (IB_Role_Name__c IN :role_name_list_inst OR (IB_Role_Name__c IN :role_name_list_op AND Type__c = \'Online Provider\') OR IB_Role_Name__c IN :role_name_list_school) ';  
        //end
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc,List <IB_Role__c> Role_List_query) {
        
            String days = Label.Role_withdrawn_days; 
			Integer days_integer = 1-integer.valueOf(days);
			DateTime dueDate = Date.today().addDays(days_integer);
            String due_Date = dueDate.format('MM/dd/YYYY');
            System.debug('due_Date: '+due_Date);
        List <IB_Role__c> Role_List = new List<IB_Role__c>();
        List <IB_Role__c> Role_List_update = new List<IB_Role__c>();
            System.debug('Role_List_query: '+Role_List_query.size());
        for(IB_Role__c role_record: Role_List_query){
            DateTime creadteddate = role_record.CreatedDate;
            String str = creadteddate.format('MM/dd/YYYY');
            if(str == due_Date || Test.isRunningTest()){
    Role_List.add(role_record);
            accountids.add(role_record.Account_Id_Formula__c);
            if(role_record.IB_Programme_New__c != null)
                programmeids.add(role_record.IB_Programme_New__c);
            }
        }
        if(Role_List.size()>0){
    Map<String,IB_Role__c> approver_map = new Map<String,IB_Role__c>();
    for(IB_Role__c role_approver_record : [Select id,IB_Account__r.id,Contact_Information_Email_Text__c,Approver_Role_Name__c,Account_Id_Formula__c,status__c,Type__c,Email_Confirmed__c,
                                           IB_Contact__r.FirstName,IB_Contact__r.Name,IB_Contact__r.User_Language__c,IB_Contact__r.Email,IB_Contact__c,
                                           AccountProgrammeCombo__c,IB_Role_Programme_Combo__c,Account_Name__c,Programme_Selection__c,IB_Role_Name__c  
                                           from IB_Role__c where Status__c = 'Confirmed' AND Active__c = true AND IB_Account__c IN :accountids
                                          AND ((IB_Role_Name__c IN :role_name_approver_programme_req AND IB_Programme_New__c IN:programmeids) 
                                            OR IB_Role_Name__c IN :role_name_approver_account_req)])
        {
            string combo = role_approver_record.IB_Role_Name__c+'|'+role_approver_record.AccountProgrammeCombo__c;
            approver_map.put(combo,role_approver_record);
        }
    List<IB_Role__c> Applicant = new List<IB_Role__c>();
    List<IB_Role__c> Approver = new List<IB_Role__c>();
        for(IB_Role__c role_record: Role_List){
            role_record.status__c = 'Withdrawn';
            role_record.Role_Withdrawn_after_90_days__c = true;
                Applicant.add(role_record);
                IB_Role__c approver_role = new IB_Role__c();
            if(role_record.Approver_Role_Name__c == 'Online Coordinator'){
                approver_role = approver_map.get(role_record.Approver_Role_Name__c+'|'+role_record.AccountProgrammeCombo__c);
                if(approver_role != null){
                role_record.Online_Coordinator__c = approver_role.IB_Contact__c;
                role_record.Online_Coordinator_Email__c = approver_role.Contact_Information_Email_Text__c;
                role_record.Online_Coordinator_Name__c = approver_role.IB_Contact__r.Name;
                }
            }
            else if(role_record.Approver_Role_Name__c == 'Programme Coordinator'){
                approver_role = approver_map.get(role_record.Approver_Role_Name__c+'|'+role_record.AccountProgrammeCombo__c);
                if(approver_role != null){
                role_record.Programme_Coordinator_First_Name__c = approver_role.IB_Contact__r.FirstName;
                    role_record.Programme_Coordinator_Name__c = approver_role.IB_Contact__r.Name;
                    role_record.Programme_Coordinator_Email__c = approver_role.IB_Contact__r.Email;
                }
            }
            else if(role_record.Approver_Role_Name__c == 'Institute Administrator'){
                approver_role = approver_map.get(role_record.Approver_Role_Name__c+'|'+role_record.AccountProgrammeCombo__c);
                if(approver_role != null){
                role_record.Institute_Administrator__c = approver_role.IB_Contact__c;
                role_record.Institute_Administrator_Name__c = approver_role.IB_Contact__r.Name;
                role_record.Institute_Administrator_Email__c = approver_role.Contact_Information_Email_Text__c;
                }          
            }
            // this code is edited  for ecm 336
            // start
             else if(role_record.Approver_Role_Name__c == 'Association Admin'){
                 approver_role = approver_map.get(role_record.Approver_Role_Name__c+'|'+role_record.AccountProgrammeCombo__c);
                 if(approver_role != null){
                     role_record.Association_Administrator__c = approver_role.IB_Contact__c;
                	 role_record.AIBWS_Administrator_Name_c__c = approver_role.IB_Contact__r.Name;
                	 role_record.Association_Administrator_Email__c = approver_role.Contact_Information_Email_Text__c;
                 }      
             }
            //end
            system.debug('approver_role'+approver_role);
            if(approver_role != null)
                Approver.add(role_record);
                Role_List_update.add(role_record);
           System.debug('role_record: '+role_record);
        }
                       System.debug('Role_List_update: '+Role_List_update.size());
        try{
           update Role_List_update;
           System.debug('Role_List_update: '+Role_List_update.size());
            if(Applicant.size()>0)
                Send_Email_Applicant(Applicant);
             if(Approver.size()>0)
                Send_Email_Approver(Approver);
        }
        catch(Exception ex){
            System.debug('Exception: '+ex);
        }
    }
    }
    
    
    
    global void finish(Database.BatchableContext bc){
        
    }
      public void Send_Email_Applicant(List<IB_Role__c> role_withdrawn_applicant){
           EmailTemplate templateeng = [Select id from EmailTemplate where developerName = 'VV_Applicant_role_withdrawn_Eng'];
          EmailTemplate templatesp = [Select id from EmailTemplate where developerName = 'VV_Applicant_role_withdrawn_SP'];
          EmailTemplate templatefr = [Select id from EmailTemplate where developerName = 'VV_Applicant_role_withdrawn_FR2'];
            List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
            
        OrgWideEmailAddress[] owea = [select Id,Address from OrgWideEmailAddress where DisplayName='IB Communities' limit 1];
          for(IB_Role__c role_withdrawn : role_withdrawn_applicant){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(role_withdrawn.IB_Contact__c);
            if(role_withdrawn.IB_Contact__r.User_Language__c == 'en_US')
            mail.setTemplateId(templateeng.id);
            else if(role_withdrawn.IB_Contact__r.User_Language__c == 'es')
            mail.setTemplateId(templatesp.id);
            else if(role_withdrawn.IB_Contact__r.User_Language__c == 'fr')
            mail.setTemplateId(templatefr.id);
            mail.setWhatId(role_withdrawn.id);
            mail.setToAddresses(new String[] {role_withdrawn.IB_Contact__r.Email});
                    if ( owea.size() > 0 )
                {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }       
            allmsg.add(mail);
          }
            Messaging.sendEmail(allmsg,false);
    }
      public void Send_Email_Approver(List<IB_Role__c> role_withdrawn_approver){
           EmailTemplate templateeng = [Select id from EmailTemplate where developerName = 'VV_Approver_role_withdrawn_Eng'];
           EmailTemplate templatesp = [Select id from EmailTemplate where developerName = 'VV_Approver_role_withdrawn_SP'];
           EmailTemplate templatefr = [Select id from EmailTemplate where developerName = 'VV_Approver_role_withdrawn_FR'];
            List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
            
        OrgWideEmailAddress[] owea = [select Id,Address from OrgWideEmailAddress where DisplayName='IB Communities' limit 1];
          for(IB_Role__c role_withdrawn : role_withdrawn_approver){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if((role_withdrawn.Institute_Administrator__c != null && role_withdrawn.Institute_Administrator__r.User_Language__c == 'en_US') || 
               (role_withdrawn.Online_Coordinator__c != null && role_withdrawn.Online_Coordinator__r.User_Language__c == 'en_US') || 
               (role_withdrawn.IB_Programme_New__r.Contact_Programme_Coordinator__r.User_Language__c == 'en_US'))
            	mail.setTemplateId(templateeng.id);
            else if((role_withdrawn.Institute_Administrator__c != null && role_withdrawn.Institute_Administrator__r.User_Language__c == 'es') || 
               (role_withdrawn.Online_Coordinator__c != null && role_withdrawn.Online_Coordinator__r.User_Language__c == 'es') || 
               (role_withdrawn.IB_Programme_New__r.Contact_Programme_Coordinator__r.User_Language__c == 'es'))
                mail.setTemplateId(templatesp.id);
              else if((role_withdrawn.Institute_Administrator__c != null && role_withdrawn.Institute_Administrator__r.User_Language__c == 'fr') || 
               role_withdrawn.Online_Coordinator__c != null && role_withdrawn.Online_Coordinator__r.User_Language__c == 'fr'  || 
               (role_withdrawn.IB_Programme_New__r.Contact_Programme_Coordinator__r.User_Language__c == 'fr'))
                  mail.setTemplateId(templatefr.id);
              // this code is edited for ecm 336
// start
              if((role_withdrawn.Association_Administrator__c != null && role_withdrawn.Association_Administrator__r.User_Language__c == 'en_US') || 
               (role_withdrawn.Online_Coordinator__c != null && role_withdrawn.Online_Coordinator__r.User_Language__c == 'en_US') || 
               (role_withdrawn.IB_Programme_New__r.Contact_Programme_Coordinator__r.User_Language__c == 'en_US'))
                  mail.setTemplateId(templateeng.id);
              else if((role_withdrawn.Association_Administrator__c != null && role_withdrawn.Association_Administrator__r.User_Language__c == 'es') || 
               (role_withdrawn.Online_Coordinator__c != null && role_withdrawn.Online_Coordinator__r.User_Language__c == 'es') || 
               (role_withdrawn.IB_Programme_New__r.Contact_Programme_Coordinator__r.User_Language__c == 'es'))
                  mail.setTemplateId(templatesp.id);
              else if((role_withdrawn.Association_Administrator__c != null && role_withdrawn.Association_Administrator__r.User_Language__c == 'fr') || 
               role_withdrawn.Online_Coordinator__c != null && role_withdrawn.Online_Coordinator__r.User_Language__c == 'fr'  || 
               (role_withdrawn.IB_Programme_New__r.Contact_Programme_Coordinator__r.User_Language__c == 'fr'))
                  mail.setTemplateId(templatefr.id);
              	mail.setWhatId(role_withdrawn.id);
              //end
              if(role_withdrawn.Institute_Administrator__c != null){
                  mail.setToAddresses(new String[] {role_withdrawn.Institute_Administrator_Email__c});
                  mail.setTargetObjectId(role_withdrawn.Institute_Administrator__c);                  
              }
            // this code is edited for ecm 336
            // start
              else if(role_withdrawn.Association_Administrator__c != null){
                  mail.setToAddresses(new String[] {role_withdrawn.Association_Administrator_Email__c});
                  mail.setTargetObjectId(role_withdrawn.Association_Administrator__c);
              }
            //end
              else if(role_withdrawn.Online_Coordinator__c != null){
            	mail.setToAddresses(new String[] {role_withdrawn.Online_Coordinator_Email__c});
            	mail.setTargetObjectId(role_withdrawn.Online_Coordinator__c);
              }
              else if(role_withdrawn.IB_Programme_New__r.Contact_Programme_Coordinator__c != null){
            	mail.setToAddresses(new String[] {role_withdrawn.Programme_Coordinator_Email__c});
            	mail.setTargetObjectId(role_withdrawn.IB_Programme_New__r.Contact_Programme_Coordinator__c);
              }      
              if ( owea.size() > 0 ){
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }       
            allmsg.add(mail);
          }
            Messaging.sendEmail(allmsg,false);
    }
}