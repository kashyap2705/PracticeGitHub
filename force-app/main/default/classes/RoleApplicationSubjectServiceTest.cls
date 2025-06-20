@isTest
private class RoleApplicationSubjectServiceTest {
    
       @isTest
    static void RoleApplicationSubjectServiceTestMethod()
    {
        
        RoleApplicationSubjectService.subject=NULL;
        RoleApplicationSubjectService.subjects=NULL;
        RoleApplicationSubjectService.subjectsByRoleList=NULL;
        
        RoleApplicationSubjectService.subjectId=NULL;
        RoleApplicationSubjectService.roleId=NULL;
        RoleApplicationSubjectService.roleList=NULL;
        
        RoleApplicationSubjectService.getSubjectById();
        RoleApplicationSubjectService.getSubjectsByRoleId();
        RoleApplicationSubjectService.getSubjectsByRoleList();
        RoleApplicationSubjectService.setSubjectId(NULL);
        RoleApplicationSubjectService.setRoleId(NULL);
        RoleApplicationSubjectService.setRoleList(NULL);
      RoleApplicationSubjectService.isSubjectCached=true;
        RoleApplicationSubjectService.isSubjectsCached=true;
        RoleApplicationSubjectService.isSubjectsByRoleListCaches=true;
        RoleApplicationSubjectService.getSubjectById();
        RoleApplicationSubjectService.getSubjectsByRoleId();
        RoleApplicationSubjectService.getSubjectsByRoleList();
        RoleApplicationSubjectService.setSubjectId(NULL);
        RoleApplicationSubjectService.setRoleId(NULL);
        RoleApplicationSubjectService.setRoleList(NULL);
    }

}