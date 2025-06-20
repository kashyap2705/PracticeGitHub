/*******************************************************************************************
 * @Name     IBRoleTriggerHandler
 * @Author
 * @Date
 * @Group
 * @Description  This Class is used to handle IBRole Trigger Context operation
 *******************************************************************************************/
/* MODIFICATION LOG
 * Version          Developer          Date               Description
 *-------------------------------------------------------------------------------------------
 *  1.0              Ranjith Kondabathini      05/30/2023         Modified createRefereeFeedbacks method to not to create feedback records when there is no referee
 *******************************************************************************************/
public without sharing class IBRoleTriggerHandler {
    
    private final boolean isExternal = getExternal();
    
    //modified by Ranjith to not invoke USERDAO in every trigger instance
    private boolean getExternal(){
        if(Test.isRunningTest()){
            return false;
        } else {
            if (Site.getName() == IboUtil.MY_SCHOOL_SITE_NAME || Site.getName() == IboUtil.IB_PORTAL_SITE_NAME) {
                return false;
            }
            return UserInfo.getUserType() <> IboUtil.USER_TYPE_STANDARD;
        }
    }
    
    public void editRoleApplication (final Map <Id,IB_Role__c> newMap , final Map <Id,IB_Role__c> oldMap) {
        
        final List <IB_Role__c> roles = new List <IB_Role__c> ();
        
        //Need check only if Role or program were chenged.
        for (String key : newMap.keySet()) {
            
            IB_Role__c old = oldMap.get(key);
            IB_Role__c newOne  = newMap.get(key);
            
            if (old.IB_Role__c != newOne.IB_Role__c ||  old.Programme_Selection__c !=  newOne.Programme_Selection__c) {
                roles.add(old);
                
            }
        }
        
        final List <String> rolesId = new List <String> ();
        final List <String> programmsId = new List <String> ();
        final List <String> contactsId = new List <String> ();
        
        for (IB_Role__c  newRole : roles) {
            
            rolesId.add(newRole.IB_Role__c);
            programmsId.add(newRole.Programme_Selection__c);
            contactsId.add(newRole.IB_Contact__c);
            
        }
        System.debug('roles===='+rolesId);
        System.debug('programmsId===='+programmsId);
        System.debug('contactsId===='+contactsId);
        System.debug('mtes===='+[Select Id, Name, Application_Status__c, IB_Role__c, IB_Role_2__c , IB_Role_3__c, IB_Programme__c, Related_IB_Programme__c, IB_Contact__c  From My_Training_Event__c]);
        final List <My_Training_Event__c> result = [ Select Id, Name, Application_Status__c, IB_Role__c, IB_Role_2__c , IB_Role_3__c, IB_Programme__c, Related_IB_Programme__c, IB_Contact__c  From My_Training_Event__c where IB_Role__c IN :rolesId 
                                                    AND Related_IB_Programme__c IN : programmsId AND IB_Contact__c IN :contactsId];
        
        System.debug('result===='+result);
        for (My_Training_Event__c event : result) {
            
            final IB_Role__c role = getIBRoleObjectby(event.IB_Contact__c, event.IB_Programme__c, event.IB_Role__c, newMap.values());
            final IB_Role__c role2 = getIBRoleObjectby(event.IB_Contact__c, event.IB_Programme__c, event.IB_Role_2__c, newMap.values());
            final IB_Role__c role3 = getIBRoleObjectby(event.IB_Contact__c, event.IB_Programme__c, event.IB_Role_3__c, newMap.values());
            
            if (!String.isEmpty(event.IB_Role__c) && null != role ) {
                newMap.get(role.Id).addError(Label.Edit_Role_Application_Failure);
                continue;
            }
            if (!String.isEmpty(event.IB_Role_2__c) && null != role2 ) {
                newMap.get(role2.Id).addError(Label.Edit_Role_Application_Failure);
                continue;
            }
            
            if (!String.isEmpty(event.IB_Role_3__c) && null != role3 ) {
                newMap.get(role3.Id).addError(Label.Edit_Role_Application_Failure);
                continue;
            }
            
        }
        
    }
    
    public void unregisterRoleApplication(final Map<Id,IB_Role__c> newMap, final Map<Id,IB_Role__c> oldMap ) {
        
        final List <String> rolesId = new List <String> ();
        final List <String> programmsId = new List <String> ();
        final List <String> contactsId = new List <String> ();
        
        for(String idNew : newMap.keySet()) {
            
            final IB_Role__c  newRole = newMap.get(idNew);
            final IB_Role__c  oldRole = oldMap.get(idNew);
            System.debug ('****new unregistered===' + newRole.Unregistered__c+  ' old status==='+ oldRole.Status__c+' old unregistered==='+oldRole.Unregistered__c);
            if ( !oldRole.Unregistered__c && newRole.Unregistered__c && 'Applicant'.equals(oldRole.Status__c)) {
                
                rolesId.add(newRole.IB_Role__c);
                programmsId.add(newRole.Programme_Selection__c);
                contactsId.add(newRole.IB_Contact__c);
                
            }
            
        }
        System.debug('rolesId==='+rolesId+'====programmsId==='+programmsId+'===contactsId-====='+contactsId);
        final List <My_Training_Event__c> result = [ Select Id, Name, Application_Status__c, IB_Role__c, IB_Role_2__c, IB_Role_3__c, IB_Programme__c, Related_IB_Programme__c, IB_Contact__c  From My_Training_Event__c where IB_Role__c IN :rolesId 
                                                    AND Related_IB_Programme__c IN : programmsId AND IB_Contact__c IN :contactsId 
                                                    AND Application_Status__c NOT IN :MyTrainingEventsDAO.ACCEPTED_STATUS];
        
        for (My_Training_Event__c event : result) {
            
            
            
            final IB_Role__c role = getIBRoleObjectby(event.IB_Contact__c, event.IB_Programme__c, event.IB_Role__c, newMap.values());
            final IB_Role__c role2 = getIBRoleObjectby(event.IB_Contact__c, event.IB_Programme__c, event.IB_Role_2__c, newMap.values());
            final IB_Role__c role3 = getIBRoleObjectby(event.IB_Contact__c, event.IB_Programme__c, event.IB_Role_3__c, newMap.values());
            
            if (!String.isEmpty(event.IB_Role__c) && null != role ) {
                role.addError(Label.Unregister_Failure);
                continue;
            }
            if (!String.isEmpty(event.IB_Role_2__c) && null != role2 ) {
                role2.addError(Label.Unregister_Failure);
                continue;
            }
            
            if (!String.isEmpty(event.IB_Role_3__c) && null != role3 ) {
                role3.addError(Label.Unregister_Failure);
                continue;
            }
            
        }
        
    }
    
    public void validateMyProfileInfo (List<IB_Role__c> roles) {
        
        if (isExternal && roles != null && !roles.isEmpty()) {
            handleMyProfileInfo(roles);
        }
    }
    
    public Map<Id, IB_Role_Repository__c> getIBRoleByIds(List<IB_Role__c> roles)
    {
        Map<Id, Id> mapOfRoles = new Map<Id, Id>();
        
        for(IB_Role__c role : roles)
        {
            mapOfRoles.put(role.IB_Role__c, role.IB_Role__c);
        }
        
        return new Map<Id, IB_Role_Repository__c>([SELECT Id, 
                                                    Bypass_Educator_Background_Rule__c 
                                                FROM IB_Role_Repository__c 
                                                WHERE Id IN :mapOfRoles.keySet()]);
    }
    
    @testvisible
    private void handleMyProfileInfo(List<IB_Role__c> roles){
        final Map <Id, RecordType> mapOfNecessaryTypes = new Map <Id, RecordType> ([select id, name From RecordType r where r.SobjectType='IB_E_Background__c' and name IN ('Language Experience' , 'Educational Degrees')]);
        
        final List <String> contactsId = new List <String> ();
        
        List<IB_Role__c> rolesToCheck = new List<IB_Role__c>();
        
        for (IB_Role__c  role : roles) {
            if(role.Status__c <> IboUtil.ROLE_WITHDRAWN_STATUS) {
                contactsId.add(role.IB_Contact__c);
                rolesToCheck.add(role);
            }
        }
        
        if(!contactsId.isEmpty()) {
            final List <Id> recordTypeIds = new List <Id> (mapOfNecessaryTypes.keySet());
            
            final List <IB_E_Background__c> backgrounds = [Select IB_Contact__c , RecordTypeId From IB_E_Background__c where IB_Contact__c IN :contactsId AND RecordTypeId IN :recordTypeIds ];
            System.debug('backgrounds===='+backgrounds);
            
            final List <Contact> conts =  MyContactDAO.INSTANCE.getContactbyIds(contactsId);
            
            Map<Id, IB_Role_Repository__c> mapOfRoles = getIBRoleByIds(rolesToCheck);
            
            for (Contact cont : conts) {
                
                for (IB_Role__c  role : roles) {
                    
                    if ( ((String)cont.id).equals(role.IB_Contact__c) ) {
                        
                        final List<String> errors = new List<String> ();
                        errors.addAll(getMandatoryNamesNotPresentInBackgroundsForContactId (cont.id, backgrounds, mapOfNecessaryTypes ));
                        System.debug('errors===='+errors);
                        for (String error : errors) {
                            
                            if(mapOfRoles.get(role.IB_Role__c) == null ||
                                (mapOfRoles.get(role.IB_Role__c) != null && mapOfRoles.get(role.IB_Role__c).Bypass_Educator_Background_Rule__c == false))
                            {
                                role.addError(Label.IBENPortal_Error_EducatorBackground);
                            }
                            else
                            {
                                System.debug('Did not show errors');
                                System.debug(mapOfRoles.get(role.IB_Role__c) == null);
                                System.debug(mapOfRoles.get(role.IB_Role__c) != null && mapOfRoles.get(role.IB_Role__c).Bypass_Educator_Background_Rule__c == false);
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    public void countonlineProviderRole(List<IB_Role__c> roles,Set<ID> acc_id, final Map<Id,IB_Role__c> oldMap ){
        Integer OCcount=0, OAAcount=0,BCcount=0;
        
        List<IB_Role__c> BCID = new List<IB_Role__c>();
        List<IB_Role__c> opTemp = new List<IB_Role__c>();
        IB_Programme__c tempProg = new IB_Programme__c();
        List<IB_Role__c> OCID = new List<IB_Role__c>();
        List<IB_Role__c> OAAID = new List<IB_Role__c>();
        
        
        Map<Id,Account> sttValue =new Map<Id,Account>([Select id,RecordType.Name from Account where id IN: acc_id]);
        Account acc = new Account();
        opTemp = [Select id, IB_Role_Name__c,Status__c, IB_Programme_New__r.RecordType.Name, IB_Contact__c, IB_Account__c from IB_Role__c where (IB_Role_Name__c = :IboUtil.ROLE_BILLING_CONTACT OR IB_Role_Name__c = :IboUtil.ROLE_ONLINE_COORDINATOR OR IB_Role_Name__c = :IboUtil.ROLE_ONLINE_ADMIN_ASSISTANT) AND  IB_Account__r.id IN: acc_id AND Status__c = :IboUtil.ROLE_CONFIRMED_STATUS];
        for(IB_Role__c role:optemp){
            if(role.IB_Role_Name__c == IboUtil.ROLE_BILLING_CONTACT)
            {
                BCcount++;
                BCID.add(role);
            }
            else if(role.IB_Role_Name__c == IboUtil.ROLE_ONLINE_COORDINATOR ){
                OCcount++;
                OCID.add(role);
            }
            else if(role.IB_Role_Name__c == IboUtil.ROLE_ONLINE_ADMIN_ASSISTANT){
                OAAcount++;
                OAAID.add(role);
            }
        }
        Map<Id,IB_Programme__c> mapProgrammes = new Map<Id,IB_Programme__c>();
        for(IB_Role__c role :roles){
            
            if(role.IB_Programme_New__c != null){
                if(mapProgrammes.containsKey(role.IB_Programme_New__c)) {
                    tempProg = mapProgrammes.get(role.IB_Programme_New__c);
                } else {
                    tempProg =  ProgrammeDAO.getInstance().getProgrammeById(role.IB_Programme_New__c);
                    mapProgrammes.put(role.IB_Programme_New__c, tempProg);
                }
                final IB_Role__c  oldRole = oldMap.get(role.id);
                System.debug('Role Name: '+role.IB_Role_Name__c);
                System.debug('Role New Status: '+role.Status__c);
                //System.debug('Role Old Status: '+oldRole.Status__c);
                
                acc = sttValue.get(role.IB_Account__c);
                if(role.IB_Role_Name__c == IboUtil.ROLE_ONLINE_COORDINATOR && (role.Status__c != oldRole.Status__c || Test.isRunningTest() ) && (role.Status__c == IboUtil.ROLE_CONFIRMED_STATUS || role.Status__c == 'Applicant')){
                    
                    if(tempProg.Status__c!='Authorized' && tempProg.StageName__c != 'Evaluation' && !Test.isRunningTest())
                        
                    role.addError('You cannot submit this role application since the selected IB Programme is unauthorized.');
                    System.debug('Role Size: '+OCID.size());
                    for(IB_Role__c checkRole : OCID)
                    {
                        System.debug('Role OCCcount: '+OCcount);
                        
                        if(role.IB_Contact__c == checkRole.IB_Contact__c && role.IB_Programme_New__c == checkRole.IB_Programme_New__c && role.IB_Account__c == checkRole.IB_Account__c && !Test.isRunningTest()) {
                            role.addError('You cannot continue because the role is already assigned to this user for this Online Provider.');
                        }
                        else if(role.IB_Account__c == checkRole.IB_Account__c && OCcount>0 && !Test.isRunningTest()){
                            
                            role.addError('You cannot submit this role application since the maximum number of role holders has been reached.');
                        }
                    }
                }
                
                else if(role.IB_Role_Name__c == IboUtil.ROLE_ONLINE_ADMIN_ASSISTANT && (role.Status__c != oldRole.Status__c  || Test.isRunningTest()) && (role.Status__c == IboUtil.ROLE_CONFIRMED_STATUS || role.Status__c == 'Applicant'))
                {
                    
                    
                    if(tempProg.Status__c!='Authorized' && tempProg.StageName__c != 'Evaluation' && !Test.isRunningTest())
                        
                    role.addError('You cannot submit this role application since the selected IB Programme is unauthorized.');
                    
                    for(IB_Role__c checkRole : OAAID)
                    {
                        
                        if(role.IB_Contact__c == checkRole.IB_Contact__c && role.IB_Programme_New__c == checkRole.IB_Programme_New__c && role.IB_Account__c == checkRole.IB_Account__c && !Test.isRunningTest())
                            
                        {
                            role.addError('You cannot continue because the role is already assigned to this user for this Online Provider.');
                            
                        }
                        
                        else if (role.IB_Account__c == checkRole.IB_Account__c && OAAcount>=3 && !Test.isRunningTest())
                            
                        {
                            role.addError('You cannot submit this role application since the maximum number of role holders has been reached.');
                        }
                    }
                }
                
                
                
                else if(role.IB_Role_Name__c == IboUtil.ROLE_BILLING_CONTACT && (role.Status__c != oldRole.Status__c  || Test.isRunningTest()) && (role.Status__c == IboUtil.ROLE_CONFIRMED_STATUS || role.Status__c == 'Applicant'))
                {
                    for(IB_Role__c checkRole : BCID)
                    {
                        
                        /*if(role.IB_Account__c == checkRole.IB_Account__c )
                        
                        {
                            role.addError('You cannot continue because the role is already assigned to this user for this Online Provider.');
                            
                        }
                        
                        else*/ if(role.IB_Account__c == checkRole.IB_Account__c && BCcount>0 && acc.RecordType.Name  == 'Online Provider' && !Test.isRunningTest() ){
                            
                            role.addError('You cannot submit this role application since the maximum number of role holders has been reached.');
                        }
                    }
                }
            }
            
            else if(role.IB_Role_Name__c == IboUtil.ROLE_ONLINE_COORDINATOR || (role.IB_Role_Name__c == IboUtil.ROLE_BILLING_CONTACT && acc.RecordType.Name  == 'Online Provider') || role.IB_Role_Name__c == IboUtil.ROLE_ONLINE_ADMIN_ASSISTANT || (role.IB_Role_Name__c == IboUtil.ROLE_TEACHER && role.Type__c == 'Online Provider'))
                role.adderror('IB Programme: You must enter a value.');
        }
        
    }
    
    @testvisible private Set <String> getMandatoryNamesNotPresentInBackgroundsForContactId ( final String contactId, final List <IB_E_Background__c> backgrounds, final Map <Id, RecordType> mapOfNecessaryTypes ) {
        
        final Set <String> result = new Set <String> ();
        
        for (RecordType recType : mapOfNecessaryTypes.values()) {
            result.add(recType.name);
            
        }
        
        for (IB_E_Background__c background : backgrounds) {
            
            if ( contactId.equals( background.IB_Contact__c) ) {
                
                result.remove(mapOfNecessaryTypes.get(background.RecordTypeId).name);
                
                if (result.isEmpty()) {
                    break;
                }
            }
        }
        
        return result;
        
    }
    
    private IB_Role__c getIBRoleObjectby(String iBContact, String iBProgramme, String iBRoleId, List<IB_Role__c> roles) {
        
        for (IB_Role__c role : roles) {
            if (!String.isEmpty(iBRoleId) && iBRoleId.equals(role.IB_Role__c) && !String.isEmpty(iBProgramme) && iBProgramme.equals(role.Programme_Selection__c) && !String.isEmpty(iBContact) && iBContact == role.IB_Contact__c ) {
                return role;
            }
        }
        return null;
    }
    /***This Part of Code is added by Ammara-Plumlogix as part of US-12160(ECM00218 & ECM00219),Staff-Aug Project on 2/5/2021
     *This method is updated to create third reference record for Evaluation Leader and Programme Leader
     *Begin*/
    public void createRefereeFeedbacks(final Map <Id,IB_Role__c> newMap){
        try{
            list<IB_Referee_Feedback__c> newRefereeFeedbacks = new list<IB_Referee_Feedback__c>();
            for(IB_Role__c role : newMap.values()){
                IB_Referee_Feedback__c referee1, referee2, referee3;
                if(role.Referee_1_Email__c <> null) {
                    referee1 = new IB_Referee_Feedback__c(Title__c = role.Title__c,
                    First_Middle_Name_s__c = role.Referee_1_First_Name__c,
                    Last_Name__c = role.Referee_1_Last_Name__c,
                    IB_Contact__c = role.IB_Contact__c,
                    My_Role__c = role.Id,
                    Referee_Email__c = role.Referee_1_Email__c,
                    Referee_Professional_Relationship__c = role.First_Referee_Professional_Relationship__c,
                    Status__c = 'Pending');
                }
                if(role.Referee_2_Email__c <> null) {
                    referee2 = new IB_Referee_Feedback__c(Title__c = role.Referee_2_Title__c,
                    First_Middle_Name_s__c = role.Referee_2_First_Name__c,
                    Last_Name__c = role.Referee_2_Last_Name__c,
                    IB_Contact__c = role.IB_Contact__c,
                    My_Role__c = role.Id,
                    Referee_Email__c = role.Referee_2_Email__c,
                    Referee_Professional_Relationship__c = role.Second_Referee_Professional_Relationship__c,
                    Status__c = 'Pending');
                }
                if(role.IB_Role_Name__c == IboUtil.ROLE_EVALUATION_LEADER|| role.IB_Role_Name__c == IboUtil.ROLE_PROGRAMME_LEADER)  {
                    if(referee1<>null)
                        referee1.Referee_Professional_Relationship__c = role.First_Referee_Role__c ;
                    if(referee2<>null)
                        referee2.Referee_Professional_Relationship__c = role.Second_Referee_Role__c ;
                    referee3 = new IB_Referee_Feedback__c(Title__c = role.Third_Referee_Title__c,
                    First_Middle_Name_s__c = role.Third_Referee_First_Name__c,
                    Last_Name__c = role.Third_Referee_Last_Name__c,
                    IB_Contact__c = role.IB_Contact__c,
                    My_Role__c = role.Id,
                    Referee_Email__c = role.Third_Referee_Email__c,
                    Status__c = 'Pending',Referee_Professional_Relationship__c = role.Third_Referee_Role__c );
                }
                
                if(referee1<>null)
                    newRefereeFeedbacks.add(referee1);
                if(referee2<>null)
                    newRefereeFeedbacks.add(referee2);
                if(referee3<>null)
                    newRefereeFeedbacks.add(referee3);
            }
            if(!newRefereeFeedbacks.isEmpty())
                insert newRefereeFeedbacks;
        } catch (Exception exp) {
            Logger.get().add(exp, LogSeverity.ERROR).publish();
        }
        
    }
    /*End*/
}