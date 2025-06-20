public abstract with sharing class ExperianceViewAbstractController {

    private String contactId;
    private String iBEBackgroundRecordTypeId;
    private Integer currentPage = 0;
        
    public ExperianceViewAbstractController (String iBEBackgroundRecordTypeName) {
        
        maxperPage = 5;
        
        try {
            User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
        
            if (null == user.ContactId ) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING , Label.IBENPortal_Error_ContactNotFound));
                
            } else {
                this.contactId = user.ContactId;    
            }
             
            this.iBEBackgroundRecordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType(iBEBackgroundRecordTypeName, 'IB_E_Background__c').Id;    
            
        } catch (Exception exc) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, exc.getMessage());
            ApexPages.addMessage(msg);
            
        } 
        
          
    }
    
     public Integer maxperPage {
        get; set;
        
    }
    
    public void changeDisplaySize() {
       first();             
    }
    
    public void doSearch() {
        first();
        total_size = null;
    }
    
   
    public Integer getCurrentPage() {
        return currentPage + 1;
    }
    
    private integer total_size {
        get {
            if (null == total_size || 0 == total_size) {
                total_size = IBEBackgroundDAO.INSTANCE.getCountofIBBackgroundsForContactAndRecordType(this.iBEBackgroundRecordTypeId, this.contactId);
            }
            return total_size;
        }
        set;
    }
    
    
    public Integer getTotal_size() {
         return total_size;
    }
        
    public List<IB_E_Background__c> tableRecordList {
        get {
            if ( null== tableRecordList ) {
                tableRecordList = getRecords(); 
            }
            return tableRecordList;

        }
        private set;
    }
    
    private List<IB_E_Background__c> getRecords() {

        List<IB_E_Background__c> result = new List <IB_E_Background__c>();
             
         try {
            
             Integer offset = pageNumberParam * maxperPage;
             result  = IBEBackgroundDAO.INSTANCE.getIBBackgroundsForContactAndRecordType(this.iBEBackgroundRecordTypeId, this.contactId, maxperPage , offset);
             
          } catch(Exception ex) {
                ApexPages.addMessages(ex);
                
          }
            
          return result;
    }      
    
    public List<SelectOption> getCounts() {
    
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('5', '5'));
        options.add(new SelectOption('10', '10'));
        options.add(new SelectOption('25', '25'));
        options.add(new SelectOption('50', '50'));
        options.add(new SelectOption('100', '100'));
        options.add(new SelectOption('200', '200'));
               
        return options;
    }
    
    
    public Integer pageNumberParam {
         
        get {
            
            system.debug('currentPage' + currentPage);
            
            Integer numberPage = currentPage;
                 
            if (numberPage < 0 || getTotalPages() == 0) {
                    
                return 0;
                    
            } else {
                //check if requested page more than total existing pages
                return (numberPage > getTotalPages()-1) ? getTotalPages()-1 : numberPage;
            }
             
        }
        
        private set;
         
    }
    
   public Integer getTotalPages() {
   
      if (math.mod(total_size, maxperPage) > 0) {
         return total_size/maxperPage + 1;
         
      } else {
        
         return (total_size/maxperPage);
      }
   }
   
   public void Previous() { //user clicked previous button
      currentPage  = pageNumberParam -1;
      tableRecordList = getRecords();
   }
 
   public void Next() { //user clicked next button
      currentPage  = pageNumberParam + 1;
      tableRecordList = getRecords();
   }
 
   public void first() {
      currentPage  = 0;
      tableRecordList = getRecords();
   }
 
   public void last() { 
      currentPage  = getTotalPages()-1;
      tableRecordList = getRecords();
   }
 
   public Boolean getDisablePrevious() {
      if (pageNumberParam > 0) {
         return false;
      } else  { 
        return true;
      } 
   }
 
   public Boolean getDisableNext() { 
       if (pageNumberParam < getTotalPages() - 1 ) { 
          return false;
           
       } else {
          return true;
           
       }      
   }
   public String pageUrl {
         set;
         get;     
   }
   
   public String recordId {
         set;
         get;     
   }
   
   
}