@isTest
private class PimsRegisFormControllerTest {
    
    @isTest
    static void validateEvent() {
        List<Account> accList = new List<Account>();
        Account objAccount = new Account();
        objAccount = AccountTestDataFactory.createAccount('School Account',objAccount);
        accList.add(objAccount);
        
        Account schAccount = new Account(Name = 'SchoolAccount', Region__c = 'IBAP', Sub_region__c = 'SOUTH ASIA', CurrencyIsoCode = 'SGD', IBIS_ID__c = '321131');
        schAccount = AccountTestDataFactory.createAccount('School Account',schAccount);
        accList.add(schAccount);
        
        Account providerAccount = new Account(Name = 'IBAP as Provider', Region__c = 'IBAP', Sub_region__c = 'SOUTH ASIA', CurrencyIsoCode = 'SGD', IBIS_ID__c = '321132');
        providerAccount = AccountTestDataFactory.createAccount('IB_Office_Account',providerAccount);
        accList.add(providerAccount);
        insert accList;
        
        Date dd = Date.newInstance(1999, 12, 9);
        
        Contact ObjContact = new Contact(FirstName = 'testing', LastName = 'Firsttest', AccountId = objAccount.Id, Homephone = '+9212345678', Phone = '+9212345678', Email = 'a@a.com', Contact_Type__c = 'IBEN', birthdate = dd);
        
        //insert ObjContact;
        ObjContact = ContactTestDataFactory.createContact('Standard Contact',ObjContact);
        insert ObjContact;
        User objuser = new User(IsActive=true,ContactId = ObjContact.Id);
        objuser = UserTestDataFactory.createUser('External PD Provider',objuser);
        insert objuser;
        
        Object_Field_IDs__c objFI1 = new Object_Field_IDs__c(Name = 'Currency_PD_Provider_Event', Field_ID__c = 'CurrencyIsoCode', Object_API_Name__c = 'PD_Provider_Event__c');
        Object_Field_IDs__c objFI2 = new Object_Field_IDs__c(Name = 'Event_Region__c', Field_ID__c = '00N20000003mYQ1', Object_API_Name__c = 'PD_Provider_Event__c');
        Object_Field_IDs__c objFI3 = new Object_Field_IDs__c(Name = 'Event_Sub_Region__c', Field_ID__c = '00N20000003mYPw', Object_API_Name__c = 'PD_Provider_Event__c');
        
        Object_Field_IDs__c objFI4 = new Object_Field_IDs__c(Name = 'Currency_PD_Provider_Workshop', Field_ID__c = 'CurrencyIsoCode', Object_API_Name__c = 'PD_Provider_Workshop__c');
        Object_Field_IDs__c objFI5 = new Object_Field_IDs__c(Name = 'PD_Provider_Event__c', Field_ID__c = '00N20000003mYQB', Object_API_Name__c = 'PD_Provider_Workshop__c');
        
        insert new list < Object_Field_IDs__c > {objFI1,objFI2,objFI3,objFI4,objFI5};
        PD_Provider_Event__c pdevent = new PD_Provider_Event__c(Name = 'Test',Status__c = 'Draft',Host_School__c = objAccount.Id);
        insert pdEvent;
        
        list < Participant_School__c > pslist = new list < Participant_School__c > ();
        list < Id > accIdlist = new list < Id > ();
        Participant_School__c ps = new Participant_School__c(Name = 'Test',School_Name__c = schAccount.Id,PD_Provider_Event__c = pdEvent.Id);
        pslist.add(ps);
        accIdlist.add(schAccount.Id);
        IB_Country_Segmentation__c ibCon = new IB_Country_Segmentation__c();
        ibCon.IBEN_Independent_Account__c = objAccount.Id;
        ibCon = IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(ibCon);
        ibCon.Name = 'Austria';
        ibCon.Geographical_Sub_Region_Segmentation__c = 'Europe';
        ibCon.Regional_Office_Segmentation__c = 'IBAEM';
        ibCon.IBEN_Segmentation__c = 'IBAEM';
        insert ibCon;
        List<IB_Address__c> addresslist = new List<IB_Address__c>();
        IB_Address__c addressOne = new IB_Address__c();
        addressOne.IB_Account__c = objAccount.Id;
        addressOne.Country__c = ibCon.Id;
        addressOne = IBAddressTestDataFactory.createIBAddress(addressOne);
        addresslist.add(addressOne);
        IB_Address__c addressTwo = new IB_Address__c();
        addressTwo.IB_Account__c = objAccount.Id;
        addressTwo.Country__c = ibCon.Id;
        addressOne = IBAddressTestDataFactory.createIBAddress(addressTwo);
        addresslist.add(addressTwo);
        IB_Address__c addressThree = new IB_Address__c();
        addressThree.IB_Account__c = objAccount.Id;
        addressThree.Country__c = ibCon.Id;
        addressThree = IBAddressTestDataFactory.createIBAddress(addressThree);
        addresslist.add(addressThree);
        insert addresslist;
        System.runAs(objuser) {
            
            test.startTest();
            list < PD_Provider_Event__c > pdevents = PimsRegisFormController.getPDProviderEvents();
            list < PD_Provider_Workshop__c > pdworkshops = PimsRegisFormController.getPDProviderWorkshopList(pdEvent.Id);
            list < IB_Address__c > ibaddresses = PimsRegisFormController.getIBAddresses(objAccount.Id);
            PimsRegisFormController.createParticipatingSchools(pdEvent.Id, accIdlist);
            PimsRegisFormController.createParticipatingSchool(pdEvent.Id, schAccount.Id);
            list<Participant_School__c> relatedPSchools = PimsRegisFormController.relatedParticipatingSchools(pdEvent.Id);
            System.assertEquals(relatedPSchools.size()>0, true,'relatedPSchools not created' );
            Boolean wsExist = PimsRegisFormController.doesWorkshopsExist(pdEvent.Id);
            System.assertEquals(wsExist, false,'workshop exists' );
            List < account > providerlist = PimsRegisFormController.getProviderAccounts();
            System.assertEquals(providerlist.size()>0, true,'Provider Accounts not present' );
            PimsRegisFormController.deleteParticipatingSchools(pdEvent.Id);
            String currentUser = PimsRegisFormController.getUserLocale();
            
            test.stopTest();
        }
    }
}