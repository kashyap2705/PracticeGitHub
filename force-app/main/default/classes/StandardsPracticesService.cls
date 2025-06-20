/*******************************************************************************************
* @Name         StandardsPracticesService 
* @Author       
* @Date         
* @Group        
* @Description  
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0           Saurabh Singh      05/23/2023         I have added a None value in the picklist in line number 71
*******************************************************************************************/
public class StandardsPracticesService {

	public static List<Standards_Practices__c> standardsAndPractices = null;
	public static Boolean isStandardsAndPracticesCached = false;
	public static String programmeChoice = '';

	public static void setProgrammeChoice(String choice, String phase) {
		if(choice == 'CP' && phase == 'Phase 1'){
            programmeChoice = 'CP1';
        } else if(choice == 'CP' && phase == 'Phase 2'){
            programmeChoice = 'CP2';
        } else if(choice == 'Diploma Programme'){
            programmeChoice = 'DP';
        } else if(choice == 'MYP Partner'){
        	programmeChoice = 'MYP';
        } else {
            programmeChoice = choice;
        }
	}

	public static List<Standards_Practices__c> getStandardsAndPractices() {
		
		if (!isStandardsAndPracticesCached) {
			
			StandardsPracticesDAO dao = StandardsPracticesDAO.getInstance();
			if(programmeChoice == '')
				standardsAndPractices = dao.getStandardsAndPractices();
			else
				standardsAndPractices = dao.getStandardsAndPracticesByProgramme(programmeChoice);
			isStandardsAndPracticesCached = true;

		}

		
			return standardsAndPractices;
		
	}

	public static Standards_Practices__c getStandardAndPracticeByPracticeIdFilter(String practiceId) {

		getStandardsAndPractices();

		for (Standards_Practices__c sp : standardsAndPractices) {
			if (sp.Practice_ID__c == practiceId) {
				return sp;
			}
		}

		return null;

	}

	public static List<SelectOption> getStandardsPicklistOptions() {

		List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = Standards_Practices__c.Standard__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('--None--', '--None--'));
        for(Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getValue(), f.getLabel()));
        }

		return options;
	}

	public static List<SelectOption> getPracticesDependentPicklistOptions(String standard) {

		getStandardsAndPractices();

		List<SelectOption> options = new List<SelectOption>();
		for (Standards_Practices__c sp : standardsAndPractices) {
			if (sp.Standard__c == standard) {
				if (sp.Practice__c.length() > 80)	{
					options.add(new SelectOption(sp.Id, sp.Practice__c.substring(0, 79) + '...'));
				}
				else {
					options.add(new SelectOption(sp.Id, sp.Practice__c));
				}
			}
		}
		
		return options;

	}
	
}