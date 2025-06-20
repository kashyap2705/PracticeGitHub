/**		
	* <h1>LeadTriggerHelper</h1>		
	* This class is responsible managing  functionality on lead object as part of trigger consolidation,US11226.
	* contains the functionality which can be called in multiple classe like before and after update etc.
	* @author  Abd Ur Rehman		
	* @version 1.0		
	* @since   28-1-2020
	
Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 


*/
public class LeadTriggerHelper {
      /**		
	   * This Method is responsible for duplicatelead trigger execution ,US11226.
	   * @author: Abd Ur Rehman-Plumlogix 
       * @since 28-1-2020
	   * @param list of  lead.		
	   * @return void.		
	  */
    public static void DupLead(list<Lead> newlist)
    {
    List<String> firstNameStr = new List<String>();
    List<String> LastNameStr = new List<String>();
    List<String> EmailStr = new List<String>();
    list<ID> leadIds= new list<ID>();
    list<Boolean> le_ads= new list<Boolean>();
    list<String> OthEmailStr= new list<String>();
    
    List<contact>  dupCheck = new List<Contact>();
    List<Lead>  dupCheck_lead = new List<Lead>();
 
// The for Loop is getting the new values which is being entered.
string uid = userinfo.getUserId();
system.debug('ID of a user who invokes the Trigger' + uid);

User PardotUser = [SELECT ID, Name, Profile.Name from User where name = 'Automation Owner' LIMIT 1];

if(PardotUser?.ID == userinfo.getUserId() )   //added safe navigation operator BenMC INC0183664
return;
//Profile p = [SELECT ID,Name from profile where userName = ''];

User u = [SELECT ID, Name, Profile.Name from User where ID = :userinfo.getUserId() LIMIT 1];

/*if(u.Profile.Name == 'Customer Community Basic' || u.Profile.Name == 'Customer Community Login User'  || u.Profile.Name == 'Customer Community Advanced'  
|| u.Profile.Name == 'Customer Community Advanced OLD'  || u.Profile.Name == 'Customer Community Basic OLD'  || u.Profile.Name == 'Educator Customer Portal AP'  || u.Profile.Name == 'Educator Customer Portal User'  || u.Profile.Name == 'Deactivated Users - Level 1' 
|| u.Profile.Name == 'Overage High Volume Customer Portal User'  || u.Profile.Name == 'Partner Community Login User'  || u.Profile.Name == 'Partner Community User'  || u.Profile.Name == 'SCU + Advanced'  || u.Profile.Name == 'SCU + Advanced' 
|| u.Profile.Name == 'SCU + Advanced'  || u.Profile.Name == 'SCU + Advanced'  || u.Profile.Name == 'SCU + Basic'  || u.Profile.Name == 'SCU + Basic'   )
return;
*/
system.debug('ID of a User' + userinfo.getUserId());
 
  for(Integer index = 0, size = newlist.size(); index < size; index++)
  {
  
        firstNameStr.add( newlist[index].FirstName?.substring(0,1) + '%' );   //added safe navigation operator BenMC INC0183664     
        LastNameStr.add( newlist[index].LastName );                
        EmailStr.add( newlist[index].Email );
        OthEmailStr.add(newlist[index].Professional_Email__c);
        leadIds.add(newlist[index].ID);
        le_ads.add(newlist[index].IsConverted);
  }    
   
   for(Boolean chk:le_ads)
   {
     if( !chk )
    {
//MC#1    
     dupCheck_lead = [SELECT ID, FirstName from Lead where  ( ( FirstName  like :FirstNameStr AND LastName = : LastNameStr ) AND ID !=:leadIds ) order by createdDate  asc ];    
     system.debug('This is dupCheck_lead Records  '+ dupCheck_lead);
//MC#2
     dupCheck_lead = [SELECT ID, FirstName from Lead where  ( ( FirstName  like :FirstNameStr AND LastName = : LastNameStr ) AND  Professional_Email__c = :OthEmailStr AND ID !=:leadIds ) order by createdDate  asc ];    
     system.debug('This is dupCheck_lead Records  '+ dupCheck_lead);
//MC#3    
     dupCheck_lead = [SELECT ID, FirstName from Lead where  ( ( FirstName  like :FirstNameStr AND LastName = : LastNameStr ) AND  (   Email = :OthEmailStr OR Professional_Email__c = :EmailStr ) AND ID !=:leadIds ) order by createdDate  asc ];    
     system.debug('This is dupCheck_lead Records  '+ dupCheck_lead);
         
     dupCheck = [SELECT ID, FirstName from contact where  ( ( FirstName  like :FirstNameStr AND LastName = : LastNameStr ) AND  (   Email = :EmailStr  OR Alternative_Email__c = :EmailStr ) AND ID !=:leadIds ) order by createdDate  asc ];    
     system.debug('This is dupCheck Records  '+ dupCheck);
     
     if( !dupCheck.isEmpty() && !dupCheck_lead.isEmpty() )
     {
         newlist[0].addError(Label.IBEN_Duplicate_Contact,False);    
        // newlist[0].addError('This is preveting to cinvert the lead' + dupCheck);    
     }
    }
   }
    }

    // Below Method is added by Suraj As a part of ECM00511
    // This is for before Insert Context
    public static void setIberoAmericaLead(list<Lead> newlist){
        ID schoolRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('School Lead').getRecordTypeId();
        ID grpOfSchoolRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Group of Schools Lead').getRecordTypeId();
        for(Lead iberoAmeraLead: newlist){
            if((schoolRecordTypeId != null && iberoAmeraLead.RecordTypeId == schoolRecordTypeId )  || (grpOfSchoolRecordTypeId!= null && iberoAmeraLead.RecordTypeId == grpOfSchoolRecordTypeId)){
                //IberoAmerica_Countries_Lead__mdt added by Shahrukh to resolve INC0218574
                if(iberoAmeraLead.AE_Country__c !=null && 
                   IberoAmerica_Countries_Lead__mdt.getInstance(iberoAmeraLead.AE_Country__c) != null){
                       iberoAmeraLead.IberoAmerica__c=true;
                   }else{
                       iberoAmeraLead.IberoAmerica__c=false;
                   }
            }
        }        
    }
    
    // Below Method is added by Suraj As a part of ECM00511
    // This is for before Update Context
    public static void updateIberoAmericaLead(Map<ID,Lead> oldMap,list<Lead> newlist){
        ID schoolRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('School Lead').getRecordTypeId();
        ID grpOfSchoolRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Group of Schools Lead').getRecordTypeId();
        for(Lead iberoAmeraLead: newlist){
            if((schoolRecordTypeId != null && iberoAmeraLead.RecordTypeId == schoolRecordTypeId )  || (grpOfSchoolRecordTypeId!= null && iberoAmeraLead.RecordTypeId == grpOfSchoolRecordTypeId)){
               // if(iberoAmeraLead.Country__c !=oldMap.get(iberoAmeraLead.Id).Country__c){
               // //IberoAmerica_Countries_Lead__mdt added by Shahrukh to resolve INC0218574
                    if(iberoAmeraLead.AE_Country__c != null && 
                       IberoAmerica_Countries_Lead__mdt.getInstance(iberoAmeraLead.AE_Country__c) != null){
                           iberoAmeraLead.IberoAmerica__c=true;
                       }else{
                           iberoAmeraLead.IberoAmerica__c=false;
                       }
               // }
            }
        }
        }
        
}