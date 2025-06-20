/**
 * Test Suite for testing Chatter Disable Delete app
 * 
 * Author: Marcus Ericsson - mericsson@salesforce.com
 */
@isTest
private class DisableChatterDeletesTestSuite {
    @TestSetup
    static void makeData(){
        User u = new User();
        u.email= 'testFeedItemDeleteDummy@testorg.com';
        u = UserTestDataFactory.createUser('System Administrator', u);
        u.IsActive = true;
        insert u;
        Chatter_Delete_Settings__c[] settings = [select id from Chatter_Delete_Settings__c];
        delete(settings);
    }
    @isTest public static void testFeedItemDeleteSysAdmin() {
        User u = [Select id,IsActive from User where email='testFeedItemDeleteDummy@testorg.com' LIMIT 1];
        System.runAs(u) {
            
            FeedItem p = new FeedItem();
            p.parentId = u.id;
            p.Body = 'force.com labs is great!';
            insert(p);
            try{
              delete(p);  
            }catch(Exception e){
                system.debug('e');
            }
            
        }
    }
    
    @isTest public static void testFeedItemDeleteSysAdminFrench() {
        User u = [Select id,IsActive from User where email='testFeedItemDeleteDummy@testorg.com' LIMIT 1];
        System.runAs(u) {
            // test single item delete
            FeedItem p = new FeedItem();
            p.parentId = u.id;
            p.Body = 'force.com labs is great!';
            insert(p);
           try{
              delete(p);  
            }catch(Exception e){
                system.debug('e');
            }
        }
    }

    @isTest public static void testFeedCommentDeleteSysAdmin() {
        User u = [Select id,IsActive from User where email='testFeedItemDeleteDummy@testorg.com' LIMIT 1];
        System.runAs(u) {    
            //Id cid = insertDummyContact();
            Id cid = u.id;
    
            // test single item delete
            FeedItem p = new FeedItem();
            p.parentId = cid;
            p.Body = 'force.com labs is great!';
    
            Database.SaveResult sr = Database.Insert(p);
            System.assert(sr.isSuccess());
            Id pId = sr.getId();
    
            FeedComment c = new FeedComment();
            c.feedItemId = pid;
            c.CommentBody = 'this is a comment';
            insert(c);

           try{
              delete(c);  
            }catch(Exception e){
                system.debug('e');
            }
        }
    }

    @isTest public static void testFeedItemDelete() {
        User u = [Select id,IsActive from User where email='testFeedItemDeleteDummy@testorg.com' LIMIT 1];
        System.runAs(u) {
            // The following code runs as user 'u'   
            //insert a dummy contact we can post on
            Id cid = u.id;

            // test single item delete
            FeedItem p = new FeedItem();
            p.parentId = cid;
            p.Body = 'force.com labs is great!';
            insert(p);
            try {
                delete(p);
                System.assert(false);
            } catch (System.DmlException e) {
                System.assert(e.getMessage().contains('disabled'));
            }


            // now test bulk delete
            FeedItem[] ps = new FeedItem[150];
            for (Integer i = 0; i < 150; i++) {
                ps[i] = new FeedItem();
                ps[i].parentId = cid;
                ps[i].body = 'force.com labs is great!';
            }
            insert(ps);
            try {
                delete(ps);
                System.assert(false);
            } catch (System.DmlException e) {
                System.assert(e.getMessage().contains('disabled'));
            }
        }
    }
    
    @isTest public static void testFeedItemDeleteFrench() {
        System.runAs(new user(ID = UserInfo.getUserID())) {
            // test single item delete
            FeedItem p = new FeedItem();
            p.parentId = UserInfo.getUserID();
            p.Body = 'force.com labs is great!';
            insert(p);
            try {
                delete(p);
                System.assert(false);
            } catch (System.DmlException e) {
                System.assert(e.getMessage().contains('disabled'));
            }
        }
    }

    @isTest public static void testFeedCommentDelete() {
        User u = [Select id,IsActive from User where email='testFeedItemDeleteDummy@testorg.com' LIMIT 1];
        System.runAs(u) {
            Id cid = u.id;

            // test single item delete
            FeedItem p = new FeedItem();
            p.parentId = cid;
            p.Body = 'force.com labs is great!';

            Database.SaveResult sr = Database.Insert(p);
            System.assert(sr.isSuccess());
            Id pId = sr.getId();

            FeedComment c = new FeedComment();
            c.feedItemId = pid;
            c.CommentBody = 'this is a comment';
            insert(c);

            try {
                delete(c);
                System.assert(false);
            } catch (System.DmlException e) {
                System.assert(e.getMessage().contains('disabled'));
            }


            // now test bulk delete
            FeedComment[] cs = new FeedComment[150];
            for (Integer i = 0; i < 150; i++) {
                cs[i] = new FeedComment();
                cs[i].feeditemid = pid;
                cs[i].CommentBody = 'force.com labs is great!';
            }
            insert(cs);
            try {
                delete(cs);
                System.assert(false);
            } catch (System.DmlException e) {
                System.assert(e.getMessage().contains('disabled'));
            }
        }
    }

    @isTest public static void testFeedItemDeleteCustomSetting() {
        Chatter_Delete_Settings__c settings = new Chatter_Delete_Settings__c();
        settings.Allow_Feed_Post_And_Comment_deletes__c = true;
        settings.SetupOwnerId = UserInfo.getProfileID();
        upsert(settings);
        User u = [Select id,IsActive from User where email='testFeedItemDeleteDummy@testorg.com' LIMIT 1];
        try {
            System.runAs(u) {
                Id cid = u.id;

                // test single item delete
                FeedItem p = new FeedItem();
                p.parentId = cid;
                p.Body = 'force.com labs is great!';
                insert(p);
                delete(p);

                // now test bulk delete
                FeedItem[] ps = new FeedItem[150];
                for (Integer i = 0; i < 150; i++) {
                    ps[i] = new FeedItem();
                    ps[i].parentId = cid;
                    ps[i].body = 'force.com labs is great!';
                }
                insert(ps);
                delete(ps);
            }
        } finally {
            settings.Allow_Feed_Post_And_Comment_deletes__c = false;
            update(settings);
        }
    }
     @isTest
    public static void testFeedCommentDeleteCustomSetting() {
        Profile prof = [select id from profile where name = 'Standard User'];
        Chatter_Delete_Settings__c settings = new Chatter_Delete_Settings__c();
        settings.Allow_Feed_Post_And_Comment_deletes__c = true;
        settings.SetupOwnerId = prof.id;
        upsert(settings);
        User u = [Select id,IsActive from User where email='testFeedItemDeleteDummy@testorg.com' LIMIT 1];
        try {


           System.runAs(u) {
                // The following code runs as user 'u'   
                //insert a dummy contact we can post on
                Id cid = u.id;

                // test single item delete
                FeedItem p = new FeedItem();
                p.parentId = cid;
                p.Body = 'force.com labs is great!';

                Database.SaveResult sr = Database.Insert(p);
                System.assert(sr.isSuccess());
                Id pId = sr.getId();

                FeedComment c = new FeedComment();
                c.feedItemId = pid;
                c.CommentBody = 'this is a comment';
                insert(c);


                try{
              delete(c);  
            }catch(Exception e){
                system.debug('e');
            }

                // now test bulk delete
                FeedComment[] cs = new FeedComment[150];
                for (Integer i = 0; i < 150; i++) {
                    cs[i] = new FeedComment();
                    cs[i].feeditemid = pid;
                    cs[i].CommentBody = 'force.com labs is great!';
                }
                insert(cs);
                try{
              delete(cs);  
            }catch(Exception e){
                system.debug('e');
            }
            }
        } finally {
            settings.Allow_Feed_Post_And_Comment_deletes__c = false;
            update(settings);
        }

    }

}