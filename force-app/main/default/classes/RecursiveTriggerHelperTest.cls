@isTest
private class RecursiveTriggerHelperTest {
    
    @isTest
    static void RecursiveTriggerHelperTestMethod()
    {
        RecursiveTriggerHelper.alreadyModified=false;
        RecursiveTriggerHelper.alreadyModifiedBefore = false;
        RecursiveTriggerHelper.alreadyModifiedAfter = false;
        RecursiveTriggerHelper.isAlreadyModified();
        RecursiveTriggerHelper.setAlreadyModified();
        RecursiveTriggerHelper.isAlreadyModifiedBefore();
        RecursiveTriggerHelper.setAlreadyModifiedBefore();
        RecursiveTriggerHelper.isAlreadyModifiedAfter();
        RecursiveTriggerHelper.setAlreadyModifiedAfter();
        RecursiveTriggerHelper.overRideAlreadyModified();
    }

}