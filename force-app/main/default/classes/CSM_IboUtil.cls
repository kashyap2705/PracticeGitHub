public class CSM_IboUtil {
    public static final String IB_ANSWERS = 'IB_Answers';
    public static final String ARTICLE_Publish_Status_ONLINE ='Online';
    public static final Map<String, String> programmeMap = new map<String, String> {'MYP' => 'Middle_years_programme','PYP' => 'Primary_years_programme','DP' => 'Diploma_programme','CP' => 'Career_related_programme'};
    public static final String PARENT_Role ='Parents_candidates_and_alumni';
    public static final String WORKSHOP_Role ='Workshop_Independent_participant';
    public static final String OTHER_Role ='Other_Roles';
    public static final String CONFIRMED_STATUS ='Confirmed';
    public static final String DP ='DP';
    public static final String CP ='CP';
    public static final String MYP ='MYP';
    public static final String PYP ='PYP';
    public static final String ProjectName='IB_Answers_EC';
    public static final String ListViewDeveloperNamePattern = 'EC_IB_Answers%';
    public static final String ListViewGroup ='caseListViewLabels';
    public static final String Guest='Guest';
    public static final Map<String, String> programMap = new map<String, String> {'Middle_years_programme' => 'MYP','Primary_years_programme' => 'PYP','Diploma_programme' => 'DP','Career_related_programme' => 'CP'};
    public static final String EXCLUDED_OWNERS_NAME = 'Excluded Owner List';
    public static final String CASE_SUPPORT_RECORD_TYPE = 'Support';
    
    @AuraEnabled
    public static void logError(String error){
        Logger.get().add(error, LogSeverity.ERROR).publish();
    }
    
    @AuraEnabled(cacheable=true)
    public static string communityBasePath() {
        try {
            IB_Answers__mdt basePathRecord = IB_Answers__mdt.getInstance(
                'IB_Community_Path'
            );
            return basePathRecord.Value__c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Network getNetworkDetails(String key){
        try {
            Network networkRecord = [SELECT id, Name from Network WHERE Name = :key LIMIT 1];
            return networkRecord;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}