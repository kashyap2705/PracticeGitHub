public class IBENBQCEventFeedbackController {

    @testvisible private Set<String> fileformat = new Set<String> {'.doc','.pdf','.docx'};

        Public ID assignment_Id;
    public String description { get; set; }
    public String attachment_u_p { get; set; }
    public String attachment_s_a { get; set; }
    public String fileName { get; set; }
    public Blob fileBody { get; set; }
    public string spanish_template{get; set;}
    public string french_template{get; set;}
    public string english_template{get; set;}
    public string redirectUrl{get;set;}
    public String deleteAppDocId { get; set; }
    public IB_Application_Attachment__c attachment_unit_plan { get; set; }
    public IB_Application_Attachment__c attachment_self_assessment{ get; set; }
    public IB_Application_Attachment__c attachment_senior_reviewer {get;set;}
    public IB_Application_Attachment__c attachment { get; set; }
    public List<IB_Application_Attachment__c> attachment_senior_reviewer_feedback {get;set;}
    public List<IB_Application_Attachment__c> attachment_reviewer_feedback {get;set;}
    public List<IB_Application_Attachment__c> child_attachments { get; set; }
    public My_Staffing_Event__c assignment{get;set;}
    public My_Staffing_Event__c assignment1;
    public boolean alreadySubmitted{get;set;}
    public boolean checkstatus {get;set;}
    public boolean school_reviewer_role {get;set;}
    public boolean senior_reviewer_role {get;set;}
    public boolean reviewer_role {get;set;}
    public string attachmentname {get;set;}
    public Campaign mypEvent {get;set;}
    public List<Campaign> mypchildeventslist{get;set;}
    public string attachment_type;
    public string Subject_Name;

    public string BQC_Status{get;set;}
    public string Unit_Plan;
    public List<string> Child_Events_name{get; set;}

    public IBENBQCEventFeedbackController(){
        initializeandload();
        assignment_Id= apexpages.currentpage().getparameters().get('id');
        
        try{

          
            
            assignment =[select id,Related_Subject__c,Staffing_Event__r.Name,Programme_Name_French__c,Programme_Name_Spanish__c,Related_Subject_French__c,Related_Subject_Spanish__c,IB_Event__r.Related_IB_Programme__r.Record_Type_Name_French__c,IB_Event__r.Related_IB_Programme__r.Record_Type_Name_Spanish__c,IB_Event__r.BQC_Subject__c,IB_Role_Name__c,Staffing_Event__c,toLabel(IB_Event__r.BQC_Status__c),Name,IB_Event__r.Name,IB_Event__r.Unit_Plan__c,Staffing_Event_Venue__c,IB_Event__r.IB_Subject__r.Subject_Group__c,Programme_From_Event_Role__c,
                         IB_Event__r.Related_IB_Programme__c ,IB_Event__r.IB_Subject__c,IB_Event__r.IB_Subject__r.Subject_Name__c from My_Staffing_Event__c where id=:assignment_Id Limit 1]; 
             Subject_Name = assignment.IB_Event__r.BQC_Subject__c;
            BQC_Status = assignment.IB_Event__r.BQC_Status__c;
            Unit_Plan = assignment.IB_Event__r.Unit_Plan__c;
            System.debug('Test: '+Subject_Name+' '+BQC_Status+' '+Unit_Plan);
            school_role();
            getattachmentname();

            set_template_name();
            alreadySubmitted = alreadysubmitted_or_not();
            
            System.debug('Already Submitted: '+alreadySubmitted+' '+school_reviewer_role);
            
            try{

            if(!school_reviewer_role ){
                get_school_attachments();
            }
            if(senior_reviewer_role) {
                get_senior_reviewer_attchments();
            }
            if(school_reviewer_role)
            {
                get_school_reviewer_attachments();
            }
            
                attachment=getattachment();}
            catch(Exception ex){
                System.debug('No Existing Attachment');
            }
            
        }
        Catch(Exception ex){
            System.debug('Exception: '+ex);
        }
    }
    public void get_school_attachments(){
        

        attachment_unit_plan = [select id,Name,Attachment__c from IB_Application_Attachment__c where 
                                BQC_Subject__c =: Subject_Name AND Unit_Plan__c =:assignment.IB_Event__r.Unit_Plan__c AND Type__c = 'Unit Plan'
                                AND IB_Programme__c=:assignment.IB_Event__r.Related_IB_Programme__c];
        attachment_self_assessment = [select id,Name,Attachment__c from IB_Application_Attachment__c where 
                                      BQC_Subject__c =: Subject_Name AND Unit_Plan__c =:assignment.IB_Event__r.Unit_Plan__c AND Type__c = 'Self-assessment'
                                      AND IB_Programme__c=:assignment.IB_Event__r.Related_IB_Programme__c];

        System.debug('ID Attachment: '+attachment_unit_plan.id);
        System.debug('ID Attachment: '+attachment_self_assessment.id);        
    }
    public void  get_senior_reviewer_attchments(){
        System.debug('Reviewer Role');


        attachment_senior_reviewer = [select id,Name,Attachment__c from IB_Application_Attachment__c where Type__c=:attachment_type AND BQC_Subject__c=:assignment.IB_Event__r.BQC_Subject__c AND Unit_Plan__c=:assignment.IB_Event__r.Unit_Plan__c AND  IB_Programme__c=:assignment.IB_Event__r.Related_IB_Programme__c];


        System.debug('Reviewer Role '+attachment_senior_reviewer);
    }
    public  void get_school_reviewer_attachments(){
        System.debug('School Reviewer ');
        mypEvent = [Select Name,IB_Subject__c,BQC_Subject__c,BQC_Status__c,IB_Subject__r.Subject_Name__c, Status, Venue_Account__r.Name,StartDate,EndDate,Workshop_Event_City__c,Workshop_Event_Region__c,Workshop_Event_Country__c,
                    Related_IB_Programme__r.id,Unit_Plan__c,Related_IB_Programme__r.Name from campaign 
                    where id=:assignment.IB_Event__c ];
        System.debug('School Reviewer '+mypEvent);

        mypchildeventslist = [Select id,toLabel(BQC_Subject__c),BQC_Status__c,Unit_Plan__c,IB_Subject__c,IB_Subject__r.Subject_Name__c,Name,Status,Related_IB_Programme__c from Campaign where ParentID =: mypEvent.id AND Status='Confirmed' AND Staffing_Event_Published__c=true];
        for(Campaign camp1:mypchildeventslist)
         Child_Events_name.add(camp1.Name);
        List<IB_Application_Attachment__c> feedback_attchment = new List<IB_Application_Attachment__c>();
        System.debug('School Reviewer Child Event '+mypchildeventslist);

        feedback_attchment = [select id,Name,IB_Subject__c,Type__c,Unit_Plan__c,toLabel(BQC_Subject__c),Attachment__c from IB_Application_Attachment__c where (Type__c='BQC Senior Reviewer Feedback' OR Type__c='BQC Reviewer Feedback') AND IB_Programme__c =:mypEvent.Related_IB_Programme__c];
        System.debug('School Reviewer Role '+feedback_attchment);
        for(IB_Application_Attachment__c attachment_record:feedback_attchment){
            System.debug('Type----- '+attachment_record.Type__c);
            if(attachment_record.Type__c == 'BQC Senior Reviewer Feedback')
                attachment_senior_reviewer_feedback.add(attachment_record);
            else if(attachment_record.Type__c == 'BQC Reviewer Feedback')
                attachment_reviewer_feedback.add(attachment_record);                
        }
         System.debug('Size:  '+attachment_reviewer_feedback.size()+' '+attachment_senior_reviewer_feedback.size());
        System.debug('ID----- '+mypEvent.id+' Programme: '+mypEvent.Related_IB_Programme__r.id);
        
        ApplicationAttachmentService.setProgrammeId(mypEvent.Related_IB_Programme__r.id);
        
        redirectUrl=null;
        
        ApplicationAttachmentService.setProgrammeId(mypEvent.Related_IB_Programme__r.id);
        ApplicationAttachmentService.queryApplicationAttachementsByProgId();
        
        List<IB_Application_Attachment__c> childeventsattachments = new List<IB_Application_Attachment__c>();
        childeventsattachments = ApplicationAttachmentService.attachments;
        System.debug('Attachment Size: '+childeventsattachments.size());
        for (IB_Application_Attachment__c aa : childeventsattachments) {
            if (aa.Type__c == 'Unit Plan' || aa.Type__c == 'Self-assessment') {
                System.debug('Attachment Type: '+aa.Type__c+' '+aa.BQC_Subject__c);
                child_attachments.add(aa);
                
            }
        }
    }
    public void  initializeandload(){
        assignment_Id= null;
        description =null;
        attachment_u_p =null;
        attachment_s_a =null;
        fileName =null;
        fileBody =null;
        school_reviewer_role = false;
        senior_reviewer_role = false;
        reviewer_role = false;
        redirectUrl =null;
        deleteAppDocId =null;
        attachment_unit_plan =new IB_Application_Attachment__c();
        attachment_self_assessment =new IB_Application_Attachment__c();
        attachment_senior_reviewer =new IB_Application_Attachment__c();
        attachment_senior_reviewer_feedback = new List<IB_Application_Attachment__c>();
        attachment_reviewer_feedback = new List<IB_Application_Attachment__c>();
        attachment = null;
        child_attachments =new List<IB_Application_Attachment__c>();

        Child_Events_name = new List<String>();

        assignment=null;
        alreadySubmitted=null;
        checkstatus =null;
        attachmentname =null;
        mypEvent =null;
        mypchildeventslist=new List<Campaign>();
        attachment_type=null;
    }
    public void school_role(){
        if(assignment.IB_Role_Name__c =='Building Quality Curriculum Reviewer'){
            reviewer_role = true;
        }else if(assignment.IB_Role_Name__c == 'Building Quality Curriculum Senior Reviewer' ){
            senior_reviewer_role = true;
        }
        else if(assignment.IB_Role_Name__c =='Building Quality Curriculum School Reviewer'){
            school_reviewer_role = true;
        }
        System.debug('Role: '+assignment.IB_Role_Name__c+' '+school_reviewer_role+' '+senior_reviewer_role+' '+reviewer_role);
    }
    public void set_template_name(){

        if(school_reviewer_role == true){

            spanish_template ='/Feedback/BQC_MYP_School_Reviewer_Feedback_SP.docx';
            french_template ='/Feedback/BQC_MYP_School_Reviewer_Feedback_FR.docx';
            english_template ='/Feedback/BQC_MYP_School_Reviewer_Feedback_EN.docx';
        }
        else{

            if(assignment.IB_Event__r.BQC_Subject__c == get_IDU_SubjectName()){

                spanish_template ='/IDU/Spanish/BQC_MYP_Feedback_Template_SP.docx';
                french_template ='/IDU/French/BQC_MYP_Feedback_Template_FR.docx';
                english_template ='/IDU/English/BQC_MYP_Feedback_Template_EN.docx';
            }
            else{


                spanish_template ='/Other/Spanish/BQC_MYP_Feedback_Template_SP.docx';
                french_template ='/Other/French/BQC_MYP_Feedback_Template_FR.docx';
                english_template ='/Other/English/BQC_MYP_Feedback_Template_EN.docx';
            }
        }


    }
    public string get_IDU_SubjectName(){
        string lang = getUserLanguageKey();
        if(lang == 'en_US')
            return 'Interdisciplinary (IDU)';
            else if(lang == 'es')
                  return 'Unidad Interdisciplinaria';
            else if(lang == 'fr')
                return 'Unité de travail interdisciplinaire';
        return null;
    }
    public boolean alreadysubmitted_or_not(){

        Campaign camp = [select id,Name,BQC_Status__c from campaign where id=:assignment.IB_Event__c ];
        System.debug('Role: '+assignment.IB_Role_Name__c+' '+reviewer_role);
        if ((reviewer_role == true && camp.BQC_Status__c == 'Pending Feedback from Senior Reviewer')||
            (senior_reviewer_role == true && camp.BQC_Status__c == 'Feedback Submitted by Senior Reviewer')||
            (school_reviewer_role == true && camp.BQC_Status__c == 'Feedback Submitted by School Reviewer')) {

                return true;
            }
        else {
            return false;
        }
        
    }
    public string getattachmentname(){
        
        if(assignment.IB_Role_Name__c == 'Building Quality Curriculum Reviewer') {

            attachmentname = 'BQC_Reviewer_Feedback';
            attachment_type = 'BQC Reviewer Feedback';
        }
        else if(assignment.IB_Role_Name__c == 'Building Quality Curriculum Senior Reviewer' ){
            attachmentname = 'BQC_Senior_Reviewer_Feedback';
            attachment_type = 'BQC Senior Reviewer Feedback';
        }
        else if(assignment.IB_Role_Name__c == 'Building Quality Curriculum School Reviewer' ){
            attachmentname = 'BQC_School_Reviewer_Feedback';

            attachment_type = 'BQC School Reviewer Feedback';
        }
        System.debug('Attachment Name: '+attachmentname);
        return attachmentname;
    }
    public PageReference upload(){
        Boolean wrongFileextension = true;

        string fileextension = null;

        try {
             for( String ext : fileformat) {
                if( this.fileName.endsWith(ext) ) {
                    wrongFileextension = false;

                    fileextension = ext;

                    break;
                }
            }
            if( wrongFileextension ) {

                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.BQC_Document));
                fileName = null;
                fileBody = null;

                return null;
            }
            else{
                Integer fileSize = fileBody.size();
                Database.SaveResult customAttachmentResult = saveCustomAttachment();
                if (customAttachmentResult == null || !customAttachmentResult.isSuccess()) {
                    
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Save_Attachment));
                    return null;
                    
                }
                Database.SaveResult attachmentResult = saveStandardAttachment(customAttachmentResult.getId());
                if (attachmentResult == null || !attachmentResult.isSuccess()) {
                    
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Save_Attachment));
                    return null;
                    
                }
                else {
                    
                    IB_Application_Attachment__c customAttachment = [select id from IB_Application_Attachment__c where id = :customAttachmentResult.getId()];

                    customAttachment.name = getattachmentname()+fileextension;
                    customAttachment.Attachment__c = attachmentResult.getId();
                    update customAttachment;
                    List<IB_Application_Attachment__c> toDelete = new  List<IB_Application_Attachment__c>();
                        if(!school_reviewer_role){
                         toDelete =[

                        SELECT Id 
                        FROM IB_Application_Attachment__c 
                        WHERE IB_Programme__c = :assignment.IB_Event__r.Related_IB_Programme__c
                        AND Type__c = :attachment_type 
                        AND Unit_Plan__c =:assignment.IB_Event__r.Unit_plan__c
                        AND BQC_Subject__c =:Subject_Name
                        AND Id != :customAttachmentResult.getId()
                    ];

                        }
                    else{
                         toDelete =[
                        SELECT Id 
                        FROM IB_Application_Attachment__c 
                        WHERE IB_Programme__c = :assignment.IB_Event__r.Related_IB_Programme__c
                        AND Type__c = :attachment_type 
                        AND Id != :customAttachmentResult.getId()
                    ];
                    }

                    system.debug('File Size--'+toDelete.size());
                    checkstatus=true;
                    if (toDelete.size() > 0) {
                        delete toDelete;
                        //checkstatus=false;
                    }
                    getattachment();
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, Label.File_Uploaded));
                    redirectUrl = '/educator/apex/IBENBQCEventFeedback?id=' + assignment.id;
                    
                }
            }
        } catch (DMLException e) {
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Uploading));

            fileName = null;
            fileBody = null;

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
        
        
        return null;
    }
    
    public Database.SaveResult saveCustomAttachment() {
        IB_Application_Attachment__c obj = new IB_Application_Attachment__c();
        obj.IB_Programme__c = assignment.IB_Event__r.Related_IB_Programme__c;
        obj.Type__c = attachment_type;
        obj.Category__c = 'Request for Authorization';

        obj.Unit_Plan__c = Unit_Plan ;
        if(!school_reviewer_role)

        obj.BQC_Subject__c = Subject_Name;
        obj.Uploaded_By__c = UserInfo.getUserId();
        
        return Database.insert(obj,false);
        
    }
    
    Public Database.SaveResult saveStandardAttachment(Id parentId) {
        
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
    
    public IB_Application_Attachment__c getattachment(){
        System.debug(assignment.IB_Event__r.BQC_Subject__c);

        IB_Application_Attachment__c attach = new IB_Application_Attachment__c();
        if(!school_reviewer_role)
        attach = [Select id,Name,Unit_Plan__c,Attachment__c,toLabel(BQC_Subject__c) from IB_Application_Attachment__c where Type__c=:attachment_type AND BQC_Subject__c=:Subject_Name AND Unit_plan__c =: Unit_Plan AND IB_Programme__c=:assignment.IB_Event__r.Related_IB_Programme__c];   
        else

        attach = [Select id,Name,Unit_Plan__c,Attachment__c,toLabel(BQC_Subject__c) from IB_Application_Attachment__c where Type__c=:attachment_type AND IB_Programme__c=:assignment.IB_Event__r.Related_IB_Programme__c];   

        if(attach != null)
        System.debug('Attachment Size: '+attach);
        return attach;
    }
    
    public void save(){
        try{
            Campaign camp = [select id,Name,BQC_Status__c from campaign where id=:assignment.IB_Event__c ];
            boolean check=false;

            System.debug('***&**** '+assignment.IB_Role_Name__c+' '+BQC_Status+' ');

            if ((assignment.IB_Role_Name__c == 'Building Quality Curriculum Reviewer' && BQC_Status != 'Pending Feedback from Senior Reviewer')){
                camp.BQC_Status__c ='Pending Feedback from Senior Reviewer';
                check = true;
            }
            else if ((assignment.IB_Role_Name__c == 'Building Quality Curriculum Senior Reviewer' && BQC_Status != 'Feedback Submitted by Senior Reviewer')){
                camp.BQC_Status__c ='Feedback Submitted by Senior Reviewer';
                check = true;
            }
            else if((assignment.IB_Role_Name__c == 'Building Quality Curriculum School Reviewer' && BQC_Status != 'Feedback Submitted by School Reviewer')) {
                camp.BQC_Status__c ='Feedback Submitted by School Reviewer';
                check = true;
            }
            
            
            System.debug('Camp record: '+check+' '+camp);

            if(check == true && getattachment()!=null){
                update camp;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, Label.Feedback_Saved));
                redirectUrl = '/educator/apex/IBENBQCEventFeedback?id=' + assignment.id;
            }
            else
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR ,Label.File_Upload));
            
        }
        Catch(Exception ex){
            System.debug('Exception: '+ex);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR ,Label.COF_Not_Uploaded+': '+fileName));
            fileName = null;
            fileBody = null;

        }        
        
        
    }
    public String getUserLanguageKey() {
        return UserInfo.getLanguage();
    }
    
    //This code is added by Umair-Plumlogix of SA project on 8/5/2020 of US11987
    //Start
    public void Cancel(){
        IB_Application_Attachment__c docToRemove = new IB_Application_Attachment__c();
        docToRemove.Id = attachment.id;
        
        delete docToRemove;
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Document_Delete));
        redirectUrl = '/educator/apex/IBENBQCEventFeedback?id=' + assignment.id;
        
    }
    //End
}