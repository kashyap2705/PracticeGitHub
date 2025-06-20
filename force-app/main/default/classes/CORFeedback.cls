public without sharing class CORFeedback{

@future
 public static void SendMail(ID Corid) {
 
                            course_outline_reading__c cor = [select name,Programme__c,Programme__r.owner__c,Programme__r.owner__r.email from course_outline_reading__c  where id=:Corid Limit 1];
                            EmailTemplate et=[Select id from EmailTemplate where developerName ='COR_Feedback_Submitted']; 
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setTargetObjectId(cor.Programme__r.owner__c); 
                            
                            mail.setSenderDisplayName('No Reply IBEN');
                            
                            mail.setUseSignature(false); 
                            mail.setBccSender(false); 
                            mail.setSaveAsActivity(false);
                            mail.setTreatTargetObjectAsRecipient(false);
                            
                            mail.setToAddresses(new string[]{cor.Programme__r.owner__r.email});
                            mail.setWhatId(cor.id);
                            mail.setTemplateId(et.id);
                            
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
 
 
 
 
 }
}