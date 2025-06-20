@isTest
public class IbEventControllerclsTest {

    static final String PARENT_STATUS = 'Planned / Ready for Staffing';
    static final String BIND = 'Bind';
    static final String UNBIND = 'unBind';
    static final String START_DATE = '06/21/2016';
    static final String END_DATE = '07/26/2016';
    static final String REGION = 'IBAEM';

    @testSetup
    static void setupData(){

        Recordtype rt = [select id, name from Recordtype where sobjectType = 'campaign' and name = 'Evaluation'];

        Account acc = PimsTestUtil.createAccount('Test Account', 'Association Account' );
        insert acc;

        Campaign camp = new Campaign(
            Name = 'Verification visit',
            Event_Organizer_Account__c = acc.Id,
            Type = 'Authorization',
            Sub_Type__c = 'Verification Visit',
            IB_Docs_ID__c = 'Test',
            Status  = PARENT_STATUS,
            Staffing_Event_Published__c = false,
            Event_Organizer_Region__c = REGION,
            Required_Number_of_Educators__c = 3,
            Venue_Account__c = acc.Id
        );
        insert camp;

        Campaign campChild = new Campaign(
            Name = 'Verification visit',
            Event_Organizer_Account__c = acc.Id,
            IB_Docs_ID__c = 'Test',
            Staffing_Event_Published__c = false,
            Event_Organizer_Region__c = REGION,
            Required_Number_of_Educators__c = 3,
            Venue_Account__c = acc.Id,
            Bundle__c = false,
            Status = 'Pending',
            Type = 'Authorization',
            Sub_Type__c = 'Request for Candidacy',
            RecordTypeID = rt.Id,
            Parentid = camp.Id,
            StartDate = Date.parse('12/27/2013'),
            Enddate = Date.parse('12/28/2013')
        );
        insert campChild;

        Campaign campChild1 = new Campaign(
            Name = 'Verification visit',
            Event_Organizer_Account__c = acc.Id,
            IB_Docs_ID__c = 'Test',
            Staffing_Event_Published__c = false,
            Event_Organizer_Region__c = REGION,
            Required_Number_of_Educators__c = 3,
            Venue_Account__c = acc.Id,
            Bundle__c = true,
            Status = 'Pending',
            Type = 'Authorization',
            Sub_Type__c = 'Request for Candidacy',
            RecordTypeID = rt.Id,
            Parentid = camp.Id,
            StartDate = Date.parse('12/27/2013'),
            Enddate = Date.parse('12/28/2013')
        );
        insert campChild1;
    }
    public static testmethod Void ibEventTestMethod() {

        recordtype rt = [select id, name from recordtype where sobjectType = 'campaign' and name = 'Evaluation'];
        Account acc = PimsTestUtil.createAccount('Test Account', 'Association Account' );
        insert acc;
        Campaign camp = new Campaign(Name = 'Verification visit',
                                     Event_Organizer_Account__c = acc.id,
                                     Type = 'Authorization',
                                     Sub_Type__c = 'Verification Visit',
                                     IB_Docs_ID__c = 'Test',
                                     Status  = 'Planned / Ready for Staffing',
                                     Staffing_Event_Published__c = false,
                                     Event_Organizer_Region__c = 'IBAEM',
                                     Required_Number_of_Educators__c = 3,
                                     Venue_Account__c = acc.id);
        insert camp;
        Campaign campChild = new Campaign(Name = 'Verification visit',
                                          Event_Organizer_Account__c = acc.id,
                                          IB_Docs_ID__c = 'Test',
                                          Staffing_Event_Published__c = false,
                                          Event_Organizer_Region__c = 'IBAEM',
                                          Required_Number_of_Educators__c = 3,
                                          Venue_Account__c = acc.id, Bundle__c = false,
                                          status = 'Pending',
                                          type = 'Authorization',
                                          Sub_Type__c = 'Request for Candidacy', recordTypeID = rt.id, startDate = date.parse('12/27/2013'), enddate = date.parse('12/28/2013')
                                         );
        insert campChild;
        Campaign campChild1 = new Campaign(Name = 'Verification visit',
                                           Event_Organizer_Account__c = acc.id,
                                           IB_Docs_ID__c = 'Test',
                                           Staffing_Event_Published__c = false,
                                           Event_Organizer_Region__c = 'IBAEM',
                                           Required_Number_of_Educators__c = 3,
                                           Venue_Account__c = acc.id, Bundle__c = true,
                                           status = 'Pending',
                                           type = 'Authorization',
                                           Sub_Type__c = 'Request for Candidacy', recordTypeID = rt.id,
                                           parentid = camp.id, startDate = date.parse('12/27/2013'), enddate = date.parse('12/28/2013')
                                          );
        insert campChild1;

        apexpages.currentpage().getparameters().put('type', 'Bind');
        apexpages.currentpage().getparameters().put('stdt', '12/27/2013');
        apexpages.currentpage().getparameters().put('endt', '12/28/2013');
        ApexPages.StandardController st = new ApexPages.StandardController(camp);
        IBEventControllerCls ibEvent = new IBEventControllerCls(st);
        IBEventControllerCls.wrapper ibwrap = new IBEventControllerCls.wrapper(campChild);
        ibEvent.getChildEvents();
        ibEvent.save();
        apexpages.currentpage().getparameters().put('type', 'unBind');
        apexpages.currentpage().getparameters().put('stdt', '12/27/2013');
        apexpages.currentpage().getparameters().put('endt', '12/28/2013');
        ApexPages.StandardController st1 = new ApexPages.StandardController(camp);
        IBEventControllerCls ibEvent1 = new IBEventControllerCls(st1);
        IBEventControllerCls.wrapper ibwrap1 = new IBEventControllerCls.wrapper(campChild1);
        ibwrap1.check = true;
        ibEvent1.getChildEvents();
        ibEvent1.save();
        ibEvent1.cancel();

    }

    static testMethod void ibEventTestMethod_2(){

        Campaign parentCampaign = [select Id, Event_Language__c, Status, IB_Subject__c, Group_of_School__c from Campaign where Status = :PARENT_STATUS][0];

        PageReference ui = Page.IBBundleChildevents;

        ui.getParameters().put('id', parentCampaign.Id);
        ui.getParameters().put('type', BIND);
        ui.getParameters().put('stdt', START_DATE);
        ui.getParameters().put('endt', END_DATE);
        ui.getParameters().put('venueRegion', REGION);

        System.Test.setCurrentPage(ui);

        IBEventControllerCls controller = new IBEventControllerCls(
            new ApexPages.StandardController(parentCampaign)
        );

        List<Campaign> childrenCampaigns = [select Id from Campaign where Status != :PARENT_STATUS];

        controller.wrappList = new List<IBEventControllerCls.Wrapper>{
            new IBEventControllerCls.Wrapper(childrenCampaigns[0]),
            new IBEventControllerCls.Wrapper(childrenCampaigns[1])
        };

        controller.getChildEvents();

        controller.subjectSelected = controller.subjectSelected;
        controller.validateFlag = controller.validateFlag;

        for(IBEventControllerCls.Wrapper tmp : controller.wrappList){
            tmp.check = true;
        }

        Pagereference tmp = controller.save();
    }

    static testMethod void ibEventTestMethod_3(){

        Campaign parentCampaign = [select Id, Event_Language__c, Status, IB_Subject__c, Group_of_School__c from Campaign where Status = :PARENT_STATUS][0];

        PageReference ui = Page.IBBundleChildevents;

        ui.getParameters().put('id', parentCampaign.Id);
        ui.getParameters().put('type', UNBIND);
        ui.getParameters().put('stdt', '6/1/2016');
        ui.getParameters().put('endt', '7/1/2016');
        ui.getParameters().put('venueRegion', REGION);

        System.Test.setCurrentPage(ui);

        IBEventControllerCls controller = new IBEventControllerCls(
            new ApexPages.StandardController(parentCampaign)
        );

        List<Campaign> childrenCampaigns = [select Id, Event_Language__c, Bundle__c, ParentId from Campaign where Status != :PARENT_STATUS];

        controller.wrappList = new List<IBEventControllerCls.Wrapper>{
            new IBEventControllerCls.Wrapper(childrenCampaigns[0]),
            new IBEventControllerCls.Wrapper(childrenCampaigns[1])
        };

        controller.subjectSelected = controller.subjectSelected;
        controller.validateFlag = controller.validateFlag;

        for(IBEventControllerCls.Wrapper tmp : controller.wrappList){
            tmp.check = true;
        }

        Pagereference tmp = controller.save();
    }

    static testMethod void ibEventTestMethod_4(){

        Campaign parentCampaign = [select Id, Event_Language__c, Status, IB_Subject__c, Group_of_School__c from Campaign where Status = :PARENT_STATUS][0];

        PageReference ui = Page.IBBundleChildevents;

        ui.getParameters().put('id', parentCampaign.Id);
        ui.getParameters().put('type', BIND);
        ui.getParameters().put('stdt', '6/1/2016');
        ui.getParameters().put('endt', '7/1/2016');
        ui.getParameters().put('venueRegion', REGION);

        System.Test.setCurrentPage(ui);

        IBEventControllerCls controller = new IBEventControllerCls(
            new ApexPages.StandardController(parentCampaign)
        );

        List<Campaign> childrenCampaigns = [select Id, Event_Language__c, Bundle__c, ParentId from Campaign where Status != :PARENT_STATUS];

        controller.wrappList = new List<IBEventControllerCls.Wrapper>{
            new IBEventControllerCls.Wrapper(childrenCampaigns[0]),
            new IBEventControllerCls.Wrapper(childrenCampaigns[1])
        };

        controller.subjectSelected = controller.subjectSelected;
        controller.validateFlag = controller.validateFlag;

        for(IBEventControllerCls.Wrapper tmp : controller.wrappList){
            tmp.check = true;
        }

        Pagereference tmp = controller.save();
    }

    static testMethod void ibEventTestMethod_5(){

        Campaign parentCampaign = [select Id, Event_Language__c, Status, IB_Subject__c, Group_of_School__c from Campaign where Status = :PARENT_STATUS][0];

        PageReference ui = Page.IBBundleChildevents;

        ui.getParameters().put('id', parentCampaign.Id);
        ui.getParameters().put('type', BIND);
        ui.getParameters().put('stdt', '6/1/2016');
        ui.getParameters().put('endt', '7/1/2016');
        ui.getParameters().put('venueRegion', REGION);

        System.Test.setCurrentPage(ui);

        IBEventControllerCls controller = new IBEventControllerCls(
            new ApexPages.StandardController(parentCampaign)
        );

        List<Campaign> childrenCampaigns = [select Id, Event_Language__c, Bundle__c, ParentId from Campaign where Status != :PARENT_STATUS];

        controller.wrappList = new List<IBEventControllerCls.Wrapper>{
            new IBEventControllerCls.Wrapper(childrenCampaigns[0]),
            new IBEventControllerCls.Wrapper(childrenCampaigns[1])
        };

        controller.subjectSelected = controller.subjectSelected;
        controller.validateFlag = controller.validateFlag;

        for(IBEventControllerCls.Wrapper tmp : controller.wrappList){
            tmp.check = true;
        }

        Pagereference tmp = controller.save();
    }
}