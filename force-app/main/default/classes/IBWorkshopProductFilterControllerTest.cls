@isTest
public class IBWorkshopProductFilterControllerTest {
    
    @isTest
    static void testIBWorkshopProductFilterController() {
        Account account = TestsUtil.createAccount('Test Account');
        account.IBIS_ID__c = '232323';
        insert account;

        Contact contact = TestsUtil.createContact('Tester', 'test@test.com', 'test@test.com', Date.today().addYears(-22), null);
        insert contact;

        User user = TestsUtil.createPortalUser('test');
        insert user;
        System.runAs(user) {
            Date today = Date.today();
            IB_Workshop_Details__c detail = new IB_Workshop_Details__c(
            	Name = 'Test Detail'
            );
            insert detail;
            IB_Workshop_Products__c product = new IB_Workshop_Products__c(
            	Name = 'Test Product',
                Available_From__c = today,
                Available_To__c = today,
                Delivery_Mode__c = 'Online',
                IB_Region__c = 'IBA',
                Language_of_Delivery__c = 'English',
                IB_Workshop_Detail__c = detail.Id
            );
            insert product;
            IB_Workshop_Products__c product2 = new IB_Workshop_Products__c(
                Name = 'Test Product',
                Available_From__c = today,
                Available_To__c = today,
                Delivery_Mode__c = 'Face 2 Face',
                IB_Region__c = 'IBA',
                Language_of_Delivery__c = 'English',
                IB_Workshop_Detail__c = detail.Id
            );
            insert product2;

            
            PageReference pageRef = Page.IBWorkshopProductFilter;
            Test.setCurrentPage(pageRef);
            
            IBWorkshopProductFilterController controller = new IBWorkshopProductFilterController();
            
            List<IB_Workshop_Products__c> products = controller.getWorkshopProducts();
            List<SelectOption> items = controller.getProgrammeItems();
            
            controller.filter();
            controller.beginning();
            controller.next();
            controller.previous();
            controller.end();
            
            List<SelectOption> categoryItems = controller.getCategoryItems();
            List<SelectOption> languageItems = controller.getLanguageItems();
            Boolean disablePrevious = controller.getDisablePrevious();
            Boolean disableNext = controller.getDisableNext();
            Integer total_size = controller.getTotal_size();
            Integer pageNumber = controller.getPageNumber();
            Integer totalPages = controller.getTotalPages();
    		
            controller.setProgramme('PYP');
            controller.setCategory('Category 1');
            controller.setLanguage('English');
            controller.setAvailableTo(today);
            controller.setAvailableFrom(today);
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            String programme = controller.getProgramme();
            String category = controller.getCategory();
            String language = controller.getLanguage();
            Date availableTo = controller.getAvailableTo();
            Date availableFrom = controller.getAvailableFrom();
            products = controller.getWorkshopProducts();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020        
        }

    }

}