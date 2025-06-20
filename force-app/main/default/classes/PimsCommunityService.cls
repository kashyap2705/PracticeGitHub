public class PimsCommunityService {
    
    @TestVisible private User user { get; set; }
    @TestVisible private Contact contact { get; set; }
    @TestVisible private Account account { get; set; }
    @TestVisible private Id accountOverrideId { get; set; }
    @TestVisible private List<IB_Role__c> roles { get; set; }
    @TestVisible private IB_View_State_Contacts__c vsContact { get; set; }
    
    public User getCurrentUser() {
        try
        {
            if (user == null) {
                initUserData();
            }
            return user;
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
    }
    
    public Contact getCurrentContact() {
        try
        {
            if (contact == null) {
                initUserData();
            }
            return contact;
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
    }
    
    public Account getCurrentAccount() {
        try
        {
            if (account == null) {
                initUserData();
            }
            return account;
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
    }
    
    public void initUserData() {
        try
        {
            user = UserService.getUser();
            system.debug('testAhamd'+Userinfo.getProfileId());
            // used for testing view state (System Admin Profile)
            if (Userinfo.getProfileId() == '00e20000001EEFOAA4') {
                
                vsContact = [SELECT Contact_ID__c, Account_ID__c FROM IB_View_State_Contacts__c WHERE Active__c = true LIMIT 1];
                system.debug('connnn'+vsContact);
                if (vsContact != null) {
                    
                    ContactService.setContactId(vsContact.Contact_ID__c);
                    contact = ContactService.getContact();
                    
                    RoleService.setContactId(contact.Id);
                    roles = RoleService.getRolesByContactId();
                    
                    getAccountCookie();
                    
                    if (accountOverrideId == null) {
                        AccountService.setAccountId(contact.AccountId);
                        account = AccountService.getAccount();
                    }
                    else {
                        AccountService.setAccountId(accountOverrideId);
                        account = AccountService.getAccount();
                    }
                    
                }
                
            }
            else {
                
                ContactService.setContactId(user.ContactId);
                contact = ContactService.getContact();
                
                RoleService.setContactId(contact.Id);
                roles = RoleService.getRolesByContactId();
                
                getAccountCookie();
                
                if (accountOverrideId == null) {
                    AccountService.setAccountId(contact.AccountId);
                    account = AccountService.getAccount();
                }
                else {
                    AccountService.setAccountId(accountOverrideId);
                    account = AccountService.getAccount();
                }
                
            }
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
            
        }
        
    }
    
    public void setAccountCookie(String accountId) {
        try
        {
            initUserData();
            
            Cookie accountCookie = ApexPages.currentPage().getCookies().get('user_acct');
            
            Crypto_Keys__c cryptoSetting = Crypto_Keys__c.getValues('PIMS_Account');
            Blob cryptoKey = EncodingUtil.base64Decode(cryptoSetting.Key__c);
            
            Blob cookieData = Blob.valueOf(contact.Id + '|' + accountId);
            Blob encryptedCookieData = Crypto.encryptWithManagedIV('AES256', cryptoKey, cookieData);
            String encryptedCookieDataStr = EncodingUtil.base64Encode(encryptedCookieData);
            
            accountCookie = new Cookie('user_acct', encryptedCookieDataStr, null, -1, true);
            ApexPages.currentPage().setCookies(new Cookie[]{accountCookie});
            
            accountOverrideId = accountId;
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
            
        }
    }
    
    @TestVisible private void getAccountCookie() {
        try
        {
            Cookie accountCookie = ApexPages.currentPage().getCookies().get('user_acct');
            
            if (Test.isRunningTest()) {
                try {
                    insert new Crypto_Keys__c(name = 'PIMS_Account', Key__c = 'CQg2OVGm6dlH85lFNOX57vsbMtlF3gNVkWUa0geyjKM=');
                }
                catch (Exception e) {
                    // already exists
                }
            }
            
            if (accountCookie == null) {
                
                Crypto_Keys__c cryptoSetting = Crypto_Keys__c.getValues('PIMS_Account');
                Blob cryptoKey = EncodingUtil.base64Decode(cryptoSetting.Key__c);
                
                Blob cookieData = Blob.valueOf(contact.Id + '|' + contact.AccountId);
                Blob encryptedCookieData = Crypto.encryptWithManagedIV('AES256', cryptoKey, cookieData);
                String encryptedCookieDataStr = EncodingUtil.base64Encode(encryptedCookieData);
                
                accountCookie = new Cookie('user_acct', encryptedCookieDataStr, null, -1, true);
                ApexPages.currentPage().setCookies(new Cookie[]{accountCookie});
                
                accountOverrideId = contact.AccountId;
                
                System.debug('Cookie written: ' + encryptedCookieDataStr);
                
            }
            else {
                
                System.debug('Cookie read: ' + accountCookie.getValue());
                
                try {
                    
                    Crypto_Keys__c cryptoSetting = Crypto_Keys__c.getValues('PIMS_Account');
                    Blob cryptoKey = EncodingUtil.base64Decode(cryptoSetting.Key__c);
                    
                    Blob encryptedCookieData = EncodingUtil.base64Decode(accountCookie.getValue());
                    Blob decryptedCookieData = Crypto.decryptWithManagedIV('AES256', cryptoKey, encryptedCookieData);
                    
                    System.debug('Decrypted cookie: ' + decryptedCookieData.toString());
                    
                    String cookieData = decryptedCookieData.toString();
                    List<String> parts = cookieData.split('\\|');
                    
                    // validate the correct user/contact in the cookie
                    if (parts.get(0) != contact.Id) {
                        System.debug('contact id is different');
                        throw new CustomValidationException('Error parsing cookie: contact.id is different');
                    }
                    
                    // validate the user has access to the account
                    Set<Id> validAccounts = new Set<id>();
                    for (IB_Role__c role : roles) {
                        validAccounts.add(role.IB_Account__c);
                    }
                    if (!validAccounts.contains(parts.get(1))) {
                        System.debug('User does not have access to this account.');
                        throw new CustomValidationException('Error parsing cookie: user does not have access to the account');
                    }
                    
                    accountOverrideId = parts.get(1);
                    
                }
                catch (Exception ex) {
                    
                    System.debug('COOKIE READ FAILED!');
                    
                    Crypto_Keys__c cryptoSetting = Crypto_Keys__c.getValues('PIMS_Account');
                    Blob cryptoKey = EncodingUtil.base64Decode(cryptoSetting.Key__c);
                    
                    Blob cookieData = Blob.valueOf(contact.Id + '|' + contact.AccountId);
                    Blob encryptedCookieData = Crypto.encryptWithManagedIV('AES256', cryptoKey, cookieData);
                    String encryptedCookieDataStr = EncodingUtil.base64Encode(encryptedCookieData);
                    
                    accountCookie = new Cookie('user_acct', encryptedCookieDataStr, null, -1, true);
                    ApexPages.currentPage().setCookies(new Cookie[]{accountCookie});
                    
                    accountOverrideId = contact.AccountId;
                    
                    System.debug('Cookie written: ' + encryptedCookieDataStr);
                    
                }
                
            }
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
           
        }
        
    }
    
    public Boolean isMySchoolRole(Id AccountId,Id contactId){
        List<IB_Role__c> roles=[SELECT id
                                FROM IB_Role__c 
                                WHERE IB_Account__c=: AccountId
                                AND IB_Contact__c =: contactId
                                AND status__c='Confirmed' 
                                AND IB_Role_Name__c in ('Programme Coordinator',
                                                        'Head of School', 
                                                        'Head of School (Overall)')];
        if(roles.size()>0){
            return true;
        }
        return false;
    }    
    
}