@isTest

public with sharing class IconControllerTest {

 public static testMethod void testIconControllerTest() {
    IconController ic = new IconController();
    Test.startTest();
      ic.setIconFileName('0');
      system.assertEquals('0',ic.getIconFileName());
      String result = ic.getIconSvg();
      system.assertEquals(null, result);
      ic.setIconFileName('training');
      result = ic.getIconSvg();
      ic.setIconFileName('person-plus');
      result = ic.getIconSvg();
      ic.setIconFileName('magnifying-glass');
      result = ic.getIconSvg();
      ic.setIconFileName('link-arrow');
      result = ic.getIconSvg();
      ic.setIconFileName('leftArrow');
      result = ic.getIconSvg();
      ic.setIconFileName('globe');
      result = ic.getIconSvg();
      ic.setIconFileName('downArrow');
      result = ic.getIconSvg();
      ic.setIconFileName('close');
      result = ic.getIconSvg();
      ic.setIconFileName('check');
      result = ic.getIconSvg();
      ic.setIconFileName('check-circle');
      result = ic.getIconSvg();
      ic.setIconFileName('cal');
      result = ic.getIconSvg();
      ic.setIconFileName('roleTraining');
      result = ic.getIconSvg();
      ic.setIconFileName('assignment');
      result = ic.getIconSvg();
    Test.stopTest();
  }
}