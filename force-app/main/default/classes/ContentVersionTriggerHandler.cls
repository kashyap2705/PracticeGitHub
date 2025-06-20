public class ContentVersionTriggerHandler {
    public static boolean check;
    public static void processFileCreation(List<ContentVersion> cvList){
        Set<Id> contentDocumentIds = new Set<Id>();
        for(ContentVersion cv : cvList){
            contentDocumentIds.add(cv.contentDocumentId);
        }
        Map<String,ContentDocumentLink> ibcfMap = new Map<String,ContentDocumentLink>();
        Map<String,ContentDocumentLink> ibpMap = new Map<String,ContentDocumentLink>();
        Map<String,ContentDocumentLink> afMap = new Map<String,ContentDocumentLink>();
        Map<String,ContentDocumentLink> vvfMap = new Map<String,ContentDocumentLink>();
        for(ContentDocumentLink cdl : [SELECT id, LinkedEntityId, ContentDOcumentId, ContentDocument.Title FROM ContentDocumentLink WHERE ContentDocumentId IN: contentDocumentIds]){
            if(String.valueOf(cdl.LinkedEntityId).startsWith(SchemaGlobalDescribe.findRecordIdPrefixFromObjectName('IB_Consultant_Feedback__c'))){
                ibcfMap.put(cdl.LinkedEntityId,cdl);
            }else if(String.valueOf(cdl.LinkedEntityId).startsWith(SchemaGlobalDescribe.findRecordIdPrefixFromObjectName('IB_Programme__c'))){
                ibpMap.put(cdl.LinkedEntityId,cdl);
            }else if(String.valueOf(cdl.LinkedEntityId).startsWith(SchemaGlobalDescribe.findRecordIdPrefixFromObjectName('Auth_Feedback__c'))){
                afMap.put(cdl.LinkedEntityId,cdl);
            }else if(String.valueOf(cdl.LinkedEntityId).startsWith(SchemaGlobalDescribe.findRecordIdPrefixFromObjectName('IB_Verification_Visit_Feedback__c'))){
                vvfMap.put(cdl.LinkedEntityId,cdl);
            }
        }
        if(ibcfMap != null) processIBCFrecords(ibcfMap);
        if(ibpMap != null) processIBPrecords(ibpMap);
        if(afMap != null) processAFrecords(afMap);
        if(vvfMap != null) processVVFrecords(vvfMap);
    }
    
    private static void processIBCFrecords(Map<String,ContentDocumentLink> ibcfMap){            
            List<IB_Application_Attachment__c> ibaas = new List<IB_Application_Attachment__c>();
            for(IB_Consultant_Feedback__c feedback : [SELECT Id,IB_Programme_Lookup__c,RecordType.Name
                                                      FROM IB_Consultant_Feedback__c
                                                      WHERE ID in :ibcfMap.keySet()]){
                IB_Application_Attachment__c ibaa = new IB_Application_Attachment__c();
                ibaa.Attachment__c = ibcfMap.get(feedback.Id).ContentDocumentId;
                ibaa.Category__c = 'Consultation process';
                ibaa.Description__c = 'Consultation Report for ' + feedback.RecordType.Name;
                ibaa.Name = 'Consultation Report ' + feedback.RecordType.Name + '.pdf';
                ibaa.IB_Programme__c = feedback.IB_Programme_Lookup__c;
                ibaa.Publish_to_Community__c = true;
                ibaa.Type__c = 'Consultant Report';
                system.debug('ibaa: ' + ibaa);
                ibaas.add(ibaa);
            }
            
            insert ibaas;
            List<IB_Programme__c> programmes = new List<IB_Programme__c>();
            Network nw = [SELECT id, name FROM Network WHERE Name = 'My School' LIMIT 1];
            String baseUrl = Network.getLoginUrl(nw.id);
            baseUrl = baseUrl.removeEnd('PimsLogin');
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
    
    private static void processIBPrecords(Map<String,ContentDocumentLink> ibpMap){  
            List<IB_Application_Attachment__c> ibaas = new List<IB_Application_Attachment__c>();
            for(IB_Programme__c i : [SELECT Id,RecordType.Name, Acceptance_Letter_Description__c
                                     FROM IB_Programme__c
                                     WHERE Id IN : ibpMap.keySet()]){
                
                IB_Application_Attachment__c ibaa = new IB_Application_Attachment__c();
                ibaa.Attachment__c = ibpMap.get(i.Id).ContentDocumentId;
                ibaa.Name = ibpMap.get(i.Id).ContentDocument.Title;
                if(i.Acceptance_Letter_Description__c !=null){
                    ibaa.Description__c = i.Acceptance_Letter_Description__c;
                }else{
                    IF((ibaa.Name).startsWith('ELT28 RRR')) {
                        ibaa.Description__c = 'MTBA from Reading Response Resolved';
                        ibaa.Category__c = 'Matters to Be Addressed';
                        ibaa.Publish_to_Community__c = true;
                    }else if((ibaa.Name).startsWith('ELT28 RRNAVGF')){
                        ibaa.Description__c = 'MTBA from Reading Response NOT Approved - Visit going forward';  
                        ibaa.Category__c = 'Matters to Be Addressed';
                        ibaa.Publish_to_Community__c = true;                   
                    }else if((ibaa.Name).startsWith('ELT28 RRNAVNGF')){
                        ibaa.Description__c = 'MTBA from Reading Response NOT Approved - Visit not going forward'; 
                        ibaa.Category__c = 'Matters to Be Addressed';
                        ibaa.Publish_to_Community__c = true;                    
                    }else if((ibaa.Name).startsWith('ELT_24')){
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
                ibaa.IB_Programme__c = i.Id;   
                ibaa.Type__c = 'Letter';
                system.debug('ibaa: ' + ibaa);
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
    }
    
    private static void processAFrecords(Map<String,ContentDocumentLink> afMap){
        try{
            Map<Id,ContentDocumentLink> attachmentMapProg = new Map<Id,ContentDocumentLink>();
            for(Auth_Feedback__c authFeedback : [SELECT IB_Programme__c 
                                                 FROM Auth_Feedback__c
                                                 WHERE Id IN : afMap.keySet()]){
                                                     for(ID id : afMap.keySet()){
                                                         attachmentMapProg.put(authFeedback.IB_Programme__c, afMap.get(id));
                                                     }
                                                 }
            List<IB_Programme__c> feedbackRecords = [SELECT Id,RecordType.Name
                                                     FROM IB_Programme__c
                                                     WHERE Id IN : attachmentMapProg.keySet()];
            
            List<IB_Application_Attachment__c> ibaas = new List<IB_Application_Attachment__c>();
            for(IB_Programme__c i:feedbackRecords){
                
                IB_Application_Attachment__c ibaa = new IB_Application_Attachment__c();
                ibaa.Attachment__c = attachmentMapProg.get(i.Id).ContentDocumentId;
                ibaa.Category__c = 'Auth Feedback Category';
                ibaa.Name = attachmentMapProg.get(i.Id).ContentDocument.Title;
                ibaa.Description__c = 'Auth Feedback';
                ibaa.IB_Programme__c = i.Id;                
                ibaa.Publish_to_Community__c = true;
                ibaa.Type__c = 'Letter';
                system.debug('ibaa: ' + ibaa);
                ibaas.add(ibaa);
            }
            insert ibaas;
            
            List<Course_Outline_Reading__c> readings = [SELECT Id, Name, Programme__c, Feedback_Attachment__c, Status__c 
                                                        FROM Course_Outline_Reading__c 
                                                        WHERE Programme__c IN : attachmentMapProg.keySet() 
                                                        AND Status__c = 'Submitted'];
            
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
        }catch(Exception exp){
            Logger.get().add(exp, LogSeverity.ERROR).publish(); 
        }
    }
    
    private static void processVVFrecords(Map<String,ContentDocumentLink> vvfMap){
        Map<Id,ContentDocumentLink> progFileMap = new Map<Id,ContentDocumentLink>();
            for(IB_Verification_Visit_Feedback__c a : [SELECT IB_Programme__c 
                                                       FROM IB_Verification_Visit_Feedback__c
                                                       WHERE Id IN : vvfMap.keySet()]){
                system.debug('Visit Feedback ' + a);
                for(ID id : vvfMap.keySet()){
                    progFileMap.put(a.IB_Programme__c, vvfMap.get(id));
                }
            }
            List<IB_Programme__c> feedbackRecords = [SELECT Id,RecordType.Name
                                                     FROM IB_Programme__c
                                                     WHERE Id IN: progFileMap.keySet()];
            
            List<IB_Application_Attachment__c> ibaas = new List<IB_Application_Attachment__c>();
            for(IB_Programme__c feedbacks : feedbackRecords){
                IB_Application_Attachment__c ibaa = new IB_Application_Attachment__c();
                ibaa.Attachment__c = progFileMap.get(feedbacks.Id).ContentDocumentId;
                ibaa.Name = (progFileMap.get(feedbacks.Id)).ContentDocument.Title;
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
                
                ibaa.IB_Programme__c = feedbacks.Id;                
                ibaa.Publish_to_Community__c = true;
                ibaa.Type__c = 'Letter';
                system.debug('ibaa: ' + ibaa);
                ibaas.add(ibaa);
            }
            insert ibaas;
    }
}