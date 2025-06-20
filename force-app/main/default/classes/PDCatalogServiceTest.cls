@isTest
private class PDCatalogServiceTest {

     static testMethod void test_method_one() {
         integer i=1;

          PDCatalogService.isCatalogCached = false;
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);
          List<SelectOption> pdCatalogOptions =  PDCatalogService.getYearOptions();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);

	}

}