/**		
* <h1>ContactTriggerHandler</h1>		
* This class is responsible for calling the functionality of diffrenet triggers functionality ,US11103.
* 
* @author  Abd Ur Rehman		
* @version 1.0		
* @since   28-1-2020

Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 


*/
public class ContactTriggerHandler {

	/**		
	* This Method is responsible for updateUserName trigger functionality,US11103.
	* @author: Abd Ur Rehman-Plumlogix 
	* @since 28-1-2020
	* @param list of contact and a user.		
	* @return void.		
	*/
	public static void updateUserName(List<Contact> cntct , user usr ){
		if(system.isFuture()) return;
		if(system.isBatch()) return;
		if (cntct.size() > 1) return;
		if(usr.Profile.Name == 'ibportal Profile') return;
		// Starting
		Map<id,Contact> map_var= new Map<id,Contact>();
		for(Contact cont: cntct){
			map_var.put(cont.ID,cont);
		}
		Set<id> conIds = map_var.keySet() ;

		if(conIds.size() > 0 ) {
			List <User> userToUpdate = [ SELECT firstName, LastName,contactID,  ID from user where contactID IN :conIds ];                
			for(Contact cont: cntct) {
				for(User us : userToUpdate){
					if( cont.ID == us.contactID ){
						us.firstName = cont.firstName;
						us.lastName = cont.LastName;
					}
				}
			}
			if(! userToUpdate.isEmpty() ){
				update userToUpdate;
			}
		}
		system.debug('Trigger to update first Name of a user' + cntct.size() );
	}

	/**		
	* This Method is responsible for updatePossibleDuplicateMerge trigger functionality,US11103.
	* @author: Abd Ur Rehman-Plumlogix 
	* @since 28-1-2020
	* @param list of contact.		
	* @return void.		
	*/
	public static void updatePossibleDuplicateMerge1(List<Contact> cntct){
		for (Contact a : cntct) {
			if(Possibleduplicate.conIDs != null ){
				if(Possibleduplicate.conIDs.contains(a.id)){
					if(a.Possible_Duplicate__c != null){
						a.Possible_Duplicate__c = False;
					}
				}
			}
		}
	}

	/**		
	* This Method is responsible for updatePossibleDuplicateMerge trigger functionality,US11103.
	* @author: Abd Ur Rehman-Plumlogix 
	* @since 28-1-2020
	* @param list of contact.		
	* @return void.		
	*/
	public static void updatePossibleDuplicateMerge(List<Contact> cntct){
		Possibleduplicate.conIDs = new set<Id>();
		for (Contact a : cntct) {
			//If the Record has been deleted through a merge, add winning Contact of merge to List
			if (a.MasterRecordId != NULL) {
				Possibleduplicate.conIDs.add(a.MasterRecordId);
			}
		}
	}

	/**		
	* This Method is responsible for updating User__c field on contact after merge.
	* @author: Arunkumar Kathiravan 
	* @since May-2021
	* @param list of deleted contacts.		
	* @return void.		
	*/
	public static void updateContUser(List<Contact> cntct){
		set<id> setMasterContIds = new set<id>();
		map<id, id> mapUserIdsToContIds = new map<id, id>();
		for (Contact con : cntct) {
			//If the Record has been deleted through a merge, add winning Contact of merge to List
			if (con.MasterRecordId != null) {
				setMasterContIds.add(con.MasterRecordId);
			}
		}
		if(!setMasterContIds.isEmpty()){
			for(User usr : [select Id, ContactId from User where ContactId IN: setMasterContIds]){
				mapUserIdsToContIds.put(usr.Id, usr.ContactId);
			}
		}
		if(!mapUserIdsToContIds.isEmpty()){
			if(!system.isFuture()){
				Utils.updateCont_User(mapUserIdsToContIds);
			}
		}
	}

	/**		
	* This Method is responsible for ContactTrigger trigger functionality,US11103.
	* @author: Abd Ur Rehman-Plumlogix 
	* @since 28-1-2020
	* @param list of contact.		
	* @return void.		
	*/
	public static void ContactTrigger(List<Contact> cntct){
		for (Contact c : cntct) {
			Blob targetBlob = Blob.valueOf(c.FirstName + c.LastName + String.valueOf(DateTime.now()));
			Blob hash = Crypto.generateDigest('SHA256', targetBlob);
			c.Invitation_ID__c = EncodingUtil.convertToHex(hash);
		}
	}
	/**		
	* This Method is responsible for AutomateoncheckDeceased trigger functionality,US11103.
	* @author: Abd Ur Rehman-Plumlogix 
	* @since 28-1-2020
	* @param list of contact and a map<id ,contact>.		
	* @return void.		
	*/
	public static void AutomateoncheckDeceased(list<Contact> Cntct ,map<id , Contact> Oldcontact){
		if(checkRecursive.runOnce()){
			Set<Id> contactIds = new Set<Id>();
			//loop over all contact Ids and if deceased flag has been updated add to list
			for(Contact c:cntct){
				boolean check=Oldcontact.get(c.Id).Deceased__c;
				system.debug('deceased value' + check );
				if(c.Deceased__c !=check  && c.Deceased__c == true){
					contactIds.add(c.Id);
				}
				//contactIds.add(c.Id);
			}

			//query all roles and applications record where contact flag has been updated and end date is null
			List<IB_Role__c> ibrolelist = [SELECT Id FROM IB_Role__c WHERE IB_Contact__c in :contactIds AND End_Date__c = null];
			for(IB_Role__c r:ibrolelist){
				r.End_Date__c = System.today();
			}
			//if there are records to update, update them
			if(ibrolelist.size() > 0){
				update ibrolelist;
			}			
		}
	}

	/**		
	* This Method is responsible for contact_all trigger functionality,US11103.
	* @author: Abd Ur Rehman-Plumlogix 
	* @since 28-1-2020
	* @param list of contact.		
	* @return void.		
	*/
    
    
      /*** Aded by Kashyap POC***/ 
    public static void updateCountryOfResidenceSegmentation(List< Contact> newContact ,List<Contact>  oldContact, Map<Id,Contact> oldMap){
        
        List<String> countryCodeList= new List<String>();
        for(Contact c : newContact)
        {
            countryCodeList.add(c.OtherCountryCode);
        }
        system.debug('countryCodeList**'+countryCodeList);
        if(!countryCodeList.isEmpty()){
            List<IB_Country_Segmentation__c> countrySegmenttaionList= [select id,ISO_Alpha_2_Code__c from IB_Country_Segmentation__c where 
                                                                       ISO_Alpha_2_Code__c in : countryCodeList];
            
            system.debug('countrySegmenttaionList**'+countrySegmenttaionList);       
            if(!countrySegmenttaionList.isEmpty()){
                Map<String, IB_Country_Segmentation__c> countryListMap= new  Map<String, IB_Country_Segmentation__c>();
                for(IB_Country_Segmentation__c ibCountry: countrySegmenttaionList)
                {
                    countryListMap.put(ibCountry.ISO_Alpha_2_Code__c,ibCountry );
                }
                for(Contact c : newContact)
                {
                    if(c.OtherCountryCode != null && oldMap.get(c.Id).OtherCountryCode!= c.OtherCountryCode)
                    {
                        c.Country__c= countryListMap.get(c.OtherCountryCode).id;
                        
                    }
                }
            }
            
        }
    }
    
    /*** Aded by Kashyap ***/
	public static void contact_all_1(List< Contact> NewContact ,List<Contact>  OldContact){
        
		system.debug('created from lead Running');
		//Boolean Valid_rule=false;           
		List<User> PardotUser = [SELECT ID, Name, Profile.Name from User where name = 'Automation Owner' LIMIT 1];
		system.debug('This is pardot user' +PardotUser.size() );
		if(!PardotUser.isEmpty() ){
			if(PardotUser[0].ID != userinfo.getUserId()){

				//DuplicateContactCheckUI

				List<ID> newContactIds = new List<ID>();
				List<String> firstNameStr = new List<String>();
				List<String> LastNameStr = new List<String>();
				List<String> CountryOfBirthStr = new List<String>();
				List<String> BirthLocaleStr = new List<String>();
				List<Date> BirthdateList = new List<Date>();    
				List<String> EmailStr = new List<String>();
				List<String> alternateEmailStr = new List<String>();
				//   The for Loop is getting the new values which is being entered.

				for(Integer index = 0, size = NewContact.size(); index < size; index++) {
					/* if(NewContact[index].Account__c=='Non-authenticated Users')
					{
					return;
					}*/
					if(NewContact[index].ID!=null){
						newContactIds.add(NewContact[index].ID);
						system.debug('id value' + newContactIds);
					}

					if( NewContact[index].FirstName !=null){
						firstNameStr.add( NewContact[index].FirstName.substring(0,1) + '%' );
					}

					if( NewContact[index].LastName !=null){
						LastNameStr.add( NewContact[index].LastName );
					}

					if( NewContact[index].Country_of_Birth__c !=null){
						CountryOfBirthStr.add( NewContact[index].Country_of_Birth__c  );
					}
					if(NewContact[index].Birth_Locale__c !=null){
						BirthLocaleStr.add( NewContact[index].Birth_Locale__c  );
					}

					if(NewContact[index].Birthdate !=null){  
						BirthdateList.add( NewContact[index].Birthdate );
					}
					if( NewContact[index].Email !=null){
						EmailStr.add( NewContact[index].Email );
					}
					if( NewContact[index].Alternative_Email__c !=null){
						alternateEmailStr.add( NewContact[index].Alternative_Email__c );
						System.debug('/////' + NewContact[index].Alternative_Email__c);
					}        
				}           
				system.debug('MC 1 ' + firstNamestr + '  ' + LastNameStr + '  ' + alternateEmailStr+ ' ' +  EmailStr+'  ' + BirthdateList  );

				List<contact>  dupCheck = new List<Contact>(); 
				dupCheck = [SELECT ID, FirstName from contact where   ( FirstName  like :FirstNameStr AND LastName = : LastNameStr) AND ( Email  = :EmailStr  OR Alternative_Email__c =:alternateEmailStr OR Email  = :alternateEmailStr OR Alternative_Email__c = :EmailStr )    AND ID NOT IN :newContactIds order by createdDate  asc ];        
				system.debug('This is first Condition' + dupCheck.size());
				if( dupCheck.isEmpty()  ){
					system.debug('The value of Birth Locale ' + BirthdateList==null + ' This is Boolean : ' + BirthLocaleStr.isEmpty());
					dupCheck = [SELECT ID, FirstName from contact where   ( Birthdate != NULL AND  Birthdate = :BirthdateList AND  Birth_Locale__c != NULL AND Birth_Locale__c = :BirthLocaleStr) AND (  ( Email  = :EmailStr  OR Alternative_Email__c =:alternateEmailStr OR Email  = :alternateEmailStr OR Alternative_Email__c = :EmailStr  ) AND Alternative_Email__c != NULL )  AND ID NOT IN :newContactIds order by createdDate  asc ];        
				}
				if( dupCheck.isEmpty()  ){    
					system.debug('The value of Birth Locale ' + BirthdateList==null + ' This is Boolean : ' + BirthLocaleStr.isEmpty());
					dupCheck = [SELECT ID, FirstName from contact where  ( ( FirstName  like :FirstNameStr AND LastName = : LastNameStr AND Birthdate != NULL AND Birthdate = :BirthdateList AND Birth_Locale__c!= null AND Birth_Locale__c  = :BirthLocaleStr) OR ( FirstName  like :FirstNameStr AND LastName = : LastNameStr AND Alternative_Email__c =:alternateEmailStr AND Alternative_Email__c  != NULL ) OR ( FirstName  like :FirstNameStr AND LastName = : LastNameStr AND Alternative_Email__c = :EmailStr AND Alternative_Email__c != NULL ) )  AND ID NOT IN :newContactIds order by createdDate  asc ];
					system.debug('Values are ::'+FirstNameStr+' :' +LastNameStr +' : '+ BirthdateList +' : '+ BirthLocaleStr);
				}

				system.debug('This is dupCheck Records  '+ dupCheck.size());
				if( !dupCheck.isEmpty() ){
					//System.debug('Java Log:---------------- Old List Size '+ OldContact.size() );
					//System.debug('Java Log:---------------- New List Size '+ NewContact.size() );
					for( integer index = 0; index < NewContact.Size(); index++){
						if(OldContact != NULL ){
							//System.debug('Java Log:---------------- Old '+ OldContact );
							//System.debug('Java Log:---------------- New '+ NewContact[index] );
							if( NewContact[index].FirstName != OldContact[index].FirstName
									|| NewContact[index].LastName  != OldContact[index].Lastname
									|| NewContact[index].Email     != OldContact[index].Email
									|| NewContact[index].Alternative_Email__c  != OldContact[index].Alternative_Email__c
									|| NewContact[index].Birthdate      != OldContact[index].Birthdate
									|| NewContact[index].Birth_Locale__c    != OldContact[index].Birth_Locale__c 
									|| NewContact[index].Country_of_Birth__c   != OldContact[index].Country_of_Birth__c){
								NewContact[index].addError('There is existing duplicate contact record found in the system.');    
								System.debug('Error There');
							}
						}
						else{
							// if(NewContact[0].Lead_Conversion__c == false ){
                            if(NewContact[index].recordtype.name == 'Standard Contact'){ // added if conditin by kashyap 
                                NewContact[index].addError('There is existing duplicate contact record found in the system.');
                                System.debug('Error There');
                            //}
							}
						}
					}         
				}
			}
		}
	}

	//This Method is commented because no functionality is implemented in IF Condition, CODE review Release2 WS3&4
	/**
	* This method contains the functionality of contact_all trigger
	* @param list of contact to be updated and list of oldcontact 
	* @return null

	*/
	/* public static void contact_all_2(List< Contact> Cntct  , user u )
	{
	for(Contact cont: cntct)
	{
	system.debug('These are birthdate Account'  + cont.Account__c + 'Created from lead' + cont.Lead_Conversion__c + 'Validation Rule' + u.Bypass_Validation_Rules__c );

	if( cont.Lead_Conversion__c!= true &&  cont.Account__c!='Non-authenticated Users'  && u.Bypass_Validation_Rules__c != true)
	{
	if(cont.Birthdate == null)
	{
	cont.addError('Please Enter Date of Birth',false);
	system.debug('Please Enter Bithdate first');
	}
	else
	{
	system.debug('Birthdate is not null');
	}

	// This DOB requirement has been commented per Tim - 10/4/2018    
	}

	}  
	}*/
	/**		
	* This Method is responsible for contact_all trigger functionality,US11103.
	* @author: Abd Ur Rehman-Plumlogix 
	* @since 28-1-2020
	* @param list of contact and a user.		
	* @return void.		
	*/
	public static void contact_all_3(List< Contact> NewContact ,Map<id,Contact>  OldContact , user u    ){
		system.debug('This is after');
		List<ID> updateTheContactIDs = new List<ID>();
		for(Contact cont: NewContact){
			if( OldContact.get(cont.id).Lead_Conversion__c==false && cont.Lead_Conversion__c == true ){
				updateTheContactIDs.add(cont.ID);
				//    Utils.updateContactCreatedFromLead(cont.ID);
			}
		}
		if( !updateTheContactIDs.IsEmpty() ){
			Utils.updateContactCreatedFromLead(updateTheContactIDs);
		}
		Boolean isSame = false;
		for(integer i=0; i<NewContact.size(); i++){
			/* if(NewContact[i].Account__c=='Non-authenticated Users')
			{
			return;
			}*/
			if( NewContact[i].firstName != OldContact.get(NewContact[i].id).FirstName || NewContact[i].lastName !=  OldContact.get(NewContact[i].id).lastName){
				isSame= true;
				system.debug('isSame True');
			}
		}
		system.debug('This is after update ');
		if(isSame){
			Map<id,Contact> map_var= new Map<id,Contact>();
			for(Contact cont: NewContact){
				map_var.put(cont.User__C,cont);
			}
			Set<id> accIds = map_var.keySet() ;
			if(accIds.size() > 0 ) {
				List <User> userToUpdate = new List<User>(); 
				userToUpdate= [ SELECT firstName, LastName,  ID from user where ID IN :accIds ];                
				for(Contact cont: NewContact) {
					for( User us : userToUpdate ){
						if( cont.User__c == us.ID ){
							if(us.firstName!=cont.firstName || us.lastName != cont.LastName){
								system.debug('running Fname');
								us.firstName = cont.firstName;
								us.lastName = cont.LastName;
							}
						}
					}
				}
				if(!userToUpdate.isEmpty()){  system.debug('running UserUpdatename');
					update userToUpdate;
				}
			}
		}
		system.debug('Trigger to update first Name of a user' + NewContact.size() );
	}

	/**
	* This method is written to check the possible duplicate checkbox field to false after the conditions are met,US11396
	* @params cntct This is the first paramaters that has Trigger.new list from contact_all trigger
	*/
	public static void updatePossibleDuplicateCheckField(List<Contact> cntct){
		//list<ID> recordsetId=new list<ID>();
		Map<ID, Contact> recordSetMap= new Map<ID, Contact>();
		for(Contact c: cntct){
			if(c.Duplicate_Record_Set_ID__c!=null || c.Duplicate_Record_Set_ID__c!=''){
				recordSetMap.put(c.Duplicate_Record_Set_ID__c,c);
			}
		}
		for(DuplicateRecordSet duprs: [select recordcount,id from DuplicateRecordSet where id IN:recordSetMap.keySet()]){
			if(duprs.RecordCount==1){
				recordSetMap.get(duprs.id).Possible_Duplicate__c=false;
			}
		}
	}
       /** 
	* @author Ammara Alvi
	* @date 05/10/2021
	* @description update Phone Field.
    * @returntype Void
	* @param List<Contact> contact_new,Map<id,Contact>  OldContact
	*/		
    public static void update_phone(List<Contact> contact_new,Map<id,Contact>  OldContact){
       Map<id,Contact> contact_map = new Map<id,Contact>();

        for(Contact cnt:contact_new){
            try{
            Contact cont = OldContact.get(cnt.id);


           

                String []str ;
				String []strFinal;
                String countCode;
                String FinalPh;
                String PhoneNumber='';
				String strPh;
				Boolean check;
                Integer len ;



            if(cnt.Country_Code__c != null && cnt.Phone_Number__c != null){
              str = cnt.Country_Code__c.split('\\(');
			  strFinal = str[1].split('\\)');
              countCode = strFinal[0];
              PhoneNumber='';
			  strPh = cnt.Phone_Number__c;
			  check=false;
              len = strPh.length();  
                FinalPh='+';

                if(cont != null && (cnt.Country_Code__c != cont.Country_Code__c || cnt.Phone_Number__c != cont.Phone_Number__c)){

                if(len<=15 && len>3  && strPh.isNumeric()){
				for(Integer x=1;x<countCode.length();x++){
					if((countCode.charAt(x)>=48 && countCode.charAt(x)<=57)){
						FinalPh=FinalPh+String.valueOf((countCode.charAt(x)-48));
					}
				}
				for(Integer x=0;x<strPh.length();x++){
					if((strPh.charAt(x)>=48 && strPh.charAt(x)<=57)){
						PhoneNumber = PhoneNumber+String.valueOf((strPh.charAt(x)-48));
                        check = false;
					}
				}
                FinalPh = FinalPh + PhoneNumber;
                if(cont.Phone != FinalPh)
                cnt.Phone = FinalPh;
            }
                else
                    cnt.addError(Label.Phone_Format_Error);
            }

            }

            else{

                if(cnt.Country_Code__c != null && cnt.Phone_Number__c == null)
                    cnt.addError('Please Enter Phone Number in the format [phone number(4-15 digits only)], with no spaces or hyphens.');
                else if(cnt.Country_Code__c == null && cnt.Phone_Number__c != null)
                    cnt.addError('Please Select Country Code.');
                else if(cnt.Country_Code__c == null && cnt.Phone_Number__c == null){

                    if(cont.Country_Code__c != null && cont.Phone_Number__c != null && cont.Phone != null)
                    cnt.Phone = null;
                }

            }
            }
            catch(Exception ex){
                System.debug('Error: '+ex);
            }
        }
            
    }
     /** 
	* @author Ammara Alvi
	* @date 05/10/2021
	* @description Add Phone value.
    * @returntype Void
	* @param List<Contact> contact_new,Map<id,Contact>  OldContact
	*/		
    
    public static void add_phone(List<Contact> contact_new,Map<id,Contact>  OldContact){
       Map<id,Contact> contact_map = new Map<id,Contact>();
        for(Contact cnt:contact_new){
             String []str ;
				String []strFinal;
                String countCode;
                String FinalPh;
                String PhoneNumber='';
				String strPh;
				Boolean check;
                Integer len ;


               

            if(cnt.Country_Code__c != null && cnt.Phone_Number__c != null){
               str = cnt.Country_Code__c.split('\\(');
			  strFinal = str[1].split('\\)');
              countCode = strFinal[0];
              PhoneNumber='';
			  strPh = cnt.Phone_Number__c;
			  check=false;
              len = strPh.length();  
                FinalPh='+';

            if(len<=15 && len>3  && strPh.isNumeric()){
				for(Integer x=1;x<countCode.length();x++){
					if((countCode.charAt(x)>=48 && countCode.charAt(x)<=57)){
						FinalPh=FinalPh+String.valueOf((countCode.charAt(x)-48));
					}
				}
				for(Integer x=0;x<strPh.length();x++){
					if((strPh.charAt(x)>=48 && strPh.charAt(x)<=57)){
						PhoneNumber = PhoneNumber+String.valueOf((strPh.charAt(x)-48));
                        check = false;
					}
				}
                FinalPh = FinalPh + PhoneNumber;
                cnt.Phone = FinalPh;
            }
                else
                    cnt.addError(Label.Phone_Format_Error);
            }
            else{

                if(cnt.Country_Code__c != null && cnt.Phone_Number__c == null)
                    cnt.addError('Please Enter Phone Number in the format [phone number(4-15 digits only)], with no spaces or hyphens.');
                else if(cnt.Country_Code__c == null && cnt.Phone_Number__c != null)
                    cnt.addError('Please Select Country Code.');
                else if(cnt.Country_Code__c == null && cnt.Phone_Number__c == null)
                    cnt.Phone = null;

            }
        }
    }
    
    public static void validatingIboEmail(List<Contact> nList, Map<Id,Contact> oMap){
        Id stdrecType = schema.sObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Standard_Contact').getRecordTypeId();
        Id invrecType = schema.sObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Invited_Contact').getRecordTypeId();
        for(Contact c:nList){
            
            if(((c.RecordTypeId == stdrecType) || (c.RecordTypeId == invrecType)) && 
               ((c.Email <> null && c.Email.contains('@ibo.org')) || 
                (c.Alternative_Email__c <> null && c.Alternative_Email__c.contains('@ibo.org')) || 
                (c.NoK_Email__c <> null && c.NoK_Email__c.contains('@ibo.org')) || 
                (c.Permission_Email__c <> null && c.Permission_Email__c.contains('@ibo.org'))
               )
               && (oMap==null || (oMap<>null && ( oMap.get(c.Id).Email!=c.Email || 
                                                 oMap.get(c.Id).Alternative_Email__c!=c.Alternative_Email__c || 
                                                 oMap.get(c.Id).NoK_Email__c!=c.NoK_Email__c || 
                                                 oMap.get(c.Id).Permission_Email__c!=c.Permission_Email__c)))) {
                                                     c.addError('Email, Alternate Email, Emergency Contact Email, HoS Email fields cannot contain @ibo.org for Standard and Invited Contacts');
                                                 }
        }                                              
    }
}