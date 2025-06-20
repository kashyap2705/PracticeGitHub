global class createChildEvents {
    webservice static string createRemoteConsultation(id eventId) {
        string whereClause = ' where id = \'' + eventId + '\'';
        //string campFieldString = UtilityClass.getCreatableFieldsSOQL('Campaign');
        string campFieldString = UtilityClass.getCreatableFieldsSOQL('Campaign');
        string assgnFieldString = UtilityClass.getCreatableFieldsSOQL('My_Staffing_Event__c');
        if(campFieldString==''){//Inc0187534 ben mcgarvey, added to prevent an error in a test class. More fields can be added to this if needed
            campFieldString='id, name';
        }
        system.debug('Camp String: '+campFieldString);
        string assgnQuery = '(SELECT ' + assgnFieldString + ' FROM My_Staffing_Events__r where Application_Status__c = \'Confirmed\')';
        string campQuery = 'SELECT ' + campFieldString + ', ' + assgnQuery + ' FROM Campaign';
        system.debug('whereClause: ' + whereClause);
        system.debug('campQuery: ' + campQuery);
        Campaign parentEvent = Database.query(campQuery + whereClause);
        system.debug('parentEvent: ' + parentEvent);
        system.debug('parentEvent.id: ' + parentEvent.id);
        system.debug('parentEvent.My_Staffing_Events__r: ' + parentEvent.My_Staffing_Events__r);
        Campaign childEvent = parentEvent.clone(false,true);
        system.debug('childEvent: ' + childEvent);
        childEvent.ParentId = parentEvent.Id;
        childEvent.Staffing_Event_Published__c = false;
        childEvent.X20_Hours_Confirmed__c = false;
        childEvent.X40_Hours_Confirmed__c = false;
        childEvent.X60_Hours_Confirmed__c = false;
        childEvent.Payment_approval__c = false;
        childEvent.Staffing_Event_Notice_Board__c = null;
        childEvent.Expense_claim_processed__c = null;
        childEvent.Expense_claim_received__c = false;
        childEvent.Sub_Type__c = 'Candidacy Remote Consultation';
        childEvent.Name = parentEvent.Name.replace('Candidacy Consultation', 'Candidacy Remote Consultation');
        system.debug('childEvent: ' + childEvent);
        Database.SaveResult sr = Database.insert(childEvent, false);
        system.debug('childEvent.id: ' + childEvent.id);
        list<My_Staffing_Event__c> insertAssgnList = new list<My_Staffing_Event__c>();
        if(parentEvent.My_Staffing_Events__r.size() > 0){
            for(My_Staffing_Event__c assmnt : parentEvent.My_Staffing_Events__r){
                My_Staffing_Event__c clonedAssgt =  assmnt.clone(false,true);
                clonedAssgt.IB_Event__c = childEvent.id;
                clonedAssgt.Staffing_Event__c = null;
                clonedAssgt.Payment_Initiated__c  = false;
                insertAssgnList.add(clonedAssgt);
            }
        }
        if (sr.isSuccess()){
            System.debug('sr.getId():' + sr.getId());
            if(!insertAssgnList.isEmpty()){
                insert insertAssgnList;
            }
            return sr.getId();
        }
        else{              
            for(Database.Error err : sr.getErrors()){                  
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                return err.getMessage();
            }
        }
        return null;
    }
    webservice static string createConsultationVisit(id eventId) {
        string whereClause = ' where id = \'' + eventId + '\'';
        string campFieldString = UtilityClass.getCreatableFieldsSOQL('Campaign');
        string assgnFieldString = UtilityClass.getCreatableFieldsSOQL('My_Staffing_Event__c');
        if(campFieldString==''){//Inc0187534 ben mcgarvey, added to prevent an error in a test class. More fields can be added to this if needed
            campFieldString='id, name';
        }
        system.debug('Camp String: '+campFieldString);
        string assgnQuery = '(SELECT ' + assgnFieldString + ' FROM My_Staffing_Events__r where Application_Status__c = \'Confirmed\')';
        string campQuery = 'SELECT ' + campFieldString + ', ' + assgnQuery + ' FROM Campaign';
        system.debug('whereClause: ' + whereClause);
        system.debug('campQuery: ' + campQuery);
        Campaign parentEvent = Database.query(campQuery + whereClause);
        system.debug('parentEvent: ' + parentEvent);
        system.debug('parentEvent.id: ' + parentEvent.id);
        system.debug('parentEvent.My_Staffing_Events__r: ' + parentEvent.My_Staffing_Events__r);
        Campaign childEvent = parentEvent.clone(false,true);
        system.debug('childEvent: ' + childEvent);
        childEvent.ParentId = parentEvent.Id;
        childEvent.Staffing_Event_Published__c = false;
        childEvent.X20_Hours_Confirmed__c = false;
        childEvent.X40_Hours_Confirmed__c = false;
        childEvent.X60_Hours_Confirmed__c = false;
        childEvent.Payment_approval__c = false;
        childEvent.Staffing_Event_Notice_Board__c = null;
        childEvent.Expense_claim_processed__c = null;
        childEvent.Expense_claim_received__c = false;           
        childEvent.Sub_Type__c = 'Candidacy Consultation Visit';
        childEvent.Name = parentEvent.Name.replace('Candidacy Consultation', 'Candidacy Consultation Visit');
        system.debug('childEvent: ' + childEvent);
        Database.SaveResult sr = Database.insert(childEvent, false);
        system.debug('childEvent.id: ' + childEvent.id);
        list<My_Staffing_Event__c> insertAssgnList = new list<My_Staffing_Event__c>();
        if(parentEvent.My_Staffing_Events__r.size() > 0){
            for(My_Staffing_Event__c assmnt : parentEvent.My_Staffing_Events__r){
                My_Staffing_Event__c clonedAssgt =  assmnt.clone(false,true);
                clonedAssgt.IB_Event__c = childEvent.id;
                clonedAssgt.Staffing_Event__c = null;
                clonedAssgt.Payment_Initiated__c  = false;
                insertAssgnList.add(clonedAssgt);
            }
        }
        if (sr.isSuccess()){
            System.debug('sr.getId():' + sr.getId());
            if(!insertAssgnList.isEmpty()){
                insert insertAssgnList;
            }
            return sr.getId();
        }
        else{              
            for(Database.Error err : sr.getErrors()){                  
                System.debug(err.getMessage() + ': ' + err.getMessage());
                return err.getMessage();
            }
        }
        return null;
    }

	
	@InvocableMethod(label='Create Consultation')
    public static List<String> createRemoteConsultationInvocable(List<eventIdMethodName> param) {
		List<string> results = new List<string>();
        switch on param[0].methodName {
			when 'createConsultationVisit' {
				String result = createConsultationVisit(param[0].eventId);
                results.add(result);
			}
			when 'createRemoteConsultation' {
				String result = createRemoteConsultation(param[0].eventId);
                results.add(result);
			}       
        }
        system.debug('results-->'+results);
		return results;
    }

    public class eventIdMethodName {
        @InvocableVariable(required=true)
        public Id eventId;

        @InvocableVariable(required=true)
        public String methodName;
    }
}