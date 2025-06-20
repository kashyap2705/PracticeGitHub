@isTest
private class MyStaffingEventDAOTest {
    @isTest
    static void MyStaffingEventDAOTestMethod()
    {	/*
        Account acc=new Account ( 
                Name = 'John',
                Region__c = 'IBAEM',
                Sub_region__c = 'EUROPE', 
                External_PD_Provider__c = true,
                Language_Of_Correspondance__c = 'English',
                Legal_Status__c = 'Private',
                Short_Name__c = 'John',
                IBIS_ID__c = '000001',
                State_Abbr__c = 'SA');
            
        insert acc;
        Campaign camp1 = new Campaign(Name = 'Test', Type='Evaluation', Event_Organizer_Account__c=acc.Id , IsActive = True);
		insert camp1;
    */
        try{
        MyStaffingEventDAO obj = MyStaffingEventDAO.getInstance();
        MyStaffingEventDAO.INSTANCE = NULL;
        
        obj.exists(NULL, NULL, NULL);
        obj.getCampaignIdFromStaffingId(NULL);
        obj.getCampigneventType(NULL);
        MyStaffingEventDAO.getAssignmentRecord(NULL);
        
        } 
         catch(Exception ex){
            System.debug('Exception: '+ex);}
    
    }
}