({
    handleChanged: function (component, message, helper) {
        var deflectionEntityId = message._params.deflectionEntityId; 
        var deflectionAnswer = message._params.deflectionAnswer;        
        component.set("v.deflectionEntityId", deflectionEntityId);
        component.set("v.deflectionAnswer",deflectionAnswer);              
        helper.fireCaseDeflectionSignal(component);
    }   
})