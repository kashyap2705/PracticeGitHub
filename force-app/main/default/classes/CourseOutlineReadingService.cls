public without sharing class CourseOutlineReadingService {

	public static Course_Outline_Reading__c reading = null;
	public static List<Course_Outline_Reading__c> readings = null;

	public static Boolean isReadingCached = false;
	public static Boolean isReadingsCached = false;

	public static Id readingId = null;
	public static Id subjectId = null;
	public static Id programmeId = null;

	public static Course_Outline_Reading__c getCourseOutlineReadingById() {

		if (!isReadingCached) {

			if (readingId == null) {
				throw new CustomValidationException('The value for readingId cannot be null.');
			}
			
			CourseOutlineReadingDAO dao = CourseOutlineReadingDAO.getInstance();
			reading = dao.getCourseOutlineReadingsById(readingId);
			isReadingCached = true;

		}

		return reading;

	}

	public static Course_Outline_Reading__c getCourseOutlineReadingBySubject() {

		getCourseOutlinesReadingsByProgramme();

		if (!isReadingCached) {

			if (subjectId == null) {
				throw new CustomValidationException('The value for readingId cannot be null.');
			}
			
			for (Course_Outline_Reading__c cor : readings) {
				if (cor.Subject_Id__c == subjectId) {
					reading = cor;
					break;
				}
			}
			isReadingCached = true;

		}

		return reading;

	}

	public static List<Course_Outline_Reading__c> getCourseOutlinesReadingsByProgramme() {

		if (!isReadingsCached) {

			if (programmeId == null) {
				throw new CustomValidationException('The value for programmeId cannot be null.');
			}
			
			CourseOutlineReadingDAO dao = CourseOutlineReadingDAO.getInstance();
			readings = dao.getCourseOutlineReadingsByProgrammeId(programmeId);
			isReadingsCached = true;

		}

		return readings;

	}

	public static void setReadingId(Id readId) {
		readingId = readId;
	}

	public static void setProgrammeId(Id progId) {
		programmeId = progId;
	}

	public static void setSubjectId(Id subId) {
		subjectId = subId;
	}
    
    public static void createCourseOutlineReadings(Set<Id> progIdSet) {
       
        List<Course_Outline_Reading__c> existingCourseOutlines = [
            SELECT Id,Programme__c 
            FROM Course_Outline_Reading__c 
            WHERE Programme__c in :progIdSet
        ];
        
        for(Course_Outline_Reading__c cor : existingCourseOutlines) {
            progIdSet.remove(cor.Programme__c);
        }

        List<Course_Outline_Reading__c> courseOutlines = new List<Course_Outline_Reading__c>();
        
        if(progIdSet.size() > 0) {   
            
            List<Campaign> events = new List<Campaign>();
            
            for(IB_Application_Attachment__c aa : [
                	SELECT Id, Name, Type__c, Publish_to_Community__c, View__c, IB_Subject__c, IB_Subject__r.Subject_Name__c, Subject_Proposal__c, Attachment__c, IB_Programme__c, IB_Programme__r.Name, 
                		Subject_Proposal__r.Subject_Level__c, Subject_Proposal__r.Language_of_Instruction__c, IB_Programme__r.SS_Region_Account_ID__c, IB_Programme__r.Owner__c, IB_Programme__r.Account__c 
                	FROM IB_Application_Attachment__c 
                    WHERE IB_Programme__c IN :progIdSet 
                    AND Type__c = 'Course outline'
            	]
            ) {
				
                courseOutlines.add(new Course_Outline_Reading__c(Programme__c = aa.IB_Programme__c, Application_Attachment__c = aa.Id, Event_Association_ID__c = aa.Id));
                
                String lvl = '';
                if (aa.Subject_Proposal__r.Subject_Level__c == 'Higher') {
                    lvl = 'HL';
                }
                else if (aa.Subject_Proposal__r.Subject_Level__c == 'Standard') {
                    lvl = 'SL';
                }

                String name = aa.IB_Subject__r.Subject_Name__c + ' ' + lvl + ' - ' + aa.IB_Programme__r.Name;
                events.add(new Campaign(
                    Name = name.left(80), 
                    Event_Organizer_Account__c = aa.IB_Programme__r.SS_Region_Account_ID__c,
                    OwnerId = aa.IB_Programme__r.Owner__c,
                    RecordTypeId = '01220000000Ewq0AAC',
                    Related_IB_Programme__c = aa.IB_Programme__c,
                    Status = 'Planned / Ready for Staffing',
                    Type = 'Authorization',
                    Sub_Type__c = 'Course Outline Reading',
                    Venue_Account__c = aa.IB_Programme__r.Account__c,
                    IB_Subject__c = aa.IB_Subject__r.Id,
                    CurrencyIsoCode = 'USD',
                    StartDate = date.today(),
                    EndDate = date.today()+7,
                    Course_Outline_Reading__r = new Course_Outline_Reading__c(Event_Association_ID__c = aa.Id),
                    Event_Language_Override__c = aa.Subject_Proposal__r.Language_of_Instruction__c,
                    Required_Number_of_Educators__c = 1
                ));
                
            }
            
            insert courseOutlines;
            insert events;
            
        }
        
        
    }

}