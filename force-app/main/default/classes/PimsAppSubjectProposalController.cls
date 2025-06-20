public class PimsAppSubjectProposalController extends PimsApplicationControllerHelper {
    
    public String appId {get;set;}
    public String activeTab {get;set;}
    public String redirectUrl {get;set;}
    public String spCompletionStatus {get;set;}
    
    public Boolean showSubPropMsgCP {get;set;}
    public Boolean showSubPropMsgDP {get;set;}
    public Boolean showSubPropMsgMYP {get;set;}
    public Integer DP1;
    public Integer DP2;
    public Integer DP3;
    public Integer DP4;
    public Integer DP5;
    public String cpFirstSubject;
    public Integer CP1;
    public Integer CP2;
    
    public IB_Application__c application {get;set;}
    public IB_Programme__c programme {get;set;}
    public Id subjectProposalId {get;set;}
    
    public List<Roles_and_Applications_Subject_Proposal__c> subjectProposals {get;set;}
    public Roles_and_Applications_Subject_Proposal__c newSubjectProposal {get;set;}
    public Roles_and_Applications_Subject_Proposal__c editSubjectProposal {get;set;}
    public String newSubjectProposalSubjectGroup {get;set;}
    public String newSubjectProposalSubjectName {get;set;}
    public String newSubjectProposalSubjectLanguage {get; set;}
    
    
    public PimsAppSubjectProposalController() {
        
        try
        {
            String urlVal = Apexpages.currentPage().getUrl();
            system.debug('urlVal##'+urlVal);
            appId = ApexPages.currentPage().getParameters().get('id');
            if (appId == null) {
                throw new CustomValidationException('The application ID is invalid.');
            }
            activeTab = PageService.getActiveTab();
            System.debug('aaamw'+activeTab);
            if (activeTab == 'sectionb2') {
                PageService.setPage('PimsApplicationForAuthorization');
                System.debug('bbb'+appId);
            }else{
                System.debug('ccc'+appId);
                PageService.setPage('PimsApplicationForCandidacy');
            }
            if (activeTab == 'subject' || activeTab == 'sectionb2') {
                System.debug('ddd'+appId);
                
                ApplicationService.setApplicationId(appId);
                System.debug('ddd'+appId);
                application = ApplicationService.getApplication();
                system.debug('application@@'+application);
                ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__c);
                system.debug('programme@@'+programme);
                programme = ProgrammeService.getProgramme();
                
                showSubPropMsgCP = false;
                showSubPropMsgDP = false;
                showSubPropMsgMYP = false;
                DP1 = 0;
                DP2 = 0;
                DP3 = 0;
                DP4 = 0;
                DP5 = 0;
                cpFirstSubject = '';
                CP1 = 0;
                CP2 = 0;
                
                subjectProposals = ApplicationService.getSubjectProposals();
                newSubjectProposal = new Roles_and_Applications_Subject_Proposal__c(
                    IB_Application_Lookup__c = application.Id
                );
                
                if(getIsMyp())
                    newSubjectProposal.RecordTypeId = Schema.SObjectType.Roles_and_Applications_Subject_Proposal__c.getRecordTypeInfosByName().get('MYP').getRecordTypeId();
                
                if (getIsCp() && subjectProposals.size() < 2) { showSubPropMsgCP = true; }
                if (getIsMyp() && subjectProposals.size() == 0) { showSubPropMsgMYP = true; }
                
                for (Roles_and_Applications_Subject_Proposal__c sp : subjectProposals) {
                    if (getIsDp()){
                        if (sp.Subject_Group__c == 'Studies in language and literature') DP1++;
                        if (sp.Subject_Group__c == 'Individuals and societies (DP)') DP2++;
                        if (sp.Subject_Group__c == 'Language acquisition (DP)') DP3++;
                        if (sp.Subject_Group__c == 'Mathematics (DP)') DP4++;
                        if (sp.Subject_Group__c == 'Sciences (DP)') DP5++;
                    }
                }
                
                //Check to show error message on subject proposal page and not allow user to submit the agreement
                if ((DP1 == 0 || DP2 == 0 || (DP3==0 && DP1<2) || DP4 == 0 || DP5 == 0)  ) showSubPropMsgDP = true;
                /*  if()
{
showSubPropMsgDP = false;

} */
                
            }
        }
        catch(exception x)
        {
            System.debug('excp'+x);
            
            
        }
        
    }
    
    public PageReference save() {
        try {
            IF (getIsCp() && showSubPropMsgCP == false) spCompletionStatus = 'Complete';
            IF (getIsCp() && showSubPropMsgCP == true) spCompletionStatus = 'In Progress';
            IF (getIsDp() && showSubPropMsgDP == false) spCompletionStatus = 'Complete';
            IF (getIsDp() && showSubPropMsgDP == true) spCompletionStatus = 'In Progress';
            IF (getIsMyp() && showSubPropMsgMYP == false) spCompletionStatus = 'Complete';
            IF (getIsMyp() && showSubPropMsgMYP == true) spCompletionStatus = 'In Progress';
            system.debug('spCompletionStatus =====> '+spCompletionStatus);
            
            
            application.AFC_Subject_Proposal_Status__c = spCompletionStatus;
            update application;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Subject_Updated));
            
            if (getisAfc()) {
                redirectUrl = '/pims/PimsApplicationForCandidacy?id=' + application.Id + '&tab=sectiona';
            }
            else {
                redirectUrl = '/pims/PimsApplicationForAuthorization?id=' + application.Id + '&tab=sectiona';
            }
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }
    
    public PageReference createSubjectProposal() {
        
        try {
            
            System.debug(newSubjectProposalSubjectGroup);
            System.debug(newSubjectProposalSubjectName);
            
            //IB_Subject__c subj = [ SELECT Id, Name FROM IB_Subject__c WHERE Subject_Group__c = :newSubjectProposalSubjectGroup AND Subject_Name__c = :newSubjectProposalSubjectName LIMIT 1 ];
            
            newSubjectProposal.Subject_Lookup__c = newSubjectProposalSubjectName;
            // This Part of Code is being added by Ammara-Plumlogix,as a part of DE6250 on 3/3/2020
            // Begin
            if(getisMYP())//End
            newSubjectProposal.Language_of_Instruction__c = newSubjectProposalSubjectLanguage;
            insert newSubjectProposal;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Subject_Added));
            
            ApplicationService.setApplicationId(newSubjectProposal.IB_Application_Lookup__c);
            application = ApplicationService.getApplication();
            subjectProposals = ApplicationService.getSubjectProposals();
            
            newSubjectProposal = new Roles_and_Applications_Subject_Proposal__c(
                IB_Application_Lookup__c = application.Id
            );
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }
    
    public PageReference updateSubjectProposal() {
        try {
            
            if (activeTab == 'sectionb2') {
                redirectUrl = '/pims/PimsApplicationForAuthorization?id=' + application.Id + '&tab=sectionb2';
            }else{
                // This Part of Code is being added by Ammara-Plumlogix,as a part of DE6251 on 3/3/2020
                // Begin
                if(getisAfa())
                   redirectUrl = '/pims/PimsApplicationForAuthorization?id=' + application.Id + '&tab=subject'; 
                else
                  redirectUrl = '/pims/PimsApplicationForCandidacy?id=' + application.Id + '&tab=subject';
                //End
            }
            update subjectProposals;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Subject_Updated_Success));
            
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }
    
    public PageReference removeSubjectProposal() {
        
        try
        {
            PageReference pageRef = ApexPages.currentPage();
            
            try {
                
                Roles_and_Applications_Subject_Proposal__c spToDelete = new Roles_and_Applications_Subject_Proposal__c();
                spToDelete.Id = subjectProposalId;
                
                delete spToDelete;
                if (activeTab == 'sectionb2') {
                    pageRef = new PageReference('/pims/PimsApplicationForAuthorization?id=' + ApexPages.currentPage().getParameters().get('id') + '&tab=sectionb2');
                }else{
                    if (getisAfc())
                        pageRef = new PageReference('/pims/PimsApplicationForCandidacy?id=' + ApexPages.currentPage().getParameters().get('id') + '&tab=subject');
                    else
                        pageRef = new PageReference('/pims/PimsApplicationForAuthorization?id=' + ApexPages.currentPage().getParameters().get('id') + '&tab=subject');
                    pageRef.setRedirect(true);
                }
                return pageRef;
                
            }
            catch (DmlException ex) {
                ApexPages.addMessages(ex);
                pageRef.setRedirect(false);
                return Null;
            }
            
        }
        catch(exception x)
        {
            system.debug('excep'+x);
            return Null;
        }
    }
    
    public List<SelectOption> getSubjectGroups() {
        
        try
        {
            if (activeTab != 'sectionb2') {
                if (activeTab != 'subject') {
                    return null;
                }
            }
            set<String> programmeSelectedTypeSet = new Set<String>(); 
            String programmeSelectedType = programme.RecordType.Name;
     
            if (programmeSelectedType == 'Diploma Programme') {
                programmeSelectedTypeSet.add('DP');
            }else if (programmeSelectedType == 'MYP Partner') {
                programmeSelectedTypeSet.add('MYP');
            }else if (programmeSelectedType == 'CP'){
                programmeSelectedTypeSet.add('CP');
                programmeSelectedTypeSet.add('DP');
            }else{
                programmeSelectedTypeSet.add(programmeSelectedType);
            }
            
            List<SelectOption> options = new List<SelectOption>();
            Boolean added = false;
            
            List<IB_Subject__c> subjects = new List<IB_Subject__c>();
            //if (programmeSelectedType == 'IBCC' && programme.IBCC_Implementation_Phase__c == 'Phase 2') {
            subjects = [
                SELECT Id, OwnerId, IsDeleted, Name, IB_Programme_Long__c, IB_Programme__c, Subject_Code__c, Subject_Group_Identifier__c, Subject_Group_Value__c, toLabel(Subject_Group__c), Subject_Name__c, Subject_Name_FR__c, Subject_Name_SP__c
                FROM IB_Subject__c
                WHERE IB_Programme__c in: programmeSelectedTypeSet  
                AND Available_in_MySchool__c = true
                ORDER BY Subject_Group__c ASC
            ];
            /*}
else {
subjects = [
SELECT Id, OwnerId, IsDeleted, Name, IB_Programme_Long__c, IB_Programme__c, Subject_Code__c, Subject_Group_Identifier__c, Subject_Group_Value__c, toLabel(Subject_Group__c), Subject_Name__c, Subject_Name_FR__c, Subject_Name_SP__c
FROM IB_Subject__c
WHERE IB_Programme__c = :programmeSelectedType
AND Available_in_MySchool__c = true
ORDER BY Subject_Group__c ASC
];
}*/
            
            Set<String> subjectNames = new Set<String>();
            /*for (IB_Subject__c subject : subjects) {
subjectNames.add(subject.Subject_Group__c);
}*/
            
            // Force user to select a subject group value from the picklist in order for the subject name picklist to be dynamically populated
            String chooseGroup = '--- '+Label.PIMS_Subject_Group+' ---';
            options.add(new SelectOption('', chooseGroup));
            /*for (String name : subjectNames) {
options.add(new SelectOption(name, name));
}*/
            for(IB_Subject__c subject : subjects){
                if(!subjectNames.contains(subject.Subject_Group_Value__c)){
                    subjectNames.add(subject.Subject_Group_Value__c);
                    System.debug('Subject Group: '+subject.Subject_Group__c);
                    System.debug('Subject Group Value: '+subject.Subject_Group_Value__c);
                    options.add(new SelectOption(subject.Subject_Group_Value__c,subject.Subject_Group__c));
                }
            }
            return options;
        }
        catch(exception x)
        {
            system.debug('exc'+x);
            return Null;
        }
    }
    
    public List<SelectOption> getSubjects() {
        
        try
        {
            System.debug('we are here'+activeTab);
            if (activeTab != 'sectionb2') {
                if (activeTab != 'subject') {
                    return null;
                }
            }
            
            set<String> programmeSelectedTypeSet = new Set<String>(); 
            String programmeSelectedType = programme.RecordType.Name;
     
            if (programmeSelectedType == 'Diploma Programme') {
                programmeSelectedTypeSet.add('DP');
            }else if (programmeSelectedType == 'MYP Partner') {
                programmeSelectedTypeSet.add('MYP');
            }else if (programmeSelectedType == 'CP'){
                programmeSelectedTypeSet.add('CP');
                programmeSelectedTypeSet.add('DP');
            }else{
                programmeSelectedTypeSet.add(programmeSelectedType);
            }
            
            System.debug('xxwe are here'+programmeSelectedType);
            System.debug('newSubjectProposalSubjectGroup'+newSubjectProposalSubjectGroup);
            
            List<SelectOption> options = new List<SelectOption>(); 
            Boolean added = false;
            
            List<IB_Subject__c> subjects = new List<IB_Subject__c>();
            //if (programmeSelectedType == 'IBCC' && programme.IBCC_Implementation_Phase__c == 'Phase 2') {
            subjects = [
                SELECT Id, OwnerId, IsDeleted, Name, IB_Programme_Long__c, IB_Programme__c, Subject_Code__c, Subject_Group_Identifier__c, Subject_Group_Value__c, toLabel(Subject_Group__c), Subject_Name__c, Subject_Name_FR__c, Subject_Name_SP__c
                FROM IB_Subject__c
                WHERE IB_Programme__c IN: programmeSelectedTypeSet 
                AND Subject_Group_Value__c = :newSubjectProposalSubjectGroup
                AND Available_in_MySchool__c = true
                ORDER BY Subject_Name__c ASC
            ];
            /*}
else {
subjects = [
SELECT Id, OwnerId, IsDeleted, Name, IB_Programme_Long__c, IB_Programme__c, Subject_Code__c, Subject_Group_Identifier__c, Subject_Group_Value__c, toLabel(Subject_Group__c), Subject_Name__c, Subject_Name_FR__c, Subject_Name_SP__c
FROM IB_Subject__c
WHERE IB_Programme__c = :programmeSelectedType
AND Subject_Group_Value__c = :newSubjectProposalSubjectGroup
AND Available_in_MySchool__c = true
ORDER BY Subject_Name__c ASC
];
}*/
            
            for (IB_Subject__c subject : subjects) {
                if(getUserLanguageKey() == 'fr'){
                    options.add(new SelectOption(subject.Id, subject.Subject_Name_FR__c));     
                } else if(getUserLanguageKey() == 'es'){
                    options.add(new SelectOption(subject.Id, subject.Subject_Name_SP__c));  
                } else {
                    options.add(new SelectOption(subject.Id, subject.Subject_Name__c));
                }
            }
            return options;
        }
        catch(exception x)
        {
            system.debug('exc'+x);
            return Null;
        }
    }
    
    public List<SelectOption> getLanguageofInstruction() {
        try
        {
            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Roles_and_Applications_Subject_Proposal__c.Language_of_Instruction__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple)
            {
                options.add(new SelectOption(f.getValue() , f.getLabel()));
            }      
            return options;
        }
        catch(exception x)
        {
            system.debug('exc'+x);
            return Null;
        }
    }
    
}