public class PGQA_SampleBeforeInsertTriggerHandler extends TriggerHandlerBase{
    public override void mainEntry(TriggerParameters tp){
        
        process( (Map<id,PGQA_Sample__c>)tp.newMap,(List<PGQA_Sample__c>)tp.newList);
        
    }
    
    @testVisible  private static void process(Map<id,PGQA_Sample__c> newSamples,List<PGQA_Sample__c> newSampleList){
        Set<ID> case_ids = new Set<ID>();
        Map<ID,PGQA_Sample__c> Pgqa_Sample_Map = new Map<ID,PGQA_Sample__c>();
        for(PGQA_Sample__c Pgqa_Sample : newSampleList){
            case_ids.add(Pgqa_Sample.PGQA_Case__c);
            Pgqa_Sample_Map.put(Pgqa_Sample.PGQA_Case__c,Pgqa_Sample);
        }
        System.debug('case_ids: '+case_ids.size());
        List<Case> Pgqa_Sample_Case = new List<Case>([Select id,(Select id,PGQA_Case__c,PGQA_Case__r.id,PGQA_Name__c from PGQA_Samples__r) from Case where id IN:case_ids]);
        System.debug('Size: '+Pgqa_Sample_Case.size());
        for(Case Pgqa_Sample : Pgqa_Sample_Case){
            for(PGQA_Sample__c existing_pgqa_sample : Pgqa_Sample.PGQA_Samples__r){
                System.debug('existing_pgqa_sample: '+existing_pgqa_sample);
                PGQA_Sample__c newsample = Pgqa_Sample_Map.get(existing_pgqa_sample.PGQA_Case__c);
                System.debug('newsample '+newsample.PGQA_Case__c+' '+newsample.PGQA_Name__c );
                 if(newsample != null && newsample.PGQA_Case__c == existing_pgqa_sample.PGQA_Case__c && newsample.PGQA_Name__c == existing_pgqa_sample.PGQA_Name__c )
                     newsample.addError(newsample.PGQA_Name__c+' Already Created');
            }
        }
    }
}