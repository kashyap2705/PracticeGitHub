public class MyTrainingDetailsController {
 

  public User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
  public String userId = String.valueOf(user.ContactId);
    
    public Training_Event__c training {get; set;}
    public List<My_Training_Event__c> myTraining {get; set;}
    
  public String reqTraining {get; set;}
  public String interestItem {get; set;}
  public String releasePermissionRequired {get; set;}
  
  public String levelOfInterest {get; set;}
  public String withdrawalReason {get; set;}
  public String withdrawalComments {get; set;}
  
  private String urlAction {get; set;}
  private String urlSubmit {get; set;}

  public Boolean withdrawalApplication{get; set;}
  public Boolean invitationAccepted {get; set;}
  public DataTranslateTraining translatedTraining {get;set;}
  //This Part is being updated by Ammara-Plumlogix,as part of US-11565 and US-11580 on 06/11/2020
  //Begin
  @testvisible private List<My_Training_Event__c> myInvitation {get; set;}//End
    
    public MyTrainingDetailsController(){

        training = new Training_Event__c();
        translatedTraining = new DataTranslateTraining();
        myInvitation = new List<My_Training_Event__c>();
        withdrawalApplication = true;
        invitationAccepted = false;
        interestItem = Label.IBEN_Assignment_Field_Interested;  
        
        if(ApexPages.currentPage().getParameters().containsKey('action')){
            urlAction = ApexPages.currentPage().getParameters().get('action').toUpperCase();
        }
        
        if(ApexPages.currentPage().getParameters().containsKey('submit')){
            urlSubmit = ApexPages.currentPage().getParameters().get('submit').toUpperCase();            
        }
    
        reqTraining = null;
        training = loadTraining();
        translatedTraining = translateTrainingDetails(training);
        system.debug(loggingLevel.ERROR, 'translatedTraining: ' + translatedTraining);
        myTraining = loadMyTraining();
        myInvitation = loadMyInvitation();
    }


    public List<SelectOption> getReleasePermissionItems() {
        return IBActivity.getReleasePermissionItems();
    }
    
    
    public List<SelectOption> getInterestLevelItems() {
        return IBActivity.getInterestLevelItems();
    }
    
    
    public List<SelectOption> getWithdrawalReasons() {
        return IBActivity.getWithdrawalReasons();
    }


    public Boolean getUrlActionEdit(){  //return true only if there is no Invitation to accept or just accepted
        if(urlAction == 'EDIT'){
            return true;
        }
        return false;
    }

        
    public Boolean getHasInvitation(){  //return true only if there is no Invitation to accept or just accepted
        if(!myInvitation.isEmpty() && !invitationAccepted && !getUrlActionEdit()){
            return true;
        }
        return false;
    }
    
    
    public Boolean getShowGeneralInstructions(){
        if(myTraining.isEmpty() && !invitationAccepted && !getAppliedForAssignment() && (myInvitation == null || myInvitation.isEmpty()) && !getUrlActionEdit()){  //don't display if any are true
            return true;
        }
        return false;
    }


    public Boolean getInvitationAccepted(){
        if(invitationAccepted){
            return true;
        }
        return false;
    }
    
            
    public Boolean getAppliedForAssignment(){
        if(urlSubmit == 'SUCCESS'){
            System.debug('*****appliedForAssignment = TRUE');
            return true;
        }
        System.debug('*****appliedForAssignment = TRUE');
        return false;
    }
    
    
    public Boolean getHasReqTraining(){
        if(reqTraining != null && reqTraining.length() > 0){
            return true;
        }
        return false;
    }
    
    public Boolean getHasTrainingPrereqs(){
        if(training.Training_Pre_Requistes__c != null){
            return true;
        }
        return false;
    }



    private Training_Event__c loadTraining(){
        training = [Select Id, Name, Training_Event_Region__c, Training_Event_Sub_Region__c, Training_Event_Country__c, Training_Event_City__c, 
                                            IB_Role_Name__c, IB_Programme__c, Start_Date__c, End_Date__c,   Training_Event_Type__c, Training_Event_Venue__c,    
                                            Training_Event_Status__c, Application_Deadline__c, Training_Pre_Requistes__c, IB_Event__c
                                        From Training_Event__c
                                        Where Id = :ApexPages.currentPage().getParameters().get('Id')
                                        //And (Application_Deadline__c = NULL OR Application_Deadline__c >= TODAY)
                                        LIMIT 1];
        
        if(training.Training_Event_Type__c == 'Advanced Training'){
            reqTraining = Label.IBENPortal_TrainingDetails_InitialTraining;
        }
        
        System.debug('Called loadTraining().');
        
        return training;
    }
    
    

    private List<My_Training_Event__c> loadMyTraining(){
        myTraining = [Select Withdrawal_Reason__c, Withdrawal_Argumentation__c, Level_of_Interest__c, Id, IB_Event__c, toLabel(Application_Status__c)
                                        From My_Training_Event__c
                                        Where Training_Event__c = :ApexPages.currentPage().getParameters().get('Id')
                                            And IB_Contact__c = :user.ContactId
                                        LIMIT 1];
    
        return myTraining;  
    }   
    
    
    
    private List<My_Training_Event__c> loadMyInvitation(){
        myInvitation = [Select Id, Application_Status__c, Invitation_Response__c, Invitation_Response_Date__c, Release_Permission_Required__c, Level_of_Interest__c
                                        From My_Training_Event__c
                                        Where Training_Event__c = :ApexPages.currentPage().getParameters().get('Id')
                                            And IB_Contact__c = :user.ContactId
                                            And Application_Status__c = 'Invited'
                                            And Invitation_Response__c = null];

        return myInvitation;    
    }

  
  
  
  public PageReference isLoggedIn() {
    if (UserInfo.getUserType() == 'Guest') {
        return null;
    }
    else {
        return new PageReference('/educator');
    }
  }
  
  
  public void acceptInvitation(){
        try{
            myInvitation[0].Invitation_Response__c = 'Accepted';
            myInvitation[0].Invitation_Response_Date__c = Date.today();
            myInvitation[0].Application_Status__c = 'Confirmed';
            myInvitation[0].Level_of_Interest__c = 'Interested';//CR-684 and CR-687
            upsert myInvitation[0];
            invitationAccepted = true;
            myInvitation = loadMyInvitation();
        }
        catch (System.DmlException e) {
       for (Integer i = 0; i < e.getNumDml(); i++) {
                     ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getDmlMessage(i)));
           if (e.getDmlMessage(i).contains('Unique_Application__c')) {
                 
               ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Error when accepting Invitation.'));
           } else { 
               ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getDmlMessage(i))); 
           }
       }
    }
    catch (Exception ex) {
       ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
    }
    }
    
    public void declineInvitation() {
        
        try {
            myInvitation[0].Invitation_Response__c = 'Declined';
            //myInvitation[0].Invitation_Response_Date__c = Date.today();
            //myInvitation[0].Application_Status__c = 'Invitation Declined';
            //myInvitation[0].Level_of_Interest__c = 'Withdraw Interest';
            upsert myInvitation[0];
            invitationAccepted = false;
            myInvitation = loadMyInvitation();
        }
        catch (DmlException ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
        }
        
    }

  public PageReference submitApplication(){
        try{
            id trainingEventId = ApexPages.currentPage().getParameters().get('Id');
            MyTrainingEventsDAO trainDAO = MyTrainingEventsDAO.getInstance();
            My_Training_Event__c newTraining = new My_Training_Event__c(IB_Contact__c = user.ContactId, Level_of_Interest__c='Interested', Application_Status__c='Pending Selection', IB_Event__c = trainDAO.getCampaignIdFromTrainingId(trainingEventId),
                                                                        Training_Event__c=trainingEventId, Release_Permission_Required__c = releasePermissionRequired);

            insert newTraining;
            String url = '/MyTrainingDetails?id=' + ApexPages.currentPage().getParameters().get('id') + '&submit=success';
            PageReference view = new PageReference (url);
            view.setRedirect(true);        
            return view;
    }
        catch (System.DmlException e) {
       for (Integer i = 0; i < e.getNumDml(); i++) {
            System.debug('***ERROR at submitApplication: ' + e.getDmlMessage(i));
             ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getDmlMessage(i)));
           if (e.getDmlMessage(i).contains('Unique_Application__c')) {
               ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,  e.getDmlMessage(i)));
           } else { 
               ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getDmlMessage(i))); 
           }
       }
       return null;
   }
   catch (Exception ex) {
       ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
     }
     return null;
  }
  
  

    public PageReference saveWithdrawal(){
        try{
            myTraining[0].Level_of_Interest__c = levelOfInterest;
            myTraining[0].Application_Status__c = 'Withdraw Interest';
            myTraining[0].Date_Withdrawn__c = Date.today();
            myTraining[0].Withdrawal_Reason__c = withdrawalReason;
            myTraining[0].Withdrawal_Argumentation__c = withdrawalComments;
            
            System.debug('at saveWithdrawal, myTraining[0] is ' + myTraining[0]);

            upsert myTraining[0];

          String url = '/MyTraining';
          PageReference view = new PageReference (url);
      view.setRedirect(true);        
      return view;
        }
        catch (System.DmlException e) {
       for (Integer i = 0; i < e.getNumDml(); i++) {
             ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getDmlMessage(i)));
           if (e.getDmlMessage(i).contains('Unique_Application__c')) {
               ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getDmlMessage(i)));
           } 
           else { 
               ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getDmlMessage(i))); 
           }
       }
         
       return null;
         
   } catch (Exception ex) {
            
       ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
       
       return null;
   }
        
    }
    
    
    
  public PageReference cancel(){
     String url = '/MyTrainingDetails?id=' + ApexPages.currentPage().getParameters().get('id');
       
     PageReference view = new PageReference (url);
     view.setRedirect(true);        
     return view;
  }

  public static String translateText(String s, IBActivity a){
    String response = s;
    for(IB_Data_Translate__c t : IBActivity.translations){
        if(s == t.Record_ID__c){
            response = t.Translate_Value_1__c;
            break;
        }
    }
    return response;
  } 

  public static DataTranslateTraining translateTrainingDetails(Training_Event__c a){
        List<IB_Data_Translate__c> translations = [
            SELECT Id, Name, Record_ID__c, Object_Name__c, Locale__c, Translate_Value_1__c, Translate_Value_2__c 
            FROM IB_Data_Translate__c 
            WHERE Object_Name__c in ('TrainingStatus','IBActivity')
            AND Locale__c = :UserInfo.getLanguage()
        ];
        DataTranslateTraining dt = new DataTranslateTraining();
        for(IB_Data_Translate__c t : translations){
            if(a.Training_Event_Country__c == t.Record_ID__c){
                dt.Training_Event_Country = t.Translate_Value_1__c;
            }
            if(a.IB_Role_Name__c == t.Record_ID__c){
                dt.IB_Role_Name = t.Translate_Value_1__c;
            }
            if(a.IB_Programme__c == t.Record_ID__c){
                dt.IB_Programme = t.Translate_Value_1__c;
            }
            if(a.Training_Event_Type__c == t.Record_ID__c){
                dt.Training_Event_Type = t.Translate_Value_1__c;
            }
            if(a.Training_Event_Status__c == t.Record_ID__c){
                dt.Training_Event_Status = t.Translate_Value_1__c;
                system.debug(loggingLevel.ERROR,dt.Training_Event_Status);
            }
        }

        if(dt.Id == null){
            dt.Id = a.Id;
        }
        if(dt.Name == null){
            dt.Name = a.Name;
        }
        if(dt.Training_Event_Region == null){
            dt.Training_Event_Region = a.Training_Event_Region__c;
        }
        if(dt.Training_Event_Sub_Region == null){
            dt.Training_Event_Sub_Region = a.Training_Event_Sub_Region__c;
        }
        if(dt.Training_Event_Country == null){
            dt.Training_Event_Country = a.Training_Event_Country__c;
        }
        if(dt.Training_Event_City == null){
            dt.Training_Event_City = a.Training_Event_City__c;
        }
        if(dt.IB_Role_Name == null){
            dt.IB_Role_Name = a.IB_Role_Name__c;
        }
        if(dt.IB_Programme == null){
            dt.IB_Programme = a.IB_Programme__c;
        }
        if(dt.Start_Date == null){
            dt.Start_Date = a.Start_Date__c;
        }
        if(dt.End_Date == null){
            dt.End_Date = a.End_Date__c;
        }
        if(dt.Training_Event_Type == null){
            dt.Training_Event_Type = a.Training_Event_Type__c;
        }
        if(dt.Training_Event_Venue == null){
            dt.Training_Event_Venue = a.Training_Event_Venue__c;
        }
        if(dt.Training_Event_Status == null){
            dt.Training_Event_Status = a.Training_Event_Status__c;
        }
        if(dt.Application_Deadline == null){
            dt.Application_Deadline = a.Application_Deadline__c;
        }
        if(dt.Training_Pre_Requistes == null){
            dt.Training_Pre_Requistes = a.Training_Pre_Requistes__c;
        }
        if(dt.IB_Event == null){
            dt.IB_Event = a.IB_Event__c;
        }

        return dt;
        
    }


    class DataTranslateTraining {

        public String Id  {get; set;}
        public String Name {get; set;}
        public String Training_Event_Region {get; set;}
        public String Training_Event_Sub_Region {get; set;}
        public String Training_Event_Country {get; set;}
        public String Training_Event_City {get; set;}
        public String IB_Role_Name {get; set;}
        public String IB_Programme {get; set;}
        public Date Start_Date {get; set;}
        public Date End_Date {get; set;}
        public String Training_Event_Type {get; set;}
        public String Training_Event_Venue {get; set;}
        public String Training_Event_Status {get; set;}
        public Date Application_Deadline {get; set;}
        public String Training_Pre_Requistes {get; set;}
        public String IB_Event {get; set;}

    }

}