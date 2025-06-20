public without sharing class IBEBackgroundDAO {
    
    public static final IBEBackgroundDAO INSTANCE = new IBEBackgroundDAO();
    
    private IBEBackgroundDAO() {
        
    }
    
    public List<IB_E_Background__c> getIBEBackgroundsForContactAndRecordType (String recordTypeId, String contactId) {
        
        if ( String.isBlank(contactId)) {
            throw new DAOException('The Contact ID cannot be zero or an empty string.');
        } 
         
        if ( String.isBlank(recordTypeId)) {
            throw new DAOException('The RecordType ID cannot be zero or an empty string.');
        }
         
        return [Select id, Related_Subject_Area__c, Title_of_Research__c, Publication_Date__c, Name_of_Paper_If_Published__c, IB_Workshop_Title__c, Start_Date__c, End_Date__c, Region__c, toLabel(Country__c), City__c,
                       i.Written_Proficiency__c, i.Spoken_Proficiency__c, toLabel(i.Language__c), Educational_Degree__c, Field_of_Study__c, School__c, 
                       General_Subject__c, Language_of_Delivery__c, Delivery_Mode__c,
                       Programme__c,Category__c, Accreditation_Body_Name__c, IB_School__c,  toLabel(IB_Role__c), IB_Programme__c, Subject_Text__c, Role__c, Language_Delivery__c, Preferred_Language__c, Accreditation__c, Accreditation_Team_Member__c
                       From IB_E_Background__c i where i.IB_Contact__c =: contactId AND  i.RecordTypeId =:recordTypeId];
       
    }

    /*public Boolean hasRequiredIBEBackgroundsForRole (String contactId){
      AggregateResult[] groupedResults = [SELECT count(Id), IB_Contact__c, RecordType.Name FROM IB_E_Background__c
                                          WHERE RecordType.Name in ('Educational Degrees','Language Experience')
                                          and IB_Contact__c = :contactId
                                          group by ib_contact__c, recordtype.Name];

      if(groupedResults.size() < 2) return false;
      else return true;                                
    }*/

    public List<IB_E_Background__c> getRequiredIBEBackgroundsForRole (String contactId){
      return [SELECT Id, RecordType.Name, RecordTypeId FROM IB_E_Background__c
              WHERE RecordType.Name in ('Educational Degrees','Language Experience')
              and IB_Contact__c = :contactId];
    }


    
    public IB_E_Background__c getIBEBackgroundById (String backgroundId){
        if ( String.isBlank(backgroundId)) {
            throw new DAOException('The ID cannot be zero or an empty string.');
        }

        try{
          return [SELECT Id, IB_Contact__c FROM IB_E_Background__c WHERE Id = :backgroundId LIMIT 1];
        } catch (Exception e){
          return new IB_E_Background__c();
        }

    }        
    
    public List<IB_E_Background__c> getIBBackgroundsForContactAndRecordType (String recordTypeId, String contactId, Integer maxperPage, Integer offset ) {
        
        if ( String.isBlank(contactId)) {
            throw new DAOException('The Contact ID cannot be zero or an empty string.');
        } 
         
        if ( String.isBlank(recordTypeId)) {
            throw new DAOException('The RecordType ID cannot be zero or an empty string.');
        }
       
        
        return [Select id, Related_Subject_Area__c, Title_of_Research__c, Publication_Date__c, Name_of_Paper_If_Published__c, IB_Workshop_Title__c, Start_Date__c, End_Date__c, Region__c, toLabel(Country__c), City__c, 
                       i.Written_Proficiency__c, i.Spoken_Proficiency__c, i.Language__c, Educational_Degree__c, Field_of_Study__c, School__c, 
                       General_Subject__c, Language_of_Delivery__c, Delivery_Mode__c,
                       Programme__c, Category__c, Accreditation_Body_Name__c, IB_School__c,  toLabel(IB_Role__c), IB_Programme__c, Subject_Text__c, Role__c, Language_Delivery__c, Preferred_Language__c, Accreditation__c, Accreditation_Team_Member__c
                       From IB_E_Background__c i where i.IB_Contact__c =: contactId AND  i.RecordTypeId =:recordTypeId LIMIT :maxperPage OFFSET  :offset];
       
    }
    
    public Integer getCountofIBBackgroundsForContactAndRecordType (String recordTypeId, String contactId ) {
        
        if ( String.isBlank(contactId)) {
            throw new DAOException('The Contact ID cannot be zero or an empty string.');
        } 
        
        if ( String.isBlank(recordTypeId)) {
            throw new DAOException('The RecordType ID cannot be zero or an empty string.');
        }
         
       return [Select count() From IB_E_Background__c i where i.IB_Contact__c =: contactId AND  i.RecordTypeId =:recordTypeId];
       
    }
    
}