public with sharing class CSM_CaseAuController {
  public static Boolean isException = false;
  private static String FILE_NAME = 'IB_Answers_';
  private static String SHARE_TYPE = 'I';
  private static String ORIGIN = 'Web';
  private static String STATUS = 'Open';

  /*
*********************************************************
@Method Name    : updateContactEmail
@description    : method is used to update Contact email 
@param          : Map<String, Object>, Case
@return         : void
********************************************************
*/

  public static void updateContactEmail(
    Map<String, Object> contactData,
    Case newCase
  ) {
    try {
      if (isException) {
        throw new DmlException('Something went wrong');
      }
      String altEmail = String.valueOf(contactData.get('Alternative_Email__c'));
      if (!String.isBlank(altEmail)) {
        Contact existingContact = new Contact();
        existingContact.Alternative_Email__c = altEmail;
        existingContact.Id = getUserContact().Id;
        update existingContact;
      }
    } catch (Exception exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new AuraHandledException(exp.getMessage());
    }
  }

  /*
*********************************************************
@Method Name    : updateContentDocuments
@description    : method is used to update content documents based on attachment came from created case 
@param          : List<Id>, Id
@return         : void
********************************************************
*/

  public static void updateContentDocuments(
    List<Id> contentVersionIds,
    Id newCaseId
  ) {
    try {
      if (isException) {
        throw new QueryException('Something went wrong');
      }
      if (!contentVersionIds.isEmpty()) {
        Set<Id> contentDocumentIds = getContentDocumentIds(contentVersionIds);
        updateContentDocumentTitles(contentDocumentIds);
        updateContentDocumentLinks(contentDocumentIds, newCaseId);
      }
    } catch (Exception exp) {
      throw new AuraHandledException(exp.getMessage());
    }
  }

  /*
    *********************************************************
    @Method Name    : getUserContact
    @description    : method is used to get user contact 
    @param          : void
    @return         : Contact
    ********************************************************
*/

  public static Contact getUserContact() {
    return [
      SELECT id, User__r.id, Name
      FROM Contact
      WHERE User__r.id = :UserInfo.getUserId()
    ];
  }

  /*
*********************************************************
@Method Name    : getContentDocumentIds
@description    : method is used to get ContentDocumentIds based on ContentVersionIds
@param          : List<Id>
@return         : Set<Id>
********************************************************
*/

  public static Set<Id> getContentDocumentIds(List<Id> contentVersionIds) {
    List<ContentVersion> contentVersionList = [
        SELECT id, ContentDocumentId
        FROM ContentVersion
        WHERE id IN :contentVersionIds
      ];
      Set<Id> contentDocumentIds = new Set<Id>();
      for (ContentVersion cv : contentVersionList) {
        contentDocumentIds.add(cv.ContentDocumentId);
      }
      return contentDocumentIds;
  }

  /*
    *********************************************************
    @Method Name    : getContentVersions
    @description    : method is used to get contentVersions
    @param          : List<String>
    @return         : List<ContentVersion>
    ********************************************************
*/
  @AuraEnabled
  public static List<ContentVersion> getContentVersions(
    List<String> contentVersionIds
  ) {
    try {
      if (isException) {
        throw new QueryException('Something went wrong');
      }
      return [
        SELECT
          Id,
          ContentDocumentId,
          FileExtension,
          Title,
          ContentSize,
          CreatedBy.Name
        FROM ContentVersion
        WHERE Id IN :contentVersionIds
      ];
    } catch (Exception exp) {
      throw new AuraHandledException(exp.getMessage());
    }
  }

  /*
    *********************************************************
    @Method Name    : deleteContentDocument
    @description    : method is used to get delete ContentDocument
    @param          : List<String>
    @return         : String
    ********************************************************
*/
  @AuraEnabled
  public static String deleteContentDocument(List<String> contentVersionId) {
    try {
      if (isException) {
        throw new QueryException('Something went wrong');
      }
      List<String> contentDocumentIDList = new List<String>();
      for (ContentVersion cv : [
        SELECT
          Id,
          ContentDocumentId,
          FileExtension,
          Title,
          ContentSize,
          CreatedBy.Name
        FROM ContentVersion
        WHERE Id IN :contentVersionId
      ]) {
        contentDocumentIDList.add(cv.ContentDocumentId);
      }
      List<ContentDocument> cd = [
        SELECT Id, CreatedBy.name, ContentSize, ParentId
        FROM ContentDocument
        WHERE Id IN :contentDocumentIDList
      ];
      Database.delete(cd, false);
      return 'Success';
    } catch (Exception exp) {
      throw new AuraHandledException(exp.getMessage());
    }
  }

  /*
*********************************************************
@Method Name    : updateContentDocumentTitles
@description    : method is used to append 'IB_Answers_' when attachment are inserted from case form
@param          : Set<Id>
@return         : void
********************************************************
*/

  public static void updateContentDocumentTitles(Set<Id> contentDocumentIds) {
    try {
      List<ContentDocument> cdListToUpdate = [
        SELECT Id, Title
        FROM ContentDocument
        WHERE Id IN :contentDocumentIds
      ];
      for (ContentDocument cd : cdListToUpdate) {
        cd.Title = FILE_NAME + cd.Title;
      }
      Database.update(cdListToUpdate, false);
    } catch (Exception exp) {
      throw new AuraHandledException(exp.getMessage());
    }
  }

  /*
*********************************************************
@Method Name    : updateContentDocumentLinks
@description    : method is used to clone and update ContentDocumentLink
@param          : Set<Id>, Id
@return         : void
********************************************************
*/
  @TestVisible
  public static void updateContentDocumentLinks(
    Set<Id> contentDocumentIds,
    Id newCaseId
  ) {
    try {
      if (isException) {
        throw new QueryException('Something went wrong');
      }
      if (contentDocumentIds.size() > 0) {
        List<ContentDocumentLink> contentDocLinkList = [
          SELECT id, ContentDocumentId, LinkedEntityId, ShareType
          FROM ContentDocumentLink
          WHERE ContentDocumentId IN :contentDocumentIds
        ];
        List<ContentDocumentLink> contentDocLinkToUpdate = new List<ContentDocumentLink>();
        for (ContentDocumentLink conDoc : contentDocLinkList) {
          ContentDocumentLink cloned = conDoc.clone();
          cloned.LinkedEntityId = newCaseId;
          cloned.ShareType = SHARE_TYPE;
          contentDocLinkToUpdate.add(cloned);
        }
        Database.insert(contentDocLinkToUpdate, false);
      }
    } catch (Exception exp) {
      throw new AuraHandledException(exp.getMessage());
    }
  }
}