/**
 * Handles data extraction for LWC custom lookup component
 * 
 * Note: Without Sharing is used to exposure records like Accounts, IB workshop Products to community user
 *       Once Community sharing is fixed it can be changed to inherited Sharing/With Sharing
 **/ 
public without sharing class CustomLookupController {

    public static String sObjectToSearch ;
    public static Integer searchLimit = 50;
    public static String searchFields;
    public static String whereFields;
    public static String hiddenFields ;
    public static String queryFilter;
    public static String sortOrder ;
    public static String customSearchClass;
    public static Boolean includeSObject;
    public static Integer offSet;

    //-This method retrieves the data from database table. It search input is '*', then retrieve all records
    @AuraEnabled (cacheable=true)
    public static List<SObjectQueryResult> retrieveRecords(String objectName, 
                                                    String fieldAPINames,
                                                    String filterFieldAPIName,
                                                    String strInput,
                                                    String titleField,
                                                    String subTitleFields,
                                                    String conditionExpression){                                               
        sObjectToSearch = objectName;
        searchFields = fieldAPINames; // Fields to Query
        whereFields = filterFieldAPIName;// Fields to filter
        queryFilter = conditionExpression; // filter condition

        List<SObjectQueryResult> lstReturnResult = new List<SObjectQueryResult>();
        if(strInput.equals('*')){
            strInput = '';
        }
        String str = strInput + '%';
        String strQueryField = '';
        List<String> fieldList = new List<String>();
        List<String> subTitleFieldList = new List<String>();
        if(fieldAPINames != '' && fieldAPINames != null){
            fieldList = fieldAPINames.split(',');
        }
        
        if(subTitleFields != '' && subTitleFields != null){
            subTitleFieldList = subTitleFields.split(',');
        }
         
        //check if Id is already been passed
        if(!fieldList.contains('Id')){
            fieldList.add('Id');
            strQueryField = String.join(fieldList, ',');
        }else {
            strQueryField = fieldAPINames;
        }

        String strQuery = createSearchQuery(strInput);

        List<SObject> lstResult = database.query(strQuery);
        //create list of records that can be easily be parsable at js controller.
            for(SObject sobj:lstResult){                
                    SObjectQueryResult result = new SObjectQueryResult();
                    result.recordId = (String) sobj.get('Id');
                    result.recordName = (String) sobj.get(titleField);
                   string subTitleText = '';
                   string concSubTitle = '';
                   for(String subField:subTitleFieldList){
                    
                       subTitleText = (String) sobj.get(subField);
                       if(subTitleText != '' && subTitleText != NULL){
                            concSubTitle = concSubTitle + ' '+ subTitleText;
                       } 
                   }

                    result.recordSubtitle = concSubTitle;
                    lstReturnResult.add(result);              
            }
        return lstReturnResult;
    }
    
    //-Wrapper to return specific details
    public class SObjectQueryResult {
        @AuraEnabled
        public String recordId;

        @AuraEnabled
        public String recordName;

        @AuraEnabled
        public String recordSubtitle;        
    }
	
    //-Build Where clause
    private static string getWhereClause(String searchTerm){
        set<string> wheres = new set<string>();
        if(whereFields != null){
            wheres = getStringTokens(whereFields);
        }
        wheres.add('Name');

        list<string> fields = new list<string>(wheres);
        list<string> whereClause = new list<string>();
        if(fields != null && !fields.isEmpty()){
            for(string s : fields){
                whereClause.add(' ' +  s + ' LIKE \'%' + string.escapeSingleQuotes(searchTerm) + '%\'');
            }
        }
        string whereString = '(' + string.join(whereClause,' OR ') + ')';
        if(String.isNotBlank(queryFilter)){
            whereString += ' AND ' + queryFilter;
        }
        return whereString;
    }
    
	//-Build Query
    private static string createSearchQuery(String searchTerm) {
        
        String sQuery =  'SELECT ' + buildFieldList();
        sQuery += ' FROM ' + sObjectToSearch;
        
        sQuery += ' WHERE ' + getWhereClause(searchTerm);
        
        if(String.isNotBlank(sortOrder)){
        	sQuery += ' ORDER BY ' + sortOrder;
        }
        else {
        	sQuery += ' ORDER BY createdDate DESC';
        }
        
        if(searchLimit != null){
        	sQuery += ' LIMIT ' + searchLimit;
        }
        
        if(offSet != null){
            sQuery += ' OFFSET ' + offSet;
        }
        return sQuery;
    }
    
	//-Build field list obtained from component(LWC)
    private static string buildFieldList(){
        Set<String> fieldsSet = getStringTokens(searchFields);
        fieldsSet.add('Id');
        fieldsSet.add('Name');
        List<String> fields = new List<String>(fieldsSet);        
        return String.join(fields,',');
    }
	
    //-Prepare String Tokens
    private static Set<String> getStringTokens(String value) {
        Set<String> returnValues = new Set<String>();

        if(!string.isBlank(value)) {
            List<String> values = value.split(',');
            for(String s :values) {
                returnValues.add(s.trim());
            }
        }
        return returnValues;
    }
}