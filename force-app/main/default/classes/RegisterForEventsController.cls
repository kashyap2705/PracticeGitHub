public without sharing class RegisterForEventsController {
    
    private Static String NONE_VALUE = 'None';
    
    private Map<String, RoleInfo> roles = new Map<String, RoleInfo> (); 
    
    private List <SelectOption> rolesInfo = new List<SelectOption>();
    private List <SelectOption> programmsInfo = new List<SelectOption>();
    
    public List<SelectOption> getRolesInfo() {
        return this.rolesInfo;
    }
       
    public List<SelectOption> getProgrammsInfo() {
        return this.programmsInfo;
    }
    
    //TODO: Has to be fixed and refactored
    private boolean isAcceptedExternal = UserDAO.INSTANCE.isAcceptedExternalUserForProfileName('Customer Community Advanced');
    
    
    private final Map <String, String > urlParams;
    
    public My_Staffing_Event__c myStaffingEvent {
        get; set;
    }
    
    private List <IB_Role__c> ibRoles = new List <IB_Role__c> ();
    
    public RegisterForEventsController (ApexPages.StandardController stdController) {
        final List<String> allFields = new List<String> {'Performance_Rating__c','My_Role__c','Invitation_Response__c','Role_Level__c', 'IB_Role_Name__c','IB_Role__c','IB_Programme__c','Staffing_Event__c','IB_Contact__c', 'Application_Status__c','Level_of_Interest__c','Release_Permission_Required__c', 'Release_Permission_Requested__c', 'Release_Response__c', 'WithdrawalReason__c', 'Withdrawal_Reason__c','Withdrawal_Argumentation__c'};
        
        if (! Test.isRunningTest()) {
            
            stdController.addFields(allFields);
        }
        
        myStaffingEvent = (My_Staffing_Event__c) stdController.getRecord();
            
            //For EDIT
        if ( myStaffingEvent != null && !String.isBlank(myStaffingEvent.Id)) {
            
            this.roles.putAll(getAvailableRoles());
            if (this.roles.isEmpty()) {
                return; 
            }
            
            if (this.roles.containsKey(this.myStaffingEvent.IB_Role__c)) {
                roles.get(this.myStaffingEvent.IB_Role__c).addProgram(this.myStaffingEvent.IB_Programme__c);
                
            } else {
                        
               RoleInfo roleInfo = new RoleInfo();
               roleInfo.setId(this.myStaffingEvent.IB_Role__c);
               roleInfo.setName(this.myStaffingEvent.IB_Role_Name__c);  
               roleInfo.addProgram(this.myStaffingEvent.IB_Programme__c);
               roles.put(this.myStaffingEvent.IB_Role__c , roleInfo);
                    
            }
            this.rolesInfo = getRoles(roles);
            setDefaultValuesForProgramList(roles, this.myStaffingEvent.IB_Role__c, this.myStaffingEvent.IB_Programme__c);
                 
         } else {
            
            //For CREATE
            this();
        }
        
        
    }
    
    public RegisterForEventsController () {
        
        try {   
             
             urlParams = ApexPages.currentPage().getParameters();
         
             String contactId = urlParams.get('contactId');
             String staffingEventId = urlParams.get('staffingEventId');
             
             contactId = !String.isBlank(contactId) ? contactId : UserDAO.INSTANCE.getUserById(Userinfo.getUserId()).ContactId;
             
             myStaffingEvent = new My_Staffing_Event__c(IB_Contact__c = contactId, Staffing_Event__c =staffingEventId, Role_Level__c = NONE_VALUE);
             this.roles.putAll(getAvailableRoles());
             if (this.roles.isEmpty()) {
                return; 
             }
             this.rolesInfo = getRoles(roles);
             System.debug('rolesInfo====='+this.rolesInfo);
             System.debug('roles====='+this.roles);
             System.debug('contactId====='+contactId);
             System.debug('myStaffingEvent====='+myStaffingEvent);
             setDefaultValuesForProgramList(this.roles, this.roles.values().get(0).getId(), new List<String>(this.roles.values().get(0).getAllProgramms()).get(0));
             
             
        } catch (Exception ex) {
             ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' '+ ex.getMessage()));
        }    
          
    }
    
    private Map<String, RoleInfo> getAvailableRoles() {
         if (null == myStaffingEvent.IB_Contact__c || null == myStaffingEvent.Staffing_Event__c) {
             return new Map<String, RoleInfo> ();
         }
        
         boolean isStaffedbyIBInternally = true;
         
         final List <IB_Event_Role__c> events = new List <IB_Event_Role__c> ();
         
         final Set <String> programs = new Set <String> () ;
         final List <String> ibRolesId = new List <String> () ;
         ibRoles.addAll([SELECT i.id, i.IB_Role__c, i.IB_Role_Level__c, Programme_Selection__c From IB_Role__c i  where Status__c = 'Confirmed' and i.IB_Contact__c =: myStaffingEvent.IB_Contact__c and IB_Role__c.Active__c = true]);
         
         for (IB_Role__c role : ibRoles) {
             ibRolesId.add(role.IB_Role__c);
             programs.add(role.Programme_Selection__c); 
         }

         events.addAll([ Select i.id, i.Staffing_Event__c, i.Name, i.IB_Role__c, i.IB_Role_Name__c, i.IB_Programme__c, i.IB_Event__r.IB_Event_Record_Type__c From IB_Event_Role__c i where 
                                                  i.IB_Role__c IN : ibRolesId
                                                  AND i.Staffing_Event__c = :myStaffingEvent.Staffing_Event__c]);
         
                                                  
         if ( events== null || events.isEmpty() ) {
             return new Map<String, RoleInfo> ();
         }
         return getRoleProgramFromEventRole(events, ibRoles);
             
    }
    
    private void setDefaultValuesForProgramList(final Map<String, RoleInfo> roles, String defaultIbRole, String defaultIbProgramm ) {
        
        if (!roles.isEmpty()) {
             this.programmsInfo = getProgramsByRoleId( roles, defaultIbRole);
             this.myStaffingEvent.Role_Level__c = getRoleLevelForIbRole (defaultIbRole, defaultIbProgramm);
                
        }
       
    }
    
    private List<SelectOption> getRoles( Map<String, RoleInfo> rolesMap) {
        
           final List<SelectOption> result =  new List<SelectOption>();
                     
           for (RoleInfo value : rolesMap.values()) {
               result.add(new SelectOption(value.id, value.name));
           }
           
           return result;
        
    } 
       
       
       
    private List<SelectOption> getProgramsByRoleId(Map<String, RoleInfo> rolesMap, String roleId) {

        final RoleInfo value = rolesMap.get(roleId);
        final List<SelectOption> result =  new List<SelectOption>();
   
        if (null != value) {
            for (String program : value.getAllProgramms()) {

                try {
                	result.add( new SelectOption(program, program) );
                } 
                catch (Exception ex) {
                	// do nothing    
                }
                
            }
              
        }
          
        return result;
    }
    
    private Map<String, RoleInfo> getRoleProgramFromEventRole(final List <IB_Event_Role__c> events,  final List <IB_Role__c> ibRoles) {
        
        final Map<String, RoleInfo> roles = new Map<String, RoleInfo> ();
        
        for (IB_Role__c role : ibRoles) {
            
             for (IB_Event_Role__c eventRole : events) {
                 //below piece of code is added by developer Ammara as part of L&T Changes on 12/26/2020
                 //start
                 if(eventRole.IB_Programme__c == null && eventRole.IB_Event__r.IB_Event_Record_Type__c == 'Learning and Teaching Programme Development' && role.IB_Role__c == eventRole.IB_Role__c ){
                      if (roles.containsKey(eventRole.IB_Role__c)) {
                         roles.get(eventRole.IB_Role__c).addProgram(eventRole.IB_Programme__c);
                
                     } else {
                        
                       RoleInfo roleInfo = new RoleInfo();
                       roleInfo.setId(eventRole.IB_Role__c);
                       roleInfo.setRoleId(role.Id);
                       roleInfo.setName(eventRole.IB_Role_Name__c);  
                       roleInfo.addProgram(eventRole.IB_Programme__c);
                       roles.put(eventRole.IB_Role__c , roleInfo);
                    
                     }
                     }
                 //end
                 else if (role.IB_Role__c == eventRole.IB_Role__c  && role.Programme_Selection__c == eventRole.IB_Programme__c) {
                    
                     if (roles.containsKey(eventRole.IB_Role__c)) {
                         roles.get(eventRole.IB_Role__c).addProgram(eventRole.IB_Programme__c);
                
                     } else {
                        
                       RoleInfo roleInfo = new RoleInfo();
                       roleInfo.setId(eventRole.IB_Role__c);
                       roleInfo.setRoleId(role.Id);
                       roleInfo.setName(eventRole.IB_Role_Name__c);  
                       roleInfo.addProgram(eventRole.IB_Programme__c);
                       roles.put(eventRole.IB_Role__c , roleInfo);
                    
                     }
                    
                 }
                 
             }
            
            
        }
        
        return roles;
        
    }
    
    public PageReference  save () {

        try {   
             MyStaffingEventDAO staffingEventDAO = MyStaffingEventDAO.getInstance();
            String eventtype = staffingEventDAO.getCampigneventType(myStaffingEvent.Staffing_Event__c);
            //below piece of code is added by developer Ammara as part of L&T Changes on 12/26/2020
            //start
            if(eventtype == 'Learning and Teaching Programme Development' && myStaffingEvent.IB_Programme__c == null && String.isBlank(myStaffingEvent.IB_Role__c) ){
                 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.No_Event_Role_Selected_L_T));
                    return null;
            }
           else if (eventtype != 'Learning and Teaching Programme Development' && (String.isBlank(myStaffingEvent.IB_Role__c) || String.isBlank(myStaffingEvent.IB_Programme__c))) {
               System.debug('Test : '+myStaffingEvent.Staffing_Event__c+' '+eventtype+' '+myStaffingEvent.IB_Programme__c);
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.No_Event_Role_Selected));
                return null;
            }
            //end

            if (myStaffingEvent.Id == null) {
                Id eventId = staffingEventDAO.getCampaignIdFromStaffingId(myStaffingEvent.Staffing_Event__c);
                if (staffingEventDAO.exists(eventId, myStaffingEvent.IB_Contact__c, myStaffingEvent.IB_Role__c)) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.Validate_Existing_Role_Application));
                    return null;
                }
            }
            
            myStaffingEvent.My_Role__c = roles.get(this.myStaffingEvent.IB_Role__c).getRoleId();   
            upsert myStaffingEvent;
            
        } catch (System.DmlException e) {
               for (Integer i = 0; i < e.getNumDml(); i++) {
                  ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getDmlMessage(i))); 
                  
               }
                 
               return null;
               
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' '+ ex.getMessage()));
            return null;        
        }   
        
        final String retUrl = ApexPages.currentPage().getParameters().get('retURL');
        
        if (!String.isBlank(retUrl)) {
            return new PageReference(retUrl);
        }
        
        return new PageReference('/'+myStaffingEvent.id);
        
    }
    
    public PageReference cancel () {
        final String retUrl = ApexPages.currentPage().getParameters().get('retURL');
        
        if (!String.isBlank(retUrl)) {
            return new PageReference(retUrl);
        }
        return new PageReference('/'+myStaffingEvent.id);
    }
    
     
    
    public void reloadRoles() {
        try {   
                
           this.roles.clear();
           this.programmsInfo.clear();
           this.rolesInfo.clear();
           this.myStaffingEvent.Role_Level__c = NONE_VALUE;
           
           this.roles.putAll(getAvailableRoles());
            
           if (this.roles.isEmpty()) {
                return; 
           }
           this.rolesInfo = getRoles(roles);
           setDefaultValuesForProgramList(this.roles, roles.values().get(0).getId(), new List<String>(this.roles.values().get(0).getAllProgramms()).get(0));
            
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' '+ ex.getMessage()));
        }   
           
    } 
    public void reloadData () {
        cleanParams();
        reloadRoles();
    }
    
    public void cleanParams() {
        setDefaultValuesForProgramList(this.roles, this.myStaffingEvent.IB_Role__c, this.myStaffingEvent.IB_Programme__c);
    }
     
    public void searchPrograme() {
          this.programmsInfo.clear();
          this.programmsInfo.addAll (getProgramsByRoleId( roles, myStaffingEvent.IB_Role__c));
          this.myStaffingEvent.Role_Level__c = getRoleLevelForIbRole (myStaffingEvent.IB_Role__c, this.programmsInfo.get(0).getValue());
          
    }
    
    public void changeRoleLevel () {
        this.myStaffingEvent.Role_Level__c = getRoleLevelForIbRole (myStaffingEvent.IB_Role__c, myStaffingEvent.IB_Programme__c);
        
    }
    
    private String getRoleLevelForIbRole (final String ibRole, final String program) {
        for (IB_Role__c role : ibRoles) {
            if (role.IB_Role__c == ibRole && role.Programme_Selection__c == program) {
                return role.IB_Role_Level__c;
            }
            
        }
        
        return NONE_VALUE;
    }
    
    public String roleData {
         set; get;
    }
    
    public String programmData {
         set; get;
    }
    
    public RegisterForEventsController getThis() {
            return this;
    }
    
    class RoleInfo {
    
       private String id;
       private String name;
       private String roleId;
       
       private final Set <String> programs = new Set <String> ();
       
       public void setRoleId(String roleId) {
           this.roleId = roleId;
       }
       
       public String getRoleId() {
           return this.roleId;
       }
       
       public void setId(String id) {
           this.id = id;
       }
       
       public void setName( String name) {
           this.name = name;
       }
       
       public String getName() {
           return this.name;
       }
       
       public String getId() {
           return this.id;
       }
       
       public void addProgram (final String program) {
           this.programs.add(program);  
       }
       
       public Set <String> getAllProgramms () {
           return this.programs;
       }    
       
     
   }
    
}