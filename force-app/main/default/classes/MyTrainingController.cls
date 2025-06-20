public class MyTrainingController {

      public static User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
    public static List<IBActivity> myTrainings {get; set;}
    public static List<IBActivity> myEligTrainings {get; set;}
    public static List<IBActivity> myTrainingsHistory {get; set;}
    public static String userId = String.valueOf(user.ContactId);

    private List<String> myRoles;
    private List<IB_Role__c> myAppliedForRoles;
    //This variable is added by Developer Ammara-Plumlogix on 3-09-2019,CR-688(New Training Event Type 'Ongoing Development')
    //begin
    private List<IB_Role__c> myConfirmIBRoles;
    //end
    public String StatusPdf;
    public String EligibilityPdf;
    public String TrainingTypesPdf;
    
    public String getStatusPdf(){
        if (UserInfo.getLanguage() == 'fr'){
            system.debug(loggingLevel.ERROR,'STATUS:' + DocumentDAO.INSTANCE.getDocumentPathByName('Training Statuses French'));
            return DocumentDAO.INSTANCE.getDocumentPathByName('Training Statuses French');
        } else if (UserInfo.getLanguage() == 'es'){
            system.debug(loggingLevel.ERROR,'STATUS:' + DocumentDAO.INSTANCE.getDocumentPathByName('Training Statuses Spanish'));
            return DocumentDAO.INSTANCE.getDocumentPathByName('Training Statuses Spanish');
        } else {
            system.debug(loggingLevel.ERROR,'STATUS:' + DocumentDAO.INSTANCE.getDocumentPathByName('Training Statuses English'));
            return DocumentDAO.INSTANCE.getDocumentPathByName('Training Statuses English');
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
     
    public String getTrainingTypesPdf(){
        if (UserInfo.getLanguage() == 'fr'){
            system.debug(loggingLevel.ERROR,'TYPES:' + DocumentDAO.INSTANCE.getDocumentPathByName('Training Types French'));
            return DocumentDAO.INSTANCE.getDocumentPathByName('Training Types French');
        } else if (UserInfo.getLanguage() == 'es'){
            system.debug(loggingLevel.ERROR,'TYPES:' + DocumentDAO.INSTANCE.getDocumentPathByName('Training Types Spanish'));
            return DocumentDAO.INSTANCE.getDocumentPathByName('Training Types Spanish');
        } else {
            system.debug(loggingLevel.ERROR,'TYPES:' + DocumentDAO.INSTANCE.getDocumentPathByName('Training Types English'));
            return DocumentDAO.INSTANCE.getDocumentPathByName('Training Types English');
        }
    }

    public MyTrainingController(){
        myRoles = new List<String>();
        myTrainings = new List<IBActivity>();
        myEligTrainings = new List<IBActivity>();
        myTrainingsHistory = new List<IBActivity>();

        String query = 'Select Training_Event__c, Training_Event_Region__c,Training_Event_Language__c, Training_Event_Country__c, Training_Event_City__c, Id, ' +
                                            'IB_Role_Names__c, toLabel(IB_Programme__c), IB_Contact__c, Start_Date__c, End_Date__c, toLabel(Application_Status__c), Training_Event__r.Name  ' +
                                        'From My_Training_Event__c ' +
                                        'Where IB_Contact__c = :userId ' +
                                        'And Application_Status__c = \'Completed\' ' +
                                        'And ID in (select ParentID from My_Training_Event__History)' +
                                        'Order by Start_Date__c ';
        
        myRoles = IBActivity.loadMyRoles(myRoles, null);
        myAppliedForRoles = IBActivity.loadMyIBRoles(null, 'Applicant');
        //This Part is added by Developer Ammara-Plumlogix on 3-09-2019,CR-688(New Training Event Type 'Ongoing Development')
        //begin
        //Getting Confirmed Roles because ongoing development Event will be shown for confirmed roles
        myConfirmIBRoles = IBActivity.loadMyIBRoles(null, 'Confirmed');
        //end
        
        myTrainings = loadMyTrainings(myTrainings, null, false);
        myTrainings = IBActivity.sortIBActivities(myTrainings);

        myEligTrainings = loadEligTrainings(myEligTrainings);
        myEligTrainings = IBActivity.sortIBActivities(myEligTrainings);
        
        myTrainingsHistory = loadMyTrainings(myTrainingsHistory, query, true);
        myTrainingsHistory = IBActivity.sortIBActivities(myTrainingsHistory);
    }



    public Boolean getNoTrainings(){
      if(myTrainings == null || myTrainings.isEmpty()){
          return true;
      }
      return false;
    }
    
    
    
    public Boolean getNoEligTrainings(){
        if(myTrainings == null || myEligTrainings.isEmpty()){
            return true;
        }
        return false;
    }


    public Boolean getNoTrainingsHistory(){
        if(myTrainings == null || myTrainingsHistory.isEmpty()){
            return true;
        }
        return false;
    }
    


    public static List<IBActivity> loadMyTrainings(List<IBActivity> activities, String query, Boolean historical){
        List<My_Training_Event__c> trainings = new List<My_Training_Event__c>();
        if(query == null){
            trainings = [Select Training_Event__c, Training_Event_Region__c, Training_Event_Country__c, Training_Event_City__c, Id, 
                                            IB_Role_Names__c, toLabel(IB_Programme__c), IB_Contact__c, Start_Date__c, End_Date__c, toLabel(Application_Status__c), Training_Event__r.Name ,Training_Event_Language__c
                                        From My_Training_Event__c
                                        Where IB_Contact__c = :userId
                                            And Application_Status__c NOT IN ('Not Selected', 'Not Approved', 'Invitation Declined', 'Declined for (all) Role Application(s)', 'Withdrawn', 'Withdrawn by IB', 'Completed') 
                                        Order by Start_Date__c];
        }
        else{
            trainings = Database.query(query);
        }
        
        System.debug('****trainings is ' + trainings);
        
        if(!trainings.isEmpty()){
            activities = IBActivity.addMyTrainingsToActivities(activities, trainings);
            if(!historical){ //only refine if not historical records
                activities = IBActivity.refineActivities(activities);               
            }
        }
        return activities;
    }
    


    private List<IBActivity> loadEligTrainings(List<IBActivity> activities){
            String userRegion = getUserRegion();
            
                //List<String> roleIds = IBActivity.getRoleIds(myAppliedForRoles);
                //System.debug('*****MyTrainingController, roleIds is ' + roleIds);

        List<Training_Event__c> trainings = new List<Training_Event__c>();

        List<String> appliedForRoleProgrammeCombos = new List<String>();
        //This Part is added by Developer Ammara-Plumlogix on 3-09-2019,CR-688(New Training Event Type 'Ongoing Development')
        //begin
        //List to store Confirmed Roles and Programme combo 
        List<String> ConfirmForRoleProgrammeCombos = new List<String>();
        
        
        for(IB_Role__c r:myAppliedForRoles){
            appliedForRoleProgrammeCombos.add(r.IB_Role_Programme_Combo__c);
        }
        //getting Confirmed Roles and Programme combo because ongoing development Event will be shown for confirmed roles
         for(IB_Role__c r:myConfirmIBRoles){
            ConfirmForRoleProgrammeCombos.add(r.IB_Role_Programme_Combo__c);
        }//end

        TrainingEventDAO teDao = TrainingEventDAO.INSTANCE;
        trainings = teDao.getEligibleTrainings(appliedForRoleProgrammeCombos,userRegion,userId);
        //This Part is added by Developer Ammara-Plumlogix on 3-09-2019,CR-688(New Training Event Type 'Ongoing Development')
        //begin
        //Adding Ongoing Development Event that are eligible to apply for particular user 
        trainings.addAll(teDao.getEligibleTrainings_ongoingdevlopment(ConfirmForRoleProgrammeCombos, userRegion, userId));
        //end
        /*trainings = [Select Training_Event_Region__c, Training_Event_Country__c, Training_Event_City__c, Start_Date__c, Name, Id, IB_Role_Name__c, IB_Event__c,IB_Event__r.Training_Language__c,
                            IB_Role__c, IB_Role_2__c, IB_Role_3__c, IB_Programme__c, End_Date__c, Application_Deadline__c
                                        From Training_Event__c t
                                        Where Training_Event_Status__c NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Completed','Confirmed')
                                                And Training_Event_Region__c = :userRegion
                                                And Id NOT IN
                                                    (Select Training_Event__c
                                                    From My_Training_Event__c
                                                    Where IB_Contact__c = :userId)
                                            AND (IB_Role__c IN  :roleIds 
                                            OR (IB_Role_2__c IN :roleIds) 
                                            OR (IB_Role_3__c IN :roleIds))
                                            And ((Application_Deadline__c = NULL And Start_Date__c >= TODAY) OR Application_Deadline__c >= TODAY)
                                              Order By Start_Date__c];
                                                                                //Note: get all roles then filter out by programme in apex (necessary due to SOQL join limitations)
        */
            for(Training_Event__c train : trainings){
                System.debug('****In loadEligTrainings, the trainings pre-filtered are: ' + train.Training_Event_City__c + ':  ' + train.Name + ', ' + train.IB_Role_Name__c);              
            }

        if(!trainings.isEmpty()){
                        //trainings = IBActivity.filterTrainingsByProgramme(trainings, myAppliedForRoles);  //filter out by programme
                        //system.debug(loggingLevel.ERROR, 'after filter: ' + trainings);
            activities = IBActivity.addEligTrainingsToActivities(activities, trainings);
            system.debug(loggingLevel.ERROR, 'after add to activities: ' + activities);
        }

        return activities;
    }
    
    
    @TestVisible
    private String getUserRegion(){
        List<Contact> myContact = [Select IB_Region__c From Contact c Where Id = :user.ContactId LIMIT 1];
        return myContact[0].IB_Region__c;
    }
    
}