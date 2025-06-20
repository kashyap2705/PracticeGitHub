@isTest
public class RoleRepoFactoryTest {
    public static IB_Role_Repository__c createRepoRecord(Boolean isInsert,string roleName){
        IB_Role_Repository__c repRecord = new IB_Role_Repository__c
            ( Available__c=true, SF_Role_Application__c=true,Available_From__c=Date.today().addDays(-12),CurrencyIsoCode='EUR',
             Role_Name__c=roleName, Category__c='Learning Centre', Role_Level__c='Fully Qualified;',Sub_Category__c='Administration',
             Related_Programmes__c='PYP;MYP;DP;IBCC',Available_in_Region__c='Global',Training_Model__c = 'Advanced Training',IB_Staff_Role__c=true);        
        if(isInsert == true){
            insert repRecord;
        }
        return repRecord;
    }
    public static List<IB_Address__c> createAddress( Integer count ,Id country, Account acc,Boolean isInsert){
        List<IB_Address__c> ibAdressList = new List<IB_Address__c>();
        for(Integer i=0;i<count;i++){
            IB_Address__c ibAdress = new IB_Address__c(Name = 'Postal'+i,Address_Line_1__c = '1 hammock beach',City__c = 'palm coast', Postal_Code__c = '32137',IB_Account__c = acc.Id,Status__c = 'Active',Province__c = 'FL',Country__c = country);
            ibAdressList.add(ibAdress);
        }
        if(isInsert)
            insert ibAdressList;
        return ibAdressList;
    }
    public static IB_Role_Repository__c createRoleRepo(String roleName){
        return new IB_Role_Repository__c(
            Available__c=true,
            SF_Role_Application__c=true,
            Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
            CurrencyIsoCode='EUR',
            Role_Name__c=roleName,
            Category__c='Learning Centre',
            Role_Level__c='Fully Qualified;',
            Sub_Category__c='Administration',
            Related_Programmes__c='PYP;MYP;DP;IBCC',
            Available_in_Region__c='Global',
            Training_Model__c = 'Advanced Training',
            IB_Staff_Role__c=true
        );
    }
    public static void generateStandardRoles(){
        List<IB_Role_Repository__c> repoList = new List<IB_Role_Repository__c>();
        IB_Role_Repository__c repo = createRoleRepo('School Contact');
        repoList.add(repo);
        repo = createRoleRepo('Programme Coordinator');
        repoList.add(repo);
        repo = createRoleRepo('Billing Contact');
        repoList.add(repo);
        repo = createRoleRepo('Exam Contact');
        repoList.add(repo);
        repo = createRoleRepo('Head of School');
        repoList.add(repo);
        repo = createRoleRepo('Head of School (Overall)');
        repoList.add(repo);
        
        insert repoList;
    }
    public static IB_Role__c createIbRole(Id repoId, Id contactId, Id accId){
        return new IB_Role__c(
            IB_Contact__c = contactId,
            IB_Role__c = repoId,
            Programme_Selection__c='PYP;MYP;DP;IBCC',
            Status__c='Confirmed',
            Active__c = true,            
            IB_Account__c = accId
        );
    }
    
    
    public static IB_Country_Segmentation__c createIBACountrySegmentation (Boolean isInsert ){
        IB_Country_Segmentation__c country = new IB_Country_Segmentation__c();
        country.Country_es__c = 'Spanish';
        country.Country_fr__c = 'French';
        country.Name = 'United States';
        country.ISO_Alpha_2_Code__c = 'us';
        country.ISO_Alpha_3_Code__c = 'us';
        country.Geographical_Sub_Region_Segmentation__c = 'Northern America';
        country.IBEN_Segmentation__c = 'IBA';
        country.Regional_Office_Segmentation__c = 'IBA';
        if(isInsert)
            insert country;
        return country;
        
    }
    public static IB_Country_Segmentation__c createCountry(Boolean isInsert ,Account acc){
        IB_Country_Segmentation__c ibs = new IB_Country_Segmentation__c (
            Name = 'Austria', 
            Geographical_Sub_Region_Segmentation__c = 'Europe',
            Regional_Office_Segmentation__c ='IBAEM', 
            IBEN_Segmentation__c = 'IBAEM',
            IBEN_Independent_Account__c = acc.Id
        );
        if(isInsert)
            insert ibs;
        return ibs;
    }
    public static IB_Referee_Feedback__c createFeedback(String roleId ,String conId){
        return new IB_Referee_Feedback__c (
            IB_Contact__c = conId,
            My_Role__c = roleId
        );
    }
    public static IB_Subject__c createSubject(Boolean isInsert){
        IB_Subject__c theSubject = new IB_Subject__c(
            IB_Programme__c = 'CP',
            IB_Programme_Long__c = 'IB Career-related Programme',
            Subject_Group__c = 'Other',
            Subject_Name__c = 'Career related study',
            Subject_Code__c = 'careerstud'
        );
        if(isInsert)
        insert theSubject;
        return theSubject;
    }
    
}