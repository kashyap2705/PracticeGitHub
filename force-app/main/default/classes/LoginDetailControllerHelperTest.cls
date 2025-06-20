@isTest
public class LoginDetailControllerHelperTest {
	 
     public static testMethod void test1() {
         
         String days = 'LAST_N_DAYS:30';
         LoginDetailControllerHelper.getLoginTimeSpan(days);
         String days1 = 'LAST_N_DAYS:60';
         LoginDetailControllerHelper.getLoginTimeSpan(days1);
         String days2 = 'LAST_N_DAYS:90';
         LoginDetailControllerHelper.getLoginTimeSpan(days2);
        
         Contact contact = new Contact(firstName='steve',lastName='smith',email='test@test.com');
         insert contact;
         
         // Insert Role
         IB_Role_Repository__c roleRepo = new IB_Role_Repository__c();
         roleRepo.Role_Name__c = 'Community Moderator';
         roleRepo.Category__c = 'Programme Development';
         roleRepo.Role_Retired__c = false;
         insert roleRepo;
         
         // Insert Role and Application
         IB_Role__c role = new IB_Role__c();
         role.IB_Contact__c = contact.id;
         role.IB_Role__c = roleRepo.id;
         role.Active__c = true;
         insert role;
        
         LoginDetailControllerHelper.getContactIds();
         User user = TestsUtil.createPortalUser('test');
         user.IsActive = true;
         insert user;
         
         Id contactId = [SELECT ContactId
                            FROM User
                            WHERE id =: user.id].ContactId;
         
         Set<Id> contactIdsSet = new Set<Id>();
         contactIdsSet.add(contactId);
         
         LoginDetailControllerHelper.getUserNameByUserIdMap(contactIdsSet);
        
         Map<Id, String> userNameByUserId = new Map<Id, String>();
         userNameByUserId.put(user.Id, user.Name);
         Datetime loginTimeSpan;
         loginTimeSpan = Datetime.now() - 30;
         LoginDetailControllerHelper.getCommunityModeratorLoginHistory(userNameByUserId,loginTimeSpan);
         LoginDetailControllerHelper.getLoanDetailWrapperByUserId(contactIdsSet,loginTimeSpan);
         
         LoginDetailController.getCommunityModeratorLoginDetails(days);
         LoginDetailController.getCommunityModeratorNonLoginDetails(days);
    }
    
}