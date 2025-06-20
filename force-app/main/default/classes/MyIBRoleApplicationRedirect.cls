public without sharing class MyIBRoleApplicationRedirect {

    public IB_Role_Repository__c currentRole {get;set;}

    public MyIBRoleApplicationRedirect(){}
	public String opType {get;set;}
    public PageReference redirect(){
        PageReference pageRef;
        RoleRepositoryService.roleId = ApexPages.currentPage().getParameters().get('roleId');
        opType = ApexPages.currentPage().getParameters().get('type');
        currentRole = RoleRepositoryService.getRoleById();

        system.debug(loggingLevel.error, 'currentRole: ' + currentRole.Id);
    
            if(currentRole.Custom_Application__c == '' || currentRole.Custom_Application__c == null) pageRef = Page.MyIBRoleApplication;
        else if(opType == 'OnlineProvider' && currentRole.Role_Name__c == 'Teacher')
        {
            pageRef = new PageReference('/apex/' + 'onlineProviderSearch'); 
        }
        else pageRef = new PageReference('/apex/' + currentRole.Custom_Application__c);                     
        pageRef.getParameters().put('roleId',ApexPages.currentPage().getParameters().get('roleId'));
        pageRef.setRedirect(true);

        return pageRef;
    }
}