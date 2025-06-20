public class PimsAppSectionAController extends PimsApplicationControllerHelper {

    private String appId;
    public String activeTab { get; set; }
    public String redirectUrl {get; set;}
    
    public String saCompletionStatus {get; set;}

    public String SelectedContacts {get; set;}
    public String currentContacts {get; set;}
    public String[] contacts = new String[]{};

    public String description {get;set;}
    public String fileName {get;set;}
    public Blob fileBody {get;set;}
	Public String strTemp1 {get;set;}
	Public String strTemp2 {get;set;}
	Public String strTemp3 {get;set;}
	Public String strTemp4 {get;set;}
    Public String strTemp5 {get;set;}	
    public IB_Application__c application {get; set;}
    public IB_Application_Assessment__c assessment { get; set; }
    //public IB_Application_Implementation__c applicationImplementation { get; set; }
    @testVisible private IB_Programme__c programme;
    public Boolean checkYear {get;set;}
    public Boolean alert = false;
    public Boolean antialert {get;set;}
    public Integer checkYear1 = 0;
    public Integer checkYear2 = 0;
    public Integer checkYear3 = 0;
    public Integer checkYear4 = 0;
    public Integer checkYear5 = 0;
    public Integer totalYear = 0;

    public Integer totalYearTemp{get;set;}

 
    public PimsAppSectionAController() {

        try
        {
         totalYearTemp = 0;   
        appId = ApexPages.currentPage().getParameters().get('id');

        if (appId == null) {
            throw new CustomValidationException('The application ID is invalid.');
        }

        PageService.setPage(getApplicationPageName());
        activeTab = PageService.getActiveTab();
        if (activeTab == 'sectiona') {

            ApplicationService.setApplicationId(appId);
            application = ApplicationService.getApplication();
            assessment = ApplicationService.getApplicationAssessment();
            //applicationImplementation = ApplicationService.getApplicationImplementation();

            ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
            programme = ProgrammeService.getProgramme();
            antialert = programme.Name.contains('MYP');

            if(antialert == true)checkInputStatus();

            
        }
            
        }
        catch(exception x)
        {
            System.debug('excp'+x);
        }
		
    }
    //This code is added by Umair-Plumlogix of Staff Augmentation Project of US11572 on 8/20/2020
    //Start
    public void checkInputStatus()
    {
        strTemp1= application.A9_a_2_MYP_Year__c;
            strTemp2= application.A9_a_2_MYP_Year_2__c;
            strTemp3= application.A9_a_2_MYP_Year_3__c;
            strTemp4= application.A9_a_2_MYP_Year_4__c;
            strTemp5= application.A9_a_2_MYP_Year_5__c;
            if(strTemp1 == null) totalYear++;
            
            if(strTemp2 == null) totalYear++;
            
            if(strTemp3 == null) totalYear++;
            
            if(strTemp4 == null) totalYear++;
            
            if(strTemp5 == null) totalYear++;

   			totalYearTemp = totalYear;

            if(totalYear < 4)
            {
                checkYear = false;
                totalYear = 0;
            }
            else
            {
                checkYear = true;
                totalYear = 0;
            }
    }
    //End

    public List<SelectOption> getItems() {

        if (activeTab != 'sectiona') {
           return null;
        }

        try {
            currentContacts = application.AC_3_1_Feasability_Leads__c;
            String[] currContactsList = new String[]{};
                if (currentContacts != null && currentContacts != '') currContactsList = currentContacts.split(',');

            List<SelectOption> options = new List<SelectOption>();
            for (Contact c: [SELECT Id, Name, Title, Job_Title__c FROM Contact WHERE AccountId = :programme.Account__c]){
                if (c.Job_Title__c != null) options.add(new selectOption(c.Id, c.Name +' - ('+c.Job_Title__c+')', false));  //Show current Job title
                if (c.Job_Title__c == null) options.add(new selectOption(c.Id, c.Name +' - (No Job Title)', false));  //Indicate Job title is missing
            }

            //system.debug('options =====> '+options);
            return options;
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Contact_List +ex));
            return null;
        }
        
        // This Part is being Commented by Developer Ahmad Shakeel-PlumLogix on 10/14/2019, Unreachable Statement
		//begin 
        	//return null;
        //End

    }

    public String[] getContacts() {
        return contacts;
    }

    public void setContacts(String[] contacts) {
        this.contacts = contacts;
    }

    public String getSelectedContacts() {
        return SelectedContacts;
    }

    public void setSelectedContacts(String selContacts) {
        this.SelectedContacts = selContacts;
    }
			
    
    public PageReference save() {

        system.debug('SelectedContacts =====> '+SelectedContacts);
        system.debug('saCompletionStatus =====> '+saCompletionStatus);
        system.debug('getIsAFA'+getIsAfa());
        system.debug('getApplicationPageName'+getApplicationPageName());
        	
        try {
            application.AC_3_1_Feasability_Leads__c = SelectedContacts;
            application.AFC_Philosophy_Status__c = saCompletionStatus;
         //This code is added by Umair-Plumlogix of Staff Augmentation Project of US11572 on 8/20/2020
         //Start   
           strTemp1= application.A9_a_2_MYP_Year__c;
            strTemp2= application.A9_a_2_MYP_Year_2__c;
            strTemp3= application.A9_a_2_MYP_Year_3__c;
            strTemp4= application.A9_a_2_MYP_Year_4__c;
            strTemp5= application.A9_a_2_MYP_Year_5__c;
            if(strTemp1 == null)
            {
               checkYear1 =0;
            }
            else
            {
                checkYear1 =integer.valueof(strTemp1);
            }
           
            if(strTemp2 == null)
            {
               checkYear2 = 0;
            }
            else
            {
                checkYear2 =integer.valueof(strTemp2);
            }
            
            if(strTemp3 == null)
            {
               checkYear3 = 0;
            }
            else
            {
               checkYear3 =integer.valueof(strTemp3);
            }
            
            if(strTemp4 == null)
            {
               checkYear4 =0;
            }
            else
            {
                checkYear4 =integer.valueof(strTemp4);
            }
            if(strTemp5 == null)
            {
               // strTemp5=strTemp4;
               checkYear5 =0;
            }
            else
            {
                checkYear5 =integer.valueof(strTemp5);
            }

            
            if(checkYear1 != 0 && checkYear2 != 0 && checkYear3 != 0 && checkYear4 != 0 && checkYear5 != 0)
            {
                if((checkYear1 <= checkYear2  && checkYear2 <= checkYear3 && checkYear3 <= checkYear4 && checkYear4 <= checkYear5)
                   )
                alert=true;
            }//5 end
            
           else if((checkYear1 != 0 && checkYear2 != 0 && checkYear3 != 0 && checkYear4 != 0 && checkYear5 == 0) 
               || (checkYear1 == 0 && checkYear2 != 0 && checkYear3 != 0 && checkYear4 != 0 && checkYear5 != 0))
           { 
               if(checkYear1 == 0)
               {
                   if ((checkYear2 <= checkYear3 && checkYear3 <= checkYear4 && checkYear4 <= checkYear5)
                      )
                       alert=true;
               }
               else if (checkYear5 == 0)
               {
                   if ((checkYear1 <= checkYear2 && checkYear2 <= checkYear3 && checkYear3 <= checkYear4)
                      )
                       alert=true;
               }
           }//4 end
            
            else if((checkYear1 != 0 && checkYear2 != 0 && checkYear3 != 0 && checkYear4 == 0 && checkYear5 == 0) 
               || (checkYear1 == 0 && checkYear2 != 0 && checkYear3 != 0 && checkYear4 != 0 && checkYear5 == 0) 
              || (checkYear1 == 0 && checkYear2 == 0 && checkYear3 != 0 && checkYear4 != 0 && checkYear5 != 0) )
            {
                if(checkYear4 == 0)
                {
                    if((checkYear1 <= checkYear2 && checkYear2 <= checkYear3) )
                        alert=true;
                }
                else if (checkYear2 == 0)
                {
                    if((checkYear3 <= checkYear4 && checkYear4 <= checkYear5) )
                        alert=true;
                }
                else if (checkYear1 == 0 && checkYear5 == 0)
                {
                    if((checkYear2 <= checkYear3 && checkYear3 <= checkYear4) )
                        alert=true;
                }
            }// 3 end
    
         else if  ((checkYear1 != 0 && checkYear2 != 0 && checkYear3 == 0 && checkYear4 == 0 && checkYear5 == 0) 
               || (checkYear1 == 0 && checkYear2 != 0 && checkYear3 != 0 && checkYear4 == 0 && checkYear5 == 0) 
              || (checkYear1 == 0 && checkYear2 == 0 && checkYear3 != 0 && checkYear4 != 0 && checkYear5 == 0)
              || (checkYear1 == 0 && checkYear2 == 0 && checkYear3 == 0 && checkYear4 != 0 && checkYear5 != 0))
         {
             if(checkYear3 == 0 && checkYear4 == 0 && checkYear5 == 0)
             {
                 if(checkYear1 <= checkYear2)
                     alert=true;
             }
             else if (checkYear1 == 0 && checkYear4 == 0 && checkYear5 == 0)
             {
                 if(checkYear2 <= checkYear3) 
                     alert=true;
             }
             else if (checkYear1 == 0 && checkYear2 == 0 && checkYear5 == 0)
             {
                 if(checkYear3 <= checkYear4)
                     alert=true;
             }
             else if (checkYear1 == 0 && checkYear2 == 0 && checkYear3 == 0)
             {
                 if(checkYear4 <= checkYear5)
                     alert=true;
             }
         } // 2 end
 		
            if(checkYear1 == 0 && checkYear2 == 0 && checkYear3 == 0 && checkYear4 == 0 && checkYear5 == 0)
            {
                alert=true;
            }
              if(alert==true && antialert == true)
                {

                    update application;
                    update assessment;
                    //update applicationImplementation;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.School_Philosophy_saved));
					//checkInputStatus();
            redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + application.Id + '&tab=sectionb1';
                }
            else if (antialert == false)
            {

                update application;
                    update assessment;
                    //update applicationImplementation;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.School_Philosophy_saved));
					
            redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + application.Id + '&tab=sectionb1';
            }


        	 else if (alert == false)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.projection_year_error));
                }
                
   		//End
        
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving));
            return null;
        }
        return null;
    }

    public IB_Application_Attachment__c IBattachment{

        get {
            if (IBattachment == null)
                IBattachment = new IB_Application_Attachment__c();

            return IBattachment;
        }
        set;
    }

    // creates a new IB_Application_Attachment__c record
    private Database.SaveResult saveCustomAttachment() {
        IB_Application_Attachment__c obj = new IB_Application_Attachment__c();
        obj.IB_Programme__c = programme.Id;
        if (description != null && description != '') obj.Description__c = description;
        obj.Type__c = 'Feasibility Study';
        obj.Category__c = programme.StageName__c;
        obj.Uploaded_By__c = UserInfo.getUserId();
        return Database.insert(obj);
    }


    // create an actual Attachment record with the IB_Application_Attachment__c as parent
    @TestVisible private Database.SaveResult saveStandardAttachment(Id parentId) {
        Database.SaveResult result;

        Attachment newFile = new Attachment();
        newFile.body = this.fileBody;
        newFile.name = this.fileName;
        newFile.parentId = parentId;
        // insert the attahcment
        result = Database.insert(newFile);
        // reset the file for the view state
        fileBody = Blob.valueOf(' ');
        return result;
    }

    /**
     * Upload process is:
     *  1. Insert new IB_Application_Attachment__c record
     *  2. Insert new Attachment with the new IB_Application_Attachment__c record as parent
     *  3. Update the IB_Application_Attachment__c record with the ID of the new Attachment
    **/
    public PageReference upload() {

        try {
            Database.SaveResult customAttachmentResult = saveCustomAttachment();

            if (customAttachmentResult == null || !customAttachmentResult.isSuccess()) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Save_Attachment));
                return null;
            }

            Database.SaveResult attachmentResult = saveStandardAttachment(customAttachmentResult.getId());

            if (attachmentResult == null || !attachmentResult.isSuccess()) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Save_Attachment));
                return null;
            } else {
                // update the custom attachment record with some attachment info
                IB_Application_Attachment__c customAttachment = [select id from IB_Application_Attachment__c where id = :customAttachmentResult.getId()];
                customAttachment.name = this.fileName;
                customAttachment.Attachment__c = attachmentResult.getId();
                update customAttachment;
            }

        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_Uploading));
            return null;

        } catch (Exception e) {

            String msg = e.getMessage();

            if (msg == 'Argument cannot be null.') {
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.File_Upload));
            } else {
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Uploading +e));
            }
            return null;
        }

        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.File_Uploaded));
        return null;
    }
}