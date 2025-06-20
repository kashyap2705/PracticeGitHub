public with sharing class MyRoleRedirectionController extends RedirectionHandlerController {
    
    public final Static String ACTION_CREATE      = 'Create';
    public final Static String ACTION_EDIT        = 'Edit';
    
    private final Map <String, MyRoleRedirectionRules__c> rules = MyRoleRedirectionRules__c.getAll();
    
    private IB_Role__c role = null;
    
    public MyRoleRedirectionController (ApexPages.StandardController stdController) {
       
       sObject obj = stdController.getRecord();
       
       if (null == obj || String.isEmpty(obj.id)) {
           return;          
       }
       
       this.role = (IB_Role__c) obj;
       
       //check if this edit page
       if (null != this.role && null != this.role.id) {
           this.role = IBRoleDAO.INSTANCE.getRoleById(this.role.id);
             
       }
    }
    
    public MyRoleRedirectionController () {
        super();
    }
    
    @TestVisible
    protected override String getUrl() {

        String defaultUrl = '';
        
        if (null == this.role) {
            return getCreateUrl();
            
        } else{
            return getEditUrl();
        }
        
    }
    
    private String getEditUrl() {
        final String communityName = String.isEmpty(System.Site.getName())? INTERNAL_COMMUNITY : System.Site.getName() ;
        system.debug(logginglevel.ERROR, 'communityName :: ' + communityName);
        system.debug(logginglevel.ERROR, 'ACTION_EDIT + \'_\'+ this.role.Status__c + \'_\' + communityName).url__c :: ' + ACTION_EDIT + '_'+ this.role.Status__c + '_' + communityName);
        return rules.get(ACTION_EDIT + '_'+ this.role.Status__c + '_' + communityName).url__c;
        
    } 
    
    private String getCreateUrl() {

        String defaultUrl = '';
        
        final String communityName = String.isEmpty(System.Site.getName())? INTERNAL_COMMUNITY : System.Site.getName() ;
        
        final Set <String> profiles = new Set <String> ();
        
        system.debug(logginglevel.ERROR, 'communityName :: ' + communityName);
        system.debug(logginglevel.ERROR, 'ACTION_CREATE + \'_\' + communityName :: ' + ACTION_CREATE + '_' + communityName);
        
        final MyRoleRedirectionRules__c rule = rules.get(ACTION_CREATE + '_' + communityName); 
                                                                               
        for (String id : rule.ids__c.split(',', -2) ) {
            profiles.add(id);
            
        }
        
        //below lines are added by developer Abd Ur Rehman as part of L&T project on 28/10/2020
        //star 
        if(communityName == 'Internal')
        {
        for (String id : rule.additional_ids__c.split(',', -2) ) {
            profiles.add(id);
        }   
        }
        //end

        if (profiles.contains((Userinfo.getProfileId()).substring(0,15) ) ) {
             defaultUrl = rule.url__c; 
        }
        system.debug(logginglevel.ERROR, 'defaultUrl :: ' + defaultUrl);
        
        return defaultUrl;
        
    } 
}