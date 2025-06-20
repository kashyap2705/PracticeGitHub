public class MyAssignmentDetailsController {
    
    
    
    public void updatereleasepermisionrequiredcon() {
        //  system.debug('permisionval==='+ permisionval);
    }
    
    public User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
    public String roleName = ApexPages.currentPage().getParameters().get('role');
    public Staffing_Event__c staffingEvent;
    public List<My_Staffing_Event__c> myAssignment {get; set;}
    public List<IB_Event_Role__c> availableRoles {get; set;}
    public IB_Event_Role__c role {get; set;}
    public IB_Event_Role__c reqs {get; set;}
    public IBActivity assignment{get; set;}
    
    public boolean DisplayError {get; set;}
    public String applicationStatus {get; set;}
    public String levelOfInterest {get; set;}
    public String withdrawalComments {get; set;}
    public String startdate {get; set;}
    public String enddate {get; set;}
    public String permisionval {get; set;}
    public String releasePermissionRequired {get; set;}
    public String releasePermissionRequiredAccept {get; set;}
    
    public List<SelectOption> selectedWithdrawalReasons{get;set;}        //Added by Shahrukh for ECM00637 on 18/07/2023
    private final My_Staffing_Event__c myStaffingEventObject;   //Added by Shahrukh for ECM00637 on 18/07/2023
    public String selectedWithdrawalReason{get;set;} //Added by kashyap ECM00694
    
    public String availableRoleId {get; set;}
    public String availableRoleName {get; set;}
    public String availableIBRole_c {get; set;}
    public String avilablepgm {get; set;}
    
    public String reqTraining {get; set;}
    public boolean hasInvitation;
    
    
    public String urlAction2 {get; set;}
    
    private String urlAction {get; set;}
    private String IBEventId;
    private Boolean applyForAssignment;
    public String staffingeventtypes {get;set;}
    public Boolean isConfirmed {get;private set;}
    public Boolean hasAdditinalNotes;
    @testvisible
    private Boolean isMyAssignment;
    
    public boolean showLocation{get;set;}
    
    // adding IB event list property to render on page
    public list<campaign> childIbEvents{get;set;}
    public boolean isChildEventExists{get;set;}
    
    public boolean isPLChildEventExists{get;set;}
    
    public boolean isProgrammeLeaderEvaluation{get;set;}
    public boolean isProgrammeLeaderConsultation{get;set;}
    public boolean isEvaluationLeaderEvaluation{get;set;}
    public boolean isEvaluationLeaderConsultation{get;set;}
    public list<My_Staffing_Event__c > childAssignments {get;set;}
    public list<Staffing_Event__c > childPLAssignment {get;set;}
    //public DataTranslateAssignment translatedAssignment {get;set;}
    
    public List<Campaign> relatedAffilatedEvents {get;set;}//added by kashyap 754 phase 3
    public boolean noAssignments{get;set;}//added by kashyap 754 phase 3
    public List<IBActivity> relatedEvents {get;set;}//added by kashyap 754 phase 3
    public String preliminaryReviewStartDate {get;set;}//added by kashyap 754 phase 3
    public string preliminaryReviewEndDate {get;set;}//added by kashyap 754 phase 3
    public boolean displayPreliminaryDates{get;set;}//added by kashyap 754 phase 3
    
   
    
    
    public PageReference reDirect() {
        
        List<Viewed_IBEN_Assignment__c> lstViewedAssig = [SELECT Community_User__c, IBEN_Assignment__c, Last_Access__c FROM Viewed_IBEN_Assignment__c
                                                          WHERE Community_User__c =: user.Id AND IBEN_Assignment__c =: ApexPages.currentPage().getParameters().get('Id')];
        
        if (!lstViewedAssig.isEmpty()) {
            lstViewedAssig[0].Last_Access__c = Date.today();
            update lstViewedAssig;
        }
        else {
            Viewed_IBEN_Assignment__c assignment = new Viewed_IBEN_Assignment__c(Community_User__c = user.Id, IBEN_Assignment__c = ApexPages.currentPage().getParameters().get('Id'),Last_Access__c = Date.today());
            insert assignment;
        }
        return null;
    }
    
    public MyAssignmentDetailsController() {
        noAssignments = false;//added by kashyap 754 phase 3
        displayPreliminaryDates = false;//added by kashyap 754 phase 3
       
        System.debug('----------------Assignment: ');
        isConfirmed = false;
        isPLChildEventExists = false;
        isChildEventExists = false;
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Test page messages.'));
        Cookie eligAssignments = new Cookie('eligAssignments-'+user.ContactId,'0',null,0,false);
        ApexPages.currentPage().setCookies(new Cookie[]{eligAssignments});
        System.debug('----------------Eligible Assignment: '+eligAssignments);
        myAssignment = new List<My_Staffing_Event__c>();
        System.debug('*****************************************************Assignment');
        assignment = loadAssignment(assignment);
        System.debug('Eligible Assignment: '+assignment);
        availableRoles = loadAvailableRoles();
        System.debug('Load Roles: '+availableRoles.size());
        isMyAssignment = checkIsMyAssignment();
        
        if (ApexPages.currentPage().getParameters().containsKey('action')) urlAction = ApexPages.currentPage().getParameters().get('action').toUpperCase();
        myAssignment = loadMyAssignment();
        
        //added by kashyap 754 phase 3
        if (myAssignment.size() > 0) {
    		applicationStatus = myAssignment[0].Application_Status__c;
		} else {
    		applicationStatus = null; 
		}
        
        applyForAssignment = false;
        reqTraining = null;
        if (!Test.isRunningTest()) reqs = IBActivity.loadIBEventAssignmentReqs(IBEventID);
        try{System.debug(myAssignment[0]);} catch (Exception ex) {}
        DisplayError = false;
        
        selectedWithdrawalReasons = new List<SelectOption>();            //Added by Shahrukh for ECM00637 on 18/07/2023
        relatedEvents=relatedCampaigns(); // added by kashyap 754 phase 3
       
    }
    /**added by kashyap 754 phase 3**/
    
    public  List<IBActivity> relatedCampaigns(){
        
        Set<Id> campaignId= new Set<Id>();
        List<Staffing_Event__c> staffingEventList =[select id,IB_Event__c from Staffing_Event__c where id=:ApexPages.currentPage().getParameters().get('Id') and 
                                                    IB_Event__r.Programme_Combination_Evaluation_Visits__c ='IB only - Affiliated' and IB_Event__r.ParentId=''];
        for(Staffing_Event__c c : staffingEventList){
            campaignId.add(c.IB_Event__c);
        }
        List<Staffing_Event__c> publishedStaffingEvents=[select id, IB_Event__c,End_Date__c, Start_Date__c, Name,IB_Event__r.Name,(select IB_Role_Name__c,IB_Role_Name_fr__c,IB_Role_Name_es__c from IB_Event_Roles__r ) from Staffing_Event__c where IB_Event__r.parentId in : campaignId];
        if(publishedStaffingEvents.isEmpty()){
            noAssignments= true;
            return null;
        }else{
            noAssignments= false;
            system.debug('publishedStaffingEvents**'+publishedStaffingEvents);
            return  IBActivity.publishedStaffingEvent(publishedStaffingEvents);//convertEligAssignmentDetails
            
        }
        
    }

    /**added by kashyap 754 phase 3**/
    
    public boolean getHasInvitation() {
        System.debug('applicationStatus: ' + applicationStatus);
        if (applicationStatus == Label.IBENPortal_shared_Invited) return true;
        else return false;
    }
    public boolean gethasAdditinalNotes() {
        if(reqs.Special_Requistes_Additional_Notes__c!=null)return true;
        return false;
    }
    
    public PageReference acceptInvitation() {
        try{
            // System.debug('releasePermissionRequiredAccept '+ releasePermissionRequiredAccept );
            myAssignment[0].Invitation_Response__c = 'Accepted';
            myAssignment[0].Invitation_Response_Date__c = Date.today();
            myAssignment[0].Application_Status__c = 'Confirmed';
            // myAssignment[0].Release_Permission_Required__c = permisionval;
            upsert myAssignment[0];
            
            myAssignment = loadMyAssignment();
            String url = '/MyAssignments';
            PageReference view = new PageReference (url);
            view.setRedirect(true);
            return view;
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
            return null;
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
        }
        return null;
    }
    
    public PageReference declineInvitation() {
        
        try {
            myAssignment[0].Invitation_Response__c = 'Declined';
            myAssignment[0].Application_Status__c = 'Invitation Declined';
            upsert myAssignment[0];
            
            myAssignment = loadMyAssignment();
            String url = '/MyAssignments';
            PageReference view = new PageReference (url);
            view.setRedirect(true);
            return view;
        }
        catch (DmlException ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
        }
        return null;
    }
    
    public String getRoleName() {
        return roleName;
    }
    
    public void sendRoleIdDataToController() {
        applyForAssignment = true;
        System.debug('releasePermissionRequiredAccept11 '+ releasePermissionRequiredAccept );
    }
    
    public void updateReleasePermissionRequired() {
        System.debug('*****with update, releasePermissionRequired is ' + releasePermissionRequired);
    }
    
    public List<SelectOption> getReleasePermissionItems() {
        return IBActivity.getReleasePermissionItems();
    }
    
    public List<SelectOption> getInterestLevelItems() {
        return IBActivity.getInterestLevelItems();
    }
    
    public Boolean getShowAssignmentApplication() {
        if (applyForAssignment) return true;
        return false;
    }
    
    public Boolean getIsMyAssignment() {
        if (isMyAssignment) return true;
        return false;
    }
    
    public Boolean getUrlActionEdit() {  //return true only if there is no Invitation to accept or just accepted
        if (urlAction == 'EDIT') return true;
        return false;
    }
    
    //****TO DO: update the if-checks on this (see MyTrainingDetails.page)
    public Boolean getShowGeneralInstructions() {
        //don't display if any are true
        if (!isMyAssignment && myAssignment.isEmpty() && !getUrlActionEdit()) return true;
        return false;
    }
    
    public Boolean getHasAssignmentPrereqs() {
        if (reqs != null) {
            if (IBActivity.hasIBEventRequirements(reqs)) return true;
        }
        return false;
    }
    
    public Boolean getHasLanguageProficiency() {
        if (reqs.Proposed_Language__c != null) return true;
        return false;
    }
    
    public Boolean getHasSpokenProficiency() {
        if (reqs.Proposed_Spoken_Proficiency__c != null) return true;
        return false;
    }
    
    public Boolean getHasWrittenProficiency() {
        if (reqs.Proposed_Written_Proficiency__c != null) return true;
        return false;
    }
    
    public Boolean getHasYearsIBExperience() {
        if (reqs.Proposed_years_of_IB_Experience__c != null) return true;
        return false;
    }
    
    //Added by Shahrukh for ECM00637 on 18/07/2023 -- START --
    public List<SelectOption> getWithdrawalReasons() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = My_Staffing_Event__c.WithdrawalReason__c.getDescribe();
        //ECM00694 WithdrawalReason__c(Single Select) changed from Withdrawal_Reason__c(Multiselect)
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getValue() , f.getLabel()));
        }
        SelectOptionSorter.doSort(options, SelectOptionSorter.FieldToSort.Label);
        options.add(0, new SelectOption('--None--' , '--None--')); //Added by kashyap for ECM00694  to make it a single picklist dropdown
        return options;
    }
    //Added by Shahrukh for ECM00637 on 18/07/2023 -- END --
    
    private List<My_Staffing_Event__c> loadMyAssignment() {
        List<My_Staffing_Event__c> myAssign = new List<My_Staffing_Event__c>();
        
        myAssign = [SELECT toLabel(WithdrawalReason__c), Withdrawal_Argumentation__c, toLabel(Level_of_Interest__c), Id, IB_Event__c, toLabel(Application_Status__c)
                    FROM My_Staffing_Event__c
                    Where Staffing_Event__c =: ApexPages.currentPage().getParameters().get('Id')
                    And IB_Contact__c = :user.ContactId
                    LIMIT 1];
        //ECM00694 WithdrawalReason__c(Single Select) changed from Withdrawal_Reason__c(Multiselect)
        if (myAssign.size() == 1 && string.isNotBlank(myAssign[0].IB_Event__c)) {
            IBEventID = myAssign[0].IB_Event__c;
            
            // this query is edited by developer Ali Haider Bajwa-plumlogix for user story 12160 of staff aug project-->
            //start 
            //added IB_Event__r.Event_Organizer_Account__r.Name in soql by kashyap as part of ECM 00524
            childAssignments = [SELECT Id,IB_Event__r.Event_Organizer_Account__r.Name, Staffing_Event_Status__c, IB_Event__c, Name, Staffing_Event__c, IB_Role_Name__c, Staffing_Event__r.Name, Application_Status__c,Start_Date__c,End_Date__c
                                FROM My_Staffing_Event__c Where IB_Event__r.parentId =: myAssign[0].IB_Event__c and (IB_Event__r.bundle__c = true) and IB_Contact__c = :user.ContactId];
            
            system.debug('--child Assignments List--'+childAssignments );
            //end
            list<IB_Role__c> ibRoles = [SELECT IB_Role__c FROM IB_Role__c Where IB_Contact__c = :user.ContactId and Status__c = 'Confirmed' and IB_Role_Name__c in ('Reader','Course Outline Reader','Programme Leader')];
            
            if (!childAssignments.isempty() && !ibRoles.isEmpty()) isChildEventExists = true;
            else isChildEventExists = false;
        }
        
        return myAssign;
    }
    
    
    private IBActivity loadAssignment(IBActivity assign) {
        // this code is edited by developer Ali Haider Bajwa-plumlogix for user story 12160 of staff aug project
        
        // this query is edited by developer Ali Haider Bajwa-plumlogix for user story 11741 of staff aug project
        try{ 
            //added IB_Event__r.Event_Organizer_Account__r.Name in soql by kashyap as part of ECM 00524
            //Added IB_Event__r.Programme_Relationship_Manager__c by Suraj as part of ECM00651
            //IB_Event__r.Preliminary_Review_Start_Date__c ,IB_Event__r.Preliminary_Review_End_Date__c  from ECM00754-phase 3 by kashyap 
            staffingEvent = [SELECT Id,IB_Event__r.Preliminary_Review_Start_Date__c ,IB_Event__r.Preliminary_Review_End_Date__c , IB_Event__r.Event_Organizer_Account__r.Name,Event_Organizer__c, Event_Organizer__r.name, Start_Date__c,toLabel(IB_Event__r.Audience__c), Staffing_Event_Region__c,IB_Programme_french__c,IB_Programme_spanish__c, Staffing_Event_Country__c, Staffing_Event_City__c, Staffing_Event_State__c, Programme_s__c, End_Date__c, Name, IB_Event__r.RecordType.Name,
                             Staffing_Event_Language_1__c, Staffing_Event_Language_2__c, Category__c, Subject__c, Staffing_Event_Venue__c, Staffing_Event_Sub_Region__c, IB_Event__c,IB_Event__r.Delivery_Mode__c,IB_Event__r.IB_Docs_ID__c,IB_Event__r.Programme_Combination_Evaluation_Visits__c,IB_Event__r.Type,IB_Event__r.Event_Language__c,IB_Event__r.Sub_Type__c,IB_Event__r.Programme_Relationship_Manager__c
                             FROM Staffing_Event__c                             
                             WHERE Id = :ApexPages.currentPage().getParameters().get('Id') LIMIT 1];           
            if (staffingEvent.IB_Event__r.RecordType.Name == 'IBEN Parent Reader Event') showLocation = false;
            else showLocation = true;
            if(roleName == null)
                roleName = ApexPages.currentPage().getParameters().get('roleID');
            
            system.debug('--- roleName : '+roleName);
            
            /** added as part of 754 phase 3 by kashyap **/
            IF(staffingEvent.IB_Event__r.RecordType.Name=='Evaluation' && staffingEvent.IB_Event__r.Programme_Combination_Evaluation_Visits__c != 'IB only - Affiliated'){
                displayPreliminaryDates= true;
            } 
            /** added as part of 754 phase 3 by kashyap **/
            
            IF(roleName.contains('Evaluation Leader'))
                
            {
                IF(staffingEvent.IB_Event__r.RecordType.Name=='Evaluation' && (staffingEvent.IB_Event__r.Type=='Evaluation' && (staffingEvent.IB_Event__r.Sub_Type__c=='Evaluation Visit' || staffingEvent.IB_Event__r.Sub_Type__c=='Multiple Programme Evaluation Visit')) || (staffingEvent.IB_Event__r.Type=='Consultation' && (staffingEvent.IB_Event__r.Sub_Type__c=='Authorization Follow Up' || staffingEvent.IB_Event__r.Sub_Type__c=='Evaluation Follow Up' || staffingEvent.IB_Event__r.Sub_Type__c=='Return Visit' || staffingEvent.IB_Event__r.Sub_Type__c=='Programme Development Support Visit') ) )
                {
                    IF(staffingEvent.IB_Event__r.IB_Docs_ID__c!='2014')
                    {
                        isEvaluationLeaderEvaluation= true;
                    }
                }
            }
            // Added an OR condition for Authorization by Atticus as part of ECM00651 on 22-11-2023
            if(staffingEvent.IB_Event__r.RecordType.Name=='Authorization' && staffingEvent.IB_Event__r.Type=='Authorization'){
                isEvaluationLeaderEvaluation= true;
            }
            
            /** Added aspart of phase 3 by kashyap**/
             if(staffingEvent.IB_Event__r.RecordType.Name=='Evaluation' && staffingEvent.IB_Event__r.Programme_Combination_Evaluation_Visits__c=='IB only - Affiliated'){
                isEvaluationLeaderEvaluation= true;
            }
            /** Added aspart of phase 3 by kashyap**/
            
            IF(roleName.contains('Programme Leader'))
                
            {
                IF(staffingEvent.IB_Event__r.RecordType.Name=='Evaluation' && (staffingEvent.IB_Event__r.Type=='Evaluation' && (staffingEvent.IB_Event__r.Sub_Type__c=='Evaluation Visit'|| staffingEvent.IB_Event__r.Sub_Type__c=='Multiple Programme Evaluation Visit'|| staffingEvent.IB_Event__r.Sub_Type__c=='Evaluation Reading'|| staffingEvent.IB_Event__r.Sub_Type__c=='Preliminary Review')) || (staffingEvent.IB_Event__r.Type=='Consultation' && (staffingEvent.IB_Event__r.Sub_Type__c=='Authorization Follow Up' || staffingEvent.IB_Event__r.Sub_Type__c=='Evaluation Follow Up' || staffingEvent.IB_Event__r.Sub_Type__c=='Return Visit' || staffingEvent.IB_Event__r.Sub_Type__c=='Programme Development Support Visit') ) )
                {
                    IF(staffingEvent.IB_Event__r.IB_Docs_ID__c!='2014')
                    {
                        isProgrammeLeaderEvaluation=true;
                        
                        isEvaluationLeaderEvaluation = false;
                        
                    }
                }
            }
            //end
            IBEventID = staffingEvent.IB_Event__c;
            assign = IBActivity.convertEligAssignmentDetails(staffingEvent);
            
             /** Added aspart of phase 3 by kashyap**/
            system.debug('--- assign : '+assign);
            
            if(staffingEvent.IB_Event__r.Preliminary_Review_Start_Date__c != null){
            assign.PreliminaryReviewStartDateString=  staffingEvent.IB_Event__r.Preliminary_Review_Start_Date__c.format();// added as part of phase 3
            }
            if(staffingEvent.IB_Event__r.Preliminary_Review_End_Date__c != null){
            assign.PreliminaryReviewEndDateString=staffingEvent.IB_Event__r.Preliminary_Review_End_Date__c.format();// added as part of phase 3
            }
             /** Added aspart of phase 3 by kashyap**/
            
            // Added for populated the correct program for the user when it is a multiprogram IB event
            list<My_Staffing_Event__c>  myAssignmentsList = new list<My_Staffing_Event__c>(); 
            myAssignmentsList = [SELECT Id,Staffing_Event_Status__c, IB_Event__c, Name, Staffing_Event__c, 
                                 IB_Role_Name__c, Staffing_Event__r.Name, Application_Status__c,
                                 Start_Date__c,End_Date__c,Programme_From_Event_Role__c 
                                 FROM My_Staffing_Event__c 
                                 WHERE Staffing_Event__c =: ApexPages.currentPage().getParameters().get('Id') AND 
                                 IB_Contact__c = :user.ContactId limit 1];
            // if(myAssignmentsList != NULL){
           if(!myAssignmentsList.isEmpty()){
                assign.Programme = myAssignmentsList[0].Programme_From_Event_Role__c;
                
            }
            // ****query to get IB Child Events***
            system.debug('--- staffingEvent.IB_Event__c : '+staffingEvent.IB_Event__c);
            
            if (string.isNotBlank(staffingEvent.IB_Event__c) &&
             !roleName.contains('Programme Leader')) {
                
                // this query is edited by developer Ali Haider Bajwa-plumlogix for user story 11741 of staff aug project
                //start 
                childAssignments = [SELECT Id, Staffing_Event_Status__c, IB_Event__c, Name, Staffing_Event__c, IB_Role_Name__c, Staffing_Event__r.Name, Application_Status__c,Start_Date__c,End_Date__c FROM My_Staffing_Event__c WHERE IB_Event__r.parentId =: staffingEvent.IB_Event__c AND IB_Event__r.bundle__c = true AND IB_Contact__c = :user.ContactId];
                system.debug('--child Assignments List--'+childAssignments );
                //end
                list<IB_Role__c> ibRoles = [SELECT IB_Role__c FROM IB_Role__c WHERE IB_Contact__c = :user.ContactId AND Status__c = 'Confirmed' AND IB_Role_Name__c = 'Reader'];
                
                if(!childAssignments.isempty() && !ibRoles.isEmpty()) isChildEventExists = true;
                else isChildEventExists = false;
            }
            else if(string.isNotBlank(staffingEvent.IB_Event__c) && roleName.contains('Programme Leader')){
                childPLAssignment = [SELECT Id, Staffing_Event_Status__c, IB_Event__c, Name,Start_Date__c,End_Date__c FROM Staffing_Event__c WHERE IB_Event__r.parentId =: staffingEvent.IB_Event__c];
                if(!childPLAssignment.isempty()) isPLChildEventExists = true;
                else isPLChildEventExists = false;
            }
        }
        catch(Exception ex){
            System.debug('ERROR: ' + ex + 'lno:'+ ex.getlineNUmber());
        }
        
        return assign;
    }
    
    public List<IB_Event_Role__c> loadAvailableRoles() {
        List<IB_Event_Role__c> roles = new List<IB_Event_Role__c>();
        
        List<IB_Role__c> roleApps = new List<IB_Role__c>();
        
        roleApps = [SELECT IB_Role__c, IB_Role_Name__c,IB_Role_Programme_Combo__c FROM IB_Role__c
                    WHERE IB_Contact__c = :user.ContactId
                    AND Status__c = 'Confirmed'];
        
        Set<ID> roleIds = new Set<ID>();
        Set<String> roleProgrammeCombo = new Set<String>();
        Set<String> roleNames = new Set<String>();
        
        for(IB_Role__c r : roleApps){
            roleIds.add(r.IB_Role__c);
            roleProgrammeCombo.add(r.IB_Role_Programme_Combo__c);
            roleNames.add(r.IB_Role_Name__c);
        }
        System.debug('Role ID: '+roleIds.size()+' '+roleIds);
        
        System.debug('Role roleProgrammeCombo: '+roleProgrammeCombo);
         System.debug('Role id  '+ApexPages.currentPage().getParameters().get('Id'));
        
        /** Added as part of 753-phase 3 by kashyap**/
        List<My_Staffing_Event__c> withdrawnRoles=[select Application_Status__c, IB_Role_Name__c ,IB_Event_Role__c  , IB_Event_Role__r.IB_Role_Programme_Combo__c from My_Staffing_Event__c where 
                                                   Staffing_Event__c =:ApexPages.currentPage().getParameters().get('Id')  and 
                                                   IB_Contact__c =: user.ContactId
                                                  ];//and (Application_Status__c='Withdrawn by IB' or Application_Status__c='Withdrawn')
        Set<String>  withDrawnRoleProgCombo = new Set<String>();  
        
        if(!withdrawnRoles.isEmpty()){
            for(My_Staffing_Event__c myStaffEvent: withdrawnRoles){
                if(roleProgrammeCombo.contains(myStaffEvent.IB_Event_Role__r.IB_Role_Programme_Combo__c)) {
                    roleProgrammeCombo.remove(myStaffEvent.IB_Event_Role__r.IB_Role_Programme_Combo__c);
                }
            }
        }
         /** Added as part of 753-phase 3 by kashyap**/
        
        
        roles = [SELECT Id, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c,IB_Programme__c, Positions_Left__c, Staffing_Event__c, IB_Role__c, IB_Role_Programme_Combo__c
                 FROM IB_Event_Role__c
                 WHERE Staffing_Event__c = :ApexPages.currentPage().getParameters().get('Id')
                 AND IB_Role__c in :roleIds
                 AND Positions_Left__c > 0
                 AND IB_Role_Programme_Combo__c in :roleProgrammeCombo];
        System.debug('Role: '+roles.size()+' '+roles);
        return roles;
    }
    
    private Boolean checkIsMyAssignment() {
        List<My_Staffing_Event__c> myAssign = [SELECT Id, Application_Status__c, Staffing_Event_Type__c FROM My_Staffing_Event__c WHERE IB_Contact__c = :user.ContactId AND Staffing_Event__c = :ApexPages.currentPage().getParameters().get('Id')];
        
        system.debug('---myAssign--'+myAssign);
        if(!myAssign.isEmpty()){
            
            if(myAssign[0].Application_Status__c == 'Confirmed'){
                isConfirmed = true;
                return true;// added as part of phase 3 754 by kashyap
            }
            // return true;
            return false;
        }
        else return false;
    }
    
    public PageReference isLoggedIn() {
        if (UserInfo.getUserType() == 'Guest') return new PageReference('/educator/siteHomePage');
        return null;
    }
    
    public PageReference SubmitApplication() {
        try{
            system.debug('user.ContactId==='+user.ContactId);
            system.debug('availableIBRole_c==='+ availableIBRole_c);
            
            list<Staffing_Event__c> eventC=[select Staffing_Event_Type__c from Staffing_Event__c where id = :ApexPages.currentPage().getParameters().get('Id')];
            IB_Role__c myRoles = [Select id, IB_Role_Name__c, Status__c From IB_Role__c where IB_Contact__c = :user.ContactId AND IB_Role__r.id = :availableIBRole_c LIMIT 1];
            System.debug('Roles Value: '+ApexPages.currentPage().getParameters().get('Id')+'  '+myRoles);
            if( eventC[0].Staffing_Event_Type__c== 'Request for Candidacy' || eventC[0].Staffing_Event_Type__c=='Request for authorization' ){
                
                List<My_Staffing_Event__c> recordlist = [Select id from My_Staffing_Event__c where ( Staffing_Event_Type__c = 'Request for candidacy' OR Staffing_Event_Type__c = 'Request for authorization' ) AND application_status__c = 'Confirmed' AND ( Staffing_Event_Status__c = 'Confirmed' OR Staffing_Event_Status__c = 'Staffed' ) And End_Date__c >= TODAY AND IB_Contact__c= :user.ContactId];
                System.debug('Size: '+recordlist.size());
                
                
                if(recordlist.size() < 3) {
                    My_Staffing_Event__c newAssignment = new My_Staffing_Event__c(IB_Contact__c = user.ContactId, Level_of_Interest__c='Interested', Application_Status__c='Confirmed',  Staffing_Event__c=ApexPages.currentPage().getParameters().get('Id'), Release_Permission_Requested__c=false, IB_Event_Role__c=availableRoleId, IB_Role__c=availableIBRole_c, My_Role__c = myRoles.id);
                    //Staffing_Event__c=ApexPages.currentPage().getParameters().get('Id'), Release_Permission_Required__c = permisionval,
                    insert newAssignment;
                    
                    Staffing_Event__c Ass=[select id , name, IB_Event__C from staffing_event__c where id =: ApexPages.currentPage().getParameters().get('Id')];
                    
                    campaign cm= [select id , name, Status from campaign where id =:Ass.IB_Event__C];
                    cm.Status = 'Staffed' ;  
                    update cm;
                }
                else
                {
                    DisplayError = true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.AFC_and_AFA_reading_error));
                }
            }
            else if( eventC[0].Staffing_Event_Type__c== 'Course Outline Reading' )/* For Course Outline events */
            {
                
                List<My_Staffing_Event__c> recordlist = [Select id from My_Staffing_Event__c where  ( Staffing_Event_Type__c = 'Course Outline Reading' )  AND application_status__c = 'Confirmed' AND ( Staffing_Event_Status__c = 'Confirmed' OR Staffing_Event_Status__c = 'Staffed' ) And End_Date__c >= TODAY AND IB_Contact__c= :user.ContactId];
                System.debug('Size: '+recordlist.size());
                
                
                if(recordlist.size() < 10) {
                    My_Staffing_Event__c newAssignment = new My_Staffing_Event__c(IB_Contact__c = user.ContactId, Level_of_Interest__c='Interested', Application_Status__c='Confirmed',  Staffing_Event__c=ApexPages.currentPage().getParameters().get('Id'), Release_Permission_Requested__c=false, IB_Event_Role__c=availableRoleId, IB_Role__c=availableIBRole_c, My_Role__c = myRoles.id);
                    //Staffing_Event__c=ApexPages.currentPage().getParameters().get('Id'), Release_Permission_Required__c = permisionval,
                    insert newAssignment;
                    
                    Staffing_Event__c Ass=[select id , name, IB_Event__C from staffing_event__c where id =: ApexPages.currentPage().getParameters().get('Id')];
                    
                    campaign cm= [select id , name, Status from campaign where id =:Ass.IB_Event__C];
                    cm.Status = 'Staffed' ;  
                    update cm;
                }
                else
                {
                    DisplayError = true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.Course_outline_reading_error));
                }
                
                
            }
            else
            {
                My_Staffing_Event__c newAssignment = new My_Staffing_Event__c(IB_Contact__c = user.ContactId, Level_of_Interest__c='Interested', Application_Status__c='Pending Selection', Staffing_Event__c=ApexPages.currentPage().getParameters().get('Id'), Release_Permission_Requested__c=false, IB_Event_Role__c=availableRoleId, IB_Role__c=availableIBRole_c, My_Role__c = myRoles.id);
                //Staffing_Event__c=ApexPages.currentPage().getParameters().get('Id'), Release_Permission_Required__c = permisionval,
                
                insert newAssignment;
                DisplayError = false;
            }
            
            if(DisplayError == false)
            {
                PageReference view = new PageReference ('/MyAssignments');
                view.setRedirect(true);
                return view;
            }
            
        }
        
        catch (System.DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i++) {
                System.debug('ERROR: ' + e.getDmlMessage(i));
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
            //SubmitApplication();
            
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
            System.debug(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage())); 
        }
        return null;
    }
    
    /*
public PageReference saveWithdrawal(){
try{
myAssignment[0].Level_of_Interest__c = levelOfInterest;
myAssignment[0].Application_Status__c = 'Withdraw Interest';
myAssignment[0].Date_Withdrawn__c = Date.today();
myAssignment[0].WithdrawalReason__c = withdrawalReason; //ECM00694 WithdrawalReason__c(Single Select) changed from Withdrawal_Reason__c(Multiselect)
myAssignment[0].Withdrawal_Argumentation__c = withdrawalComments;

//System.debug('at saveWithdrawal, myAssignment[0] is ' + myAssignment[0]);

upsert myAssignment[0];

String url = '/MyAssignments';
PageReference view = new PageReference (url);
view.setRedirect(true);
return view;
}
catch (System.DmlException e) {
for (Integer i = 0; i < e.getNumDml(); i++) {
System.debug('***ERROR: ' + e.getDmlMessage(i));
ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getDmlMessage(i)));
if (e.getDmlMessage(i).contains('Unique_Application__c')) {
ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getDmlMessage(i)));
}
else {
ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getDmlMessage(i)));
}
}
return null;
}
catch (Exception ex) {
System.debug('***ERROR: ' + ex.getMessage());
ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));

return null;
}

return null;
}
*/
    public PageReference saveWithdrawal() {
        
        string logTag = '[saveWithdrawal]';
        
        try{
            
            Campaign ibEvent = [select Name, Sub_Type__c, Id, Status, StartDate from Campaign where Id = :myAssignment[0].IB_Event__c];
            System.debug(logTag + 'Withdrawing ' + UserInfo.getName() + ' from event ' + ibEvent.Id);
            
            // Check if the Event starts within 2 weeks, if it does, the user cannot withdraw.
            if (Date.today().addDays(14) > ibEvent.StartDate && ibEvent.Sub_Type__c != 'Request for authorization'&& ibEvent.Sub_Type__c != 'Request for Candidacy' && ibEvent.Sub_Type__c != 'Course Outline Reading' ) {
                System.debug(logTag + 'Event cannot be withdrawn, startDate within 2 weeks.');
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, Label.IBENPortal_withdrawal_too_close_to_event_start) );
                return null;
                
            }
            else{  
                // Update the My Assignment (new) record's Status to "Withdrawn"
                myAssignment[0].Level_of_Interest__c = levelOfInterest;
                myAssignment[0].Application_Status__c = 'Withdrawn';
                myAssignment[0].Date_Withdrawn__c = Date.today();
                myAssignment[0].Withdrawal_Argumentation__c = withdrawalComments;
                myAssignment[0].WithdrawalReason__c = selectedWithdrawalReason;// added by kashyap ECM00694
                
                //Added by Shahrukh for ECM00637 on 19/07/2023 -- START --
                /**
                 * Commnetd by kashyap ECM00694
                 * if(selectedWithdrawalReasons.size() > 0){
                    String reason='';
                    for(SelectOption option : selectedWithdrawalReasons){
                        reason += option.getValue()+';';
                    }
                    myAssignment[0].WithdrawalReason__c = reason; //ECM00694 WithdrawalReason__c(Single Select) changed from Withdrawal_Reason__c(Multiselect)
                }**/
                //Added by Shahrukh for ECM00637 on 19/07/2023 -- END --
                
                upsert myAssignment[0];
            }
            /*
michael.demeglio - Logic moved to Process "Educator Withdrawn from Event" 3/14/2016 to ensure that IB Event's status would be updated whether the
educator withdrew (Application_Status__c = 'Withdrawn') or IB Staff withdrew them (Application_Status__c = 'Withdrawn by IB').

// Update the Event's status - TODO: MOVE TO A TRIGGER / FLOW
ibEvent.Status = 'Planned / Ready for Staffing';
update(ibEvent);
System.debug(logTag + 'Event updated to status of Planned Ready for Staffing');
*/
            
            
            // Find all followers
            List<EntitySubscription> followers = [select id, subscriberid, subscriber.email, subscriber.name from EntitySubscription where parentid = :ibEvent.Id];
            if (!followers.isEmpty()) {
                String[] userIds = new String[]{};
                    
                    // CREATE A TASK FOR FOLLOWERS
                    List<Task> taskList = new List<Task>();
                String[] toAddresses = new String[]{};
                    for(EntitySubscription es : followers) {
                        toAddresses.add(es.Subscriber.Email); // Add each follower to the email recipients list
                        
                        // Create a task for each follower
                        taskList.add(new Task(WhatId = ibEvent.Id, OwnerId = es.SubscriberId, Type = 'Other', Description = 'Educator ' + UserInfo.getName() + ' has withdrawn from event ' + ibEvent.Name, Subject = 'Educator withdrawal from event'));
                    }
                
                System.debug(logTag + 'Creating ' + taskList.size() + ' tasks for IB Event ' + ibEvent.Id);
                if(!taskList.isEmpty()) insert(taskList);
                
                // Send email
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                msg.setToAddresses(toAddresses);
                msg.setSubject('Withdrawal notification for ' + ibEvent.Name);
                msg.setPlainTextBody(UserInfo.getName() + ' has withdrawn from ' + ibEvent.Name);
                
                try{
                    Messaging.sendEmail(new Messaging.Email[] {msg});
                } catch (Exception ex){
                    System.debug(logTag + 'Error sending mass email for Withdrawal notification: ' + ex.getMessage());
                }
                
            }
            
            // Redirect to MyAssignments
            String url = '/MyAssignments';
            PageReference view = new PageReference (url);
            view.setRedirect(true);
            return view;
            
            
        } catch (System.DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i++) {
                System.debug(logTag + '***ERROR: ' + e.getDmlMessage(i));
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getDmlMessage(i)));
            }
        } catch (Exception ex) {
            System.debug(logTag + '***ERROR: ' + ex.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
        }
        
        return null;
    }
    
    public PageReference cancel() {
        String url = urlAction2;
        PageReference view = new PageReference (url);
        view.setRedirect(true);
        return view;
    }
    
    public String getUserLanguageKey() {
        return UserInfo.getLanguage();
    }
    
    public IB_Application_Feedback__c getLinkForApplicationFeedback() {
        //My_Assignments_Lookup__r.Staffing_Event__c = :ApexPages.currentPage().getParameters().get('Id')
        
        List<My_Staffing_Event__c> thisEvent = [SELECT Staffing_Event__r.Related_Programme__c
                                                FROM My_Staffing_Event__c
                                                WHERE Staffing_Event__c = :ApexPages.currentPage().getParameters().get('Id')
                                                AND Application_Status__c = 'Confirmed'
                                                AND Staffing_Event__r.Event_Type__c = 'Reader'
                                                AND Staffing_Event__r.Sub_Type__c = 'Request for Candidacy'
                                                AND IB_Contact__c = :user.ContactId];
        
        if (thisEvent.size() > 0) {
            // Need to modify this query so that the feedback application is only returned for the programme if it is "active" or "not submitted"
            List<IB_Application_Feedback__c> appFeedback = [SELECT ID FROM IB_Application_Feedback__c
                                                            WHERE IB_Programme_Lookup__c = :thisEvent[0].Staffing_Event__r.Related_Programme__c
                                                            AND Status__c != 'Submitted'];
            system.debug('App Feedback: ' + appFeedback);
            if(appFeedback.size() > 0) return appFeedback[0];
            return new IB_Application_Feedback__c();
        }
        else {
            return new IB_Application_Feedback__c();
        }
    }
    
    public Auth_Feedback__c getLinkForAFAFeedback() {
        //My_Assignments_Lookup__r.Staffing_Event__c = :ApexPages.currentPage().getParameters().get('Id')
        
        List<My_Staffing_Event__c> thisEvent = [SELECT Staffing_Event__r.Related_Programme__c
                                                FROM My_Staffing_Event__c
                                                WHERE Staffing_Event__c = :ApexPages.currentPage().getParameters().get('Id')
                                                AND Application_Status__c = 'Confirmed'
                                                AND Staffing_Event__r.Event_Type__c = 'Reader'
                                                AND Staffing_Event__r.Sub_Type__c = 'Request for authorization'
                                                AND IB_Contact__c = :user.ContactId];
        
        if (thisEvent.size() > 0) {
            // Need to modify this query so that the feedback application is only returned for the programme if it is "active" or "not submitted"
            List<Auth_Feedback__c> appFeedback = [SELECT ID FROM Auth_Feedback__c
                                                  WHERE IB_Programme__c = :thisEvent[0].Staffing_Event__r.Related_Programme__c
                                                  AND Status__c not in ('Submitted','Published')];
            system.debug('App Feedback: ' + appFeedback);
            if(appFeedback.size() > 0) return appFeedback[0];
            return new Auth_Feedback__c();
        }
        else {
            return new Auth_Feedback__c();
        }
    }    
    
    public IB_Consultant_Feedback__c getLinkForConsultantFeedback() {
        //My_Assignments_Lookup__r.Staffing_Event__c = :ApexPages.currentPage().getParameters().get('Id')
        
        List<My_Staffing_Event__c> thisEvent = [SELECT Staffing_Event__r.Related_Programme__c
                                                FROM My_Staffing_Event__c
                                                WHERE Staffing_Event__c = :ApexPages.currentPage().getParameters().get('Id')
                                                AND Staffing_Event__r.Event_Type__c = 'Consultant'
                                                AND Application_Status__c = 'Confirmed'
                                                AND IB_Contact__c = :user.ContactId];
        
        if (thisEvent.size() > 0) {
            // Need to modify this query so that the feedback application is only returned for the programme if it is "active" or "not submitted"
            List<IB_Consultant_Feedback__c> appFeedback = [SELECT ID,IB_Application__c, Assignment_ID__c FROM IB_Consultant_Feedback__c
                                                           WHERE IB_Programme_Lookup__c = :thisEvent[0].Staffing_Event__r.Related_Programme__c
                                                           AND Status__c not in ('Submitted','Published')];
            system.debug('App Feedback: ' + appFeedback);
            if(appFeedback.size() > 0) {
                return appFeedback[0];
            }
            return new IB_Consultant_Feedback__c();
        }
        else {
            return new IB_Consultant_Feedback__c();
        }
    }
    // this code is edited by developer ali haider bajwa-plumlogix for US-11987 in staff aug project
    // start
    public My_Staffing_Event__c getLinkForBQCEventFeedback() {
        //My_Assignments_Lookup__r.Staffing_Event__c = :ApexPages.currentPage().getParameters().get('Id')
        
        List<My_Staffing_Event__c> thisEvent = [SELECT ID,Staffing_Event__r.Related_Programme__c,IB_Event__r.BQC_Status__c,IB_Role__r.Role_Name__c FROM My_Staffing_Event__c WHERE Staffing_Event__c = :ApexPages.currentPage().getParameters().get('Id') AND Application_Status__c = 'Confirmed' AND IB_Contact__c = :user.ContactId];
        
        if (thisEvent.size() > 0) {
            if(thisEvent[0].IB_Role__r.Role_Name__c == 'Building Quality Curriculum Reviewer' && thisEvent[0].IB_Event__r.BQC_Status__c =='Pending Feedback from Reviewer') 
                return thisEvent[0];
            if(thisEvent[0].IB_Role__r.Role_Name__c == 'Building Quality Curriculum Senior Reviewer' && thisEvent[0].IB_Event__r.BQC_Status__c =='Pending Feedback from Senior Reviewer')
                return thisEvent[0];
            if(thisEvent[0].IB_Role__r.Role_Name__c == 'Building Quality Curriculum School Reviewer' && thisEvent[0].IB_Event__r.BQC_Status__c =='Pending Feedback from School Reviewer')
                return thisEvent[0];
            // Need to modify this query so that the feedback application is only returned for the programme if it is "active" or "not submitted"
            /*  List<IB_Consultant_Feedback__c> appFeedback = [SELECT ID,IB_Application__c, Assignment_ID__c FROM IB_Consultant_Feedback__c
WHERE IB_Programme_Lookup__c = :thisEvent[0].Staffing_Event__r.Related_Programme__c
AND Status__c not in ('Submitted','Published')];
system.debug('App Feedback: ' + appFeedback);
if(appFeedback.size() > 0) {
return appFeedback[0];
}
return new IB_Consultant_Feedback__c();
}
else {
return new IB_Consultant_Feedback__c();
}*/
        }
        
        
        return  Null;
        
    }
    //end
    public String getLinkForCourseOutlineReader() {
        
        List<My_Staffing_Event__c> thisEvent = [
            SELECT Staffing_Event__c, Staffing_Event__r.Related_Programme__c, Staffing_Event__r.Related_Subject__c, Staffing_Event__r.Course_Outline_Reading__c 
            FROM My_Staffing_Event__c
            WHERE Staffing_Event__c = :ApexPages.currentPage().getParameters().get('Id')
            AND Staffing_Event__r.Event_Type__c = 'Course Outline Reader'
            AND Application_Status__c = 'Confirmed'
            AND IB_Contact__c = :user.ContactId
        ];
        
        Staffing_Event__c staffEvent = [
            SELECT Id, Name, Course_Outline_Reading__c 
            FROM Staffing_Event__c 
            WHERE Id = :ApexPages.currentPage().getParameters().get('Id')
        ];
        
        if (thisEvent.size() > 0) {
            
            CourseOutlineReadingService.setProgrammeId(thisEvent[0].Staffing_Event__r.Related_Programme__c);
            CourseOutlineReadingService.setSubjectId(thisEvent[0].Staffing_Event__r.Related_Subject__c);
            Course_Outline_Reading__c reading = null;
            if (thisEvent[0].Staffing_Event__r.Course_Outline_Reading__c != null) {
                CourseOutlineReadingService.setReadingId(thisEvent[0].Staffing_Event__r.Course_Outline_Reading__c);
                reading = CourseOutlineReadingService.getCourseOutlineReadingById();
            }
            //Course_Outline_Reading__c reading = CourseOutlineReadingService.getCourseOutlineReadingBySubject();
            
            if (reading != null && (reading.Status__c == 'Submitted' || reading.Status__c == 'Published')) {
                return '';
            }
            
            return thisEvent[0].Staffing_Event__c;
            
        }
        else {
            return '';
        }
        
    } 
    
    public IB_Verification_Visit_Feedback__c getLinkForVerificationVisit() {
        List<My_Staffing_Event__c> thisEvent = [SELECT Staffing_Event__r.Related_Programme__c
                                                FROM My_Staffing_Event__c
                                                WHERE Staffing_Event__c = :ApexPages.currentPage().getParameters().get('Id')
                                                AND Staffing_Event__r.Event_Type__c = 'Verification Visit'
                                                AND Application_Status__c = 'Confirmed'
                                                AND IB_Contact__c = :user.ContactId];
        
        if (thisEvent.size() > 0) {
            // Need to modify this query so that the feedback application is only returned for the programme if it is "active" or "not submitted"
            List<IB_Verification_Visit_Feedback__c> vvFeedback = [SELECT ID FROM IB_Verification_Visit_Feedback__c
                                                                  WHERE IB_Programme__c = :thisEvent[0].Staffing_Event__r.Related_Programme__c
                                                                  AND Status__c not in ('Submitted','Published')];
            system.debug('App Feedback: ' + vvFeedback);
            if(vvFeedback.size() > 0) return vvFeedback[0];
            return new IB_Verification_Visit_Feedback__c();
        }
        else {
            System.debug('DebugX: did not find this event');
            return new IB_Verification_Visit_Feedback__c();
        }
    }    
    
    public void updateAssignmentId() {
        System.debug('mw updateAssignmentId');
        //My_Assignments_Lookup__r.Staffing_Event__c = :ApexPages.currentPage().getParameters().get('Id')
        
        List<My_Staffing_Event__c> thisEvent = [SELECT Staffing_Event__r.Related_Programme__c,Staffing_Event__r.Event_Type__c,Staffing_Event__r.Sub_Type__c
                                                FROM My_Staffing_Event__c
                                                WHERE Staffing_Event__c = :ApexPages.currentPage().getParameters().get('Id')
                                                AND Application_Status__c = 'Confirmed'];
        
        if (thisEvent.size() > 0) {
            // Need to modify this query so that the feedback application is only returned for the programme if it is "active" or "not submitted"
            if(thisEvent[0].Staffing_Event__r.Event_Type__c == 'Consultant') {
                
                List<IB_Consultant_Feedback__c> appFeedback = [SELECT ID,IB_Application__c, Assignment_ID__c FROM IB_Consultant_Feedback__c
                                                               WHERE IB_Programme_Lookup__c = :thisEvent[0].Staffing_Event__r.Related_Programme__c
                                                               AND Status__c  not in ('Submitted','Published')];
                system.debug('App mw2 Feedback: ' + appFeedback);
                if(appFeedback.size() > 0) {
                    if(appFeedback[0].Assignment_ID__c == '' || appFeedback[0].Assignment_ID__c == null || appFeedback[0].Assignment_ID__c != ApexPages.currentPage().getParameters().get('Id')){
                        appFeedback[0].Assignment_ID__c = ApexPages.currentPage().getParameters().get('Id');
                        update appFeedback[0];
                    }
                }
            } else if(thisEvent[0].Staffing_Event__r.Event_Type__c == 'Reader' && thisEvent[0].Staffing_Event__r.Sub_Type__c == 'Request for authorization'){
                
                List<Auth_Feedback__c> appFeedback = [SELECT ID, Assignment_ID__c FROM Auth_Feedback__c WHERE IB_Programme__c = :thisEvent[0].Staffing_Event__r.Related_Programme__c AND Status__c not in ('Submitted','Published')];
                system.debug('mw1 App Feedback: ' + appFeedback);
                if(appFeedback.size() > 0) {
                    if(appFeedback[0].Assignment_ID__c == '' || appFeedback[0].Assignment_ID__c == null || appFeedback[0].Assignment_ID__c != ApexPages.currentPage().getParameters().get('Id')){
                        appFeedback[0].Assignment_ID__c = ApexPages.currentPage().getParameters().get('Id');
                        update appFeedback[0];
                    }
                }
                //mw begin
                // }
            } else if(thisEvent[0].Staffing_Event__r.Event_Type__c == 'Verification Visit' && thisEvent[0].Staffing_Event__r.Sub_Type__c == 'Verification Visit'){
                System.debug('mw do we get here');
                
                List<IB_Verification_Visit_Feedback__c> vvFeedback = [SELECT ID, Assignment_ID__c FROM IB_Verification_Visit_Feedback__c
                                                                      WHERE IB_Programme__c = :thisEvent[0].Staffing_Event__r.Related_Programme__c
                                                                      AND Status__c not in ('Submitted','Published')];
                system.debug('mw vv Feedback: ' + vvFeedback);
                if(vvFeedback.size() > 0) {
                    if(vvFeedback[0].Assignment_ID__c == '' || vvFeedback[0].Assignment_ID__c == null || vvFeedback[0].Assignment_ID__c != ApexPages.currentPage().getParameters().get('Id')){
                        vvFeedback[0].Assignment_ID__c = ApexPages.currentPage().getParameters().get('Id');
                        update vvFeedback[0];
                    }
                }
            }            
            //mw end
            
        }
    }   
}