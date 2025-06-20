public class LocaleSwitcherExtension {
	
	public LocaleSwitcherExtension() {
		
        Cookie locale = ApexPages.currentPage().getCookies().get('locale');
        if (locale == null && getVFPageName() != 'IBPortalLogin') {
        	
            locale = new Cookie('locale','en_US',null,-1,false);
        	ApexPages.currentPage().setCookies(new Cookie[]{locale});
            
        } 
        else if (locale == null && ApexPages.currentPage().getParameters().get('lang') != null) {

            // make sure the value of lang is one of our allowed locales
            if (LOCALE_SET.contains(ApexPages.currentPage().getParameters().get('lang'))) {

                locale = new Cookie('locale', ApexPages.currentPage().getParameters().get('lang'),null,-1,false);
                ApexPages.currentPage().setCookies(new Cookie[]{locale});
                
            }

        }
        else if (ApexPages.currentPage().getParameters().get('lang') != null && (String.valueOf(locale.getValue()) != ApexPages.currentPage().getParameters().get('lang'))) {
			
			// make sure the value of lang is one of our allowed locales
			if (LOCALE_SET.contains(ApexPages.currentPage().getParameters().get('lang'))) {

	            locale = new Cookie('locale', ApexPages.currentPage().getParameters().get('lang'),null,-1,false);
	        	ApexPages.currentPage().setCookies(new Cookie[]{locale});
	        	
			} 
            
        }
        
    } 

    public String getLocale() {
    	
        Cookie locale = ApexPages.currentPage().getCookies().get('locale');
        if (locale == null) {
            return 'en_US';
        } else if (!LOCALE_SET.contains(String.valueOf(locale.getValue()))) {
        	locale = new Cookie('locale','en_US',null,-1,false);
        	ApexPages.currentPage().setCookies(new Cookie[]{locale});
        }
        
        return locale.getValue();
        
    }
    
    private static final Set<String> LOCALE_SET = new Set<String> {
    	'en_US',
    	'fr',
    	'es'
    };

    private string getVFPageName()  {

        String pageName = ApexPages.CurrentPage().getUrl();
        if(pageName == null){
        	return '';
        }
        pageName = pageName.replaceFirst('/apex/','');         
        pageName = EncodingUtil.urlEncode(pageName, 'UTF-8');
        
        String[] pageNameExtra = pageName.split('%3F',0);
        pageName = pageNameExtra[0]; 

        return pageName;

    }
	
}