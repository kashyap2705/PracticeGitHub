/**
 * @description This is used as an utility class for test classes
 * @author      Gautam Manchanda
 * @since       14-10-2024
 */
@isTest
public class TestDataUtility {
    /**
     * @description This method generates random String values for test classes
     * @param len   length of random string  
     * @return      `String`
     */
    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }
    /**
     * @description This method generates random integer values for test classes
     * @param len   length of random integer  
     * @return      `Integer`
     */
    public static Integer generateRandomInteger(Integer len)
    {
        final String chars = '1234567890';
        String randStr = '';

        while (randStr.length() < len) 
        {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }

        return Integer.valueOf(randStr);
    }
    /**
     * @description This method generates random decimal values for test classes
     * @param len   length of random decimal 
     * @return      `Decimal`
     */
    public static Decimal generateRandomDecimal(Integer len)
    {
        return Decimal.valueOf(generateRandomInteger(len));
    }
    /**
     * @description   This method generates randomemail for test classes     
     * @param prefixLength length of string before domain name
     * @param domain   domain name for test email    
     * @return             `String`
     */
    public static String generateRandomEmail(Integer prefixLength, String domain)
    {
        if(domain == null)
        {
            domain = 'gmail.com';
        }

        if(prefixLength == null)
        {
            prefixLength = 15;
        }

        return generateRandomString(prefixLength) + '@' + domain;
    }
    
    /**
    * @description Helper method to return default value if original is null or blank
    * @param originalValue - stores original value
    * @param defaultValue - stores default value
    * @return string
    */
    public static String getValueOrDefault(String originalValue, String defaultValue) {
    	return String.isBlank(originalValue) ? defaultValue : originalValue;
	}
    
    /**
    * @description - Helper method to return default value if the original Boolean is null
    * @param originalValue - the original Boolean value
    * @param defaultValue - the default Boolean value to use if originalValue is null
    * @return Boolean - returns originalValue if not null; otherwise, returns defaultValue
    */
    public static Boolean getValueOrDefault(Boolean originalValue, Boolean defaultValue) {
        return originalValue == null ? defaultValue : originalValue;
    }
    
    /**
    * @description Helper method to return default value if the original Date is null
    * @param originalValue - the original Date value
    * @param defaultValue - the default Date value to use if originalValue is null
    * @return Date - returns originalValue if not null; otherwise, returns defaultValue
    */
    public static Date getValueOrDefault(Date originalValue, Date defaultValue) {
        return originalValue == null ? defaultValue : originalValue;
    }
}