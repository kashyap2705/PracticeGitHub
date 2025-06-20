@isTest public class NetworkMemberUpdateTests {
public static testMethod void testRunAs() {


Account a = PimsTestUtil.createAccount('TEST ACCOUNT','');
insert a;
 Date dd = Date.newInstance(1999, 12, 9);
contact c = new Contact(AccountId = a.id, FirstName = 'lastName', lastname = 'firstname', Language_of_Correspondence__c = 'English', HomePhone = '1112223344', Email = 'test@testgmail.com' , birthdate = dd);
insert c;

Profile p = [select id, name from profile 
                     where name = 'SCU + Basic' limit 1];  
        
String testemail = 'puser0001@amamama.com';
User pu = new User(profileId = p.id, username =  'xyzesllll0001@exampleamama.com', email = 'puser00012255@example.com', 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
                           alias='cspu', lastname='lastname', contactId = c.id);
    	
Database.insert(pu);

//get the network membership to get the correct network ID
NetworkMember membership = [SELECT networkID, memberID FROM NetworkMember 
                                                    WHERE memberID = :pu.id limit 1];

system.runas(pu){ 
    FeedItem post = new FeedItem(); 
    post.ParentId = userinfo.getuserid(); 
    post.Body = 'test post';   
    post.NetworkScope = membership.networkID;   //set the network ID of the post
    insert post; 
}
}
}