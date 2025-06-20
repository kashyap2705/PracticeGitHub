@isTest public class RoleRepositoryDAOTest {
    @isTest static void test_method_one() {
        RoleRepositoryDAO role = new RoleRepositoryDAO();
        role.getRoleById(null);
        role.getAllMyIBRoles();
        role.getAllRoles();
        RoleRepositoryDAO.getInstance();
    }
}