/**
* @description -This is used to Test the instance of List of IB_Country_Segmentation__c
* 
* Ticket: 
*
* @author: Vikash Kumar
* @since 16-10-2024
* @Modification Log:
* Date            Created/Modified    Ticket           Description    
* 16-10-2024      Created            US-0002499       Created the classe
*/
@isTest
public without sharing class IBCountrySegmentationTestDataFactory { 
    private final static String COUNTRY = 'Australia';
    private final static String GEOGRAPHICAL_SUBREGION = 'Asia';
    private final static String IBEN_SEGMENTATION = 'IBA';
    private final static String REGIONAL_OFFICE_SEGMENTATION = 'IBA';
    /**
     * @description - Creates a list of IB_Address__c records                 
     * @param tempCountrySegmentation - template IB_Country_Segmentation__c record to clone (can be null)
     * @param nCountrySegmentations  - number of records to create
     * @return `List<IB_Country_Segmentation__c>`
     */
    public static List<IB_Country_Segmentation__c> createIBCountrySegmentations(IB_Country_Segmentation__c tempCountrySegmentation, Integer nCountrySegmentations){
        List<IB_Country_Segmentation__c> ibCountrySegmentations = new List<IB_Country_Segmentation__c>();
        for (Integer i = 0; i < nCountrySegmentations; i++) {
            IB_Country_Segmentation__c ibCountrySegmentation;
            if(tempCountrySegmentation != null){
                ibCountrySegmentation = tempCountrySegmentation.clone(false);
            }else{
                ibCountrySegmentation = new IB_Country_Segmentation__c();
            }
            
            ibCountrySegmentation = createIBCountrySegmentationInstance(ibCountrySegmentation);
            ibCountrySegmentations.add(ibCountrySegmentation);
        }
        return ibCountrySegmentations;
    }
    /**
     * @description -   Creates a IB_Country_Segmentation__c records                 
     * @param tempCountrySegmentation - template IB_Country_Segmentation__c record to clone (can be null)
     * @return  `IB_Country_Segmentation__c`
     */
    public static IB_Country_Segmentation__c createIBCountrySegmentation(IB_Country_Segmentation__c tempCountrySegmentation){

        IB_Country_Segmentation__c ibCountrySegmentation;
        if(tempCountrySegmentation != null){
            ibCountrySegmentation = tempCountrySegmentation.clone(false);
        }else{
            ibCountrySegmentation = new IB_Country_Segmentation__c();
        }
        
        ibCountrySegmentation = createIBCountrySegmentationInstance(ibCountrySegmentation);
        return ibCountrySegmentation;
    }
    
    /**
     * @description  - Populates fields of IB_Country_Segmentation__c instance                        
     * @param ibCountrySegmentationRecord - the record to populate fields
     * @return `IB_Country_Segmentation__c`
     */
    public static IB_Country_Segmentation__c createIBCountrySegmentationInstance(IB_Country_Segmentation__c ibCountrySegmentationRecord){
        IB_Country_Segmentation__c ibCountrySegmentationInstance = ibCountrySegmentationRecord;            
        ibCountrySegmentationInstance.Country_es__c = String.isBlank(ibCountrySegmentationRecord.Country_es__c) ? COUNTRY: ibCountrySegmentationRecord.Country_es__c;
        ibCountrySegmentationInstance.Geographical_Sub_Region_Segmentation__c = String.isBlank(ibCountrySegmentationRecord.Geographical_Sub_Region_Segmentation__c) ? GEOGRAPHICAL_SUBREGION : ibCountrySegmentationRecord.Geographical_Sub_Region_Segmentation__c;
        ibCountrySegmentationInstance.IBEN_Segmentation__c = String.isBlank(ibCountrySegmentationRecord.IBEN_Segmentation__c) ? IBEN_SEGMENTATION : ibCountrySegmentationRecord.IBEN_Segmentation__c;
        ibCountrySegmentationInstance.Regional_Office_Segmentation__c = String.isBlank(ibCountrySegmentationRecord.Regional_Office_Segmentation__c) ? REGIONAL_OFFICE_SEGMENTATION : ibCountrySegmentationRecord.Regional_Office_Segmentation__c;
        return ibCountrySegmentationInstance;
    }
    
}