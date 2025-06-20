public without sharing class MyTrainingEventsDAO {
    
    public static MyTrainingEventsDAO INSTANCE = null;
    public static MyTrainingEventsDAO getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new MyTrainingEventsDAO();
        }
        return INSTANCE;
    }
    public static final Set<String> ACCEPTED_STATUS = new Set<String> { 'Not Selected',
                                                                        'Not Approved',
                                                                        'Invitation Declined', 
                                                                        'Declined for (all) Role Application(s)',
                                                                        'Withdrawn',
                                                                        'Withdrawn by IB'
                                                                       };
    
    private MyTrainingEventsDAO() {
    
    }
    public Id getCampaignIdFromTrainingId(Id trainingEventId) {
        try
        {
            system.debug('Training event id ===' + trainingEventId);
            final Training_Event__c trainingEvent = [
                SELECT id, IB_Event__c 
                FROM Training_Event__c 
                WHERE Id = :trainingEventId
            ];
            return trainingEvent.IB_Event__c;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
        
    }
}