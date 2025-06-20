public without sharing class AssociatedSchoolClass {
    public AssociatedSchoolClass() {
    }    
    public static List<WrapAccount> wrapAccountList {get; set;}
    public static List <WrapAssAccount> wrapAssAccountList {get;set;}
    public static boolean renderTrue {get;set;}
    public static List<Account> allSearchedAccount{get;set;}
    

    Private static  list<Account> account = [Select id,Country__c,name,IBIS_ID__c,IB_Transcript_Method__c from Account where id=:[select contact.AccountId from user where id=:userInfo.getUserId()].contact.AccountId AND RecordType.DeveloperName = 'IB World Schools Association Account' limit 1];
    @AuraEnabled (cacheable=true )
    public static List<WrapAssAccount> getAssociatedSchools(String selectedAccountId) {
      wrapAssAccountList= new List<WrapAssAccount>();
        List<SchoolAssociation__c> schoolAccountList = new List<SchoolAssociation__c>();
        WrapAssAccount varAssSchool ;
        if(selectedAccountId !=null){
           schoolAccountList=[Select school_id__c,Association_id__c,school_id__r.name,school_id__r.Country__c,school_id__r.Authorized_School__c,school_id__r.IBIS_ID__c,school_id__r.Authorized_Programmes__c,school_id__r.Candidate_Programmes__c FROM SchoolAssociation__c Where Association_id__c=: selectedAccountId ];
           schoolAccountList.size();
           for(SchoolAssociation__c acc : schoolAccountList){
            varAssSchool = new WrapAssAccount();
            varAssSchool.Name=acc.school_id__r.name;
            varAssSchool.Country=acc.school_id__r.Country__c;
            varAssSchool.Ibis=acc.school_id__r.IBIS_ID__c;
            varAssSchool.Authentic=acc.school_id__r.Authorized_School__c;
            varAssSchool.id=acc.id;
            varAssSchool.SchoolId=acc.school_id__c;
            varAssSchool.AssociationId=acc.Association_id__c;
            wrapAssAccountList.add(varAssSchool);
           }
            return wrapAssAccountList;
        }
        return null;
    }
    @AuraEnabled
    public static void removeAssociationSchool(List<WrapAssAccount> listAccount) {
        List<Id> schoolAssIds= new List<id>();
        try{  
            for(Integer i=0; i<listAccount.size(); i++){
                schoolAssIds.add(listAccount[i].id);
            }
            List<SchoolAssociation__c>accountList=new List<SchoolAssociation__c>();
            for(SchoolAssociation__c account:[SELECT Id FROM SchoolAssociation__c WHERE Id IN:schoolAssIds]){
                
                accountList.add(account);
            }
            
            if(accountList.size()>0){
                delete accountList;
            }
        }
        catch(Exception e){
            System.debug(Logginglevel.ERROR, e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    /********************************************************************
    User Story : Bug 185244: Character limit on SchoolAssociation Name triggers error
    Fixed by : Atticus F.
    Modified Date : 08-12-2022
    Description : Modified existing logic to incorporate below changes
                  1. Name of the Association was modified
                  2. Code refactored as part of techical debt
    ********************************************************************/
    @AuraEnabled
    public static void addAssociationSchool(List<Account> listAccount, String accountId) {
        try{  
            List<SchoolAssociation__c> schoolAssocationLst = new List<SchoolAssociation__c>();
            List<Account> queriedAssociationAccountlst = [SELECT Id,Name,IBIS_ID__c 
                                                          FROM Account 
                                                          WHERE Id =: accountId];
           
            if(!listAccount.isEmpty() && !queriedAssociationAccountlst.isEmpty()){
                for(integer index = 0 ; index < listAccount.size() ; index++){
                    SchoolAssociation__c newSchoolAssociate = new SchoolAssociation__c();
                    newSchoolAssociate.School_Id__c = listAccount[index].Id;
                    newSchoolAssociate.Association_Id__c = queriedAssociationAccountlst[0].Id;
                    //newSchoolAssociate.Name = listAccount[index].name +' '+ accName.name ;
                    String ibisCode = listAccount[index].IBIS_ID__c != Null ? 
                                        listAccount[index].IBIS_ID__c : '';
                    //List of Accounts consist of number of accounts selected from the Lightning UI
                    //AddAssociationSchoolPage Lwc Component
                    newSchoolAssociate.Name = (queriedAssociationAccountlst[0].Name).trim().left(50)
                                             +'-'+ ibisCode ;
                    schoolAssocationLst.add(newSchoolAssociate);
                }
            }
            if(!schoolAssocationLst.isEmpty()){
                Database.SaveResult[] srList = Database.insert(schoolAssocationLst, false);
            }
        }
        catch(Exception e){
            System.debug(Logginglevel.ERROR, e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    // End -- Atticus -- Bug 185244 -- End

    @AuraEnabled (cacheable=true )
    public static  List <Account> searchInfoAssociation(String AccountName,String IBISCode,String selectedCountry, String SelectedState, String selectedAccountId ) {
        List<WrapAssAccount> associatedSchool = getAssociatedSchools(selectedAccountId);
        List<id> schoolids =new List<id>();
        for(Integer i=0;i<associatedSchool.size();i++){
            schoolids.add(associatedSchool[i].SchoolId);
        }
        boolean valid=true;
        renderTrue=true;

        string AccName=AccountName+'%';
        string AccName0=AccountName;
        string accName2='%'+AccountName;
        string accName3='%'+AccountName+'%';
        String searchQuery='SELECT id,Recordtype.Name,Name,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true ';
        if(AccountName!=''){
            searchQuery = searchQuery + 'AND (Name like :AccName OR Name like :accName2 OR Name Like : accName3)'; 
        }
        if(IBISCode!=''){
            searchQuery = searchQuery + 'And IBIS_ID__c=:IBISCode ';
        }
        if(selectedCountry!='--None--'){
            searchQuery = searchQuery + 'And country__c=:selectedCountry ';
        }
        if(SelectedState!='--None--'){
            searchQuery = searchQuery + 'And State_Abbr__c=:SelectedState ';
        }
        searchQuery = searchQuery + 'AND Id NOT IN : schoolids AND Recordtype.Name=\'School Account\' LIMIT 1000';
        allSearchedAccount=  Database.query(searchQuery);
        wrapAccountList = new List<WrapAccount>();
        if(valid){
            for(Account a:allSearchedAccount){
                if(a.RecordType.Name=='School Account'){
                    wrapAccountList.add(new WrapAccount(a));
                }
            }
        }
        return allSearchedAccount;
    }

    public Class WrapAssAccount{
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
        public String Country {get;set;}
        @AuraEnabled
        public String Ibis {get;set;}
        @AuraEnabled
        public Boolean Authentic {get;set;} 
        @AuraEnabled
        public ID id {get;set;}
        @AuraEnabled
        public ID SchoolId {get;set;}
        @AuraEnabled
        public ID AssociationId {get;set;}      
        public WrapAssAccount() {
        }           
    }
    
    public class WrapAccount {
        public Account acc {get; set;}
        public Boolean selected {get; set;}
        public WrapAccount(Account a) {
            acc = a;
            selected = false;
        }
        public WrapAccount() {
        }
    }
}