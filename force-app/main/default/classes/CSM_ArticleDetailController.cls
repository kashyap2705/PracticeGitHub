public with sharing class CSM_ArticleDetailController {
    private static final String NO_ARTICLE_FOUND = 'No article found';
    @AuraEnabled(cacheable=true)
    public static Knowledge__kav getArticleDetail(Id articleId){
        try {
            List<Knowledge__kav> articles = [SELECT KnowledgeArticleId, FAQ_Answers_Question__c, Answer_Rich_Text__c
                        FROM Knowledge__kav 
                        WHERE PublishStatus=:CSM_IboUtil.ARTICLE_Publish_Status_ONLINE 
                        AND Id =:articleId UPDATE VIEWSTAT];
            if (articles.size() > 0) {
                return articles[0];
            }
            throw new AuraHandledException(NO_ARTICLE_FOUND);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}