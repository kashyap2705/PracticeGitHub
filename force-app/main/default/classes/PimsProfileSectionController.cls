public class PimsProfileSectionController implements PimsProfilePanelInterface {

    public Account account { get; set; }

    public SchoolSections__c addSection { get; set; }
    public SchoolSections__c editSection { get; set; }
    public List<SchoolSections__c> sections { get; set; }
    public List<SchoolSections__c> Acd_sections {get;set;}
    
    
  //  public SchoolSections__c section1 { get; set; }
    public Id deleteSectionId { get; set; }
	public List<IB_Programme__c> programmes { get; set; }

	public boolean hasPypProgramme { get; set; }
	public boolean hasMypProgramme { get; set; }
	public boolean hasDpProgramme { get; set; }
	public boolean hasCpProgramme { get; set; }
	public boolean isAuthorized { get; set; }
	
	public string pypProgrammeMgrName { get; set; }
	public string mypProgrammeMgrName { get; set; }
	public string dpProgrammeMgrName { get; set; }
	public string cpProgrammeMgrName { get; set; }
	public string pypProgrammeMgrEmail { get; set; }
	public string mypProgrammeMgrEmail { get; set; }
	public string dpProgrammeMgrEmail { get; set; }
	public string cpProgrammeMgrEmail { get; set; }

    public String activeTab { get; set; }
    public Boolean isUpdatePage { get; set; }
    public String redirectUrl { get; set; }
    //shehryar
    //
    // public String acdemic_year {get;set; }
        
    public boolean update_chk {get;set;}
    //public String sessionValue;
   // public boolean chk {get;set;}
   // public Integer currentYear {get;set;}
   // public String projected_value {get;set;}
    public String AcdamicYearString {get;set;}
   // public String AcdamicYearString1 {get;set;} 
    
    public boolean addSec_chk {get;set;}
   // public boolean cache_value {get;set;}
   // public String projectedString {get;set;} 
    
    private ProfileService profileService = new ProfileService();
    public PimsProfileSectionController() {
        
		        
       
		hasPypProgramme = false;
		hasMypProgramme = false;
		hasDpProgramme = false;
		hasCpProgramme = false;
		isAuthorized = false;
        
        addSec_chk=true;
       // chk=false;
        update_chk=true;
		list<id> progIds = new list<id>();
		List<IB_Application__c> listApps = new List<IB_Application__c>();
        
        PimsCommunityService pimsService = new PimsCommunityService();


        account = pimsService.getCurrentAccount();
        profileService.account = account;

        ProgrammeService.setAccountId(account.Id);
        programmes = ProgrammeService.getProgrammesByAccount();
		

        SchoolSectionsService.setAccountId(account.Id);
        sections = SchoolSectionsService.getSectionsByAccount();

        Acd_sections= new List<SchoolSections__c>();
        
       
        
        addSection = new SchoolSections__c(Account__c = account.Id);
		system.debug('programmes: ' + programmes);
		/* Written as part of CR966 - display IBWS Manager if the user's account is (a) an Authorized School & (b) the School Rel Mgr field is filled out and PRM if AFC of any interested programme is in Submitted status */
		for (IB_Programme__c prog : programmes) {
			if(prog.Status__c.equalsIgnoreCase('Interested')){
				progIds.add(prog.id);
			}
		}
		ApplicationService.setProgrammeIdList(progIds);
		listApps = ApplicationService.getApplicationsByProgrammeIds();

        for (IB_Programme__c p : programmes) {
			Boolean isContinue = false;
            if(!(p.Status__c.contains('Terminated') || p.Status__c.contains('Withdrawn') || p.Status__c.contains('Denied') ||
					p.Status__c.equalsIgnoreCase('Previously Interested') || p.Status__c.contains('Authorized'))){
				if(p.Status__c.equalsIgnoreCase('Interested')){
					for(IB_Application__c app : listApps){
						if(app.Application_Lookup_to_Programme__c == p.id && app.RecordType.Name == 'Application for Candidacy' && app.Status__c == 'Submitted'){
							isContinue = true;
						}
					}
				}
				else{
					isContinue = true;
				}
				if(isContinue){
					if(p.RecordType.DeveloperName.Contains('PYP')){
						hasPypProgramme = true;
						pypProgrammeMgrName = p.Programme_Relationship_Manager_Name__c;
						pypProgrammeMgrEmail = p.Programme_Relationship_Manager_Email__c;
					}
					if(p.RecordType.DeveloperName.Contains('MYP')){
						hasMypProgramme = true;
						mypProgrammeMgrName = p.Programme_Relationship_Manager_Name__c;
						mypProgrammeMgrEmail = p.Programme_Relationship_Manager_Email__c;
					}
					if(p.RecordType.DeveloperName.Contains('Diploma_Programme')){
						hasDpProgramme = true;
						dpProgrammeMgrName = p.Programme_Relationship_Manager_Name__c;
						dpProgrammeMgrEmail = p.Programme_Relationship_Manager_Email__c;
					}
					if(p.RecordType.DeveloperName.Contains('IBCC')){
						hasCpProgramme = true;
						cpProgrammeMgrName = p.Programme_Relationship_Manager_Name__c;
						cpProgrammeMgrEmail = p.Programme_Relationship_Manager_Email__c;
					}
				}
			}
			else if(p.Status__c.equalsIgnoreCase('Authorized')){
				isAuthorized = true;
			}
        }
		system.debug('hasPypProgramme: ' + hasPypProgramme);
		system.debug('hasMypProgramme: ' + hasMypProgramme);
		system.debug('hasDpProgramme: ' + hasDpProgramme);
		system.debug('hasCpProgramme: ' + hasCpProgramme);
    }
    
    
     //The Following Code is Added By Shehryar-plumlogix for US-12218 of sprint 21 on 05/29/2021
				// 
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
       system.debug('Acdamic_year: ' +AcdamicYearString );
 
       
       try
        {
            if(AcdamicYearString!='Historical enrollment data')
            {
                addSec_chk=true;
               // chk=true;
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
                addSec_chk=false;
                //chk=false;
                 for(SchoolSections__c sect: sections)
       			{
           			if(sect.Academic_Year__c=='' || sect.Academic_Year__c== null || sect.Academic_Year__c=='Historical enrollment data')
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
        //End
    public PageReference save() {

        try {
            
            if (!profileService.validateSections(account.Id)) {
                throw new CustomValidationException(Label.System_Error_No_Section);
            }

            update account;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Section_saved));

            if (!isUpdatePage) {
                redirectUrl = '/pims/PimsProfileNew?tab=contact';
            }
            
        }
        catch (Exception ex) {

            ApexPages.addMessages(ex);

        }

        return null;

    }

    public PageReference create() {

        //The Following Code is Added By Shehryar-plumlogix for US-12218 of sprint 21 on 05/29/2021
				
				// start                
        try {
              
          // AcdamicYearString = (String)Cache.Session.get('data');
           system.debug('acdmaicYear value: ' + AcdamicYearString+ ' ?');
			if( AcdamicYearString !='' && AcdamicYearString != null)
            {
            	addSection.Academic_Year__c=AcdamicYearString;
                
            insert addSection;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Section_added));
            }
            else
            {
                
           system.debug('acdmaicYear value: ' + AcdamicYearString+ ' ?');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Section not added'));
            }
            
			//End

        }
        catch (Exception ex) {

            ApexPages.addMessages(ex);

        }

        return null;

    }
    
   

    public PageReference edit() {

        //The Following Code is Added By Shehryar-plumlogix for US-12218 of sprint 21 on 05/29/2021
				
				// start                
        try {
            update_chk=false;
                        update editSection;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Section_updated));

        }
        catch (Exception ex) {

            update_chk=true;
            ApexPages.addMessages(ex);

        }

        return null;

    }

    public PageReference remove() {

        PageReference pageRef = ApexPages.currentPage();

        try {

            SchoolSections__c sectionToDelete = new SchoolSections__c();
            sectionToDelete.Id = deleteSectionId;
            delete sectionToDelete;

            activeTab = 'section';
            if (isUpdatePage) {
                pageRef = new PageReference('/pims/PimsProfile');
            }
            else {
                pageRef = new PageReference('/pims/PimsProfileNew');
            }
            pageRef.setRedirect(true);

        }
        catch (DmlException ex) {

            ApexPages.addMessages(ex);
            activeTab = 'section';
            pageRef.setRedirect(false);
            
        }

        pageRef.getParameters().put('tab', activeTab);

        return pageRef;

    }


    public String getUserLanguageKey() {
       return UserInfo.getLanguage();
    }

}