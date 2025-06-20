/**
* <h1> PimsProfileSectionAddController </h1>
* This class is created to test the functionality of PimsProfile Add Section Page Controller
* 
* @author  Shehryar - Plumlogix
* @version 1.0
* @since   2021-05-20 

Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description                     Version                          

* ------------------------------------------------------------------------------------------------- 
  Shehryar                    2021-05-20             Created the Controller            1.0

*/
public class PimsProfileSectionAddController {
  public String activeTab { get; set; }
    public String subNav { get; set; }

    
    public SchoolSections__c addSection { get; set; }
    public List<SchoolSections__c> sections { get; set; }
    public List<SchoolSections__c> Acd_sections {get;set;}
     public Boolean showSchoolRMLink { get; set; }
    
    
    public Account account { get; set; }


    private ProfileService profileService = new ProfileService();
    public List<IB_Programme__c> programmes { get; set; }
    public Boolean hasPypProgramme { get; set; }
    public Boolean hasMypProgramme { get; set; }
    public Boolean hasDpProgramme { get; set; }
    public Boolean hasIbccProgramme { get; set; }
    public Boolean hasAgreementProgramme{ get; set; }// Added as part of 635-phase 2



    
    public Contact userContact {get; set;}  
    public Boolean showPageDetails {get; set;}
   
    public String sessionValue;
    public boolean chk {get;set;}
    public String AcdamicYearString {get;set;}
    
    public PimsProfileSectionAddController(){
        showSchoolRMLink = false;
         PimsCommunityService pimsService = new PimsCommunityService();
        pimsService.initUserData();
        AcdamicYearString = ApexPages.currentPage().getParameters().get('year');
        account = pimsService.getCurrentAccount();
          userContact = pimsService.getCurrentContact();
        
        showPageDetails = pimsService.isMySchoolRole(account.Id,userContact.Id);
            ProgrammeService.setAccountId(account.Id);
        programmes = ProgrammeService.getProgrammesByAccount();


        
        //programmes = profileService.getProgrammes();
        hasPypProgramme = profileService.hasProgramme(programmes, 'PYP');
        hasMypProgramme = profileService.hasProgramme(programmes, 'MYP');
        hasDpProgramme = profileService.hasProgramme(programmes, 'Diploma_Programme');
        hasIbccProgramme = profileService.hasProgramme(programmes, 'IBCC');
        hasAgreementProgramme = profileService.hasProgramme(programmes, 'Agreement'); //Added as part of 635-phase 2



        //if(account.Authorized_School__c && account.School_Relationship_Manager__c != null){        //commented by Shahrukh and added new line below for ECM00420 - Sprint 23-3
        if(account.Authorized_School__c){
            showSchoolRMLink = true;
        }
        else{
            list<id> progIds = new list<id>();
            List<IB_Application__c> listApps = new List<IB_Application__c>();
            for (IB_Programme__c prog : programmes) {
                if(prog.Status__c.equalsIgnoreCase('Interested') || prog.Status__c.equalsIgnoreCase('Candidate')){
                    progIds.add(prog.id);
                }
            }

            ApplicationService.setProgrammeIdList(progIds);
            listApps = ApplicationService.getApplicationsByProgrammeIds();
            for(IB_Application__c app : listApps){
                if(app.RecordType.Name == 'Application for Candidacy' && app.Status__c == 'Submitted'){
                    showSchoolRMLink = true;
                }
            }
        }
        subNav = ApexPages.currentPage().getParameters().get('nav');
        
        if (subNav == null) {
            subNav = 'info';
        }
         SchoolSectionsService.setAccountId(account.Id);
        sections = SchoolSectionsService.getSectionsByAccount();

        Acd_sections= new List<SchoolSections__c>();
        
       // call();
        
        addSection = new SchoolSections__c(Account__c = account.Id);
        system.debug('programmes: ' + programmes);

    }
      public void init() {
        
        
        PageService.setPage('PimsProfile');
        activeTab = PageService.getActiveTab();
        
        if (activeTab == null) activeTab = 'contact';
        
    }
   
    Public void selectcon() {
string selectconid = System.currentPagereference().getParameters().get('conid');
//debugging the value 
system.debug('selected id:::::::::::::::::::::::'+selectconid);
}
    
    
   // Public static string ShowAdamicValue{get;set;}
    
    public List<SelectOption> getAcdemicYearList(){
        integer year =  Date.Today().Year();
        //year=year+7;   
        string s1 =string.valueOf(year);
            year++;
           string s2=string.valueof(year).right(2);
           String AcdamicYear=s1 + '-' + s2;
           year=year-6;
        s1 =string.valueOf(year);
        year++;
        s2=string.valueof(year).right(2);
        String futureYear=s1 + '-' + s2;
        List<SelectOption> options = new List<SelectOption>();
     Schema.DescribeFieldResult fieldResult = SchoolSections__c.Academic_Year__c.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
           for(Schema.PicklistEntry p : ple)
           {
               if(p.getValue()>futureYear)
               options.add(new SelectOption(p.getValue(), p.getValue()));
               if(p.getValue()==AcdamicYear)
               {
                   
                   AcdamicYearString=AcdamicYear;
                   AcdemicYear();
               }
           }
           return options;
    }
   public void AcdemicYear()
   {
   
       acd_sections= new List <SchoolSections__c>();
      
       
       try
        {
            if(AcdamicYearString!='Historical enrollment data')
            {
                chk=true;
                for(SchoolSections__c sect: sections)
                {
                    if(sect.Academic_Year__c==AcdamicYearString)
                        {
                        
                            system.debug('Acdamic_year1123' +AcdamicYearString );
                            //  Acd_sections.add(new SchoolSections__c(sect));
                            Acd_sections.add(sect);
                        }
                }
            }
            else if(AcdamicYearString=='Historical enrollment data')
            {
                chk=false;
                 for(SchoolSections__c sect: sections)
                {
                    if(sect.Academic_Year__c=='' || sect.Academic_Year__c== null)
                        {
                            system.debug('Acdamic_year1123' +AcdamicYearString );
                            //  Acd_sections.add(new SchoolSections__c(sect));
                            Acd_sections.add(sect);
                        }
                }
            }
            system.debug('Acdmaic section ' + Acd_sections.size());
        }
       catch(exception e)
        {
            system.debug('exp'+e);
        }
       
   }
   public PageReference create() {

        try {
            
    
         //  AcdamicYearString = (String)Cache.Session.get('data');
           system.debug('acdmaicYear value: ' + AcdamicYearString+ ' ?');
            if( AcdamicYearString !='' && AcdamicYearString != null)
            {
                addSection.Academic_Year__c=AcdamicYearString;
                
                
           system.debug('acdmaicYear value: ' + AcdamicYearString+ ' ?');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Section added' ));
            insert addSection;


                 
                if (hasPypProgramme || hasMypProgramme || hasDpProgramme || hasIbccProgramme || hasAgreementProgramme) {//Added hasAgreementProgramme as part of 635-phase 2
            PageReference pageref = new PageReference('/pims/PimsProfile');
                pageref.setRedirect(true);
                return pageref;
        }
        else {
            PageReference pageref = new PageReference('/pims/PimsProfileNew');
                pageref.setRedirect(true);
                return pageref;
        }


               
            }
            else
            {
                
           system.debug('acdmaicYear value: ' + AcdamicYearString+ ' ?');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Section not added' ));
            }


        }
        catch (Exception ex) {

            ApexPages.addMessages(ex);

        }

        return null;

    }
    public PageReference close() {


                 if (hasPypProgramme || hasMypProgramme || hasDpProgramme || hasIbccProgramme || hasAgreementProgramme) {//Added hasAgreementProgramme as part of 635-phase 2
            PageReference pageref = new PageReference('/pims/PimsProfile');
                pageref.setRedirect(true);
                return pageref;
        }
        else {
            PageReference pageref = new PageReference('/pims/PimsProfileNew');
                pageref.setRedirect(true);
                return pageref;
    }


    }
}