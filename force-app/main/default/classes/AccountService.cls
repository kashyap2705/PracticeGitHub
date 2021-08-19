/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-18-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AccountService {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String strAccountName) {
      system.debug('strAccountName****'+strAccountName);
      String strKey = '%'+strAccountName+'%';
       List<Account> accList = [SELECT Id,Name,AccountNumber FROM Account WHERE name like :strKey ];
       return accList;
     }
    }