public class CanvasLifeCycle implements Canvas.CanvasLifecycleHandler {
    
    public Set<Canvas.ContextTypeEnum> excludeContextTypes(){
        Set<Canvas.ContextTypeEnum> excluded = new Set<Canvas.ContextTypeEnum>();
        excluded.add(Canvas.ContextTypeEnum.ORGANIZATION);
      //  excluded.add(Canvas.ContextTypeEnum.USER);
        excluded.add(Canvas.ContextTypeEnum.RECORD_DETAIL);
        return excluded;
    }
    
    
    public void onRender(Canvas.RenderContext renderContext) {
        // Get the Application and Environment context from the RenderContext
        Canvas.ApplicationContext app = renderContext.getApplicationContext();
        Canvas.EnvironmentContext env = renderContext.getEnvironmentContext();
 
        /*Double currentVersion = Double.valueOf(app.getVersion());
        if (currentVersion <= 5){
            throw new Canvas.CanvasRenderException('Error: Versions earlier than 5 are no longer supported.');
        }
        app.setCanvasUrlPath('/alternatePath');*/
        env.addEntityFields(new Set<String>{'Person_Code__c','Name','Email','Phone','LanguageLocaleKey','Global_IBEN_ID__c'});
        //'Name','BillingAddress','YearStarted'});
        System.debug('xxCanvasLifeCycle debug start');
        System.debug(env.getEntityFields());
        System.debug(env.getLocationUrl());
        System.debug(env.getDisplayLocation());
        System.debug(env.getSublocation());
        System.debug(env.getParametersAsJSON());
        
        Map<String, Object> previousParams = (Map<String, Object>) JSON.deserializeUntyped(env.getParametersAsJSON());
        //previousParams.put('newCustomParam',newValueenv.setParametersAsJSON(JSON.serialize(previousParams)));
        env.setParametersAsJSON(JSON.serialize(previousParams));
    }
}