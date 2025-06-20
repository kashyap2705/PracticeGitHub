public class FaqController {
    //This Part is being added by Suraj Parihar on 27-Dec-2022 for ECM00572
    public  boolean checkMCSOrOPERole{get; set;}    // Check Marking claim summary and Out of pocket expense role
    public  boolean checkMarkingClaimSumRole{get; set;}  // Check marking claim summary role
    
    public FaqController() {
        List<IB_Role__c> rolesAssignedToUser = new List<IB_Role__c>();
        Set<String> roleAssignedSet = new Set<String>();
        
        List<User> loggedInUser = [SELECT Id, ContactId FROM User WHERE Id =: UserInfo.getUserId()];
        if(!loggedInUser.isEmpty() && loggedInUser[0].ContactId != null){
            rolesAssignedToUser =[SELECT Id, IB_Role_Name__c  FROM IB_Role__c 
                                  WHERE IB_Contact__c = :loggedInUser[0].ContactId 
                                  AND Active__c = true 
                                  AND Status__c='Confirmed'];
            
            for(IB_Role__c role : rolesAssignedToUser ){
                roleAssignedSet.add(role.IB_Role_Name__c); }
        }
        checkMCSOrOPERole = false;
        checkMarkingClaimSumRole = false;
        Set<String>  roleASet = String.isNotBlank(Label.IBEN_Assigned_Role_A)?splitStringForRoles(Label.IBEN_Assigned_Role_A) :  new Set<String>();
        Set<String>  roleBSet = String.isNotBlank(Label.IBEN_Assigned_Role_B)?splitStringForRoles(Label.IBEN_Assigned_Role_B) :  new Set<String>();
        
        if(!roleAssignedSet.isEmpty()){
            for(String roleAssigned : roleAssignedSet){
                if(roleASet.contains(roleAssigned)){
                    checkMCSOrOPERole=true;
                    checkMarkingClaimSumRole=true;
                    break;
                }else if(roleBSet.contains(roleAssigned)){
                    checkMCSOrOPERole=true; 
                }
            }
        } 
    }
    
    public Set<String> splitStringForRoles (String customLabelRoles){
        List<String> rolesNames = customLabelRoles.split(',');
        Set<String> roleSet = new Set<String>();
        roleSet.addAll(rolesNames);
        return roleSet;
    }
    //END
    
    // This Part is being Commented by Developer Ahmad Shakeel-PlumLogix on 10/10/2019, US-11170
    //begin  
    
    
    /*  public List<FAQ__c> faq { get; set; }
public List<IB_Data_Translate__c> translations { get; set; }
public string userLanguage{get;set;}

public FaqController() {

faq = [
SELECT Id, Name, Category__c, Question__c, Answer__c
FROM FAQ__c 
ORDER BY CreatedDate ASC
];

translations = [
SELECT Id, Name, Record_ID__c, Object_Name__c, Locale__c, Translate_Value_1__c, Translate_Value_2__c 
FROM IB_Data_Translate__c 
WHERE Object_Name__c = 'FAQ__c'
AND Locale__c = :UserInfo.getLanguage()
];

System.debug(UserInfo.getLanguage());
userLanguage = UserInfo.getLanguage();
}

public List<FAQ__c> getAssignmentsFaq() {

List<FAQ__c> assignmentsFaq = new List<FAQ__c>();

for (FAQ__c f : faq) { 
if (f.Category__c == 'Assignments') {
for (IB_Data_Translate__c tran : translations) {
if (tran.Record_Id__c == f.Id) {
f.Question__c = tran.Translate_Value_1__c;
f.Answer__c = tran.Translate_Value_2__c;
}
}
assignmentsFaq.add(f);
}
}

return assignmentsFaq;
}

public List<FAQ__c> getRolesFaq() {

List<FAQ__c> rolesFaq = new List<FAQ__c>();

for (FAQ__c f : faq) { 
if (f.Category__c == 'Roles') {
for (IB_Data_Translate__c tran : translations) {
if (tran.Record_Id__c == f.Id) {
f.Question__c = tran.Translate_Value_1__c;
f.Answer__c = tran.Translate_Value_2__c;
}
}
rolesFaq.add(f);
}
}

return rolesFaq;
}

public List<FAQ__c> getGeneralFaq() {

List<FAQ__c> generalFaq = new List<FAQ__c>();

for (FAQ__c f : faq) { 
if (f.Category__c == 'General') {
for (IB_Data_Translate__c tran : translations) {
if (tran.Record_Id__c == f.Id) {
f.Question__c = tran.Translate_Value_1__c;
f.Answer__c = tran.Translate_Value_2__c;
}
}
generalFaq.add(f);
}
}

return generalFaq;
}

public List<FAQ__c> getTrainingFaq() {

List<FAQ__c> trainingFaq = new List<FAQ__c>();

for (FAQ__c f : faq) { 
if (f.Category__c == 'Training') {
for (IB_Data_Translate__c tran : translations) {
if (tran.Record_Id__c == f.Id) {
f.Question__c = tran.Translate_Value_1__c;
f.Answer__c = tran.Translate_Value_2__c;
}
}
trainingFaq.add(f);
}
}

return trainingFaq;
}*/
    
    //End
    
}