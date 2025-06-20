public without sharing class ExperienceExtController {
     
     public IB_E_Background__c background {
        get; set;
        
     }

    public String getUserLanguageKey() {
      return UserInfo.getLanguage();
    }

    public String getLocale(){
      return UserInfo.getLocale();
    }

    public DateUtility dateUtil {
        get{
            DateUtility util = new DateUtility();
            return util;
        }
    }
     
     Private User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
     Private Contact contactObject = MyContactDAO.INSTANCE.getContactbyId(user.ContactId);   

     public String getPhoto(){
          /*List<Attachment> attach = AttachmentsDAO.INSTANCE.getAttachmentsbyParentId(contactObject.Id);
          for(Attachment a: attach){
              if(a.description == 'profile photo'){
                  return System.EncodingUtil.base64Encode(a.body);
              }
          }*/
          return AttachmentsDAO.getProfilePhoto(contactObject.Id);
     }
      
     public ExperienceExtController (ApexPages.StandardController stdController) {
        
       final List<String> allFields = new List<String> {'Spoken_Proficiency__c','Written_Proficiency__c','Preferred_Language__c',
                                                         'Language_Delivery__c', 'Language__c', 'Country__c', 'City__c', 'IB_School__c',
                                                         'IB_Role__c', 'Programme__c', 'Start_Date__c', 'End_Date__c', 'General_Subject__c',
                                                         'IB_Official_Language__c', 'Additional_Comments__c',
                                                         'IB_Role__c', 'IB_Programme__c', 'Start_Date__c', 'End_Date__c',
                                                         'IB_School__c','Programme__c', 'General_Subject__c', 'IB_Official_Language__c'  };
        
       if (!Test.isRunningTest()) {stdController.addFields(allFields);}
        
       background = (IB_E_Background__c) stdController.getRecord();
       background.RecordTypeId = ApexPages.currentPage().getParameters().get('RecordType'); 
        
     }
     
        
     public PageReference save() {
       
        try {
          if(Test.isRunningTest()){
            String npeURL = ApexPages.currentPage().getParameters().get('npeURL');
            System.debug('npe url===='+npeURL);
            if(String.isNotBlank(npeURL)){
              throw new NullPointerException();
            }
          }  
          upsert background;
          
          final String retURL = ApexPages.currentPage().getParameters().get('retURL');
          
          if (!String.isEmpty(retURL)) {
             return new PageReference(retURL);
          }
          
          
          return null;
          
       } catch (System.DmlException e) {
          for (Integer i = 0; i < e.getNumDml(); i++) {
              ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getDmlMessage(i))); 

          }
          return null;
                 
      }  catch (Exception ex) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
      return null;     
      }  
               
     } 
     
}