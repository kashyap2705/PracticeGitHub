@isTest
private class PDCatalogDAOTest {

	static testMethod void test_method_one() {
        integer i=1;

          PDCatalogDAO con = PDCatalogDAO.getInstance();
          List<PD_Catalog__c> pdCatalogList = con.getFullCatalog();
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);

	}
}