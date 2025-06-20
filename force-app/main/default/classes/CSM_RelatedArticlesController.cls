public without sharing class CSM_RelatedArticlesController {
    public static List<Knowledge__kav> relatedArticles = new List<Knowledge__kav>();
    private static Set<Id> promotedIds = new Set<Id>();
    private static Set<String> dataCategoriesSet = new Set<String>();
    private static Map<Id,Set<String>> knowledgeDataCategoryMap = new Map<Id,Set<String>>();
    private static Map<Id, Knowledge__kav> knowledgeMap = new Map<Id, Knowledge__kav>();
    private static RelatedArticlesRequest relatedArticlesRequest;
    private static final Integer requiredRelatedArticlesCount = 5;
    private static List<String> category3List;
    private static List<String> category2List;
    private static Map<String, String> Master_ChildArticleIdMap = new Map<String, String>();
    private static Map<String, String> Child_MasterArticleIdMap = new Map<String, String>();

    @AuraEnabled(cacheable=true)
    public static List<Knowledge__kav> fetchRelatedArticles(String relatedArticleInput){
        try {
            relatedArticlesRequest = (RelatedArticlesRequest)JSON.deserialize(relatedArticleInput, RelatedArticlesRequest.class);
            processKnowledgeDataCategoryList();
            fetchPromotedArticles();   
            if(String.isNotBlank(relatedArticlesRequest.articleId)){
                processDataCategoriesForArticle();
            } else {
                processDataCategoriesForNonArticle();
            }
            
            getRelatedArticles();
            return relatedArticles;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static void processKnowledgeDataCategoryList(){
        for(KnowledgeArticleVersion knowledgeVersion: [SELECT id, MasterVersionId, Language 
                                                       FROM KnowledgeArticleVersion
                                                       WHERE PublishStatus =:CSM_IboUtil.ARTICLE_Publish_Status_ONLINE
                                                       AND Language =:relatedArticlesRequest.userLanguage] ){
			Master_ChildArticleIdMap.put(knowledgeVersion.MasterVersionId,knowledgeVersion.Id);
            Child_MasterArticleIdMap.put(knowledgeVersion.Id,knowledgeVersion.MasterVersionId);
		}

		knowledgeMap = new Map<Id, knowledge__kav>([SELECT Id, FAQ_Answers_Question__c, Answer_Rich_Text__c, Language 
                                                    FROM knowledge__kav 
                                                    WHERE Language =:relatedArticlesRequest.userLanguage
                                                    AND PublishStatus =:CSM_IboUtil.ARTICLE_Publish_Status_ONLINE]);

        for(Knowledge__DataCategorySelection articleDataCategory : [SELECT Id, DataCategoryGroupName, DataCategoryName, Parentid
                                                                    FROM Knowledge__DataCategorySelection 
                                                                    WHERE Parent.PublishStatus = :CSM_IboUtil.ARTICLE_Publish_Status_ONLINE]){
            if(String.isNotBlank(relatedArticlesRequest.articleId) && articleDataCategory.DataCategoryGroupName != CSM_IboUtil.IB_ANSWERS){
                continue;
            }
            
            if(Master_ChildArticleIdMap.containsKey(articleDataCategory.ParentId)){
                if(!knowledgeDataCategoryMap.containsKey(articleDataCategory.ParentId)){
                    knowledgeDataCategoryMap.put(articleDataCategory.ParentId, new set<String>());
                }
                knowledgeDataCategoryMap.get(articleDataCategory.ParentId).add(articleDataCategory.DataCategoryName);
            }
        }
    }

    public static void processDataCategoriesForNonArticle(){
        if(relatedArticlesRequest.categories != null && !relatedArticlesRequest.categories.isEmpty()){
            dataCategoriesSet.addAll(relatedArticlesRequest.categories);
        }
        if(relatedArticlesRequest.programmes != null && !relatedArticlesRequest.programmes.isEmpty()){
            dataCategoriesSet.addAll(relatedArticlesRequest.programmes);
        }
        if(String.isNotBlank(relatedArticlesRequest.role)){
            dataCategoriesSet.add(relatedArticlesRequest.role);
        }
    }

    public static void processDataCategoriesForArticle(){
        getCategory3List();
        dataCategoriesSet = new Set<String>(knowledgeDataCategoryMap.get(Child_MasterArticleIdMap.get(relatedArticlesRequest.articleId)));
        dataCategoriesSet.retainAll(category3List);
        if(dataCategoriesSet.isEmpty()){
            getCategory2List();
            dataCategoriesSet = new Set<String>(knowledgeDataCategoryMap.get(Child_MasterArticleIdMap.get(relatedArticlesRequest.articleId)));
            dataCategoriesSet.retainAll(category2List);
        }
    }

    public static void getRelatedArticles(){
        List<Knowledge__kav> articles = new List<Knowledge__kav>();
        Integer promotedCount = 0;
        
        for(Id articleId: knowledgeDataCategoryMap.keySet()){
            if(String.isNotBlank(relatedArticlesRequest.articleId) && articleId.equals(Child_MasterArticleIdMap.get(relatedArticlesRequest.articleId))){
                continue;
            }
            Boolean isRelatedArticle = isArticleRelated(articleId);

            if(isRelatedArticle){
                if(promotedIds.contains(Master_ChildArticleIdMap.get(articleId)) && !articles.isEmpty()){
                    articles.add(0,knowledgeMap.get(Master_ChildArticleIdMap.get(articleId)));
                    promotedIds.remove(articleId);
                    if(++promotedCount == requiredRelatedArticlesCount){
                        break;
                    }
                }else{
                    articles.add(knowledgeMap.get(Master_ChildArticleIdMap.get(articleId)));
                }

                if(promotedIds.isEmpty() && articles.size() == requiredRelatedArticlesCount){
                    break;
                }
            }
        }

        for(Knowledge__kav article: articles){
            relatedArticles.add(article);
            if(relatedArticles.size() == requiredRelatedArticlesCount){
                break;
            }
        }
    }
    
    public static Boolean isArticleRelated(String articleId){
        Set<String> allDataGroupValuesForArticle = knowledgeDataCategoryMap.get(articleId);
        if(String.isNotBlank(relatedArticlesRequest.articleId)){
            for(String category3 : dataCategoriesSet) {
                if(allDataGroupValuesForArticle.contains(category3)){
                    return true;
                }
            }
        } else {
            return allDataGroupValuesForArticle.containsAll(dataCategoriesSet);
        }
        return false;
    }

    public static void getCategory3List(){
        category3List = new List<String>();
        for(Category3__c category:  [SELECT Id, Name FROM Category3__c]){
            category3List.add(category.Name);
        }
    }

    public static void getCategory2List(){
        category2List = new List<String>();
        for(Category2__c category: [SELECT Id, Name FROM Category2__c]){
            category2List.add(category.Name);
        }
    }

    public static void fetchPromotedArticles(){
        for(SEARCHPROMOTIONRULE promoted:[SELECT ID, QUERY, PROMOTEDENTITYID FROM SEARCHPROMOTIONRULE 
                                          WHERE PromotedEntity.Language = :relatedArticlesRequest.userLanguage 
                                          AND PromotedEntity.PublishStatus = :CSM_IboUtil.ARTICLE_Publish_Status_ONLINE 
                                          LIMIT 10000]) {
            if(promoted.PROMOTEDENTITYID != null){
                promotedIds.add(promoted.PROMOTEDENTITYID);
            }
        }
    }

    public class RelatedArticlesRequest{
        @AuraEnabled
        public List<String> categories{get;set;}
        @AuraEnabled
        public String role{get;set;}
        @AuraEnabled
        public List<String> programmes{get;set;}
        @AuraEnabled
        public String userLanguage{get;set;}
        @AuraEnabled
        public String articleId{get;set;}
    }
}