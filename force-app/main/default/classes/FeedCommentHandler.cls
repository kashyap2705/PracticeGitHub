public without sharing class FeedCommentHandler {
    private static final CustomNotificationType customNotifType = [
        SELECT Id, DeveloperName
        FROM CustomNotificationType
        WHERE DeveloperName = 'Feed_Item_on_Support_Case_Custom_Notification'
        LIMIT 1
    ];
    
    private static final OrgWideEmailAddress[] owea = [
        SELECT Id
        FROM OrgWideEmailAddress
        WHERE Address = 'ibcommunities.noreply@ibo.org'
        LIMIT 1
    ];
    
    private static final IB_Answers__mdt communityPath = [
        SELECT Id, DeveloperName, Name__c, Value__c
        FROM IB_Answers__mdt
        WHERE DeveloperName = 'Community_base_path'
        LIMIT 1
    ];
    
    private static final IB_Answers__mdt SC_BASE_PATH = [
        SELECT Id, Value__c
        FROM IB_Answers__mdt
        WHERE DeveloperName = 'Service_Console_Base_Path'
        LIMIT 1
    ];
    
    private static List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
    
    private static final Map<String, Translation__c> translationsMap = new Map<String, Translation__c>();
    
    static {
        Map<String, String> languageCodeMap = new Map<String, String>{
            'American English' => 'en_US',
                'French' => 'fr',
                'Spanish' => 'es'
                };
                    
                    for (Translation__c translation : [
                        SELECT Id, Language__c, Value__c, CustomLabel__r.Label__c
                        FROM Translation__c
                        WHERE
                        CustomLabel__r.Label__c IN (
                            'view_case',
                            'comment_mention',
                            'comment_received'
                        )
                    ]) {
                        String languageCode = languageCodeMap.get(translation.Language__c);
                        if (languageCode != null) {
                            translationsMap.put(
                                translation.CustomLabel__r.Label__c + '_' + languageCode,
                                translation
                            );
                        }
                    }
    }
    
    public static void notifyStakeHolders(List<FeedComment> feedCommentList) {
        try{
            Set<Id> caseIdSet = new Set<Id>();
            List<Case> casesToUpdate = new List<Case>();
            for (FeedComment feed : feedCommentList) {
                string parentId = feed.ParentId;
                if(parentId?.startsWith('500'))
                	caseIdSet.add(feed.ParentId);
            }
            if (caseIdSet.size() > 0) {
            	 Map<Id, Case> caseMap = new Map<Id, Case>(
                [
                    SELECT
                    Id,
                    CaseNumber,
                    Contact.User__r.Email,
                    Contact.User__r.Id,
                    Contact.User__r.LanguageLocaleKey,
                    Contact.User__r.isActive,
                    Contact.User__c,
                    Owner.Email,
                    Owner.Id,
                    Owner.isActive,
                    RecordType.Name,
                    Status,
                    isClosed,
                    Owner.FirstName,
                    Subject
                    FROM Case
                    WHERE Id IN :caseIdSet AND RecordType.Name = 'Support'
                ]
            );
            
            String commentUsertype = UserInfo.getUserType();
            for (FeedComment fc : feedCommentList) {
                Case parentCase = caseMap.get(fc.ParentId);
                if (commentUsertype != 'Standard') {
                    if(!parentCase.isClosed) {
                        parentCase.Status = 'Updated';
                        casesToUpdate.add(parentCase);
                    }
                    if(String.valueOf(parentCase.Owner.Id).startsWith('005') && parentCase.Owner.isActive){
                        handleExpCloudComment(parentCase, fc);
                    }
                } else if (parentCase.Contact != null &&
                           parentCase.Contact.User__c != null && 
                           parentCase.Contact.User__r.isActive &&
                           parentCase.Contact.User__r.Id != UserInfo.getUserId()){
                    handleStandardComment(parentCase, fc);
                }
            }
            
            if (!casesToUpdate.isEmpty()) {
                update casesToUpdate;
            }
            
            if (!emailsToSend.isEmpty()) {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(emailsToSend, false);
            }    
           
            }
           
        } catch (Exception exp) {
            Logger.get().add(exp, LogSeverity.ERROR).publish();
        }
    }

    @TestVisible
    private static void handleExpCloudComment(Case parentCase, FeedComment fc) {
        FeedItem relatedPost = [SELECT Id, Visibility,createdBy.Id FROM FeedItem WHERE Id = :fc.FeedItemId];
        Id postUserId = relatedPost.createdBy.Id;
        Id commentUserId = fc.createdById;
        Boolean isPostByExternal = postUserId == commentUserId;
        
        if(isPostByExternal) {
            // To send custom bell notification
            Set<String> userIds = new Set<String>(); // User Id to which notification is sent
            userIds.add(parentCase.OwnerId);
            String communityMdt = communityPath.Value__c;
            String viewCaseUrl =
                communityPath.Value__c +
                '/s/case/' +
                parentCase.Id +
                '/view-Case';
            String body = 'You have received a comment:\n' + fc.CommentBody;
            body = body.stripHtmlTags();
            sendCustomNotification(body, parentCase.CaseNumber, customNotifType.Id, fc.ParentId, userIds);
        }
       
        // To send custom email notification
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> userEmails = new List<String>(); // Mail ids for Single Email Message
        if (owea.size() > 0) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }

        String mailSubject = 'New comment added on case ' + parentCase.CaseNumber;
        String mailBody = 
            'Hello ' + parentCase.Owner.FirstName + ',<br><br>'+
            'The status on a case assigned to you has been changed as there is new comment added.<br>' +
            'The details are below:' + '<br><br>' +
            'Case ID: ' + parentCase.CaseNumber + '<br>' +
            'Subject: ' + parentCase.Subject + '<br>' +
            'Status: ' + parentCase.Status + '<br><br>' +
            'To view the case please click the following link: <a href="' + SC_BASE_PATH.Value__c + parentCase.Id + '" target="_blank">'+ parentCase.CaseNumber +'</a>';
        

        userEmails.add(parentCase.Owner.Email);
        mail.setToAddresses(userEmails);
        mail.setSubject(mailSubject);
        mail.setHTMLBody(mailBody);
        mail.setSaveAsActivity(false);
        mail.setUseSignature(false);
        emailsToSend.add(mail);
    }
    
    private static void handleStandardComment(Case parentCase, FeedComment fc) {
        Set<String> userIds = new Set<String>(); // User Id to which notification is sent
        List<String> userEmails = new List<String>(); // Mail ids for Single Email Message
        userIds.add(parentCase.Contact.User__r.Id);
        userEmails.add(parentCase.Contact.User__r.Email);
        FeedItem relatedPost = [SELECT Id, Visibility FROM FeedItem WHERE Id = :fc.FeedItemId];
        String postVisibleTo = relatedPost.visibility;
        if (parentCase.Contact.User__r.Id != UserInfo.getUserId() && postVisibleTo != 'InternalUsers') {
            String viewCaseUrl =
                communityPath.Value__c +
                '/s/case/' +
                parentCase.Id +
                '/view-Case';
            String comment_received_key ='comment_received_' +parentCase.Contact.User__r.LanguageLocaleKey;
            String view_case_key = 'view_case_' + parentCase.Contact.User__r.LanguageLocaleKey;
            String body =
                (translationsMap.containsKey(comment_received_key)?
                translationsMap.get(comment_received_key).Value__c :'')+
                ':\n\n' +
                fc.CommentBody;
            if (parentCase.Contact.User__r.LanguageLocaleKey == 'fr') {
                body =
                (translationsMap.containsKey(comment_received_key)?
                translationsMap.get(comment_received_key).Value__c :'')+
                ' :\n\n' +
                fc.CommentBody;
            }

            String mailBody =
                '<div><p>' +
                body +
                '</p><a href="' +
                viewCaseUrl +
                '" target="_blank">' +
                (translationsMap.containsKey(view_case_key)?
                translationsMap.get(view_case_key).Value__c :'')+
                '</a></div>';
            String subjectKey;
            body = body.stripHtmlTags();
            sendCustomNotification(body, parentCase.CaseNumber, customNotifType.Id, fc.ParentId, userIds);
            List<string> toAddress = new List<string>();
            toAddress.addAll(userEmails);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(userEmails);
            if (owea.size() > 0) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            subjectKey =
                'comment_received_' +
                parentCase.Contact.User__r.LanguageLocaleKey;
            mail.setSubject(translationsMap.get(subjectKey).Value__c);
            
            mail.setHTMLBody(mailBody);
            mail.setSaveAsActivity(false);
            mail.setUseSignature(false);
            List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
            allmsg.add(mail);
            
            Messaging.SendEmailResult[] results = Messaging.sendEmail(allmsg);
        }
    }
    
    private static void sendCustomNotification(String body, String title, Id notificationTypeId, Id targetId, Set<String> userIds) {
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setNotificationTypeId(notificationTypeId);
        notification.setBody(body);
        notification.setTitle(title);
        notification.setTargetId(targetId);
        notification.send(userIds);
    }
}