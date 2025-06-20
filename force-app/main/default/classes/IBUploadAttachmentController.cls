public class IBUploadAttachmentController {

     public String selectedType {get;set;}
     public Boolean publishToCommunity {get;set;}
     public String description {get;set;}
     private IB_Programme__c IBprogramme {get;set;}
     public String fileName {get;set;}
     public Blob fileBody {get;set;}
     public String Prog_Stage_name = '';

     public IBUploadAttachmentController(ApexPages.StandardController controller) {
          this.IBprogramme = (IB_Programme__c)controller.getRecord();
          system.debug('IBprogramme =====> '+IBprogramme);
          Prog_Stage_name = [SELECT StageName__c FROM IB_Programme__c WHERE Id = :IBprogramme.Id].StageName__c;
     }

     // get picklist values for the attachment type from the IB Application Attachment object
     public List<SelectOption> getAttachmentTypes() {
          List<SelectOption> options = new List<SelectOption>();
          //options.add(new SelectOption('','--Select--'));
          Schema.DescribeFieldResult attachmentTypeFieldDescription = IB_Application_Attachment__c.Type__c.getDescribe();
          for (Schema.Picklistentry picklistEntry : attachmentTypeFieldDescription.getPicklistValues()) {
               options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
          }
          return options;
     }

     // creates a new IB_Application_Attachment__c record
     private Database.SaveResult saveCustomAttachment() {
          IB_Application_Attachment__c obj = new IB_Application_Attachment__c();
          obj.IB_Programme__c = IBprogramme.Id;
          obj.description__c = description;
          obj.type__c = selectedType;
          obj.Category__c = Prog_Stage_name;
          obj.Uploaded_By__c = UserInfo.getUserId();
          obj.Publish_to_Community__c = publishToCommunity;
          // fill out cust obj fields
          return Database.insert(obj);
     }

     // create an actual Attachment record with the IB_Application_Attachment__c as parent
     private Database.SaveResult saveStandardAttachment(Id parentId) {
          Database.SaveResult result;

          Attachment attachment = new Attachment();
          attachment.body = this.fileBody;
          attachment.name = this.fileName;
          attachment.parentId = parentId;
          // insert the attahcment
          result = Database.insert(attachment);
          // reset the file for the view state
          fileBody = Blob.valueOf(' ');
          return result;
     }

     /**
     * Upload process is:
     *  1. Insert new IB_Application_Attachment__c record
     *  2. Insert new Attachment with the new IB_Application_Attachment__c record as parent
     *  3. Update the IB_Application_Attachment__c record with the ID of the new Attachment
     **/
     public PageReference processUpload() {
          try {
               Database.SaveResult customAttachmentResult = saveCustomAttachment();

               if (customAttachmentResult == null || !customAttachmentResult.isSuccess()) {
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Could not save attachment.'));
                    return null;
               }

               Database.SaveResult attachmentResult = saveStandardAttachment(customAttachmentResult.getId());

               if (attachmentResult == null || !attachmentResult.isSuccess()) {
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Could not save attachment.'));
                    return null;
               } else {
                    // update the custom attachment record with some attachment info
                    IB_Application_Attachment__c customAttachment = [select id from IB_Application_Attachment__c where id = :customAttachmentResult.getId()];
                    customAttachment.name = this.fileName;
                    customAttachment.Attachment__c = attachmentResult.getId();
                    update customAttachment;
               }

          } catch (Exception e) {
               ApexPages.AddMessages(e);
               return null;
          }

          return new PageReference('/'+IBprogramme.Id);
     }

     public PageReference back() {
          return new PageReference('/'+IBprogramme.Id);
     }
}