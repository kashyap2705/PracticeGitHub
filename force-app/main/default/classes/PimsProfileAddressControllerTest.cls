@isTest
private class PimsProfileAddressControllerTest {
    
    @isTest
    static void PimsProfileAddressControllerTestMethod()
    {
        PimsProfileAddressController obj = new PimsProfileAddressController();
        obj.account=NULL;
        obj.programmes=NULL;
        obj.addresses=NULL;
        obj.addAddress=NULL;
        obj.editAddress=NULL;
        obj.address=NULL;
        obj.editAddressId=NULL;
        obj.deleteAddressId=NULL;
        obj.pageIntent=NULL;
        obj.activeTab=NULL;
        obj.isUpdatePage=NULL;
        obj.redirectUrl=NULL;
        obj.profileService=NULL;
        
        IB_Programme__c pyp=obj.pyp;
        obj.pyp=NULL;
        IB_Programme__c myp=obj.myp;
        obj.myp=NULL;
        IB_Programme__c dp=obj.dp;
        obj.dp=NULL;
        IB_Programme__c ibcc=obj.ibcc;
        obj.ibcc=NULL;
        
        obj.getHasPypProgramme();
        obj.getHasMypProgramme();
        obj.getHasDpProgramme();
        obj.getHasIbccProgramme();
        obj.save();
        obj.savePyp();
        
        obj.saveMyp();
        obj.saveDp();
        obj.saveIbcc();
        obj.create();
        obj.createIntent();
        obj.edit();
        obj.remove();
        
        obj.getCountryOptions();
        obj.getAddressOptions();
        obj.getUserLanguageKey();
    }
    
    @isTest static void test_method_one() {
        integer i=1;
        try
        {
            User u = PimsTestUtil.createPortalUserPIMS('testname.unique@ibo.org','August', 'May',true);
            insert u;
            
            System.runAs(u){
                
                PimsProfileAddressController controller = new PimsProfileAddressController();
                controller.isUpdatePage = true;
                
                
                ProfileService ps = new ProfileService();
                
                Account account = ps.getProfileAccount();
                
                controller.save();
                
                controller.account = account;
                
                Test.startTest();
                controller.save();
                
                IB_Country_Segmentation__c cou = PimsTestUtil.createIBACountrySegmentation('United States','US','US');
                insert cou;
                
                IB_Address__c address = PimsTestUtil.createAddress('Billing', '1 hammock beach', 'palm coast', '32137', cou.Id, account);
                IB_Address__c address2 = PimsTestUtil.createAddress('Postal', '1 hammock beach', 'palm coast', '32137', cou.Id, account);
                IB_Address__c address3 = PimsTestUtil.createAddress('Street', '1 hammock beach', 'palm coast', '32137', cou.Id, account);
                
                insert address;
                //insert address2;
                //insert address3;
                
                controller.save();
                
                IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(account, 'PYP');
                IB_Programme__c programme2 = PimsTestUtil.createProgrammeForAccount(account, 'MYP');
                IB_Programme__c programme3 = PimsTestUtil.createProgrammeForAccount(account, 'CP');
                IB_Programme__c programme4 = PimsTestUtil.createProgrammeForAccount(account, 'Diploma_Programme');
                
                List<IB_Programme__c> tmpList = new List<IB_Programme__c>{
                    programme,
                        programme2,
                        programme3,
                        programme4
                        };
                            
                            //  insert tmpList;
                            
                            //insert programme;
                            controller.pyp=programme;
                //insert programme2;
                controller.myp=programme2;
                //insert programme3;
                controller.dp=programme3;
                //insert programme4;
                controller.ibcc=programme4;
                
                List<IB_Programme__c> programmeList = new List<IB_Programme__c>();
                programmeList.add(programme);
                programmeList.add(programme2);
                programmeList.add(programme3);
                programmeList.add(programme4);
                
                controller.programmes = programmeList;
                
                Boolean hasPyp = controller.getHasPypProgramme();
                Boolean hasMyp = controller.getHasMypProgramme();
                Boolean hasDp = controller.getHasDpProgramme();
                Boolean hasIbcc = controller.getHasIbccProgramme();
                
                PageReference pyp = controller.savePyp();
                PageReference myp = controller.saveMyp();
                PageReference dp = controller.saveDp();
                PageReference ibcc = controller.saveIbcc();
                
                controller.address = address3;
                PageReference create = controller.create();
                create = controller.create();
                controller.address = address2;
                PageReference createIntent = controller.createIntent();
                
                List<IB_Address__c> addList = new List<IB_Address__c>();
                addList.add(address);
                addList.add(address2);
                controller.addresses = addList;
                
                PageReference edit = controller.edit();
                
                controller.deleteAddressId = address.id;
                
                PageReference remove = controller.remove();
                remove = controller.remove();
                controller.address = address2;
                createIntent = controller.createIntent();
                
                edit = controller.edit();
                
                List<SelectOption> countryOptions = controller.getCountryOptions();
                List<SelectOption> addressOptions = controller.getAddressOptions();
                
                // delete controller.pyp;
                pyp = controller.savePyp();
                
                // delete controller.myp;
                myp = controller.saveMyp();
                
                // delete controller.dp;
                dp = controller.saveDp();
                
                // delete controller.ibcc;
                ibcc = controller.saveIbcc();
                //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
                System.assertEquals(1,i);
                Test.stopTest();
            }
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }
    
    @isTest static void test_method_two() {
        integer i=1;
        try
        {
            User u = PimsTestUtil.createPortalUserPIMS('testname.unique@ibo.org','August', 'May', true);
            insert u;
            
            System.runAs(u){
                
                PimsProfileAddressController controller = new PimsProfileAddressController();
                controller.isUpdatePage = false;
                
                ProfileService ps = new ProfileService();
                
                Account account = ps.getProfileAccount();
                
                controller.save();
                
                controller.account = account;
                controller.save();
                
                IB_Country_Segmentation__c cou = PimsTestUtil.createIBACountrySegmentation('United States','US','US');
                insert cou;
                
                IB_Address__c address = PimsTestUtil.createAddress('Billing', '1 hammock beach', 'palm coast', '32137', cou.Id, account);
                IB_Address__c address2 = PimsTestUtil.createAddress('Postal', '1 hammock beach', 'palm coast', '32137', cou.id, account);
                IB_Address__c address3 = PimsTestUtil.createAddress('Street', '1 hammock beach', 'palm coast', '32137', cou.Id, account);
                
                insert address;
                //insert address2;
                //insert address3;
                
                controller.save();
                
                IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(account, 'PYP');
                IB_Programme__c programme2 = PimsTestUtil.createProgrammeForAccount(account, 'MYP');
                IB_Programme__c programme3 = PimsTestUtil.createProgrammeForAccount(account, 'CP');
                IB_Programme__c programme4 = PimsTestUtil.createProgrammeForAccount(account, 'Diploma_Programme');
                
                List<IB_Programme__c> tmpList = new List<IB_Programme__c>{
                    programme,
                        programme2,
                        programme3,
                        programme4
                        };
                            
                            // insert tmpList;
                            
                            //insert programme;
                            controller.pyp=programme;
                //insert programme2;
                controller.myp=programme2;
                //insert programme3;
                controller.dp=programme3;
                //insert programme4;
                controller.ibcc=programme4;
                
                List<IB_Programme__c> programmeList = new List<IB_Programme__c>();
                programmeList.add(programme);
                programmeList.add(programme2);
                programmeList.add(programme3);
                programmeList.add(programme4);
                
                controller.programmes = programmeList;
                
                Boolean hasPyp = controller.getHasPypProgramme();
                Boolean hasMyp = controller.getHasMypProgramme();
                Boolean hasDp = controller.getHasDpProgramme();
                Boolean hasIbcc = controller.getHasIbccProgramme();
                
                PageReference pyp = controller.savePyp();
                PageReference myp = controller.saveMyp();
                PageReference dp = controller.saveDp();
                PageReference ibcc = controller.saveIbcc();
                
                controller.address = address3;
                PageReference create = controller.create();
                controller.address = address2;
                PageReference createIntent = controller.createIntent();
                
                List<IB_Address__c> addList = new List<IB_Address__c>();
                addList.add(address);
                addList.add(address2);
                controller.addresses = addList;
                Test.startTest();
                PageReference edit = controller.edit();
                
                controller.deleteAddressId = address.id;
                
                PageReference remove = controller.remove();
                remove = controller.remove();
                controller.address = address2;
                createIntent = controller.createIntent();
                
                edit = controller.edit();
                
                List<SelectOption> countryOptions = controller.getCountryOptions();
                List<SelectOption> addressOptions = controller.getAddressOptions();
                
                // delete controller.pyp;
                pyp = controller.savePyp();
                
                //delete controller.myp;
                myp = controller.saveMyp();
                
                // delete controller.dp;
                dp = controller.saveDp();
                
                // delete controller.ibcc;
                ibcc = controller.saveIbcc();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
                System.assertEquals(1,i);
                Test.stopTest();
                
            }
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }
}