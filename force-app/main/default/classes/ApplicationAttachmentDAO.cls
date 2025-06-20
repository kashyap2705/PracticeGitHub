public class ApplicationAttachmentDAO {
	
	private static final ApplicationAttachmentDAO instance = new ApplicationAttachmentDAO();
	private List<IB_Application_Attachment__c> attachments;

	private ApplicationAttachmentDAO() {}

	public static ApplicationAttachmentDAO getInstance() {
		return instance;
	}

	public List<IB_Application_Attachment__c> getAttachmentsByProgrammeId(Id progId) {
       /*This part of Code is being Updated by Ammara-Plumlogix as part of US-11987,7-28-2020
        * As, new Fields are added in IB Application Attachment Object
        * Begin*/
		attachments = [

			SELECT Id, Name, IB_Programme__c,toLabel(BQC_Subject__c), IB_Programme__r.Name, Attachment__c, Category__c,Unit_Plan__c, Description__c, Publish_to_Community__c, 

			toLabel(Type__c), IB_Subject__c, Subject_Proposal__c, Uploaded_By__c, View__c, LastModifiedDate, IsDeleted, CreatedDate
            FROM IB_Application_Attachment__c
            WHERE IB_Programme__c = :progId 
            ORDER BY Type__c, CreatedDate ASC/*End*/
		];

		return attachments;

	}

}