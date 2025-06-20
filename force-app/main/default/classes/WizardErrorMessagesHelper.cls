public with sharing class WizardErrorMessagesHelper {
	public enum ERROR_TYPE {TYPE_1,TYPE_2,TYPE_3,TYPE_4,TYPE_5 }
	
	public static String getErrorMessageBy(ERROR_TYPE typeError, Contact contactInfo, SiteValidationHelper.MatchResultDescription matchesResult ) {
        try
        {
		
		String result = contactInfo.Salutation +' '+ contactInfo.FirstName +' '+ contactInfo.LastName + ' tried to get access to the IB Educator Community. The corresponding contact information related to this person is:'+
		        +'Email: '+ contactInfo.Email;
		
		if (String.isNotBlank(contactInfo.Alternative_Email__c)) {
		 	result += ' Alternative Email: ' + contactInfo.Alternative_Email__c;
		}
			 
		result += ' Home Phone:'+ contactInfo.Phone +' Work Phone:' + contactInfo.OtherPhone;
			 
		if (String.isNotBlank(contactInfo.MobilePhone)) {
			 	result += ' Mobile Phone: ' + contactInfo.MobilePhone;
		}
		
		result +=  '. The error type the person received was: ';
		
		if (typeError == ERROR_TYPE.TYPE_1) {
		    result +=  Label.Error_Type_1;
		}
		
		if (typeError == ERROR_TYPE.TYPE_2) {
			result +=  Label.Error_Type_2 ;
		}
		
		if (typeError == ERROR_TYPE.TYPE_3) {
			 result +=  Label.Error_Type_3 ;
		}
		
		if (typeError == ERROR_TYPE.TYPE_4) {
			result +=  Label.Error_Type_4;
		}
		
		if (typeError == ERROR_TYPE.TYPE_5) {
			result +=  Label.Error_Type_5;
		}
		
		return	result += '. We found the following matched contact' + ( matchesResult.getMatchedContactCountByAllFiels() > 1 ? ' id\'s ' : ' id ') + ' related to this person:  '
		    + (matchesResult.getMatchedContactCountByAllFiels() > 1 ? matchesResult.getMostMatchedContact().contactId +' , '+matchesResult.getLessMatchedContact().contactId : matchesResult.getMostMatchedContact().contactId) +'.';
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
        
	}

}