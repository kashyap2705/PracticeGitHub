global class createUniqueOCCcodeOnDemand {
/*  Author/owner name: Ammara Alvi
    Reason of change : Commented as part of US-11171 because Related Object OCC_Code_Generator__c is going to be Deleted
    Date:  24-09-19

    webservice static void generateOCCcode(String Id, String RecType) {
    
        Map<String, Account> currIBIScodes = new Map<String, Account>();
        Map<String, IB_Programme__c> currOCCcodes = new Map<String, IB_Programme__c>();
        
        String tmpRecordTypeLookup = '';
        Decimal currSequenceVal = 0;
        String newSequenceVal = '';
        
        String dupeIBIScode;
        String dupeOCCcode;
        
        if (RecType == 'Diploma Programme' || RecType == 'CP') tmpRecordTypeLookup = 'DP/CP';
        if (RecType == 'PYP') tmpRecordTypeLookup = 'PYP';
        if (RecType == 'MYP') tmpRecordTypeLookup = 'MYP';
        if (RecType == 'European Platform') tmpRecordTypeLookup = 'EP';

        // Grab the current OCC_Code_Generator__c record with the related Record Type
        OCC_Code_Generator__c currOCCCodeGenRec = [SELECT ID,Current_Sequence_Value__c FROM OCC_Code_Generator__c WHERE Programme_Record_Type__c = :tmpRecordTypeLookup];
        if (currOCCCodeGenRec != null) {
            currSequenceVal = currOCCCodeGenRec.Current_Sequence_Value__c;
            newSequenceVal = string.valueOf(currSequenceVal + 1);
        }
        
        // Grab all IBIS Codes currently in use by the IB Accounts
        for (Account acc : [SELECT IBIS_ID__c FROM Account WHERE IBIS_ID__c != null]) {
            currIBIScodes.put(acc.IBIS_ID__c, acc);
        }

        // Grab all OCC Codes currently in use by the IB Programmes
        for (IB_Programme__c prog : [SELECT OCC_Code__c FROM IB_Programme__c WHERE OCC_Code__c != null]) {
            currOCCcodes.put(prog.OCC_Code__c, prog);
        }
        system.debug('Current IBIS Codes in use =====> '+currIBIScodes);
        system.debug('Current OCC Codes in use =====> '+currOCCcodes);
        
        //system.debug('programme ID ====> '+Id);
        //system.debug('RecType ====> '+RecType);
        //system.debug('current sequence value for '+tmpRecordTypeLookup+' =====> '+currOCCCodeGenRec.Current_Sequence_Value__c);
        
        // Set up object for current Programme record
        IB_Programme__c currProgRec = new IB_Programme__c();
        currProgRec.Id = Id;
        boolean validCodeFound = false;
        
        // loop through the next 25 values in the sequence to get a valid OCC Code
        for (integer i=0; i<25; i++) {
            
            // Set dupe value variables to a default value before checking for existing IBIS and OCC Codes
            dupeIBIScode = 'Empty';
            dupeOCCcode = 'Empty';
            
            Account tmpAccount = currIBIScodes.get(newSequenceVal);
            if (tmpAccount != null) dupeIBIScode = tmpAccount.IBIS_ID__c;
            IB_Programme__c tmpProg = currOCCcodes.get(newSequenceVal);
            if (tmpProg != null) dupeOCCcode = tmpProg.OCC_Code__c;
            system.debug('dupeIBIScode =====> '+dupeIBIScode);
            system.debug('dupeOCCcode =====> '+dupeOCCcode);
            
            if (dupeIBIScode == 'Empty' && dupeOCCcode == 'Empty') {
                currProgRec.OCC_Code__c = newSequenceVal;
                currProgRec.OCC_Code_Duplicate_Found__c = false;
                currProgRec.OCC_Code_is_Valid__c = true;
                validCodeFound = true;
                currOCCCodeGenRec.Current_Sequence_Value__c = Decimal.valueOf(newSequenceVal);
                break;
            } else {
                currSequenceVal += 1;
                newSequenceVal = string.valueOf(currSequenceVal);
            }
        }
        
        // Update the current programme record and set the new Current_Sequence_Value__c in the OCC_Code_Generator__c object
        if (validCodeFound) {
            update currProgRec;
            update currOCCCodeGenRec;
        }
    }*/

}