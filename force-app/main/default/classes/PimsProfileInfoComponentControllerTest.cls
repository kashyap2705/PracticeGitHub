/**     
    * <h1>Test Classes</h1>     
    * This class is responsible for Testing PimsProfileInfoComponentController,PimsProfileContactComponent
    * and EditContactComponentController, US11890.
    * 
    * @author  Abd Ur Rehman        
    * @version 1.0      
    * @since   22-06-2020
    
Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 


*/

@isTest
public class PimsProfileInfoComponentControllerTest 
{

  /**
   * This Method will Create the data and test PimsProfileInfoComponentController class,US11129.
   * @author: Abd Ur Rehman-Plumlogix 
   * @since 22-12-2020
   * @param No parameter.
   * @return No return Type.
*/
    

    @isTest
    Public Static void infoComponent()
    {
         Account acc=new Account ( 
            Name = 'Ahmad',
            Region__c = 'IBAEM',
            Sub_region__c = 'EUROPE', 
            External_PD_Provider__c = true,
            Language_Of_Correspondance__c = 'English',
            Legal_Status__c = 'Private',
            Short_Name__c = 'AS',
            IBIS_ID__c = '000001',
            State_Abbr__c = 'SA',
            Phone = '+9212345607865'
        );
        insert acc;
        PimsProfileInfoComponentController controller=new PimsProfileInfoComponentController();
        controller.getcitynames();
        controller.citySelected='(+51)';
        controller.acc=acc;
        controller.phone = '123456789';
        controller.create2();
        
    }
    
    
    /**
   * This Method will Create the data and test PimsProfileContactComponent and EditContactComponentController class,US11890.
   * @author: Ahmad Shakeel-Plumlogix 
   * @since 22-06-2020
   * @param No parameter.
   * @return No return Type.
*/
    
    @isTest
    public static void PimsProfileContactComponentTestMethod()
    {
        Contact con=new Contact (
            Salutation = 'Mr.',
            LastName = 'Messi',
            MobilePhone = '9212345607865',
            HomePhone = '9212345607865',
            AssistantPhone = '+9212345607865',
            OtherPhone = '9212345607865',
            NoK_Mobile__c = '9212345607865',
            NoK_Phone__c = '9212345607865',
            Permission_Mobile__c = '9212345607865',
            Permission_Phone__c = '9212345607865',
            Work_Phone_Extension__c = '9212345607865',
            Phone = '92123457865',
            //OtherPhone = '+30992907711',
            Email = 'Email@example.com',
            Birthdate = Date.today().addYears(-20),
            //Country__c = (country == null ? null : country.id),
           
            FirstName = 'FN Leo',
            MailingCity = 'Lviv city',
            MailingStateCode = 'USCA',
            MailingCountryCode = 'US',
            MailingPostalCode = '33016',
            MailingStreet = 'street'
        );
        
        Account acc = TestsUtil.createAccount('Test');
        acc.Region__c = 'IBAEM';
        acc.External_PD_Provider__c = true;
        acc.Phone = '123456789';
        insert acc;
        
        Test.startTest();
        insert con;
        PimsProfileContactComponent control=new PimsProfileContactComponent();
        control.citySelected='Albania (+355)';
        control.getcitynames();
        control.addstep = 'abc';
        control.phone = '92123457865';
        control.Conphone=con;
        control.create();
        EditContactComponentController control2=new EditContactComponentController();
        control2.citySelected='Albania (+355)';
        control2.getcitynames();
        control2.Conphone=con;
        control2.phone  = '92123457865';
        control2.create();
        control2.addStep = 'adc';
        control2.phone = '1234';
        control2.create();
        pimsprofileinfocomponentcontroller control3 = new pimsprofileinfocomponentcontroller();
        control3.citySelected='Albania (+355)';
        control3.acc = acc;
        control3.phone  = '92123457865';
        control3.getcitynames();
        control3.create2();
        test.stopTest();
    }
}