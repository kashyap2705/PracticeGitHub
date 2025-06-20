public with sharing class RoleCtrl {
    public integer cnt{get;set;}
    public string userId = Userinfo.getUserId();
    User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
        
    private List<IB_Role_Repository__c> rolesMaster = IBRoleRepositoryDAO.INSTANCE.getAvailableRoles();
    public List<IB_Role_Repository__c> roles_Available = new List<IB_Role_Repository__c>();
    public List<IB_Role_Repository__c> roles_Confirmed = new List<IB_Role_Repository__c>();
    public List<IB_Role_Repository__c> roles_Applied = new List<IB_Role_Repository__c>();
    public List<IB_Role_Repository__c> roles_Declined = new List<IB_Role_Repository__c>();
    public List<IB_Role_Repository__c> roles_Withdrawn = new List<IB_Role_Repository__c>();
    
    private List<IB_Role__c> myRoles = [Select id, IB_Role_Name__c, Status__c, Programme_Selection__c, IB_Role__c From IB_Role__c where IB_Contact__c = :user.ContactId];
    
    public List<Role_Application_Subject__c> myRoleSubjects = new List<Role_Application_Subject__c>();
    
    public Map<String, IB_Role__c> myConfirmedRolesMap = new Map<String, IB_Role__c>();
    public Map<String,List<String>> myConfirmedRolesSubjectsMap = new Map<String,List<String>>();
    public Map<String,List<String>> myProgrammeSubjectsMap = new Map<String,List<String>>();
    
    public Map<String,List<String>> getMyConfirmedRolesSubjectsMap(){
        return myConfirmedRolesSubjectsMap;
    }
    public Map<String,List<String>> getmyProgrammeSubjectsMap(){
        return myProgrammeSubjectsMap;
    }
    
    public Map<String, IB_Role__c> myAppliedRolesMap = new Map<string, IB_Role__c>();
    public Map<String, IB_Role__c> myDeclinedRolesMap = new Map<string, IB_Role__c>();
    public Map<String, IB_Role__c> myWithdrawnRolesMap = new Map<string, IB_Role__c>();
    
    List<IB_Role_Repository__c> initialSchoolServicesRoles = new List<IB_Role_Repository__c>();
    List<IB_Role_Repository__c> initialProfessionalDevRoles = new List<IB_Role_Repository__c>();
    
    public String EligibilityPdf;
    public String RolesPdf;
    public String StatusPdf;
    
    public map<string,IB_Role__c> roleMap{get;set;}
    public map<string,list<IB_Role__c>> roleConfirmedProgrammeMap{get;set;}
    public map<string,list<IB_Role__c>> roleAppliedProgrammeMap{get;set;}
    
    public String getStatusPdf(){
        if (UserInfo.getLanguage() == 'fr'){
            system.debug(loggingLevel.ERROR,'STATUS:' + DocumentDAO.INSTANCE.getDocumentPathByName('Application Statuses French'));
        	return DocumentDAO.INSTANCE.getDocumentPathByName('Application Statuses French');
        } else if (UserInfo.getLanguage() == 'es'){
            system.debug(loggingLevel.ERROR,'STATUS:' + DocumentDAO.INSTANCE.getDocumentPathByName('Application Statuses Spanish'));
        	return DocumentDAO.INSTANCE.getDocumentPathByName('Application Statuses Spanish');
        } else {
            system.debug(loggingLevel.ERROR,'STATUS:' + DocumentDAO.INSTANCE.getDocumentPathByName('Application Statuses English'));
        	return DocumentDAO.INSTANCE.getDocumentPathByName('Application Statuses English');
        }
    }
    
    public String getEligibilityPdf(){
        if (UserInfo.getLanguage() == 'fr'){
            system.debug(loggingLevel.ERROR,'ELIGIBILITY:' + DocumentDAO.INSTANCE.getDocumentPathByName('Assignment Statuses French'));
            return DocumentDAO.INSTANCE.getDocumentPathByName('Eligibility F');
        } else if (UserInfo.getLanguage() == 'es'){
            system.debug(loggingLevel.ERROR,'ELIGIBILITY:' + DocumentDAO.INSTANCE.getDocumentPathByName('Assignment Statuses Spanish'));
            return DocumentDAO.INSTANCE.getDocumentPathByName('Eligibility S');
        } else {
            system.debug(loggingLevel.ERROR,'ELIGIBILITY:' + DocumentDAO.INSTANCE.getDocumentPathByName('Assignment Statuses English'));
            return DocumentDAO.INSTANCE.getDocumentPathByName('Eligibility');
        }
     }
     
    public String getRolesPdf(){
        if (UserInfo.getLanguage() == 'fr'){
            system.debug(loggingLevel.ERROR,'ROLES:' + DocumentDAO.INSTANCE.getDocumentPathByName('Roles French'));
        	return DocumentDAO.INSTANCE.getDocumentPathByName('Roles French');
        } else if (UserInfo.getLanguage() == 'es'){
            system.debug(loggingLevel.ERROR,'ROLES:' + DocumentDAO.INSTANCE.getDocumentPathByName('Roles Spanish'));
        	return DocumentDAO.INSTANCE.getDocumentPathByName('Roles Spanish');
        } else {
            system.debug(loggingLevel.ERROR,'ROLES:' + DocumentDAO.INSTANCE.getDocumentPathByName('Roles English'));
        	return DocumentDAO.INSTANCE.getDocumentPathByName('Roles English');
        }
    }
     
    
    public Boolean isAdvancedSchoolServices;
    public Boolean isAdvancedProfessionalDev;
    public List<String> subjectsForRole;
    
    public Boolean getIsAdvancedSchoolServices(){
        Integer count = 0;
        for(Integer c = 0; c < initialSchoolServicesRoles.size(); c++){
            if(myConfirmedRolesMap.containsKey(initialSchoolServicesRoles[c].Role_Name__c)){
                count++;
            }
        }
        if(count > 0){
            return true;
        }
        else{
            return false;
        }
    }
    
    public Boolean getIsAdvancedProfessionalDev(){
        Integer count = 0;
        system.debug('****Size of required roles = ' + initialProfessionalDevRoles.size());

        for(Integer c = 0; c < initialProfessionalDevRoles.size(); c++){
            if(myConfirmedRolesMap.containsKey(initialProfessionalDevRoles[c].Role_Name__c)){
                count++;
            }
        }
        system.debug('****Size of confirmed roles = ' + count);
        if(count > 0){
            return true;
        }
        else{
            return false;
        }
    }
    
    public List<IB_Role_Repository__c> getRoles_Available(){
        return roles_Available;
    }
    
    public List<IB_Role_Repository__c> getRoles_Confirmed(){
        return roles_Confirmed;
    }
    
    public List<IB_Role_Repository__c> getRoles_Applied(){
        return roles_Applied;
    }
    
    public List<IB_Role_Repository__c> getRoles_Declined(){
        return roles_Declined;
    }
    
    public List<IB_Role_Repository__c> getRoles_Withdrawn(){
        return roles_Withdrawn;
    }

    public String getRegion(){
        List<Contact> myContact = [Select IB_Region__c From Contact c Where Id = :user.ContactId LIMIT 1];
        return myContact[0].IB_Region__c;
    }    
    
    
    public RoleCtrl(){ 
        cnt = 0;
        List<ID> myRoleIds = new List<Id>();     
        for(IB_Role__c role : myRoles){
            if(role.Status__c == 'Applicant'){
                myAppliedRolesMap.put(role.IB_Role_Name__c, role);
            }
            if(role.Status__c == 'Declined'){
                myDeclinedRolesMap.put(role.IB_Role_Name__c, role);
            }
            if(role.Status__c == 'Confirmed'){
                myConfirmedRolesMap.put(role.IB_Role_Name__c, role);
                myRoleIds.add(role.Id);
            }
            if(role.Status__c =='Withdrawn'){
                myWithdrawnRolesMap.put(role.IB_Role_Name__c, role);
            }
        }
        system.debug('#### myAppliedRolesMap : '+myAppliedRolesMap.keyset());

        myRoleSubjects = [Select IB_Subject__r.Subject_Name__c, IB_Subject__r.Subject_Name_FR__c,IB_Subject__r.Subject_Name_SP__c,Role_And_Application__c, Role_And_Application__r.IB_Role_Name__c FROM Role_Application_Subject__c WHERE Role_And_Application__c in :myRoleIds ];
        //myConfirmedRolesSubjectsMap
        system.debug('#### myRoleIds : '+myRoleIds);
        system.debug('#### myConfirmedRolesMap: ' + myConfirmedRolesMap);
        system.debug('#### myConfirmedRolesMap : '+myConfirmedRolesMap.size());
        for(String s : myConfirmedRolesMap.keySet()){
            List<String> mySet = new List<String>();
            Set<String> dupeCheck = new Set<String>();

            for(Role_Application_Subject__c r : myRoleSubjects){
                if(s == r.Role_And_Application__r.IB_Role_Name__c){    
                    if(!dupeCheck.contains(r.IB_Subject__r.Subject_Name__c)){
                        dupeCheck.add(r.IB_Subject__r.Subject_Name__c);
                        if(UserInfo.getLanguage() == 'fr'){
                            mySet.add(r.IB_Subject__r.Subject_Name_FR__c);
                        } else if (UserInfo.getLanguage() == 'es') {
                            mySet.add(r.IB_Subject__r.Subject_Name_SP__c);
                        } else {
                            mySet.add(r.IB_Subject__r.Subject_Name__c);
                        }
                    }
                }
            }
            myConfirmedRolesSubjectsMap.put(s,mySet);
        }

        for(Role_Application_Subject__c r : myRoleSubjects){
            list<string> mySet = myProgrammeSubjectsMap.get(r.Role_And_Application__c);
            if(mySet == null){
                mySet = new list<string>();
            }
            if(UserInfo.getLanguage() == 'fr'){
                mySet.add(r.IB_Subject__r.Subject_Name_FR__c);
            } else if (UserInfo.getLanguage() == 'es') {
                mySet.add(r.IB_Subject__r.Subject_Name_SP__c);
            } else {
                mySet.add(r.IB_Subject__r.Subject_Name__c);
            }
            myProgrammeSubjectsMap.put(r.Role_And_Application__c,mySet);
        }

        roleMap = new map<string,IB_Role__c>();
        roleConfirmedProgrammeMap = new map<string,list<IB_Role__c>>();
        roleAppliedProgrammeMap = new map<string,list<IB_Role__c>>();
        
        for(Integer a = 0; a < rolesMaster.size(); a++){
            system.debug('#### rolesMaster[a].Role_Name__c : '+rolesMaster[a].Role_Name__c);
            if(myConfirmedRolesMap.containsKey(rolesMaster[a].Role_Name__c)){
                roles_Confirmed.add(rolesMaster[a]);
                roleMap.put(rolesMaster[a].Id,myConfirmedRolesMap.get(rolesMaster[a].Role_Name__c));
            }
            if(myAppliedRolesMap.containsKey(rolesMaster[a].Role_Name__c)){
                roles_Applied.add(rolesMaster[a]);
            }
            if(myDeclinedRolesMap.containsKey(rolesMaster[a].Role_Name__c)){
                roles_Declined.add(rolesMaster[a]);
            }
            if(myWithdrawnRolesMap.containsKey(rolesMaster[a].Role_Name__c)){
                roles_Withdrawn.add(rolesMaster[a]);
            }
            
            if(!myConfirmedRolesMap.containsKey(rolesMaster[a].Role_Name__c) && !myAppliedRolesMap.containsKey(rolesMaster[a].Role_Name__c) && !myDeclinedRolesMap.containsKey(rolesMaster[a].Role_Name__c) && !myWithdrawnRolesMap.containsKey(rolesMaster[a].Role_Name__c)){
                roles_Available.add(rolesMaster[a]);
            }
            
            if(rolesMaster[a].Category__c == 'School Services' && rolesMaster[a].Training_Model__c != 'Advanced Training'){
                initialSchoolServicesRoles.add(rolesMaster[a]);
            }
            if(rolesMaster[a].Category__c == 'Professional Development' && rolesMaster[a].Training_Model__c != 'Advanced Training'){
                initialProfessionalDevRoles.add(rolesMaster[a]);
            }
        }
        
        for(IB_Role__c prog : myRoles){ //this line is updated by developer Abd Ur Rehman-Plumlogix as part of cr- us11727 on 21-2-2020
            //change the role name from "Global PD Contractor" to "Professional Services Contractor"
            //begin            
            if(prog.IB_Role_Name__c == 'Workshop Leader' || prog.IB_Role_Name__c == 'Programme Field Representative' || prog.IB_Role_Name__c == 'Professional Services Contractor' || prog.IB_Role_Name__c == 'Session Observer'){
             //end
			 if(prog.Status__c == 'Confirmed'){
                    list<IB_Role__c> temp = roleConfirmedProgrammeMap.get(prog.IB_Role__c);
                    if(temp == null){
                        temp = new list<IB_Role__c>();
                    }
                    temp.add(prog);
                    roleConfirmedProgrammeMap.put(prog.IB_Role__c,temp);
                }else if(prog.Status__c == 'Applicant'){
                    list<IB_Role__c> temp = roleAppliedProgrammeMap.get(prog.IB_Role__c);
                    if(temp == null){
                        temp = new list<IB_Role__c>();
                    }
                    temp.add(prog);
                    roleAppliedProgrammeMap.put(prog.IB_Role__c,temp);
                }
            }
            if(!myProgrammeSubjectsMap.containsKey(prog.Id)){
                myProgrammeSubjectsMap.put(prog.Id, new list<string>());
            }
        }
        system.debug('####'+myProgrammeSubjectsMap.keyset());
        system.debug('#### roles_Confirmed : '+roles_Confirmed);
        system.debug('#### roles_Applied : '+roles_Applied);
        system.debug('#### roleConfirmedProgrammeMap : '+roleConfirmedProgrammeMap);
        system.debug('#### roleAppliedProgrammeMap : '+roleAppliedProgrammeMap);
    }   




}