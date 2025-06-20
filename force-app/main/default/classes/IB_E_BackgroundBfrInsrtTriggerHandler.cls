/**		
	* <h1>IB_E_BackgroundBfrInsrtTriggerHandler</h1>		
	* This class is responsible managing before insert trigger functionality on IB_E_Background__c object as part of trigger consolidation,US11101.
	* 
	* @author  Abd Ur Rehman		
	* @version 1.0		
	* @since   28-1-2020
	
Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 

*/
public class IB_E_BackgroundBfrInsrtTriggerHandler extends TriggerHandlerBase{
     public override void mainEntry(TriggerParameters tp){  
         //if(TriggerContextUtility.isFirstRun()){
         //TriggerContextUtility.setFirstRunFalse();
         ValidateDataForIBEBackground((list<IB_E_Background__c>)tp.newList);   
         //}
             
     }
    private static void ValidateDataForIBEBackground(list<IB_E_Background__c> usr)
    {
        
        //final Set <String> validProfiles = new Set <String> { '00eg0000000QNHfAAO' , '00eg0000000QNHeAAO' };
        final Set<String> validProfiles = new Set <String>();
        final List<Profile> listProfiles = [SELECT Id, Name FROM Profile WHERE Name IN ('SCU + Basic','SCU + Advanced','Customer Community Basic','Customer Community Advanced')];

        for (Profile p : listProfiles) {
            validProfiles.add(p.Id);
        }
       
        if (validProfiles.contains(Userinfo.getProfileId())) {

            final String contactId =  UserDAO.INSTANCE.getUserById(Userinfo.getUserId()).ContactId;

            for (IB_E_Background__c back : usr) {
                back.IB_Contact__c = contactId;
            }

        }
       
    }
}