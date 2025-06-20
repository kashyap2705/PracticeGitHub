@isTest
private class PimsProfileSectionControllerTest {

	@isTest static void test_method_one() {

        integer i=1;
		User u = PimsTestUtil.createPortalUserPIMS('testname.unique@ibo.org','August', 'May',true);
        u.Bypass_Validation_Rules__c = true;
		insert u;

		System.runAs(u){

            
                    
                        
			PimsProfileSectionController controller = new PimsProfileSectionController();
			controller.isUpdatePage = false;

			Account acc = PimsTestUtil.createAccount('Test Account', '');
			insert acc;
           
                
            IB_Country_Segmentation__c ibCon=new  IB_Country_Segmentation__c (                Name = 'Canada', 
                Geographical_Sub_Region_Segmentation__c = 'Europe',
                Regional_Office_Segmentation__c ='IBAEM', 
                IBEN_Segmentation__c = 'IBAEM',
                ISO_Alpha_2_Code__c = 'CA',
                IBEN_Independent_Account__c = acc.Id
            );
            insert ibCon;
              
            IB_Address__c address = new IB_Address__c(
                Name = 'Test',
                Address_Line_1__c = '1 hammock beach',
                City__c = 'palm coast',
                Postal_Code__c = '32137',
                IB_Account__c = acc.Id,
                Status__c = 'Active',
                Province__c = 'AB',
                Country__c = ibCon.id
            );
            //PimsTestUtil.createAddress('Billing', '1 hammock beach', 'palm coast', '32137', cou.Id, account);
            IB_Address__c address2 = new IB_Address__c(
                Name = 'Postal',
                Address_Line_1__c = '1 hammock beach',
                City__c = 'palm coast',
                Postal_Code__c = '32137',
                IB_Account__c = acc.Id,
                Status__c = 'Active',
                Province__c = 'AB',
                Country__c = ibCon.id
            );
            //PimsTestUtil.createAddress('Postal', '1 hammock beach', 'palm coast', '32137', cou.Id, account);
            IB_Address__c address3 = new IB_Address__c(
                Name = 'Street',
                Address_Line_1__c = '1 hammock beach',
                City__c = 'palm coast',
                Postal_Code__c = '32137',
                IB_Account__c = acc.Id,
                Status__c = 'Active',
                Province__c = 'AB',
                Country__c = ibCon.id
            );
            //PimsTestUtil.createAddress('Street', '1 hammock beach', 'palm coast', '32137', cou.Id, account);
            //insert address;
            //insert address2;
            //insert address3;
            
            insert new List<IB_Address__c>{address,address2,address3};
                
                List<IB_Address__c> addressList = new List<IB_Address__c>();
            addressList.add(address);
            
            //List<IB_Address__c> addressesByAccount = ps.getAllAddressesByAccount(acc.Id);
            
            IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(acc, 'PYP');
            
            programme = PimsTestUtil.associateAddressWithProgramme(programme, address, 'billing');
            programme = PimsTestUtil.associateAddressWithProgramme(programme, address2, 'postal');
            programme = PimsTestUtil.associateAddressWithProgramme(programme, address3, 'street');
            programme.Status__c = 'Candidate';
            programme.Date_Decision_on_Candidacy__c = Date.today().addDays(365);
            programme.RecordTypeId = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByName().get('PYP').getRecordTypeId();
            system.debug('recordtypename= ' + programme.recordtype.name);
            programme.Invoice_Date__c = 'Feb 1 2015';
                insert programme;
            
            
            List<IB_Programme__c> programmeList = new List<IB_Programme__c>();
            programmeList.add(programme);

            
            controller.programmes = programmeList;
            
            

			controller.account = acc;
            controller.AcdamicYearString='Historical enrollment data';
            controller.pypProgrammeMgrName='pyp';
            controller.mypProgrammeMgrName='myp';
            controller.dpProgrammeMgrName='dp';
            controller.cpProgrammeMgrName='cp';
            controller.cpProgrammeMgrEmail='cpemail';
            controller.dpProgrammeMgrEmail='dpemail';
            controller.mypProgrammeMgrEmail='';
            controller.pypProgrammeMgrEmail='';
            controller.getAcdemicYearList();
            controller.getUserLanguageKey();

			PageReference save = controller.save();

			SchoolSections__c sec = PimsTestUtil.createSchoolSection('1', '5', acc);

			PageReference create = controller.create();
			create = controller.create();

			SchoolSections__c sec2 = PimsTestUtil.createSchoolSection('6', '8', acc);
			insert sec2;

			List<SchoolSections__c> secList = new List<SchoolSections__c>();
			secList.add(sec2);
			controller.sections = secList;

			save = controller.save();

			PageReference edit = controller.edit();

			controller.deleteSectionId = sec2.Id;

			PageReference remove = controller.remove();
			remove = controller.remove();

			edit = controller.edit();
		}

	}

	@isTest static void test_method_two() {

        integer i=1;
		User u = PimsTestUtil.createPortalUserPIMS('testname.unique@ibo.org','August', 'May',true);
        u.Bypass_Validation_Rules__c = true;
		insert u;

		System.runAs(u){

			PimsProfileSectionController controller = new PimsProfileSectionController();
			controller.isUpdatePage = true;

			Account acc = PimsTestUtil.createAccount('Test Account', '');
			insert acc;

			controller.account = acc;

			PageReference save = controller.save();

			SchoolSections__c sec = PimsTestUtil.createSchoolSection('1', '5', acc);

			PageReference create = controller.create();
			create = controller.create();

			SchoolSections__c sec2 = PimsTestUtil.createSchoolSection('6', '8', acc);
			insert sec2;

			List<SchoolSections__c> secList = new List<SchoolSections__c>();
			secList.add(sec2);
			controller.sections = secList;

			save = controller.save();

			PageReference edit = controller.edit();

			controller.deleteSectionId = sec2.Id;

			PageReference remove = controller.remove();

			remove = controller.remove();

			edit = controller.edit();
			
            
            controller.AcdamicYearString='Historical enrollment data';
            controller.AcdemicYear();
		}

	}

}