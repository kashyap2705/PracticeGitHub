/**
 * @description       : Controller class to get the promoted article and top 2 categories
 * @author            : Vikash Kumar
 * @last modified on  : 03-05-2024
 * @last modified by  : Mounika
**/
public without sharing class CSM_PromotedArticleController {
    /**
    * @description : Get the promoted articles to display on top
    * @return      : List<String> 
    **/
   @AuraEnabled(cacheable=true)
   public static List<String> getPromotedArticles() {
       Set<String> promotedKnowledgeIdSet = new Set<String>();
       List<String> returnKnowledgeIdList;
       for(SEARCHPROMOTIONRULE promotion:[SELECT ID, QUERY, PROMOTEDENTITYID FROM SEARCHPROMOTIONRULE limit 10000]){
           promotedKnowledgeIdSet.add(promotion.PROMOTEDENTITYID);
       }
       returnKnowledgeIdList = new List<String>(promotedKnowledgeIdSet);
       return returnKnowledgeIdList;
   }
   /**
    * @description : Get the top two category tiles
    * @return      : List<String> 
    **/
   @AuraEnabled(cacheable=true)
   public static List<String> getTopCategory1() {
       List<String> topCategoriesList = new List<String>();
       Set<String> topCategory1Set = new Set<String>();
       for (Category1__c cat1 : [SELECT ID, Name, Top_Category__c FROM Category1__C WHERE Top_Category__c = TRUE  ORDER BY Name ASC LIMIT 2]) {
           topCategory1Set.add(cat1.Name);
       }
       topCategoriesList.addAll(topCategory1Set);        
       return topCategoriesList;
   }
}