@isTest
private class ArticleSearchControllerTest {

    @isTest
    static void testGetArticles() {
        Knowledge__kav kk = new Knowledge__kav(Title='title1',urlName='test-article123');
        insert kk;
        Test.startTest();
        ArticleSearchController.getArticles('Test','en_US');
        Test.stopTest();
    }
    @isTest
    static void TestGetArticlesCatch() {
        Test.startTest();
        try {
            ArticleSearchController.getArticles(null,'');
        } catch(Exception ex) {
            
        }
        Test.stopTest();
    }
}