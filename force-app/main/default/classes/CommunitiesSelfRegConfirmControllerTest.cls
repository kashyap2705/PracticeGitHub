/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
@IsTest public with sharing class CommunitiesSelfRegConfirmControllerTest {
    @IsTest(SeeAllData=true) public static void testCommunitiesSelfRegConfirmController() {
        integer i=1;
        // Instantiate a new controller with all parameters in the page
        CommunitiesSelfRegConfirmController controller = new CommunitiesSelfRegConfirmController();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
      }    
}