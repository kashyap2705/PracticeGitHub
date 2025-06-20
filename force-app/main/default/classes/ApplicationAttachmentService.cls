public class ApplicationAttachmentService {

	public static Boolean isCached = false;
	public static List<IB_Application_Attachment__c> attachments = null;
	public static Id programmeId = null;

	public static void queryApplicationAttachementsByProgId() {

		ApplicationAttachmentDAO dao = ApplicationAttachmentDAO.getInstance();
		attachments = dao.getAttachmentsByProgrammeId(programmeId);
		isCached = true;

	}

	public static List<IB_Application_Attachment__c> getApplicationAttachmentsByStage(String stage) {

		if (!isCached) {
			queryApplicationAttachementsByProgId();
		}

		List<IB_Application_Attachment__c> att = new List<IB_Application_Attachment__c>();
		for (IB_Application_Attachment__c aa : attachments) {
			if (aa.Category__c == stage && aa.Type__c != 'Course outline') {
				att.add(aa);
			}
		} 

		return att;

	}

	public static List<IB_Application_Attachment__c> getPublishedApplicationAttachments() {
        try
        {

		if (!isCached) {
			queryApplicationAttachementsByProgId();
		}

		List<IB_Application_Attachment__c> att = new List<IB_Application_Attachment__c>();
		for (IB_Application_Attachment__c aa : attachments) {
			if (aa.Publish_to_Community__c) {
				att.add(aa);
			}
		} 

		return att;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }

	}

	public static List<IB_Application_Attachment__c> getCandidacyResponseLetters() {
try
{
		if (!isCached) {
			queryApplicationAttachementsByProgId();
		}

		List<IB_Application_Attachment__c> att = new List<IB_Application_Attachment__c>();
		for (IB_Application_Attachment__c aa : attachments) {
			if (aa.Publish_to_Community__c && aa.Type__c == 'Letter') {
				att.add(aa);
			}
		} 

		return att;
}Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
	}

	public static List<IB_Application_Attachment__c> getCourseOutlines() {
try
{
		if (!isCached) {
			queryApplicationAttachementsByProgId();
		}

		List<IB_Application_Attachment__c> courseOutlineList = new List<IB_Application_Attachment__c>();
		for (IB_Application_Attachment__c aa : attachments) {
			if (aa.Type__c == 'Course outline') {
				courseOutlineList.add(aa);
			}
		}

		return courseOutlineList;
}Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }

	}

	public static void setProgrammeId(Id progId) {
		programmeId = progId;
	}

}