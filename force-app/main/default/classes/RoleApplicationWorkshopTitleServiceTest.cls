@isTest
private class RoleApplicationWorkshopTitleServiceTest {
    
    @isTest
    static void RoleApplicationWorkshopTitleServiceTestMethod()
    {
        RoleApplicationWorkshopTitleService.workshopTitles=NULL;
        RoleApplicationWorkshopTitleService.roleId = '7010D0000B09UYG';
        
        RoleApplicationWorkshopTitleService.isWorkshopTitlesCached = false;
        RoleApplicationWorkshopTitleService.getWorkshopTitlesByRoleId();
    }

}