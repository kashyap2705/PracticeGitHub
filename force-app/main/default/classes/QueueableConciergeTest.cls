@isTest
private class QueueableConciergeTest {

     private static Id evalRecordTypeId {
        get {
            if (evalRecordTypeId == null) {
                evalRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Evaluation').getRecordTypeId();
            }
            return evalRecordTypeId;
        }
        private set;
    }
    
    @testSetup
    static void setupData() {
        // Setup Concierge Config
        Concierge_API_Configs__c config = new Concierge_API_Configs__c(
            Name = 'Default',
            End_Point_URL__c = 'https://example.com/',
            Access_Token__c = 'test_token'
        );
        insert config;
        
        
        
         Account testAccount = AccountTestDataFactory.createAccount(null, null);
        testAccount.External_PD_Provider__c = true;
        testAccount.IBIS_ID__c='060787';
        insert testAccount;

        Contact testContact = ContactTestDataFactory.createContact(null, 
            new Contact(AccountId = testAccount.Id, Email = 'test@contact.com'));
        insert testContact;
        
         List<IB_Programme__c> progRecList = new List<IB_Programme__c>();
        IB_Programme__c progRec = IbProgramFactoryTest.createProgrammeForAccount(testAccount, 'CP');
        progRec.StageName__c = 'Evaluation';
        progRec.Status__c = 'Authorized';
        progRec.Owner__c=userInfo.getUserid();
        progRec.Date_Decision_on_Authorization__c=Date.newInstance(2025, 12, 9);
        progRecList.add(progRec);
        insert progRecList;
        
        
         Campaign childCamp = new Campaign(
            Name = 'Preliminary Review Child Evaluation',
            Event_Organizer_Account__c = testAccount.Id,
             Venue_Account__c=testAccount.Id,
            RecordTypeId = evalRecordTypeId,
            Type = 'Evaluation',
            Sub_Type__c = 'Preliminary Review',
            Status = 'Planned / Ready for Staffing',
            IB_Docs_ID__c='2020' ,
             Related_IB_Programme__c=progRecList[0].id,
             Deadline_to_Submit_Docs__c=Date.newInstance(2025, 12, 9)
        );
        insert childCamp;
        
        system.debug('childCamp***'+childCamp);

       
    }

     @isTest
    static void testQueueableConciergeWithActualPayloadIBWSMApprovalPRReport() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Build real-like JSON payload (as string)
        Map<String, Object> triggerEvent = new Map<String, Object>{
            'IBConciergeDate' => '2025-05-20T17:36:31Z',
            'triggerName' => 'IBWSM approval date for PR report',
            'DPEvaluationOutcome' => 'MTBA',
                'CPEvaluationOutcome' => 'MTBA',
                'MYPEvaluationOutcome' => 'MTBA',
                'PYPEvaluationOutcome' => 'MTBA'
        };

        Map<String, Object> jsonMap = new Map<String, Object>{
            'eventAt' => '2025-05-20T17:36:31Z',
            'eventId' => '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5',
            'eventName' => 'preliminary_review.approved',
            'processReference' => '060787/EVAL/2025/PYP',
            'programmeCodes' => new List<String>{'CP'},
            'schoolCode' => '060787',
            'triggerEventNames' => new List<Object>{ triggerEvent }
        };
            
            
               

        String payload = JSON.serialize(jsonMap);
            

        IBConciergeStaging__c staging = new IBConciergeStaging__c(
            Received_Payload__c = payload,
            Received_Event_Id__c = '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5'
        );
        insert staging;

        Test.startTest();
        System.enqueueJob(new QueueableConcierge(new List<IBConciergeStaging__c>{ staging }));
        Test.stopTest();

    }
      @isTest
    static void testQueueableConciergeWithActualPayloadPreliminaryReviewBeforeDeadline() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Build real-like JSON payload (as string)
        Map<String, Object> triggerEvent = new Map<String, Object>{
            'IBConciergeDate' => '2025-05-20T17:36:31Z',
            'triggerName' => 'Preliminary Review requested by school before deadline'
        };

        Map<String, Object> jsonMap = new Map<String, Object>{
            'eventAt' => '2025-05-20T17:36:31Z',
            'eventId' => '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5',
            'eventName' => 'preliminary_review.approved',
            'processReference' => '060787/EVAL/2025/PYP',
            'programmeCodes' => new List<String>{'CP'},
            'schoolCode' => '060787',
            'triggerEventNames' => new List<Object>{ triggerEvent }
        };
            
            
               

        String payload = JSON.serialize(jsonMap);
            

        IBConciergeStaging__c staging = new IBConciergeStaging__c(
            Received_Payload__c = payload,
            Received_Event_Id__c = '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5'
        );
        insert staging;

        Test.startTest();
        System.enqueueJob(new QueueableConcierge(new List<IBConciergeStaging__c>{ staging }));
        Test.stopTest();

    }
    
       @isTest
    static void testPreliminaryReviewNotRequestedBeforeDeadline() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Build real-like JSON payload (as string)
        Map<String, Object> triggerEvent = new Map<String, Object>{
            'IBConciergeDate' => '2025-05-20T17:36:31Z',
            'triggerName' => 'Preliminary Review not requested by deadline'
        };

        Map<String, Object> jsonMap = new Map<String, Object>{
            'eventAt' => '2025-05-20T17:36:31Z',
            'eventId' => '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5',
            'eventName' => 'preliminary_review.approved',
            'processReference' => '060787/EVAL/2025/PYP',
            'programmeCodes' => new List<String>{'CP'},
            'schoolCode' => '060787',
            'triggerEventNames' => new List<Object>{ triggerEvent }
        };
            
            
               

        String payload = JSON.serialize(jsonMap);
            

        IBConciergeStaging__c staging = new IBConciergeStaging__c(
            Received_Payload__c = payload,
            Received_Event_Id__c = '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5'
        );
        insert staging;

        Test.startTest();
        System.enqueueJob(new QueueableConcierge(new List<IBConciergeStaging__c>{ staging }));
        Test.stopTest();

    }
    
     @isTest
    static void PLsubmitteddateforPRreport() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        
         // Build triggerEventNames payload
        Map<String, Object> sectionStatuses = new Map<String, Object>{
            'ALL' => 'submitted',
            'PYP' => 'pending'
        };
            
        // Build real-like JSON payload (as string)
       Map<String, Object> triggerEvent = new Map<String, Object>{
            'IBConciergeDate' => '2025-05-20T17:36:31Z',
            'triggerName' => 'PL submitted date for PR report',
            'sectionName' => 'ALL',
            'sectionStatuses' => sectionStatuses
        };

        Map<String, Object> jsonMap = new Map<String, Object>{
            'eventAt' => '2025-05-20T17:36:31Z',
            'eventId' => '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5',
            'eventName' => 'preliminary_review.approved',
            'processReference' => '060787/EVAL/2025/PYP',
            'programmeCodes' => new List<String>{'CP'},
            'schoolCode' => '060787',
            'triggerEventNames' => new List<Object>{ triggerEvent }
        };
            
            
               

        String payload = JSON.serialize(jsonMap);
            

        IBConciergeStaging__c staging = new IBConciergeStaging__c(
            Received_Payload__c = payload,
            Received_Event_Id__c = '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5'
        );
        insert staging;

        Test.startTest();
        System.enqueueJob(new QueueableConcierge(new List<IBConciergeStaging__c>{ staging }));
        Test.stopTest();

    }
    
    @isTest
    static void PLsubmitteddateforPRreport2() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        
         // Build triggerEventNames payload
        Map<String, Object> sectionStatuses = new Map<String, Object>{
            'ALL' => 'submitted',
            'PYP' => 'submitted'
        };
            
        // Build real-like JSON payload (as string)
       Map<String, Object> triggerEvent = new Map<String, Object>{
            'IBConciergeDate' => '2025-05-20T17:36:31Z',
            'triggerName' => 'PL submitted date for PR report',
            'sectionName' => 'ALL',
            'sectionStatuses' => sectionStatuses
        };

        Map<String, Object> jsonMap = new Map<String, Object>{
            'eventAt' => '2025-05-20T17:36:31Z',
            'eventId' => '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5',
            'eventName' => 'preliminary_review.approved',
            'processReference' => '060787/EVAL/2025/PYP',
            'programmeCodes' => new List<String>{'CP'},
            'schoolCode' => '060787',
            'triggerEventNames' => new List<Object>{ triggerEvent }
        };
            
            
               

        String payload = JSON.serialize(jsonMap);
            

        IBConciergeStaging__c staging = new IBConciergeStaging__c(
            Received_Payload__c = payload,
            Received_Event_Id__c = '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5'
        );
        insert staging;

        Test.startTest();
        System.enqueueJob(new QueueableConcierge(new List<IBConciergeStaging__c>{ staging }));
        Test.stopTest();

    }
    
     
    
     @isTest
    static void PRoutcome() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Build real-like JSON payload (as string)
        Map<String, Object> triggerEvent = new Map<String, Object>{
            'IBConciergeDate' => '2025-05-20T17:36:31Z',
            'triggerName' => 'PR outcome',
            'DPEvaluationOutcome' => 'MTBA',
                'CPEvaluationOutcome' => 'MTBA',
                'MYPEvaluationOutcome' => 'MTBA',
                'PYPEvaluationOutcome' => 'MTBA'
        };

        Map<String, Object> jsonMap = new Map<String, Object>{
            'eventAt' => '2025-05-20T17:36:31Z',
            'eventId' => '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5',
            'eventName' => 'preliminary_review.approved',
            'processReference' => '060787/EVAL/2025/PYP',
            'programmeCodes' => new List<String>{'CP'},
            'schoolCode' => '060787',
            'triggerEventNames' => new List<Object>{ triggerEvent }
        };
            
            
               

        String payload = JSON.serialize(jsonMap);
            

        IBConciergeStaging__c staging = new IBConciergeStaging__c(
            Received_Payload__c = payload,
            Received_Event_Id__c = '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5'
        );
        insert staging;

        Test.startTest();
        System.enqueueJob(new QueueableConcierge(new List<IBConciergeStaging__c>{ staging }));
        Test.stopTest();

    }
    
      @isTest
    static void PCrequestreviewdateforpMTBAevidenceuploaded() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Build real-like JSON payload (as string)
        Map<String, Object> triggerEvent = new Map<String, Object>{
            'IBConciergeDate' => '2025-05-20T17:36:31Z',
            'triggerName' => 'PC request review date for pMTBA evidence uploaded'
        };

        Map<String, Object> jsonMap = new Map<String, Object>{
            'eventAt' => '2025-05-20T17:36:31Z',
            'eventId' => '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5',
            'eventName' => 'preliminary_review.approved',
            'processReference' => '060787/EVAL/2025/PYP',
            'programmeCodes' => new List<String>{'CP'},
            'schoolCode' => '060787',
            'triggerEventNames' => new List<Object>{ triggerEvent }
        };
            
            
               

        String payload = JSON.serialize(jsonMap);
            

        IBConciergeStaging__c staging = new IBConciergeStaging__c(
            Received_Payload__c = payload,
            Received_Event_Id__c = '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5'
        );
        insert staging;

        Test.startTest();
        System.enqueueJob(new QueueableConcierge(new List<IBConciergeStaging__c>{ staging }));
        Test.stopTest();

    }
    
     @isTest
    static void IBWSMsubmitteddateforPRRepublishing() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Build real-like JSON payload (as string)
        Map<String, Object> triggerEvent = new Map<String, Object>{
            'IBConciergeDate' => '2025-05-20T17:36:31Z',
            'triggerName' => 'IBWSM submitted date for PR re-publishing (after pMTBA review)',
                
                'DPEvaluationOutcome' => 'MTBA',
                'CPEvaluationOutcome' => 'MTBA',
                'MYPEvaluationOutcome' => 'MTBA',
                'PYPEvaluationOutcome' => 'MTBA'
        };

        Map<String, Object> jsonMap = new Map<String, Object>{
            'eventAt' => '2025-05-20T17:36:31Z',
            'eventId' => '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5',
            'eventName' => 'preliminary_review.approved',
            'processReference' => '060787/EVAL/2025/PYP',
            'programmeCodes' => new List<String>{'CP'},
            'schoolCode' => '060787',
            'triggerEventNames' => new List<Object>{ triggerEvent }
        };
            
            
               

        String payload = JSON.serialize(jsonMap);
            

        IBConciergeStaging__c staging = new IBConciergeStaging__c(
            Received_Payload__c = payload,
            Received_Event_Id__c = '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5'
        );
        insert staging;

        Test.startTest();
        System.enqueueJob(new QueueableConcierge(new List<IBConciergeStaging__c>{ staging }));
        Test.stopTest();

    }
      @isTest
    static void IBWSMsubmitteddateforPRRePublishing2() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Build real-like JSON payload (as string)
        Map<String, Object> triggerEvent = new Map<String, Object>{
            'IBConciergeDate' => '2025-05-20T17:36:31Z',
            'triggerName' => 'IBWSM submitted date for PR re-publishing (after pMTBA review)',
                   'DPEvaluationOutcome' => 'Requirements met',
                'CPEvaluationOutcome' => 'Requirements met',
                'MYPEvaluationOutcome' => 'Requirements met',
                'PYPEvaluationOutcome' => 'Requirements met'
        };

        Map<String, Object> jsonMap = new Map<String, Object>{
            'eventAt' => '2025-05-20T17:36:31Z',
            'eventId' => '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5',
            'eventName' => 'preliminary_review.approved',
            'processReference' => '060787/EVAL/2025/PYP',
            'programmeCodes' => new List<String>{'CP'},
            'schoolCode' => '060787',
            'triggerEventNames' => new List<Object>{ triggerEvent }
        };
            
            
               

        String payload = JSON.serialize(jsonMap);
            

        IBConciergeStaging__c staging = new IBConciergeStaging__c(
            Received_Payload__c = payload,
            Received_Event_Id__c = '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5'
        );
        insert staging;

        Test.startTest();
        System.enqueueJob(new QueueableConcierge(new List<IBConciergeStaging__c>{ staging }));
        Test.stopTest();

    }
      @isTest
    static void NoDataFound() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Build real-like JSON payload (as string)
        Map<String, Object> triggerEvent = new Map<String, Object>{
            'IBConciergeDate' => '2025-05-20T17:36:31Z',
            'triggerName' => 'IBWSM submitted date for PR re-publishing (after pMTBA review)',
                   'DPEvaluationOutcome' => 'Requirements met',
                'CPEvaluationOutcome' => 'Requirements met',
                'MYPEvaluationOutcome' => 'Requirements met',
                'PYPEvaluationOutcome' => 'Requirements met'
        };

        Map<String, Object> jsonMap = new Map<String, Object>{
            'eventAt' => '2025-05-20T17:36:31Z',
            'eventId' => '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5',
            'eventName' => 'preliminary_review.approved',
            'processReference' => '067787/EVAL/2025/PYP',
            'programmeCodes' => new List<String>{'CP'},
            'schoolCode' => '067787',
            'triggerEventNames' => new List<Object>{ triggerEvent }
        };
            
            
               

        String payload = JSON.serialize(jsonMap);
            

        IBConciergeStaging__c staging = new IBConciergeStaging__c(
            Received_Payload__c = payload,
            Received_Event_Id__c = '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5'
        );
        insert staging;

        Test.startTest();
        System.enqueueJob(new QueueableConcierge(new List<IBConciergeStaging__c>{ staging }));
        Test.stopTest();

    }
    
   @isTest
    static void NoDataFound2() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Build real-like JSON payload (as string)
        Map<String, Object> triggerEvent = new Map<String, Object>{
            'IBConciergeDate' => '2025-05-20T17:36:31Z',
            'triggerName' => 'IBWSM submitted date for PR re-publishing (after pMTBA review)',
                   'DPEvaluationOutcome' => 'Requirements met',
                'CPEvaluationOutcome' => 'Requirements met',
                'MYPEvaluationOutcome' => 'Requirements met',
                'PYPEvaluationOutcome' => 'Requirements met'
        };

        Map<String, Object> jsonMap = new Map<String, Object>{
            'eventAt' => '2025-05-20T17:36:31Z',
            'eventId' => '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5',
            'eventName' => 'preliminary_review.approved',
            'processReference' => '067787/EVAL/2025/PYP',
            'programmeCodes' => new List<String>{'CP'},
            'schoolCode' => '',
            'triggerEventNames' => new List<Object>{ triggerEvent }
        };
            
            
               

        String payload = JSON.serialize(jsonMap);
            

        IBConciergeStaging__c staging = new IBConciergeStaging__c(
            Received_Payload__c = payload,
            Received_Event_Id__c = '93b519fe-de5f-4a2e-8e42-a47d49dbc5f5'
        );
        insert staging;

        Test.startTest();
        System.enqueueJob(new QueueableConcierge(new List<IBConciergeStaging__c>{ staging }));
        Test.stopTest();

    }    

     @isTest
    static void testParseWrapperWithSectionSubmitted() {
        String payload = '{' +
            '"eventAt":"2025-05-19T11:26:13Z",' +
            '"eventId":"0ab61333-6abe-4674-b434-fea4c1010010",' +
            '"eventName":"preliminary_review.section_submitted",' +
            '"processReference":"060995/EVAL/2025/PYP",' +
            '"programmeCodes":["PYP"],' +
            '"schoolCode":"060995",' +
            '"triggerEventNames":[{' +
                '"IBConciergeDate":"2025-05-19T11:26:13Z",' +
                '"sectionName":"ALL",' +
                '"sectionStatuses":{"ALL":"submitted","PYP":"pending"},' +
                '"triggerName":"PL submitted date for PR report"' +
            '}]' +
        '}';

        Test.startTest();
        IB_Wrapper wrapper = IB_Wrapper.parse(payload);
        Test.stopTest();

        
    }
    
}