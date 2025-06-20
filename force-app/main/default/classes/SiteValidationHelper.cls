public without sharing class SiteValidationHelper {
//This part is Updated by Ahmad Shakeel-plumlogix on 02-11-2020 , US-11100
//Begin
public static MatchResultDescription findMatches (List<Contact> cont) {
 //End
    for(Integer x=0;x<cont.size();x++)
        {
        //This part is Updated by Ahmad Shakeel-plumlogix on 02-11-2020 , US-11100
            //Begin
            return  new MatchResultDescription(cont , getAccountsBy(cont[0].firstName, cont[0].lastName, cont[0].Email, cont[0].Alternative_Email__c, cont[0].Phone, cont[0].OtherPhone, cont[0].MobilePhone));
        
        }
    return Null;
    //End
    }
    
    public static List<Contact> getAccountsBy (String firstName, String lastName, String email, String workEmail, String homePhone, String workPhone, String mobilePhone ) {
        if (String.isBlank(firstName)) {
            throw new IllegalArgumentException(Label.IBENPortal_Error_FirstName);
        }
        
        if (String.isBlank(lastName)) {
            throw new IllegalArgumentException(Label.IBENPortal_Error_LastName);
        }
        
        if (String.isBlank(email)) {
            throw new IllegalArgumentException(Label.IBENPortal_Error_Email);
        }
        
        /*if (String.isBlank(homePhone)) {
            throw new IllegalArgumentException(Label.IBENPortal_Error_HomePhone);
        }*/
        
        String whereParams = ' Unique_Email_del__c = \'' + String.escapeSingleQuotes(email) + '\'' + ' AND LastName = \''+ String.escapeSingleQuotes(lastName) + '\'';
        whereParams += ' order by Email LIMIT 2' ;
        system.debug('Contact ******'+ whereParams);
        
        return MyContactDAO.INSTANCE.getContactbyWere(whereParams) ;
        
        
    }
    
    public enum FIELDSSET { EMAIL, PROFESSIONAL_EMAIL, FIRSTNAME, LASTNAME, PHONE, OTHERPHONE,  MOBILEPHONE, DATE_OF_BIRTH }
    
    public class MatchResultDescription {
        
       private List <ContactMatchResult> matchesResults  = new List <ContactMatchResult> ();
        
       public Integer getMatchedContactCountByAllFiels() {
           return matchesResults.size();
       }
       
       public ContactMatchResult getMostMatchedContact() {
            
            ContactMatchResult res = null; 
            
            if (!matchesResults.isEmpty()) {
                res = matchesResults.get(0);
            }
            
            return res;
       }
       
       public ContactMatchResult getLessMatchedContact() {
            
            ContactMatchResult res = null; 
            
            if (!matchesResults.isEmpty()) {
                res = matchesResults.get(matchesResults.size()-1);
            }
            return res;
       }
       
       public Integer getMatchedContactCountByField (FIELDSSET field) {
           Integer  countMatchedField = 0;
           
           for (ContactMatchResult res  : matchesResults) {
             if (res.isFieldMatched(field)) {
                countMatchedField = countMatchedField + 1;
             }
            
           }
           
           return countMatchedField;
           
       } 
        
         //This part is Updated by Ahmad Shakeel-plumlogix on 02-11-2020 , US-11100
        //Begin
       public MatchResultDescription (List<Contact> template , List<Contact> result) {
            
           System.debug('Resullttss'+result);
            for (Contact cont : result ) {
                ContactMatchResult matchRes = new ContactMatchResult();
                
                if (String.isNotBlank(template[0].Email) && template[0].Email.equals(cont.Email)) {
                    matchRes.addField(FIELDSSET.EMAIL);
                } else if (String.isNotBlank(template[0].Email) && template[0].Email.equals(cont.Alternative_Email__c)) {
                    matchRes.addField(FIELDSSET.EMAIL);
                }
                
                if (String.isNotBlank(template[0].Alternative_Email__c) && template[0].Alternative_Email__c.equals(cont.Alternative_Email__c)) {
                    matchRes.addField(FIELDSSET.PROFESSIONAL_EMAIL);
                } else if (String.isNotBlank(template[0].Alternative_Email__c) && template[0].Alternative_Email__c.equals(cont.Email)) {
                    matchRes.addField(FIELDSSET.PROFESSIONAL_EMAIL);
                }
                
                if (String.isNotBlank(template[0].FirstName) && template[0].FirstName.equals(cont.FirstName)) {
                    matchRes.addField(FIELDSSET.FIRSTNAME);
                }
                if (String.isNotBlank(template[0].LastName) && template[0].LastName.equals(cont.LastName)) {
                    matchRes.addField(FIELDSSET.LASTNAME);
                }
                
                if (String.isNotBlank(template[0].homePhone) && template[0].FirstName.equals(cont.HomePhone)) {
                    matchRes.addField(FIELDSSET.PHONE);
                }
                if (String.isNotBlank(template[0].OtherPhone) && template[0].OtherPhone.equals(cont.OtherPhone)) {
                    matchRes.addField(FIELDSSET.OTHERPHONE);
                }
                if (String.isNotBlank(template[0].MobilePhone) && template[0].MobilePhone.equals(cont.MobilePhone)) {
                    matchRes.addField(FIELDSSET.MOBILEPHONE);
                }
                //End
                if (matchRes.getMatchedFieldsCount() > 0) {
                    matchRes.contactId = cont.Id;
                    matchesResults.add(matchRes);
                }
            }
            
            if (!matchesResults.isEmpty()) {
                matchesResults.sort();
            }
            
        }
            
    }
   
    public class ContactMatchResult implements Comparable {
        
        private Set<FIELDSSET> presentFields = new Set<FIELDSSET>(); 
        
        public String contactId { set; get; }
        
        public void addField (FIELDSSET field) {
            presentFields.add(field);
            
        }
        public boolean isFieldMatched(FIELDSSET field) {
            return presentFields.contains(field); 
        }
        public Integer getMatchedFieldsCount() {
            return presentFields.size(); 
        }
        
        public Integer compareTo(Object compareTo) {
            if(compareTo == null ) return 1;
            
            ContactMatchResult compare = (ContactMatchResult) compareTo; 
            
            if (this.getMatchedFieldsCount() > compare.getMatchedFieldsCount()) return 1;
            if (this.getMatchedFieldsCount() < compare.getMatchedFieldsCount()) return -1;
            
            return 0;
        }
        
    }
    
}