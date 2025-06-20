global class WeeklyEmailBatch implements Database.Batchable<sObject>{
    public boolean check = false;
    public string region;
    public Set<String> roleProgrammeCombo = new Set<String>();
    public static Integer count_cp ,count_dp , count_myp , count_pyp, cor_count_cp, cor_count_dp,cor_count_myp, cor_count_pyp,sum=0 ;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
         
         
    string query = 'select id from contact' ;
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc,List <contact> contactIDs) {
     
     ID mailid;
       set <id> cons = new set <id>();
       Map<ID,String> userregion = new Map<ID,String>();
       Map<ID,String> name = new Map<ID,String>();
       List<String> roleids = new List<String>();
        
         //ibroles courseoutline and reader
         List <IB_Role__c> ibroles = [select id,name,IB_Contact__r.id,IB_Role__c,IB_Contact__r.name,IB_Contact__r.IB_Region__c,IB_Role_Programme_Combo__c from IB_Role__c 
                                   where ( IB_Role_Name__c = 'Reader' OR IB_Role_Name__c = 'Course Outline Reader' )
                                   AND Status__c = 'Confirmed' AND (IB_Contact__c in :contactIDs) ];
        
      //getting the template
        EmailTemplate et=[Select id from EmailTemplate where Name=:'Weekly Report']; 
        
        //getting contact,Programme and Role data from Roles & Application
         for(IB_Role__c r : ibroles) {
             cons.add(r.IB_Contact__c);
             userregion.put(r.IB_Contact__c,r.IB_Contact__r.IB_Region__c);
             name.put(r.IB_Contact__c,r.IB_Contact__r.name);
             roleids.add(r.IB_Role__c);
         }
      
        //for Each Role check eligible assigment and send weekly email
         for(ID myID : cons) {
            region = userregion.get(myID);
            roleProgrammeCombo.clear();
            roleProgrammeCombo = get_roleProgrammeCombo(ibroles,myID);
             List<Staffing_Event__c> assignments = get_count(roleProgrammeCombo,myID,region,roleids);
              set_count_by_prog(assignments);
               if(sum >0 || test.isRunningtest()) {
                   System.debug('Name '+name.get(myID)+ ' '+sum);
                   //Sending Email object
                   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                 
                       OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.iben@ibo.org'];
                if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                   mail.setTargetObjectId(myID);
                   
                   mail.setWhatId(myID);    
                   mail.setUseSignature(false); 
                   mail.setBccSender(false); 
                   mail.setSaveAsActivity(false); 
                   mail.setTemplateId(et.id); 
                   mail.setUseSignature(false);
                   try {
                   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                       }
                   catch(Exception ex){
                       System.debug('Error: '+ex);
                   }
             }
         }
    }
    
    
    
    global void finish(Database.BatchableContext bc){
        
    }
    
    
    public static void set() {
    count_cp=0;
    count_dp=0;
    count_myp=0;
    count_pyp=0;
    sum=0;
    cor_count_dp=0;
    cor_count_pyp=0;
    cor_count_myp=0;
    cor_count_cp=0;
}
    public void set_count_by_prog(List<Staffing_Event__c> assignments) {
        String prog;
        set();
        for(Staffing_Event__c staffingevent : assignments) {
            if(staffingevent.Related_Programme_Name__c != null && staffingevent.Staffing_Event_Type__c != null) {
            prog = staffingevent.Related_Programme_Name__c; 
                if(staffingevent.Staffing_Event_Type__c == 'Request for authorization' || staffingevent.Staffing_Event_Type__c == 'Request for Candidacy'){
                    IF(prog.contains('CP') )
                       count_cp++;
                    IF(prog.contains('DP'))
                       count_dp++; 
                    IF(prog.contains('MYP') ) 
                        count_myp++;
                    IF(prog.contains('PYP')) 
                        count_pyp++;
                }
            else if (staffingevent.Staffing_Event_Type__c == 'Course Outline Reading') {
                    IF(prog.contains('CP')) 
                       cor_count_cp++;
                    IF(prog.contains('DP')) 
                        cor_count_dp++;
                    IF(prog.contains('MYP')) 
                        cor_count_myp++;
                    IF(prog.contains('PYP')) 
                        cor_count_pyp++;
            }
        }
      }
            sum = count_cp+count_dp+count_myp+count_pyp+cor_count_cp+cor_count_dp+cor_count_myp+cor_count_pyp;
             set_controller_count();
       
    }
    public void set_controller_count() {
        WeeklyEmailComponentController.count_cp = count_cp;
        WeeklyEmailComponentController.count_dp = count_dp;
        WeeklyEmailComponentController.count_myp = count_myp;
        WeeklyEmailComponentController.count_pyp = count_pyp;
        WeeklyEmailComponentController.cor_count_cp = cor_count_cp;
        WeeklyEmailComponentController.cor_count_dp = cor_count_dp;
        WeeklyEmailComponentController.cor_count_myp = cor_count_myp;
        WeeklyEmailComponentController.cor_count_pyp = cor_count_pyp;
    }
    public List<Staffing_Event__c> get_count(Set<String> role_prog_combo,ID contactid,String region,List<String> roleids){
       
        List<Staffing_Event__c> staffingevent = [SELECT Id,Related_Programme_Name__c,Staffing_Event_Type__c,
                           (Select IB_Role_Name__c, IB_Role__c, Positions_Left__c from IB_Event_Roles__r where Positions_Left__c > 0)
                            FROM Staffing_Event__c  WHERE Staffing_Event_Status__c NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Complete', 'Confirmed')
                                And Staffing_Event_Region__c = :region                 
                                And Start_Date__c != null and End_Date__c != null
                                And End_Date__c >= TODAY
                                And Id IN
                                    (Select Staffing_Event__c 
                                     From IB_Event_Role__c
                                     Where  IB_Role__c IN :roleids
                                         AND IB_Role_Programme_Combo__c IN :role_prog_combo 
                                         AND  Positions_Left__c > 0 
                                     )
                                And Id NOT IN
                                    (Select Staffing_Event__c
                                     From My_Staffing_Event__c
                                     Where IB_Contact__c = :contactid )];  
            return staffingevent;
    }
     public Set<String> get_roleProgrammeCombo(List<IB_Role__c> contacts,id contid) {
                 Set<String> role_prog_combo = new Set<String>();
          for(IB_Role__c r : contacts) {
              if(r.IB_Contact__c == contid)
                  role_prog_combo.add(r.IB_Role_Programme_Combo__c);
          }
         return role_prog_combo;
    }
    
    
    
    
    
    
    }