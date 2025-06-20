/*
    Created By: Shahrukh Anwar
    Date: 09/03/2023
    Azure US No.: ECM00283
    Description: Login History Report for Community Moderator Users
*/
public with sharing class LoginDetailControllerHelper {
    
    public static Datetime getLoginTimeSpan(String days) {
        Datetime loginTimeSpan;
        if(days == 'LAST_N_DAYS:30') {
            loginTimeSpan = Datetime.now() - 30;
        } else if(days == 'LAST_N_DAYS:60') {
            loginTimeSpan = Datetime.now() - 60;
        } else {
            loginTimeSpan = Datetime.now() - 90;
        }

        return loginTimeSpan;
    }

    public static Set<Id> getContactIds() {
        Set<Id> contactIds = new Set<Id>();

        for(IB_Role__c ibRole : [SELECT Id, IB_Contact__c 
                                    FROM IB_Role__c 
                                    WHERE Active__c = true 
                                    AND IB_Role_Name__c = 'Community Moderator']) {
            contactIds.add(ibRole.IB_Contact__c);
        }

        return contactIds;
    }

    public static Map<Id, String> getUserNameByUserIdMap(Set<Id> contactIds) {
        Map<Id, String> userNameByUserId = new Map<Id, String>();

        for(User usr : [SELECT Id, Name, ContactId 
                            FROM User 
                            WHERE IsActive = true 
                            AND ContactId IN :contactIds]) {
            LoginDetailController.LoginDetailWrapper wrap = new LoginDetailController.LoginDetailWrapper();
            wrap.userId = usr.Id;
            wrap.userName = usr.Name;
            
            System.debug('wrap User -------> '+wrap);

            userNameByUserId.put(usr.Id, usr.Name);
        }

        return userNameByUserId;
    }

    public static List<LoginDetailController.LoginDetailWrapper> getCommunityModeratorLoginHistory(Map<Id, String> userNameByUserId, Datetime loginTimeSpan) {
        List<LoginDetailController.LoginDetailWrapper> loanDetailWrapperFinalList = new List<LoginDetailController.LoginDetailWrapper>();

        for(LoginHistory lh : [SELECT Id, UserId, LoginTime, LoginType, LoginUrl, NetworkId 
                                FROM LoginHistory 
                                WHERE UserId IN :userNameByUserId.keyset() 
                                AND NetworkId != NULL 
                                AND LoginUrl LIKE '%IBProgramme%'
                                AND LoginTime > :loginTimeSpan]) {
            LoginDetailController.LoginDetailWrapper wrapper = new LoginDetailController.LoginDetailWrapper();
            wrapper.userId = lh.UserId;
            wrapper.userName = userNameByUserId.get(lh.UserId);
            wrapper.loginTime = String.valueOf(lh.LoginTime);
            wrapper.loginType = lh.LoginType;
            wrapper.loginUrl = lh.LoginUrl;
            wrapper.siteName = 'IB Programme Communities';

            System.debug('wrapper LoginHistory --------> '+wrapper);

            loanDetailWrapperFinalList.add(wrapper);
        }

        return loanDetailWrapperFinalList;
    }

    public static List<LoginDetailController.LoginDetailWrapper> getLoanDetailWrapperByUserId(Set<Id> contactIds, Datetime loginTimeSpan) {
        Map<Id, LoginDetailController.LoginDetailWrapper> loanDetailWrapperByUserId = new Map<Id, LoginDetailController.LoginDetailWrapper>();

        for(User usr : [SELECT Id, Name, ContactId 
                            FROM User 
                            WHERE IsActive = true 
                            AND ContactId IN :contactIds]) {
            LoginDetailController.LoginDetailWrapper wrap = new LoginDetailController.LoginDetailWrapper();
            wrap.userId = usr.Id;
            wrap.userName = usr.Name;
            
            System.debug('wrap User -------> '+wrap);

            loanDetailWrapperByUserId.put(usr.Id, wrap);
        }

        for(LoginHistory lh : [SELECT Id, UserId, LoginTime, LoginType, LoginUrl, NetworkId 
                                FROM LoginHistory 
                                WHERE UserId IN :loanDetailWrapperByUserId.keySet() 
                                AND NetworkId != NULL 
                                AND LoginUrl LIKE '%IBProgramme%'
                                AND LoginTime > :loginTimeSpan]) {
                                    loanDetailWrapperByUserId.remove(lh.UserId);
        }

        return loanDetailWrapperByUserId.values();
    }
}