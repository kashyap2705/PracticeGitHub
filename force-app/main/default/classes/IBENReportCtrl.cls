public class IBENReportCtrl {
public String fileId{get;set;}
    public static Blob bodyBlob {get;set;}
public Attachment file{get;set;}
    public Attachment file2{get;set;}
public String paramvalue{get;set;}
    public string filetype{get; set;}
    public string filename{get; set;}
public IBENReportCtrl()
{
fileId = ApexPages.currentPage().getParameters().get('file');
system.debug('attachment file id '+fileId);
file=[select ID,Body,Name,ContentType from Attachment where Id =:fileId];
bodyBlob = file.Body;
paramvalue = EncodingUtil.base64Encode(bodyBlob);// body=file.Body.tostring();
     String nameField = file.Name;
    if(nameField.Contains('.'))
    	filetype = nameField.substringAfter('.');
    filename = file.Name;
system.debug('File Type '+filetype);
}
}