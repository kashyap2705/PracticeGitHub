/**		
	* <h1>TranslationBeforeInsertTriggerHandler</h1>		
	* This class is responsible managing before insert event of translation object.
	* 
	* @author  Dilip Kumar	
	* @version 1.0		
	* @since   08-02-2022
	
Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 

*/
public class TranslationBeforeInsertTriggerHandler extends TriggerHandlerBase{
    public override void mainEntry(TriggerParameters tp){
        if(TriggerContextUtility.isFirstRun()){
            process(tp.newList);
        }
    }

    @testVisible
    private static void process(List<Translation__c> translationList){
        Set<Id> customLabelIds = new Set<Id>();
        Map<String, Translation__c> mapCustomLabelWithLanguageToTranslation = new Map<String, Translation__c>();
        for(Translation__c trans : translationList){
            customLabelIds.add(trans.CustomLabel__c);
        }

        List<CustomLabel__c> customLabelList = [SELECT Id, Label__c, Group__c, 
                                                (SELECT Id, CustomLabel__c, Language__c,Value__c FROM Translations__r)
                                                    FROM CustomLabel__c 
                                                    WHERE Id IN :customLabelIds];
        
        for(CustomLabel__c cl : customLabelList){
            for(Translation__c translation : cl.Translations__r){
                mapCustomLabelWithLanguageToTranslation.put(cl.Id+'-'+translation.Language__c, translation);
            }
        }

        for(Translation__c tran : translationList){
            String Key = tran.CustomLabel__c+'-'+tran.Language__c;
            if(mapCustomLabelWithLanguageToTranslation.containsKey(Key)){
                tran.addError('There is already a Translation with Selected Language For Custom label');
            }
        }
    }
}