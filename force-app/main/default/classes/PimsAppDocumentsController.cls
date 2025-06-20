public class PimsAppDocumentsController extends PimsApplicationControllerHelper {
    
    public String appId {get;set;}
    public String activeTab {get;set;}
    public String redirectUrl {get;set;}
    public String urlCommunityPath {get;set;}
    public String docsCompletionStatus {get;set;}
    
    public IB_Application__c application {get;set;}
    public IB_Programme__c programme {get;set;}
    
    public List<IB_Application_Attachment__c> afcAttachments { get; set; }
    public List<IB_Application_Attachment__c> afaAttachments { get; set; }
    
    public String deleteAppDocId {get;set;}
    public String description {get;set;}
    public String fileName {get;set;}
    public Blob fileBody {get;set;}
    public String docType {get;set;}
    
    public Boolean showReqDocsMsgAfc { get; set; }
    public Boolean showReqDocsMsgAfa { get; set; }
    public Integer AppAttachCnt;
    
    public PimsAppDocumentsController() {
        try
        {
            
            appId = ApexPages.currentPage().getParameters().get('id');
            activeTab = ApexPages.currentPage().getParameters().get('tab');
            
            String currUrl = ApexPages.currentPage().getUrl();
            if (getIsPageInternal()) {
                urlCommunityPath = '/';
            }
            else {
                if (currUrl.contains(getApplicationPageName())) 
                    urlCommunityPath = '/pims/';
                if (currUrl.contains('Iben')) 
                    urlCommunityPath = '/educator/';
            }
            
            if (appId == null) {
                throw new CustomValidationException('The application ID is invalid.');
            }
            
            PageService.setPage(getApplicationPageName());
            activeTab = PageService.getActiveTab();
            
            ApplicationService.setApplicationId(appId);
            application = ApplicationService.getApplication();
            
            ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
            programme = ProgrammeService.getProgramme();
            
            ApplicationAttachmentService.setProgrammeId(programme.Id);
            afcAttachments = ApplicationAttachmentService.getApplicationAttachmentsByStage('Request for Candidacy');
            afaAttachments = ApplicationAttachmentService.getApplicationAttachmentsByStage('Request for Authorization');
            
            validateRequiredDocuments();
        }
        Catch(Exception ex)
        {
            System.Debug(ex);
            
        }
        
    }
    
    // Method for setting the UrlPath parameter from javascript
    public PageReference passUrlPathVal(){
        
        System.debug('urlCommunityPath: ' + urlCommunityPath);
        return null;
        
    }
    
    // creates a new IB_Application_Attachment__c record
    @testVisible
    private Database.SaveResult saveCustomAttachment(String documentType) {
        
        IB_Application_Attachment__c obj = new IB_Application_Attachment__c();
        obj.IB_Programme__c = programme.Id;
        if (description != null && description != '') 
            obj.Description__c = description;
        obj.Type__c = documentType;
        obj.Category__c = programme.StageName__c;
        obj.Uploaded_By__c = UserInfo.getUserId();
        
        return Database.insert(obj);
        
    }
    
    // create an actual Attachment record with the IB_Application_Attachment__c as parent
    @testVisible
    private Database.SaveResult saveStandardAttachment(Id parentId) {
        
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
            
            Integer fileSize = fileBody.size();
            system.debug('fileSize =====> '+fileSize);
            system.debug('docType =====> '+docType);
            system.debug('description =====> '+description);
            
            //if (fileSize == 0) {
            //    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.File_Upload));
            //    return null;
            //}
            
            Database.SaveResult customAttachmentResult = saveCustomAttachment(docType);
            
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
                // update the custom attachment record with some attachment info
                IB_Application_Attachment__c customAttachment = [select id from IB_Application_Attachment__c where id = :customAttachmentResult.getId()];
                customAttachment.name = this.fileName;
                customAttachment.Attachment__c = attachmentResult.getId();
                update customAttachment;
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, Label.File_Uploaded));
                redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + application.Id + '&tab=docs';
            }
            
        } catch (DMLException e) {
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Uploading));
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
    
    public PageReference removeAppDocument() {
        System.debug('in removeAppDocument method =====>');
        
        try {
            
            IB_Application_Attachment__c docToRemove = new IB_Application_Attachment__c();
            docToRemove.Id = deleteAppDocId;
            
            delete docToRemove;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Document_Delete));
            redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + application.Id + '&tab=docs';
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Removing));
            return null;
        }
        return null;
    }
    
    public PageReference save() {
        
        // Re-query the IB application attachments object to ensure there is at least one record
        // because the appAttachments list will be empty before uploading the first attachment
        ApplicationAttachmentService.isCached = false;
        ApplicationAttachmentService.setProgrammeId(programme.Id);
        afcAttachments = ApplicationAttachmentService.getApplicationAttachmentsByStage('Request for Candidacy');
        afaAttachments = ApplicationAttachmentService.getApplicationAttachmentsByStage('Request for Authorization');
        
        validateRequiredDocuments();
        
        if (application.RecordTypeId == RecordTypeService.getRecordTypeByTypeAndName('IB_Application__c','Application_for_Candidacy').Id) {
            if (showReqDocsMsgAfc == false) 
                docsCompletionStatus = 'Complete';
            if (showReqDocsMsgAfc == true) 
                docsCompletionStatus = 'In Progress';
        } 
        else if (application.RecordTypeId == RecordTypeService.getRecordTypeByTypeAndName('IB_Application__c','Application_for_Authorization').Id) {
            if (showReqDocsMsgAfa == false) 
                docsCompletionStatus = 'Complete';
            if (showReqDocsMsgAfa == true) 
                docsCompletionStatus = 'In Progress';
        }
        
        try {
            
            application.AFC_Documents_Status__c = docsCompletionStatus;
            update application;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Doc_section_saved));
            if (getIsAfa() && (getIsDp() || getIsCp())) {
                redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + application.Id + '&tab=outlines';
            }
            else {
                redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + application.Id + '&tab=agreement';
            }
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving));
            
        }
        
        return null;
        
    }
    
    public void validateRequiredDocuments() {
        
        try
        {
            
            if (getIsAfc()) {
                
                String lsdFlag = 'No';
                String sfaFlag = 'No';
                String ocFlag = 'No';
                String popFlag = 'No';
                String pocwFlag = 'No';
                for (IB_Application_Attachment__c ibaa : afcAttachments) {
                    if (ibaa.Type__c == 'Legal status documentation' || ibaa.Type__c == 'Justificatifs du statut légal' || ibaa.Type__c == 'Documentación de situación jurídica') lsdFlag = 'Yes';
                    if (ibaa.Type__c == 'Support from authorities' || ibaa.Type__c == 'Apoyo de las autoridades' || ibaa.Type__c == 'Soutien des autorités') sfaFlag = 'Yes';
                    if (ibaa.Type__c == 'Organizational chart'||ibaa.Type__c == 'Organization chart' || ibaa.Type__c == 'Organigramme' || ibaa.Type__c == 'Organigrama del colegio') ocFlag = 'Yes';
                    if (ibaa.Type__c == 'Proof of Payment'  || ibaa.Type__c == 'Comprobante de pago' || ibaa.Type__c == 'Justificatif de paiement') popFlag = 'Yes';
                    if (ibaa.Type__c == 'Proof of Category 1 workshop' || ibaa.Type__c == 'Preuve d\'atelier de catégorie 1' || ibaa.Type__c == 'Prueba de taller de categoría 1') pocwFlag = 'Yes';
                }
                
                if (getIsCpPhase1() == false && lsdFlag == 'Yes' && sfaFlag == 'Yes' && ocFlag == 'Yes' && popFlag == 'Yes' && pocwFlag == 'Yes') 
                    showReqDocsMsgAfc = false;
                if (getIsCpPhase1() == true && lsdFlag == 'Yes' && sfaFlag == 'Yes' && ocFlag == 'Yes' && popFlag == 'Yes') 
                    showReqDocsMsgAfc = false;
                if (getIsCpPhase1() == false && (lsdFlag == 'No' || sfaFlag == 'No' || ocFlag == 'No' || popFlag == 'No' || pocwFlag == 'No')) 
                    showReqDocsMsgAfc = true;
                if (getIsCpPhase1() == true && (lsdFlag == 'No' || sfaFlag == 'No' || ocFlag == 'No' || popFlag == 'No')) 
                    showReqDocsMsgAfc = true;
                
            }
            else if (getIsAfa()) {
                
                Boolean doc1 = false;
                Boolean doc2 = false;
                Boolean doc3 = false;
                Boolean doc4 = false;
                Boolean doc5 = false;
                Boolean doc6 = false;
                Boolean doc7 = false;
                Boolean doc8 = false;
                Boolean doc9 = false;
                Boolean doc10 = false;
                Boolean doc11 = false;
                Boolean doc12 = false;
                Boolean doc13 = false;
                Boolean doc14 = false;
                //Boolean doc15 = false;
                
                if (getIsPyp()) {
                    
                    for (IB_Application_Attachment__c aa : afaAttachments) {
                        if (aa.Type__c == 'School brochure and literature' || aa.Type__c == 'Folleto escolar y literatura.' || aa.Type__c == 'Brochure et littérature scolaires') doc1 = true;
                        if (aa.Type__c == 'Programme coordinator job description' || aa.Type__c == 'Description du poste de coordonnateur de programme' || aa.Type__c == 'Descripción del puesto de coordinador de programas') doc2 = true;
                        if (aa.Type__c == 'School principal job description' || aa.Type__c == 'Descripción del puesto de director de escuela' || aa.Type__c == 'Description du poste de directeur d\'école') doc3 = true;
                        if (aa.Type__c == 'Assessment policy' || aa.Type__c == 'Politique d\'évaluation' || aa.Type__c == 'Política de evaluación') doc4 = true;
                        if (aa.Type__c == 'Language policy' || aa.Type__c == 'Política lingüística' || aa.Type__c == 'Politique linguistique') doc5 = true;
                        if (aa.Type__c == 'Sample class schedules' || aa.Type__c == 'exemples d’emplois du temps des classes' || aa.Type__c == 'Muestras de horarios de clases') doc6 = true;
                        if (aa.Type__c == 'Programme inquiry' || aa.Type__c == 'Consulta del programa' || aa.Type__c == 'Demande de programme') doc7 = true;
                        if (aa.Type__c == 'Three completed unit planners' || aa.Type__c == 'Trois planificateurs d\'unités terminés' || aa.Type__c == 'Tres planificadores de unidades completos') doc8 = true;
                        if (aa.Type__c == 'Examples of school reports' || aa.Type__c == 'Ejemplos de informes escolares' || aa.Type__c == 'Exemples de bulletins scolaires') doc9 = true;
                    }
                    
                    if (doc1 == false || doc2 == false || doc3 == false || doc4 == false || doc5 == false || doc6 == false || doc7 == false || doc8 == false || doc9 == false) {
                        showReqDocsMsgAfa = true;
                    }
                    else {
                        showReqDocsMsgAfa = false;
                    }
                    
                }
                else if (getIsMyp()) {
                    
                    for (IB_Application_Attachment__c aa : afaAttachments) {
                        if (aa.Type__c == 'School brochure and literature' || aa.Type__c == 'Folleto escolar y literatura.' || aa.Type__c == 'Brochure et littérature scolaires') doc1 = true;
                        if (aa.Type__c == 'Programme coordinator job description' || aa.Type__c == 'Description du poste de coordonnateur de programme' || aa.Type__c == 'Descripción del puesto de coordinador de programas') doc2 = true;
                        if (aa.Type__c == 'Assessment policy' || aa.Type__c == 'Politique d\'évaluation' || aa.Type__c == 'Política de evaluación') doc3 = true;
                        if (aa.Type__c == 'Language policy' || aa.Type__c == 'Política lingüística' || aa.Type__c == 'Politique linguistique') doc4 = true;
                        if (aa.Type__c == 'Inclusion/special educational needs' || aa.Type__c == 'Inclusion/besoins éducatifs particuliers' || aa.Type__c == 'Inclusión necesidades educativas especiales') doc5 = true;
                        if (aa.Type__c == 'Academic honesty policy' || aa.Type__c == 'Política de probidad académica' || aa.Type__c == 'politique d’intégrité intellectuelle') doc6 = true;
                        if (aa.Type__c == 'Full class schedule' || aa.Type__c == 'Horaire complet des cours' || aa.Type__c == 'Horario de clases completo') doc7 = true;
                        if (aa.Type__c == 'Subject group overview' || aa.Type__c == 'Resumen del grupo de materias' || aa.Type__c == 'Aperçu du groupe de sujets') doc8 = true;
                        if (aa.Type__c == 'Learning expectations' || aa.Type__c == 'Expectativas de aprendizaje' || aa.Type__c == 'Expectativas de aprendizaje') doc9 = true;
                        if (aa.Type__c == 'Unit plans from subjects' || aa.Type__c == 'plans de travail des unités des matières' || aa.Type__c == 'Planes de unidad de las asignaturas') doc10 = true;
                        if (aa.Type__c == 'Interdisciplinary unit plan' || aa.Type__c == 'Plan de Unidad Interdisciplinaria' || aa.Type__c == 'plans de travail des unités des matières') doc11 = true;
                        if (aa.Type__c == 'Report cards' || aa.Type__c == 'Bulletins scolaires' || aa.Type__c == 'Boletines de calificaciones') doc12 = true;
                        if (aa.Type__c == 'Personal/community project' || aa.Type__c == 'Proyecto personal/comunitario' || aa.Type__c == 'Projet personnel/communautaire') doc13 = true;
                        if (aa.Type__c == 'Standardization of assessment' || aa.Type__c == 'Standardisation de l\'évaluation' || aa.Type__c == 'Estandarización de la evaluación') doc14 = true;
                    }
                    
                    if (doc1 == false || doc2 == false || doc3 == false || doc4 == false || doc5 == false || doc6 == false || 
                        doc7 == false || doc8 == false || doc9 == false || doc10 == false || doc11 == false || doc12 == false || 
                        doc13 == false || doc14 == false) {
                            showReqDocsMsgAfa = true;
                        }
                    else {
                        showReqDocsMsgAfa = false;
                    }
                    
                }
                else if (getIsDp()) {
                    
                    for (IB_Application_Attachment__c aa : afaAttachments) {
                        if (aa.Type__c == 'School brochure and literature' || aa.Type__c == 'Folleto escolar y literatura.' || aa.Type__c == 'Brochure et littérature scolaires') doc1 = true;
                        if (aa.Type__c == 'Programme coordinator job description' || aa.Type__c == 'Description du poste de coordonnateur de programme' || aa.Type__c == 'Descripción del puesto de coordinador de programas') doc2 = true;
                        if (aa.Type__c == 'Assessment policy' || aa.Type__c == 'Politique d\'évaluation' || aa.Type__c == 'Política de evaluación') doc3 = true;
                        if (aa.Type__c == 'Language policy' || aa.Type__c == 'Política lingüística' || aa.Type__c == 'Politique linguistique') doc4 = true;
                        if (aa.Type__c == 'Admissions policy' || aa.Type__c == 'Política de admisión' || aa.Type__c == 'Politique d’admission') doc5 = true;
                        if (aa.Type__c == 'Inclusion/special educational needs' || aa.Type__c == 'Inclusion/besoins éducatifs particuliers' || aa.Type__c == 'Inclusión necesidades educativas especiales') doc6 = true;
                        if (aa.Type__c == 'Academic honesty policy' || aa.Type__c == 'Política de probidad académica' || aa.Type__c == 'politique d’intégrité intellectuelle') doc7 = true;
                        if (aa.Type__c == 'Student schedule' || aa.Type__c == 'Horaire des étudiants' || aa.Type__c == 'Horario estudiantil') doc8 = true;
                        if (aa.Type__c == 'Calendar of school deadlines' || aa.Type__c == 'Calendario de plazos escolares' || aa.Type__c == 'Calendrier des dates limites scolaires') doc9 = true;
                    }
                    
                    if (doc1 == false || doc2 == false || doc3 == false || doc4 == false || doc5 == false || doc6 == false || 
                        doc7 == false || doc8 == false || doc9 == false) {
                            showReqDocsMsgAfa = true;
                        }
                    else {
                        showReqDocsMsgAfa = false;
                    }
                    
                }
                else if (getIsCpPhase1()) {
                    
                    for (IB_Application_Attachment__c aa : afaAttachments) {
                        if (aa.Type__c == 'School brochure and literature' || aa.Type__c == 'Folleto escolar y literatura.' || aa.Type__c == 'Brochure et littérature scolaires') doc1 = true;
                        if (aa.Type__c == 'Programme coordinator job description' || aa.Type__c == 'Description du poste de coordonnateur de programme' || aa.Type__c == 'Descripción del puesto de coordinador de programas') doc2 = true;
                        if (aa.Type__c == 'Assessment policy' || aa.Type__c == 'Politique d\'évaluation' || aa.Type__c == 'Política de evaluación') doc3 = true;
                        if (aa.Type__c == 'Language policy' || aa.Type__c == 'Política lingüística' || aa.Type__c == 'Politique linguistique') doc4 = true;
                        if (aa.Type__c == 'Admissions policy' || aa.Type__c == 'Política de admisión' || aa.Type__c == 'Politique d’admission') doc5 = true;
                        if (aa.Type__c == 'Inclusion/special educational needs' || aa.Type__c == 'Inclusion/besoins éducatifs particuliers' || aa.Type__c == 'Inclusión necesidades educativas especiales') doc6 = true;
                        if (aa.Type__c == 'Academic honesty policy' || aa.Type__c == 'Política de probidad académica' || aa.Type__c == 'politique d’intégrité intellectuelle') doc7 = true;
                        if (aa.Type__c == 'Student schedule' || aa.Type__c == 'Horaire des étudiants' || aa.Type__c == 'Horario estudiantil') doc8 = true;
                        if (aa.Type__c == 'Career-related accreditation/certification' || aa.Type__c == 'Accréditation/certification liée à la carrière' || aa.Type__c == 'Acreditación/certificación relacionada con la carrera') doc9 = true;
                    }
                    
                    if (doc1 == false || doc2 == false || doc3 == false || doc4 == false || doc5 == false || doc6 == false || 
                        doc7 == false || doc8 == false || doc9 == false) {
                            showReqDocsMsgAfa = true;
                        }
                    else {
                        showReqDocsMsgAfa = false;
                    }
                    
                }
                else if (getIsCpPhase2()) {
                    
                    for (IB_Application_Attachment__c aa : afaAttachments) {
                        if (aa.Type__c == 'School brochure and literature' || aa.Type__c == 'Folleto escolar y literatura.' || aa.Type__c == 'Brochure et littérature scolaires') doc1 = true;
                        if (aa.Type__c == 'Programme coordinator job description' || aa.Type__c == 'Description du poste de coordonnateur de programme' || aa.Type__c == 'Descripción del puesto de coordinador de programas') doc2 = true;
                        if (aa.Type__c == 'Assessment policy' || aa.Type__c == 'Politique d\'évaluation' || aa.Type__c == 'Política de evaluación') doc3 = true;
                        if (aa.Type__c == 'Language policy' || aa.Type__c == 'Política lingüística' || aa.Type__c == 'Politique linguistique') doc4 = true;
                        if (aa.Type__c == 'Admissions policy' || aa.Type__c == 'Política de admisión' || aa.Type__c == 'Politique d’admission') doc5 = true;
                        if (aa.Type__c == 'Inclusion/special educational needs' || aa.Type__c == 'Inclusion/besoins éducatifs particuliers' || aa.Type__c == 'Inclusión necesidades educativas especiales') doc6 = true;
                        if (aa.Type__c == 'Academic honesty policy' || aa.Type__c == 'Política de probidad académica' || aa.Type__c == 'politique d’intégrité intellectuelle') doc7 = true;
                        if (aa.Type__c == 'Student schedule' || aa.Type__c == 'Horaire des étudiants' || aa.Type__c == 'Horario estudiantil') doc8 = true;
                        if (aa.Type__c == 'Calendar of school deadlines' || aa.Type__c == 'Calendario de plazos escolares' || aa.Type__c == 'Calendrier des dates limites scolaires') doc9 = true;
                        if (aa.Type__c == 'Career-related accreditation/certification' || aa.Type__c == 'Accréditation/certification liée à la carrière' || aa.Type__c == 'Acreditación/certificación relacionada con la carrera') doc10 = true;
                    }
                    
                    if (doc1 == false || doc2 == false || doc3 == false || doc4 == false || doc5 == false || doc6 == false || 
                        doc7 == false || doc8 == false || doc9 == false || doc10 == false) {
                            showReqDocsMsgAfa = true;
                        }
                    else {
                        showReqDocsMsgAfa = false;
                    }
                    
                }
                
            }
            
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }  
        
    }    
     
}