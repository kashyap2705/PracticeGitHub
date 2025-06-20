public class CourseOutlineReadingDAO {

	private static final CourseOutlineReadingDAO instance = new CourseOutlineReadingDAO();
	private Course_Outline_Reading__c reading;
	private List<Course_Outline_Reading__c> readings;

	private CourseOutlineReadingDAO() {}

	public static CourseOutlineReadingDAO getInstance() {
		return instance;
	}

	public List<Course_Outline_Reading__c> getCourseOutlineReadingsByProgrammeId(Id programmeId) {

		readings = [
			SELECT Id, Name, Programme__c, Programme__r.Name, Application_Attachment__c, Application_Attachment__r.Attachment__c, 
				Feedback_Attachment__c, Feedback_Attachment__r.Attachment__c, Feedback_Attachment__r.Name, Subject_Id__c, 
				Subject__c, Group__c, Level__c, Subject_Proposal_Id__c, Resubmission_Date__c, Resubmission_Due_Date__c, 
				Course_Outline_Returned_Comment__c, Status__c, Template_EN__c, Template_SP__c, Template_FR__c  
			FROM Course_Outline_Reading__c 
			WHERE Programme__c = :programmeId
		];

		return readings;

	}

	public Course_Outline_Reading__c getCourseOutlineReadingsById(Id readingId) {

		reading = [
			SELECT Id, Name, Programme__c, Programme__r.Name, Application_Attachment__c, Application_Attachment__r.Attachment__c, 
				Feedback_Attachment__c, Feedback_Attachment__r.Attachment__c, Feedback_Attachment__r.Name, Subject_Id__c, 
				Subject__c, Group__c, Level__c, Subject_Proposal_Id__c, Resubmission_Date__c, Resubmission_Due_Date__c, 
				Course_Outline_Returned_Comment__c, Status__c, Template_EN__c, Template_SP__c, Template_FR__c  
			FROM Course_Outline_Reading__c 
			WHERE Id = :readingId
		];

		return reading;

	}

}