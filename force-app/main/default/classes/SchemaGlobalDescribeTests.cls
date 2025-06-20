@isTest
private class SchemaGlobalDescribeTests{
    @istest
    private static void testMethodPositive(){
        String objectName = SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix('500');
        String prefix = SchemaGlobalDescribe.findRecordIdPrefixFromObjectName('Case');
        System.assertEquals(objectName,'Case');
    }
    @isTest
    private static void testMethodNegative(){
        String objectName = SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix('500');
        System.assertNotEquals(objectName,'Account');
    }
    @isTest
    private static void testMethodNull(){
        String objectName = SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix('101');
        System.assertEquals(objectName,'');
    }
    @isTest
    private static void testMethodException(){
        String objectName = SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix('10');
        String prefix = SchemaGlobalDescribe.findRecordIdPrefixFromObjectName('');
        System.assertEquals(objectName,'');
    }
}