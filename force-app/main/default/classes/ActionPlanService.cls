public class ActionPlanService {
    
    public static IB_Action_Plan__c actionPlanItem = null;
    public static List<IB_Action_Plan__c> actionPlan = null;
    public static List<IB_Action_Plan__c> filteredActionPlan = new List<IB_Action_Plan__c>();
    
    public static Boolean isPlanCached = false;
    public static Boolean isItemCached = false;
    public static Boolean isFilteredPlanCached = false;
    
    public static Id programmeId = null;
    public static Id itemId = null;
    
    public static String standard = null;
    public static String status = null;
    public static String stage = null;
    public static String apType = null;
    public static String actionType = null;
    
    public static void setProgrammeId(Id progId) {
        programmeId = progId;
    }
    
    public static void setItemId(Id apId) {
        itemId = apId;
    }
    
    public static void setStandard(string filterString) {
        standard = filterString;
    }
    
    public static void setStatus(string filterString) {
        status = filterString;
    }
    
    public static void setStage(string filterString) {
        stage = filterString;
    }
    
    public static void setApType(string filterString) {
        apType = filterString;
    }
    public static void setActionType(string filterString) {
        actionType = filterString;
    }
    
    public static IB_Action_Plan__c getActionPlanItem() {
        
        try
        {
            
            if (!isItemCached) {
                
                if (itemId == null) {
                    throw new CustomValidationException('The value for itemId cannot be null.');
                }
                
                ActionPlanDAO dao = ActionPlanDAO.getInstance();
                actionPlanItem = dao.getActionPlanItem(itemId);
                isItemCached = true;
                
            }
            
            return actionPlanItem;
        }
        Catch(Exception ex)
        {
            System.Debug(ex);
            return NULL;
        }
        
    }
    
    public static List<IB_Action_Plan__c> getActionPlanByProgramme() {
        
        if (!isPlanCached) {
            
            if (programmeId == null) {
                throw new CustomValidationException('The value for programmeId cannot be null.');
            }
            
            ActionPlanDAO dao = ActionPlanDAO.getInstance();
            actionPlan = dao.getActionPlan(programmeId);
            isPlanCached = true;
            
        }
        
        return actionPlan;
        
    }
    
    public static List<IB_Action_Plan__c> getFilteredActionPlan() {
        
        actionPlan = getActionPlanByProgramme();
        
        //System.debug(LoggingLevel.ERROR, 'actionPlan.size():' + actionPlan.size());
        //System.debug(LoggingLevel.ERROR, 'isFilteredPlanCached:' + isFilteredPlanCached);
        
        if (!isFilteredPlanCached) {
            for (IB_Action_Plan__c ap : actionPlan) {
                //system.debug('yup');
                //System.debug(LoggingLevel.ERROR, 'Looping:Before 1st IF()');
                //System.debug(LoggingLevel.ERROR, 'standard:' + standard);
                //System.debug(LoggingLevel.ERROR, 'ap.AP_Standard_Practice__r.Standard__c:' + ap.AP_Standard_Practice__r.Standard__c);
                if ((standard == null || ap.AP_Standard_Practice__r.Standard__c == standard || standard == 'All')) {
                    //System.debug(LoggingLevel.ERROR, 'Looping:Inside 1st IF()');
                    //System.debug(LoggingLevel.ERROR, 'status:' + status);
                    //System.debug(LoggingLevel.ERROR, 'ap.AP_Status__c:' + ap.AP_Status__c);
                    if (status == 'All' || ap.AP_Status__c == status) {
                        //System.debug(LoggingLevel.ERROR, 'Looping:Inside 2nd IF()');
                        //System.debug(LoggingLevel.ERROR, 'stage:' + stage);
                        //System.debug(LoggingLevel.ERROR, 'apType:' + apType);
                        if (stage == 'All') {
                            if (apType == 'All' && ap.AP_Action_Type__c==actionType) {
                                filteredActionPlan.add(ap);
                            }
                            else if (apType == 'All' && actionType=='All') {
                                filteredActionPlan.add(ap);
                            }
                            if (apType == 'Required' && (ap.AP_Standard_Practice__r.Required_For_Candidacy__c == true || ap.AP_Standard_Practice__r.Required_For_Authorization__c == true) && ap.AP_Action_Type__c==actionType) {
                                filteredActionPlan.add(ap);
                            }
                            else if (apType == 'Required' && (ap.AP_Standard_Practice__r.Required_For_Candidacy__c == true || ap.AP_Standard_Practice__r.Required_For_Authorization__c == true) && actionType=='All') {
                                filteredActionPlan.add(ap);
                            }
                           
                            if (apType == 'In Progress' && (ap.AP_Standard_Practice__r.In_Progress_For_Candidacy__c == true || ap.AP_Standard_Practice__r.In_Progress_For_Authorization__c  == true) && ap.AP_Action_Type__c==actionType) {
                                filteredActionPlan.add(ap);
                            }
                            else if (apType == 'In Progress' && (ap.AP_Standard_Practice__r.In_Progress_For_Candidacy__c == true || ap.AP_Standard_Practice__r.In_Progress_For_Authorization__c  == true) && actionType=='All') {
                                filteredActionPlan.add(ap);
                            }
                            
                            
                        }
                        //for Evals
                        //
                      //  system.debug('ap.AP_Action_Type__c:'+ap.AP_Action_Type__c+':::actionType'+actionType);
                       // system.debug('Stage is : '+stage+'+Prog status is : '+ap.Programme__r.Status__c );
                        if (stage == 'Evaluation' && ap.AP_Authorization_Status__c == 'Evaluation' /*&& (ap.AP_Standard_Practice__r.Required_For_Candidacy__c == true || ap.AP_Standard_Practice__r.In_Progress_For_Candidacy__c == true)*/) {
                            if (apType == 'All' && ap.AP_Action_Type__c==actionType) {
                                filteredActionPlan.add(ap);
                            }
                            else if (apType == 'All' && actionType=='All') {
                                filteredActionPlan.add(ap);
                            }
                            
                            if (apType == 'Required' && (ap.AP_Standard_Practice__r.Required_For_Candidacy__c == true || ap.AP_Standard_Practice__r.Required_For_Authorization__c == true) && ap.AP_Action_Type__c==actionType) {
                                filteredActionPlan.add(ap);
                            }
                            else  if (apType == 'Required' && (ap.AP_Standard_Practice__r.Required_For_Candidacy__c == true || ap.AP_Standard_Practice__r.Required_For_Authorization__c == true) && actionType=='All') {
                                filteredActionPlan.add(ap);
                            }
                            
                            if (apType == 'In Progress' && (ap.AP_Standard_Practice__r.In_Progress_For_Candidacy__c == true || ap.AP_Standard_Practice__r.In_Progress_For_Authorization__c  == true) && ap.AP_Action_Type__c==actionType) {
                                filteredActionPlan.add(ap);
                            }
                            else if (apType == 'In Progress' && (ap.AP_Standard_Practice__r.In_Progress_For_Candidacy__c == true || ap.AP_Standard_Practice__r.In_Progress_For_Authorization__c  == true)  && actionType=='All') {
                                filteredActionPlan.add(ap);
                            }
                           
                            
                        }
                        if (stage == 'Candidacy' && (ap.AP_Standard_Practice__r.Required_For_Candidacy__c == true || ap.AP_Standard_Practice__r.In_Progress_For_Candidacy__c == true)) {
                            if (apType == 'All' && ap.AP_Action_Type__c==actionType) {
                                filteredActionPlan.add(ap);
                            }
                            else if (apType == 'All' && actionType=='All') {
                                filteredActionPlan.add(ap);
                            }
                            if (apType == 'Required' && (ap.AP_Standard_Practice__r.Required_For_Candidacy__c == true || ap.AP_Standard_Practice__r.Required_For_Authorization__c == true) && ap.AP_Action_Type__c==actionType) {
                                filteredActionPlan.add(ap);
                            }
                           else  if (apType == 'Required' && (ap.AP_Standard_Practice__r.Required_For_Candidacy__c == true || ap.AP_Standard_Practice__r.Required_For_Authorization__c == true) && actionType=='All') {
                                filteredActionPlan.add(ap);
                            }
                            if (apType == 'In Progress' && (ap.AP_Standard_Practice__r.In_Progress_For_Candidacy__c == true || ap.AP_Standard_Practice__r.In_Progress_For_Authorization__c  == true) && ap.AP_Action_Type__c==actionType) {
                                filteredActionPlan.add(ap);
                            }
                            else if (apType == 'In Progress' && (ap.AP_Standard_Practice__r.In_Progress_For_Candidacy__c == true || ap.AP_Standard_Practice__r.In_Progress_For_Authorization__c  == true) && actionType=='All') {
                                filteredActionPlan.add(ap);
                            }
                           
                        }
                        if (stage == 'Authorization' && (ap.AP_Standard_Practice__r.In_Progress_For_Authorization__c  == true || ap.AP_Standard_Practice__r.Required_For_Authorization__c == true)) {
                            if (apType == 'All' && ap.AP_Action_Type__c==actionType) {
                                filteredActionPlan.add(ap);
                            }
                            else if (apType == 'All' && actionType=='All') {
                                filteredActionPlan.add(ap);
                            }
                            if (apType == 'Required' && (ap.AP_Standard_Practice__r.Required_For_Candidacy__c == true || ap.AP_Standard_Practice__r.Required_For_Authorization__c == true && ap.AP_Action_Type__c==actionType)) {
                                filteredActionPlan.add(ap);
                            }
                           else  if (apType == 'Required' && (ap.AP_Standard_Practice__r.Required_For_Candidacy__c == true || ap.AP_Standard_Practice__r.Required_For_Authorization__c == true && actionType=='All')) {
                                filteredActionPlan.add(ap);
                            }
                            if (apType == 'In Progress' && (ap.AP_Standard_Practice__r.In_Progress_For_Candidacy__c == true || ap.AP_Standard_Practice__r.In_Progress_For_Authorization__c  == true) && ap.AP_Action_Type__c==actionType) {
                                filteredActionPlan.add(ap);
                            }
                            else  if (apType == 'In Progress' && (ap.AP_Standard_Practice__r.In_Progress_For_Candidacy__c == true || ap.AP_Standard_Practice__r.In_Progress_For_Authorization__c  == true) && actionType=='All') {
                                filteredActionPlan.add(ap);
                            }
                           
                        }
                    }
                }
            }
            isFilteredPlanCached = true;
        }
        
        return filteredActionPlan;
        
    }
    
    public static List<SelectOption> getStandardOptions() {
        
        actionPlan = getActionPlanByProgramme();
        
        List<SelectOption> options = new List<SelectOption>();
        Set<String> standardSet = new Set<String>();
        
        for (IB_Action_Plan__c item : actionPlan) {
            standardSet.add(item.AP_Standard_Practice__r.Standard__c);
        }
        
        options.add(new SelectOption('All', 'All'));
        for (String standardOption : standardSet) {
            options.add(new SelectOption(standardOption, standardOption));
        }
        
        return options;
        
    }
    
    public static List<SelectOption> getStatusOptions() {
        
        actionPlan = getActionPlanByProgramme();
        
        List<SelectOption> options = new List<SelectOption>();
        Set<String> statusSet = new Set<String>();
        
        for (IB_Action_Plan__c item : actionPlan) {
            if (item.AP_Status__c != null) {
                statusSet.add(item.AP_Status__c);
            }
        }
        
        options.add(new SelectOption('All', 'All'));
        for (String statusOption : statusSet) {
            options.add(new SelectOption(statusOption, statusOption));
        }
        
        return options;
        
    }
    
    public static List<SelectOption> getStageOptions() {
        
        List<SelectOption> options = new List<SelectOption>{
            new SelectOption(Label.PIMS_All,Label.PIMS_All),
                new SelectOption(Label.PIMS_Candidacy,Label.PIMS_Candidacy),
                new SelectOption(Label.PIMS_Authorization,Label.PIMS_Authorization)
                };
                    
                    return options;
        
    }
    
}