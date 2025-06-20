global class ScheduleSyncUserLanguageToContactBatch implements Schedulable{
    
    
     /**
   * This method Will call syncUserLanguageToContactBatch.
   * @param SchedulableContext.
   * @return Void.
   */
    global void execute(SchedulableContext sc)
    {
        syncUserLanguageToContactBatch languageBatch = new syncUserLanguageToContactBatch();
        
        database.executebatch(languageBatch);
    }
}