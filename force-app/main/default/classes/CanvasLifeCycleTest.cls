@isTest
global class CanvasLifeCycleTest {
    
    Public static testMethod void testExcludeTypes(){
        CanvasLifeCycle handler = new CanvasLifeCycle ();
        Set<Canvas.ContextTypeEnum> excluded = handler.excludeContextTypes();
        System.assertEquals(2,excluded.size());
        System.assert(excluded.contains(Canvas.ContextTypeEnum.ORGANIZATION),true);
        System.assert(excluded.contains(Canvas.ContextTypeEnum.RECORD_DETAIL),true); 
    }

    Public static testMethod void testCanvasUrl(){
        Map<String,String> appvalues = new Map<String, String>();
        Appvalues.put(Canvas.Test.KEY_CANVAS_URL, 'http://some.iben.com/foo?shouldExistinTest=true');
        CanvasLifeCycle handler = new CanvasLifeCycle();
        Canvas.RenderContext mock = Canvas.Test.mockRenderContext(appValues,null);
        Canvas.Test.testCanvasLifecycle(handler,mock);
        system.assertEquals(mock.getApplicationContext().getCanvasUrl(), 'http://some.iben.com/foo?shouldExistinTest=true');
    }
    
    
}