/*

* @author : oleg, CoastalCloud.us
* @date : 1/8/2016
* @description: CR 3803 (5) Weekly Email Digest of New Assignments
*
* © Copyright 2011 - 2016 CoastalCloud, Inc.  All Rights Reserved.
*

*/


public with sharing class IBAssignmentDigestUtil {
    private static Map <Id, Set <IB_Role__c>> confirmedRolesMapForUsers;
    private static Map <Id, Set <IB_Event_Role__c>> ibEventRoleMapForIBRoles;
    private static Map <Id, Set <IB_Event_Role__c>> ibEventRoleMapByStaffingEvent;

    private static Set <Id> ibEventInRoleIdSet;
    private static Set <Id> ibRoleIdSet;
    private static Map <Id, Set <String>> userEventRegionMap;
    private static Set <String> userRegionsSet;
    private static Map <Id, Set <Staffing_Event__c>> userEligibleAssignments;
    private static Map <Id, Set <String>> userRoleProgramAssignmentMap; //contains list of IB_Role_repository + Programme_Selection__c set for user
    private static Map <Id, Set <Role_Application_Subject__c>> rolesAndAppliscationSubjectsByUserContact;

    public static void processUserAssignments (List <User> portalUsers) {
        Map <String, Assignment_Digest__c> digestByUserMap = new Map <String, Assignment_Digest__c> ();
        IBEN_Assignment_Digest_Settings__c settings = IBEN_Assignment_Digest_Settings__c.getInstance();
        if (settings == null) settings = new IBEN_Assignment_Digest_Settings__c (Number_of_Days__c = 14);

        Set <Id> contactIdSet = new Set <Id> ();
        userRegionsSet = new Set <String> ();

        for (User u : portalUsers) {
            contactIdSet.add(u.ContactId);
            userRegionsSet.add(u.Contact.IB_Region__c);
        }

        Map <Id, User> userMap = new Map <Id, User> (portalUsers);
        System.debug('Processing number of users -  ' + portalUsers.size());
        System.debug('Processing number of users -  ' + portalUsers);


        populateConfirmedRolesMapForUsers(contactIdSet);
        populateIBEventRoles ();
        populateUserRegionMap (portalUsers);
        //populateSubjectsByUser ();

        userEligibleAssignments = new  Map <Id, Set <Staffing_Event__c>> ();
        Date createdDatePeriod = System.today() - Integer.valueOf(settings.Number_of_Days__c);
        Map <Id, Staffing_Event__c> staffingEvents;

        if (!Test.isRunningTest()) {
            staffingEvents = new Map <Id, Staffing_Event__c> ([SELECT Id
                                                                    ,Name
                                                                    ,Staffing_Event_Region__c
                                                                    ,IB_Region_Id__c
                                                                    ,Workshop_Product_Title__c
                                            						,Sub_Type__c
                                                                    FROM Staffing_Event__c
                                                                    Where Staffing_Event_Status__c
                                                                        NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Completed', 'Confirmed')
                                                                        AND Staffing_Event_Region__c = :userRegionsSet
                                                                        AND Start_Date__c != null
                                                                        AND End_Date__c != null
                                                                        AND Start_Date__c >= TODAY
                                                                        AND Id IN :ibEventInRoleIdSet
                                                                        AND CreatedDate > :createdDatePeriod
                                                                        AND Id NOT IN (SELECT Staffing_Event__c
                                                                                        FROM My_Staffing_Event__c
                                                                                        WHERE IB_Contact__c = :contactIdSet)
                                                                        ORDER BY Start_Date__c, Name]);
            System.debug('Found ' + staffingEvents.size() + ' events ... ');

        } else {
            staffingEvents = new Map <Id, Staffing_Event__c> ([SELECT Id
                                            ,Name
                                            ,Staffing_Event_Region__c
                                            ,IB_Region_Id__c
                                            ,Workshop_Product_Title__c
                                            ,Sub_Type__c
                                            FROM Staffing_Event__c
                                            ORDER BY Start_Date__c, Name]);

            System.debug('Found ' + staffingEvents.size() + ' events ... ');
        }




        for (Staffing_Event__c se: staffingEvents.values()) {
			
            System.debug('For Staffing_Event__c : ' + se.Id);
			
            if(se.Sub_Type__c!=null&&se.Sub_Type__c=='Course Outline Reading'){
                continue;
            }
            for (User u: portalUsers) {
                System.debug('Taking user : ' + u.Id);

                System.debug('userEventRegionMap.get(u.ContactId) = ' + userEventRegionMap.get(u.ContactId));
                System.debug('&& userEventRegionMap.get(u.ContactId).contains(se.IB_Region_Id__c) = ' + userEventRegionMap.get(u.ContactId).contains(se.IB_Region_Id__c));
                System.debug('&& ibEventInRoleIdSet.contains(se.Id) =  ' +   ibEventInRoleIdSet.contains(se.Id));
                System.debug('&& ibEventRoleMapByStaffingEvent.get(se.Id) = ' +  ibEventRoleMapByStaffingEvent.get(se.Id));
                System.debug('userRoleProgramAssignmentMap.get(u.ContactId) = ' + userRoleProgramAssignmentMap.get(u.ContactId));


                if (userEventRegionMap.get(u.ContactId) !=  null //avoid possible NPE if user has no regions.

                    //check if a user belongs to the region from the event
                    && userEventRegionMap.get(u.ContactId).contains(se.IB_Region_Id__c)

                    //check if staffing event has IB_Event_Role__c with positions > 0
                    && ibEventInRoleIdSet.contains(se.Id)
                    && ibEventRoleMapByStaffingEvent.get(se.Id) != null //make sure there are IB Event Roles for that Staffing Event
                    && userRoleProgramAssignmentMap.get(u.ContactId) != null //check if user has role/program combo
                    ){


                    for (IB_Event_Role__c ibRole : ibEventRoleMapByStaffingEvent.get(se.Id)) {
                        System.debug('For IB_Event_Role__c : ' + ibRole.Id);
                        System.debug('userRoleProgramAssignmentMap.get(u.ContactId) = ' + userRoleProgramAssignmentMap.get(u.ContactId));
                        System.debug('ibRole.IB_Role__c.ibRole.IB_Programme__c = ' + ibRole.IB_Role__c + '.' + ibRole.IB_Programme__c);
                        System.debug('userRoleProgramAssignmentMap.get(u.ContactId).contains (ibRole.IB_Role__c.ibRole.IB_Programme__c) = ' + userRoleProgramAssignmentMap.get(u.ContactId).contains (ibRole.IB_Role__c + '.' + ibRole.IB_Programme__c));
                        //System.debug('String.isEmpty(se.Workshop_Product_Title__c) = ' + String.isEmpty(se.Workshop_Product_Title__c));


                        //check if matches program selection
                        if (userRoleProgramAssignmentMap.get(u.ContactId) != null
                                && userRoleProgramAssignmentMap.get(u.ContactId).contains (ibRole.IB_Role__c + '.' + ibRole.IB_Programme__c)
                                //&& String.isEmpty(se.Workshop_Product_Title__c)
                                //&& rolesAndAppliscationSubjectsByUserContact.get(u.ContactId) != null
                                //&& rolesAndAppliscationSubjectsByUserContact.get(u.ContactId).contains(ibRole)
                                ) {

                            System.debug('digestByUserMap.get(u.Id) = ' + digestByUserMap.get(u.Id));

                            if (digestByUserMap.get(u.Id)== null) {
                                Assignment_Digest__c ad = new Assignment_Digest__c ();
                                ad.Contact__c = u.ContactId;
                                ad.Contact_Language__c = u.Contact.Language_of_Correspondence__c;
                                ad.Contact_First_Name__c = u.Contact.FirstName;
                                ad.User_Id__c = u.Id;
                                ad.Portal_User__c = u.Id;
                                ad.Email__c = u.Contact.Preferred_Communication_Method__c == 'Email' ? u.Contact.Email : u.Contact.Alternative_Email__c;
                                if (!String.isBlank(ad.Email__c))
                                    digestByUserMap.put (u.Id, ad);


                            }

                            if (digestByUserMap.get(u.Id)!= null) {
                                String suId = digestByUserMap.get (u.Id).Eligible_Assignment_Ids__c == null ? '' : digestByUserMap.get (u.Id).Eligible_Assignment_Ids__c;

                                if (String.isEmpty(suId)) suId += se.Id;
                                else suId += ',' + se.Id;


                                digestByUserMap.get (u.Id).Eligible_Assignment_Ids__c = suId;
                            }
                        }
                    }
                }
            }

            se.Digest_Status__c = 'Processed on ' + System.now();

        }

        update staffingEvents.values();

        for (User u: portalUsers) {
            if (digestByUserMap.get (u.Id) != null) {
                List <String> assingmentList = new List <String> ();
                assingmentList = digestByUserMap.get (u.Id).Eligible_Assignment_Ids__c.split(',');
                Set <String> uniqueSet = new Set <String> ();
                uniqueSet.addAll(assingmentList);


                digestByUserMap.get(u.Id).Eligible_Assignment_Ids__c = '';
                for (String s: uniqueSet) {
                    digestByUserMap.get(u.Id).Eligible_Assignment_Ids__c += '<a href="' + settings.IBEN_Central_URL__c + '/apex/MyAssignmentDetails?id=' + staffingEvents.get(s).Id + '">' + staffingEvents.get(s).Name + '</a> <br/>';
                }

                digestByUserMap.get (u.Id).Number_of_Assignments__c = uniqueSet.size();
            }
        }
        System.debug('inserting ' + digestByUserMap.values());
        insert digestByUserMap.values();
    }

    @testVisible
    private static void populateSubjectsByUser (){
        rolesAndAppliscationSubjectsByUserContact = new Map <Id, Set <Role_Application_Subject__c>> ();

        Map <Id, Set <String>> userContactSubjectsMap = new Map <Id, Set <String>> ();
        Set <Id> roleAppSubjectSet = new Set <Id> ();
        Map <Id, Set <IB_Workshop_Titles__c>> workshoptitlesByUserContact = new Map <Id, Set <IB_Workshop_Titles__c>> ();

        for (Role_Application_Subject__c r : [SELECT Id
                                                ,IB_Subject__c
                                                ,Role_And_Application__r.IB_Contact__c
                                                ,Role_And_Application__c
                                        FROM Role_Application_Subject__c
                                        WHERE Role_And_Application__c in :ibRoleIdSet]){

            roleAppSubjectSet.add (r.IB_Subject__c);

            if (userContactSubjectsMap.get(r.Role_And_Application__r.IB_Contact__c) == null )
                userContactSubjectsMap.put (r.Role_And_Application__r.IB_Contact__c, new Set <String> ());

            userContactSubjectsMap.get(r.Role_And_Application__r.IB_Contact__c).add (r.IB_Subject__c);

            if (confirmedRolesMapForUsers.get(r.Role_And_Application__r.IB_Contact__c) != null
                    && confirmedRolesMapForUsers.get(r.Role_And_Application__r.IB_Contact__c).contains(r.Role_And_Application__r)) {

                if (rolesAndAppliscationSubjectsByUserContact.get(r.Role_And_Application__r.IB_Contact__c) == null)
                    rolesAndAppliscationSubjectsByUserContact.put(r.Role_And_Application__r.IB_Contact__c, new Set <Role_Application_Subject__c>());


                rolesAndAppliscationSubjectsByUserContact.get(r.Role_And_Application__r.IB_Contact__c).add(r);
            }
        }

        for (IB_Workshop_Titles__c wst : [SELECT Id
                                            ,(SELECT IB_Subject__c FROM IB_Workshop_Title_Subjects__r WHERE  IB_Subject__c = null
                                            OR IB_Subject__c IN  :roleAppSubjectSet)
                                            FROM IB_Workshop_Titles__c
                                            ]) {

        }
    }

    private static void populateUserRegionMap (List <User> portalUsers) {
        userEventRegionMap = new Map <Id, Set <String>> ();

        for (User u : portalUsers) {
            if (userEventRegionMap.get (u.ContactId) == null)
                userEventRegionMap.put(u.ContactId, new Set <String> ());

            userEventRegionMap.get (u.ContactId).add (u.Contact.IB_Region__c);

        }

        System.debug('userEventRegionMap \n' + userEventRegionMap);
    }

    private static void populateIBEventRoles () { // IBEN Assignment Roles & Pre-Requisites

        ibEventRoleMapForIBRoles = new  Map <Id, Set <IB_Event_Role__c>> ();
        ibEventInRoleIdSet = new Set <Id> ();
        ibEventRoleMapByStaffingEvent =  new  Map <Id, Set <IB_Event_Role__c>> ();

        for (IB_Event_Role__c er: [SELECT Id
                                        ,IB_Role__c
                                        ,Staffing_Event__c
                                        ,IB_Programme__c

                                        FROM IB_Event_Role__c
                                        WHERE Positions_Left__c > 0
                                        AND IB_Role__c IN :ibRoleIdSet]) {


            if (ibEventRoleMapForIBRoles.get(er.IB_Role__c) == null)
                ibEventRoleMapForIBRoles.put(er.IB_Role__c, new Set <IB_Event_Role__c> ());

            ibEventRoleMapForIBRoles.get(er.IB_Role__c).add (er);


            ibEventInRoleIdSet.add (er.Staffing_Event__c);
            //ibEventInRoleIdSet.remove(null) //some IB_Event_Role__c records have no Staffing_Event__c - bad data


            if (ibEventRoleMapByStaffingEvent.get(er.Staffing_Event__c) == null)
                ibEventRoleMapByStaffingEvent.put(er.Staffing_Event__c, new Set <IB_Event_Role__c> ());

            ibEventRoleMapByStaffingEvent.get(er.Staffing_Event__c).add (er);


        }

        System.debug('ibEventRoleMapForIBRoles \n' + ibEventRoleMapForIBRoles);
        System.debug('ibEventInRoleIdSet \n' + ibEventInRoleIdSet);
    }


    private static void populateConfirmedRolesMapForUsers (Set <Id> conIdSet) {
        confirmedRolesMapForUsers = new Map <Id, Set <IB_Role__c>> ();
        ibRoleIdSet = new Set <Id> ();
        userRoleProgramAssignmentMap = new Map <Id, Set <String>> ();
        List <IB_Role__c> ibRoleList;

        if (!Test.isRunningTest()) {
            ibRoleList = new List <IB_Role__c> ([SELECT Id
                                        ,IB_Role__r.Role_Name_es__c //lookup to IB_Role_repository....
                                        ,IB_Role__r.Role_Name_fr__c
                                        ,IB_Role__c
                                        ,Subject__c
                                        ,IB_Role_Name__c
                                        ,IB_Contact__c
                                        ,Programme_Selection__c
                                        ,(SELECT IB_Subject__c FROM Role_Application_Subjects__r)
                                FROM IB_Role__c
                                WHERE  IB_Contact__c IN :conIdSet
                                AND Status__c = 'Confirmed'
                                AND Display_In_PIMS_Community__c=false
                                AND IB_Role__r.SF_Role_Application__c = true]);
        } else {
            ibRoleList = new List <IB_Role__c> ([SELECT Id
                                        ,IB_Role__r.Role_Name_es__c //lookup to IB_Role_repository....
                                        ,IB_Role__r.Role_Name_fr__c
                                        ,IB_Role__c
                                        ,Subject__c
                                        ,IB_Role_Name__c
                                        ,IB_Contact__c
                                        ,Programme_Selection__c
                                        ,(SELECT IB_Subject__c FROM Role_Application_Subjects__r)
                                FROM IB_Role__c]);
        }

        System.debug ('Found IBROLES for USERS : ' + ibRoleList.size());

        for (IB_Role__c ibRole: ibRoleList) {

            if (userRoleProgramAssignmentMap.get(ibRole.IB_Contact__c) == null)
                userRoleProgramAssignmentMap.put(ibRole.IB_Contact__c, new Set <String>());

            userRoleProgramAssignmentMap.get(ibRole.IB_Contact__c).add(ibRole.IB_Role__c + '.' + ibRole.Programme_Selection__c); //IB_Role_repository

            if (confirmedRolesMapForUsers.get(ibRole.IB_Contact__c) == null) {
                confirmedRolesMapForUsers.put(ibRole.IB_Contact__c, new Set <IB_Role__c>());
            }

            confirmedRolesMapForUsers.get(ibRole.IB_Contact__c).add(ibRole);

            ibRoleIdSet.add(ibRole.IB_Role__c);//which is actually a lookup to IB_Role_repository__c

        }

        System.debug('confirmedRolesMapForUsers \n' + confirmedRolesMapForUsers);
        System.debug('ibRoleIdSet \n' + ibRoleIdSet);

        System.debug('userRoleProgramAssignmentMap \n' + userRoleProgramAssignmentMap);
    }


}


/*

delete [select id from Assignment_Digest__c];

IBAssignmentDigestBatch b = new IBAssignmentDigestBatch ();

Database.executeBatch (b);

*/