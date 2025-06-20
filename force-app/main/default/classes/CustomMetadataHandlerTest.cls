/*******************************************************************************************
* @Name     CustomMetadataDAOTest
* @Author   Ranjith Kondabathini    
* @Date     05/16/2023    
* @Group        
* @Description  Unit test for CustomMetadataDAO
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Ranjith Kondabathini      05/16/2023         Unit test for CustomMetadataDAO
*******************************************************************************************/
@isTest public class CustomMetadataHandlerTest {
    @isTest static void testGetMetadata() {
        list<SObject> mtadataRecords;
        Test.startTest();
        mtadataRecords = new CustomMetadataHandler().getCustomMetadataRecords('global');
        Test.stopTest();
        
        If(!mtadataRecords.isEmpty()) { 
            system.assertEquals(1, mtadataRecords.size(), 'no metadata found');
        }
    }
    /*
     * @description: this method to set metadata value for testing
     * @returns: SObject
     */ 
    public static void setMetadata(String query, list<SObject> records) {
        CustomMetadataHandler.metadataRecMap.put(query, records);
    }
    

}