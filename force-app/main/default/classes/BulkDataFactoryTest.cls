public class BulkDataFactoryTest {
    public static List<IB_Role_Repository__c> loadRoleRepoData(){
		            List<sObject> IbRoleData = Test.loadData(IB_Role_Repository__c.sObjectType, 'IBRoleRepository');
        return IbRoleData;
    }
}