public without sharing class ICFSectionC1Controller extends PimsApplicationControllerHelper {

    public IB_Consultant_Feedback__c visitFeedback {get;set;}
    public IB_Consultant_Feedback__c endOfProcFeedback {get;set;}
    public IB_Application__c application {get;set;}
    public IB_Application_Assessment__c assessment {get;set;}
    public Boolean isEndOfProcess {get;set;}
    public List<Application_Meeting_Chart__c> applicationMeetingList {get;set;}
    public List<IB_Role__c> rolesByProgramme {get;set;}
    public List<IB_Role__c> rolesByProgramme_T {get;set;}
    public List<Role_Application_Subject__c> subjectsByRoles {get;set;}
    public Map<Id,Set<Role_Application_Subject__c>> roleAppSubjectMap {get;set;}
    public Boolean pdCompletionStatus {get;set;}
    public Boolean isEditMode {get;set;}
    public String workingId {get;set;}
    public Boolean isEditable {get;set;}
    public Boolean showReturn {get;set;}
    public PageReference activeContent {get;set;}

    public static final RecordType endOfProcRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'End_of_Process'];
    public static final RecordType visitRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'Initial_Visit'];

    public IB_Programme__c programme {get;set;}

    public ICFSectionC1Controller(){
        
        System.debug('Limits.getCpuTime()C1 :'+Limits.getCpuTime());
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        System.debug('In ICFSectionC1Controller()');
        if(getIsPyp()){
            activeContent = Page.ICFSectionC1_PYP;
        } else if(getIsMyp()){
            activeContent = Page.ICFSectionC1_MYP;
        } else if(getIsDp()){
            activeContent = Page.ICFSectionC1_DP;
        } else if(getIsCpPhase1()){
            activeContent = Page.ICFSectionC1_CP1;
        } else if(getIsCpPhase2()){
            activeContent = Page.ICFSectionC1_CP2;
        } 

        
        System.debug('Limits.getCpuTime()C1 :'+Limits.getCpuTime());
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        System.debug('activeContent:'+activeContent);
        
        isEndOfProcess = false;
        pdCompletionStatus = false;

        application = ApplicationDAO.getInstance().getApplicationById(ApexPages.currentPage().getParameters().get('id'));

        
        System.debug('Limits.getCpuTime()C1 :'+Limits.getCpuTime());
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        assessment = ApplicationAssessmentDAO.getInstance().getAppAssessmentByAppId(application.Id);
        
        System.debug('Limits.getCpuTime()C1 :'+Limits.getCpuTime());
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        isEditMode = false;
        isEditable = false;

        for(Profile tmp : [select Id, Name from Profile where Name IN :ICFlib.allowEdit]){

            if(UserInfo.getProfileId() == tmp.Id){
                isEditable = true;
            }
        }

        System.debug('Limits.getCpuTime()C1 :'+Limits.getCpuTime());
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        System.debug('isEditable:'+isEditable);
        for(IB_Consultant_Feedback__c tmp : ConsultantFeedbackDAO.getInstance().getRecordsByAppId(application.Id)){

            if (tmp.RecordTypeId == visitRecType.Id){
                visitFeedback = tmp;
                workingId = workingId != null ? workingId : tmp.Id;
            }
            if (tmp.RecordTypeId == endOfProcRecType.Id) {
                endOfProcFeedback = tmp;
                workingId = tmp.Id;
                isEndOfProcess = true;
            }

            ApexPages.currentPage().getParameters().put('id', application.Id);
        }

        if(visitFeedback!=null){
            programme = ProgrammeDAO.getInstance().getProgrammeById(visitFeedback.IB_Programme_Lookup__c);
        } else {
            programme = ProgrammeDAO.getInstance().getProgrammeById(endOfProcFeedback.IB_Programme_Lookup__c);
        }
        
        System.debug('Limits.getCpuTime()C1 :'+Limits.getCpuTime());
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        System.debug('isEditable:'+isEditable);
        RoleService.setAccountId(programme.Account__c);
        
        System.debug('Limits.getCpuTime()C1 :'+Limits.getCpuTime());
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        
        RoleService.setAccountId(programme.Account__c);
        RoleService.setProgrammeId(programme.Id);
        
       // rolesByProgramme = RoleService.getRolesByProgrammeId();
      /* Code added as part of APEX CPU Limit issues fix */
        
        rolesByProgramme = RoleService.getRolesByProgrammeId_B(programme.Account__c,programme.Id); //non - teacher
        rolesByProgramme_T = RoleService.getRolesByProgrammeId_T(programme.Account__c,programme.Id); // teacher
        
        List<Id> roleIdList_T = new List<Id>() ;
        if(rolesByProgramme_T.size()>0 ){
            for (IB_Role__c r : rolesByProgramme_T) {
                roleIdList_T.add(r.Id);
            }
        }

          RoleApplicationSubjectService.setRoleList(roleIdList_T);
        subjectsByRoles = RoleApplicationSubjectService.getSubjectsByRoleList();

         roleAppSubjectMap = new Map<Id, Set<Role_Application_Subject__c>>();
   
       for(IB_Role__c teacher: rolesByProgramme_T){
            Set<Role_Application_Subject__c> subList = new Set<Role_Application_Subject__c>();
            for(Role_Application_Subject__c subject: subjectsByRoles){
                if(teacher.Id == subject.Role_And_Application__c){
                    subList.add(subject);
                }
            }
            roleAppSubjectMap.put(teacher.Id, subList);
        }
        System.debug('rolesByProgramme_T.size():'+rolesByProgramme_T.size());
        System.debug('subjectsByRoles.size():'+subjectsByRoles.size());
        System.debug('roleAppSubjectMap.size():'+roleAppSubjectMap.size());
 /* ------------------------------------------------------------------------------------------- */
        
        List<Id> roleIdList = new List<Id>() ;
        Set<Id> roleIdSet = new Set<Id>() ;
        for (IB_Role__c r : rolesByProgramme) {
            if (r.IB_Role_Name__c == 'Teacher') roleIdSet.add(r.Id);
        }
        roleIdList.addAll(roleIdSet);
        System.debug('Limits.getCpuTime()C1 :'+Limits.getCpuTime());
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        
        RoleApplicationSubjectService.setRoleList(roleIdList);
        subjectsByRoles = RoleApplicationSubjectService.getSubjectsByRoleList();
    
        applicationMeetingList = [
            SELECT B2_4_2_Meeting_Attendance__c, B2_4_2_Meeting_Chart__c, B2_4_2_Meeting_Frequency__c, B2_4_2_Meeting_Objectives__c, IB_Application_Lookup__c, Name, Id
            FROM Application_Meeting_Chart__c
            WHERE IB_Application_Lookup__c = :application.Id
        ];
        
        System.debug('Limits.getCpuTime()C1 :'+Limits.getCpuTime());
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        

        if(visitFeedback != null && visitFeedback.Status__c == 'Returned to Consultant'){
            endOfProcFeedback = null;
            isEndOfProcess = false;
            workingId = visitFeedback.Id;
        }
        
        System.debug('Limits.getCpuTime()C1 :'+Limits.getCpuTime());
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
        

    }

    public PageReference save(){

        if(isEndOfProcess){
            endOfProcFeedback.C1_Complete__c = pdCompletionStatus;
            update endOfProcFeedback;
        }
        else{
            visitFeedback.C1_Complete__c = pdCompletionStatus;
            update visitFeedback;
        }

        return null;
    }

    public Void saveAndReturn(){
        undoReturn();
        save();
    }

    public Void edit(){
        isEditMode = true;
    }

    public Void undoEdit(){
        isEditMode = false;
    }

    public Void doReturn(){
        showReturn = true;
    }

    public Void undoReturn(){
        showReturn = false;
    }

    public Void saveFromEdit(){
        undoEdit();

        if(visitFeedback != null && visitFeedback.Id == workingId){
            visitFeedback.Edited_by_Staff__c = true;
            update visitFeedback;
        }
        else if(endOfProcFeedback != null && endOfProcFeedback.Id == workingId){
            endOfProcFeedback.Edited_by_Staff__c = true;
            update endOfProcFeedback;
        }
    }
}