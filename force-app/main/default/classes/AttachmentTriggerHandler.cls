/*******************************************************************************************
* @Name         AttachmentTriggerHandler 
* @Author       
* @Date         
* @Group        
* @Description  
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Saurabh Singh      06/22/2023         I have modify the code from line 232 to 251 because we need to make it work for all records of COR and I have added try catch in the handleNewAFAttachment method.
*******************************************************************************************/
public class AttachmentTriggerHandler {
    public static boolean check;
    public static void handleNewIBCFAttachment(List<Attachment> newAttList,String IBCF){
        
        Set<Id> IBCFRecords = new Set<Id>();
        //map of ParentId to AttachmentId
        Map<Id,Id> attachmentMap = new Map<Id,Id>();
        
        for(Attachment a : newAttList){
            system.debug('Parent Id: ' + String.valueOf(a.ParentId).substring(0,3));
            if(String.valueOf(a.ParentId).substring(0,3) == IBCF){
                IBCFRecords.add(a.ParentId);
                attachmentMap.put(a.ParentId,a.Id);
            }
        }
        
        system.debug('IBCF attachmentmap: ' + attachmentMap);
        
        if(!attachmentMap.isEmpty()){
            
            List<IB_Consultant_Feedback__c> feedbackRecords = [SELECT Id,IB_Programme_Lookup__c,RecordType.Name
                                                               FROM IB_Consultant_Feedback__c
                                                               WHERE ID in :IBCFRecords];
            
            List<IB_Application_Attachment__c> ibaas = new List<IB_Application_Attachment__c>();
            //loop over feedback records an associate to programme
            for(IB_Consultant_Feedback__c i:feedbackRecords){
                IB_Application_Attachment__c ibaa = new IB_Application_Attachment__c();
                ibaa.Attachment__c = attachmentMap.get(i.Id);
                ibaa.Category__c = 'Consultation process';
                ibaa.Description__c = 'Consultation Report for ' + i.RecordType.Name;
                ibaa.Name = 'Consultation Report ' + i.RecordType.Name + '.pdf';
                ibaa.IB_Programme__c = i.IB_Programme_Lookup__c;
                ibaa.Publish_to_Community__c = true;
                ibaa.Type__c = 'Consultant Report';
                system.debug('ibaa: ' + ibaa);
                ibaas.add(ibaa);
            }
            
            insert ibaas;
            
            //now update programmes with the URLs
            
            List<IB_Programme__c> programmes = new List<IB_Programme__c>();
            //query to get network id of my school
            Network nw = [SELECT id, name FROM Network WHERE Name = 'My School' LIMIT 1];
            
            String baseUrl = Network.getLoginUrl(nw.id);
            baseUrl = baseUrl.removeEnd('PimsLogin');
            
            //'servlet/servlet.FileDownload?file=' + ibaa.Attachment__c
            //'PimsViewReports?pid=' + ibaa.IB_Programme__c
            
            for(IB_Application_Attachment__c ibaa:ibaas){
                IB_Programme__c programme = new IB_Programme__c();
                programme.Id = ibaa.IB_Programme__c;
                if(ibaa.Name.contains('End of Process')){
                    programme.Consultation_EOC_Report_Link__c = baseUrl + 'servlet/servlet.FileDownload?file=' + ibaa.Attachment__c;
                } else if (ibaa.Name.contains('Initial Visit')){
                    programme.Consultation_Visit_Report_Link__c = baseUrl + 'servlet/servlet.FileDownload?file=' + ibaa.Attachment__c;
                }
                programmes.add(programme);
            }
            
            update programmes;
        }
    }
    
    //This Method modified by Prerna on 19-05-2025 for ECM00739: Phase 2
    public static void handleNewIBPAttachment(List<Attachment> newAttList, String IBP) {
    Set<Id> IBPRecords = new Set<Id>();
    if (newAttList == null || newAttList.isEmpty()) return;
    List<Attachment> filteredAttachments = new List<Attachment>();
    for (Attachment a : newAttList) {
        if (String.valueOf(a.ParentId).startsWith(IBP)) {
            IBPRecords.add(a.ParentId);
            filteredAttachments.add(a);
        }
    }
    if (filteredAttachments.isEmpty()) return;
        
    Map<Id, IB_Programme__c> programMap = new Map<Id, IB_Programme__c>(
        [SELECT Id, RecordType.Name, Acceptance_Letter_Description__c
         FROM IB_Programme__c
         WHERE Id IN :IBPRecords]
    );

    List<IB_Application_Attachment__c> ibaas = new List<IB_Application_Attachment__c>();

        for (Attachment att : filteredAttachments) {
            IB_Programme__c prog = programMap.get(att.ParentId);
            if (prog == null) continue;
            IB_Application_Attachment__c ibaa = new IB_Application_Attachment__c();
            ibaa.Attachment__c = att.Id;
            //ibaa.Category__c = 'Matters to Be Addressed';
            ibaa.Name = att.Name;
            ibaa.IB_Programme__c = prog.Id;
            ibaa.Type__c = 'Letter';

        // Description logic
        if (prog.Acceptance_Letter_Description__c != null) {
            ibaa.Description__c = prog.Acceptance_Letter_Description__c;
        } else {
            IF(att.Name.startsWith('ELT28 RRR')) {
                ibaa.Description__c = 'MTBA from Reading Response Resolved';
                ibaa.Category__c = 'Matters to Be Addressed';
                ibaa.Publish_to_Community__c = true;
            } else if (att.Name.startsWith('ELT28 RRNAVGF')) {
                ibaa.Description__c = 'MTBA from Reading Response NOT Approved - Visit going forward';
                ibaa.Category__c = 'Matters to Be Addressed';
                ibaa.Publish_to_Community__c = true;
            } else if (att.Name.startsWith('ELT28 RRNAVNGF')) {
                ibaa.Description__c = 'MTBA from Reading Response NOT Approved - Visit not going forward';
                ibaa.Category__c = 'Matters to Be Addressed';
                ibaa.Publish_to_Community__c = true;
            } else if (att.Name.startsWith('ELT_24')) {
                ibaa.Description__c = 'Verification Visit Letter';
                ibaa.Category__c = 'Matters to Be Addressed';
                ibaa.Publish_to_Community__c = true;
            }else if((ibaa.Name).startsWith('ELT-19A') || (ibaa.Name).startsWith('ELT-19B') || (ibaa.Name).startsWith('ELT-19C') || (ibaa.Name).startsWith('ELT-21')){
                        ibaa.Category__c = 'Published Letter';
                        ibaa.Description__c = 'Published Letter'; 
                        ibaa.Publish_to_Community__c = true;                    
                    }else if(ibaa.Name == 'IB: Demande de lettre de réponse à la candidature.pdf' || ibaa.Name == 'IB: Solicitud de carta de respuesta a la candidatura.pdf' || ibaa.Name == 'IB : Application for candidacy response letter.pdf'){
                        ibaa.Category__c = 'Letter';
                        ibaa.Description__c = 'Letter';
                        
                ibaa.Publish_to_Community__c = true;
            }
        }
        if (
            att.Name.startsWith('IBWS Welcome Letter – First Programme.pdf') ||
            att.Name.startsWith('Lettre de Bienvenue pour les écoles du monde de l’IB – Premier programme.pdf') ||
            att.Name.startsWith('Carta de bienvenida – Primer programa (Colegios del Mundo del IB).pdf') ||
            att.Name.startsWith('IBWS Welcome Letter – Adding a Programme.pdf') ||
            att.Name.startsWith('Lettre de Bienvenue pour les écoles du monde de l’IB – Ajouter un programme.pdf') ||
            att.Name.startsWith('Carta de bienvenida – Programa Adicional (Colegios del Mundo del IB).pdf') ||
            att.Name.startsWith('Becoming an IB Continuum School – Welcome Letter.pdf') ||
            att.Name.startsWith('Devenir un établissement continuum de l’IB - Lettre de bienvenue.pdf') ||
            att.Name.startsWith('Carta de bienvenida – Colegio del continuo de programas del IB.pdf')
        ) {
            ibaa.Description__c = att.Description;
            ibaa.Category__c = 'Evaluation';
            ibaa.Publish_to_Community__c = true;
        }

            ibaa.IB_Programme__c = prog.Id; //i repaced by Prerna for 739-phase 2 changes
            ibaa.Type__c = 'Letter';
            ibaas.add(ibaa);
    }

        do {
            try {
                System.debug('Insert: ');
                insert ibaas;
                check = true;
            }
            catch(Exception ex) {
                System.debug('Exception: '+ex);
            }
        }while(check != true);
    //}
    }
    
    public static void handleNewAFAttachment(List<Attachment> newAttList,String AF){
        try{
            Set<Id> AFRecords = new Set<Id>();
            //map of ParentId to AttachmentId
            Map<Id,Attachment> attachmentMap = new Map<Id,Attachment>();
            Map<Id,Attachment> attachmentMapProg = new Map<Id,Attachment>();
            
            for(Attachment a : newAttList){
                system.debug('Attachment ' + a);
                if(String.valueOf(a.ParentId).substring(0,3) == AF){
                    AFRecords.add(a.ParentId);  
                    attachmentMap.put(a.ParentId,a);
                }
            }
            
            system.debug('AF attachmentmap: ' + attachmentMap);
            
            if(!attachmentMap.isEmpty()){
                List<Auth_Feedback__c> feedbacks = [SELECT IB_Programme__r.id
                                                    FROM Auth_Feedback__c
                                                    WHERE ID in :AFRecords];
                
                Set<Id> pgRecords = new Set<Id>();
                
                for(Auth_Feedback__c a : feedbacks){
                    system.debug('Auth Feedback ' + a);
                    pgRecords.add(a.IB_Programme__c);
                    for(ID id : attachmentMap.keySet()){
                        attachmentMapProg.put(a.IB_Programme__r.Id, attachmentMap.get(id));
                    }
                    //attachmentMap.put(a.IB_Programme__r.Id,a);
                }
                
                system.debug('Programmes:'+pgRecords);
                
                List<IB_Programme__c> feedbackRecords = [SELECT Id,RecordType.Name
                                                         FROM IB_Programme__c
                                                         WHERE Id in :pgRecords];
                
                List<IB_Application_Attachment__c> ibaas = new List<IB_Application_Attachment__c>();
                //loop over programme records
                for(IB_Programme__c i:feedbackRecords){
                    
                    IB_Application_Attachment__c ibaa = new IB_Application_Attachment__c();
                    ibaa.Attachment__c = (attachmentMapProg.get(i.Id)).Id;
                    
                    ibaa.Category__c = 'Auth Feedback Category';
                    ibaa.Name = (attachmentMapProg.get(i.Id)).Name;
                    
                    ibaa.Description__c = 'Auth Feedback';
                    
                    ibaa.IB_Programme__c = i.Id;                
                    ibaa.Publish_to_Community__c = true;
                    ibaa.Type__c = 'Letter';
                    system.debug('ibaa: ' + ibaa);
                    ibaas.add(ibaa);
                }
                
                insert ibaas;
                
                // we want to set all of the Course Outline Attachments to published when the AFA Report is created
                List<Course_Outline_Reading__c> readings = [
                    SELECT Id, Name, Programme__c, Feedback_Attachment__c, Status__c 
                    FROM Course_Outline_Reading__c 
                    WHERE Programme__c IN :pgRecords 
                    AND Status__c = 'Submitted'
                ];
                
                // This Part is being updated by Developer Ahmad Shakeel-PlumLogix on 20/11/2019, Duplicate Id Error
                //begin
                Map<id,IB_Application_Attachment__c> mapOfAtt = new Map<id,IB_Application_Attachment__c>();
                for (Course_Outline_Reading__c cor : readings) {
                    cor.Status__c = 'Published';
                    if(cor.Feedback_Attachment__c != null){
                        IB_Application_Attachment__c sAttachMent=new IB_Application_Attachment__c();
                        sAttachMent.Id=cor.Feedback_Attachment__c;
                        sAttachMent.Publish_to_Community__c=true;
                        mapOfAtt.put(sAttachMent.Id,sAttachMent);
                    }
                }
                update readings;
                 if(!mapOfAtt.isEmpty()){
                    update mapOfAtt.values();
                }
            }
        }
        catch(Exception exp)
        {
            Logger.get().add(exp, LogSeverity.ERROR).publish(); 
        }
    }
    
    public static void handleNewVVFAttachment(List<Attachment> newAttList,String VVF){
        
        Set<Id> VVFRecords = new Set<Id>();
        //map of ParentId to AttachmentId
        Map<Id,Attachment> attachmentMap = new Map<Id,Attachment>();
        Map<Id,Attachment> attachmentMapProg = new Map<Id,Attachment>();
        
        for(Attachment a : newAttList){
            system.debug('Attachment ' + a);
            if(String.valueOf(a.ParentId).substring(0,3) == VVF){
                VVFRecords.add(a.ParentId);
                attachmentMap.put(a.ParentId,a);
            }
        }
        
        system.debug('VVF attachmentmap: ' + attachmentMap);
        
        if(!attachmentMap.isEmpty()){
            
            List<IB_Verification_Visit_Feedback__c> feedbacks = [SELECT IB_Programme__r.id
                                                                 FROM IB_Verification_Visit_Feedback__c
                                                                 WHERE ID in :VVFRecords];
            
            Set<Id> pgRecords = new Set<Id>();
            
            for(IB_Verification_Visit_Feedback__c a : feedbacks){
                system.debug('Visit Feedback ' + a);
                pgRecords.add(a.IB_Programme__c);
                for(ID id : attachmentMap.keySet()){
                    attachmentMapProg.put(a.IB_Programme__r.Id, attachmentMap.get(id));
                }
                //attachmentMap.put(a.IB_Programme__r.Id,a);
            }
            
            system.debug('Programmes:'+pgRecords);
            
            List<IB_Programme__c> feedbackRecords = [SELECT Id,RecordType.Name
                                                     FROM IB_Programme__c
                                                     WHERE ID in :pgRecords];
            
            List<IB_Application_Attachment__c> ibaas = new List<IB_Application_Attachment__c>();
            //loop over programme records
            for(IB_Programme__c i:feedbackRecords){
                
                IB_Application_Attachment__c ibaa = new IB_Application_Attachment__c();
                ibaa.Attachment__c = (attachmentMapProg.get(i.Id)).Id;
                
                ibaa.Name = (attachmentMapProg.get(i.Id)).Name;
                
                ibaa.Category__c = 'Verification Visit Letter';
                
                IF((ibaa.Name).startsWith('ELT_28B')) {
                    ibaa.Description__c = 'MTBA from Verification Visit Response Approved';
                }else if((ibaa.Name).startsWith('ELT_28C1')){
                    ibaa.Description__c = 'MTBA from Verification Visit NOT Approved';                     
                }else if((ibaa.Name).startsWith('ELT_28C2')){
                    ibaa.Description__c = 'MTBA from Verification Visit NOT Approved - Candidacy Extended';                     
                }else if((ibaa.Name).startsWith('ELT_28C3')){
                    ibaa.Description__c = 'AFA MTBAs: revise AfA';                     
                }else if((ibaa.Name).startsWith('ELT_25a')){
                    ibaa.Description__c = 'Matters to respond within short deadline';                     
                }else if((ibaa.Name).startsWith('ELT_25b')){
                    ibaa.Description__c = 'Submit Revised AFA';                     
                }else if((ibaa.Name).startsWith('ELT_25c')){
                    ibaa.Description__c = 'No MTBAs';                     
                }
                
                ibaa.IB_Programme__c = i.Id;                
                ibaa.Publish_to_Community__c = true;
                ibaa.Type__c = 'Letter';
                system.debug('ibaa: ' + ibaa);
                ibaas.add(ibaa);
            }
            
            insert ibaas;
        }
    }
    
    public static void handleAttachmentDelete(List<Attachment> delAttList,String docType){
        
        Set<String> delRecords = new Set<String>();
        
        for(Attachment a : delAttList){
            if(String.valueOf(a.ParentId).substring(0,3) == docType){
                delRecords.add(a.Id);
            }
        }
        
        if(delRecords.size() >0){
            List<IB_Application_Attachment__c> ibaas = [SELECT ID FROM IB_Application_Attachment__c 
                                                        WHERE Attachment__c in :delRecords];
            
            delete ibaas;            
        }                    
    }   
}