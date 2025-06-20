global class contactCommentBatchClass implements Database.Batchable<sObject> {
    public List<string> role_name_approver_programme_req = new List<string>{'Online Coordinator','Programme Coordinator'};
        public List<string> role_name_approver_account_req = new List<string>{'Institute Administrator'};
            public Set<Id> accountids = new set<Id>();
    public Set<Id> programmeids = new set<Id>();
    public List<string> role_name_list_op = new List<string>{'Teacher'};
        public List<string> role_name_list_inst = new List<string>{'Institute Transcript User','Communication User','Institute Policy User','Institute Curriculum User'};
            public List<string> role_name_list_school = new List<string>{'Teacher','Head of Section','ATL Coordinator','Head of Faculty','Librarian','University and Career Counselor','General and Academic Counselor','ICT Coordinator','Programme Associate','Personal Project Coordinator','Community Project Coordinator','CAS Coordinator','Reflective Project Lead Supervisor','Service Learning Coordinator','Personal and Professional Skills Coordinator','Deputy/Assistant Head','Group of Schools Affiliate'};
                
                
                global Database.QueryLocator start(Database.BatchableContext bc) {
                    string query = 'Select id,IB_Contact__c,Type__c,Programme_Coordinator_Email__c,IB_Programme_New__r.Contact_Programme_Coordinator__c,IB_Programme_New__r.Contact_Programme_Coordinator__r.User_Language__c,Programme_Coordinator_Name__c,Institute_Administrator__r.User_Language__c,Online_Coordinator__r.User_Language__c,Online_Coordinator__c,Institute_Administrator__c,Institute_Administrator__r.Email,Online_Coordinator__r.Name,Online_Coordinator__r.Email,Role_Withdrawn_after_90_days__c,Account_Id_Formula__c,Approver_Role_Name__c,CreatedDate,IB_Account__r.id,status__c,Email_Confirmed__c,Account_ID__c,AccountProgrammeCombo__c,IB_Role_Name__c,IB_Contact__r.User_Language__c ,IB_Contact__r.Name,IB_Programme_New__r.id,IB_Programme_New__c,IB_Contact__r.Email from IB_Role__c where Role_Type__c != \'IBEN Role\' AND Status__c = \'Applicant\' AND  (IB_Role_Name__c IN :role_name_list_inst OR (IB_Role_Name__c IN :role_name_list_op AND Type__c = \'Online Provider\') OR IB_Role_Name__c IN :role_name_list_school) ';
                    return Database.getQueryLocator(query);
                }
    global void execute(Database.BatchableContext bc , list<IB_Role__c> query)
    {
         String days = Label.Role_withdrawn_days;
        Integer days_integer = (-6)-integer.valueOf(days);
        DateTime dueDate = Date.today().addDays(days_integer);
        DateTime dueEndDate = Date.today().addDays(-186);
        System.debug('DateTime: dueDate: '+dueDate);
        System.debug('DateTime: dueEndDate: '+dueEndDate);
        List <IB_Role__c> Role_List = new List<IB_Role__c>();
        List <IB_Role__c> Role_List_update = new List<IB_Role__c>();
        EmailTemplate templateeng = [Select id from EmailTemplate where developerName = 'VV_Applicant_role_withdrawn_Eng'];
        EmailTemplate templatesp = [Select id from EmailTemplate where developerName = 'VV_Applicant_role_withdrawn_SP'];
        EmailTemplate templatefr = [Select id from EmailTemplate where developerName = 'VV_Applicant_role_withdrawn_FR2'];
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        
        OrgWideEmailAddress[] owea = [select Id,Address from OrgWideEmailAddress where DisplayName='IB Communities' limit 1];
        
        for(IB_Role__c role_record: query){
            DateTime creadteddate = role_record.CreatedDate;
            //String str = creadteddate.format('MM/dd/YYYY');
            if(creadteddate <= dueDate || Test.isRunningTest()){
                //role_record.Status__c='Withdrawn';
                
                if(role_record.Status__c!= IboUtil.ROLE_APPLICANT_STATUS && role_record.Status__c!=IboUtil.ROLE_INVITED_STATUS){
                    role_record.Status__c = IboUtil.ROLE_WITHDRAWN_STATUS;
                    }
                    else{
                        role_record.Status__c = IboUtil.ROLE_DECLINED_STATUS;  
                    }
                    
                role_record.Role_Withdrawn_after_90_days__c = true;
                
                try{
                    System.debug('role_record: '+role_record);
                    update role_record;
                }
                catch (Exception ex)
                {
                    System.debug('Exception: '+ex);
                }
                System.debug('role_record '+role_record );
                System.debug('creadteddate '+creadteddate);
                System.debug('dueDate '+dueDate);
                if(creadteddate >= dueEndDate){
                    system.debug('createddate'+creadteddate);
                    System.debug('dueEndDate '+dueEndDate);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTargetObjectId(role_record.IB_Contact__c);
                    if(role_record.IB_Contact__r.User_Language__c == 'en_US')
                        mail.setTemplateId(templateeng.id);
                    else if(role_record.IB_Contact__r.User_Language__c == 'es')
                        mail.setTemplateId(templatesp.id);
                    else if(role_record.IB_Contact__r.User_Language__c == 'fr')
                        mail.setTemplateId(templatefr.id);
                    mail.setWhatId(role_record.id);
                    mail.setToAddresses(new String[] {role_record.IB_Contact__r.Email});
                    if ( owea.size() > 0 )
                    {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    allmsg.add(mail);
                }
                
            }
            
        }
        
        Messaging.sendEmail(allmsg,false);
        
        
    }
    global void finish(Database.BatchableContext bc)
    {}
    
}