public class AIBWSRolesHandler {
 
    public void ProcessAIBWSRoles(List<IB_Role__c> roles)
    {
        list<id> AccList=new list<id>();
        boolean hasIBECAdmin=false;
        Set<id>ContactIds=new set<id>();
        for(IB_Role__c rol:roles)
        {
            if(rol.status__c!='Applicant')   
                AccList.add(rol.IB_Account__c);
            ContactIds.add(rol.IB_Contact__c);
        }
        list<IB_Role__c> confirmTrans = new list<IB_Role__c>();
        list<IB_Role__c> adRole = new list<IB_Role__c>();
        for(IB_Role__c rol : [select id,status__c,ContactUserLanguage__c,ContactInfo_Emailvalue__c,IB_Contact__c,IB_Role_Name__c,Contact_Information_Email__c,Contact_Information_Phone__c from IB_Role__c where
                              IB_Account__c IN:AccList and status__c='Confirmed' and 
                              ((IB_Role_Name__c='Association Admin' and id not in: roles)) ])
        {
                                       adRole.add(rol);
        }  
        for(IB_Role__c rol:roles)
        {
            if(rol.IB_Role_Name__c=='Association Admin' && rol.Status__c=='Confirmed')
            {
                hasIBECAdmin=true;
            }
            
        }
        if(adRole.size()>0 && hasIBECAdmin==true)
        {
            list<IB_role__c>rolestowithdraw=new list<ib_role__c>();
            for(IB_role__c AIBWSAdminRolefromList:adRole)
            {
                AIBWSAdminRolefromList.status__c='Withdrawn';
                ContactIds.add(AIBWSAdminRolefromList.IB_Contact__c);
                rolestowithdraw.add(AIBWSAdminRolefromList);
            }
        try{
             update rolestowithdraw;
            if(ContactIds.size()>0)PermissionSetMaintenance.permissionMaintenance(contactIds);
        }
        catch(Exception e){
            system.debug('Error Message: ' + e.getMessage());
        }
        }
    }
}