/*-
* This class is -----
* Modified line by 401,455,480 by Vikranth for EMS Project D29-08-2023
*/
public class userHeaderController {
    public Integer intEligibleAssignment {get;set;}
    public Integer intEligibleTraining {get;set;}
    Private User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
    Private Contact contactObject = MyContactDAO.INSTANCE.getContactbyId(user.ContactId);   
    private List<IB_Role__c> myConfirmedRoles;
    private Set<String> roleProgrammeCombo;
    @testvisible private set<String> myLanguages;
    private List<IB_Role__c> myAppliedForRoles;
    private List<String> myConfirmedSubjects;
    private String userRegion;
    private String userCountry;
    private List<String> roleIds;
    private List<String> roleIdsTraining;
    private List<Id> lstViewedAssignments;
    private Map<Id,List<Id>> eligibleWorkshopTitles;
    public List<Role_Application_Subject__c> rasSubjects {get;set;}
    private List<String> searchRoleIds;
    public List<IB_Workshop_Titles__c> ibWorkshopTitles {get;set;}
    public List<IB_Workshop_Titles__c> ibWorkshopTitles2 {get;set;}
    // This Part is being added by Suraj Parihar on 28-Dec-2022 for ECM00572
    public  boolean checkMCSOrOPERole{get; set;} // Check Marking claim summary and Out of pocket expense role
    public boolean checkGlobalModeratorRole {get;set;} //ECM00801- Urgent Requirement - Generation Global Moderator by Kashyap

    public static String coi;
    public static String Ulan;
    public static String language;
    public static String HelpAndResource;
    public static String Assignment;
    public static String Dashboard;
    public userHeaderController(){
        
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        
        
        myConfirmedRoles = new List<IB_Role__c>();
        roleProgrammeCombo = new Set<String>();
        myLanguages = new set<String>();
        myAppliedForRoles = new List<IB_Role__c>();
        myConfirmedSubjects = new List<String>();
        lstViewedAssignments = new List<Id>();
        roleIds = new List<String>();
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        intEligibleAssignment = intEligibleTraining = 0;
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        userRegion = getUserRegion();
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        userCountry = getUserCountry();
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );        
        for(Viewed_IBEN_Assignment__c recView : [Select Community_User__c, IBEN_Assignment__c FROM Viewed_IBEN_Assignment__c WHERE Community_User__c =: user.Id])
            lstViewedAssignments.add(recView.IBEN_Assignment__c);
        System.debug('lstViewedAssignments() :'+lstViewedAssignments.size());
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        myConfirmedRoles = IBActivity.loadMyIBRoles(null, 'Confirmed');
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
  
        //Following Line is added by plumlogix For ECM 477
        //Start
        for(IB_Role__c r:myConfirmedRoles){
            if(r.Upskilled_in_PSP__c=='2014 - 2020'){
                roleProgrammeCombo.add(r.IB_Role_Programme_Combo__c+'|2014');
                roleProgrammeCombo.add(r.IB_Role_Programme_Combo__c+'|2020');
            }
            else if(r.Upskilled_in_PSP__c==''|| r.Upskilled_in_PSP__c==null){
                roleProgrammeCombo.add(r.IB_Role_Programme_Combo__c+'|');
            }
            else{
                roleProgrammeCombo.add(r.Role_Programme_Psp_Combo__c);
            }
        }
        //End
        
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        myAppliedForRoles = IBActivity.loadMyIBRoles(null,'Applicant');
        
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        myLanguages = IBActivity.loadMyLanguages();
        
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        roleIds = IBActivity.getRoleIds(myConfirmedRoles);
        
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        roleIdsTraining = IBActivity.getRoleIds(myAppliedForRoles);
        
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        System.debug('Before eligibleAssignments call ');
        eligibleAssignments();
        
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        System.debug('Before eligTrainings call');
        eligTrainings();
        // reset the local variables for heap size - Mariappan
        myConfirmedRoles = new List<IB_Role__c>();
        roleProgrammeCombo = new Set<String>();
        myLanguages = new set<String>();
        myAppliedForRoles = new List<IB_Role__c>();
        myConfirmedSubjects = new List<String>();
        lstViewedAssignments = new List<Id>();
        roleIds = new List<String>();
        roleIdsTraining = new List<String>();
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        //This Part is being added by Suraj Parihar on 28-Dec-2022 for ECM00572

        List<IB_Role__c> rolesAssignedToUser = new List<IB_Role__c>();
        Set<String> roleAssignedSet = new Set<String>();

        List<User> loggedInUser = [SELECT Id, ContactId FROM User WHERE Id =: UserInfo.getUserId()];
        if(!loggedInUser.isEmpty() && loggedInUser[0].ContactId != null){
            rolesAssignedToUser =[SELECT Id, IB_Role_Name__c  FROM IB_Role__c 
                                  WHERE IB_Contact__c = :loggedInUser[0].ContactId 
                                  AND Active__c = true 
                                  AND Status__c='Confirmed'];

            for(IB_Role__c role : rolesAssignedToUser ){
                roleAssignedSet.add(role.IB_Role_Name__c); 
    }
        }
        checkMCSOrOPERole = false;
        Set<String>  roleASet = String.isNotBlank(Label.IBEN_Assigned_Role_A)?splitStringForRoles(Label.IBEN_Assigned_Role_A) :  new Set<String>();
        Set<String>  roleBSet = String.isNotBlank(Label.IBEN_Assigned_Role_B)?splitStringForRoles(Label.IBEN_Assigned_Role_B) :  new Set<String>();
    
        if(!roleAssignedSet.isEmpty()){
            for(String roleAssigned : roleAssignedSet){
                if(roleASet.contains(roleAssigned) || roleBSet.contains(roleAssigned)){
                    checkMCSOrOPERole=true;
                }
            }
        }
        
        /**ECM00801- Urgent Requirement - Generation Global Moderator by Kashyap**/
        checkGlobalModeratorRole= false;
        if(roleAssignedSet.contains('Generation Global Moderator') && roleAssignedSet.size()==1){
            checkGlobalModeratorRole= true;
        }
        /**ECM00801- Urgent Requirement - Generation Global Moderator by Kashyap**/

    }
    //END
    
    public String getcoi() {
        //Ulan = [Select LanguageLocaleKey from User Where Id = :UserInfo.getUserId() LIMIT 1].LanguageLocaleKey;
        if(UserInfo.getLanguage() == 'en_US'){
            language = 'American English';  
        }
        if(UserInfo.getLanguage() == 'es'){
            language = 'Spanish';  
        }
        if(UserInfo.getLanguage() == 'fr'){
            language = 'French';  
        }
        List<Translation__c> lstTranslations = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'COI' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+lstTranslations);
        if(!lstTranslations.isEmpty()){
            coi = (String)lstTranslations[0].Value__c;
        }
        return coi;
    }
    
        
    
    //This Part is being added by Suraj Parihar on 28-Dec-2022 for ECM00572
    public Set<String> splitStringForRoles (String customLabelRoles){
        List<String> rolesNames = customLabelRoles.split(',');
        Set<String> roleSet = new Set<String>();
        roleSet.addAll(rolesNames);
        return roleSet;
    }
    
    //END
    
    public String getHelpAndResource() {
        Ulan = [Select LanguageLocaleKey from User Where Id = :UserInfo.getUserId() LIMIT 1].LanguageLocaleKey;
        if(Ulan == 'en_US'){
            language = 'American English';  
        }
        if(Ulan == 'es'){
            language = 'Spanish';  
        }
        if(Ulan == 'fr'){
            language = 'French';  
        }
        List<Translation__c> HelpAndResources = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'HelpAndResources' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+HelpAndResources);
        if(!HelpAndResources.isEmpty()){
            HelpAndResource = (String)HelpAndResources[0].Value__c;
        }
        return HelpAndResource;
    }	
    
    public String getAssignment() {
        //Ulan = [Select LanguageLocaleKey from User Where Id = :UserInfo.getUserId() LIMIT 1].LanguageLocaleKey;
        if(UserInfo.getLanguage() == 'en_US'){
            language = 'American English';  
        }
        if(UserInfo.getLanguage() == 'es'){
            language = 'Spanish';  
        }
        if(UserInfo.getLanguage() == 'fr'){
            language = 'French';  
        }
        List<Translation__c> Assignments = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'Assignments' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+Assignments);
        if(!Assignments.isEmpty()){
            Assignment = (String)Assignments[0].Value__c;
        }
        return Assignment;
    }	
    
    
    public String getDashboard() {
        //Ulan = [Select LanguageLocaleKey from User Where Id = :UserInfo.getUserId() LIMIT 1].LanguageLocaleKey;
        if(UserInfo.getLanguage() == 'en_US'){
            language = 'American English';  
        }
        if(UserInfo.getLanguage() == 'es'){
            language = 'Spanish';  
        }
        if(UserInfo.getLanguage() == 'fr'){
            language = 'French';  
        }
        List<Translation__c> Dashboards = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'Dashboard' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+Dashboards);
        if(!Dashboards.isEmpty()){
            Dashboard = (String)Dashboards[0].Value__c;
        }
        return Dashboard;
    }	
    public String getPhoto(){
        /*List<Attachment> attach = AttachmentsDAO.INSTANCE.getAttachmentsbyParentId(contactObject.Id);
for(Attachment a: attach){
if(a.description == 'profile photo'){
return System.EncodingUtil.base64Encode(a.body);
}
}*/
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        System.debug('contactObject.Id :'+contactObject.Id );
        String k = AttachmentsDAO.getProfilePhoto(contactObject.Id);
        return k;
    }
    
    @testvisible private void eligibleAssignments(){

        Cookie eligAssignments = ApexPages.currentPage().getCookies().get('eligAssignments-'+ user.ContactId);
        // System.debug('Umair-header'+eligAssignments.getValue());
        
        Boolean reprocess = true;
        if(eligAssignments == null){
            reprocess = true;
        } else {
            if(Integer.valueOf(eligAssignments.getValue()) == 0){
                reprocess = true;
            }
        }
        
        
        List<Staffing_Event__c> assignment = new List<Staffing_Event__c>();
        if(reprocess == true) {
            
            Set<Staffing_Event__c> setAssignment = new Set<Staffing_Event__c>();
            List<Staffing_Event__c> assignments = new List<Staffing_Event__c>();
            List<Staffing_Event__c> confirmedassignments = new List<Staffing_Event__c>();
            if(myLanguages != null && !myLanguages.isEmpty()){
                System.debug('userRegion:'+userRegion);
                System.debug('roleIds:'+roleIds);
                System.debug('roleProgrammeCombo:'+roleProgrammeCombo);
                System.debug('myLanguages:'+myLanguages);
                System.debug('user.ContactId:'+user.ContactId);
                System.debug('lstViewedAssignments:'+lstViewedAssignments.size());
                System.debug('assignments size:'+assignments.size());
                System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
                assignments = [Select Id, IB_Event__r.Applicant_Eligibility_Location__c,Workshop_Product_Title__c, Start_Date__c, Staffing_Event_Region__c, Staffing_Event_Country__c, Staffing_Event_City__c, Programme_s__c, End_Date__c, Name, Subject__c, Staffing_Event_Type__c, Related_Subject__c,
                               (Select IB_Role_Name__c, IB_Workshop_Product_Title__c, IB_Role__c, IB_Programme__c, Positions_Left__c from IB_Event_Roles__r where Positions_Left__c > 0)
                               From Staffing_Event__c //IBEN Assignment
                               Where Staffing_Event_Status__c NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Completed', 'Confirmed') 
                               And Staffing_Event_Region__c = :userRegion
                               And Start_Date__c != null and End_Date__c != null
                               And (Start_Date__c >= TODAY OR (Staffing_Event_Type__c IN ('Candidacy Consultation', 'Request for authorization', 'Request for Candidacy', 'Course Outline Reading')))
                               And IB_Event__r.Bundle__c = false 
                               And Id IN
                               (Select Staffing_Event__c
                                From IB_Event_Role__c
                                Where IB_Role__c IN :roleIds
                                AND Positions_Left__c  > 0
                                And Role_Programme_Psp_Combo__c in :roleProgrammeCombo
                                AND Proposed_Language__c IN :myLanguages)
                               And Id NOT IN
                               (Select Staffing_Event__c
                                From My_Staffing_Event__c
                                Where IB_Contact__c =: user.ContactId)
                               AND Id NOT IN :lstViewedAssignments
                               Order by Start_Date__c, Name];
                System.debug('assignments size:'+assignments.size());
                System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
            }
            else{
                
                assignments = [Select Id, IB_Event__r.Applicant_Eligibility_Location__c,Workshop_Product_Title__c, Start_Date__c, Staffing_Event_Region__c, Staffing_Event_Country__c, Staffing_Event_City__c, Programme_s__c, End_Date__c, Name, Subject__c, Staffing_Event_Type__c, Related_Subject__c,
                               (Select IB_Role_Name__c, IB_Workshop_Product_Title__c, IB_Role__c, IB_Programme__c, Positions_Left__c from IB_Event_Roles__r where Positions_Left__c > 0)
                               From Staffing_Event__c //IBEN Assignment
                               Where Staffing_Event_Status__c NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Completed', 'Confirmed') 
                               And Staffing_Event_Region__c = :userRegion
                               And Start_Date__c != null and End_Date__c != null
                               And (Start_Date__c >= TODAY OR (Staffing_Event_Type__c IN ('Candidacy Consultation', 'Request for authorization', 'Request for Candidacy', 'Course Outline Reading')))
                               And IB_Event__r.Bundle__c = false 
                               And Id IN
                               (Select Staffing_Event__c
                                From IB_Event_Role__c
                                Where IB_Role__c IN :roleIds
                                AND Positions_Left__c  > 0
                                And Role_Programme_Psp_Combo__c in :roleProgrammeCombo)
                               And Id NOT IN
                               (Select Staffing_Event__c
                                From My_Staffing_Event__c
                                Where IB_Contact__c =: user.ContactId)
                               AND Id NOT IN : lstViewedAssignments
                               Order by Start_Date__c, Name];
            }
            
            
            
            //Following code line is added by Umair-Plumlogix of US11930 of Staff Augmentation on 06/03/2020
            //Begin
            System.debug('Before covid_workshops call');
            
            System.debug('assignments size:'+assignments.size());
            setAssignment.addAll(assignments);
            System.debug('setAssignment size:'+setAssignment.size());
            
            System.debug('assignments size:'+assignments.size());
            
            System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
            assignments = covid_workshops(setAssignment,userRegion,userCountry,roleProgrammeCombo,roleIds);
            System.debug('assignments size:'+assignments.size());
            
            //Commented the below 2 lines as that are not used - Mariappan 
            // setAssignment.addAll(assignments);
            // System.debug('setAssignment size:'+setAssignment.size());
            
            System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
            System.debug('After covid_workshops call');
            
            //End
            if(!assignments.isEmpty()){
                //assignments = IBActivity.refineEligibleAssignments(assignments);
                
                System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
                //assignments = IBActivity.filterAssignmentsByProgramme(assignments, myConfirmedRoles);
                //assignments = IBActivity.filterAssignmentsByProgrammeAndSubject(assignments, myConfirmedRoles);
                
				AggregateResult[] arList =  [SELECT count(id)
									FROM Staffing_Event__c //IBEN Assignment
									WHERE Staffing_Event_Status__c NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Complete', 'Confirmed') 
										And Staffing_Event_Region__c = :userRegion
										And Start_Date__c != null and End_Date__c != null
										And (Start_Date__c >= TODAY OR (Staffing_Event_Type__c IN ('Candidacy Consultation', 'Request for authorization', 'Request for Candidacy', 'Course Outline Reading')))
										And IB_Event__r.Bundle__c = false 
										And Id IN
											(Select Staffing_Event__c
											 From IB_Event_Role__c
											 Where IB_Role__c IN :roleIds
												 AND Role_Programme_Psp_Combo__c IN :roleProgrammeCombo
												 AND Positions_Left__c  > 0 // DEMEG: TESTING CPU TIMEOUT
												 AND (Proposed_Language__c = null OR Proposed_Language__c IN :myLanguages)
											 )
										And Id NOT IN
											(Select Staffing_Event__c
											 From My_Staffing_Event__c
											 Where IB_Contact__c = :user.ContactId)];
					intEligibleAssignment = Integer.valueOf(arList[0].get('expr0'));
					System.debug('Total inteligibleassignment: ' + intEligibleAssignment);
				
                System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
                
                //intEligibleAssignment = assignments.size();
                eligAssignments = new Cookie('eligAssignments-'+ user.ContactId,String.valueOf(intEligibleAssignment),null,1800,false);
                ApexPages.currentPage().setCookies(new Cookie[]{eligAssignments});
                // reset the local variables for heap size - Mariappan
                setAssignment = new Set<Staffing_Event__c>();
                assignments = new List<Staffing_Event__c>();
                System.debug('Final Limits.getHeapSize() :'+Limits.getHeapSize() );
            }
            
            
        } else {
            
            intEligibleAssignment = Integer.valueOf(eligAssignments.getValue());
        }
    }
    //Following code line is added by Umair-Plumlogix of US11930 of Staff Augmentation on 06/03/2020
    //Begin
    public List<Staffing_Event__c> covid_workshops(Set<Staffing_Event__c> assignments,String userRegion,String userCountry,Set<String>roleProgrammeCombo,List<String> roleIds){
        
        List<Staffing_Event__c> final_assignments = new List<Staffing_Event__c>();
        Set<Staffing_Event__c> global_assignments = new Set<Staffing_Event__c>();
        Map<id, Staffing_Event__c> temp_assignments = new Map<id,Staffing_Event__c>();
        Set<Staffing_Event__c> assignmentsSet = assignments;
        
        //Commented the below line as it is assignmentSet directly from the parameter - Mariappan
        // assignmentsSet.addAll(assignments);
        System.debug('In covid_workshops ');
        System.debug('covid_workshops assignments - ' + assignments);
        System.debug('covid_workshops userRegion - ' + userRegion);
        System.debug('covid_workshops userCountry - ' + userCountry);
        System.debug('covid_workshops roleProgrammeCombo - ' + roleProgrammeCombo);
        System.debug('covid_workshops roleIds - ' + roleIds);
        System.debug('Before Global_workshops call ');
        
        global_assignments = Global_workshops(assignmentsSet,roleProgrammeCombo,roleIds);
        System.debug('After Global_workshops call ');
        
        System.debug('global_assignments size:'+global_assignments.size());
        
        integer index =0 ;
        //assignments.addAll(global_assignments);
        assignmentsSet.addAll(global_assignments);
        //System.debug('assignments size:'+assignments.size());
        System.debug('assignmentsSet size:'+assignmentsSet.size());
        
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        
        if(assignmentsSet != null)
            for(Staffing_Event__c event:assignmentsSet ){
                //System.debug('event.Staffing_Event_Type__c:'+event.Staffing_Event_Type__c);
                //System.debug('event.IB_Event__r.Applicant_Eligibility_Location__c:'+event.IB_Event__r.Applicant_Eligibility_Location__c);
                
                if(event.Staffing_Event_Type__c== 'Cluster Workshop' || event.Staffing_Event_Type__c== 'Regional Workshop' || event.Staffing_Event_Type__c== 'In School Workshop'
                   || event.Staffing_Event_Type__c == IBConstants.SCHEDULED_WORKSHOP || event.Staffing_Event_Type__c == IBConstants.REQUESTED_WORKSHOP)  //Addedd by Vikranth EMS Project
                {
                    if ((event.IB_Event__r.Applicant_Eligibility_Location__c == 'Venue Region' && event.Staffing_Event_Region__c == userRegion) 
                        || (event.IB_Event__r.Applicant_Eligibility_Location__c == 'Venue Country' && event.Staffing_Event_Country__c==userCountry) 
                        || (event.IB_Event__r.Applicant_Eligibility_Location__c == 'Global'))
                    {
                        //Adding it the filtered records directly to the final assignment set directly instead of map
                        // temp_assignments.put(event.Id, event);
                        final_assignments.add(event);
                    }
                }
                else
                {
                    //Adding it the filtered records directly to the final assignment set directly instead of map
                    // temp_assignments.put(event.Id, event);
                    final_assignments.add(event);
                }
                
            } 
        
      /*   System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        System.debug('temp_assignments size:'+temp_assignments.size());
        System.debug('temp_assignments values:'+temp_assignments.values());
        final_assignments.addall(temp_assignments.values()); */
        
        // reset the local variables for heap size - Mariappan
        global_assignments = new Set<Staffing_Event__c>();
        temp_assignments = new Map<id,Staffing_Event__c>();
        assignmentsSet = new Set<Staffing_Event__c>();
        
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        System.debug('Ass: '+final_assignments.size()+' '+final_assignments);
        
        
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        return final_assignments;
    }    
    
    
    
    private  Set<Staffing_Event__c> Global_workshops(Set<Staffing_Event__c> final_assignments,Set<String>roleProgrammeCombo,List<String> roleIds){
        
        
        Set<String> roleIdsSet = new Set<String>();
        roleIdsSet.addAll(roleIds);
        Set<Staffing_Event__c> global_assignmentsSet = new Set<Staffing_Event__c>();
        List<Staffing_Event__c> global_assignments = new List<Staffing_Event__c>();
        if(myLanguages != null && !myLanguages.isEmpty()){
            global_assignments = [select Id,IB_Event__r.Applicant_Eligibility_Location__c, Workshop_Product_Title__c, Start_Date__c, Staffing_Event_Region__c, 
                                  Staffing_Event_Country__c, Staffing_Event_City__c, Programme_s__c, End_Date__c, Name, Subject__c, Staffing_Event_Type__c, 
                                  Related_Subject__c,(Select IB_Role_Name__c, IB_Role__c,IB_Workshop_Product_Title__c, toLabel(IB_Programme__c),Positions_Left__c 
                                                      from IB_Event_Roles__r where Positions_Left__c > 0) 
                                  from Staffing_Event__c where 
                                  (Staffing_Event_Type__c= 'Cluster Workshop'OR Staffing_Event_Type__c= 'Regional Workshop' OR Staffing_Event_Type__c= 'In School Workshop' OR //Added by Vikranth EMS Project
                                   Staffing_Event_Type__c =: IBConstants.SCHEDULED_WORKSHOP  OR Staffing_Event_Type__c =: IBConstants.REQUESTED_WORKSHOP)  And Start_Date__c != null and End_Date__c != null
                                  And (IB_Event__r.Applicant_Eligibility_Location__c = 'Global' OR
                                       IB_Event__r.Applicant_Eligibility_Location__c = 'Venue Country' )
                                  And Start_Date__c >= TODAY
                                  And IB_Event__r.Bundle__c = false 
                                  And Id IN
                                  (Select Staffing_Event__c
                                   From IB_Event_Role__c
                                   Where IB_Role__c IN :roleIdsSet
                                   AND Role_Programme_Psp_Combo__c IN :roleProgrammeCombo // DEMEG: TESTING CPU TIMEOUT
                                   AND Positions_Left__c > 0
                                   AND (Proposed_Language__c = null OR Proposed_Language__c IN :myLanguages)
                                  )
                                  And Id NOT IN
                                  (Select Staffing_Event__c
                                   From My_Staffing_Event__c
                                   Where IB_Contact__c = :user.ContactId)
                                  And Id Not IN:final_assignments
                                  ORDER BY Start_Date__c, Name];
        }
        else {
            global_assignments = [select Id,IB_Event__r.Applicant_Eligibility_Location__c, Workshop_Product_Title__c, Start_Date__c, Staffing_Event_Region__c, 
                                  Staffing_Event_Country__c, Staffing_Event_City__c, Programme_s__c, End_Date__c, Name, Subject__c, Staffing_Event_Type__c, 
                                  Related_Subject__c,(Select IB_Role_Name__c, IB_Role__c,IB_Workshop_Product_Title__c, toLabel(IB_Programme__c),Positions_Left__c 
                                                      from IB_Event_Roles__r where Positions_Left__c > 0) from Staffing_Event__c where 
                                  (Staffing_Event_Type__c= 'Cluster Workshop'OR Staffing_Event_Type__c= 'Regional Workshop' OR Staffing_Event_Type__c= 'In School Workshop'  OR Staffing_Event_Type__c =: IBConstants.REQUESTED_WORKSHOP  OR Staffing_Event_Type__c =: IBConstants.SCHEDULED_WORKSHOP)  And Start_Date__c != null and End_Date__c != null
                                  And (IB_Event__r.Applicant_Eligibility_Location__c = 'Global' OR
                                       IB_Event__r.Applicant_Eligibility_Location__c = 'Venue Country' )
                                  And Start_Date__c >= TODAY
                                  And IB_Event__r.Bundle__c = false 
                                  And Id IN
                                  (Select Staffing_Event__c
                                   From IB_Event_Role__c
                                   Where IB_Role__c IN :roleIdsSet
                                   AND Role_Programme_Psp_Combo__c IN :roleProgrammeCombo // DEMEG: TESTING CPU TIMEOUT
                                   AND Positions_Left__c > 0
                                  )
                                  And Id NOT IN
                                  (Select Staffing_Event__c
                                   From My_Staffing_Event__c
                                   Where IB_Contact__c = :user.ContactId)
                                  And Id Not IN:final_assignments
                                  ORDER BY Start_Date__c, Name];
        }
        
        System.debug('global_assignments size: ' + global_assignments.size());
        global_assignmentsSet.addAll(global_assignments);
        System.debug('global_assignmentsSet size: ' + global_assignmentsSet.size());
        
        
        return global_assignmentsSet;
    }
    //End
    private void eligTrainings(){
        
        
        List<Training_Event__c> trainings = new List<Training_Event__c>();
        //Following code is added by Umair-Plumlogix of US11949 of Staff Augmentation Project on 06/18/2020
        //Start
        List<IB_Role__c> RolesOfContact = new List<IB_Role__c>();
        List<IB_Role__c> final_Roles = new List<IB_Role__c>();
        RolesOfContact = [Select IB_Role_Name__c, Status__c, Programme_Selection__c from IB_Role__c where IB_Contact__r.id =: user.ContactId];
        
        for (IB_Role__c roleTemp : myAppliedForRoles)
        {
            if(roleTemp.IB_Role_Name__c == 'School Visit Team Leader')
            {
                for (IB_Role__c rolCon : RolesOfContact)
                {
                    if (rolCon.IB_Role_Name__c == 'School Visit Team Member' && rolCon.Status__c == 'Confirmed' && rolCon.Programme_Selection__c==roleTemp.Programme_Selection__c)
                    {
                        final_Roles.add(roleTemp);
                    }
                }
                
            }
            else
            {
                final_Roles.add(roleTemp);
            }
        }
        myAppliedForRoles = final_Roles;
        //End
        ////Following query is updated by Ammara-Plumlogix of US11580 and US11565 of Staff Augmentation Project on 06/18/2020
        //Start
        trainings = [Select Training_Event_Region__c, Training_Event_Country__c, Training_Event_City__c, Start_Date__c, Name, Id, IB_Role_Name__c, IB_Event__c,IB_Event__r.Training_Language__c,
                     IB_Role__c, IB_Role_2__c, IB_Role_3__c, IB_Programme__c, End_Date__c, Application_Deadline__c
                     From Training_Event__c t
                     Where Training_Event_Status__c NOT IN ('Pending', 'Planned / Ready for Staffing', 'Postponed', 'Cancelled', 'Completed')
                     And Training_Event_Region__c =: userRegion
                     And Id NOT IN
                     (Select Training_Event__c
                      From My_Training_Event__c
                      Where IB_Contact__c =: user.ContactId)
                     /*And IB_Role__c IN :roleIdsTraining
And (IB_Role_2__c = null OR IB_Role_2__c in :roleIdsTraining)
And (IB_Role_3__c = null OR IB_Role_3__c in :roleIdsTraining)*/
                     AND (IB_Role__c IN  :roleIdsTraining 
                          OR (IB_Role_2__c IN :roleIdsTraining) 
                          OR (IB_Role_3__c IN :roleIdsTraining))
                     And ((Application_Deadline__c = NULL And Start_Date__c >= TODAY) OR Application_Deadline__c >= TODAY)
                     Order By Start_Date__c];//End
        //Note: get all roles then filter out by programme in apex (necessary due to SOQL join limitations)
        System.debug('Role Training  '+roleIdsTraining.size());
        System.debug('Applied Roles  '+myAppliedForRoles.size());
        if(!trainings.isEmpty()){
            trainings = IBActivity.filterTrainingsByProgramme(trainings, myAppliedForRoles);  //filter out by programme
        }
        System.debug('Umair3  '+trainings.size());
        intEligibleTraining = trainings.size();  
        
    }
    private String getUserCountry(){
        List<Contact> myContact = [Select Country__r.Name From Contact c Where Id = :user.ContactId LIMIT 1];
        return myContact[0].Country__r.Name;
    }
    private String getUserRegion(){
        List<Contact> myContact = [Select IB_Region__c From Contact c Where Id = :user.ContactId LIMIT 1];
        return myContact[0].IB_Region__c;
    }

}