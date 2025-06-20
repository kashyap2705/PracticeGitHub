/**
* @description       : 
* @author            : Mounika
* @group             : 
* @last modified on  : 04-25-2024
* @last modified by  : Mounika
**/
public class IBAnswersArticleVoteController {
    @AuraEnabled(cacheable=true)
    public static Boolean checkVote(String articleId){       
        Id userId = UserInfo.getUserId();
        List<Knowledge_Article_Feedback__c> existingVotes =  [SELECT Id, Feedback_For_Article__r.KnowledgeArticleId, CreatedById,Feedback_For_Article__r.PublishStatus   from Knowledge_Article_Feedback__c where Feedback_For_Article__r.KnowledgeArticleId = :articleId and CreatedById =: userId and Feedback_For_Article__r.PublishStatus='Online' and RecordType.Name ='IB Answers' Limit 1];
        return existingVotes.isEmpty();
    }
    @AuraEnabled(cacheable=false)
    public static void insertVote(String articleId,String type) {        
        // Query for an existing vote record based on the articleId
        Id userId = UserInfo.getUserId();
        Vote existingVote;
        List<Vote> existingVotes = [SELECT Id,Type,parentid,CreatedById FROM Vote WHERE parentid = :articleId and CreatedById = :userId LIMIT 1];
        
        if (existingVotes.isEmpty()) {           
            // A vote doesn't exist, create a new vote record
            existingVote = new Vote();
            existingVote.parentid = articleId;
            existingVote.Type = type;            
        }  else if(!existingVotes.isEmpty() ) {
            if(existingVotes[0].Type!=type){
                existingVote = existingVotes[0]; 
                existingVote.type = type ; 
            }
        }         
        try{
            if(existingVote!=null){
                upsert existingVote; 
            }
        }
        catch (Exception e) {            
            Logger.get().add(e, LogSeverity.ERROR).publish();          
            throw new AuraHandledException('An error occurred while processing the vote.'+ + e.getMessage());
        }
    }
}