public class IBENReferenceWebFormCtrl{
    public integer maxLength{get;set;}
    public integer commentLength{get;set;}
    public integer capacityLength{get;set;}
    public integer strengthLength{get;set;}
    public integer aodLength{get;set;}
    
    public boolean isSubmitted{get;set;}
    public IB_Referee_Feedback__c feedback{get;set;}
    public IBENReferenceWebFormCtrl(ApexPages.StandardController std){
        this.feedback = (IB_Referee_Feedback__c)std.getRecord();
        feedback = [select Id, My_Role__c, My_Role__r.First_Name__c, My_Role__r.Last_Name__c, My_Role__r.IB_Role_Name__c, 
                    Referee_Professional_Relationship__c, Years_Known_Applicant__c, Years_Supervised_Applicant__c, School_Position__c, School_Name__c, 
                    First_Middle_Name_s__c, Last_Name__c, Referee_Email__c, Status__c, Commitment_to_IB_Programmes__c, 
                    Comments__c, Areas_of_Development__c, Greatest_Strengths__c, Capacity__c, Commitment_to_Professional_Development__c, 
                    Knowledge_of_IB_Programmes__c, Knowledge_in_New_Context__c, Implemenation_of_IB_Programme__c, Facilitate_Inquiry__c, Encourages_New_Ideas__c, 
                    Engage_in_Reflection_and_Self_Evaluation__c, Technology_Skills__c, Effective_Organizational_Skills__c, Presentation_Confidence__c, 
                    Communicate_Effectively__c, Inspires_Critical_Thinking__c, Takes_Risks__c, Listen_and_Engage__c, Empathize_and_Encourage_Others__c, Climate_of_Open_Communication__c, 
                    Work_Collaboratively__c 
                    from IB_Referee_Feedback__c where Id =: feedback.Id limit 1];
    }
    
    public void submit(){
        try{
            feedback.Status__c = 'Complete';
            update feedback;
            isSubmitted = true;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR : '+e.getMessage()));        
        }
    }
}