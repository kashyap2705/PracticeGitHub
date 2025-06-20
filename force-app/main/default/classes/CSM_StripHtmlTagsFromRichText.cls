public class CSM_StripHtmlTagsFromRichText {
public class inputVarFromFlow {
    @InvocableVariable
    public String richText;
  }

  public class returnVarToFlow {
    @InvocableVariable
    public String plainText;
  }
  @InvocableMethod(label='Strip HTML Tags'description='Strip HTML Tags from the feed Post')
  public static List<returnVarToFlow> stripHtmlTagsFromPost(List<inputVarFromFlow> inputVarFromFlow) {
       List<returnVarToFlow> returnVarList = new List<returnVarToFlow>();
     
           String richTextList = inputVarFromFlow.get(0).richText;
    String plainText = richTextList.stripHtmlTags();

   
    returnVarToFlow returnVar = new returnVarToFlow();
    returnVar.plainText = plainText;
    returnVarList.add(returnVar);

    return returnVarList;

  } 
}