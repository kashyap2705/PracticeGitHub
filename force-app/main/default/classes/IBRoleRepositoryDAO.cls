public with sharing class IBRoleRepositoryDAO {
    
    public static final IBRoleRepositoryDAO INSTANCE = new IBRoleRepositoryDAO();
	
	private IBRoleRepositoryDAO () {}
		
	public List <IB_Role_Repository__c> getAvailableRoles () {
         
        List<IB_Role_Repository__c> roles = [
            SELECT id, i.Related_Programmes__c,i.Role_Name__c, i.Role_Name_es__c, i.Role_Name_fr__c, i.Category__c, i.Training_Model__c, i.Category_es__c, 
            	i.Category_fr__c, i.Role_Description__c, i.Role_Description_es__c, i.Role_Description_fr__c, Context__c
            FROM IB_Role_Repository__c i 
            WHERE i.SF_Role_Application__c = true 
            	AND i.Available__c = true
        ];
         
        /*List<IB_Data_Translate__c> translations = [
        	SELECT Id, Name, Record_ID__c, Object_Name__c, Locale__c, Translate_Value_1__c, Translate_Value_2__c 
            FROM IB_Data_Translate__c 
            WHERE Object_Name__c = 'IB_Role_Repository__c'
            	AND Locale__c = :UserInfo.getLanguage()
        ];*/  
	 	
		return roles;
         
	 }
   
}