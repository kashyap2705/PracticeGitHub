global class CSMUpdateDraftArticlesBatch implements Database.Batchable<sObject>,Database.Stateful {
    Set<Id> onlineArticleIdsWithError = new Set<Id>();    
    Set<Id> onlineArticleIds = new Set<Id>();
    Set<Id> draftArticleIds = new Set<Id>();
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, KnowledgeArticleId, MasterVersionId
            FROM Knowledge__kav 
            WHERE PublishStatus = 'Online' AND Language = 'en_US'
        ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Knowledge__kav> scope) {
        Map<Id, Id> onlineVersionIdsMap = new Map<Id, Id>();               
        for (Knowledge__kav onlineArticle : scope) {
            onlineArticleIds.add(onlineArticle.KnowledgeArticleId);
            onlineVersionIdsMap.put(onlineArticle.KnowledgeArticleId, onlineArticle.MasterVersionId);
        }        
        
        for (Knowledge__kav draftArticle : [SELECT Id, KnowledgeArticleId FROM Knowledge__kav WHERE KnowledgeArticleId IN :onlineVersionIdsMap.keySet() AND PublishStatus = 'Draft']) {
            onlineVersionIdsMap.remove(draftArticle.KnowledgeArticleId);
            draftArticleIds.add(draftArticle.KnowledgeArticleId);
        }
        
        
        for (Id onlineArticleId : onlineVersionIdsMap.KeySet()) {
            try {
                KbManagement.PublishingService.editOnlineArticle(onlineArticleId, false);
                KbManagement.PublishingService.editPublishedTranslation(onlineArticleId,'fr',false);
                KbManagement.PublishingService.editPublishedTranslation(onlineArticleId,'es',false);
            } catch (Exception e) {             
                onlineArticleIdsWithError.Add(onlineArticleId);                   
            }
        }        
        
        List<Knowledge__kav> draftArticlesToUpdate = [SELECT Id, KnowledgeArticleId, FAQ_Answers_Staff_Notes__c FROM Knowledge__kav WHERE KnowledgeArticleId IN :onlineVersionIdsMap.keySet() AND PublishStatus = 'Draft'];
        for (Knowledge__kav draftArticle : draftArticlesToUpdate) {
            Id onlineVersionId = onlineVersionIdsMap.get(draftArticle.KnowledgeArticleId);
            draftArticle.FAQ_Answers_Staff_Notes__c = onlineVersionId;
        }
        
        // Update draft articles
        try {
            update draftArticlesToUpdate;
            for (Knowledge__kav draftArticle : draftArticlesToUpdate) {
                System.debug('Draft article updated successfully: ' + draftArticle.Id);
            }
        } catch (Exception e) {          
            Logger.get().add(e, LogSeverity.ERROR).publish();
        }
    }
    global void finish(Database.BatchableContext BC) {
        if(!draftArticleIds.isEmpty()){
            String draftids = String.join(new set<Id>(draftArticleIds),';');
            Logger.get().add( draftArticleIds.size()+' Draft Found: '+draftids, LogSeverity.ERROR).publish();
            
        }
        if(!onlineArticleIdsWithError.isEmpty()){
            String noTranslationsids = String.join(new set<Id>(onlineArticleIdsWithError),';');
            Logger.get().add( onlineArticleIdsWithError.size()+' No Translations Found: '+noTranslationsids, LogSeverity.ERROR).publish();
        }
    }
}