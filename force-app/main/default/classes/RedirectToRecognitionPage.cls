/** 
Author:- Kashyap
Added on:- 14-12-2022
Description :- For ticket ECM00565 This Class is used for redirection to URL specified in custom label 
for Recognititon Tile ***/

public class RedirectToRecognitionPage
{
    public PageReference redirectToRecognitionURL() {
        String locale = UserInfo.getLocale();
        String userLocaleRedirect;
        String url;
        if(locale=='fr')
        {
            userLocaleRedirect='fr-FR/?as=sf';
        }else if(locale=='es')
        {
            userLocaleRedirect='es-ES/?as=sf';
        }else
        {
            userLocaleRedirect='en-US/?as=sf';
        }
        url = System.Label.RecognitionRedirectionBaseURL+userLocaleRedirect;
        PageReference page = new PageReference(url);
        page.setRedirect(true);
        return page;
        
    }
 }