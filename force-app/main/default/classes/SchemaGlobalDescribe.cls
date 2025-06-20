public class SchemaGlobalDescribe{
    public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
        String objectName = '';
        try{
            //Get prefix from record ID
            //This assumes that you have passed at least 3 characters
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
             
            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
             
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){
                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                 
                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return objectName;
    }

    public static String findRecordIdPrefixFromObjectName(String objectName){

    	String prefix = '';
    	Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();

    	try{
	    	for(Schema.SObjectType stype : gd.values()){
	    		Schema.DescribeSObjectResult r = stype.getDescribe();
	    		String oName = r.getName();

	    		if(oName != null && oName.equals(objectName)){
	    			prefix = r.getKeyPrefix();
	    			break;
	    		}


	    	}
	    } catch(Exception e){
	    	System.debug(e);
	    }

    	return prefix;

    }
}