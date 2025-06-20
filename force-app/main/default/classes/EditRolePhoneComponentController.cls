/**		
	* <h1>Update Roles & Applications Phone Field</h1>		
	* This class is responsible for Updating the phone field on Roles & Applications object,ECM00192.
	* 
	* @author  Arunkumar Kathiravan		
	* @version 1.0		
	* @since   02-02-2021
	
Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 


*/

public class EditRolePhoneComponentController {
    private IBPortalSettingsUtil util;
    //public User user {get;private set;}
    public String addStep{get;set;}
	public String roleAppId{get;set;}
    public String citySelected{get; set;}
    public IB_Role__c roleApp{get;set;}
    public boolean error {get; set;}
    //public string redirecturl {get;set;}
    public string phone{get;set;}
	public Contact_Information__c conInfoPhone {get;set;}

	/**
	* This constructor get the phone number of role&App,ECM00192.
	* @author: Arunkumar Kathiravan
	* @since 02-02-2021
	* @param No parameter.
	* @return No return Type.
	*/
    public EditRolePhoneComponentController(){
        util = IBPortalSettingsUtil.getInstance();
		system.debug('roleAppId: ' + roleAppId);
		/*if(roleAppId != null){
			Id roleAppID = Id.valueOf(roleAppId);
			roleApp = [select id, IB_Contact__c, Contact_Information_Phone__c, Contact_Information_Phone__r.phone__c from IB_Role__c where ID =: roleAppID];
			conInfoPhone = new Contact_Information__c(id = roleApp.Contact_Information_Phone__c, phone__c = roleApp.Contact_Information_Phone__r.phone__c);
		}*/
    }

	/**		
	* This Method is responsible for getting the country codes and names,ECM00192.
	* @author: Arunkumar Kathiravan
	* @since 02-02-2021
	* @param No Parameter.		
	* @return List of SelectOption.		
	*/
	public List<SelectOption> getcitynames(){
		list<SelectOption> pickListValuesList= new list<SelectOption>();
		Schema.DescribeFieldResult fieldResult = IB_Country_Segmentation__c.Country_Codes__c.getDescribe();
		list<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(new SelectOption(pickListVal.getLabel(),pickListVal.getLabel()));
		}     
		return pickListValuesList;
	}
	/**		
	* This Method is responsible for processing the and updating phone field with specific format,ECM00192.
	* @author: Arunkumar Kathiravan
	* @since 02-02-2021
	* @param No Parameter.		
	* @return pageReference.		
	*/
	public pagereference create(){
		try{
			Boolean roleAppUpd = false;
			system.debug('roleAppId: ' + roleAppId);
			if(roleAppId != null){
				Id roleAppID = Id.valueOf(roleAppId);
                system.debug('roleAppId: ' + roleAppId);
				roleApp = [select id, IB_Contact__c, Contact_Information_Phone__c, Contact_Information_Phone__r.phone__c from IB_Role__c where ID =: roleAppID];
				conInfoPhone = new Contact_Information__c(id = roleApp.Contact_Information_Phone__c, phone__c = roleApp.Contact_Information_Phone__r.phone__c);
			}
			error = false;
			Integer len = Phone.length();  
			boolean city = false;
			if (citySelected =='--None--' || citySelected =='--Aucun--' || citySelected =='--Ninguno--'){
				city = true;
			} 
			if( !city && Phone!=Null  && len<=15 && len>8  && Phone.isNumeric() ){
				String []str=citySelected.split('\\(');
				String []strFinal=str[1].split('\\)');
				String FinalPh='';
				String countCode=strFinal[0];
				FinalPh=FinalPh+'+';
				for(Integer x=1;x<countCode.length();x++){
					if((countCode.charAt(x)>=48 && countCode.charAt(x)<=57)){
						FinalPh=FinalPh+String.valueOf((countCode.charAt(x)-48));
					}
				}

				String PhoneNumber='';
				String strPh = Phone;
				Boolean check=false;
				for(Integer x=0;x<strPh.length();x++){
					if(strPh.charAt(x)!=48){
						check = true;
					}
					if((strPh.charAt(x)>=48 && strPh.charAt(x)<=57) && check == true ){
						PhoneNumber = PhoneNumber+String.valueOf((strPh.charAt(x)-48));
					}
				}
				FinalPh=FinalPh+PhoneNumber;
				system.debug('conInfoPhone : ' + conInfoPhone);
				system.debug('conInfoPhone.Phone__c : ' + conInfoPhone.Phone__c);
				system.debug('FinalPh : ' + FinalPh);
				if(conInfoPhone.Phone__c != FinalPh){
					list<Contact_Information__c> listExistingConInfoPhone = [select Name, Phone__c from Contact_Information__c where IB_Contact__c =: roleApp.IB_Contact__c AND Phone__c =: FinalPh limit 1];
					if(listExistingConInfoPhone != null && !listExistingConInfoPhone.isEmpty()){
						for(Contact_Information__c conPhone : listExistingConInfoPhone){
							roleApp.Contact_Information_Phone__c = conPhone.Id;
							roleAppUpd = true;
						}
					}
					else{
						Contact_Information__c newConInfoPhone = new Contact_Information__c(IB_Contact__c = roleApp.IB_Contact__c, Phone__c = FinalPh,
																								Name = FinalPh, 
																								RecordTypeId=Schema.SObjectType.Contact_Information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId());
						insert newConInfoPhone;
						roleApp.Contact_Information_Phone__c = newConInfoPhone.Id;
						roleAppUpd = true;
					}
				}
				if(roleAppUpd){
					update roleApp;
				}
			}
			else{
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Phone_format));
				Phone = null;
				error = true;
				addStep = 'X';
				IBPortalEditRoleInfoController.error = false;
				IBPortalEditRoleInfoController.error1 = false;
			}
		}
		catch(Exception e){
			system.debug('Error Message: ' + e.getMessage());
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
		}
		system.debug('message =' + ApexPages.hasMessages() );
		return ApexPages.hasMessages() ? null : new PageReference('/ibportal/IBPortalEditRoleInfo?id='+roleAppId);
	}
}