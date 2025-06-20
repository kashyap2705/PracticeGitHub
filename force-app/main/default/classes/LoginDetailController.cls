/*
    Created By: Shahrukh Anwar
    Date: 09/03/2023
    Azure US No.: ECM00283
    Description: Login History Report for Community Moderator Users
*/

public with sharing class LoginDetailController {

    @AuraEnabled(cacheable=true)
	public static List<LoginDetailWrapper> getCommunityModeratorLoginDetails(String days) {
        Set<Id> contactIds = new Set<Id>();
        Map<Id, String> userNameByUserId = new Map<Id, String>();
        List<LoginDetailWrapper> loanDetailWrapperFinalList = new List<LoginDetailWrapper>();

        Datetime loginTimeSpan = LoginDetailControllerHelper.getLoginTimeSpan(days);
        
        contactIds = LoginDetailControllerHelper.getContactIds();
        
        userNameByUserId = LoginDetailControllerHelper.getUserNameByUserIdMap(contactIds);
        
        loanDetailWrapperFinalList = LoginDetailControllerHelper.getCommunityModeratorLoginHistory(userNameByUserId, loginTimeSpan);

        return loanDetailWrapperFinalList;
    }

    @AuraEnabled(cacheable=true)
	public static List<LoginDetailWrapper> getCommunityModeratorNonLoginDetails(String days) {
        Set<Id> contactIds = new Set<Id>();
        List<LoginDetailWrapper> loanDetailWrapperFinalList = new List<LoginDetailWrapper>();

        Datetime loginTimeSpan = LoginDetailControllerHelper.getLoginTimeSpan(days);
        
        contactIds = LoginDetailControllerHelper.getContactIds();
        
        loanDetailWrapperFinalList = LoginDetailControllerHelper.getLoanDetailWrapperByUserId(contactIds, loginTimeSpan);

        return loanDetailWrapperFinalList;
    }

    public class LoginDetailWrapper {
        @AuraEnabled public String userId;
        @AuraEnabled public String userName;
        @AuraEnabled public String loginTime;
        @AuraEnabled public String loginType;
        @AuraEnabled public String loginUrl;
        @AuraEnabled public String siteName;
	}

}