public class RecursiveTriggerHelper {
    
    @TestVisible private static Boolean alreadyModified = false;
    @TestVisible private static Boolean alreadyModifiedBefore = false;
    @TestVisible private static Boolean alreadyModifiedAfter = false;
    
    public static Boolean isAlreadyModified() {
        return alreadyModified;
    }
    
    public static void setAlreadyModified() {
        alreadyModified = true;
    }

    public static Boolean isAlreadyModifiedBefore() {
        return alreadyModifiedBefore;
    }
    
    public static void setAlreadyModifiedBefore() {
        alreadyModifiedBefore = true;
    }

    public static Boolean isAlreadyModifiedAfter() {
        return alreadyModifiedAfter;
    }
    
    public static void setAlreadyModifiedAfter() {
        alreadyModifiedAfter = true;
    } 

    public static void overRideAlreadyModified(){
        alreadyModified = false;
        alreadyModifiedBefore = false;
        alreadyModifiedAfter = false;        
    }  

}