/*******************************************************************************************
* @author : oleg, CoastalCloud.us
* @date : 1/19/2016
* @description: CR 3803 (5) Weekly Email Digest of New Assignments
*
* © Copyright 2011 - 2016 CoastalCloud, Inc.  All Rights Reserved.
* 
* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Ranjith Kondabathini      08/01/2023         Added logger framework to publish error messages - 193958 - PRB0041113
*******************************************************************************************/

global class IBAssignmentDigestSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {        
        try {
        	//needs to be moved to batch if we need to clean up records for more users
        	List<Assignment_Digest__c> listAD = [SELECT Id FROM Assignment_Digest__c];
        	delete listAD;
        } catch (Exception exp) {
        	Logger.get().add(exp, LogSeverity.ERROR).publish();
        }
        
        IBAssignmentDigestBatch b = new IBAssignmentDigestBatch ();
        
        Database.executeBatch (b);
    }
}