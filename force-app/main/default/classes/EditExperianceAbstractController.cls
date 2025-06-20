public abstract without sharing class EditExperianceAbstractController {
    
    protected String iBEBackgroundRecordTypeId;
    protected Contact contactObject;
    protected List<IB_E_Background__c> expiriances = new List<IB_E_Background__c>();

    public EditExperianceAbstractController(String iBEBackgroundRecordTypeName) {
        
        User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
        
        if (null == user.ContactId ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING , Label.IBENPortal_Error_ContactNotFound));
            
        } else {
            
            this.contactObject = MyContactDAO.INSTANCE.getContactbyId(user.ContactId);
            this.iBEBackgroundRecordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType(iBEBackgroundRecordTypeName, 'IB_E_Background__c').Id;    
            this.expiriances = IBEBackgroundDAO.INSTANCE.getIBEBackgroundsForContactAndRecordType(iBEBackgroundRecordTypeId , user.ContactId);
        } 
        

    }
     
    public Contact getContactObject () {
         
        return contactObject;
         
    }
    
    public List<IB_E_Background__c> getIBExperienceList() {
          return expiriances;
    }
    
    public PageReference cancel() {
        Pagereference newPage =  Page.myProfile;
        newPage.setRedirect(true);
        return newPage;
    }
    
    
    
    
}