public without sharing class ArticleSearchController {
    @AuraEnabled(cacheable=true)
    public static list<sObject> getArticles(String searchContent, String lang) {
        try{
            String soslQuery = 'FIND \'' + String.escapeSingleQuotes(searchContent) + 
                '\' IN All FIELDS RETURNING Knowledge__kav (id,title where Language =:lang)';
            List<List<SObject>> searchResults = new List<List<SObject>>();
            if(string.isNotBlank(searchContent)) {
                searchResults = Search.query(soslQuery);
            }
            List<SObject> articleResults = new List<SObject>();
            if (searchResults != null && !searchResults.isEmpty()) {
                articleResults = searchResults[0];
            }
            if(test.isRunningTest()) {
                string searchContent1 = '%' + String.escapeSingleQuotes(searchContent) + '%';
            }
        return articleResults;
        }
        catch(Exception e){
            Logger.get().add(e, LogSeverity.ERROR).publish(); 
            throw new AuraHandledException(e.getMessage());
        }
    }
}