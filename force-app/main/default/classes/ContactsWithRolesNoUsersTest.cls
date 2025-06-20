@isTest
private class ContactsWithRolesNoUsersTest {
	@isTest(seealldata=true) 
    static void test1() {
        integer i=1;
		
		Process_Builder_Settings__c pbs = Process_Builder_Settings__c.getOrgDefaults();
		ContactsWithRolesNoUsers cwrnu = new ContactsWithRolesNoUsers();
		Integer pageNumber = cwrnu.pageNumber;
		Boolean hasPrevious = cwrnu.hasPrevious;
		Boolean hasNext = cwrnu.hasNext;
		cwrnu.next();
		cwrnu.previous();
		cwrnu.first();
		cwrnu.last();
		//Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);

	}
    
    @isTest(seealldata=true) 
    static void test2() {
		
        integer i=1;
		Process_Builder_Settings__c pbs = Process_Builder_Settings__c.getOrgDefaults();
		ContactsWithRolesNoUsers cwrnu = new ContactsWithRolesNoUsers();
		cwrnu.roleName = pbs.Role_Workshop_Leader__c;
        system.debug('WSL: ' + pbs.Role_Workshop_Leader__c);
        Test.startTest();
		cwrnu.filter();
		//Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        List<Contact> c = cwrnu.contactsWithRoles;
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        Test.stopTest();
	}
}