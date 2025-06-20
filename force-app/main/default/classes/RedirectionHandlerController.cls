public with sharing abstract class RedirectionHandlerController {
    
    public final Static String INTERNAL_COMMUNITY = 'Internal';
    
    public PageReference redirectTo() {
    	
    	
    	PageReference ref = new PageReference(getUrl());
    	ref.getParameters().putAll(ApexPages.currentPage().getParameters());
   	    ref.setRedirect(true);
   	    return ref;
   	   
    }
    
    protected abstract String getUrl(); 
    
}