@istest
public class AFC_Requirements_test {

    @testSetup
    static void setup(){
        List<Flow_Signatures__c> settings = new List<Flow_Signatures__c>();

        settings.add(new Flow_Signatures__c(
        	name = 'Regional Head of School Services - IBA',
            signature__c = 'Salesforce Rocks!'
        ));

        settings.add(new Flow_Signatures__c(
        	name = 'Regional Head of School Services - AP',
            signature__c = 'Salesforce Rocks!'
        ));

        settings.add(new Flow_Signatures__c(
        	name = 'Regional Head of School Services - AEM',
            signature__c = 'Salesforce Rocks!'
        ));

        settings.add(new Flow_Signatures__c(
        	name = 'Regional Director - IBA',
            signature__c = 'Salesforce Rocks!'
        ));

        settings.add(new Flow_Signatures__c(
        	name = 'Regional Director - AP',
            signature__c = 'Salesforce Rocks!'
        ));

        settings.add(new Flow_Signatures__c(
        	name = 'Regional Director - AEM',
            signature__c = 'Salesforce Rocks!'
        ));
        
        settings.add(new Flow_Signatures__c(
        	name = 'Regional Director - IBA-FR',
            signature__c = 'Salesforce Rocks!'
        ));
        
        settings.add(new Flow_Signatures__c(
        	name = 'Regional Director - IBA-SP',
            signature__c = 'Salesforce Rocks!'
        ));

		insert settings;
    }

    static testmethod void letter_1_IBA(){
        Account acc = PimsTestUtil.createAccount('Test Account', '');
		insert acc;

		IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
		insert prog;
		
		Standards_Practices__c sNp = new Standards_Practices__c(
		    Standard__c = 'Collaborative planning',
            Practice_ID__c = 'qwertyuiopa',
            Programme_Choice__c = 'PYP'
        );
        insert sNp;
		
		IB_Action_Plan__c theActionPlan = new IB_Action_Plan__c(
            name = 'PYP_ActionPlan_1',
            AP_Standard_Practice__c  = sNp.Id,
            programme__c = prog.Id,
            AP_Action_Description__c = 'test',
            AP_Action_Type__c = 'MTBA',
            AP_Status__c = 'New'
        );
        insert theActionPlan;
        
        AFC_Requirements tmp = new AFC_Requirements();
        tmp.describe();

        Process.PluginResult result = tmp.invoke(new Process.PluginRequest(new Map<String,Object>{
            'Letter 1'=>true,
        	'Region'=>'IBA',
            'Language'=>'ENGLISH',
            'IB Programme ID'=>prog.Id
        }));

        system.assertNotEquals(null, result);
    }
    
    static testmethod void letter_1_IBA_EN(){
        Account acc = PimsTestUtil.createAccount('Test Account', '');
		insert acc;

		IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
		insert prog;
		
		AFC_Requirements tmp = new AFC_Requirements();
        tmp.describe();

        Process.PluginResult result = tmp.invoke(new Process.PluginRequest(new Map<String,Object>{
            'Letter 1'=>true,
        	'Region'=>'IBA',
            'Language'=>'ENGLISH',
            'IB Programme ID'=>prog.Id
        }));

        system.assertNotEquals(null, result);
    }
    
    static testmethod void letter_1_IBA_SP(){
        Account acc = PimsTestUtil.createAccount('Test Account', '');
		insert acc;

		IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
		insert prog;
		
		AFC_Requirements tmp = new AFC_Requirements();
        tmp.describe();

        Process.PluginResult result = tmp.invoke(new Process.PluginRequest(new Map<String,Object>{
            'Letter 1'=>true,
        	'Region'=>'IBA',
            'Language'=>'SPANISH',
            'IB Programme ID'=>prog.Id
        }));

        system.assertNotEquals(null, result);
    }
    
    static testmethod void letter_1_IBA_FR(){
        Account acc = PimsTestUtil.createAccount('Test Account', '');
		insert acc;

		IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
		insert prog;
		
		AFC_Requirements tmp = new AFC_Requirements();
        tmp.describe();

        Process.PluginResult result = tmp.invoke(new Process.PluginRequest(new Map<String,Object>{
            'Letter 1'=>true,
        	'Region'=>'IBA',
            'Language'=>'FRENCH',
            'IB Programme ID'=>prog.Id
        }));

        system.assertNotEquals(null, result);
    }
    
    static testmethod void letter_1_IBAP(){
        Account acc = PimsTestUtil.createAccount('Test Account', '');
		insert acc;

		IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
		insert prog;
		
        AFC_Requirements tmp = new AFC_Requirements();
        tmp.describe();

        Process.PluginResult result = tmp.invoke(new Process.PluginRequest(new Map<String,Object>{
            'Letter 1'=>true,
        	'Region'=>'IBAP',
            'Language'=>'ENGLISH',
            'IB Programme ID'=>prog.Id
        }));

        system.assertNotEquals(null, result);
    }
    
    static testmethod void letter_1_IBAEM(){
        Account acc = PimsTestUtil.createAccount('Test Account', '');
		insert acc;

		IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
		insert prog;
		
        AFC_Requirements tmp = new AFC_Requirements();
        tmp.describe();

        Process.PluginResult result = tmp.invoke(new Process.PluginRequest(new Map<String,Object>{
            'Letter 1'=>true,
        	'Region'=>'IBAEM',
            'Language'=>'ENGLISH',
            'IB Programme ID'=>prog.Id
        }));

        system.assertNotEquals(null, result);
    }
    
    static testmethod void letter_2_IBA(){
        Account acc = PimsTestUtil.createAccount('Test Account', '');
		insert acc;

		IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
		insert prog;
		
        AFC_Requirements tmp = new AFC_Requirements();
        tmp.describe();

        Process.PluginResult result = tmp.invoke(new Process.PluginRequest(new Map<String,Object>{
            'Letter 1'=>false,
        	'Region'=>'IBA',
            'Language'=>'ENGLISH',
            'IB Programme ID'=>prog.Id
        }));

        system.assertNotEquals(null, result);
    }
    
    static testmethod void letter_2_IBAP(){
        Account acc = PimsTestUtil.createAccount('Test Account', '');
		insert acc;

		IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
		insert prog;
		
        AFC_Requirements tmp = new AFC_Requirements();
        tmp.describe();

        Process.PluginResult result = tmp.invoke(new Process.PluginRequest(new Map<String,Object>{
            'Letter 1'=>false,
        	'Region'=>'IBAP',
            'Language'=>'ENGLISH',
            'IB Programme ID'=>prog.Id
        }));

        system.assertNotEquals(null, result);
    }
    
    static testmethod void letter_2_IBAEM(){
        Account acc = PimsTestUtil.createAccount('Test Account', '');
		insert acc;

		IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
		insert prog;
		
        AFC_Requirements tmp = new AFC_Requirements();
        tmp.describe();

        Process.PluginResult result = tmp.invoke(new Process.PluginRequest(new Map<String,Object>{
            'Letter 1'=>false,
        	'Region'=>'IBAEM',
            'Language'=>'ENGLISH',
            'IB Programme ID'=>prog.Id
        }));

        system.assertNotEquals(null, result);
    }
}