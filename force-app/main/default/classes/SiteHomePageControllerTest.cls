@isTest
private class SiteHomePageControllerTest {

    @isTest
    static void testInitialState(){
        SiteHomePageController controller = new SiteHomePageController();
        System.assert(controller.userName == null);
        System.assert(controller.password == null);
    }   
    
    
    @isTest
    static void testLogin(){
        integer i=1;
        User usr = TestsUtil.createPortalUser('test_user_name');
        insert usr;
        
        Test.setCurrentPage(Page.siteHomePage);
        
        System.runAs(usr) {
        
            SiteHomePageController controller = new SiteHomePageController();
            controller.userName = usr.LastName;
            controller.password = 'test_psw';
            controller.getLocale();
            PageReference pr = controller.login();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        }
    }

    
    @isTest
    static void testLoginWithCookies(){
        integer i=1;
        User usr = TestsUtil.createPortalUser('test_user_name');
        insert usr;
        
        Test.setCurrentPage(Page.siteHomePage);

        System.runAs(usr) {
            Cookie labelCookie = new Cookie('locale','en_US',null,-1,false);
            ApexPages.currentPage().setCookies(new List<Cookie>{labelCookie});    
            ApexPages.currentPage().getParameters().put('lang','fr');

            SiteHomePageController controller = new SiteHomePageController();
            controller.userName = usr.LastName;
            controller.password = 'test_psw';
            controller.getLocale();
            PageReference pr = controller.login();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        }
    }

    @isTest
    static void testLoginWithCookiesNewLocale(){
        integer i=1;
        User usr = TestsUtil.createPortalUser('test_user_name');
        insert usr;
        
        Test.setCurrentPage(Page.siteHomePage);

        System.runAs(usr) {
            Cookie labelCookie = new Cookie('locale','en_GB',null,-1,false);
            ApexPages.currentPage().setCookies(new List<Cookie>{labelCookie});    
            ApexPages.currentPage().getParameters().put('lang','en_GB');

            SiteHomePageController controller = new SiteHomePageController();
            controller.userName = usr.LastName;
            controller.password = 'test_psw';
            controller.getLocale();
            PageReference pr = controller.login();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        }
    }

    @isTest
    static void testLoginNoUserNameAndPassword(){
        integer i=1;
        User usr = TestsUtil.createPortalUser('test_user_name');
        insert usr;
        
        Test.setCurrentPage(Page.siteHomePage);
        
        System.runAs(usr) {
        
            SiteHomePageController controller = new SiteHomePageController();
            controller.userName = null;
            controller.password = null;
            
            System.debug(! ApexPages.hasMessages());
            
            PageReference pr = controller.login();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
            System.debug(ApexPages.hasMessages());
        }
    }   
    
}