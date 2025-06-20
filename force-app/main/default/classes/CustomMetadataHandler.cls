/*******************************************************************************************
* @Name     CustomMetadataDAO 
* @Author   Ranjith Kondabathini    
* @Date     05/16/2023    
* @Group        
* @Description  This class to query custom metadata records
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Ranjith Kondabathini      05/16/2023         This class to query custom metadata records
*******************************************************************************************/

public without sharing class CustomMetadataHandler {
    /*
     * @description: varible to add SObject
     */ 
    @testVisible static private Map<String,List<SObject>> metadataRecMap = new Map<String, List<SObject>>();
    
    /*
     *@Description: This method is used in other class to get field value from custom metada records 
     * @returns: list of Sobjects
     */ 
    public List<SObject> getCustomMetadataRecords(String recordName) {
        list<Sobject> listMetadata;
        if(!metadataRecMap.containsKey(recordName)) {
            listMetadata = [Select Enable_Log_Events_from_Level__c,Enable_Log_Save_from_Level__c FROM LoggerSetting__mdt Where DeveloperName= :recordName];
            metadataRecMap.put(recordName, listMetadata);
            
        }
        return metadataRecMap.get(recordName);
        
    }   

}