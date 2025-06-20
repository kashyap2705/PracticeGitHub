public without sharing class TrainingEventDAO {

	public static final TrainingEventDAO INSTANCE = new TrainingEventDAO();

	public List<Training_Event__c> getEligibleTrainings(List<String> appliedForRoleProgrammeCombos,String userRegion, String contactId){
		//Following code is added by Umair-Plumlogix of US11949 of Staff Augmentation Project on 06/18/2020
		//Start
        Boolean check =false;
        Boolean checkProgCP = false;
        Boolean checkProgDP = false;
        Boolean checkProgMYP = false;
        Boolean checkProgPYP = false;
        List<IB_Role__c> RolesOfContact = new List<IB_Role__c>();
        List<String> final_Roles = new List<String>();
        RolesOfContact = [Select IB_Role_Name__c, Status__c, Programme_Selection__c from IB_Role__c where IB_Contact__r.id =: contactId];
        system.debug('appliedForRoleProgrammeCombos:0 ' + appliedForRoleProgrammeCombos);
        for (String strRole : appliedForRoleProgrammeCombos)
        {
            check= strRole.contains('School Visit Team Leader');
            if (check==true)
            {
                String progCheckStr;
                checkprogCP = strRole.contains('CP');
                checkprogDP = strRole.contains('DP');
                checkprogMYP = strRole.contains('MYP');
                checkprogPYP = strRole.contains('PYP');
                if(checkprogCP == true)
                {
                    progCheckStr = 'CP';
                }
                else if(checkprogDP == true)
                {
                    progCheckStr = 'DP';
                }
                else if(checkprogMYP == true)
                {
                    progCheckStr = 'MYP';
                }
                else if(checkprogPYP == true)
                {
                    progCheckStr = 'PYP';
                }
                for (IB_Role__c roleTemp : RolesOfContact)
                {
                    if (roleTemp.IB_Role_Name__c == 'School Visit Team Member' && roleTemp.Status__c == 'Confirmed' && roleTemp.Programme_Selection__c == progCheckStr)
                    {
                        final_Roles.add(strRole);
                    }
                }
                
            }
            else
            {
                final_Roles.add(strRole);
            }
        }
        appliedForRoleProgrammeCombos = final_Roles;
        //End
        system.debug('appliedForRoleProgrammeCombos:1 ' + appliedForRoleProgrammeCombos);
        system.debug('userRegion: ' + userRegion);
        system.debug('contactId: ' + contactId);
        //CR-684 and CR-687 Changes
        return [SELECT Training_Event_Region__c, Training_Event_Country__c, Training_Event_City__c, Start_Date__c, Name, Id, IB_Role_Name__c, IB_Role_Name_ES__c, IB_Role_Name_Fr__c, IB_Event__c,IB_Event__r.Training_Language__c,
                            IB_Role__c, IB_Role_2__c, IB_Role_3__c, IB_Programme__c, End_Date__c, Application_Deadline__c
                FROM Training_Event__c 
                WHERE Training_Event_Status__c NOT IN ('Pending', 'Planned / Ready for Staffing','Participants Confirmed', 'Postponed', 'Cancelled', 'Completed','Confirmed')
                AND Training_Event_Region__c = :userRegion
                AND (Training_Event_Type__c = 'Initial Training'
                     OR Training_Event_Type__c = 'Advanced Training')
                AND Id NOT IN
                	(Select Training_Event__c
                     From My_Training_Event__c
                     Where IB_Contact__c = :contactId)
                AND (
                	IB_Role_1_Programme_Combo__c IN  :appliedForRoleProgrammeCombos 
                	OR (IB_Role_2_Programme_Combo__c IN :appliedForRoleProgrammeCombos) 
                	OR (IB_Role_3_Programme_Combo__c IN :appliedForRoleProgrammeCombos)
                	)
                AND (
                	(Application_Deadline__c = NULL AND Start_Date__c >= TODAY) 
                	OR Application_Deadline__c >= TODAY
                	)
                ORDER BY Start_Date__c];
	}
	//This Part is added by Developer Ammara-Plumlogix on 3-09-2019,CR-688(New Training Event Type 'Ongoing Development')
    //begin
    public List<Training_Event__c> getEligibleTrainings_ongoingdevlopment(List<String> ConfirmRoleProgrammeCombos,String userRegion, String contactId){
		system.debug('ConfirmForRoleProgrammeCombos: ' + ConfirmRoleProgrammeCombos);
        system.debug('userRegion: ' + userRegion);
        system.debug('contactId: ' + contactId);
        return [SELECT Training_Event_Region__c, Training_Event_Country__c, Training_Event_City__c, Start_Date__c, Name, Id, IB_Role_Name__c, IB_Role_Name_ES__c, IB_Role_Name_Fr__c, IB_Event__c,IB_Event__r.Training_Language__c,
                            IB_Role__c, IB_Role_2__c, IB_Role_3__c, IB_Programme__c, End_Date__c, Application_Deadline__c
                FROM Training_Event__c t
                WHERE Training_Event_Status__c NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Completed','Confirmed')
                AND Training_Event_Region__c = :userRegion
                AND (Training_Event_Type__c = 'Ongoing Development')
                AND Id NOT IN
                	(Select Training_Event__c
                     From My_Training_Event__c
                     Where IB_Contact__c = :contactId)
                AND (
                	IB_Role_1_Programme_Combo__c IN  :ConfirmRoleProgrammeCombos 
                	OR (IB_Role_2_Programme_Combo__c IN :ConfirmRoleProgrammeCombos) 
                	OR (IB_Role_3_Programme_Combo__c IN :ConfirmRoleProgrammeCombos)
                	)
                AND (
                	(Application_Deadline__c = NULL AND Start_Date__c >= TODAY) 
                	OR Application_Deadline__c >= TODAY
                	)
                ORDER BY Start_Date__c];
	}
	//end

    public List<Training_Event__c> getAppliedForTrainings(String contactId){
        return [SELECT Training_Event_Region__c, Training_Event_Country__c, Training_Event_City__c, Start_Date__c, Name, Id, IB_Role_Name__c, IB_Role_Name_ES__c, IB_Role_Name_Fr__c, IB_Event__c,IB_Event__r.Training_Language__c,
                            IB_Role__c, IB_Role_2__c, IB_Role_3__c, IB_Programme__c, End_Date__c, Application_Deadline__c
                FROM Training_Event__c t
                WHERE Id IN
                    (Select Training_Event__c
                     From My_Training_Event__c
                     Where IB_Contact__c = :contactId
                     And Application_Status__c in ('Invited','Confirmed','Pending Selection'))
                AND Start_Date__c >= TODAY
                ORDER BY Start_Date__c];
    }

}