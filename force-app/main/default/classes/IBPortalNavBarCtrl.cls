/**
* <h1> IBPortalNavBarCtrl </h1>
* This class is controller related to IBPortalNavBar(VFPage Component)
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
public class IBPortalNavBarCtrl {
    public void IBPortalNavBarCtrl(){
       
    }
    public String getPageText()
    {
        String pageName = String.valueOf(ApexPages.currentPage());
        if(pageName.contains('IBPortalEditProfile')||pageName.contains('ibportaleditprofile'))
            return 'My Profile';
        else if(pageName.contains('IBPortalForgotPassword')||pageName.contains('ibportalforgotpassword')||pageName.contains('ibportalforgotpasswordconf'))
            return 'Forgot Password';
        else if(pageName.contains('IBPortalRegistration')||pageName.contains('ibportalregistration')||pageName.contains('ibportalselfregconfirm'))
            return 'Create new account';
        //added by prerna on 16-06-2023 for ECM00603 Start
        else if(pageName.containsIgnoreCase('ENewsLetter'))
            return 'eNewsLetters Signup';
        //end
        else
            return pageName;
    }
    public Boolean getPagecheck()
    {
        String pageName = String.valueOf(ApexPages.currentPage());
        //added ENewsLetter check by Prerna Sobti on 16-06-2023 for ECM00603 
        if(pageName.contains('IBPortalEditProfile')|| pageName.contains('IBPortalForgotPassword')||pageName.contains('IBPortalRegistration')||pageName.contains('ibportalforgotpasswordconf')||pageName.contains('ibportalselfregconfirm')||pageName.containsIgnoreCase('ENewsLetter'))
            return true;
        else
            return false;
    }
}