/*******************************************************************************************
* @Name     IB_RoleBeforeInsertTriggerHandler
* @Author       
* @Date         
* @Group        
* @Description  This is before insert trigger handler class for IB_Role__c object
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Ranjith Kondabathini      06/06/2023        UPDATED ALL CONSTANTS WITH IBOUTIL CLASS REFERENCES
*******************************************************************************************/
public class IB_RoleBeforeInsertTriggerHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp){
        if(TriggerContextUtility.isFirstRun()){
            process(tp.newList);
        }
    }
    
    @testVisible  private static void process (List<IB_Role__c> newRole){
        
         Integer maxAllowed = Integer.valueOf(Label.CI_Max_Limit_Integer);
        
        Map<String, Integer> incomingCountMap = new Map<String, Integer>();
        Set<Id> ciAccountIds = new Set<Id>();
        
        // Step 1: Count incoming roles per (account + programme)
        for (IB_Role__c role : newRole) {
            if ((role.Status__c == 'Invited' || role.Status__c == 'Confirmed') && role.IB_Account__c != null && role.Programme_Selection__c != null) {
                ciAccountIds.add(role.IB_Account__c);
                String compositeKey = role.IB_Account__c + '-' + role.Programme_Selection__c;
                Integer currentCount = incomingCountMap.get(compositeKey) != null ? incomingCountMap.get(compositeKey) : 0;
                incomingCountMap.put(compositeKey, currentCount + 1);
            }
        }
        
        if (ciAccountIds.isEmpty()) return;
        
        // Step 2: Query existing roles per (account + programme)
        Map<String, Integer> existingCountMap = new Map<String, Integer>();
        for (AggregateResult ar : [
            SELECT IB_Account__c accId, Programme_Selection__c prog, COUNT(Id) recordCount
            FROM IB_Role__c
            WHERE Status__c IN ('Invited', 'Confirmed')
            AND IB_Account__c IN :ciAccountIds
            AND Programme_Selection__c != null
            AND IB_Role_Name__c='Chief Invigilator'
            GROUP BY IB_Account__c, Programme_Selection__c
        ]) {
            Id accId = (Id) ar.get('accId');
            String prog = (String) ar.get('prog');
            Integer count = (Integer) ar.get('recordCount');
            
            if (accId != null && prog != null && count != null) {
                String compositeKey = accId + '-' + prog;
                existingCountMap.put(compositeKey, count);
            }
        }
        
        // Step 3: Validate total per (account + programme)
        for (IB_Role__c role : newRole) {
            if ((role.Status__c == 'Invited' || role.Status__c == 'Confirmed') && role.IB_Account__c != null && role.Programme_Selection__c != null) {
                String compositeKey = role.IB_Account__c + '-' + role.Programme_Selection__c;
                Integer existing = existingCountMap.containsKey(compositeKey) ? existingCountMap.get(compositeKey) : 0;
                Integer incoming = incomingCountMap.get(compositeKey);
                Integer total = existing + incoming;
                
                if (total > maxAllowed) {
                    role.addError(IboUtil.PIMS_CI_ROLE_LIMIT_ERROR);
                }
            }
        }
        
        boolean ContainsInstRole=false;
        List<IB_Role__c> CAS_rolelist = new List<IB_Role__c>();
        Set<Id> contactInformationIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        Set<Id> roleIds = new Set<Id>();
        
        Set<ID> accountIDs = new Set<ID>();
        List<Account> accountFields = new List<Account>();
        for (IB_Role__c role : newRole) {
            if(role.IB_Account__c != null){
                accountIDs.add(role.IB_Account__c);
            }
        }
        If(accountIDs.isEmpty() != true){
            accountFields = [SELECT ID, isPartner, Lead_Account__c, RecordType.Name FROM Account WHERE Id in :accountIDs];
        }
        
        for (IB_Role__c role : newRole)
        {
            if(role.Contact_Information_Email__c != null){
                contactInformationIds.add(role.Contact_Information_Email__c);
            }
            if(role.IB_Contact__c != null){
                contactIds.add(role.IB_Contact__c);
            }
            if(role.Ib_Role__c != null){
                roleIds.add(role.Ib_Role__c);
            }
            //validation added by Kevin Fugate on 11/20/2024 for PRB0042033
            
            if((role.Status__c == IboUtil.ROLE_CONFIRMED_STATUS || role.Status__c == 'Applicant') && role.IB_Account__c != null && Test.isRunningTest() != true){
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
            
            system.debug('role.IB_Role_Name__c'+role.IB_Role_Name__c);
            if (role.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_ADMINISTRATOR ||
                role.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_CURRICULUM_USER ||
                role.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_POLICY_USER || 
                role.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_TRANSCRIPT_USER||
                role.IB_Role_Name__c == IboUtil.ROLE_COMMUNICATION_USER ||
                (role.IB_Role_Name__c == IboUtil.ROLE_TEACHER && role.Type__c == 'Online Provider')) {
                    ContainsInstRole=true;
                    break;
                }
            else if(role.IB_Role_Name__c == IboUtil.ROLE_CAS_Coordinator && role.IB_Account__c == null)
                role.addError('IB Account is Required');
            else if(role.IB_Role_Name__c == IboUtil.ROLE_CAS_Coordinator && role.IB_Programme_New__c == null)
                role.addError('IB Programme is Required');
            else if((role.IB_Role_Name__c == IboUtil.ROLE_CAS_Coordinator && role.Programme_Type__c != 'Diploma Programme') || (role.IB_Role_Name__c == IboUtil.ROLE_CAS_Coordinator &&(role.Programme_Status__c != 'Authorized' && role.Programme_Status__c != 'Candidate' )))
                role.addError('Selected IB Programme should be DP Candidate or Authorized');
            else if(role.IB_Role_Name__c == IboUtil.ROLE_CAS_Coordinator && !CAS_rolelist.contains(role) )
                CAS_rolelist.add(role);
        }        
        if(ContainsInstRole==false) new IBRoleTriggerHandler().validateMyProfileInfo(newRole);
        //This line is added on 11-25-2021,update InstituteAdmin on roles
        if(ContainsInstRole == true) new InstituteMgmRolesHandler().updateInstituteAdmin(newRole);
        
        
        map<Id,Contact_Information__c> mapOfConInfo = new map<Id,Contact_Information__c>();
        map<Id,Contact> mapOfCon = new map<Id,Contact>();
        map<Id,IB_Role_Repository__c> mapOfRole = new map<Id,IB_Role_Repository__c>();
        if(!contactInformationIds.isEmpty()) {
            mapOfConInfo = new map<Id,Contact_Information__c>([SELECT Id,Email__c FROM Contact_Information__c WHERE Id IN:contactInformationIds]);
        }
        if(!contactIds.isEmpty()) {
            mapOfCon = new map<Id,Contact>([SELECT Id,User__r.Email FROM Contact WHERE Id =:contactIds]);
        }
        if(!roleIds.isEmpty()) {
            mapOfRole = new map<Id,IB_Role_Repository__c>([SELECT Id,Role_Name__c FROM IB_Role_Repository__c WHERE Id =:roleIds]);
        }
        
        for (IB_Role__c role : newRole) {
            //Added logic to update the Email_Confirmed field as the part This user stroy PRB0041092 by Saurabh(Epam).
            if( mapOfConInfo.containsKey(role.Contact_Information_Email__c)) {
                If(role.Contact_Information_Email__c != null && role.Email_Confirmed__c == false && mapOfConInfo.get(role.Contact_Information_Email__c).Email__c == mapOfCon.get(role.IB_Contact__c).User__r.Email && mapOfRole.get(role.IB_Role__c).Role_Name__c != IboUtil.IBEC_University_Administrator && mapOfRole.get(role.IB_Role__c).Role_Name__c != IboUtil.Institute_Administrator){                
                    role.Email_Confirmed__c = True;
                } 
            }
            
            if((role.IB_Role_Name__c == IboUtil.ROLE_HOS_OVERALL || IboUtil.DEFAULT_PROGRAMME_ROLES_ADDITION.contains(role.IB_Role_Name__c)) && role.IB_Role_Name__c!=IboUtil.ROLE_ADMIN_ASSISTANT && role.Status__c == 'Applicant'){    
                role.Status__c = IboUtil.ROLE_CONFIRMED_STATUS;
            }
            
            if(role.Status__c == IboUtil.ROLE_CONFIRMED_STATUS && (role.End_Date__c == null || role.End_Date__c > system.TODAY()))
                role.Active__c = true;
            else if(role.Status__c != IboUtil.ROLE_CONFIRMED_STATUS || role.End_Date__c <= system.Today())
                role.Active__c = false;           
            if(role.Active__c && role.IB_Programme_New__c==null && IboUtil.DEFAULT_PROGRAMME_ROLES_ADDITION.contains(role.IB_Role_Name__c)) {
                role.Expiry_Date__c = Date.today().addDays(Integer.valueOf(Label.Role_withdrawn_days));
            }
            else if(role.IB_Programme_New__c==null && role.IB_Role_Name__c == IboUtil.ROLE_ADMIN_ASSISTANT && role.Status__c == 'Applicant'){
                role.Expiry_Date__c = Date.today().addDays(Integer.valueOf(Label.Role_withdrawn_days));
            }
        }
        
        IB_RoleTriggerHelper.populateProgrammeOnOnboardingRoles(newRole, new Map<Id,IB_Role__c>());
        
        try{
            if(CAS_rolelist.size()>0)
                IB_RoleTriggerHelper.IBRole_CAS_confirmed_Validation(CAS_rolelist); 
        }catch(Exception exp){
            Logger.get().add(exp, LogSeverity.ERROR).publish();
        }
        
        List<AccountContactRelation> AccCon=new List<AccountContactRelation>();
        List<AccountContactRelation> uAccCon=new List<AccountContactRelation>();
        List<AccountContactRelation> DAccCon=new List<AccountContactRelation>();
        List<AccountShare> accountSharing  = new List<AccountShare>();
        List<AccountShare> lstShareToDelete = new List<AccountShare>();
        
        
        Set<ID> roleAccID = new Set<ID>();
        Set<ID> roleConID = new Set<ID>();
        List<Account> stt = new List<Account>();
        
        for(IB_Role__c roll:newRole)
        {
            if(roll.IB_Account__c != null && roll.IB_Contact__c!=null)
            {
                roleAccID.add(roll.IB_Account__c);  
                roleConID.add(roll.IB_Contact__c);  
            }
        }
        
        Map<Id,Account> sttValue =new Map<Id,Account>([Select id,RecordType.Name from Account where id IN: roleAccID]);
        List<IB_Role__c> opTemp = new List<IB_Role__c>();
        opTemp = [Select id, IB_Role_Name__c,Status__c, IB_Programme_New__r.RecordType.Name, IB_Contact__c, IB_Account__c from IB_Role__c where (IB_Role_Name__c = :IboUtil.ROLE_Billing_Contact OR IB_Role_Name__c = :IboUtil.ROLE_ONLINE_COORDINATOR OR IB_Role_Name__c = :IboUtil.ROLE_Online_Admin_Assistant) AND  IB_Account__r.id IN: roleAccID AND Status__c != 'Withdrawn' AND Status__c != 'Declined'];
        Integer OCcount=0,OAAcount=0,BCcount=0;
        
        List<IB_Role__c> BCID = new List<IB_Role__c>();
        List<IB_Role__c> OCID = new List<IB_Role__c>();
        List<IB_Role__c> OAAID = new List<IB_Role__c>();
        List<IB_Role__c> OCData = new List<IB_Role__c>();
        
        
        OCData = [Select id, IB_Role_Name__c,Status__c, Email__c ,IB_Contact__c, IB_Contact__r.Name, IB_Contact__r.Email from IB_Role__c where IB_Role_Name__c = :IboUtil.ROLE_ONLINE_COORDINATOR AND IB_Account__r.id IN: roleAccID AND Status__c != 'Withdrawn' AND Status__c != 'Declined' AND Status__c = :IboUtil.ROLE_CONFIRMED_STATUS Limit 1];
        
        IB_Programme__c tempProg = new IB_Programme__c();
        
        System.debug('Apple Main '+ opTemp);      
        for(IB_Role__c temp : opTemp)
        {
            if(temp.IB_Role_Name__c == IboUtil.ROLE_Billing_Contact)
            {                
                if( temp.Status__c == IboUtil.ROLE_CONFIRMED_STATUS)
                    BCcount++;
                BCID.add(temp);
            }
            
            else if(temp.IB_Role_Name__c == IboUtil.ROLE_ONLINE_COORDINATOR) 
            {                
                if( temp.Status__c == IboUtil.ROLE_CONFIRMED_STATUS)
                    OCcount++;
                OCID.add(temp);
            }
            
            else if(temp.IB_Role_Name__c == IboUtil.ROLE_Online_Admin_Assistant) 
            {
                if(temp.Status__c == IboUtil.ROLE_CONFIRMED_STATUS)
                    OAAcount++;
                OAAID.add(temp);
            }
        }
        
        for(IB_Role__c opRole : newRole)
        {
            Account acc = sttValue.get(opRole.IB_Account__c);
            
            if(opRole.IB_Programme_New__c != null || opRole.IB_Role_Name__c == IboUtil.ROLE_Billing_Contact){
                if (opRole.IB_Role_Name__c != IboUtil.ROLE_Billing_Contact)
                {
                    tempProg =  ProgrammeDAO.getInstance().getProgrammeById(opRole.IB_Programme_New__c);
                }
                if(opRole.IB_Role_Name__c == IboUtil.ROLE_ONLINE_COORDINATOR)
                {
                    if(tempProg.Status__c!='Authorized' && tempProg.StageName__c != 'Evaluation')
                        opRole.addError('You cannot submit this role application since the selected IB Programme is unauthorized.');
                    for(IB_Role__c checkRole : OCID)
                    {
                        if( opRole.IB_Account__c == checkRole.IB_Account__c && OCcount>0)
                        {
                            opRole.addError('You cannot submit this role application since the maximum number of role holders has been reached.');
                            
                        }
                        else if(opRole.IB_Contact__c == checkRole.IB_Contact__c && opRole.IB_Programme_New__c == checkRole.IB_Programme_New__c && opRole.IB_Account__c == checkRole.IB_Account__c)
                        { 
                            opRole.addError('You cannot continue because the role is already assigned to this user for this Online Provider.');
                            
                        }
                    }
                }
                else if(opRole.IB_Role_Name__c == IboUtil.ROLE_Billing_Contact)
                {
                    for(IB_Role__c checkRole : BCID)
                    {
                        if(opRole.IB_Account__c == checkRole.IB_Account__c && BCcount>0 && acc.RecordType.Name  == 'Online Provider')
                        {                            
                            opRole.addError('You cannot submit this role application since the maximum number of role holders has been reached.');    
                        }
                    }
                }
                else if(opRole.IB_Role_Name__c == IboUtil.ROLE_Online_Admin_Assistant)
                {
                    
                    if(tempProg.Status__c!='Authorized' && tempProg.StageName__c != 'Evaluation')
                        opRole.addError('You cannot submit this role application since the selected IB Programme is unauthorized.');
                    
                    for(IB_Role__c checkRole : OAAID)
                    {
                        if(opRole.IB_Contact__c == checkRole.IB_Contact__c && opRole.IB_Programme_New__c == checkRole.IB_Programme_New__c && opRole.IB_Account__c == checkRole.IB_Account__c)
                        {
                            opRole.addError('You cannot continue because the role is already assigned to this user for this Online Provider.');                            
                        }
                        else if (opRole.IB_Account__c == checkRole.IB_Account__c && OAAcount>=3)
                        {
                            opRole.addError('You cannot submit this role application since the maximum number of role holders has been reached.');
                        }
                    }
                }
                else if (opRole.IB_Role_Name__c == IboUtil.ROLE_TEACHER && opRole.Type__c == 'Online Provider')
                {
                    
                    if(tempProg.Status__c!='Authorized' && tempProg.StageName__c != 'Evaluation')
                        opRole.addError('You cannot submit this role application since since the selected IB Programme is unauthorized.');
                    
                    if(OCData != Null)
                    {
                        opRole.Online_Coordinator_Name__c=OCData[0].IB_Contact__r.Name;
                        opRole.Online_Coordinator_Email__c = OCData[0].IB_Contact__r.Email;                        
                        opRole.Online_Coordinator__c = OCData[0].IB_Contact__c;
                    }
                } 
            }                                    
            else if(opRole.IB_Role_Name__c == IboUtil.ROLE_ONLINE_COORDINATOR  || opRole.IB_Role_Name__c == IboUtil.ROLE_Online_Admin_Assistant || (opRole.IB_Role_Name__c == IboUtil.ROLE_TEACHER && opRole.Type__c == 'Online Provider'))
                opRole.adderror('IB Programme: You must enter a value.');
            
        }
        
        List<AccountContactRelation> AccConR = [SELECT id, iSActive ,AccountId,Contactid from AccountContactRelation Where AccountId IN: roleAccID AND Contactid IN: roleConID];
        Map<String,AccountContactRelation> accRecValue = new Map<String,AccountContactRelation>(); 
        for (AccountContactRelation acr : AccConR)
        {
            accRecValue.put(acr.AccountId+','+acr.ContactId,acr);
        }
        
        List<User> userL = [SELECT id,userName,Name, Contactid From User Where Contactid IN : roleConID];
        Map<String,User> userM = new Map<String,User>();
        for(User u : userL)
        {
            userM.put(u.Contactid,u);
        }
        
        List<IB_Role__C> roleL = new List<IB_Role__C>();
        if(!roleAccID.isEmpty())
        {
            roleL=[SELECT Id , IB_Account__c, Status__c , IB_Role_Name__c FROM IB_Role__C WHERE IB_Account__c IN :roleAccID AND Status__c = :IboUtil.ROLE_CONFIRMED_STATUS AND (IB_Role_Name__c =:IboUtil.ROLE_Programme_Coordinator OR IB_Role_Name__c = :IboUtil.ROLE_HOS)]; 
        }
        Map<String,IB_Role__C> roleM = new Map<String,IB_Role__C>();
        for (IB_Role__C r : roleL)
        {
            roleM.put(r.IB_Account__c,r);
        }
        
        
        List<AccountShare> roleASL = [SELECT ID, AccountID, UserorGroupID FROM AccountShare WHERE AccountID IN :roleAccID AND UserorGroupID  IN : userL ];
        Map<String,AccountShare> roleASM = new Map<String,AccountShare>();  
        for(AccountShare a : roleASL)
        {
            roleASM.put(a.AccountID+','+a.UserorGroupID,a);
        }
        for(IB_Role__c rol:newRole)
        {
            
            List<Account> st = new List<Account>();
            st.add(sttValue.get(rol.IB_Account__c));
            
            if(st[0]!=null && !st.isEmpty()){
                if(rol.Status__c==IboUtil.ROLE_CONFIRMED_STATUS && st[0].RecordType.Name=='School Account')
                {
                    List<AccountContactRelation> accRec = new List<AccountContactRelation>();
                    accRec.add(accRecValue.get(rol.IB_Account__c+','+rol.IB_Contact__c));
                    
                    if(accRec[0]==null || accRec.isEmpty())
                    {
                        AccountContactRelation UPCon=new AccountContactRelation(isActive=true, AccountId=rol.IB_Account__c,ContactId=rol.IB_Contact__c,CurrencyIsoCode='USD');
                        AccCon.add(UpCon);
                    }
                    else if(accRec[0].isActive==false)
                    {
                        accRec[0].isActive=True;
                        uAccCon.add(accRec[0]);
                    }
                    
                    if(rol.IB_Role_Name__c==IboUtil.ROLE_Programme_Coordinator || rol.IB_Role_Name__c == IboUtil.ROLE_HOS)
                    {
                        List<User> uList = new List<User>();
                        uList.add(userM.get(rol.IB_Contact__c));
                        if(uList[0]!=null && !uList.isEmpty())
                        {
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
                
                else if(rol.Status__c=='Withdrawn' && st[0].RecordType.Name=='School Account')
                {
                    List<AccountContactRelation> accRec = new List<AccountContactRelation>();
                    accRec.add(accRecValue.get(rol.IB_Account__c+','+rol.IB_Contact__c));
                    if(accRec[0]!=null && !accRec.isEmpty())
                    {
                        accRec[0].isActive=false;
                        uAccCon.add(accRec[0]);
                    }
                    List<IB_Role__C> rolesConfirmed = new List<IB_Role__C>();
                    rolesConfirmed.add(roleM.get(rol.IB_Account__c));
                    
                    List<User> uList = new List<User>();
                    uList.add(userM.get(rol.IB_Contact__c));
                    if(uList[0]!=null && !uList.isEmpty() && ( rolesConfirmed.isEmpty() || rolesConfirmed[0]==null))
                    {
                        lstShareToDelete.add(roleASM.get(rol.IB_Account__c+','+uList[0].id));  
                    }
                }
            }    
        }
        
        if(AccCon!=null && !AccCon.isEmpty())
        {
            Insert AccCon;
        }
        if(uAccCon!=null && !uAccCon.isEmpty())
        {
            Set<AccountContactRelation> myset = new Set<AccountContactRelation>();
            List<AccountContactRelation> result = new List<AccountContactRelation>();
            myset.addAll(uAccCon);
            result.addAll(myset);
            Update result;
        } 
        
        try 
        {  
            if(accountSharing!=null && !accountSharing.isEmpty())
            {
                INSERT accountSharing;
            }
            if(lstShareToDelete!=null && !lstShareToDelete.isEmpty())
            {
                DELETE lstShareToDelete;  
            }
        } 
        catch(DmlException exp) 
        {   
            Logger.get().add(exp, LogSeverity.ERROR).publish();
        }
    }
}