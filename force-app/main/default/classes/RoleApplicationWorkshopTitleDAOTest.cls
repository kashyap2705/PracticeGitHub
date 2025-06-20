@isTest
private class RoleApplicationWorkshopTitleDAOTest {
    
    @isTest
    static void RoleApplicationWorkshopTitleDAOTestMethod()
    {
        RoleApplicationWorkshopTitleDAO obj = new RoleApplicationWorkshopTitleDAO();
        obj.workshopTitles=NULL;
        
        obj.getWorkshopTitlesByRoleId(NULL);
        RoleApplicationWorkshopTitleDAO.getInstance();
    }

}