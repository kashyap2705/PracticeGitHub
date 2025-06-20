@isTest
private class IbenSuggestedFindingsControllerTest {
 @isTest static void testLabelList() {
     IbenSuggestedFindingsController obj= new IbenSuggestedFindingsController();
     //obj.questionAttr="";
     obj.labelsAttr='abi>c\\|xyz\\|123\\|jaI>sd\\|ksad\\|';
     Test.startTest();
     obj.getLabelList();
     
     Test.stopTest();
         // Decimal celsius = TemperatureConverter.FahrenheitToCelsius(70);
       // System.assertEquals(21.11,celsius);
    }
}