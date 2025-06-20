public class createUniqueOCCcodeHandler {
/*  Author/owner name: Ammara Alvi
    Reason of change : Commented as part of US-11171 because Related Object OCC_Code_Generator__c is going to be Deleted
    Date:  24-09-19
    public List<IB_Programme__c> stageChangeIBprogrammes = new List<IB_Programme__c>();
    public List<IB_Programme__c> updtIBprogrammes = new List<IB_Programme__c>();
    public List<OCC_Code_Generator__c> occCodeSequenceUpdates = new List<OCC_Code_Generator__c>();

    public Decimal currDPCPval;
    public Decimal currPYPval;
    public Decimal currMYPval;
    public Decimal currEPval;
    public Map<String, OCC_Code_Generator__c> currOCCCodeSequences = new Map<String, OCC_Code_Generator__c>();
    public Map<Id, RecordType> progRecTypes = new Map<Id, RecordType>();
    public Map<String, Account> currIBIScodes = new Map<String, Account>();
    public Map<String, IB_Programme__c> currOCCcodes = new Map<String, IB_Programme__c>();

    public static Boolean createUniqueOCCcode_firstRun = false;

    
    public createUniqueOCCcodeHandler() {
        try
        {
        for (OCC_Code_Generator__c ocg : [SELECT Id,Programme_Record_Type__c,Current_Sequence_Value__c FROM OCC_Code_Generator__c]) {
            iF (ocg.Programme_Record_Type__c == 'DP/CP') currDPCPval = ocg.Current_Sequence_Value__c;
            iF (ocg.Programme_Record_Type__c == 'PYP') currPYPval = ocg.Current_Sequence_Value__c;
            iF (ocg.Programme_Record_Type__c == 'MYP') currMYPval = ocg.Current_Sequence_Value__c;
            iF (ocg.Programme_Record_Type__c == 'EP') currEPval = ocg.Current_Sequence_Value__c;
            currOCCCodeSequences.put(ocg.Programme_Record_Type__c, ocg);
        }
        //system.debug('currDPCPval =====> '+currDPCPval);
        //system.debug('currPYPval =====> '+currPYPval);
        //system.debug('currMYPval =====> '+currMYPval);
        //system.debug('currEPval =====> '+currEPval);

        for (RecordType rc : [SELECT Id,Name FROM RecordType WHERE SobjectType = 'IB_Programme__c']) {
            progRecTypes.put(rc.Id, rc);
        }

        for (Account acc : [SELECT IBIS_ID__c FROM Account WHERE IBIS_ID__c != null]) {
            currIBIScodes.put(acc.IBIS_ID__c, acc);
        }

        for (IB_Programme__c prog : [SELECT OCC_Code__c FROM IB_Programme__c WHERE OCC_Code__c != null]) {
            currOCCcodes.put(prog.OCC_Code__c, prog);
        }
        system.debug('Current IBIS Codes in use =====> '+currIBIScodes);
        system.debug('Current OCC Codes in use =====> '+currOCCcodes);
            }
        catch(exception x)
        {
            system.debug('exception occurred');
        }
    }

    // Method used to handle creation of new OCC Codes for Programmes that are missing a value
    public void processNewOCCcodes (List<IB_Programme__c> needOCCcodes) {
                try
                {
        String dupeIBIScode;
        String dupeOCCcode;
        
        for (IB_Programme__c newOCC : needOCCcodes) {
            
            // Set dupe value variables to a default before processing the list of records
            dupeIBIScode = 'Empty';
            dupeOCCcode = 'Empty';
            
            String tmpRecordType = progRecTypes.get(newOCC.RecordTypeId).Name;
            system.debug('tmpRecordType ====> '+tmpRecordType);
            String tmpRecordTypeLookup = '';
            if (tmpRecordType == 'Diploma Programme' || tmpRecordType == 'CP') tmpRecordTypeLookup = 'DP/CP';
            if (tmpRecordType == 'PYP') tmpRecordTypeLookup = 'PYP';
            if (tmpRecordType == 'MYP') tmpRecordTypeLookup = 'MYP';
            if (tmpRecordType == 'European Platform') tmpRecordTypeLookup = 'EP';

            // Grab the current OCC_Code_Generator__c record to update if needed
            OCC_Code_Generator__c currOCCCodeGenRec = currOCCCodeSequences.get(tmpRecordTypeLookup);
            
            Decimal currOCCsequenceVal = 0;
            String nextOCCsequenceVal = '';
            // Increment the sequence values to update the OCC_Code_Generator__c row with the new "Current_Sequence_Value__c"
            if (tmpRecordTypeLookup == 'DP/CP') {
                currDPCPval += 1;
                system.debug('after DP/CP ++ =====>'+currDPCPval);
                currOCCsequenceVal = currDPCPval;
            }
            else if (tmpRecordTypeLookup == 'PYP') {
                currPYPval += 1;
                system.debug('after PYP ++ =====>'+currPYPval);
                currOCCsequenceVal = currPYPval;
            }
            else if (tmpRecordTypeLookup == 'MYP') {
                currMYPval += 1;
                system.debug('after MYP ++ =====>'+currMYPval);
                currOCCsequenceVal = currMYPval;
            }
            else if (tmpRecordTypeLookup == 'EP') {
                currEPval += 1;
                system.debug('after EP ++ =====>'+currEPval);
                currOCCsequenceVal = currEPval;
            }
            
            nextOCCsequenceVal = string.valueOf(currOCCsequenceVal);
            system.debug('currOCCsequenceVal =====> '+currOCCsequenceVal);
            system.debug('nextOCCsequenceVal =====> '+nextOCCsequenceVal);

            Account tmpAccount = currIBIScodes.get(nextOCCsequenceVal);
            if (tmpAccount != null) dupeIBIScode = tmpAccount.IBIS_ID__c;
            IB_Programme__c tmpProg = currOCCcodes.get(nextOCCsequenceVal);
            if (tmpProg != null) dupeOCCcode = tmpProg.OCC_Code__c;
            system.debug('dupeIBIScode =====> '+dupeIBIScode);
            system.debug('dupeOCCcode =====> '+dupeOCCcode);
            
            if (dupeIBIScode == 'Empty' && dupeOCCcode == 'Empty') {
                newOCC.OCC_Code__c = nextOCCsequenceVal;
                newOCC.OCC_Code_Duplicate_Found__c = false;
                newOCC.OCC_Code_is_Valid__c = true;
                stageChangeIBprogrammes.add(newOCC);

                currOCCCodeGenRec.Current_Sequence_Value__c = currOCCsequenceVal;
                occCodeSequenceUpdates.add(currOCCCodeGenRec);
            } else {
                newOCC.OCC_Code__c = '';
                newOCC.OCC_Code_Duplicate_Found__c = true;
                newOCC.OCC_Code_is_Valid__c = false;
                stageChangeIBprogrammes.add(newOCC);
            }
        }
        
        // update the OCC_Code_Generator__c object with the latest values for all impacted programme sequences if changes were made
        if (occCodeSequenceUpdates.size() > 0) update occCodeSequenceUpdates;
        system.debug('stageChangeIBprogrammes.size() =====> '+stageChangeIBprogrammes.size());
        system.debug('stageChangeIBprogrammes list =====> '+stageChangeIBprogrammes);
                }
        
        catch(exception x)
        {
            system.debug('exception occurred');
        }
    }

    // Method used to handle updates to an already existing OCC Code
    public void processOCCcodeChanges (List<IB_Programme__c> updtOCCcodes) {
        try
        {
        String dupeIBIScodeUpdt;
        String dupeOCCcodeUpdt;
        
        for (IB_Programme__c updtOCC : updtOCCcodes) {
            
            // Set dupe value variables to a default before processing the list of records
            dupeIBIScodeUpdt = 'Empty';
            dupeOCCcodeUpdt = 'Empty';
            
            Account tmpAccount = currIBIScodes.get(updtOCC.OCC_Code__c);
            if (tmpAccount != null) dupeIBIScodeUpdt = tmpAccount.IBIS_ID__c;
            IB_Programme__c tmpProg = currOCCcodes.get(updtOCC.OCC_Code__c);
            if (tmpProg != null) dupeOCCcodeUpdt = tmpProg.OCC_Code__c;
            system.debug('dupeIBIScodeUpdt =====> '+dupeIBIScodeUpdt);
            system.debug('dupeOCCcodeUpdt =====> '+dupeOCCcodeUpdt);

            if (dupeIBIScodeUpdt == 'Empty' && dupeOCCcodeUpdt == 'Empty') {
                updtOCC.OCC_Code_Duplicate_Found__c = false;
                updtOCC.OCC_Code_is_Valid__c = true;
                updtIBprogrammes.add(updtOCC);
            } else {
                updtOCC.OCC_Code__c = '';
                updtOCC.OCC_Code_Duplicate_Found__c = true;
                updtOCC.OCC_Code_is_Valid__c = false;
                updtIBprogrammes.add(updtOCC);
            }
        }
        system.debug('updtIBprogrammes.size() =====> '+updtIBprogrammes.size());
        system.debug('updtIBprogrammes list =====> '+updtIBprogrammes);
            }
        catch(exception x)
        {
            system.debug('exception occurred');
        }
    }*/

}