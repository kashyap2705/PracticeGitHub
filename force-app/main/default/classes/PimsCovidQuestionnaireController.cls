public class PimsCovidQuestionnaireController {
    
    public COVID_19_Questionnaire__c ques {get;set;}
    
    public transient Account account { get; set; }
    
    public List<COVID_19_Questionnaire__c> ques1 = new List<COVID_19_Questionnaire__c>();
    public transient List<COVID_19_Questionnaire__c> ques2 = new List<COVID_19_Questionnaire__c>();
    COVID_19_Questionnaire__c ques3 = new COVID_19_Questionnaire__c();
    public List<IB_Role__c> rolesList {get;set;}
    public User user {get;private set;}
    
    public Boolean gethasMySchoolRole()
    {
        user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId()); 
        IBPortalLandingCtrl portal=new IBPortalLandingCtrl();
        String conId = user.ContactId;
        rolesList = [SELECT Id, IB_Account__c, Role_Type__c, IB_Role_Name__c, Status__c, Account_Name__c, Programme_Selection__c, Programme_Selection_ES__c, Programme_Selection_FR__c, IB_Role__r.Display_in_MyIB__c  
                     FROM IB_Role__c 
                     WHERE IB_Contact__c = :conId 
                     AND IB_Account__c =:account.Id
                     AND (End_Date__c = null OR End_Date__c > TODAY)
                     AND (IB_Role_Name__c = 'Programme Coordinator' OR IB_Role_Name__c = 'Head of School' OR IB_Role_Name__c = 'Head of School (Overall)')
                     AND Status__c = 'Confirmed'];
        System.debug('Size : '+rolesList.size()+' Id is : '+user.ContactId);
        if(rolesList.size()>0)
        {
            return true;
        }
        else
            return false;
    }
    
    @testvisible
    public COVID_19_Questionnaire__c questionnaire {
        get {
            ques2 = [SELECT Id, Name, Account_Name__c, Is_school_closed_due_to_the_COVID_19__c, 
                     Closed_Status_Leadership_administration__c, Closed_Status_Teachers__c, Closed_Status_Students__c,
                     Closed_Date_Leadership_administration__c, Closed_Date_Teachers__c, Closed_Date_Students__c, 
                     Resume_Date_Leadership_administration__c, Resume_Date_Teachers__c, Resume_Date_Students__c,
                     Expected_return_at_diff_times_for_grades__c,Unknown_Comments__c,
                     Current_year_teaching_learning_practice__c,Current_Year_Other_Comments__c,
                     Next_year_teaching_learning_practice__c,Next_Year_Other_Comments__c,
                     LastModifiedById, LastModifiedBy.Name , LastModifiedDate
                     FROM COVID_19_Questionnaire__c
                     WHERE Account_Name__c = :account.Id
                     LIMIT 1];
            if(ques2.size()>0)
            {
                ques3=ques2[0];
            }
            return ques3;
        }
    }
    public PimsCovidQuestionnaireController(){
        PimsCommunityService pimsService = new PimsCommunityService();
        account = pimsService.getCurrentAccount();
        ques = new COVID_19_Questionnaire__c();
        
        
    }
    
    public Boolean gethasQuestionnaire()
    {
        List<COVID_19_Questionnaire__c> lst=new List<COVID_19_Questionnaire__c>();
        lst = [SELECT Id, Name, Account_Name__c, Is_school_closed_due_to_the_COVID_19__c, 
               Closed_Status_Leadership_administration__c, Closed_Status_Teachers__c, Closed_Status_Students__c,
               Closed_Date_Leadership_administration__c, Closed_Date_Teachers__c, Closed_Date_Students__c, 
               Resume_Date_Leadership_administration__c, Resume_Date_Teachers__c, Resume_Date_Students__c,
               Expected_return_at_diff_times_for_grades__c,Unknown_Comments__c,
               Current_year_teaching_learning_practice__c,Current_Year_Other_Comments__c,
               Next_year_teaching_learning_practice__c,Next_Year_Other_Comments__c,
               LastModifiedById, LastModifiedBy.Name , LastModifiedDate
               FROM COVID_19_Questionnaire__c
               WHERE Account_Name__c = :account.Id
               LIMIT 1];
        
        if(lst.size() > 0)
            return true;
        else
            return false;
    }    
    public Boolean gethasAuthorizedProg()
    {
        if(account.Authorized_Programmes__c > 0)
            return true;
        else
            return false;
    }
    
    public String getAccountLangofCorres() {
        PimsCommunityService pimsService = new PimsCommunityService();
        account = pimsService.getCurrentAccount();
        String lang='en_US';
        if(account.Language_Of_Correspondance__c == 'English')
            lang='en_US';
        else if(account.Language_Of_Correspondance__c == 'Spanish')
            lang='es';
        else if(account.Language_Of_Correspondance__c == 'French')
            lang='fr';
        else
            lang='en_US';
        
        System.debug(account.Language_Of_Correspondance__c);
        return lang;
    }
    
    public boolean getPageHasErrors() {
        return ApexPages.hasMessages();
    }
    public PageReference save() {
        try {
            system.debug('account : '+account.Id);
            
            ques1 = [SELECT Id, Name, Account_Name__c, Is_school_closed_due_to_the_COVID_19__c, 
                     Closed_Status_Leadership_administration__c, Closed_Status_Teachers__c, Closed_Status_Students__c,
                     Closed_Date_Leadership_administration__c, Closed_Date_Teachers__c, Closed_Date_Students__c, 
                     Resume_Date_Leadership_administration__c, Resume_Date_Teachers__c, Resume_Date_Students__c,
                     Expected_return_at_diff_times_for_grades__c,Unknown_Comments__c,
                     Current_year_teaching_learning_practice__c,Current_Year_Other_Comments__c,
                     Next_year_teaching_learning_practice__c,Next_Year_Other_Comments__c,
                     LastModifiedById, LastModifiedBy.Name , LastModifiedDate
                     FROM COVID_19_Questionnaire__c
                     WHERE Account_Name__c = :account.Id
                     LIMIT 1];
            system.debug('ques : '+ques);
            if(ques1.size() > 0)
            { 
                system.debug('in if : '+ques);
                
                if(ques.Is_school_closed_due_to_the_COVID_19__c == 'No')
                {
                    ques.Closed_Status_Leadership_administration__c='';
                    ques.Closed_Status_Teachers__c='';
                    ques.Closed_Status_Students__c='';
                    
                    ques.Unknown_Comments__c='';
                    ques.Current_Year_Other_Comments__c='';
                    ques.Next_Year_Other_Comments__c='';
                    
                    ques.Expected_return_at_diff_times_for_grades__c='None';
                    ques.Current_year_teaching_learning_practice__c='None';
                    ques.Next_year_teaching_learning_practice__c='None';
                    
                    ques.Closed_Date_Leadership_administration__c=null;
                    ques.Closed_Date_Teachers__c=null;
                    ques.Closed_Date_Students__c=null;
                    ques.Resume_Date_Leadership_administration__c=null;
                    ques.Resume_Date_Teachers__c=null;
                    ques.Resume_Date_Students__c=null;
                }else
                {
                    if(ques.Closed_Status_Leadership_administration__c=='No')
                        ques.Closed_Date_Leadership_administration__c=null;
                    if(ques.Closed_Status_Teachers__c=='No')
                        ques.Closed_Date_Teachers__c=null;
                    if(ques.Closed_Status_Students__c=='No')
                        ques.Closed_Date_Students__c=null;
                    if(ques.Expected_return_at_diff_times_for_grades__c != 'Yes')
                        ques.Unknown_Comments__c='';
                    if(ques.Current_year_teaching_learning_practice__c != 'Other')
                        ques.Current_Year_Other_Comments__c='';
                    if(ques.Next_year_teaching_learning_practice__c != 'Other')
                        ques.Next_Year_Other_Comments__c='';
                    
                }
                ques.id=ques1[0].id;
                update ques;
            }else
            {
                system.debug('in : '+ques.Is_school_closed_due_to_the_COVID_19__c);
                system.debug('in : '+ques.Closed_Status_Leadership_administration__c);
                system.debug('in : '+ques.Closed_Status_Teachers__c);
                system.debug('in : '+ques.Closed_Status_Students__c);
                if(ques.Is_school_closed_due_to_the_COVID_19__c == null)
                {
                    Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.INFO, Label.COVID_Error_Status));
                }
                else  if(ques.Is_school_closed_due_to_the_COVID_19__c == 'No' || ques.Is_school_closed_due_to_the_COVID_19__c == 'Yes' ) {
                    ques.Account_Name__c=account.id;
                    insert ques;
                }
            }    
            PageReference pgref = Page.PimsCovidQuestionnaireExists; 
            pgref.setRedirect(true);
            return pgref;
            
        }catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }
    
    
    public void isQuesPresent() {
        try
        {
            if (gethasQuestionnaire() == true) {
                
                ques = [SELECT Id, Name, Account_Name__c, Is_school_closed_due_to_the_COVID_19__c, 
                        Closed_Status_Leadership_administration__c, Closed_Status_Teachers__c, Closed_Status_Students__c,
                        Closed_Date_Leadership_administration__c, Closed_Date_Teachers__c, Closed_Date_Students__c, 
                        Resume_Date_Leadership_administration__c, Resume_Date_Teachers__c, Resume_Date_Students__c,
                        Expected_return_at_diff_times_for_grades__c,Unknown_Comments__c,
                        Current_year_teaching_learning_practice__c,Current_Year_Other_Comments__c,
                        Next_year_teaching_learning_practice__c,Next_Year_Other_Comments__c,
                        LastModifiedById, LastModifiedBy.Name , LastModifiedDate
                        FROM COVID_19_Questionnaire__c
                        WHERE Account_Name__c = :account.Id
                        LIMIT 1];
                
            } else {
                ques = new COVID_19_Questionnaire__c();
            }  
        }
        catch(exception e)
        {
            system.debug('exp'+e);
            
        }
    }
}