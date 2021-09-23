public with sharing class RelatedListController {
    
    public RelatedListController()
    {
        
    }
    
    @AuraEnabled(cacheable=true)
    public static Result fetchHistoryTrackingData(Id recordId, String objName, Boolean viewAllPage, Boolean viewAllLink, Boolean viewAllClassic, Integer limitSize, Integer offset)
    {
        Integer noOfRecords;
        String query;
        Integer totalNumberOfRecords = [SELECT count() from e_eat__Audit_Tracking_History__c where e_eat__Related_Record_ID__c =: recordId];

        List<e_eat__Audit_Tracking_History__c> enhancedAuditTrackingList = new List<e_eat__Audit_Tracking_History__c>();
        List<e_eat__Audit_Tracking_History__c> enhancedAuditList = new List<e_eat__Audit_Tracking_History__c>();
        
        if(viewAllClassic) {
            limitSize = 20;
        }
        
        if(Schema.SObjectType.e_eat__Audit_Tracking_History__c.isAccessible()
           && Schema.SObjectType.e_eat__Audit_Tracking_History__c.fields.e_eat__New_Value__c.isAccessible()
           && Schema.SObjectType.e_eat__Audit_Tracking_History__c.fields.e_eat__Original_Value__c.isAccessible()  
           && Schema.SObjectType.e_eat__Audit_Tracking_History__c.fields.e_eat__Related_Record_ID__c.isAccessible()
          ) {
              query = 'select id,Name,e_eat__New_Value__c,e_eat__Original_Value__c,e_eat__Audit_Tracking_Field__r.Name,e_eat__Audit_Tracking_Field__r.e_eat__Field_API_Name__c,';
              query += 'CreatedBy.Name,LastModifiedBy.Name,createddate,e_eat__Related_Record_ID__c from e_eat__Audit_Tracking_History__c where e_eat__Related_Record_ID__c = \''+ recordId +'\' order by createddate DESC LIMIT :limitSize OFFSET :offset';
          }
        else {
            throw new SecurityException('You don\'t have access to the fields/records. Please contact System Administrator');
        }
        enhancedAuditTrackingList = Database.query(query);
        if(viewAllClassic){
            viewAllPage=true;
        }
        if(enhancedAuditTrackingList.size() > 0)
        {
            if(viewAllPage == true)
            {
                enhancedAuditList = enhancedAuditTrackingList; 
            }
            else
            {
                Integer count = 0;
                for(Integer i=0;i<enhancedAuditTrackingList.size();i++)
                {
                    if(count <= 9)
                    {
                        enhancedAuditList.add(enhancedAuditTrackingList[i]);
                    }
                    count++;
                }
            }
        }
        
        Result res = new Result();
        res.auditTrackingList = enhancedAuditList;
        res.totalNumberOfRecords = totalNumberOfRecords;
        
        if(viewAllClassic){
            res.viewAllC=true;
        }
        return res;
    }
    
    @AuraEnabled(cacheable=true)
    public static String getIconName(String sObjectName) {
        String u;
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();
                
        for(Schema.DescribeTabSetResult tsr : tabSetDesc) { tabDesc.addAll(tsr.getTabs()); }
        for(Schema.DescribeTabResult tr : tabDesc) {
            String objName = tr.getSobjectName();
            if( sObjectName == tr.getSobjectName() ) {
                if( tr.isCustom() == true ) {
                    iconDesc.addAll(tr.getIcons());
                } else {
                    u = 'standard:' + sObjectName.toLowerCase();
                }
            } else if( sObjectName.contains(objName) ) {
                if( tr.isCustom() == true ) {
                    iconDesc.addAll(tr.getIcons());
                } else {
                    u = 'standard:' + objName.toLowerCase();
                }
           	}
        }
        for (Schema.DescribeIconResult ir : iconDesc) {
            if (ir.getContentType() == 'image/svg+xml'){
                u = 'custom:' + ir.getUrl().substringBetween('custom/','.svg').substringBefore('_');
                break;
            }
        }
        if(String.isBlank(u)) {
            u = 'standard:record';
        }
        return u;
    }
    
    public class Result{
        
        @AuraEnabled public List<e_eat__Audit_Tracking_History__c> auditTrackingList;
        @AuraEnabled public Boolean viewAllC;
        @AuraEnabled public Integer totalNumberOfRecords;
        
        public Result()
        {
            viewAllC = false;
            auditTrackingList = new List<e_eat__Audit_Tracking_History__c>();
            totalNumberOfRecords = 0;
        }
    }
}