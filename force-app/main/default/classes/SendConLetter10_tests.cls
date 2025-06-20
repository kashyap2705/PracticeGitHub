@istest
public class SendConLetter10_tests {

	public static final String SIGKEY = 'TEST';

	@testSetup
	static void setupData(){

		insert new Flow_Signatures__c(
			Name = SIGKEY,
			Signature__c = 'Test'
		);

		insert new Account(
			Name = 'gg',
			Country__c = 'aa',
			Sub_region__c = 'ss',
			Region__c = 'IBAEM',
			Language_Of_Correspondance__c = 'English',
			Legal_Status__c = 'Legit',
			Short_Name__c = 'too Legal_Status__c to quit',
			IBIS_ID__c = '000000'
		);

		insert new Campaign(
			RecordTypeId = [select Id from RecordType where SobjectType = 'Campaign' and DeveloperName = 'Evaluation'][0].Id,
			CampaignMemberRecordTypeId = [select Id from RecordType where SobjectType = 'CampaignMember' and DeveloperName = 'IBEN'][0].Id,
			Name = 'test',
			Type = 'Evaluation',
			Event_Organizer_Account__c = [select id from account limit 1][0].Id,
			Sub_Type__c = 'test'
		);
	}
	static testmethod void english_pyp(){

		Boolean hasException = false;

		System.Test.starttest();
			try{
				SendConLetter10 con = new SendConLetter10();
				Process.PluginDescribeResult tmp = con.describe();
				con.invoke(new Process.PluginRequest(new Map<String,Object>{
			        SendConLetter10.COORD_NAME => 'test',
			        SendConLetter10.SCHOOL_NAME => 'test',
			        SendConLetter10.PROG_NAME => 'PYP',
			        SendConLetter10.CON_NAME => 'test',
			        SendConLetter10.CON_EMAIL => 'test',
			        SendConLetter10.THE_YEAR => 'test',
			        SendConLetter10.SIGNATURE => SIGKEY,
			        SendConLetter10.THE_DATE => 'test',
			        SendConLetter10.CP_PHASE => 'test',
			        SendConLetter10.TO_ADDRESS => 'Robert.strunk@coastalcloud.us',
			        SendConLetter10.LANG => 'ENGLISH',
			        SendConLetter10.IB_EVENT_ID => [select Id from Campaign limit 1][0].Id
				}));
			}
			catch(Exception e){
				hasException = true;
			}

		System.Test.stopTest();

		System.assertEquals(false, hasException);
	}
	static testmethod void english_myp(){

		Boolean hasException = false;

		System.Test.starttest();
			try{
				SendConLetter10 con = new SendConLetter10();
				Process.PluginDescribeResult tmp = con.describe();
				con.invoke(new Process.PluginRequest(new Map<String,Object>{
			        SendConLetter10.COORD_NAME => 'test',
			        SendConLetter10.SCHOOL_NAME => 'test',
			        SendConLetter10.PROG_NAME => 'MYP',
			        SendConLetter10.CON_NAME => 'test',
			        SendConLetter10.CON_EMAIL => 'test',
			        SendConLetter10.THE_YEAR => 'test',
			        SendConLetter10.SIGNATURE => SIGKEY,
			        SendConLetter10.THE_DATE => 'test',
			        SendConLetter10.CP_PHASE => 'test',
			        SendConLetter10.TO_ADDRESS => 'Robert.strunk@coastalcloud.us',
			        SendConLetter10.LANG => 'ENGLISH',
			        SendConLetter10.IB_EVENT_ID => [select Id from Campaign limit 1][0].Id
				}));
			}
			catch(Exception e){
				hasException = true;
			}

		System.Test.stopTest();

		System.assertEquals(false, hasException);
	}
	static testmethod void english_cp(){

		Boolean hasException = false;

		System.Test.starttest();
			try{
				SendConLetter10 con = new SendConLetter10();
				Process.PluginDescribeResult tmp = con.describe();
				con.invoke(new Process.PluginRequest(new Map<String,Object>{
			        SendConLetter10.COORD_NAME => 'test',
			        SendConLetter10.SCHOOL_NAME => 'test',
			        SendConLetter10.PROG_NAME => 'CP',
			        SendConLetter10.CON_NAME => 'test',
			        SendConLetter10.CON_EMAIL => 'test',
			        SendConLetter10.THE_YEAR => 'test',
			        SendConLetter10.SIGNATURE => SIGKEY,
			        SendConLetter10.THE_DATE => 'test',
			        SendConLetter10.CP_PHASE => 'test',
			        SendConLetter10.TO_ADDRESS => 'Robert.strunk@coastalcloud.us',
			        SendConLetter10.LANG => 'ENGLISH',
			        SendConLetter10.IB_EVENT_ID => [select Id from Campaign limit 1][0].Id
				}));
			}
			catch(Exception e){
				hasException = true;
			}

		System.Test.stopTest();

		System.assertEquals(false, hasException);
	}
	static testmethod void english_cp1(){

		Boolean hasException = false;

		System.Test.starttest();
			try{
				SendConLetter10 con = new SendConLetter10();
				Process.PluginDescribeResult tmp = con.describe();
				con.invoke(new Process.PluginRequest(new Map<String,Object>{
			        SendConLetter10.COORD_NAME => 'test',
			        SendConLetter10.SCHOOL_NAME => 'test',
			        SendConLetter10.PROG_NAME => 'CP',
			        SendConLetter10.CON_NAME => 'test',
			        SendConLetter10.CON_EMAIL => 'test',
			        SendConLetter10.THE_YEAR => 'test',
			        SendConLetter10.SIGNATURE => SIGKEY,
			        SendConLetter10.THE_DATE => 'test',
			        SendConLetter10.CP_PHASE => 'Phase 1',
			        SendConLetter10.TO_ADDRESS => 'Robert.strunk@coastalcloud.us',
			        SendConLetter10.LANG => 'ENGLISH',
			        SendConLetter10.IB_EVENT_ID => [select Id from Campaign limit 1][0].Id
				}));
			}
			catch(Exception e){
				hasException = true;
			}

		System.Test.stopTest();

		System.assertEquals(false, hasException);
	}
	static testmethod void english_dp(){

		Boolean hasException = false;

		System.Test.starttest();
			try{
				SendConLetter10 con = new SendConLetter10();
				Process.PluginDescribeResult tmp = con.describe();
				con.invoke(new Process.PluginRequest(new Map<String,Object>{
			        SendConLetter10.COORD_NAME => 'test',
			        SendConLetter10.SCHOOL_NAME => 'test',
			        SendConLetter10.PROG_NAME => 'DP',
			        SendConLetter10.CON_NAME => 'test',
			        SendConLetter10.CON_EMAIL => 'test',
			        SendConLetter10.THE_YEAR => 'test',
			        SendConLetter10.SIGNATURE => SIGKEY,
			        SendConLetter10.THE_DATE => 'test',
			        SendConLetter10.CP_PHASE => 'test',
			        SendConLetter10.TO_ADDRESS => 'Robert.strunk@coastalcloud.us',
			        SendConLetter10.LANG => 'ENGLISH',
			        SendConLetter10.IB_EVENT_ID => [select Id from Campaign limit 1][0].Id
				}));
			}
			catch(Exception e){
				hasException = true;
			}

		System.Test.stopTest();

		System.assertEquals(false, hasException);
	}
	static testmethod void spanish_pyp(){

		Boolean hasException = false;

		System.Test.starttest();
			try{
				SendConLetter10 con = new SendConLetter10();
				Process.PluginDescribeResult tmp = con.describe();
				con.invoke(new Process.PluginRequest(new Map<String,Object>{
			        SendConLetter10.COORD_NAME => 'test',
			        SendConLetter10.SCHOOL_NAME => 'test',
			        SendConLetter10.PROG_NAME => 'PYP',
			        SendConLetter10.CON_NAME => 'test',
			        SendConLetter10.CON_EMAIL => 'test',
			        SendConLetter10.THE_YEAR => 'test',
			        SendConLetter10.SIGNATURE => SIGKEY,
			        SendConLetter10.THE_DATE => 'test',
			        SendConLetter10.CP_PHASE => 'test',
			        SendConLetter10.TO_ADDRESS => 'Robert.strunk@coastalcloud.us',
			        SendConLetter10.LANG => 'SPANISH',
			        SendConLetter10.IB_EVENT_ID => [select Id from Campaign limit 1][0].Id
				}));
			}
			catch(Exception e){
				hasException = true;
			}

		System.Test.stopTest();

		System.assertEquals(false, hasException);
	}
	static testmethod void spanish_myp(){

		Boolean hasException = false;

		System.Test.starttest();
			try{
				SendConLetter10 con = new SendConLetter10();
				Process.PluginDescribeResult tmp = con.describe();
				con.invoke(new Process.PluginRequest(new Map<String,Object>{
			        SendConLetter10.COORD_NAME => 'test',
			        SendConLetter10.SCHOOL_NAME => 'test',
			        SendConLetter10.PROG_NAME => 'MYP',
			        SendConLetter10.CON_NAME => 'test',
			        SendConLetter10.CON_EMAIL => 'test',
			        SendConLetter10.THE_YEAR => 'test',
			        SendConLetter10.SIGNATURE => SIGKEY,
			        SendConLetter10.THE_DATE => 'test',
			        SendConLetter10.CP_PHASE => 'test',
			        SendConLetter10.TO_ADDRESS => 'Robert.strunk@coastalcloud.us',
			        SendConLetter10.LANG => 'SPANISH',
			        SendConLetter10.IB_EVENT_ID => [select Id from Campaign limit 1][0].Id
				}));
			}
			catch(Exception e){
				hasException = true;
			}

		System.Test.stopTest();

		System.assertEquals(false, hasException);
	}
	static testmethod void spanish_cp(){

		Boolean hasException = false;

		System.Test.starttest();
			try{
				SendConLetter10 con = new SendConLetter10();
				Process.PluginDescribeResult tmp = con.describe();
				con.invoke(new Process.PluginRequest(new Map<String,Object>{
			        SendConLetter10.COORD_NAME => 'test',
			        SendConLetter10.SCHOOL_NAME => 'test',
			        SendConLetter10.PROG_NAME => 'CP',
			        SendConLetter10.CON_NAME => 'test',
			        SendConLetter10.CON_EMAIL => 'test',
			        SendConLetter10.THE_YEAR => 'test',
			        SendConLetter10.SIGNATURE => SIGKEY,
			        SendConLetter10.THE_DATE => 'test',
			        SendConLetter10.CP_PHASE => 'test',
			        SendConLetter10.TO_ADDRESS => 'Robert.strunk@coastalcloud.us',
			        SendConLetter10.LANG => 'SPANISH',
			        SendConLetter10.IB_EVENT_ID => [select Id from Campaign limit 1][0].Id
				}));
			}
			catch(Exception e){
				hasException = true;
			}

		System.Test.stopTest();

		System.assertEquals(false, hasException);
	}
	static testmethod void spanish_cp1(){

		Boolean hasException = false;

		System.Test.starttest();
			try{
				SendConLetter10 con = new SendConLetter10();
				Process.PluginDescribeResult tmp = con.describe();
				con.invoke(new Process.PluginRequest(new Map<String,Object>{
			        SendConLetter10.COORD_NAME => 'test',
			        SendConLetter10.SCHOOL_NAME => 'test',
			        SendConLetter10.PROG_NAME => 'CP',
			        SendConLetter10.CON_NAME => 'test',
			        SendConLetter10.CON_EMAIL => 'test',
			        SendConLetter10.THE_YEAR => 'test',
			        SendConLetter10.SIGNATURE => SIGKEY,
			        SendConLetter10.THE_DATE => 'test',
			        SendConLetter10.CP_PHASE => 'Phase 1',
			        SendConLetter10.TO_ADDRESS => 'Robert.strunk@coastalcloud.us',
			        SendConLetter10.LANG => 'SPANISH',
			        SendConLetter10.IB_EVENT_ID => [select Id from Campaign limit 1][0].Id
				}));
			}
			catch(Exception e){
				hasException = true;
			}

		System.Test.stopTest();

		System.assertEquals(false, hasException);
	}
	static testmethod void spanish_dp(){

		Boolean hasException = false;

		System.Test.starttest();
			try{
				SendConLetter10 con = new SendConLetter10();
				Process.PluginDescribeResult tmp = con.describe();
				con.invoke(new Process.PluginRequest(new Map<String,Object>{
			        SendConLetter10.COORD_NAME => 'test',
			        SendConLetter10.SCHOOL_NAME => 'test',
			        SendConLetter10.PROG_NAME => 'DP',
			        SendConLetter10.CON_NAME => 'test',
			        SendConLetter10.CON_EMAIL => 'test',
			        SendConLetter10.THE_YEAR => 'test',
			        SendConLetter10.SIGNATURE => SIGKEY,
			        SendConLetter10.THE_DATE => 'test',
			        SendConLetter10.CP_PHASE => 'test',
			        SendConLetter10.TO_ADDRESS => 'Robert.strunk@coastalcloud.us',
			        SendConLetter10.LANG => 'SPANISH',
			        SendConLetter10.IB_EVENT_ID => [select Id from Campaign limit 1][0].Id
				}));
			}
			catch(Exception e){
				hasException = true;
			}

		System.Test.stopTest();

		System.assertEquals(false, hasException);
	}
	static testmethod void french_pyp(){

		Boolean hasException = false;

		System.Test.starttest();
			try{
				SendConLetter10 con = new SendConLetter10();
				Process.PluginDescribeResult tmp = con.describe();
				con.invoke(new Process.PluginRequest(new Map<String,Object>{
			        SendConLetter10.COORD_NAME => 'test',
			        SendConLetter10.SCHOOL_NAME => 'test',
			        SendConLetter10.PROG_NAME => 'PYP',
			        SendConLetter10.CON_NAME => 'test',
			        SendConLetter10.CON_EMAIL => 'test',
			        SendConLetter10.THE_YEAR => 'test',
			        SendConLetter10.SIGNATURE => SIGKEY,
			        SendConLetter10.THE_DATE => 'test',
			        SendConLetter10.CP_PHASE => 'test',
			        SendConLetter10.TO_ADDRESS => 'Robert.strunk@coastalcloud.us',
			        SendConLetter10.LANG => 'FRENCH',
			        SendConLetter10.IB_EVENT_ID => [select Id from Campaign limit 1][0].Id
				}));
			}
			catch(Exception e){
				hasException = true;
			}

		System.Test.stopTest();

		System.assertEquals(false, hasException);
	}
	static testmethod void french_myp(){

		Boolean hasException = false;

		System.Test.starttest();
			try{
				SendConLetter10 con = new SendConLetter10();
				Process.PluginDescribeResult tmp = con.describe();
				con.invoke(new Process.PluginRequest(new Map<String,Object>{
			        SendConLetter10.COORD_NAME => 'test',
			        SendConLetter10.SCHOOL_NAME => 'test',
			        SendConLetter10.PROG_NAME => 'MYP',
			        SendConLetter10.CON_NAME => 'test',
			        SendConLetter10.CON_EMAIL => 'test',
			        SendConLetter10.THE_YEAR => 'test',
			        SendConLetter10.SIGNATURE => SIGKEY,
			        SendConLetter10.THE_DATE => 'test',
			        SendConLetter10.CP_PHASE => 'test',
			        SendConLetter10.TO_ADDRESS => 'Robert.strunk@coastalcloud.us',
			        SendConLetter10.LANG => 'FRENCH',
			        SendConLetter10.IB_EVENT_ID => [select Id from Campaign limit 1][0].Id
				}));
			}
			catch(Exception e){
				hasException = true;
			}

		System.Test.stopTest();

		System.assertEquals(false, hasException);
	}
	static testmethod void french_cp(){

		Boolean hasException = false;

		System.Test.starttest();
			try{
				SendConLetter10 con = new SendConLetter10();
				Process.PluginDescribeResult tmp = con.describe();
				con.invoke(new Process.PluginRequest(new Map<String,Object>{
			        SendConLetter10.COORD_NAME => 'test',
			        SendConLetter10.SCHOOL_NAME => 'test',
			        SendConLetter10.PROG_NAME => 'CP',
			        SendConLetter10.CON_NAME => 'test',
			        SendConLetter10.CON_EMAIL => 'test',
			        SendConLetter10.THE_YEAR => 'test',
			        SendConLetter10.SIGNATURE => SIGKEY,
			        SendConLetter10.THE_DATE => 'test',
			        SendConLetter10.CP_PHASE => 'test',
			        SendConLetter10.TO_ADDRESS => 'Robert.strunk@coastalcloud.us',
			        SendConLetter10.LANG => 'FRENCH',
			        SendConLetter10.IB_EVENT_ID => [select Id from Campaign limit 1][0].Id
				}));
			}
			catch(Exception e){
				hasException = true;
			}

		System.Test.stopTest();

		System.assertEquals(false, hasException);
	}
	static testmethod void french_cp1(){

		Boolean hasException = false;

		System.Test.starttest();
			try{
				SendConLetter10 con = new SendConLetter10();
				Process.PluginDescribeResult tmp = con.describe();
				con.invoke(new Process.PluginRequest(new Map<String,Object>{
			        SendConLetter10.COORD_NAME => 'test',
			        SendConLetter10.SCHOOL_NAME => 'test',
			        SendConLetter10.PROG_NAME => 'CP',
			        SendConLetter10.CON_NAME => 'test',
			        SendConLetter10.CON_EMAIL => 'test',
			        SendConLetter10.THE_YEAR => 'test',
			        SendConLetter10.SIGNATURE => SIGKEY,
			        SendConLetter10.THE_DATE => 'test',
			        SendConLetter10.CP_PHASE => 'Phase 1',
			        SendConLetter10.TO_ADDRESS => 'Robert.strunk@coastalcloud.us',
			        SendConLetter10.LANG => 'FRENCH',
			        SendConLetter10.IB_EVENT_ID => [select Id from Campaign limit 1][0].Id
				}));
			}
			catch(Exception e){
				hasException = true;
			}

		System.Test.stopTest();

		System.assertEquals(false, hasException);
	}
	static testmethod void french_dp(){

		Boolean hasException = false;

		System.Test.starttest();
			try{
				SendConLetter10 con = new SendConLetter10();
				Process.PluginDescribeResult tmp = con.describe();
				con.invoke(new Process.PluginRequest(new Map<String,Object>{
			        SendConLetter10.COORD_NAME => 'test',
			        SendConLetter10.SCHOOL_NAME => 'test',
			        SendConLetter10.PROG_NAME => 'DP',
			        SendConLetter10.CON_NAME => 'test',
			        SendConLetter10.CON_EMAIL => 'test',
			        SendConLetter10.THE_YEAR => 'test',
			        SendConLetter10.SIGNATURE => SIGKEY,
			        SendConLetter10.THE_DATE => 'test',
			        SendConLetter10.CP_PHASE => 'test',
			        SendConLetter10.TO_ADDRESS => 'Robert.strunk@coastalcloud.us',
			        SendConLetter10.LANG => 'FRENCH',
			        SendConLetter10.IB_EVENT_ID => [select Id from Campaign limit 1][0].Id
				}));
			}
			catch(Exception e){
				hasException = true;
			}

		System.Test.stopTest();

		System.assertEquals(false, hasException);
	}
	static testMethod void unsupportedLanguage(){

		Boolean hasError = false;

		try{
			SendConLetter10.localizeProgName('Latin', 'DP');
		}
		catch(SendConLetter10.UnsupportedException e){
			hasError = true;
		}

		System.assert(hasError);
	}
	static testmethod void unsupportedLanguage_2(){

		List<Task> allTasks = [select id from task];
		System.assertEquals(allTasks.size(), 0);

		Boolean hasException = false;

		System.Test.starttest();
			try{

				Letter10 sampleLetter = new Letter10();

				sampleLetter.coordName = 'test';
				sampleLetter.schoolName = 'test';
				sampleLetter.progName = 'test';
				sampleLetter.conName = 'test';
				sampleLetter.conEmail = 'test@test.com';
				sampleLetter.year = 'test';
				sampleLetter.signature1 = 'test';
				sampleLetter.theDate = 'test';
				sampleLetter.toAddress = 'test';
				sampleLetter.orgWideEmail = 'test';
				sampleLetter.conId = 'test';
				sampleLetter.lang = 'Latin';
				sampleLetter.ibEventId = [select Id from Campaign limit 1][0].Id;
				sampleLetter.hosEmail = 'test@test.com';

				SendConLetter10.sendEmail(
					JSON.serialize(
						sampleLetter
					)
				);
			}
			catch(Exception e){
				hasException = true;
			}

		System.Test.stopTest();

		System.assertEquals(false, hasException);

		allTasks = [select id from task];
		System.assertEquals(allTasks.size(), 1);
	}
	static testMethod void unsupportedProgramme(){

		Boolean hasError = false;

		try{
			SendConLetter10.localizeProgName('english', 'xkcd');
		}
		catch(SendConLetter10.UnsupportedException e){
			hasError = true;
		}

		System.assert(hasError);
	}
}