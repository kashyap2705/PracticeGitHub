/**
* @description - This is used to create test data for User object.
*
* @author: Satyanarayana Gajavalli
* @since 24-10-2024
* @Modification Log:
* Date            Created/Modified    Ticket           Description    
* 24-10-2024      Created             US-0002466       Created the class
*/
@isTest
public without sharing class UserTestDataFactory { 

    private final static String DEFAULT_DOMAIN = 'test.com';
    private final static String DEFAULT_FIRSTNAME = 'TestFirstName';
    private final static String DEFAULT_ALIAS = 'tUser';
    private final static Boolean DEFAULT_ACTIVE = true;
    private final static String DEFAULT_TIMEZONE = 'America/Los_Angeles';
    private final static String DEFAULT_LOCALE = 'en_US';
    private final static String DEFAULT_EMAILKEY = 'UTF-8';
    private final static String DEFAULT_LANGUAGEKEY = 'en_US';

    /**
     * @description - Creates a list of `User` records, either cloned from a provided template or created as new records.
     *                Each user record is assigned a specified profile based on the profile name provided.
     * @param profileName - The name of the profile to assign to each user record. Used to fetch the profile ID.
     * @param tempUser - A template `User` record to clone from. If null, a new `User` record is created.
     * @param nUsers - The number of `User` records to create.
     * @return - A list of populated `User` records, each with the specified profile and default values for fields where applicable.
     */
    public static List<User> createUsers(String profileName, User tempUser, Integer nUsers){

        Id profileId = getProfileId(profileName);
        List<User> users = new List<User>();

        for (Integer i = 0; i < nUsers; i++) {
            User usr;
            if(tempUser != null){
                usr = tempUser.clone(false);
            } else {
                usr = new User();
            }

            if (profileId == null){
                usr = createUserInstance(usr, null);
            } else {
                usr = createUserInstance(usr, profileId);
            }
            users.add(usr);
        }
        return users;
    }

    /**
     * @description - Creates a `User` record by either cloning from a provided template or creating a new instance.
     *                Assigns the specified profile based on the provided profile name and populates fields using default values
     *                where applicable through the `createUserInstance` method.
     * @param profileName - The name of the profile to assign to the user. Used to retrieve the profile ID.
     * @param tempUser - A template `User` record to clone from. If null, a new `User` record is created.
     * @return - A `User` record with the specified profile and populated fields.
     */
    public static User createUser(String profileName, User tempUser){

        Id profileId = getProfileId(profileName);

        User usr;
        if(tempUser != null){
            usr = tempUser.clone(false);
        } else {
            usr = new User();
        }

        if (profileId == null){
            usr = createUserInstance(usr, null);
        } else {
            usr = createUserInstance(usr, profileId);
        }
        return usr;
    }

    /**
     * @description - Retrieves the Profile ID based on the provided profile name. If the profile name is 'System Administrator' 
     *                or is empty/null, it specifically fetches the System Administrator profile with a 'Salesforce' user license.
     *                If the profile name does not match any records, or an error occurs, a default Profile ID is returned.
     * @param profileName - The name of the profile to search for. If null or empty, defaults to 'System Administrator' with the 'Salesforce' license.
     * @return - The ID of the Profile matching the specified name or a default Profile ID if none is found or an error occurs.
     */
    public static String getProfileId(String profileName){
        String profileId = '';
        try{
            if(profileName == 'System Administrator' || profileName == '' || profileName == null) {
                Id userLicenseId = [ select Id from UserLicense where name = 'Salesforce'].id;
                profileId = [select Id from Profile where name='System Administrator' and UserLicenseId=:userLicenseId].id;
            } else {
                profileId = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1].Id;
            }
        } catch(Exception e){
            profileId = [SELECT Id FROM Profile LIMIT 1].Id;
        }
        return profileId;
    }

    /**
     * @description - Creates or updates a User instance with default or specified values. If a field is blank or null in 
     *                the provided user record, it assigns a default value to that field.
     * @param userRecord - The User record to be used as a template. If fields are blank or null, defaults are applied.
     * @param profileId - The Profile ID to assign to the User. If null, the User's Profile ID remains unchanged.
     * @return - The User instance populated with provided or default values.
     */
    public static User createUserInstance(User userRecord, String profileId){

        User userInstance = userRecord;
        
        userInstance.FirstName = String.isBlank(userRecord.FirstName) ? DEFAULT_FIRSTNAME : userRecord.FirstName;
        userInstance.LastName = String.isBlank(userRecord.LastName) ? TestDataUtility.generateRandomString(5) : userRecord.LastName;

        String fullName = userInstance.FirstName + userInstance.LastName;

        if(profileId != null) {
            userInstance.ProfileId = profileId;
        }

        userInstance.Email = TestDataUtility.getValueOrDefault(userRecord.Email,fullName + '@' + DEFAULT_DOMAIN);
        userInstance.UserName = TestDataUtility.getValueOrDefault(userRecord.UserName,fullName + '@' + DEFAULT_DOMAIN);
        userInstance.IsActive = TestDataUtility.getValueOrDefault(userRecord.IsActive,DEFAULT_ACTIVE);
        userInstance.Alias = TestDataUtility.getValueOrDefault(userRecord.Alias,DEFAULT_ALIAS);
        userInstance.TimeZoneSidKey = TestDataUtility.getValueOrDefault(userRecord.TimeZoneSidKey,DEFAULT_TIMEZONE);
        userInstance.LocaleSidKey = TestDataUtility.getValueOrDefault(userRecord.LocaleSidKey,DEFAULT_LOCALE);
        userInstance.EmailEncodingKey = TestDataUtility.getValueOrDefault(userRecord.EmailEncodingKey,DEFAULT_EMAILKEY);
        userInstance.LanguageLocaleKey = TestDataUtility.getValueOrDefault(userRecord.LanguageLocaleKey,DEFAULT_LANGUAGEKEY);

        return userInstance;
    }
}