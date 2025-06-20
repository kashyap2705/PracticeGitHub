/**
* @author Hari Krishnan
* @date 07/16/2013
* @description This class has helper methods.
*/

public with sharing class UtilityClass {
	
	/**
	* @author Hari Krishnan
	* @date 07/16/2013
	* @description Gets the type name of the SObject.
	* @param SObject The SObject for which the name to be obtained.
	* @return String - The type name.
	*/
	public static String getSObjectTypeName(SObject so) {
		return so.getSObjectType().getDescribe().getName();
	}
	
	/**
	* @author Arunkumar Kathiravan
	* @date 11/18/2018
	* @description Creates an SOQL query with all fields.
	* @param objectName - The Object name for which the query has to be generated.
	* @param whereClause - where conditions for the query
	* @return String - SOQL query.
	*/
    // Returns a dynamic SOQL statement for the whole object, includes all fields
    public static string getFieldsSOQL(String objectName){
         
        String selects = '';
         
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
         
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                selectFields.add(fd.getName());
            }
        }
         
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){
            	selects = selects.substring(0,selects.lastIndexOf(','));
            }
        }
         
        //return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
        return selects;
    }
    
	/**
	* @author Arunkumar Kathiravan
	* @date 11/18/2018
	* @description Creates an SOQL query with all creatable fields.
	* @param objectName - The Object name for which the query has to be generated.
	* @param whereClause - where conditions for the query
	* @return String - SOQL query.
	*/
    // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
    public static string getCreatableFieldsSOQL(String objectName){
         
        String selects = '';
         
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
         
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
         
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){
            	selects = selects.substring(0,selects.lastIndexOf(','));
            }
        }
         
        //return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
        system.debug('Select'+selects);
        return selects;
    }
}