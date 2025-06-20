public with sharing class DocumentDAO {
  public static final DocumentDAO INSTANCE = new DocumentDAO();
       
  public DocumentDAO(){
    
  }
  
  public String getDocumentPathByName(final String name){
    if ( String.isBlank(name)) {
        throw new DAOException('The ID cannot be zero or an empty string.');
    } 
  
    String imageURL= Site.getPathPrefix() + '/servlet/servlet.FileDownload?file=';
    List< document > documentList=[select name from document where 
                                    Name=:name];
   
    if(documentList.size()>0){
      return imageURL+documentList[0].id;
    }
    else{
      return null;
    }
  }
}