public class customCreateAndAttachPDF {
    
    /*
     * Welcome Letter PDF
     * 
     * */
     
     public static boolean ibProgramWLPDFExecuted = false;
     @future (callout = true)
    public static void ibProgramWLPDF(id progID)  {
        
        ibProgramWLPDFExecuted = true;
        list <IB_Programme__c> prog =[select 
                                          id,
                                          StageName__c,
                                          Welcome_Letter_Sended__c,
                                          Status__c,
                                          Sub_Stage__c,
                                          Date_Decision_on_Candidacy__c 
                                                           from IB_Programme__c where id =:progID  limit 1];
     
     if(Prog.size()>0){       
        if(prog[0].StageName__c == 'Consultation process' && 
                prog[0].Status__c == 'Candidate' && 
                   /* prog[0].Sub_Stage__c == 'Candidacy Approved' && */
                   //     prog[0].Date_Decision_on_Candidacy__c == Date.today() &&
                          prog[0].Welcome_Letter_Sended__c == false ){
                            
                            
                            prog[0].Welcome_Letter_Sended__c=true;
                             System.debug('Prog Status Before: '+prog[0].Welcome_Letter_Sended__c);
                            update prog[0];
                            System.debug('Prog Status After: '+prog[0].Welcome_Letter_Sended__c);
                            
                            //Welcome Leter PDF atachment generation
                            PageReference pdfPage = Page.Welcome_Letter;
                        
                            //prep attachment
                            pdfPage.getParameters().put('ibProgramID', progID);
                            
                            Attachment attachWL = new Attachment();
                
                          //  Blob content;
        if (Test.IsRunningTest())
                   {
                       attachWL.Body=Blob.valueOf('UNIT.TEST');
                   }
                   else
                   {  
                   attachWL.Body = pdfPage.getContentAsPDF();
                        
                                      
                   }
      //  attachWL.Body = pdfPage.getContentAsPDF();
    
                            
                        //    attachWL.Body = pdfPage.getContentAsPDF();//email.gethtmlBody(); //Blob.valueOf(encodedContentsString);
                            attachWL.Name = String.valueOf('Welcome Letter.pdf');
                            attachWL.ParentId = progid; 
                          
                            
                            insert attachWL;
                            
                            List<IB_Application_Attachment__c> ibAppAttachments = [Select name from IB_Application_Attachment__c where Attachment__c =: attachWL.id];
                            IB_Application_Attachment__c ibAppAttach = ibAppAttachments[0];
                            ibAppAttach.Description__c = 'Letter';
                            ibAppAttach.Category__c = 'Letter';
                            ibAppAttach.Publish_to_Community__c = True;
                            update ibAppAttach;
               }
            }
    }

}