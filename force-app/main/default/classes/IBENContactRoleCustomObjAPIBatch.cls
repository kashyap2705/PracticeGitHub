global class IBENContactRoleCustomObjAPIBatch implements Database.Batchable<sObject>,Database.Stateful{
    global Map<Id,contact> mapOfContactToProcess = new Map<Id,contact> () ;
    global Map<Id,IB_Role__c> newRoles = new Map<Id,IB_Role__c>();
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        String query = 'Select Id,FirstName__c, LastName__c, Email__c, IB_Code__c,Legal_first_name__c, Legal_Last_name__c,'
            + 'Role_Name__c,IB_Role__c, Programme__c, Birthdate__c, Contact_ID__c, Country_of_Birth__c,Place_of_Birth__c, referenceId__c, Status__c,'
            + 'Request_Processed__c FROM IBENApiRequest__c WHERE Request_Processed__c = false';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc,List< IBENApiRequest__c> apiRequestList)    {
        System.debug('apiRequestList Size '+apiRequestList.Size());
        processApiRequest(apiRequestList);
        List<IB_Role__c> newRolesList = new List<IB_Role__c>();
        Map<Id,Id> apiRequestMap = new Map<Id,Id>();
        List<IBENApiRequest__c> requestList = new List<IBENApiRequest__c>();
        
        Id RoleRecordTypeId = Schema.getGlobalDescribe().get('IB_Role__c').getDescribe().getRecordTypeInfosByName().get('Confirmed').getRecordTypeId();
        
        List<Contact> getUnprocessedContactList = new List<Contact>();
        getUnprocessedContactList = [Select Id,IBENApiRequest__c, IBENApiRequest__r.Programme__c,IBENApiRequest__r.IB_role__c from Contact 
                                     where IBENApiRequest__c != null AND IBENApiRequest__c IN :apiRequestList];
        System.debug('getUnprocessedContactList Size: '+getUnprocessedContactList.Size());
        for(Contact c: getUnprocessedContactList){
            IB_Role__c newrole = new IB_Role__c();
            newrole.RecordTypeId = RoleRecordTypeId;
            newrole.Status__c = 'Confirmed';
            newrole.Reason_For_Status__c = 'Confirmed'; 
            newrole.Active__c=true;
            //via API
            if(c.IBENApiRequest__r.Programme__c == 'MYP' || c.IBENApiRequest__r.Programme__c == 'DP')
                newrole.Programme_Selection__c = c.IBENApiRequest__r.Programme__c; 
            else 
                newrole.Programme_Selection__c = 'DP';
            newrole.IB_Role__c = c.IBENApiRequest__r.IB_role__c;
            newrole.IB_Contact__c = c.Id;
            apiRequestMap.put(c.IBENApiRequest__c,c.Id);
            newRolesList.add(newRole);
        }
        
        if(newRolesList.size()>0){
            System.debug('newRolesList Size '+newRolesList.Size());
            try{
                insert newRolesList;
                newRoles.putall(newRolesList);
            }catch(Exception e){
                System.debug('Exception:' + e.getMessage());
            }
        }
        
        if(apiRequestMap.size()>0)
        {
            for(IBENApiRequest__c apiReq: [Select Id from IBENApiRequest__c where Id in :apiRequestMap.keySet()]){
                apiReq.Contact_ID__c = apiRequestMap.get(apiReq.Id);
                apiReq.Request_Processed__c = true;
                requestList.add(apiReq);
            }
            System.debug('requestList Size '+requestList.Size());
            
            try{
                update requestList;
            }catch(Exception e){
                System.debug('Exception:' + e.getMessage());
            }
            System.debug('requestList updated');
        }
    }
    
    global void finish(Database.BatchableContext bc){
        Id batchJobId = Database.executeBatch(new CreateUserBatch(newRoles,mapOfContactToProcess), 1);
        System.debug('newRoles SizeB '+newRoles);
        System.debug('mapOfContactToProcess SizeB '+mapOfContactToProcess);        
        
        Datetime dt = system.now().addMinutes(5);
        String day = string.valueOf(dt.day());
        String month = string.valueOf(dt.month());
        String hour = string.valueOf(dt.hour());
        String minute = string.valueOf(dt.minute());
        String second = '00';
        String year = string.valueOf(system.now().year());
        String strJobName = 'ScheduleIBENContactRoleAPIBatch  -' + year + '-' + month + '-' + 
        day + ' ' + hour + ':' + minute + ':' + second;
        String strSchedule = '00 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
        System.schedule(strJobName, strSchedule, new ScheduleIBENContactRoleAPIBatch ());

    }
    
    void processApiRequest(List< IBENApiRequest__c> apiRequestList){
        IB_Role__c newrole = new IB_Role__c();
        List<IB_Role__c> newRoleListwithContacts = new List<IB_Role__c>();
        List<Contact> newContactList = new List<Contact>();
        
        Id ContactRecordTypeId = Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId();
        Id RoleRecordTypeId = Schema.getGlobalDescribe().get('IB_Role__c').getDescribe().getRecordTypeInfosByName().get('Confirmed').getRecordTypeId();
        
        List<Account> accountList = new List<Account>([Select Id from Account where Name ='IBEN Global' LIMIT 1 FOR UPDATE]);
        ID accountId;
        accountId = accountList[0].id;
        
        List< IBENApiRequest__c> apiRequests = new List< IBENApiRequest__c>();
        List< IBENApiRequest__c> apiwithExistingContactRequests = new List< IBENApiRequest__c>();
        System.debug('apiRequestList Size '+apiRequestList.Size());
        apiRequests = apiRequestList;
        String RequestProcessed;
        for(IBENApiRequest__c request: apiRequests){
            if(request.Contact_ID__c != null )
            {
                //Defaults
                newrole.RecordTypeId = RoleRecordTypeId;
                newrole.Status__c = 'Confirmed';
                newrole.Reason_For_Status__c = 'Confirmed'; 
                newrole.Active__c=true;
                //via API
                if(request.Programme__c == 'MYP' || request.Programme__c == 'DP')
                    newrole.Programme_Selection__c = request.Programme__c; 
                else 
                    newrole.Programme_Selection__c = 'DP'; 
                newrole.IB_Role__c = request.IB_Role__c;
                newrole.IB_Contact__c = request.Contact_ID__c;
                request.Request_Processed__c = True;
                apiwithExistingContactRequests.add(request);
                newRoleListwithContacts.add(newrole);
                
            }else if(request.Contact_ID__c == null )
            {
                Contact newContact = new Contact();
                newContact.Contact_Type__c = 'IBEN';
                newContact.AccountId = accountId;
                newContact.RecordTypeId = ContactRecordTypeId; 
                newContact.Join_Date__c = System.today();
                //via API
                newContact.FirstName = request.FirstName__c;
                newContact.LastName = request.LastName__c;
                newContact.Legal_First_Name__c = request.Legal_first_name__c;
                newContact.Legal_Last_Name__c = request.Legal_Last_name__c;
                newContact.Birthdate = request.Birthdate__c;
                newContact.Email = request.Email__c;
                newContact.Country_of_Birth__c = request.Country_of_Birth__c;
                newContact.Birth_Locale__c = request.Place_of_Birth__c;
                newContact.IBENApiRequest__c = request.Id;
                newContactList.add(newContact);
            }
        }
        System.debug('Before newRoleListwithContacts Size '+newRoleListwithContacts.Size());
        if(newRoleListwithContacts.size()>0){
            System.debug('newRoleListwithContacts Size '+newRoleListwithContacts.Size());
            try{
                insert newRoleListwithContacts;
                update apiwithExistingContactRequests;
            }catch(Exception e){
                System.debug('Exception:' + e.getMessage());
            }
        }
        
        System.debug('Before newContactList Size '+newContactList.Size());
        if(newContactList.size()>0){
            System.debug('newContactList Size '+newContactList.Size());
            try{
                insert newContactList;
                mapOfContactToProcess.putall(newContactList);
                System.debug('Insertion done');
                
            }catch(Exception e){
                System.debug('Exception:' + e.getMessage());
            }
        }  
    }
}