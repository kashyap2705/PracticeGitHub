/**
* <h1> IBPortalNavBarCtrlTest </h1>
* This class is created to test the IBPortalNavBarCtrl
As part of cr-691 
* 
* @author  Ali Haider - Plumlogix
* @version 1.0
* @since   2020-04-15

Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 


*/
@istest
public class IBPortalNavBarCtrlTest {
    
    @isTest static void My_Profile() {
        PageReference pageRef = Page.IBPortalEditProfile;
        Test.setCurrentPage(pageRef);
        System.Test.startTest();
        String Page_Name = String.valueOf(ApexPages.currentPage());
        System.debug('test: '+Page_Name);
        IBPortalNavBarCtrl obj=new IBPortalNavBarCtrl();
        String test = obj.getPageText();
        System.assertEquals('My Profile', test);
        Boolean test_check = obj.getPagecheck();
        System.assertEquals(False, test_check);
        System.Test.StopTest();
    }
    @isTest static void Forgot_Password() {
        PageReference pageRef = Page.IBPortalForgotPassword;
        Test.setCurrentPage(pageRef);
        String Page_Name = String.valueOf(ApexPages.currentPage());
        System.debug('test: '+Page_Name);
        System.Test.startTest();
        IBPortalNavBarCtrl obj=new IBPortalNavBarCtrl();
        String test = obj.getPageText();
        System.assertEquals('Forgot Password', test);
        Boolean test_check = obj.getPagecheck();
        System.assertEquals(False, test_check);
        System.Test.StopTest();
    }
    @isTest static void Create_New_Account() {
        PageReference pageRef = Page.IBPortalRegistration;
        Test.setCurrentPage(pageRef);
        String Page_Name = String.valueOf(ApexPages.currentPage());
        System.debug('test: '+Page_Name);
        System.Test.startTest();
        IBPortalNavBarCtrl obj=new IBPortalNavBarCtrl();
        String test = obj.getPageText();
        System.assertEquals('Create new account', test);
        Boolean test_check = obj.getPagecheck();
        System.assertEquals(False, test_check);
        System.Test.StopTest();
    }
    //below method added by Prerna Sobti on 19-06-2023 for ECM00603 
    @isTest static void eNewsLettersSignup() {
        
        PageReference pageRef = Page.ENewsLetter;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        IBPortalNavBarCtrl obj=new IBPortalNavBarCtrl();
        String getPageText = obj.getPageText();
        System.assertEquals('eNewsLetters Signup', getPageText);
        Boolean getPageCheck =  obj.getPagecheck();
        System.assertEquals(true, getPageCheck);
        Test.stopTest();
        
    }
}