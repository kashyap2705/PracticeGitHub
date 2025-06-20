public without sharing class MyRoleCreateController {
    
    //IBEN US-80177 - Manual addition of new IBE roles against person profile record 
    //IBE Roles - Chief examiner | Examiner responsible | Deputy examiner responsible | Examiner
    //Changes - 1. Added pop-ups and related button actions. 2. Overriden Standard Save button functionality
    
    public List<IB_Role__c> rolesList {get;set;}
    public boolean showPopup {get;set;}
    public boolean showOkButton {get;set;}
    public boolean showContinueButton {get;set;}
    public boolean showCancelButton {get;set;}
    
    private IB_Role__c role; 
    private final Map<String,IB_Role_Repository__c> rolesMap = new Map< String , IB_Role_Repository__c>(); 
    private final User user; 
    private final String  INTERNAL_LICENSE = 'Salesforce';
    
    private final List <SelectOption> categoriesInfo = new List<SelectOption>();
    private final List <SelectOption> rolesInfo = new List<SelectOption>();
    private final List <SelectOption> programmsInfo = new List<SelectOption>();
    
    //Property to display custom pop-up message
    public String popupMsg {
        set; get;
    }
    
    public String roleDescription {
        set; get;
    }
    
    public String categoryData {
        set; get;
    }
    public String roleData {
        set; get;
    }
    public String programmData {
        set; get;
    }    
    
    private boolean isEditMode = false;
    private boolean isInternal = UserDAO.INSTANCE.isInternalUserForProfileId();
    
    public MyRoleCreateController (ApexPages.StandardController stdController) {
        
        this.role = (IB_Role__c) stdController.getRecord();
        //check if this edit page
        if (null != this.role && null != this.role.id) {
            this.isEditMode = true;
            this.role = IBRoleDAO.INSTANCE.getRoleById(this.role.id);
        } else {
            
            //check if this is create page with predefined role. If we have "roleId" as parameter in URL  
            final String roleId = ApexPages.currentPage().getParameters().get('roleId');
            if ( null != roleId) {
                this.isEditMode = false;  
                this.role.IB_Role__c = roleId;
            }
        }
        
        this.user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
        
        final List <IB_Role_Repository__c> result = IBRoleRepositoryDAO.INSTANCE.getAvailableRoles();
        
        Map<String, String> categories = new Map<String,String>();
        system.debug(logginglevel.ERROR, 'result :: ' + result);
        for (IB_Role_Repository__c role : result) {
            if (UserInfo.getLanguage() == 'es') {
                categories.put(role.Category__c, role.Category_es__c);
            } else if (UserInfo.getLanguage() == 'fr') {
                categories.put(role.Category__c, role.Category_fr__c);
            } else {
                categories.put(role.Category__c, role.Category__c);
            }
            rolesMap.put(role.id, role);
        }
        
        for (String key : categories.keySet()) {
            this.categoriesInfo.add(new SelectOption(key, categories.get(key)));
        }
        
        String initCategory = this.categoriesInfo.get(0).getValue();
        String initRole;
        
        if (isEditMode) {
            final IB_Role_Repository__c value = rolesMap.get(this.role.IB_Role__c);
            if (null != value) {
                categoryData = initCategory = value.Category__c;
                roleData = initRole = value.Id;
                programmData = this.role.Programme_Selection__c;
                if (UserInfo.getLanguage() == 'es') {
                    roleDescription = value.Role_Description_es__c;
                } else if (UserInfo.getLanguage() == 'fr') {
                    roleDescription = value.Role_Description_fr__c;
                } else {
                    roleDescription = value.Role_Description__c;
                }
                //roleDescription = value.Role_Description__c;
            }
            
        }
        
        if ( !this.categoriesInfo.isEmpty()) {
            this.rolesInfo.addAll  ( getRolesByCategory(initCategory) );
        }
        
        if (!this.rolesInfo.isEmpty() && null == initRole) {
            initRole = this.rolesInfo.get(0).getValue();
        }
        
        if (!this.rolesInfo.isEmpty() && null != initRole) {
            this.programmsInfo.addAll ( getProgramsByRoleId(initRole) );
        }     
        
    }
    
    //Overrides Saleforce standard Save button action
    public PageReference save()
    {
        String roleStatuses='';
        integer activeCount =0;
        integer inactiveCount =0;
        integer exceptionalactiveCount =0;
        List<IB_Role__c> exisitingRoleList = new List<IB_Role__c>();
        
        String thisRoleName = [SELECT Id,Name,Role_Name__c,Role_Type__c FROM IB_Role_Repository__c where Id =: this.role.IB_Role__c LIMIT 1][0].Role_Name__c;
        System.debug('MyRoleCreateController#: thisRoleName:' + thisRoleName);  
        
        String roleNameFilter = 'Examiner|Examiner Responsible|Chief Examiner|Deputy Examiner Responsible|Online Facilitator|Online Lead Facilitator|Assessment Translator|Assessment Language Reviewer|Assessment Content Developer|'+
            'Programme Field Representative|Workshop Leader|Exam Team Leader|Principal Examiner|Online PD Mentor';
        system.debug('Rolefilter'+roleNameFilter.contains(thisRoleName));
        if(roleNameFilter.contains(thisRoleName)){
            system.debug('Rolefilter'+roleNameFilter.contains(thisRoleName));
            IBEN_Conflicting_Roles_Addition__mdt thisRoleMdt = [SELECT MasterLabel, DeveloperName, Conflicting_Roles__c FROM IBEN_Conflicting_Roles_Addition__mdt where MasterLabel =: thisRoleName LIMIT 1];
            
            String conflictingTextArea = thisRoleMdt.Conflicting_Roles__c;
            System.debug('MyRoleCreateController#: conflictingTextArea:' + conflictingTextArea);  
            
            List<String> conflictingRolesStringList = conflictingTextArea.split(',');
            System.debug('MyRoleCreateController#: conflictingRolesStringList.size():' + conflictingRolesStringList.size());  
            System.debug('MyRoleCreateController#: conflictingRolesStringList.size():' + conflictingRolesStringList); 
            List<IB_Role_Repository__c> conflictingRolesList = [SELECT Id, Name, Role_Name__c FROM IB_Role_Repository__c where Role_Name__c IN :conflictingRolesStringList];
            Set<Id> conflictingRoles = new Set<Id>();
            
            for(IB_Role_Repository__c repository: conflictingRolesList)
            {
                conflictingRoles.add(repository.Id);
            }
            System.debug('MyRoleCreateController#: conflictingRolesList.size():' + conflictingRolesList.size());      
            System.debug('MyRoleCreateController#: conflictingRolesList.size():' + conflictingRolesList); 
            System.debug('MyRoleCreateController#: conflictingRoles:' + conflictingRoles);      
            System.debug('MyRoleCreateController#: conflictingRoles.size():' + conflictingRoles.size());
            
            rolesList = [SELECT Id, Name, IB_Role__c,IB_Account__c, Start_Date__c, End_Date__c, Role_Type__c, Active__c, IB_Role_Name__c, Status__c, Account_Name__c, Programme_Selection__c, Programme_Selection_ES__c, Programme_Selection_FR__c  
                         FROM IB_Role__c 
                         WHERE IB_Contact__c = :this.role.IB_Contact__c
                         AND IB_Role__c in :conflictingRoles]; 
            System.debug('MyRoleCreateController#: rolesList size():'+rolesList.size()); //show popup
            
            if((rolesList.size() > 0))            
            {
                
                for(IB_Role__c role: rolesList){
                    if((this.role.IB_Role__c == role.IB_Role__c) && ((role.IB_Role_Name__c == 'Examiner') || (role.IB_Role_Name__c == 'Exam Team Leader') || (role.IB_Role_Name__c == 'Principal Examiner') || (role.IB_Role_Name__c == 'Deputy Examiner Responsible') || (role.IB_Role_Name__c == 'Examiner Responsible') || (role.IB_Role_Name__c == 'Chief Examiner') || (role.IB_Role_Name__c == 'Assessment Content Developer') || (role.IB_Role_Name__c == 'Assessment Language Reviewer')|| (role.IB_Role_Name__c == 'Assessment Translator')))
                    {
                        if(role.Active__c == true){
                            exceptionalactiveCount ++;
                            System.debug('exceptionalactiveCount '+exceptionalactiveCount);
                        } 
                        else{
                            inactiveCount ++;
                            exisitingRoleList.add(role);
                            
                        } 
                    }
                }
                
                System.debug('MyRoleCreateController#: activeCount: '+activeCount);
                System.debug('MyRoleCreateController#: inactiveCount: '+inactiveCount);
                System.debug('MyRoleCreateController#: exisitingRoleList: '+exisitingRoleList.size());
                System.debug('exceptionalactiveCount '+exceptionalactiveCount);
                System.debug('activeCount '+activeCount);
                System.debug('inactiveCount '+inactiveCount);
                System.debug('exceptionalinactiveCount '+inactiveCount);
                system.debug('Entered321'+this.role.IB_Role_Name__c);
                if((this.role.IB_Role__c == role.IB_Role__c) && ((role.IB_Role_Name__c == 'Online Facilitator') || (role.IB_Role_Name__c == 'Online Lead Facilitator') || (role.IB_Role_Name__c == 'Programme Field Representative') || (role.IB_Role_Name__c == 'Workshop Leader') || (role.IB_Role_Name__c == 'Online PD Mentor')))
                { system.debug('Entered321');
                    
                    if(role.Active__c == true){
                        activeCount ++;
                        system.debug('activeCountEntered321'+activeCount);
                    }else {
                            inactiveCount ++;
                            system.debug('Entered123');
                            exisitingRoleList.add(role);  
                        }
                    
                }
                if((exceptionalactiveCount > 2))
                {	System.debug('exceptionalcountpopup'+exceptionalactiveCount);
                    popupMsg ='This person already holds the role of '+ thisRoleName +'. Following are the conflicting roles:' ;
                    this.showOkButton = true;
                    showPopup = true;
                    showContinueButton = false;
                    showCancelButton = false;
                    System.debug('MyRoleCreateController#: showPopup:'+showPopup);
                }
                else if((activeCount > 0))
                {   System.debug('justactive'+activeCount);
                    popupMsg ='This person already holds the role of '+ thisRoleName +'. Following are the conflicting roles:' ;
                    this.showOkButton = true;
                    showPopup = true;
                    showContinueButton = false;
                    showCancelButton = false;
                    System.debug('MyRoleCreateController#: showPopup:'+showPopup);
                }
                else{
                    if(inactiveCount > 0 ){
                        System.debug('testinside'+inactiveCount);
                        for(IB_Role__c existingRole: exisitingRoleList){
                            roleStatuses = roleStatuses+', ' +  existingRole.Status__c;
                        }    
                        popupMsg ='This person previously held the role of '+ thisRoleName +'. The current status(es) of the role is(are): '+ roleStatuses.substring(2) +'.' ;
                    }else{
                        popupMsg ='Please note person holds conflicting role(s): ' ;
                    }
                    showPopup = true; 
                    showContinueButton = true;
                    showCancelButton = true;
                    showOkButton = false;
                    System.debug('MyRoleCreateController#: showPopup:'+showPopup);
                }
            }else{
            try{
                upsert this.role;
                PageReference view = new PageReference ('/' + this.role.Id);
                view.setRedirect(true);        
                return view;
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
                return null;
            }
        }
            
            return null;
        }else{
            try{
                upsert this.role;
                PageReference view = new PageReference ('/' + this.role.Id);
                view.setRedirect(true);        
                return view;
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
                return null;
            }
        }
        
    }
    
    public PageReference continueRecord(){
        try{
            Database.insert(this.role);
            PageReference view = new PageReference ('/'+this.role.id);
            view.setRedirect(true);        
            return view;
            
        } catch (Exception ex) {
            this.showPopup = false; 
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
            return null;
        }
    }
    
    public void cancelRecord()
    {
        this.showPopup = false;
    }
    
    
    private List<SelectOption> getRolesByCategory(String catName) {
        
        final List<SelectOption> result =  new List<SelectOption>();
        
        for (IB_Role_Repository__c value : rolesMap.values()) {
            
            if (catName.equals(value.Category__c)) {
                
                if (UserInfo.getLanguage() == 'es') {
                    result.add(new SelectOption(value.id, value.Role_Name_es__c));
                } else if (UserInfo.getLanguage() == 'fr') {
                    result.add(new SelectOption(value.id, value.Role_Name_fr__c));
                } else {
                    result.add(new SelectOption(value.id, value.Role_Name__c));
                }
                
            }
        }
        
        return result;
        
    } 
    
    
    
    private List<SelectOption> getProgramsByRoleId(String roleId) {
        
        final IB_Role_Repository__c value = rolesMap.get(roleId);
        final List<SelectOption> result =  new List<SelectOption>();
        
        if (null != value) {
            for (String program : value.Related_Programmes__c.split(';' ,0) ) {  
                result.add( new SelectOption(program, program) );
            }
            if (UserInfo.getLanguage() == 'es') {
                this.roleDescription = value.Role_Description_es__c;
            } else if (UserInfo.getLanguage() == 'fr') {
                this.roleDescription = value.Role_Description_fr__c;
            } else {
                this.roleDescription = value.Role_Description__c;
            }
            
        }
        
        return result;
    }
    
    public List<SelectOption> getCategoriesInfo () {
        return this.categoriesInfo;
    }
    
    public List<SelectOption> getRolesInfo() {
        return this.rolesInfo;
    }
    
    public List<SelectOption> getProgrammsInfo() {
        return this.programmsInfo;
    }
    
    public PageReference SaveInfo() {
        try {
            if (!isInternal) {
                this.role.IB_Contact__c = user.ContactId;
                this.role.IB_Role__c = roleData; 
                this.role.Programme_Selection__c = programmData;
            }
            
            upsert this.role;
            
            PageReference view = new PageReference ('/' + this.role.Id);
            view.setRedirect(true);        
            return view;
            
        } catch (System.DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i++) {
                
                //Check for apply for the same role/programme combination ,
                // better to do this in IBRoleDAO.INSTANCE.getRoleById but to prevent of doing complicating check we will do this here
                
                if (e.getDmlMessage(i).contains('Unique_Application__c')) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.IBENPortal_Error_RoleApplicationDuplication));
                } else { 
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getDmlMessage(i))); 
                }
            }
            
            return null;
            
        } catch (Exception ex) {
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
            
            return null;
        }
        
    }
    
    public PageReference  cancel() {
        String url = '/' + IB_Role__c.sObjectType.getDescribe().getKeyPrefix();
        if (this.isEditMode && ApexPages.currentPage().getParameters().get('id') != ''){ 
            url = '/' + ApexPages.currentPage().getParameters().get('id');
        }
        
        PageReference view = new PageReference (url);
        view.setRedirect(true);        
        return view;
    }
    
    public void searchRole() {
        this.rolesInfo.clear();
        this.rolesInfo.addAll(getRolesByCategory(categoryData));
        
        if (!this.rolesInfo.isEmpty()) {
            this.programmsInfo.clear();
            this.programmsInfo.addAll (getProgramsByRoleId(this.rolesInfo.get(0).getValue()) );
            if (UserInfo.getLanguage() == 'es') {
                this.roleDescription = this.rolesMap.get(this.rolesInfo.get(0).getValue()).Role_Description_es__c;
            } else if (UserInfo.getLanguage() == 'fr') {
                this.roleDescription = this.rolesMap.get(this.rolesInfo.get(0).getValue()).Role_Description_fr__c;
            } else {
                this.roleDescription = this.rolesMap.get(this.rolesInfo.get(0).getValue()).Role_Description__c;
            }
        }  
    }
    
    public void searchPrograme() {
        this.programmsInfo.clear();
        this.programmsInfo.addAll (getProgramsByRoleId(roleData) );
    } 
    
    public IB_Role__c getRole() {
        
        return role;
        
    }
    
    public boolean getIsInternal() {
        return this.isInternal;
        
    }
    
    
}