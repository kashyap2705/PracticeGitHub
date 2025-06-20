@isTest
public class EvaluationEventPaymentTest {


    @isTest static void testEvaluationPayment() {
        
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        
        Campaign camp1= new  Campaign();
        camp1.Event_Organizer_Account__c=acc1.id;
        Id RecordTypeIdCampaign = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Evaluation').getRecordTypeId();
        camp1.Name='Return Visit';
        camp1.recordtypeId=RecordTypeIdCampaign;
        camp1.Type='Consultation';
        camp1.Sub_Type__c='Return Visit';
        camp1.StartDate=Date.newInstance(2023, 07, 12);
        camp1.EndDate=Date.newInstance(2024, 07, 11);
        camp1.Status='Staffing_Event_Status__c';
        camp1.Programme_Combination_Evaluation_Visits__c='IB only';
        camp1.Name='Candidacy Consultation Visit';
        insert camp1;
        
        Staffing_Event__c staffEvent= new Staffing_Event__c();
        staffEvent.IB_Event__c=camp1.Id;
        staffEvent.Name='Return Visit Event';
        insert staffEvent;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', acc1);
        insert country;
        
        Contact con1 = TestsUtil.createContact('test_contact_001', 'xxx@xxxx.xxx', 'xxx@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
        con1.OtherStreet = 'other_street';
        con1.OtherCity = 'other_city';
        //con1.OtherState = 'other_state';
        con1.OtherPostalCode = 'postal';
        con1.OtherCountry = 'Austria';
        con1.Country__c = country.id;
        insert con1;
        
        
        
        IB_Role_Repository__c repo= new IB_Role_Repository__c();
        repo.Available__c=true;
        repo.SF_Role_Application__c=true;
        repo.CurrencyIsoCode='EUR';
        repo.Role_Name__c='Programme Leader';
        repo.Category__c='School Services';
        repo.Role_Level__c='Fully Qualified';
        repo.Sub_Category__c='Evaluation & Authorization';
        repo.Related_Programmes__c='PYP;MYP;DP;CP;IBCC';
        repo.Available_in_Region__c='Global';
        repo.Training_Model__c = 'Advanced Training';
        repo.IB_Staff_Role__c=true;
        insert repo;
        
        
        IB_Role__c ibRole1 = TestsUtil.createIbRole(repo.Id, con1.Id);
        insert new List<IB_Role__c> {ibRole1};
            
            
            My_Staffing_Event__c assignment= new My_Staffing_Event__c();
        assignment.Application_Status__c='Confirmed';
        assignment.IB_Contact__c=con1.id;
        assignment.IB_Event__c=camp1.id;
        assignment.Staffing_Event__c=staffEvent.Id;
        assignment.IB_Role__c=repo.id;
        assignment.Chair__c= false;
        insert assignment;
        
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=Date.newInstance(2023, 07, 01),
                                                                               Effective_End_Date__c=Date.newInstance(2024, 06, 30), Event_Record_Type__c='Evaluation', Event_Type__c='Consultation',
                                                                               Event_Sub_type__c='Return Visit', Fees_Name__c='Evaluation Leader or Programme Leader (Return Visit)',
                                                                               IB_Programme__c='MYP', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY23/24',
                                                                               Account__c='2812', Task_Code__c='M1.2.1.1');
        insert fees;
        
        test.startTest();
        EvalutionEventPayment.evalutionEventPaymentCreation(camp1.id);
        test.stopTest();
        
        /** fees.Event_Protocol__c='IB only';
update fees;

test.startTest();
EvalutionEventPayment.evalutionEventPaymentCreation(camp1.id);
test.stopTest();**/
        
    }
    
    @isTest static void testEvaluationPayment1() {
        
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc1.Region__c='IBA';
        insert acc1;
        
        Campaign camp1= new  Campaign();
        camp1.Event_Organizer_Account__c=acc1.id;
        Id RecordTypeIdCampaign = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Evaluation').getRecordTypeId();
        camp1.Name='Return Visit';
        camp1.recordtypeId=RecordTypeIdCampaign;
        camp1.Type='Consultation';
        camp1.Sub_Type__c='Return Visit';
        camp1.StartDate=Date.newInstance(2023, 07, 12);
        camp1.EndDate=Date.newInstance(2024, 07, 11);
        camp1.Status='Staffing_Event_Status__c';
        camp1.Programme_Combination_Evaluation_Visits__c='IB only';
        camp1.Name='Candidacy Consultation Visit';
        camp1.Venue_Account__c=acc1.Id;
        insert camp1;
        
        Staffing_Event__c staffEvent= new Staffing_Event__c();
        staffEvent.IB_Event__c=camp1.Id;
        staffEvent.Name='Return Visit Event';
        insert staffEvent;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', acc1);
        insert country;
        
        Contact con1 = TestsUtil.createContact('test_contact_001', 'xxx@xxxx.xxx', 'xxx@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
        con1.OtherStreet = 'other_street';
        con1.OtherCity = 'other_city';
        //con1.OtherState = 'other_state';
        con1.OtherPostalCode = 'postal';
        con1.OtherCountry = 'Austria';
        con1.Country__c = country.id;
        insert con1;
        
        
        
        IB_Role_Repository__c repo= new IB_Role_Repository__c();
        repo.Available__c=true;
        repo.SF_Role_Application__c=true;
        repo.CurrencyIsoCode='EUR';
        repo.Role_Name__c='Programme Leader';
        repo.Category__c='School Services';
        repo.Role_Level__c='Fully Qualified';
        repo.Sub_Category__c='Evaluation & Authorization';
        repo.Related_Programmes__c='PYP;MYP;DP;CP;IBCC';
        repo.Available_in_Region__c='Global';
        repo.Training_Model__c = 'Advanced Training';
        repo.IB_Staff_Role__c=true;
        insert repo;
        
        
        IB_Role__c ibRole1 = TestsUtil.createIbRole(repo.Id, con1.Id);
        insert new List<IB_Role__c> {ibRole1};
            
            
            IB_Event_Role__c ibEventRole = new IB_Event_Role__c();
        ibEventRole.Staffing_Event__c=staffEvent.id;
        ibEventRole.IB_Event__c=camp1.id;
        ibEventRole.IB_Role__c=repo.id;
        ibEventRole.IB_Programme__c='MYP';
        insert ibEventRole;
        
        
        My_Staffing_Event__c assignment= new My_Staffing_Event__c();
        assignment.Application_Status__c='Confirmed';
        assignment.IB_Contact__c=con1.id;
        assignment.IB_Event__c=camp1.id;
        assignment.Staffing_Event__c=staffEvent.Id;
        assignment.IB_Role__c=repo.id;
        assignment.Chair__c= false;
        assignment.IB_Event_Role__c=ibEventRole.id;
        insert assignment;
        
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=Date.newInstance(2023, 07, 01),
                                                                               Effective_End_Date__c=Date.newInstance(2024, 06, 30), Event_Record_Type__c='Evaluation', Event_Type__c='Consultation',
                                                                               Event_Sub_type__c='Return Visit', Fees_Name__c='Evaluation Leader or Programme Leader (Return Visit)',
                                                                               IB_Programme__c='MYP', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY23/24',
                                                                               Account__c='2812', Task_Code__c='M1.2.1.1',Event_Protocol__c='IB only');
        insert fees;
        
        test.startTest();
        EvalutionEventPayment.evalutionEventPaymentCreation(camp1.id);
        test.stopTest();
        
        
        
    }
    
    
    @isTest static void testEvaluationPayment2() {
        
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc1.Region__c='IBA';
        insert acc1;
        
        Campaign camp1= new  Campaign();
        camp1.Event_Organizer_Account__c=acc1.id;
        Id RecordTypeIdCampaign = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Evaluation').getRecordTypeId();
        camp1.Name='Return Visit';
        camp1.recordtypeId=RecordTypeIdCampaign;
        camp1.Type='Evaluation';
        camp1.Sub_Type__c='Evaluation Visit';
        camp1.StartDate=Date.newInstance(2023, 07, 12);
        camp1.EndDate=Date.newInstance(2024, 07, 11);
        camp1.Status='Staffing_Event_Status__c';
        camp1.Programme_Combination_Evaluation_Visits__c='IB only';
        camp1.Name='Evaluation Visit';
        camp1.Venue_Account__c=acc1.Id;
        insert camp1;
        
        
        
        Staffing_Event__c staffEvent= new Staffing_Event__c();
        staffEvent.IB_Event__c=camp1.Id;
        staffEvent.Name='Evaluation Visit';
        insert staffEvent;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', acc1);
        insert country;
        
        Contact con1 = TestsUtil.createContact('test_contact_001', 'xxx@xxxx.xxx', 'xxx@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
        con1.OtherStreet = 'other_street';
        con1.OtherCity = 'other_city';
        //con1.OtherState = 'other_state';
        con1.OtherPostalCode = 'postal';
        con1.OtherCountry = 'Austria';
        con1.Country__c = country.id;
        insert con1;
        
        Contact con11 = TestsUtil.createContact('test1_contact_001', 'xx1x@xxxx.xxx', 'xx1x@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
        con11.OtherStreet = 'other_street';
        con11.OtherCity = 'other_city';
        //con11.OtherState = 'other_state';
        con11.OtherPostalCode = 'postal';
        con11.OtherCountry = 'Austria';
        con11.Country__c = country.id;
        insert con11;
        
        
        
        IB_Role_Repository__c repo= new IB_Role_Repository__c();
        repo.Available__c=true;
        repo.SF_Role_Application__c=true;
        repo.CurrencyIsoCode='EUR';
        repo.Role_Name__c='Programme Leader';
        repo.Category__c='School Services';
        repo.Role_Level__c='Fully Qualified';
        repo.Sub_Category__c='Evaluation & Authorization';
        repo.Related_Programmes__c='PYP;MYP;DP;CP;IBCC';
        repo.Available_in_Region__c='Global';
        repo.Training_Model__c = 'Advanced Training';
        repo.IB_Staff_Role__c=true;
        insert repo;
        
        
        IB_Role__c ibRole1 = TestsUtil.createIbRole(repo.Id, con1.Id);
        insert new List<IB_Role__c> {ibRole1};
            
            
            IB_Event_Role__c ibEventRole = new IB_Event_Role__c();
        ibEventRole.Staffing_Event__c=staffEvent.id;
        ibEventRole.IB_Event__c=camp1.id;
        ibEventRole.IB_Role__c=repo.id;
        ibEventRole.IB_Programme__c='MYP';
        insert ibEventRole;
        
        
        My_Staffing_Event__c assignment= new My_Staffing_Event__c();
        assignment.Application_Status__c='Confirmed';
        assignment.IB_Contact__c=con1.id;
        assignment.IB_Event__c=camp1.id;
        assignment.Staffing_Event__c=staffEvent.Id;
        assignment.IB_Role__c=repo.id;
        assignment.Chair__c= false;
        assignment.IB_Event_Role__c=ibEventRole.id;
        insert assignment;
        
        My_Staffing_Event__c assignment1= new My_Staffing_Event__c();
        assignment1.Application_Status__c='Confirmed';
        assignment1.IB_Contact__c=con1.id;
        assignment1.IB_Event__c=camp1.id;
        assignment1.Staffing_Event__c=staffEvent.Id;
        assignment1.IB_Role__c=repo.id;
        assignment1.Chair__c= false;
        assignment1.IB_Event_Role__c=ibEventRole.id;
        insert assignment1;
        
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=Date.newInstance(2023, 07, 01),
                                                                               Effective_End_Date__c=Date.newInstance(2024, 06, 30), Event_Record_Type__c='Evaluation', Event_Type__c='Evaluation',
                                                                               Event_Sub_type__c='Evaluation Visit', Fees_Name__c='Evaluation Leader (Parent only)',
                                                                               IB_Programme__c='MYP', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY23/24',
                                                                               Account__c='2812', Task_Code__c='M1.2.1.1',Event_Protocol__c='IB only');
        insert fees;
        
        test.startTest();
        EvalutionEventPayment.evalutionEventPaymentCreation(camp1.id);
        test.stopTest();
        
        
        
    }
    
    @isTest static void testEvaluationPayment3() {
        
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc1.Region__c='IBA';
        insert acc1;
        
        Campaign camp1= new  Campaign();
        camp1.Event_Organizer_Account__c=acc1.id;
        Id RecordTypeIdCampaign = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Evaluation').getRecordTypeId();
        camp1.recordtypeId=RecordTypeIdCampaign;
        camp1.Type='Evaluation';
        camp1.Sub_Type__c='Evaluation Visit';
        camp1.StartDate=Date.newInstance(2023, 07, 12);
        camp1.EndDate=Date.newInstance(2024, 07, 11);
        camp1.Status='Staffing_Event_Status__c';
        camp1.Programme_Combination_Evaluation_Visits__c='IB only';
        camp1.Name='Evaluation Visit';
        camp1.Venue_Account__c=acc1.Id;
        insert camp1;
        
        
        
        Staffing_Event__c staffEvent= new Staffing_Event__c();
        staffEvent.IB_Event__c=camp1.Id;
        staffEvent.Name='Evaluation Visit';
        insert staffEvent;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', acc1);
        insert country;
        
        Contact con1 = TestsUtil.createContact('test_contact_001', 'xxx@xxxx.xxx', 'xxx@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
        con1.OtherStreet = 'other_street';
        con1.OtherCity = 'other_city';
        //con1.OtherState = 'other_state';
        con1.OtherPostalCode = 'postal';
        con1.OtherCountry = 'Austria';
        con1.Country__c = country.id;
        insert con1;
        
        Contact con11 = TestsUtil.createContact('test1_contact_001', 'xx1x@xxxx.xxx', 'xx1x@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
        con11.OtherStreet = 'other_street';
        con11.OtherCity = 'other_city';
        //con11.OtherState = 'other_state';
        con11.OtherPostalCode = 'postal';
        con11.OtherCountry = 'Austria';
        con11.Country__c = country.id;
        insert con11;
        
        
        
        IB_Role_Repository__c repo= new IB_Role_Repository__c();
        repo.Available__c=true;
        repo.SF_Role_Application__c=true;
        repo.CurrencyIsoCode='EUR';
        repo.Role_Name__c='Programme Leader';
        repo.Category__c='School Services';
        repo.Role_Level__c='Fully Qualified';
        repo.Sub_Category__c='Evaluation & Authorization';
        repo.Related_Programmes__c='PYP;MYP;DP;CP;IBCC';
        repo.Available_in_Region__c='Global';
        repo.Training_Model__c = 'Advanced Training';
        repo.IB_Staff_Role__c=true;
        insert repo;
        
        
        IB_Role__c ibRole1 = TestsUtil.createIbRole(repo.Id, con1.Id);
        insert new List<IB_Role__c> {ibRole1};
            
            
            IB_Event_Role__c ibEventRole = new IB_Event_Role__c();
        ibEventRole.Staffing_Event__c=staffEvent.id;
        ibEventRole.IB_Event__c=camp1.id;
        ibEventRole.IB_Role__c=repo.id;
        ibEventRole.IB_Programme__c='MYP';
        insert ibEventRole;
        
        
        My_Staffing_Event__c assignment= new My_Staffing_Event__c();
        assignment.Application_Status__c='Confirmed';
        assignment.IB_Contact__c=con1.id;
        assignment.IB_Event__c=camp1.id;
        assignment.Staffing_Event__c=staffEvent.Id;
        assignment.IB_Role__c=repo.id;
        assignment.Chair__c= false;
        assignment.IB_Event_Role__c=ibEventRole.id;
        insert assignment;
        
        My_Staffing_Event__c assignment1= new My_Staffing_Event__c();
        assignment1.Application_Status__c='Confirmed';
        assignment1.IB_Contact__c=con1.id;
        assignment1.IB_Event__c=camp1.id;
        assignment1.Staffing_Event__c=staffEvent.Id;
        assignment1.IB_Role__c=repo.id;
        assignment1.Chair__c= false;
        assignment1.IB_Event_Role__c=ibEventRole.id;
        insert assignment1;
        
        Campaign camp2= new  Campaign();
        camp2.Event_Organizer_Account__c=acc1.id;
        camp2.Name='Preliminary Evaluation Visit';
        camp2.recordtypeId=RecordTypeIdCampaign;
        camp2.Type='Evaluation';
        camp2.Sub_Type__c='Evaluation Visit';
        camp2.StartDate=Date.newInstance(2023, 07, 12);
        camp2.EndDate=Date.newInstance(2024, 07, 11);
        camp2.Status='Staffing_Event_Status__c';
        camp2.Programme_Combination_Evaluation_Visits__c='IB only';
        camp2.Venue_Account__c=acc1.Id;
        camp2.ParentId=camp1.id;
        insert camp2;
        
        system.debug('camp2**'+camp2);
        
        system.debug('camp2**'+camp2.Id);
        
        Staffing_Event__c staffEvent1= new Staffing_Event__c();
        staffEvent1.IB_Event__c=camp2.Id;
        staffEvent1.Name='Preliminary Evaluation Visit';
        insert staffEvent1;
        
        IB_Event_Role__c ibEventRole1 = new IB_Event_Role__c();
        ibEventRole1.Staffing_Event__c=staffEvent1.id;
        ibEventRole1.IB_Event__c=camp2.id;
        ibEventRole1.IB_Role__c=repo.id;
        ibEventRole1.IB_Programme__c='MYP';
        insert ibEventRole1;
        
        My_Staffing_Event__c assignment2= new My_Staffing_Event__c();
        assignment2.Application_Status__c='Confirmed';
        assignment2.IB_Contact__c=con1.id;
        assignment2.IB_Event__c=camp2.Id;
        assignment2.Staffing_Event__c=staffEvent1.Id;
        assignment2.IB_Role__c=repo.id;
        assignment2.Chair__c= false;
        assignment2.IB_Event_Role__c=ibEventRole1.id;
        insert assignment2;
        
        List<My_Staffing_Event__c> insertedEvent=[select id,IB_Event__r.Name,IB_Event__r.ParentId from My_Staffing_Event__c where id=:assignment2.id limit 1];
        
        system.debug('assignment2**'+assignment2);
        system.debug('assignment2**'+assignment2.IB_Event__r.Name + 'insertedEvent**'+insertedEvent[0].IB_Event__r.Name);
        system.debug('assignment2**'+assignment2.IB_Event__r.ParentId+ 'insertedEvent ParentId**'+insertedEvent[0].IB_Event__r.ParentId);
        
        
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=Date.newInstance(2023, 07, 01),
                                                                               Effective_End_Date__c=Date.newInstance(2024, 06, 30), Event_Record_Type__c='Evaluation', Event_Type__c='Evaluation',
                                                                               Event_Sub_type__c='Evaluation Visit', Fees_Name__c='Programme Leader',
                                                                               IB_Programme__c='MYP', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY23/24',
                                                                               Account__c='2812', Task_Code__c='M1.2.1.1',Event_Protocol__c='IB only');
        insert fees;
        
        IBEN_Honorarium_Fees_Table__c fees1 = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=Date.newInstance(2023, 07, 01),
                                                                                Effective_End_Date__c=Date.newInstance(2024, 06, 30), Event_Record_Type__c='Evaluation', Event_Type__c='Evaluation',
                                                                                Event_Sub_type__c='Evaluation Visit', Fees_Name__c='Programme Leader',
                                                                                IB_Programme__c='MYP', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY23/24',
                                                                                Account__c='2812', Task_Code__c='M1.2.1.1',Event_Protocol__c='IB only');
        insert fees1;
        
        test.startTest();
        EvalutionEventPayment.evalutionEventPaymentCreation(camp1.id);
        test.stopTest();
        
        
        
    }
    
    @isTest static void testEvaluationPayment4() {
        
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc1.Region__c='IBA';
        insert acc1;
        
        Campaign camp1= new  Campaign();
        camp1.Event_Organizer_Account__c=acc1.id;
        Id RecordTypeIdCampaign = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Evaluation').getRecordTypeId();
        camp1.recordtypeId=RecordTypeIdCampaign;
        camp1.Type='Evaluation';
        camp1.Sub_Type__c='Multiple Programme Evaluation Visit';
        camp1.StartDate=Date.newInstance(2023, 07, 12);
        camp1.EndDate=Date.newInstance(2024, 07, 11);
        camp1.Status='Staffing_Event_Status__c';
        camp1.Programme_Combination_Evaluation_Visits__c='IB only';
        camp1.Name='Multiple Programme Evaluation Visit';
        camp1.Venue_Account__c=acc1.Id;
        insert camp1;
        
        
        
        Staffing_Event__c staffEvent= new Staffing_Event__c();
        staffEvent.IB_Event__c=camp1.Id;
        staffEvent.Name='Multiple Programme Evaluation Visit';
        insert staffEvent;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', acc1);
        insert country;
        
        Contact con1 = TestsUtil.createContact('test_contact_001', 'xxx@xxxx.xxx', 'xxx@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
        con1.OtherStreet = 'other_street';
        con1.OtherCity = 'other_city';
        //con1.OtherState = 'other_state';
        con1.OtherPostalCode = 'postal';
        con1.OtherCountry = 'Austria';
        con1.Country__c = country.id;
        insert con1;
        
        Contact con11 = TestsUtil.createContact('test1_contact_001', 'xx1x@xxxx.xxx', 'xx1x@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
        con11.OtherStreet = 'other_street';
        con11.OtherCity = 'other_city';
        //con11.OtherState = 'other_state';
        con11.OtherPostalCode = 'postal';
        con11.OtherCountry = 'Austria';
        con11.Country__c = country.id;
        insert con11;
        
        
        
        IB_Role_Repository__c repo= new IB_Role_Repository__c();
        repo.Available__c=true;
        repo.SF_Role_Application__c=true;
        repo.CurrencyIsoCode='EUR';
        repo.Role_Name__c='Programme Leader';
        repo.Category__c='School Services';
        repo.Role_Level__c='Fully Qualified';
        repo.Sub_Category__c='Evaluation & Authorization';
        repo.Related_Programmes__c='PYP;MYP;DP;CP;IBCC';
        repo.Available_in_Region__c='Global';
        repo.Training_Model__c = 'Advanced Training';
        repo.IB_Staff_Role__c=true;
        insert repo;
        
        
        IB_Role__c ibRole1 = TestsUtil.createIbRole(repo.Id, con1.Id);
        insert new List<IB_Role__c> {ibRole1};
            
            
            IB_Event_Role__c ibEventRole = new IB_Event_Role__c();
        ibEventRole.Staffing_Event__c=staffEvent.id;
        ibEventRole.IB_Event__c=camp1.id;
        ibEventRole.IB_Role__c=repo.id;
        ibEventRole.IB_Programme__c='MYP';
        insert ibEventRole;
        
        
        My_Staffing_Event__c assignment= new My_Staffing_Event__c();
        assignment.Application_Status__c='Confirmed';
        assignment.IB_Contact__c=con1.id;
        assignment.IB_Event__c=camp1.id;
        assignment.Staffing_Event__c=staffEvent.Id;
        assignment.IB_Role__c=repo.id;
        assignment.Chair__c= true;
        assignment.IB_Event_Role__c=ibEventRole.id;
        insert assignment;
        
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=Date.newInstance(2023, 07, 01),
                                                                               Effective_End_Date__c=Date.newInstance(2024, 06, 30), Event_Record_Type__c='Evaluation', Event_Type__c='Evaluation',
                                                                               Event_Sub_type__c='Multiple Programme Evaluation Visit', Fees_Name__c='Multi-programme Chair (Child only)',
                                                                               IB_Programme__c='MYP', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY23/24',
                                                                               Account__c='2812', Task_Code__c='M1.2.1.1',Event_Protocol__c='IB only');
        insert fees;
        
        
        test.startTest();
        EvalutionEventPayment.evalutionEventPaymentCreation(camp1.id);
        test.stopTest();
        
        
        
    }
    
    
}