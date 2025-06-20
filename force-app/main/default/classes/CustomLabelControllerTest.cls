@isTest
public class CustomLabelControllerTest{
	@isTest
	static void CustomLabelControllerTestMethod(){

		Custom_Label_Project__c  project = new Custom_Label_Project__c ();
		project.Name = 'PSPTest';
		insert project;

		CustomLabel__c label = new CustomLabel__c();
		label.Group__c = 'Test';
		label.Label__c = 'Test label';
		label.Project__c = project.Id;
		insert label;

		Translation__c translation = new Translation__c();
		translation.CustomLabel__c = label.id;
		translation.Language__c = 'American English';
		translation.Value__c = 'Test';
		insert translation;

		Test.startTest();
		CustomLabelController.getLabels('Test', 'American English');
		Test.stopTest();
	}
}