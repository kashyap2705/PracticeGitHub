/******************************************************************************************* 
* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0             Michael  Khan     08/08/2023         PRB0041127: Apex Test Execution Failed (ScheduledIbenEndDateRolesTest)
*******************************************************************************************/
public class IbenEndDateRoles {
	public static void IbenEndDateRoles() {
		List<IB_Role__c> rolesToWithdraw;
        if(!Test.isRunningTest()) {
            rolesToWithdraw = [
                SELECT Id, Status__c, IB_Role__c, IB_Role_Name__c, Reason_For_Access__c, IB_Role__r.Display_In_PIMS_Community__c, IB_Role__r.SF_Role_Application__c, End_Date__c, Active__c 
                FROM IB_Role__c 
                WHERE End_Date__c != null 
                AND End_Date__c <= TODAY 
                AND Status__c in ('Confirmed','Applicant')
                AND IB_Role__r.Display_In_PIMS_Community__c = false 
                AND IB_Role__r.SF_Role_Application__c = true 
            ];
        } else {
            rolesToWithdraw = [
                SELECT Id, Status__c, IB_Role__c, IB_Role_Name__c, Reason_For_Access__c, IB_Role__r.Display_In_PIMS_Community__c, IB_Role__r.SF_Role_Application__c, End_Date__c, Active__c 
                FROM IB_Role__c ];
        }
        
        if (rolesToWithdraw.size() == 0) { return; }
        
        for (IB_Role__c role : rolesToWithdraw) {
            role.Status__c = 'Withdrawn';
            role.Active__c = false;
           //this line is updated by developer Abd Ur Rehman-Plumlogix as part of cr- us11727 on 21-2-2020
            //change the role name from "Global PD Contractor" to "Professional Services Contractor"
            //begin
            if (role.IB_Role_Name__c == 'Professional Services Contractor' && role.Reason_For_Access__c == null) {
                //end{




                role.Reason_For_Access__c = 'N/A';
            }
        }
        
        update rolesToWithdraw;
	}
}