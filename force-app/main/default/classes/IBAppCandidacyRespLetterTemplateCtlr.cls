public class IBAppCandidacyRespLetterTemplateCtlr {
//This controller is used for generating letter 1    
    public string templateBody{get;set;}
    public IBAppCandidacyRespLetterTemplateCtlr(){
        
        String progId = ApexPages.currentPage().getParameters().get('programmeId');
        
        if(progId != null){
            List<IB_Programme__c> textTemplate = [SELECT Letter_Template__c FROM IB_Programme__c WHERE Id = :progId LIMIT 1];
            
            if(textTemplate.size() == 1){
                templateBody = textTemplate[0].Letter_Template__c;
            }else{
                templateBody = 'Letter template not found';
            }    	
	    } 
    }


}