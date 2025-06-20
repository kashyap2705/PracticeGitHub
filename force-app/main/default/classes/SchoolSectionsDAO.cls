public class SchoolSectionsDAO {

	private static final SchoolSectionsDAO instance = new SchoolSectionsDAO();
	@testvisible private static List<SchoolSections__c> sections;
	private SchoolSections__c section;
    public static List<IB_Data_Translate__c> translations { get; set; }

	private SchoolSectionsDAO() {}

	public static SchoolSectionsDAO getInstance() {
		return instance;
	}
    // In The Following function A Query is  Updated By Shehryar-plumlogix for US-12218 of sprint 21 on 05/29/2021
    // To Get New fields values Of SchoolSections__c Object

	public List<SchoolSections__c> getSchoolSectionsByAccountId(Id accountId) {
        
		if (sections == null) {
            sections = [
                SELECT Id, Name, Account__c, Age_From__c, Age_To__c,toLabel(Grade_From__c), toLabel(Grade_To__c),Academic_Year__c,CP_enrollment__c,
                DP_course_candidate_enrollment__c,DP_diploma_candidate_enrollment__c,MYP_enrollment__c,
                Projected__c,PYP_enrollment__c, Number_Of_Classes__c, Number_Of_Students__c, toLabel(Section_Name__c),isPYPEnrollmentProjected__c,
                isDPdiplomaProjected__c,isCPEnrollmentProjected__c,isDPcourseProjected__c,isMYPEnrollmentProjected__c
                FROM SchoolSections__c
                WHERE Account__c = :accountId
                ORDER BY Grade_From__c ASC
            ];
        }
		
        if (translations == null) {
            translations = [
                SELECT Id, Name, Record_ID__c, Object_Name__c, Locale__c, Translate_Value_1__c, Translate_Value_2__c 
                FROM IB_Data_Translate__c 
                WHERE Object_Name__c = 'SchoolSections__c'
                AND Locale__c = :UserInfo.getLanguage()
            ];
        }

        for (SchoolSections__c a : sections) {
            for (IB_Data_Translate__c t : translations) {
                if (a.Section_Name__c == t.Record_ID__c) {
                    a.Section_Name__c = t.Translate_Value_1__c;
                }
            }
        }

		return sections;

	}
    	public List<SchoolSections__c> getSchoolSectionsByAccountIdForCurrentYear(Id accountId) {
        integer year =  Date.Today().Year();   
        string Year1 =string.valueOf(year);
            year++;
           string Year2 = string.valueof(year).right(2);
           String CurrentYear = Year1 + '-' + Year2;
            System.debug('Javalog -- Current Year: '+CurrentYear);
		if (sections == null) {
            sections = [
                SELECT Id, Name, Account__c, Age_From__c, Age_To__c,toLabel(Grade_From__c), toLabel(Grade_To__c),Academic_Year__c,CP_enrollment__c,
                DP_course_candidate_enrollment__c,DP_diploma_candidate_enrollment__c,MYP_enrollment__c,
                Projected__c,PYP_enrollment__c, Number_Of_Classes__c, Number_Of_Students__c, toLabel(Section_Name__c),isPYPEnrollmentProjected__c,
                isDPdiplomaProjected__c,isCPEnrollmentProjected__c,isDPcourseProjected__c,isMYPEnrollmentProjected__c
                FROM SchoolSections__c
                WHERE Account__c = :accountId
                AND Academic_Year__c = :CurrentYear
                ORDER BY Grade_From__c ASC
            ];
        }
		
        if (translations == null) {
            translations = [
                SELECT Id, Name, Record_ID__c, Object_Name__c, Locale__c, Translate_Value_1__c, Translate_Value_2__c 
                FROM IB_Data_Translate__c 
                WHERE Object_Name__c = 'SchoolSections__c'
                AND Locale__c = :UserInfo.getLanguage()
            ];
        }

        for (SchoolSections__c a : sections) {
            for (IB_Data_Translate__c t : translations) {
                if (a.Section_Name__c == t.Record_ID__c) {
                    a.Section_Name__c = t.Translate_Value_1__c;
                }
            }
        }

		return sections;

	}
    
    

    
    

    
}