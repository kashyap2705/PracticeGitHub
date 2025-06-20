public without sharing class ApplicationAssessmentDAO {

    private static final ApplicationAssessmentDAO instance = new ApplicationAssessmentDAO();
    private static IB_Application_Assessment__c assessment;

    private ApplicationAssessmentDAO() {}

    public static ApplicationAssessmentDAO getInstance() {
        return instance;
    }

    public IB_Application_Assessment__c getAppAssessmentByAppId (Id applicationId) {

            assessment = [
            SELECT Id, Name, Application__c, A1_1__c, A1_2__c, A1_3__c, A1_3a__c, A1_3b__c, A1_3c__c, A1_4__c, A1_5__c, A1_6__c, A1_7__c, A1_8__c, A1_9__c, A1_9a__c, A1_9b__c, A1_9c__c, A1_3d__c, A1_3e__c, A1_7a__c, A1_7b__c,
            B1_1__c, B1_2__c, B1_3__c, B1_4__c, B1_5__c, B1_6__c, B1_7__c, B1_5a__c, B1_5b__c, B1_5c__c, B1_5d__c, B1_5e__c, B1_5f__c, B1_2a__c, B1_2b__c, B1_4a__c, B1_6a__c,
            B2_1__c, B2_2__c, B2_3__c, B2_4__c, B2_5__c, B2_6__c, B2_7__c, B2_8__c, B2_9__c, B2_10__c, B2_11__c, B2_12__c, B2_1a__c, B2_1b__c, B2_3a__c, B2_5a__c, B2_5b__c, B2_5c__c, B2_6a__c, B2_9a__c, B2_10a__c, B2_10b__c, B2_10c__c,
            C1_1__c, C1_2__c, C1_3__c, C1_3a__c, C1_3b__c, C1_4__c, C1_4a__c, C1_4b__c, C1_5__c, C1_6__c, C1_7__c, C1_8__c, C1_9__c, C1_1a__c, C1_1b__c, C1_1c__c,
            C2_1__c, C2_1a__c, C2_1b__c, C2_1c__c, C2_1d__c, C2_1e__c, C2_1f__c, C2_1h__c, C2_1g__c, C2_2__c, C2_3__c, C2_4__c, C2_5__c, C2_6__c, C2_7__c, C2_8__c, C2_9__c, C2_10__c, C2_11__c, C2_4a__c, C2_4b__c, C2_6a__c, C2_7a__c, C2_9a__c,
            C3_1__c, C3_1a__c, C3_1b__c, C3_1c__c, C3_2__c, C3_2a__c, C3_3__c, C3_3a__c, C3_4__c, C3_5__c, C3_6__c, C3_7__c, C3_8__c, C3_9__c, C3_10__c, C3_10a__c, C3_11__c, C3_12__c, C3_13__c, C3_14__c, C3_14a__c, C3_14b__c, C3_15__c, C3_16__c,
            C4_1__c, C4_1a__c, C4_1b__c, C4_1c__c, C4_1d__c, C4_2__c, C4_3__c, C4_4__c, C4_4a__c, C4_5__c, C4_6__c, C4_6a__c, C4_7a__c, C4_5a__c, C4_9__c, C4_8__c, C4_7__c, C2_5a__c
            FROM IB_Application_Assessment__c
            WHERE Application__c = :applicationId
        ];

        return assessment;
            
        }



    public IB_Application_Assessment__c getAppAssessmentByAppId (Id applicationId, String section) {
        System.debug('section = ' + section);
        if (section == 'sectiona') {
            assessment = [
                SELECT Id, Name, Application__c, A1_1__c, A1_2__c, A1_3__c, A1_3a__c, A1_3b__c, A1_3c__c, A1_4__c, A1_5__c, A1_6__c, A1_7__c, A1_8__c, A1_9__c, A1_9a__c, A1_9b__c, A1_9c__c, A1_3d__c, A1_3e__c, A1_7a__c, A1_7b__c
                FROM IB_Application_Assessment__c
                WHERE Application__c = :applicationId
            ];
        }
        else if (section == 'sectionb1') {
            assessment = [
                SELECT Id, Name, Application__c, B1_1__c, B1_2__c, B1_3__c, B1_4__c, B1_5__c, B1_6__c, B1_7__c, B1_5a__c, B1_5b__c, B1_5c__c, B1_5d__c, B1_5e__c, B1_5f__c, B1_2a__c, B1_2b__c, B1_4a__c, B1_6a__c
                FROM IB_Application_Assessment__c
                WHERE Application__c = :applicationId
            ];
        }
        else if (section == 'sectionb2') {
            assessment = [
                SELECT Id, Name, Application__c, B2_1__c, B2_2__c, B2_3__c, B2_4__c, B2_5__c, B2_6__c, B2_7__c, B2_8__c, B2_9__c, B2_10__c, B2_11__c, B2_12__c, B2_1a__c, B2_1b__c, B2_3a__c, B2_5a__c, B2_5b__c, B2_5c__c, B2_6a__c, B2_9a__c, B2_10a__c, B2_10b__c, B2_10c__c
                FROM IB_Application_Assessment__c
                WHERE Application__c = :applicationId
            ];
        }
        else if (section == 'sectionc1') {
            assessment = [
                SELECT Id, Name, Application__c, C1_1__c, C1_2__c, C1_3__c, C1_4__c, C1_5__c, C1_6__c, C1_7__c, C1_8__c, C1_9__c, C1_1a__c, C1_1b__c, C1_1c__c
                FROM IB_Application_Assessment__c
                WHERE Application__c = :applicationId
            ];
        }
        else if (section == 'sectionc2') {
            assessment = [
                SELECT Id, Name, Application__c, C2_1__c, C2_10__c, C2_11__c, C2_1a__c, C2_1b__c, C2_1c__c, C2_1d__c, C2_1e__c, C2_1f__c, C2_1g__c, C2_1h__c, C2_2__c, C2_3__c, C2_4__c, C2_4a__c, C2_4b__c, C2_5__c, C2_6__c, C2_6a__c, C2_7__c, C2_7a__c, C2_8__c, C2_9__c, C2_9a__c, C2_5a__c
                FROM IB_Application_Assessment__c
                WHERE Application__c = :applicationId
            ];
        }
        else if (section == 'sectionc3') {
            assessment = [
                SELECT Id, Name, Application__c, C3_16__c
                FROM IB_Application_Assessment__c
                WHERE Application__c = :applicationId
            ];
        }
        else if (section == 'sectionc4') {
            assessment = [
                SELECT Id, Name, Application__c, C4_1__c, C4_1a__c, C4_1b__c, C4_1c__c, C4_1d__c, C4_2__c, C4_3__c, C4_4__c, C4_4a__c, C4_5__c, C4_6__c, C4_6a__c, C4_7a__c, C4_5a__c, C4_9__c, C4_8__c, C4_7__c
                FROM IB_Application_Assessment__c
                WHERE Application__c = :applicationId
            ];
        }

        return assessment;

    }

}