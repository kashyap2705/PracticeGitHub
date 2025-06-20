public with sharing class ContactsWithRolesNoUsers {
    
    public List<Contact> contactsWithRoles{
        get{
            return (List<Contact>) setContacts.getRecords();
        }
        set;
    }

    public ApexPages.StandardSetController setContacts {get;set;}

    public List<SelectOption> rolesForFilter {get;set;}


    public ContactsWithRolesNoUsers() {
        PageReference pageRef = ApexPages.currentPage();
        rolesForFilter = new List<SelectOption>();
        rolesForFilter.add(new SelectOption('', '-All-'));
        for(IB_Role_Repository__c r : [SELECT Id, Role_Name__c FROM IB_Role_Repository__c]){
            rolesForFilter.add(new SelectOption(r.Id,r.Role_Name__c));
        }
        SelectOptionSorter.doSort(rolesForFilter, SelectOptionSorter.FieldToSort.Label);
        init();
    }

    public Integer pageSize = 200;
    public Integer resultSize {get;set;}
    public String roleName {get;set;}

    public void init() {
        setContacts = New ApexPages.StandardSetController(
                        Database.getQueryLocator([SELECT Id, Name,
                                                  (
                                                    SELECT Programme_Selection__c, IB_Role_Name__c, IB_Account__r.Name, End_Date__c
                                                    FROM IBEN_Roles1__r
                                                    WHERE Status__c = 'Confirmed'
                                                    AND (End_Date__c = null OR End_Date__c > TODAY)
                                                  )
                                                FROM Contact
                                                WHERE Id not in (SELECT ContactId FROM User Where isActive = true)
                                                AND Id in (SELECT IB_Contact__c 
                                                           FROM IB_Role__c 
                                                           WHERE Status__c = 'Confirmed' 
                                                           AND (End_Date__c = null OR End_Date__c > TODAY)) ORDER BY Name LIMIT 10000 ]));

        setContacts.setPageSize(pageSize);
        resultSize = setContacts.getResultSize();
    }

    public void filter() {
        system.debug('1.' + roleName);
        if(roleName != null && roleName != ''){
            system.debug('2.' + roleName);
            String query =  'SELECT Id, Name, ' + 
                            '  ( ' +
                            '    SELECT Programme_Selection__c, IB_Role_Name__c, IB_Account__r.Name, End_Date__c ' + 
                            '    FROM IBEN_Roles1__r ' +
                            '    WHERE Status__c = \'Confirmed\' ' + 
                            '    AND (End_Date__c = null OR End_Date__c > TODAY) ' + 
                            //'    AND IB_Role__c = \'' + roleName +  '\'' + 
                            '  ) ' +
                            ' FROM Contact ' + 
                            ' WHERE Id not in (SELECT ContactId FROM User Where isActive = true) ' + 
                            ' AND Id in (SELECT IB_Contact__c ' + 
                                       ' FROM IB_Role__c ' + 
                                       ' WHERE Status__c = \'Confirmed\' ' +
                                       ' AND (End_Date__c = null OR End_Date__c > TODAY) ' +
                                       ' AND IB_Role__c = \'' + roleName + '\' ) ORDER BY Name LIMIT 10000';
            system.debug('Query: ' + query);

            setContacts = New ApexPages.StandardSetController(
                        Database.getQueryLocator(query));

            setContacts.setPageSize(pageSize);
            resultSize = setContacts.getResultSize();
        } else{
            init();
        }



    }

    public void first() {
        setContacts.first();
    }

    public void last(){
        if(resultSize > 0){
            Integer numberOfPages = (Integer)Math.ceil((Decimal)resultSize/(Decimal)pageSize);
            setContacts.setPageNumber(numberOfPages);
        }
    }

    public void previous(){
        setContacts.previous();
    }

    public void next(){
        setContacts.next();
    }

    public Boolean hasNext {
        get {
            return setContacts.getHasNext();
        }
        set;
    }

    public Boolean hasPrevious {
        get{
            return setContacts.getHasPrevious();
        }
        set;
    }

    public Integer pageNumber {
        get {
            return setContacts.getPageNumber();
        }
        set;
    }
}