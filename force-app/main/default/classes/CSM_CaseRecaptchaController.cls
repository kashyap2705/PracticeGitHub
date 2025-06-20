public with sharing class CSM_CaseRecaptchaController {
  public static Boolean isException = false;
  private static Decimal ReCAPTHASCORE = 0.5;
  private static String SUCCESSMSG = 'Success';
  private static String FAILUREMSG = 'Failure';

  /*
    *********************************************************
    @Method Name    : isReCAPTCHAValid
    @description    : method is used to check the validity of ReCAPTHA on Contact Form
    @param          : String
    @return         : Boolean
    ********************************************************
*/
  @AuraEnabled
  public static String isReCAPTCHAValid(String tokenFromClient) {
    String captchaMsg;
    Boolean success;
    String endpoint = 'https://www.google.com/recaptcha/api/siteverify';
    String requestMethod = 'POST';
    try {
      Community_Setting__mdt communitySetting = Community_Setting__mdt.getInstance(
        'IB_Answer_Recaptcha'
      );
      String recaptcha_secret = communitySetting.Captcha_Private_Key__c;
      Http h = new Http();
      HttpRequest req = new HttpRequest();
      String body =
        'secret=' +
        recaptcha_secret +
        '&response=' +
        tokenFromClient;
      req.setEndpoint(endpoint);
      req.setMethod(requestMethod);
      req.setBody(body);
      if (!Test.isRunningTest()) {
        HttpResponse resp = h.send(req);
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(
          resp.getBody()
        );
        success = (Boolean) jsonMap.get('success');
        if (success) {
          Decimal score = (Decimal) jsonMap.get('score');
          captchaMsg = score > ReCAPTHASCORE ? SUCCESSMSG : FAILUREMSG;
        } else {
          captchaMsg = FAILUREMSG;
        }
      } else {
        captchaMsg = SUCCESSMSG;
      }
      if (isException) {
        throw new CalloutException('Something went wrong');
      }
      return captchaMsg;
    } catch (Exception exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new AuraHandledException(exp.getMessage());
    }
  }
}