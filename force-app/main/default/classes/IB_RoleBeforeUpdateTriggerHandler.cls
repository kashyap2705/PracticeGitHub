/*******************************************************************************************
* @Name     IB_RoleBeforeUpdateTriggerHandler
* @Author       
* @Date         
* @Group        
* @Description  This is before update trigger handler class for IB_Role__c object
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Ranjith Kondabathini      06/06/2023        Removed duplicate validateMyProfileInfo execution from IBRoleTriggerHelper
*******************************************************************************************/
public class IB_RoleBeforeUpdateTriggerHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp){
        
        if(TriggerContextUtility.isFirstRun()) {
            
            // TriggerContextUtility.setFirstRunFalse();  
            System.debug('IB_RoleBeforeUpdateTriggerHandler');
            System.debug('TriggerContextUtility.isFirstRun: '+TriggerContextUtility.isFirstRun());           
            process((Map<Id,IB_Role__c>)tp.oldMap, (Map<Id,IB_Role__c>)tp.newMap);
            
        }
    }
    
    @testVisible  
    private static void process(Map<Id,IB_Role__c> oldRoleApp, Map<Id,IB_Role__c> newRoleApp) {
        
        
        List<IB_Role__c> CAS_rolelist = new List<IB_Role__c>();   
        boolean ContainsInstRole=false;
        boolean onlineproviderRole=false;
        Integer OCcount=0, OAAcount=0;
        Set<ID> acc_id = new Set<ID>();
        List<IB_Role__c> opTemp = new List<IB_Role__c>();
        
        // added by kashyap for 000565 added to avoid Creation of policy user role if applied Institute has confirmed policy user role
        
        List<Id> ibAccountRoleIds = new List<Id>(); // added to populate selected accountIds
        Map<Id,IB_Role__c> existingiBMapRole = new Map<Id,IB_Role__c>(); // added to prepare existing map
        
        // End of 000565 added by kashyap Logic added to avoid Creation of policy user role if applied Institute has confirmed policy user role
        Set<ID> accountIDs = new Set<ID>();
        List<Account> accountFields = new List<Account>();
        for (IB_Role__c role : newRoleApp.values()) {
            if(role.IB_Account__c != null){
                accountIDs.add(role.IB_Account__c);
            }
        }
        If(accountIDs.isEmpty() != true){
            accountFields = [SELECT ID, isPartner, Lead_Account__c, RecordType.Name FROM Account WHERE Id in :accountIDs];
        }
        
        for (IB_Role__c role : newRoleApp.values()) {
            
            //validation added by Kevin Fugate on 11/20/2024 for PRB0042033
            
            if((role.Status__c == IboUtil.ROLE_CONFIRMED_STATUS || role.Status__c == 'Applicant') && role.IB_Account__c != null  && Test.isRunningTest() != true){
                for(Account acc : accountFields){
                    if(acc.id == role.IB_Account__c && (acc.RecordType.Name == 'School Account' || acc.RecordType.Name == 'Online Provider') &&(acc.Lead_Account__c == true)){
                        System.debug('account: ' + role.IB_Account__c);
                        System.debug('account partner: ' + role.IB_Account__r.isPartner);
                        System.debug('account lead: ' + role.IB_Account__r.Lead_Account__c);
                        role.addError('This account is currently marked as a Lead. Please uncheck the ‘Lead’ status before adding a new role application.'); 
                    }
                    if(acc.id == role.IB_Account__c && (acc.RecordType.Name == 'School Account' || acc.RecordType.Name == 'Online Provider') &&(acc.IsPartner == false)){
                        System.debug('account: ' + role.IB_Account__c);
                        System.debug('account partner: ' + role.IB_Account__r.isPartner);
                        System.debug('account lead: ' + role.IB_Account__r.Lead_Account__c);
                        role.addError('This account is not yet set up as a Partner. Please convert the account to a Partner before creating new role applications.'); 
                    }
                }
            }
            //end of validation for PRB0042033

             //code added by Prerna on 26-10-2023 for ECM00566 --STARTS--
            if (role.IB_Role_Name__c == 'IBEC Certificate Holder' && role.Status__c == 'Confirmed' && oldRoleApp.get(role.Id).Status__c != newRoleApp.get(role.id).Status__c) {
                 role.End_Date__c = System.today().addYears(2);
            }  
            //code added by Prerna on 26-10-2023 for ECM00566 --ENDS--
            
            if(role.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_POLICY_USER && role.IB_Account__c != null ) {
                ibAccountRoleIds.add(role.IB_Account__c);
            }
            
            if (role.IB_Role_Name__c == IboUtil.ROLE_ONLINE_COORDINATOR || role.IB_Role_Name__c == IboUtil.ROLE_Online_Admin_Assistant || role.IB_Role_Name__c == IboUtil.ROLE_Billing_Contact) {
                
                onlineproviderRole = true;
                acc_id.add(role.Account_Id_Formula__c);
                
            } else if (
                role.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_ADMINISTRATOR ||
                role.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_CURRICULUM_USER ||
                role.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_POLICY_USER || 
                role.IB_Role_Name__c == IboUtil.ROLE_COMMUNICATION_USER||
                role.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_TRANSCRIPT_USER|| 
                (role.IB_Role_Name__c != null && role.IB_Role_Name__c.Contains('IBEC')) ||
                (role.IB_Role_Name__c == IboUtil.ROLE_TEACHER && role.Type__c == 'Online Provider') 
                || role.IB_Role_Name__c==IboUtil.ROLE_ASSOCIATION_USER)
            {
                
                ContainsInstRole=true;
                break;
                
            } else if ( ( role.Status__c == IboUtil.ROLE_CONFIRMED_STATUS || role.Status__c == 'Applicant' ) && role.IB_Role_Name__c == IboUtil.ROLE_CAS_Coordinator && role.IB_Programme_New__c == null ) {
                
                role.addError('IB Programme is Required');
                
            } else if ( oldRoleApp.get(role.Id).Status__c != newRoleApp.get(role.id).Status__c && (role.Status__c == IboUtil.ROLE_CONFIRMED_STATUS || role.Status__c == 'Applicant' ) && role.IB_Role_Name__c == IboUtil.ROLE_CAS_Coordinator && role.IB_Account__c == null ) {
                
                role.addError('IB Account is Required');
                
            } else if ( (oldRoleApp.get(role.Id).Status__c != newRoleApp.get(role.id).Status__c && (role.Status__c == IboUtil.ROLE_CONFIRMED_STATUS || role.Status__c == 'Applicant' ) ) && ((role.IB_Role_Name__c == IboUtil.ROLE_CAS_Coordinator && role.Programme_Type__c != 'Diploma Programme') || (role.IB_Role_Name__c == IboUtil.ROLE_CAS_Coordinator &&(role.Programme_Status__c != 'Authorized' && role.Programme_Status__c != 'Candidate' )))) {
                
                role.addError('Selected IB Programme should be DP Candidate or Authorized');
                
            } else if ( role.IB_Role_Name__c == IboUtil.ROLE_CAS_Coordinator && role.Status__c == IboUtil.ROLE_CONFIRMED_STATUS && oldRoleApp.get(role.Id).Status__c != newRoleApp.get(role.id).Status__c && !CAS_rolelist.contains(role)) {
                
                CAS_rolelist.add(role);
                
            }
            
        }
        
        if ( CAS_rolelist.size() > 0 ) {
            
            IB_RoleTriggerHelper.IBRole_CAS_confirmed_Validation(CAS_rolelist); 
            
        }
        
        if ( ContainsInstRole == false ) {
            
            new IBRoleTriggerHandler().validateMyProfileInfo(newRoleApp.values());
            
        }        
        
        //This line is added on 11-25-2021,update InstituteAdmin on roles
        if ( ContainsInstRole == true ) {
            
            new InstituteMgmRolesHandler().updateInstituteAdmin(newRoleApp.values());
            
        }
        
        if ( onlineproviderRole == true ) {
            
            new IBRoleTriggerHandler().countonlineProviderRole(newRoleApp.values(),acc_id,oldRoleApp);
            
        }
        
        //This line is added on 11-25-2021,update InstituteAdmin on roles
        if ( ContainsInstRole == true ) {
            
            new InstituteMgmRolesHandler().updateInstituteAdmin(newRoleApp.values());
            
        }
        
        new IBRoleTriggerHandler().unregisterRoleApplication(newRoleApp, oldRoleApp);
        
        for (IB_Role__c role:newRoleApp.values()) {
            
            if (role.Status__c == IboUtil.ROLE_CONFIRMED_STATUS && (role.End_Date__c == null || role.End_Date__c > system.TODAY()) ) { 
                role.Active__c = true;
            }
            else if ( role.Status__c != IboUtil.ROLE_CONFIRMED_STATUS || role.End_Date__c <= system.Today() ) {
                role.Active__c = false; 
            } 
            if(role.Active__c && role.IB_Programme_New__c==null && IboUtil.DEFAULT_PROGRAMME_ROLES_ADDITION.contains(role.IB_Role_Name__c) && role.Expiry_Date__c==null) {
                role.Expiry_Date__c = Date.today().addDays(Integer.valueOf(Label.Role_withdrawn_days));
        }
        }
        
        // Calling populateProgrammeOnOnboardingRoles method.
        IB_RoleTriggerHelper.populateProgrammeOnOnboardingRoles(newRoleApp.values(), oldRoleApp);
        
        List<AccountContactRelation> AccCon=new List<AccountContactRelation>();
        List<AccountContactRelation> uAccCon=new List<AccountContactRelation>();
        List<AccountContactRelation> DAccCon=new List<AccountContactRelation>();
        List<AccountShare> accountSharing  = new List<AccountShare>();
        List<AccountShare> lstShareToDelete = new List<AccountShare>();  
        
        List<IB_Role__C> newRoleAppList = new List<IB_Role__c>();
        newRoleAppList = newRoleApp.values();
        
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> conIdSet = new Set<Id>();
        Set<Id> roleIdSet = new Set<Id>();
        
        for (IB_Role__c role : newRoleAppList) {
            
            accIdSet.add(role.Account_ID__c);
            conIdSet.add(role.IB_Contact__c);
            roleIdSet.add(role.id);
            
        }
        
        System.debug('accIdSet.size() : ' + accIdSet.size());
        System.debug('conIdSet.size() : ' + conIdSet.size());
        System.debug('roleIdSet.size() : ' + roleIdSet.size());
        
        List<IB_Role__C> rolesConfirmed = [SELECT Id 
                                           FROM IB_Role__C 
                                           WHERE Status__c=:IboUtil.ROLE_CONFIRMED_STATUS 
                                           AND IB_Account__c =: accIdSet 
                                           AND IB_Contact__c =: conIdSet 
                                           AND (IB_Role_Name__c=:IboUtil.ROLE_PROGRAMME_COORDINATOR OR IB_Role_Name__c = :IboUtil.ROLE_HOS)];
        
        System.debug('rolesConfirmed.size() : ' + rolesConfirmed.size());
        
        List<User> uList = new List<User>();
        uList = [SELECT Id, userName, UserType, Name FROM User WHERE Contactid IN :conIdSet];
        
        List<AccountShare> accShareList = new List<AccountShare>();        
        accShareList = [SELECT ID, AccountID, UserorGroupID FROM AccountShare WHERE AccountID = :accIdSet];
        
        
        List<Account> Acc = new List<Account>();
        Acc = [SELECT RecordType.Name FROM Account WHERE Id IN :accIdSet];
        
        System.debug('Account List: '+Acc.size());
        
        List<AccountContactRelation> AccConR = [SELECT Id, iSActive, AccountId, Contactid FROM AccountContactRelation WHERE AccountId IN :accIdSet AND Contactid IN :conIdSet];
        System.debug('AccountConR List: '+AccConR.size());
        
        Map<String,AccountContactRelation> accRecValue = new Map<String,AccountContactRelation>(); 
        
        for (AccountContactRelation acr : AccConR) {
            
            accRecValue.put(acr.AccountId+','+acr.ContactId,acr);
            
        }
        //end
        
        // added by kashyap for 000565 added to avoid Creation of policy user role if applied Institute has confirmed policy user role
        for(IB_Role__c ibRole: [select id,name,IB_Account__c,IB_Role_Name__c from IB_Role__c where 
                                IB_Role_Name__c = :IboUtil.ROLE_INSTITUTE_POLICY_USER 
                                and status__c = :IboUtil.ROLE_CONFIRMED_STATUS and 
                                IB_Account__c In : ibAccountRoleIds ]){
                                    existingiBMapRole.put(ibRole.IB_Account__c,ibRole);
                                }
        
        for (IB_Role__c rol : newRoleAppList) {
            
            if(existingiBMapRole.containsKey(rol.IB_Account__c) &&  rol.status__c == IboUtil.ROLE_CONFIRMED_STATUS){
                rol.addError(System.Label.Confirmed_Policy_User_Role_Exists);
            }
            
            //end of logic added by kashyap for 000565 added to avoid Creation of policy user role if applied Institute has confirmed policy user role
            
            //This part is updated on 1-03-2020,AFA Reader Feedback validation issue in 
            // qa and UAT due to query inside loop
            
            Integer i = 0;
            if ( Acc != null && !Acc.isEmpty() ) {                  
                
                if ( rol.Status__c == IboUtil.ROLE_CONFIRMED_STATUS && Acc[i].RecordType.Name == 'School Account' ) {
                    
                    List<AccountContactRelation> accRec = new List<AccountContactRelation>();
                    accRec.add(accRecValue.get(rol.IB_Account__c+','+rol.IB_Contact__c));
                    
                    if (accRec[0] == null || accRec.isEmpty()) {
                        
                        AccountContactRelation UPCon = new AccountContactRelation( isActive=true, AccountId=rol.IB_Account__c, ContactId=rol.IB_Contact__c, CurrencyIsoCode='USD' );
                        
                        if (!AccCon.contains(UpCon)) {
                            
                            AccCon.add(UpCon);
                            
                        }
                        
                    } else if ( accRec[0].isActive == false ) {
                        
                        accRec[0].isActive = True;
                        
                        if( !uAccCon.contains(accRec[0]) ) {
                            
                            uAccCon.add(accRec[0]);
                            
                        }
                        
                    }
                    
                    if (rol.IB_Role_Name__c == IboUtil.ROLE_PROGRAMME_COORDINATOR || rol.IB_Role_Name__c == IboUtil.ROLE_HOS) {
                        
                        if (uList!=null && !uList.isEmpty()) {
                            
                            if (uList[0].userType != 'CspLitePortal') {
                                
                                AccountShare jobShr  = new AccountShare();
                                
                                jobShr.AccountId = rol.IB_Account__c;
                                jobShr.UserOrGroupId = uList[0].id;
                                jobShr.AccountAccessLevel='edit';
                                jobShr.OpportunityAccessLevel='edit';
                                jobShr.ContactAccessLevel='edit';
                                jobShr.RowCause = Schema.AccountShare.RowCause.Manual;
                                accountSharing.add(jobShr);
                            }
                            
                        }
                        
                    }
                    
                } else if (rol.Status__c == 'Withdrawn' && Acc[i].RecordType.Name == 'School Account') {
                    
                    List<AccountContactRelation> accRec = new List<AccountContactRelation>();
                    accRec.add(accRecValue.get(rol.IB_Account__c+','+rol.IB_Contact__c));
                    
                    if (accRec[0] != null && !accRec.isEmpty()) {
                        
                        accRec[0].isActive = false;
                        
                        if (!uAccCon.contains(accRec[0])) {
                            
                            uAccCon.add(accRec[0]);
                            
                        }
                        
                    }
                    
                    if (uList != null && !uList.isEmpty() && (rolesConfirmed == null || rolesConfirmed.isEmpty())) {
                        
                        System.Debug('rolesConfirmed is empty');
                        
                        for (AccountShare accShare: accShareList) {
                            
                            if (accShare.UserorGroupID == uList[0].id) {
                                
                                lstShareToDelete.add(accShare);
                                
                            }
                            
                        }
                        
                        if (lstShareToDelete != null) { 
                            
                            System.Debug('lstShareToDelete.size() : ' + lstShareToDelete.size());
                            
                        }
                        
                    }
                    
                }  
                
                i++;
                
            }
            
        }
        
        if (AccCon != null && !AccCon.isEmpty()) {
            Insert AccCon;
        }
        
        if (uAccCon != null && !uAccCon.isEmpty()) {
            Update uAccCon;
        } 
        
        
        
        
        try {
            
            if (accountSharing != null && !accountSharing.isEmpty()) {
                
                Insert accountSharing;
                
            }
            
            if (lstShareToDelete != null && !lstShareToDelete.isEmpty()) {
                
                //This part is updated on 05-29-2020,US11269 Automatic role withdrawal issue due to duplicate Id
                Set<AccountShare> SetTODel = new Set<AccountShare>();
                List<AccountShare> FinalListToDel = new List<AccountShare>();
                SetToDel.addAll(lstShareToDelete);
                FinalListToDel.addAll(SetToDel);
                Delete FinalListToDel;
                //End
                //
            }
            
        } catch(DmlException exp) {              
            Logger.get().add(exp, LogSeverity.ERROR).publish();            
        }
        
        
    }
    
}