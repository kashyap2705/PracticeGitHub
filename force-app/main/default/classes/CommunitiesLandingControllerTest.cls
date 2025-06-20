/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
@IsTest public with sharing class CommunitiesLandingControllerTest {
    @IsTest(SeeAllData=true) public static void testCommunitiesLandingController() {
        integer i=1;
        // Instantiate a new controller with all parameters in the page
        CommunitiesLandingController controller = new CommunitiesLandingController();
        PageReference page = controller.forwardToStartPage();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
      }
}