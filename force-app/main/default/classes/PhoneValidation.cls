public class PhoneValidation {
 public boolean edit_phone(Contact con){
        string citySelected = con.Country_Code__c;
        string phone_number = con.Phone_Number__c;
        boolean city = false;
        boolean roleAppUpd = false;
        boolean error = false;
		Integer len = phone_number.length();  
        
        	if (citySelected =='--None--' || citySelected =='--Aucun--' || citySelected =='--Ninguno--'){
				city = true;
			} 
			if( !city && phone_number!=Null  && len<=15 && len>3  && phone_number.isNumeric() ){
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

				String PhoneNumber2 ='';
				String strPh = phone_number;
				Boolean check=false;
				for(Integer x=0;x<strPh.length();x++){
					if((strPh.charAt(x)>=48 && strPh.charAt(x)<=57)){
						PhoneNumber2 = PhoneNumber2+String.valueOf((strPh.charAt(x)-48));
					}
				}
                
                FinalPh=FinalPh+PhoneNumber2;
                con.Phone = FinalPh;
				system.debug('FinalPh : ' + FinalPh);
              
			}
			else{
                return true;
			}
        return false;
	}
 /** 
	* @author Ammara
	* @date 03/24/2021
	* @description Validate the contact added phone and Country Code.
    * @returntype Boolean
	* @param Contact_Information__c conInfoPhone,String citySelected,String phone, IB_Role__c roleApp
*/
    public boolean edit_phone_contact_Info(Contact_Information__c conInfoPhone,String citySelected,String phone, IB_Role__c roleApp){
        if(conInfoPhone != null && conInfoPhone.Country_Code__c != null)
         citySelected = conInfoPhone.Country_Code__c;
          if(conInfoPhone != null && conInfoPhone.Phone_Number__c != null)
         phone = conInfoPhone.Phone_Number__c;
        boolean city = false;
        boolean roleAppUpd = false;
        Integer len;
        	if (citySelected == null || citySelected == '' || citySelected =='--None--' || citySelected =='--Aucun--' || citySelected =='--Ninguno--'){
				city = true;
			} 
        if( !city && Phone!=Null ){
           len = Phone.length();  
                if( len<=15 && len>3  && Phone.isNumeric() ){
        System.debug('city: '+citySelected);
         System.debug('phone: '+phone);
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
					if((strPh.charAt(x)>=48 && strPh.charAt(x)<=57)){
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
                                                                                                Country_Code__c = cityselected,
                                                                                                Phone_Number__c = PhoneNumber,
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
        else
            return true;
    }
			else{
                return true;
			}
        return false;
	}
         /** 
	* @author Ammara
	* @date 03/24/2021
	* @description Validate the contact added phone and Country Code.
    * @returntype Boolean
	* @param N/A
	*/
     public boolean edit_phone_contact_Info(String Country_Code,String phonenumber,String phone){
        string citySelected = Country_Code;
        string phone_number = phonenumber;
        boolean city = false;
        boolean roleAppUpd = false;
        boolean error = false;
		Integer len = phone_number.length();  
        System.debug('city: '+citySelected);
         System.debug('phone: '+phone);
        	if (citySelected =='-None-' || citySelected =='-Aucun-' || citySelected =='-Ninguno-' || city == null ){// Removed || phone == null by Kashyap as a Part of ECM00562 bug fix
				city = true;
			} 
         //Condtions updated for ECM226 as part of Staff-Aug Project
			if( !city && phone_number!=Null  && len<=15 && len>3  && phone_number.isNumeric() ){
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

				String PhoneNumber2 ='';
				String strPh = phone_number;
				Boolean check=false;
				for(Integer x=0;x<strPh.length();x++){
					if((strPh.charAt(x)>=48 && strPh.charAt(x)<=57)){
						PhoneNumber2 = PhoneNumber2+String.valueOf((strPh.charAt(x)-48));
					}
				}
                FinalPh=FinalPh+PhoneNumber2;
                Phone = FinalPh;
				system.debug('FinalPh : ' + FinalPh);
              
			}
			else{
                return true;
			}
        return false;
	}
    public boolean edit_phone_account(Account account){
        string citySelected = account.Dial_code__c;
        string phone_number = account.Phone_Number__c;
        boolean city = false;
        boolean roleAppUpd = false;
        boolean error = false;
		Integer len = phone_number.length();  
        
        	if (citySelected =='--None--' || citySelected =='--Aucun--' || citySelected =='--Ninguno--'){
				city = true;
			} 
			if( !city && phone_number!=Null  && len<=15 && len>3  && phone_number.isNumeric() ){
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

				String PhoneNumber2 ='';
				String strPh = phone_number;
				Boolean check=false;
				for(Integer x=0;x<strPh.length();x++){
					if((strPh.charAt(x)>=48 && strPh.charAt(x)<=57)){
						PhoneNumber2 = PhoneNumber2+String.valueOf((strPh.charAt(x)-48));
					}
				}
				
                
                FinalPh=FinalPh+PhoneNumber2;
                account.Phone = FinalPh;
				system.debug('FinalPh : ' + FinalPh);
              
			}
			else{
                return true;
			}
        return false;
	}
}