/**
* <h1>To reduce the recurssion of methods</h1>
* This class is to prevent recurssion processing of records 
* 
* @author  Tiyyab Ahmed PLX
* @version 1.0
* @since   2019-09-30 

Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 

  
*/

public class TriggerContextUtility {
       /**
   * This method is used to check if the method ran for first time or it already ran. 
   * @param None
   * @return firstRun boolean.
   */
   public static boolean firstRun = true;
   public static boolean secondRun=false;
    public static boolean isFirstRun() {
        return firstRun;
    }
    public static void setFirstRunFalse(){
        firstRun = false;
    
    }
    public static void IsFirstRunTrue(){
        firstRun = true;
    
    }
    public static void setFirstRunTrue()
    {
        secondRun=true;
    }
     public static void setFirstRunFalseTest()
    {
        secondRun=false;
    }
    
}