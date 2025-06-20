public without sharing class DashboardController {

    private User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
    public string userId = String.valueOf(user.ContactId);
    public List<IB_Role_Repository__c> roles = IBRoleRepositoryDAO.INSTANCE.getAvailableRoles();
    public List<IBActivity> notifications {get; set;}
    public IBActivity notify = new IBActivity();
    public static List<IBActivity> myActivities {get; set;}
    public static List<IBActivity> myActivitiesCases {get; set;}
    public String activityId {get; set;}
    public String activityTable {get; set;}
    public List<String> lstRolesName {get;set;}
    public Map<String, Boolean> mapRoleNameToBoolean {get;set;}
    public boolean elapsedTime;
    public String notifyTable = 'default';
    private List<IB_Role__c> myRoles;
    private API_Settings__c objCS;
    private static final string CUSTOM_SETTING_INSTANCE_NAME = 'IBEN';

    public DashboardController(){
        
        myActivities = new List<IBActivity>();
        myActivitiesCases = new List<IBActivity>();
        objCS = API_Settings__c.getValues(CUSTOM_SETTING_INSTANCE_NAME);
        
        List<String> lstConcRole = new List<String>();
        
        if(objCS != null){
            for(String role : objCS.Role_Name__c.split(','))
                lstConcRole.add(role.trim());
        }
        
        lstRolesName = new List<String>(lstConcRole);
        mapRoleNameToBoolean = new Map<String, Boolean>();
        myActivities = loadMyActivities();
        myActivitiesCases= loadMyCases();
        completedAssignment();
        notifications = getNotifications();
        myRoles = IBActivity.loadMyIBRoles('Select IB_Role__c From IB_Role__c Where IB_Contact__c = \'' + user.ContactId + '\'', null);
        
    }
    
    //Method added by Shahrukh for ECM00747 on 19/08/24
    public String getUserLanguageKey() {
        return UserInfo.getLanguage();
    }
    
    public boolean getElapsedTime(){
        Long test = dateTime.now().getTime() - user.LastModifiedDate.getTime(); 
        Long seconds = test / 1000;
        Long minutes = seconds / 60;
        Long hours = minutes / 60;
        Long days = hours / 24;
        Long years = days / 365;
        if(years >= 1){
            return true;
        }
        else{
            return false;
        }
    }
    
    public void setNotifyTable(String notifyTable){
    this.notifyTable = notifyTable;
    }
    
    public String getNotifyTable(){
        return notifyTable;
    }
    
    public void setNotify(IBActivity notify){
        this.notify = notify;
    }
    
    public IBActivity getNotify(){
        return notify;
    }
    
    public DateTime getLastUpdated(){
        return user.LastModifiedDate;
    }
    
    public List<IB_Role_Repository__c> getRoles(){
        return roles;
    }
    
    /*public PageReference isLoggedIn() {
        if (UserInfo.getUserType() == 'Guest') {
            return new PageReference('/educator/siteHomePage');
        }
        return null;
    }*/

    public PageReference isLoggedIn() {
        if (UserInfo.getUserType() == 'Guest') {
            return new PageReference('/educator/siteHomePage');
        }
        else {
            User u = [Select Profile.Name,LastPasswordChangeDate from User
                      Where id = :UserInfo.getUserId() limit 1];
            if(u.Profile.Name == 'SCU + Basic' || u.Profile.Name == 'SCU + Advanced'){
                Long lastChanged = u.LastPasswordChangeDate.getTime();
                Long curTime = Datetime.now().getTime();
                Long diff = (curTime - lastChanged) / 1000;

                if(diff < 2){
                    return new PageReference('/educator/communitylinks');
                } else {
                    return null;
                }
            } else{
                return null;
            }
        }
    }

    public void completedAssignment(){
        
        for(String roleName : lstRolesName)
            mapRoleNameToBoolean.put(roleName, false);
        
        AggregateResult[] groupedResults = [    Select count(Id) countCompletedAssignment, IB_Role__r.Role_Name__c
                                                From My_Staffing_Event__c 
                                                WHERE IB_Role__r.Role_Name__c IN: lstRolesName 
                                                AND IB_Contact__c =: user.ContactId 
                                                AND Application_Status__c = 'Completed'
                                                AND My_Role__r.Notify_Status__c = TRUE
                                                GROUP By IB_Role__r.Role_Name__c
                                            ];
        
        for(AggregateResult ar : groupedResults)
            mapRoleNameToBoolean.put((String)ar.get('Role_Name__c'), (Integer)ar.get('countCompletedAssignment') >= 3 ? true : false);
    
    }

    public Boolean getNoActivities(){
        if(myActivities != null && myActivities.isEmpty()){
            return true;
        }
        return false;
    }
    
    public Boolean getHasNotifications(){
        if(notifications != null && notifications.size() > 0){
            return true;
        }
        return false;
    }
    
    
    public Boolean getHasRoles(){
        if(myRoles != null && myRoles.size() > 0){
            return true;
        }
        return false;
    }


    public Boolean getIsDenied(){
        if(notify.ApplicationStatus == 'Not Selected' || notify.ApplicationStatus == 'Not Approved'){
            return true;
        }
        return false;
    }

    //Following code is added by Shehryar-Plumlogix in Sprint 22 on 06/21/2021
    //start
    private List<IBActivity> loadMyCases(){
        myActivitiesCases = MyAssignmentsController.loadMyCases(myActivitiesCases);
        return myActivitiesCases;
    }
    
    //End
    private List<IBActivity> loadMyActivities(){
        //case 5464 - only display invited and confirmed assignments on dashboard
        //Added IB_Event__r.Delivery_Mode__c and IB_Event__r.Programme_Relationship_Manager__c by Shahrukh for ECM00508 on 23/08/24
        //Added IB_Event__r.recordtype.name,IB_Event__r.Preliminary_Review_Start_Date__c ,IB_Event__r.Preliminary_Review_End_Date__c by Kashyap for ECM00754 - Phase 3


        String dashboardQuery = 'Select Id, IB_Event__r.recordtype.name,IB_Event__r.Preliminary_Review_Start_Date__c ,IB_Event__r.Preliminary_Review_End_Date__c ,Start_Date__c, Staffing_Event__c, Staffing_Event__r.Id, IB_Event_Role__r.IB_Role_Name_fr__c,IB_Event_Role__r.IB_Role_Name_es__c,Staffing_Event_Region__c, Staffing_Event_Country__c, Staffing_Event_City__c, ' +
                                'toLabel(Staffing_Event__r.IB_Event__r.Workshop_Programme__c), Programme_s__c,Programme_From_Event_Role__c, IB_Role_Name__c, End_Date__c, toLabel(Application_Status__c), IB_Contact__c, Staffing_Event__r.Name , '+
                                'IB_Event_Role__r.Proposed_Language__c,IB_Event_Role__r.Delivery_Mode__c,IB_Event_Role__r.PSP__c,IB_Event__r.Delivery_Mode__c,IB_Event__r.Programme_Relationship_Manager__c ' +
                                'From My_Staffing_Event__c ' +
                                'Where IB_Contact__c = :userId ' +
                                'AND Staffing_Event__c != null ' + 
                                'AND IB_Event__r.Bundle__c = false ' + 
                                'And Application_Status__c IN (\'Invited\',\'Confirmed\') ' + 
                                'Order by Application_Status__c ASC, Start_Date__c, Staffing_Event__r.Name';

        
        myActivities = MyAssignmentsController.loadMyAssignments(myActivities, dashboardQuery, false);
        myActivities = MyTrainingController.loadMyTrainings(myActivities, null, false);


        /*Date cutoffDate = Date.today().addDays(-30);
        List<My_Staffing_Event__c> assignments = [Select Id, Start_Date__c, Staffing_Event__c, Staffing_Event_Region__c, Staffing_Event_Country__c, Staffing_Event_City__c, 
                                                        toLabel(Staffing_Event__r.IB_Event__r.Workshop_Programme__c), IB_Role_Name__c, End_Date__c, toLabel(Application_Status__c), IB_Contact__c, Staffing_Event__r.Name 
                                                From My_Staffing_Event__c
                                                Where IB_Contact__c = :user.ContactId
                                                And 
                                                    (Application_Status__c NOT IN ('Not Selected', 'Not Approved', 'Invitation Declined', 'Withdrawn', 'Withdrawn by IB', 'Completed')
                                                     Or (Date_Declined__c != NULL And Date_Declined__c >= :cutoffDate)
                                                     Or (Date_Withdrawn__c != NULL And Date_Withdrawn__c >= :cutoffDate))  //only display rejected or withdrawn assignments for 30 days
                                                Order by Start_Date__c, Staffing_Event__r.Name];
      

        if(!assignments.isEmpty()){
            myActivities = IBActivity.addAssignmentsToActivities(myActivities, assignments);
            myActivities = IBActivity.refineActivities(myActivities);           
        }

        
        List<My_Training_Event__c> trainings = [Select Training_Event__c, Training_Event_Region__c, Training_Event_Country__c, Training_Event_City__c, Id, 
                                            IB_Role_Names__c, toLabel(IB_Programme__c), IB_Contact__c, Start_Date__c, End_Date__c, toLabel(Application_Status__c), Training_Event__r.Name 
                                        From My_Training_Event__c
                                        Where IB_Contact__c = :userId
                                            And Application_Status__c NOT IN ('Not Selected', 'Not Approved', 'Invitation Declined', 'Declined for (all) Role Application(s)', 'Withdrawn', 'Withdrawn by IB', 'Completed') 
                                        Order by Start_Date__c];
        
        
        if(!trainings.isEmpty()){
            myActivities = IBActivity.addMyTrainingsToActivities(myActivities, trainings);
            myActivities = IBActivity.refineActivities(myActivities);               
        }
        */



        myActivities = IBActivity.refineActivities(myActivities);
        //myActivities = IBActivity.sortIBActivities(myActivities);
        /*Integer i = 0;
        for(IBActivity a:theseActivities){
            if(filter != '--' && filter != a.ApplicationStatus){
                theseActivities.remove(i);
                i++;
            }
        }*/
        return myActivities;
    }
    
    private List<IBActivity> getNotifications(){
        List<IBActivity> myNotifications = new List<IBActivity>();
        
        myNotifications = getNotifyAssignments(myNotifications);
        myNotifications = getNotifyTrainings(myNotifications);
        //myNotifications = getCompletedAssignment(myNotifications);
        
        for(IBActivity activity : myNotifications){
            activity.ApplicationStatus = updateNotificationStatus(activity.ApplicationStatus, activity.Table);
        }
        
        return myNotifications;
    }

    private List<IBActivity> getNotifyAssignments(List<IBActivity> myNotifications){
        List<My_Staffing_Event__c> assignments = new List<My_Staffing_Event__c>();
        //Added IB_Event_Role__r.PSP__c and IB_Event__r.Delivery_Mode__c by Shahrukh for ECM00508 on 23/08/24
        assignments = [Select  Id, Start_Date__c, Staffing_Event__c, Staffing_Event_Region__c, Staffing_Event_Country__c, Staffing_Event_City__c, 
                                                        Programme_s__c,Programme_From_Event_Role__c, IB_Role_Name__c,IB_Event_Role__r.IB_Role_Name_fr__c,IB_Event_Role__r.IB_Role_Name_es__c, End_Date__c, Application_Status__c, IB_Contact__c, Notify_Of_Status__c, Staffing_Event__r.Name,
                                                        IB_Event_Role__r.Proposed_Language__c,IB_Event_Role__r.Delivery_Mode__c, IB_Event_Role__r.PSP__c, IB_Event__r.Delivery_Mode__c
                                            From My_Staffing_Event__c
                                            Where IB_Contact__c = :user.ContactId
                                            And Notify_Of_Status__c = true];
        system.debug('inline added by uma 255 assignments:'+ assignments.size());               
        if(assignments.size() > 0){
            myNotifications = IBActivity.addAssignmentsToActivities(myNotifications, assignments);  
        }
        return myNotifications;     
    }
    
    
    private List<IBActivity> getNotifyTrainings(List<IBActivity> myNotifications){
        List<My_Training_Event__c> trainings = new List<My_Training_Event__c>();
        
        trainings = [Select Training_Event__c, Training_Event_Region__c, Training_Event_Country__c, Training_Event_City__c, Id, Training_Event_Language__c, 
                           IB_Role_Names__c, IB_Programme__c, IB_Contact__c, Start_Date__c, End_Date__c, Application_Status__c, Notify_Of_Status__c, Training_Event__r.Name 
                                            From My_Training_Event__c
                                            Where IB_Contact__c = :user.ContactId
                                            And Notify_Of_Status__c = true];
                            
        if(trainings.size() > 0){
            myNotifications = IBActivity.addMyTrainingsToActivities(myNotifications, trainings);    
        }
        return myNotifications;     
    }   
    
    
    public String updateNotificationStatus(String status, String table){
    //update the ApplicationStatus on the IBObject to hold the appropriate notification label
        if(status == 'Not Approved'){
            if(table == 'My_Staffing_Event__c'){
                return Label.IBENPortal_Assignment_Notify_NotApproved;
            }
            else{
                return Label.IBENPortal_Training_Notify_NotApproved;
            }
        }
        
        else if(status == 'Not Selected'){
            if(table == 'My_Staffing_Event__c'){
                return Label.IBENPortal_Assignment_Notify_NotSelected;
            }
            else{
                return Label.IBENPortal_Training_Notify_NotSelected;
            }
        }
        
        else if(status == 'Backup'){
            if(table == 'My_Staffing_Event__c'){
                return Label.IBENPortal_Assignment_Notify_Backup;
            }
        }

        else if(status == 'Invited'){
            if(table == 'My_Staffing_Event__c'){
                return Label.IBENPortal_Assignment_Notify_Invited;
            }
            else{
                return Label.IBENPortal_Training_Notify_Invited;
            }
        }       
        
        else if(status == 'Under Approval'){
            if(table == 'My_Staffing_Event__c'){
                return Label.IBENPortal_Assignment_Notify_UnderApproval;
            }
            else{
                return Label.IBENPortal_Training_Notify_UnderApproval;
            }
        }
        
        else if(status == 'Confirmed'){
            if(table == 'My_Staffing_Event__c'){
                return Label.IBENPortal_Assignment_Notify_Confirmed;
            }
            else{
                return Label.IBENPortal_Training_Notify_Confirmed;
            }
        }
        
        else{
            //do nothing
        }
        return notify.ApplicationStatus;
    }
    
    
    public PageReference updateActivityNotification(){
        system.debug(loggingLevel.ERROR, 'activityTable: ' + activityTable + ' activityId: ' + activityId);
        PageReference p;
        p = Page.Dashboard;
        p.setRedirect(true);
        try{
            if(activityTable == 'My_Staffing_Event__c'){
                List<My_Staffing_Event__c> event = [Select Id, Notify_Of_Status__c From My_Staffing_Event__c Where Id = :activityId And Notify_Of_Status__c = true Limit 1];
                event[0].Notify_Of_Status__c = false;
                update event[0];        
            }
            if(activityTable == 'My_Training_Event__c'){
                List<My_Training_Event__c> event = [Select Id, Notify_Of_Status__c From My_Training_Event__c Where Id = :activityId And Notify_Of_Status__c = true Limit 1];
                event[0].Notify_Of_Status__c = false;
                update event[0];
            }   
        }
        catch (Exception ex) {
            System.debug('***ERROR: ' + ex.getMessage());     
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
        }
        notifications = getNotifications();
        return p;
    }

    public void updateAlerts(){

        String roleName = ApexPages.currentPage().getParameters().get('roleAssigned');

        List<IB_Role__c> lstIBRole = new List<IB_Role__c>(); 

        for(IB_Role__c ibRole : [  SELECT Id, IB_Contact__c, IB_Role_Name__c, Notify_Status__c 
                                    FROM IB_Role__c 
                                    WHERE IB_Role_Name__c =: roleName
                                    AND IB_Contact__c =: user.ContactId
                                 ]){
            ibRole.Notify_Status__c = false;
            lstIBRole.add(ibRole);
        }
   
        update lstIBRole;
    }
}