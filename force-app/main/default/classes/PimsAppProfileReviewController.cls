public class PimsAppProfileReviewController extends PimsApplicationControllerHelper {
    
    @TestVisible String appId;
    @TestVisible String prCompletionStatus;
    
    public String activeTab {get;set;}
    public String redirectUrl {get;set;}
    public Integer roleCnt {get;set;}
    
    public IB_Programme__c programme {get; set;}
    public transient IB_Application__c application {get;set;}
    public Account account {get;set;}
    
    public List<IB_Address__c> addresses {get;set;}
    public List<SchoolSections__c> sections {get;set;}
    public List<SchoolSections__c> acd_sections {get;set;}
   
    public List<SchoolSections__c> currentsections {get;set;}
    
    public List<Contact> contacts {get;set;}
    public List<IB_Role__c> roles {get;set;}
    
    
    public String AcdamicYearString {get;set;}
    public boolean chk {get;set;}
    
    public PimsAppProfileReviewController() {
        
        try
        {
            appId = ApexPages.currentPage().getParameters().get('id');
            
            if (appId == null) {
                throw new CustomValidationException('The application ID is invalid.');
            }
            system.debug('ranjith page : '+getApplicationPageName());
            PageService.setPage(getApplicationPageName());
            activeTab = PageService.getActiveTab();
            system.debug('ranjith tab : '+activeTab);
            if (activeTab == 'profile') {
                
                PimsCommunityService pimsService = new PimsCommunityService();
                pimsService.initUserData();
                
                account = pimsService.getCurrentAccount();
                
                ApplicationService.setApplicationId(appId);
                application = ApplicationService.getApplication();
                
                ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
                programme = ProgrammeService.getProgramme();
                
                AddressService.setAccountId(account.Id);
                addresses = AddressService.getAddressesByAccount();
                
                SchoolSectionsService.setAccountId(account.Id);
                
                sections = SchoolSectionsService.getSectionsByAccount();
                //The Following Code is Added By Shehryar-plumlogix for US-12218 of sprint 21 on 05/29/2021
				// To Show The data Of  Current year
				// start                
    
                currentsections= new List<SchoolSections__c>();
          		CurrentYearData();
          	
                System.debug('Java - Controller Acd_section');
               acd_sections= new List<SchoolSections__c>();
                //AcdemicYear();
                //End
                RoleService.setAccountId(account.Id);
                roles = RoleService.getRolesByAccountId();
                
                ContactService.setAccountId(account.Id);
                contacts = ContactService.getContactsForAccount();
                
                roleCnt = 0;
                Integer pcCntPYP = 0;
                Integer hsCntPYP = 0;
                Integer pcCntMYP = 0;
                Integer hsCntMYP = 0;
                Integer pcCntMYPPartner = 0;
                Integer hsCntMYPPartner = 0;
                Integer pcCntDP = 0;
                Integer hsCntDP = 0;
                Integer pcCntCP = 0;
                Integer hsCntCP = 0;
                for (IB_Role__c ibr : roles) {
                    if (ibr.IB_Role_Name__c == 'Programme Coordinator' && ibr.Programme_Type__c == 'PYP') pcCntPYP++;
                    if (ibr.IB_Role_Name__c == 'Head of School' && ibr.Programme_Type__c == 'PYP') hsCntPYP++;
                    if (ibr.IB_Role_Name__c == 'Programme Coordinator' && ibr.Programme_Type__c == 'MYP') pcCntMYP++;
                    if (ibr.IB_Role_Name__c == 'Head of School' && ibr.Programme_Type__c == 'MYP') hsCntMYP++;
                    
                    if (ibr.IB_Role_Name__c == 'Programme Coordinator' && ibr.Programme_Type__c == 'MYP Partner') pcCntMYPPartner++;
                    if (ibr.IB_Role_Name__c == 'Head of School' && ibr.Programme_Type__c == 'MYP Partner') hsCntMYPPartner++;
                    
                    if (ibr.IB_Role_Name__c == 'Programme Coordinator' && ibr.Programme_Type__c == 'Diploma Programme') pcCntDP++;
                    if (ibr.IB_Role_Name__c == 'Head of School' && ibr.Programme_Type__c == 'Diploma Programme') hsCntDP++;
                    if (ibr.IB_Role_Name__c == 'Programme Coordinator' && ibr.Programme_Type__c == 'CP') pcCntCP++;
                    if (ibr.IB_Role_Name__c == 'Head of School' && ibr.Programme_Type__c == 'CP') hsCntCP++;
                }
                if (getIsPyp() && pcCntPYP >= 1 && hsCntPYP >= 1) roleCnt = pcCntPYP + hsCntPYP;
                if (getIsMyp() && pcCntMYP >= 1 && hsCntMYP >= 1) roleCnt = pcCntMYP + hsCntMYP;
                if (getIsMyp() && pcCntMYPPartner >= 1 && hsCntMYPPartner >= 1) roleCnt = pcCntMYPPartner + hsCntMYPPartner;
                if (getIsDp() && pcCntDP >= 1 && hsCntDP >= 1) roleCnt = pcCntDP + hsCntDP;
                if ((getIsCp() || getIsCpPhase1()) && pcCntCP >= 1 && hsCntCP >= 1) roleCnt = pcCntCP + hsCntCP;
                
                
            }
        }
        Catch(Exception ex)
        {
            System.Debug(ex);
            
        }
    }
    //The Following function is Added By Shehryar-plumlogix for US-12218 of sprint 21 on 05/29/2021
				// To Show The data Of  Current year
				// start                
    
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
        
                   system.debug('Acdamic_year Current Year 1: ' +AcdamicYearString );
     Schema.DescribeFieldResult fieldResult = SchoolSections__c.Academic_Year__c.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
           for(Schema.PicklistEntry p : ple)
           {
               if(p.getValue()>futureYear)
               options.add(new SelectOption(p.getValue(), p.getValue()));
               if(p.getValue()==AcdamicYear )
               {
                   
                   system.debug('Acdamic_year Current Year 2: ' +AcdamicYearString );
                   AcdamicYearString=AcdamicYear;
                   //  acd_sections= new List <SchoolSections__c>();
      
                   AcdemicYear();
               }
           }
           return options;
    }
   public void AcdemicYear()
   {
     System.debug('Java - Faunction Acd_section');
      // if(acd_sections.size() > 0 )
      acd_sections= new List <SchoolSections__c>();
       system.debug('Acdamic_year: ' +AcdamicYearString );
   
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
               				acd_sections.add(sect);
           				}
       			}
            }
            else if(AcdamicYearString=='Historical enrollment data')
            {
                chk=false;
                 for(SchoolSections__c sect: sections)
       			{
           			if(sect.Academic_Year__c=='' || sect.Academic_Year__c== null || sect.Academic_Year__c=='Historical enrollment data')
           				{
               				system.debug('Acdamic_year1123' +AcdamicYearString );
             				//  Acd_sections.add(new SchoolSections__c(sect));
               				acd_sections.add(sect);
           				}
       			}
            }
            system.debug('Acdmaic section ' + Acd_sections.size());
   		}
       catch(exception e)
        {
            system.debug('exp'+e);
            system.debug('exception###'+e.getStackTraceString());
            system.debug('line###'+e.getLineNumber());
        }
       
   }
    
    
    public void CurrentYearData()
    {
        integer year =  Date.Today().Year();
		   string s1 =string.valueOf(year);
            year++;
           string s2=string.valueof(year).right(2);
          String AcdamicYearString=s1 + '-' + s2;
        system.debug('Acdamic_year1123' +AcdamicYearString );
        for(SchoolSections__c sec: sections)
        {
            if(sec.Academic_Year__c==AcdamicYearString)
            {
                system.debug('Acdamic_year112' +AcdamicYearString );
                currentsections.add(sec);
            }
        }
        
            system.debug('Acdmaic section ' + currentsections.size());
    }

    //End
    public PageReference save() {
        try {
            
            roleCnt = 0;
            
            Integer pcCntMYPPartner = 0;
            Integer hsCntMYPPartner = 0;
            
            Integer pcCntPYP = 0;
            Integer hsCntPYP = 0;
            Integer pcCntMYP = 0;
            Integer hsCntMYP = 0;
            Integer pcCntDP = 0;
            Integer hsCntDP = 0;
            Integer pcCntCP = 0;
            Integer hsCntCP = 0;
            
            if(roles.size()>0){
                for (IB_Role__c ibr : roles) {
                    if (ibr.IB_Role_Name__c == 'Programme Coordinator' && ibr.Programme_Type__c == 'PYP') pcCntPYP++;
                    if (ibr.IB_Role_Name__c == 'Head of School' && ibr.Programme_Type__c == 'PYP') hsCntPYP++;
                    if (ibr.IB_Role_Name__c == 'Programme Coordinator' && ibr.Programme_Type__c == 'MYP') pcCntMYP++;
                    if (ibr.IB_Role_Name__c == 'Head of School' && ibr.Programme_Type__c == 'MYP') hsCntMYP++;
                    if (ibr.IB_Role_Name__c == 'Programme Coordinator' && ibr.Programme_Type__c == 'Diploma Programme') pcCntDP++;
                    if (ibr.IB_Role_Name__c == 'Head of School' && ibr.Programme_Type__c == 'Diploma Programme') hsCntDP++;
                    if (ibr.IB_Role_Name__c == 'Programme Coordinator' && ibr.Programme_Type__c == 'CP') pcCntCP++;
                    if (ibr.IB_Role_Name__c == 'Head of School' && ibr.Programme_Type__c == 'CP') hsCntCP++;
                    
                    if (ibr.IB_Role_Name__c == 'Programme Coordinator' && ibr.Programme_Type__c == 'MYP Partner') pcCntMYPPartner++;
                    if (ibr.IB_Role_Name__c == 'Head of School' && ibr.Programme_Type__c == 'MYP Partner') hsCntMYPPartner++;
                    
                }
            }
            
            if (getIsPyp() && pcCntPYP >= 1 && hsCntPYP >= 1) roleCnt = pcCntPYP + hsCntPYP;
            if (getIsMyp() && pcCntMYP >= 1 && hsCntMYP >= 1) roleCnt = pcCntMYP + hsCntMYP;
            if (getIsDp() && pcCntDP >= 1 && hsCntDP >= 1) roleCnt = pcCntDP + hsCntDP;
            if ((getIsCp() || getIsCpPhase1()) && pcCntCP >= 1 && hsCntCP >= 1) roleCnt = pcCntCP + hsCntCP;
            if (getIsMyp() && pcCntMYPPartner >= 1 && hsCntMYPPartner >= 1) roleCnt = pcCntMYPPartner + hsCntMYPPartner;
            
            if (roleCnt >= 2) {
                prCompletionStatus = 'Complete';
            }
            else {
                prCompletionStatus = 'In Progress';
            }
            system.debug('prCompletionStatus =====> '+prCompletionStatus);
            
            
            IB_Application__c tmpApp = [select AFC_Profile_Review_Status__c from IB_Application__c where Id = :AppId];
            tmpApp.AFC_Profile_Review_Status__c = prCompletionStatus;
            update tmpApp;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Profile_Review));
            redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + AppId + '&tab=desc';
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }
}