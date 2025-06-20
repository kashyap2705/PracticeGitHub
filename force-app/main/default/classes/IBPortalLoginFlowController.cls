public without sharing class IBPortalLoginFlowController {
    // 
    private IBPortalSettingsUtil util;
    public User user {get;private set;}
    public Contact con {get;private set;} 
    public String birthDateString {get; set;}
    private final Contact contactObject;
    public Boolean isIben {get;set;}

    public IBPortalLoginFlowController(){
        util = IBPortalSettingsUtil.getInstance();
        user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
        isIben = false;
        ContactService.setContactId(user.ContactId);
        try {
            con = ContactService.getContact();
        } catch (Exception e){
            con = new Contact();
        }
           
        if (null == user.ContactId ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING , Label.IBENPortal_Error_ContactNotFound));
        } else {
            this.contactObject = MyContactDAO.INSTANCE.getContactbyId(user.ContactId);  
        }

    }

    public Contact getContactObject() {
        return this.contactObject;
    }

    public PageReference saveProfile() {
        try{
            System.debug(birthdatestring);
            if (birthDateString != null && birthDateString != '') {
                birthDateString = birthDateString.removeEnd('.000Z');
                birthDateString = birthDateString.replace('T', ' ');
                contactObject.Birthdate = Date.valueOf(Datetime.valueOfGMT(birthDateString));
                contactObject.Birthdate = Date.newInstance(contactObject.Birthdate.year(), contactObject.Birthdate.month(), contactObject.Birthdate.day());
            }

            update this.contactObject;
            PageReference pg = new PageReference('/ibportal');
            return pg;
        }catch(Exception e){

            return null;  
        }
    }

    public String getLocale() {
        LocaleSwitcherExtension lse = new LocaleSwitcherExtension();
        return lse.getLocale();
    }
}